#!/usr/bin/env node
// Onboard a library patch into the music engine: render test notes through the bridge, measure them and
// write the measured blocks (status M) into its profile JSON. Docs: docs/music-engine.md ("Calibración").
//
//   node scripts/calibrate-instrument.mjs --profile albion-one/strings-long --dry-run
//       writes the test MIDI (replace_midi) and measurement specs into --out; no REAPER
//   node scripts/calibrate-instrument.mjs --profile albion-one/strings-long --from-results <dir> [--write]
//       maps existing measure.py results (<patch>_<test>.result.json) onto the profile; shows the diff, --write
//       saves it. --result <file> takes one explicit result file instead.
//   node scripts/calibrate-instrument.mjs --profile albion-one/strings-long --yes [--write]
//       LIVE: needs the bridge running and the user's OK every time. Opens the separate calibration project
//       (never the user's working tab), loads the patch on a CAL track, renders it, measures and maps.
//
// Options: --tests legato,long,short,swam (default: by the patch's style) --out <dir> (default: scratch under
// .reaper-manager/calibration) --project <cal .rpp> --root <Reaper Manager workspace> (default: cwd)
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { join, resolve } from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import { loadProfiles, findPatch, resolveTrack, PROFILE_DIR } from "../src/music/index.js";
import { buildTest, testsFor, blocksFromResult, applyBlocks } from "../src/music/profiles/calibration.js";

const HERE = fileURLToPath(new URL(".", import.meta.url));
const args = process.argv.slice(2);
const arg = (k, d) => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : d; };
const flag = (k) => args.includes(k);
const profile = arg("--profile");
if (!profile) { console.error("usage: --profile <library/patch> (--dry-run | --from-results <dir> | --yes) [--write]"); process.exit(2); }
const registry = loadProfiles();
const found = findPatch(registry, { profile });
if (!found) { console.error(`profile ${profile} not found in ${PROFILE_DIR}`); process.exit(1); }
const { cfg, style } = resolveTrack(registry, "CAL", { profile });
const tests = (arg("--tests") || testsFor(style).join(",")).split(",").filter(Boolean);
if (!tests.length) { console.error(`no calibration test for style ${style}; pass --tests`); process.exit(1); }
const root = resolve(arg("--root", process.cwd()));
const out = resolve(arg("--out", join(root, ".reaper-manager", "calibration", profile.replace("/", "__"))));
const project = arg("--project", "A:/CERBATANA/Ableton/calibracion-librerias/calibracion-librerias.rpp");
const id = (kind) => `${found.patchId}_${kind}`;
mkdirSync(out, { recursive: true });

// 1) test MIDI and specs
const specs = tests.map((kind) => {
  const t = buildTest(kind, cfg);
  const plugin = found.patch.match?.[0] || "";
  writeFileSync(join(out, `${id(kind)}.midi.json`), JSON.stringify({ type: "replace_midi", track: "CAL", midi: [{ bar: 1, bars: t.bars, name: id(kind), cc_shape: "square", notes: t.notes, cc: t.cc }] }));
  writeFileSync(join(out, `${id(kind)}.spec.json`), JSON.stringify({ id: id(kind), patch: plugin, bars: t.bars, ...t.spec }));
  console.log(`${id(kind)}: ${t.notes.length} notes, ${t.bars} bars (${t.bars * 2} s at 120 BPM)`);
  return { kind, bars: t.bars, plugin };
});
if (flag("--dry-run")) { console.log(`test MIDI and specs in ${out}`); process.exit(0); }

// 2) results: from a folder, or live through the bridge
const resultsDir = arg("--from-results");
if (!resultsDir && !arg("--result") && !flag("--yes")) {
  console.error("live calibration renders through REAPER: ask the user first, then pass --yes (or use --dry-run / --from-results)");
  process.exit(2);
}
if (!resultsDir && !arg("--result")) await live();
const merged = {};
const single = arg("--result"); // one explicit result file (e.g. an older measurement under another name)
for (const { kind } of specs) {
  const path = single ? resolve(single) : join(resultsDir ? resolve(resultsDir) : out, `${id(kind)}.result.json`);
  if (!existsSync(path)) { console.error(`no result for ${kind} (${path})`); continue; }
  Object.assign(merged, blocksFromResult(JSON.parse(readFileSync(path, "utf8")), { source: resultsDir || single ? `results ${single || resultsDir}` : "calibrate-instrument" }));
  if (single) break;
}
if (!Object.keys(merged).length) { console.error("nothing measured"); process.exit(1); }

// 3) map onto the profile: show the diff, save only with --write
const libFile = join(PROFILE_DIR, `${found.libraryId}.json`);
const lib = JSON.parse(readFileSync(libFile, "utf8"));
const { before, after } = applyBlocks(lib, found.patchId, merged);
for (const k of Object.keys(merged)) console.log(`${k}:\n  before ${JSON.stringify(before[k] ?? null)}\n  after  ${JSON.stringify(after[k])}`);
if (flag("--write")) { writeFileSync(libFile, JSON.stringify(lib, null, 2) + "\n"); console.log(`written ${libFile}`); }
else console.log("(dry: pass --write to save the profile)");

async function live() {
  const { enqueueCommand, waitForResponse, readStatus } = await import("../src/client.js");
  const status = readStatus(root);
  if (status?.heartbeat?.bridge !== "running") { console.error("bridge not running: press the Reaper Manager toolbar button in REAPER"); process.exit(1); }
  const send = async (command, timeoutMs = 120000) => {
    const r = await waitForResponse(enqueueCommand(command, { root }), { root, timeoutMs });
    if (r?.ok === false || r?.error) throw new Error(`${command.type}: ${r.error || JSON.stringify(r)}`);
    return r;
  };
  // a separate one-track project: never the user's working tab
  await send({ type: "open_project", path: project });
  await send({ type: "delete_tracks", contains: "CAL" });
  const fx = specs[0].plugin.startsWith("VST") ? { name: specs[0].plugin } : { patch: specs[0].plugin };
  await send({ type: "build_beat", tempo: 120, timesig: [4, 4], tracks: [{ name: "CAL", volume_db: 0, fx: [fx] }] }, 300000);
  for (const { kind, bars } of specs) {
    await send(JSON.parse(readFileSync(join(out, `${id(kind)}.midi.json`), "utf8")));
    await send({ type: "render_audio", from_bar: 1, to_bar: bars, tail_ms: 2000, dir: out.replaceAll("\\", "/"), name: id(kind), stems: ["CAL"] }, 400000);
    const wav = join(out, `${id(kind)}_CAL.wav`);
    const r = spawnSync("python", ["-I", join(HERE, "calibration", "measure.py"), wav, join(out, `${id(kind)}.spec.json`)], { encoding: "utf8" });
    if (r.status !== 0) throw new Error(`measure.py: ${r.stderr}`);
    writeFileSync(join(out, `${id(kind)}.result.json`), r.stdout);
    console.log(`measured ${kind}`);
  }
}
