#!/usr/bin/env node
// Builds knowledge/composition/index.json from the notes' YAML frontmatter and checks the vault:
// missing required fields, duplicate ids/file names and wikilinks that point nowhere.
// Usage: node scripts/build-knowledge-index.mjs [--check]   (--check: report only, exit 1 on errors)

import { readdirSync, readFileSync, writeFileSync, statSync } from "node:fs";
import { join, relative, basename, extname } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(fileURLToPath(new URL(".", import.meta.url)), "..", "knowledge", "composition");
const checkOnly = process.argv.includes("--check");
const REQUIRED = ["id", "title", "domain", "use_when", "summary"];
// Folders whose files are not topic notes: specs, raw digests, indexes.
const SKIP_DIRS = new Set(["digests"]);

function walk(dir, out = []) {
  for (const name of readdirSync(dir)) {
    const full = join(dir, name);
    if (statSync(full).isDirectory()) {
      if (!SKIP_DIRS.has(name)) walk(full, out);
    } else if (extname(name) === ".md") {
      out.push(full);
    }
  }
  return out;
}

// Minimal YAML subset: `key: value`, `key: [a, b]` and `key:` followed by `- item` lines.
function parseFrontmatter(text) {
  const match = text.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) return null;
  const data = {};
  let listKey = null;
  for (const line of match[1].split(/\r?\n/)) {
    const item = line.match(/^\s+-\s+(.*)$/);
    if (item && listKey) {
      data[listKey].push(unquote(item[1]));
      continue;
    }
    const kv = line.match(/^([A-Za-z_][\w-]*):\s*(.*)$/);
    if (!kv) continue;
    const [, key, raw] = kv;
    const value = raw.replace(/\s+#.*$/, "").trim();
    if (value === "") {
      data[key] = [];
      listKey = key;
    } else if (value.startsWith("[") && value.endsWith("]")) {
      data[key] = splitList(value.slice(1, -1));
      listKey = null;
    } else {
      data[key] = unquote(value);
      listKey = null;
    }
  }
  return data;
}

function splitList(body) {
  const items = [];
  let current = "";
  let quote = null;
  let depth = 0;
  for (const ch of body) {
    if (quote) {
      if (ch === quote) quote = null;
      current += ch;
    } else if (ch === '"' || ch === "'") {
      quote = ch;
      current += ch;
    } else if (ch === "[") {
      depth += 1;
      current += ch;
    } else if (ch === "]") {
      depth -= 1;
      current += ch;
    } else if (ch === "," && depth === 0) {
      items.push(current);
      current = "";
    } else {
      current += ch;
    }
  }
  if (current.trim()) items.push(current);
  return items.map((s) => unquote(s.trim())).filter(Boolean);
}

function unquote(value) {
  return value.replace(/^(['"])(.*)\1$/, "$2");
}

const files = walk(root);
const names = new Map();
for (const file of files) {
  const name = basename(file, ".md");
  names.set(name, [...(names.get(name) ?? []), file]);
}

const errors = [];
const warnings = [];
const notes = [];
const ids = new Map();

for (const file of files) {
  const rel = relative(root, file).replaceAll("\\", "/");
  const name = basename(file, ".md");
  const text = readFileSync(file, "utf8");
  const body = text.replace(/^---[\s\S]*?\n---/, "");
  // Links shown as examples inside code are not real links.
  const prose = body.replace(/```[\s\S]*?```/g, "").replace(/`[^`\n]*`/g, "");
  const fm = parseFrontmatter(text) ?? {};
  // Topic notes live in domain folders; root files (START-HERE, glossary), maps of content, specs and
  // source cards are navigation, not topics.
  const isTopic = rel.includes("/") && !name.startsWith("_") && !rel.startsWith("_meta/") && !rel.startsWith("sources/");

  for (const [, target] of prose.matchAll(/\[\[([^\]|#]+)(?:[#|][^\]]*)?\]\]/g)) {
    if (!names.has(basename(target.trim()))) warnings.push(`${rel}: broken link [[${target}]]`);
  }
  for (const link of [].concat(fm.related ?? [])) {
    const target = link.replace(/^\[\[|\]\]$/g, "").split("|")[0].trim();
    if (target && !names.has(target)) warnings.push(`${rel}: broken related link ${link}`);
  }
  if (!isTopic) continue;

  for (const key of REQUIRED) {
    if (!fm[key] || (Array.isArray(fm[key]) && fm[key].length === 0)) errors.push(`${rel}: missing '${key}'`);
  }
  if (fm.id) {
    if (ids.has(fm.id)) errors.push(`${rel}: duplicate id '${fm.id}' (also ${ids.get(fm.id)})`);
    ids.set(fm.id, rel);
  }
  const words = body.split(/\s+/).filter(Boolean).length;
  if (words > 1400) warnings.push(`${rel}: ${words} words, consider splitting`);

  notes.push({
    id: fm.id ?? null,
    path: rel,
    link: `[[${name}]]`,
    title: fm.title ?? name,
    domain: fm.domain ?? null,
    style_scope: fm.style_scope ?? null,
    tags: [].concat(fm.tags ?? []),
    aliases: [].concat(fm.aliases ?? []),
    use_when: fm.use_when ?? null,
    summary: fm.summary ?? null,
    sources: [].concat(fm.sources ?? []),
    related: [].concat(fm.related ?? []).map((l) => l.replace(/^\[\[|\]\]$/g, "")),
    words,
  });
}

for (const [name, paths] of names) {
  if (paths.length > 1) errors.push(`duplicate file name '${name}': ${paths.map((p) => relative(root, p)).join(", ")}`);
}

notes.sort((a, b) => a.path.localeCompare(b.path));
if (!checkOnly) {
  const index = { generated: new Date().toISOString(), root: "knowledge/composition", count: notes.length, notes };
  writeFileSync(join(root, "index.json"), JSON.stringify(index, null, 2) + "\n");
}

for (const w of warnings) console.warn(`warn: ${w}`);
for (const e of errors) console.error(`error: ${e}`);
console.log(`${notes.length} notes, ${errors.length} errors, ${warnings.length} warnings${checkOnly ? "" : " -> index.json"}`);
process.exitCode = errors.length ? 1 : 0;
