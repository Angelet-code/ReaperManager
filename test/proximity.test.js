import assert from "node:assert/strict";
import path from "node:path";
import test from "node:test";
import {
  PROXIMITY_SCRIPT,
  buildProximityArgs,
  buildAutomationPoints,
  buildProximityMarkers,
  markerName,
  proximityFixPath,
  proximitySourceRange,
  runProximityDetect,
  sourceToProjectTime
} from "../src/proximity.js";

const probe = {
  source_file: "C:\\audio\\vox.wav",
  item_position: 10,
  item_length: 5,
  take_offset: 2,
  take_playrate: 1,
  time_selection: { start: 11, end: 12.5 }
};

test("proximitySourceRange covers the whole item unless --selection", () => {
  assert.deepEqual(proximitySourceRange(probe), { startS: 2, endS: 7 });
  assert.deepEqual(proximitySourceRange(probe, { selection: true }), { startS: 3, endS: 4.5 });
});

test("sourceToProjectTime honours offset and playrate", () => {
  assert.equal(sourceToProjectTime(probe, 3), 11);
  assert.equal(sourceToProjectTime({ ...probe, take_playrate: 2 }, 4), 11);
});

test("buildProximityArgs validates tuning options", () => {
  const args = buildProximityArgs({ "h12-drop-db": 8 }, "vox.wav", { startS: 0, endS: 1 });
  assert.equal(args[0], PROXIMITY_SCRIPT);
  assert.deepEqual(args.slice(-2), ["--h12-drop-db", "8"]);
  assert.throws(() => buildProximityArgs({ "min-z": 9 }, "vox.wav", { startS: 0, endS: 1 }), /between/);
});

test("--fix renders next to the source and passes --max and --render", () => {
  const out = proximityFixPath(path.join("audio", "vox take.wav"));
  assert.match(out, /vox take prox-fix\.wav$/);
  const args = buildProximityArgs({}, "vox.wav", { startS: 0, endS: 1 }, { max: 12, render: out });
  assert.deepEqual(args.slice(-4), ["--max", "12", "--render", out]);
});

test("buildProximityMarkers ranks by score and orders by position", () => {
  const markers = buildProximityMarkers(probe, [
    { start: 4, score: 10, h12_drop_db: -7, level_drop_db: -1 },
    { start: 3, score: 20, h12_drop_db: -15, level_drop_db: -3 },
    { start: 5, score: 5, h12_drop_db: -6, level_drop_db: 0 }
  ], { max: 2 });
  assert.deepEqual(markers.map((m) => m.name), ["PROX 1 H12 -15 lvl -3", "PROX 2 H12 -7 lvl -1"]);
  assert.deepEqual(markers.map((m) => m.position), [11, 12]);
});

test("markerName shows diagnosis, distance ratio and level vs neighbours", () => {
  assert.equal(markerName(1, { kind: "lejos", distance_ratio: 2.01, fix_level_gap_db: 6 }), "PROX 1 LEJOS x2.0 lvl -6");
  assert.equal(markerName(4, { kind: "fuerte", fix_level_gap_db: -2.8 }), "PROX 4 FUERTE lvl +2.8");
});

test("proximityFixPath numbers the render when the name is taken", () => {
  const taken = new Set([path.join("audio", "vox prox-fix.wav"), path.join("audio", "vox prox-fix 2.wav")]);
  assert.equal(proximityFixPath(path.join("audio", "vox.wav"), (file) => taken.has(file)), path.join("audio", "vox prox-fix 3.wav"));
});

test("runProximityDetect refuses to analyse a prox-fix render", async () => {
  const request = async () => ({ ok: true, data: { ...probe, source_file: "C:\\audio\\vox prox-fix.wav" } });
  await assert.rejects(runProximityDetect({}, { request }), /already a prox-fix/);
});

test("runProximityDetect --fix first removes earlier prox-fix takes", async () => {
  const sent = [];
  const request = async (command) => {
    sent.push(command.type);
    return command.type === "remove_takes_matching"
      ? { ok: true, data: { removed: 1 } }
      : { ok: true, data: { ...probe, source_file: "C:\audio\vox.mp3" } };
  };
  await assert.rejects(runProximityDetect({ fix: true }, { request }), /WAV sources only/);
  assert.deepEqual(sent, ["remove_takes_matching", "sample_edit_probe"]);
});

test("buildAutomationPoints makes ramped plateaus, merges close windows, keeps FUERTE out of the EQ", () => {
  const item = { ...probe, item_position: 0, take_offset: 0, item_length: 10 };
  const points = buildAutomationPoints(item, [
    { kind: "lejos", windows: [[1, 1.5], [1.51, 2]], shelf_db: 4, fix_level_db: 5 },
    { kind: "fuerte", windows: [[3, 3.5]], shelf_db: 0, fix_level_db: -3 }
  ], { fadeS: 0.02 });
  assert.deepEqual(points.volume, [[0, 0], [0.98, 0], [1, 5], [2, 5], [2.02, 0], [2.98, 0], [3, -3], [3.5, -3], [3.52, 0], [10, 0]]);
  assert.deepEqual(points.eq, [[0, 0], [0.98, 0], [1, 4], [2, 4], [2.02, 0], [10, 0]]);
});

test("buildAutomationPoints ramps a FUERTE hit straight into its vowel", () => {
  const item = { ...probe, item_position: 0, take_offset: 0, item_length: 10 };
  const points = buildAutomationPoints(item, [
    { kind: "fuerte", hit_window: [1, 1.09], hit_gain_db: -3.65, windows: [[1.09, 1.6]], shelf_db: 0, fix_level_db: -4.87 }
  ], { fadeS: 0.02 });
  assert.deepEqual(points.volume, [[0, 0], [0.98, 0], [1, -3.65], [1.07, -3.65], [1.09, -4.87], [1.6, -4.87], [1.62, 0], [10, 0]]);
  assert.deepEqual(points.eq, []);
});

test("runProximityDetect rejects non-WAV sources before running python", async () => {
  const request = async () => ({ ok: true, data: { ...probe, source_file: "C:\\audio\\vox.mp3" } });
  await assert.rejects(runProximityDetect({}, { request }), /WAV sources only/);
});
