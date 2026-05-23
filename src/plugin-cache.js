import fs from "node:fs";
import path from "node:path";
import { DEFAULT_ALIASES } from "./constants.js";
import { readJson, writeJsonAtomic } from "./fs-utils.js";
import { pluginCachePath, reaperResourcePath } from "./paths.js";

function parsePluginLine(line) {
  const eq = line.indexOf("=");
  if (eq === -1) return null;

  const left = line.slice(0, eq);
  const right = line.slice(eq + 1);
  const name = right.slice(right.lastIndexOf(",") + 1).replace(/!!!VSTi$/, "").trim();
  if (!name || name === "<SHELL>") return null;

  const type = left.toLowerCase().includes(".vst3") ? "VST3" : "VST";
  const shell = left.split("<")[0] || null;

  return {
    name,
    type,
    shell,
    fxName: `${type}:${name}`
  };
}

export function scanReaperPluginCache(resourcePath = reaperResourcePath()) {
  const cacheFile = path.join(resourcePath, "reaper-vstplugins64.ini");
  if (!fs.existsSync(cacheFile)) return [];

  const seen = new Set();
  const entries = [];
  for (const rawLine of fs.readFileSync(cacheFile, "utf8").split(/\r?\n/)) {
    const parsed = parsePluginLine(rawLine.trim());
    if (!parsed) continue;

    const key = `${parsed.type}:${parsed.name}`.toLowerCase();
    if (seen.has(key)) continue;
    seen.add(key);
    entries.push(parsed);
  }

  return entries.sort((a, b) => a.name.localeCompare(b.name));
}

function scorePlugin(entry, query, prefer = "vst3-stereo") {
  const q = query.toLowerCase();
  const name = entry.name.toLowerCase();
  let score = 0;

  if (name === q) score += 1000;
  else if (name.startsWith(q)) score += 600;
  else if (name.includes(q)) score += 350;
  else return -1;

  if (prefer.startsWith("vst3") && entry.type === "VST3") score += 120;
  if (prefer.includes("stereo") && name.includes("stereo") && !name.includes("mono/stereo")) score += 80;
  if (prefer.includes("mono-stereo") && name.includes("mono/stereo")) score += 80;
  if (name.includes("surround") || name.includes("5.1") || name.includes("7.1")) score -= 60;

  return score;
}

export function resolvePlugin(query, { aliases = DEFAULT_ALIASES, entries = [] } = {}) {
  const key = String(query).trim().toLowerCase();
  const alias = aliases[key];
  const search = alias?.query || query;
  const prefer = alias?.prefer || "vst3-stereo";

  let best = null;
  let bestScore = -1;
  for (const entry of entries) {
    const score = scorePlugin(entry, search, prefer);
    if (score > bestScore) {
      best = entry;
      bestScore = score;
    }
  }

  if (best) {
    return {
      query,
      name: best.name,
      type: best.type,
      fxName: best.fxName,
      source: "reaper-cache"
    };
  }

  if (alias?.fallbackFxName) {
    return {
      query,
      name: alias.fallbackName,
      type: alias.fallbackFxName.split(":")[0],
      fxName: alias.fallbackFxName,
      source: "fallback-alias"
    };
  }

  return {
    query,
    name: query,
    type: null,
    fxName: query,
    source: "literal"
  };
}

export function writePluginCache(root, resourcePath = reaperResourcePath()) {
  const entries = scanReaperPluginCache(resourcePath);
  writeJsonAtomic(pluginCachePath(root), {
    scannedAt: new Date().toISOString(),
    resourcePath,
    entries
  });
  return entries;
}

export function loadPluginEntries(root) {
  return readJson(pluginCachePath(root), { entries: [] }).entries || [];
}
