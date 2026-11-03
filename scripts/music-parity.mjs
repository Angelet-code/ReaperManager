#!/usr/bin/env node
// Parity check: La Forja del Alba through the music engine against its own generator.
// Copies the generator (read only) twice into --work: "ref" runs as is, "engine" gets core/orch/expr
// replaced by adapters onto src/music (sections s1–s5, bal.mjs and main.mjs untouched). Both write into --work,
// never into the La Forja folder. Then compares every replace_midi command note by note and CC by CC.
// Usage: node scripts/music-parity.mjs --forja "<La Forja>/generator" --work <scratch dir> [--soplo] [--env K=V ...]
import { cpSync, mkdirSync, readFileSync, writeFileSync, readdirSync, rmSync, existsSync } from "node:fs";
import { join, resolve } from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath, pathToFileURL } from "node:url";

const HERE = fileURLToPath(new URL(".", import.meta.url));
const ENGINE = pathToFileURL(resolve(HERE, "..", "src", "music", "index.js")).href;
const args = process.argv.slice(2);
const arg = (k) => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : undefined; };
const forja = arg("--forja"), work = arg("--work");
if (!forja || !work) { console.error("usage: --forja <generator dir> --work <dir> [--soplo] [--env K=V]"); process.exit(2); }
// never write into the piece's project folder (the generator's parent, where the .rpp lives)
const project = resolve(forja, "..");
const inside = (p, dir) => (p + "\\").toLowerCase().startsWith((dir + "\\").toLowerCase()) || (p + "/").toLowerCase().startsWith((dir + "/").toLowerCase());
if (inside(resolve(work), resolve(forja)) || (readdirSync(project).some((f) => f.endsWith(".rpp")) && inside(resolve(work), project))) {
  console.error("--work must be outside the piece's project folder"); process.exit(2);
}
const env = { ...process.env };
for (let i = 0; i < args.length; i++) if (args[i] === "--env") { const [k, v] = args[i + 1].split("="); env[k] = v; }
if (args.includes("--soplo")) env.SOPLO = "1";

function prepare(kind) {
  const dir = join(work, kind, "generator");
  rmSync(join(work, kind), { recursive: true, force: true });
  mkdirSync(dir, { recursive: true });
  cpSync(forja, dir, { recursive: true, filter: (s) => !/\.(py|wav)$/i.test(s) });
  if (kind === "engine") {
    for (const f of ["core.mjs", "orch.mjs", "expr.mjs", "forja-tracks.mjs"]) {
      writeFileSync(join(dir, f), readFileSync(join(HERE, "music-parity", f), "utf8").replaceAll("__ENGINE__", ENGINE));
    }
    rmSync(join(dir, "soplo.mjs"), { force: true });
    // performance options from the same environment flags the original reads
    const opts = {
      swamBreath: env.SOPLO === "1" ? { end: env.SOPLO_END || "B", amount: Number(env.SOPLO_AMOUNT || 1), ceil: 127,
        ...Object.fromEntries(["shape", "noise", "ride"].map((k) => [k, (env.SOPLO_CAPAS || "shape,noise,ride").split(",").includes(k)])) } : false,
      feel: env.EXPR_ALB_T === "2" ? { sampled: "on-beat" } : {}
    };
    writeFileSync(join(dir, "run.mjs"), `globalThis.__FORJA_OPTIONS = ${JSON.stringify(opts)};\nawait import("./main.mjs");\n`);
  } else writeFileSync(join(dir, "run.mjs"), `await import("./main.mjs");\n`);
  return dir;
}

function run(kind) {
  const dir = prepare(kind), out = join(work, kind, "out");
  const r = spawnSync(process.execPath, ["run.mjs"], { cwd: dir, env: { ...env, FORJA_OUT: out }, encoding: "utf8" });
  writeFileSync(join(work, kind, "log.txt"), r.stdout + r.stderr);
  if (r.status !== 0 && !existsSync(join(out, "midi.json"))) { console.error(`${kind} failed:\n${r.stderr || r.stdout}`); process.exit(1); }
  return out;
}

const refOut = run("ref"), engOut = run("engine");
const a = JSON.parse(readFileSync(join(refOut, "midi.json"), "utf8")), b = JSON.parse(readFileSync(join(engOut, "midi.json"), "utf8"));
const report = [];
let same = 0, diff = 0;
const key = (x) => JSON.stringify(x);
for (const t of new Set([...Object.keys(a), ...Object.keys(b)])) {
  const A = a[t] || [], B = b[t] || [];
  const na = A.flatMap((i) => i.notes.map((n) => ({ bar: i.bar, ...n }))), nb = B.flatMap((i) => i.notes.map((n) => ({ bar: i.bar, ...n })));
  const ca = A.flatMap((i) => i.cc.map((c) => ({ bar: i.bar, ...c }))), cb = B.flatMap((i) => i.cc.map((c) => ({ bar: i.bar, ...c })));
  const items = key(A.map((i) => [i.bar, i.bars, i.name])) === key(B.map((i) => [i.bar, i.bars, i.name]));
  let nd = 0, cd = 0;
  const ex = [];
  for (let k = 0; k < Math.max(na.length, nb.length); k++) if (key(na[k]) !== key(nb[k])) { nd++; if (ex.length < 3) ex.push(`note ${k}: ${key(na[k])} ≠ ${key(nb[k])}`); }
  for (let k = 0; k < Math.max(ca.length, cb.length); k++) if (key(ca[k]) !== key(cb[k])) { cd++; if (ex.length < 6) ex.push(`cc ${k}: ${key(ca[k])} ≠ ${key(cb[k])}`); }
  if (!nd && !cd && items) same++; else { diff++; report.push(`${t}: notes ${na.length}/${nb.length} (${nd} differ), cc ${ca.length}/${cb.length} (${cd} differ)${items ? "" : ", items differ"}\n    ${ex.join("\n    ")}`); }
}
const build = readFileSync(join(refOut, "build.json"), "utf8") === readFileSync(join(engOut, "build.json"), "utf8");
const cmds = readdirSync(join(refOut, "cmd")).filter((f) => readFileSync(join(refOut, "cmd", f), "utf8") !== readFileSync(join(engOut, "cmd", f), "utf8"));
console.log(`tracks identical: ${same}, different: ${diff}; build.json ${build ? "identical" : "DIFFERENT"}; cmd files different: ${cmds.length}`);
if (report.length) console.log(report.join("\n"));
const logs = ["ref", "engine"].map((k) => readFileSync(join(work, k, "log.txt"), "utf8"));
if (logs[0] !== logs[1]) console.log("\nreport logs differ (see log.txt in each folder)");
process.exitCode = diff || !build ? 1 : 0;
