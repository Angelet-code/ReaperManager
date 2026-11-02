import test from "node:test";
import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { mkdtempSync, readdirSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { buildTest, testsFor, blocksFromResult, applyBlocks } from "../src/music/profiles/calibration.js";

test("calibration: test MIDI per style uses the profile's controllers", () => {
  assert.deepEqual(testsFor("sampled-legato"), ["legato"]);
  assert.deepEqual(testsFor("piano"), []);
  const t = buildTest("long", { range: { practical: [40, 80] }, dynamics: { cc: 1 }, expression: { cc: 11 }, vibrato: { cc: 21 } });
  assert.equal(t.spec.kind, "long");
  assert.ok(t.cc.some((c) => c.cc === 21 && c.value === 0), "vibrato off while measuring");
  assert.equal(t.spec.cc1.length, 9);
  const s = buildTest("swam", { range: { practical: [60, 93] }, expression: { cc: 11 }, vibrato: { cc: 1 } });
  assert.equal(s.spec.blocks.length, 6);
});

test("calibration: measured results become status-M profile blocks", () => {
  const legato = blocksFromResult({
    attack_by_vel: [{ vel: 30, "attack_ms(-6dB)": 190 }, { vel: 60, "attack_ms(-6dB)": 105 }],
    legato_by_vel: [30, 60, 90, 120].map((vel) => ({ vel, "start_ms(20%)": 55, "mid_ms(50%)": 90, "done_ms(90%)": 340 }))
  }, { date: "2026-11-02" });
  assert.deepEqual(legato.latency.transitionMs, [55, 90, 340]);
  assert.equal(legato.velocity.slurEffect, "none"); // same transition at every velocity
  const swam = blocksFromResult({
    cc11_response: [{ cc: 80, dB: -2.6 }, { cc: 95, dB: -0.5 }, { cc: 127, dB: 0 }],
    portamento_by_vel: [{ vel: 60, "mid_ms(50%)": 65 }, { vel: 120, "mid_ms(50%)": 60 }],
    attack_first: { "attack_ms(-6dB)": 60 }
  });
  assert.equal(swam.expression.levelCeiling, 95);
  assert.deepEqual(swam.calibration.cc11Db, [[80, -2.6], [95, -0.5], [127, 0]]);
  assert.equal(swam.calibration.status, "M");
  const lib = { library: "X", patches: { p: { latency: { onBeat: { attackMs: 100 } } } } };
  const { after } = applyBlocks(lib, "p", legato);
  assert.equal(after.latency.onBeat.attackMs, 100, "unmeasured keys stay");
  assert.deepEqual(after.latency.transitionMs, [55, 90, 340]);
  assert.throws(() => applyBlocks(lib, "nope", legato), /not in/);
});

test("calibrate-instrument: dry run writes test MIDI, live mode refuses without --yes", () => {
  const out = mkdtempSync(join(tmpdir(), "rm-cal-"));
  try {
    const dry = spawnSync(process.execPath, ["scripts/calibrate-instrument.mjs", "--profile", "albion-one/woods-high-legato", "--dry-run", "--out", out], { encoding: "utf8" });
    assert.equal(dry.status, 0, dry.stderr);
    assert.deepEqual(readdirSync(out).sort(), ["woods-high-legato_legato.midi.json", "woods-high-legato_legato.spec.json"]);
    const live = spawnSync(process.execPath, ["scripts/calibrate-instrument.mjs", "--profile", "albion-one/woods-high-legato", "--out", out], { encoding: "utf8" });
    assert.equal(live.status, 2);
    assert.match(live.stderr, /ask the user first/);
  } finally {
    rmSync(out, { recursive: true, force: true });
  }
});
