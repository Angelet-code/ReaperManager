import test from "node:test";
import assert from "node:assert/strict";
import {
  createTimeline, createRandom, M, mel, parseChord, voice, noteName, scaleOf, interp, thin, rampPoints,
  swing, bandDrift, humanizeNotes, fixSamePitchOverlaps, checkNotes, checkMonophonic, findClashes, trackItems, replaceMidi, buildSpec
} from "../src/music/index.js";

const near = (a, b, eps = 1e-9) => assert.ok(Math.abs(a - b) < eps, `${a} ≉ ${b}`);

test("timeline: meter and tempo changes map bars, qn and seconds", () => {
  const tl = createTimeline([{ bar: 1, bpm: 120, num: 4, den: 4 }, { bar: 3, bpm: 60, num: 7, den: 8 }], 6);
  assert.equal(tl.pos(3), 8);
  assert.equal(tl.barLen(3), 3.5);
  assert.equal(tl.pos(4, 1), 12.5);
  near(tl.secOf(8), 4); // two 4/4 bars at 120
  near(tl.secOf(9), 5); // then one qn at 60
  assert.equal(tl.measureAt(11.4).bar, 3);
  assert.equal(tl.barOf(11.6), 4);
  near(tl.ms2qn(500, 9), 0.5);
  near(tl.secs(1, 9), 1);
  assert.equal(tl.fmtPos(12.5), "c.4:1.00");
  assert.throws(() => tl.pos(99), /outside the tempo map/);
});

test("random: streams are deterministic and independent per track and layer", () => {
  const a = createRandom({ seed: 7 }), b = createRandom({ seed: 7 });
  const x1 = a.stream("VLN", "humanize").rnd();
  a.stream("VLA", "humanize").rnd(); // consuming another stream...
  const x2 = a.stream("VLN", "humanize").rnd();
  b.stream("VLN", "humanize").rnd();
  assert.equal(x2, b.stream("VLN", "humanize").rnd()); // ...does not move this one
  assert.notEqual(x1, createRandom({ seed: 7 }).stream("VLN", "breaths").rnd());
  const s = createRandom({ seed: 20261102, mode: "shared" });
  assert.equal(s.stream("A", "x"), s.stream("B", "y"));
  // Park–Miller as La Forja's core.mjs
  let seed = 20261102;
  const ref = () => ((seed = (seed * 16807) % 2147483647) / 2147483647);
  assert.equal(createRandom({ seed: 20261102, mode: "shared" }).stream().rnd(), ref());
});

test("pitch: names, melody syntax, chords and voicing", () => {
  assert.equal(M("C4"), 60);
  assert.equal(M("Bb3"), 58);
  assert.equal(noteName(61), "C#4");
  const spec = mel("D4:1! A4:.5^ Bb4:2~ r:1 C5:.25g");
  assert.deepEqual(spec.map(([p, l]) => [p, l]), [[62, 1], [69, 0.5], [70, 2], [null, 1], [72, 0.25]]);
  assert.equal(spec[0][2].acc, 8);
  assert.equal(spec[1][2].tie, false);
  assert.ok(spec[2][2].gliss && spec[4][2].grace);
  assert.deepEqual(parseChord("Gm7/Bb").pcs, [7, 10, 2, 5]);
  assert.equal(parseChord("Gm7/Bb").bass, 10);
  assert.deepEqual(parseChord("C7sus4").pcs.sort((a, b) => a - b), [0, 5, 7, 10]);
  const v = voice("Dm", 3, 60, 76);
  assert.equal(v.length, 3);
  assert.deepEqual([...new Set(v.map((p) => p % 12))].sort((a, b) => a - b), [2, 5, 9]);
  assert.deepEqual(scaleOf("F#", "minor"), [6, 8, 9, 11, 1, 2, 4]);
  assert.throws(() => parseChord("Hm"), /chord/);
});

test("curves: interpolation with subito steps, thinning and ramps", () => {
  const f = interp([{ pos: 0, value: 20 }, { pos: 4, value: 60 }, { pos: 4, value: 100 }, { pos: 8, value: 100 }], 0);
  assert.equal(f(2), 40);
  assert.equal(f(4), 100);
  assert.equal(interp([], 64)(3), 64);
  assert.equal(thin([{ pos: 0, value: 0 }, { pos: 1, value: 10 }, { pos: 2, value: 20 }]).length, 2);
  assert.deepEqual(rampPoints(0, 0, 1, 10, 0.5).map((p) => p.value), [0, 5, 10]);
});

test("feel: swing moves off-beats only, band drift stays in range, humanize moves chords together", () => {
  const ns = [{ pos: 0, len: 0.4 }, { pos: 0.5, len: 0.4 }, { pos: 1, len: 0.4 }];
  swing(ns, { amount: 60, grid: 0.5, keep: 0 });
  assert.deepEqual(ns.map((n) => +n.pos.toFixed(4)), [0, 0.6, 1]);
  const r = createRandom({ seed: 3 }).stream("", "band");
  const drift = bandDrift(r, 64, { maxQn: 0.01, step: 0.005 });
  for (let p = 0; p < 64; p += 0.37) assert.ok(Math.abs(drift(p)) <= 0.01 + 1e-12);
  const tl = createTimeline([{ bar: 1, bpm: 120, num: 4, den: 4 }], 4);
  const chord = [{ pos: 1, len: 1, pitch: 60, vel: 80 }, { pos: 1, len: 1, pitch: 64, vel: 80 }, { pos: 2, len: 1, pitch: 67, vel: 80 }];
  humanizeNotes(chord, tl, createRandom({ seed: 1 }).stream("P", "h"), { timingMs: 20 });
  assert.equal(chord[0].pos, chord[1].pos);
});

test("validate: same-pitch overlaps, ranges, monophony and sustained clashes", () => {
  const tl = createTimeline([{ bar: 1, bpm: 60, num: 4, den: 4 }], 4);
  const d = { notes: [{ pos: 0, len: 2, pitch: 60 }, { pos: 1, len: 1, pitch: 60 }, { pos: 1, len: 1, pitch: 60 }], cc: [] };
  fixSamePitchOverlaps(d);
  assert.equal(d.notes.length, 2);
  near(d.notes[0].len, 0.98);
  const r = checkNotes("X", { notes: [{ pos: 0, len: 1, pitch: 50 }, { pos: 1, len: 1, pitch: 58 }] }, { practical: [60, 80], full: [55, 90] }, tl);
  assert.equal(r.errors.length, 1);
  assert.equal(r.warnings.length, 1);
  const mono = checkMonophonic("X", { notes: [{ pos: 0, len: 1.05, pitch: 60 }, { pos: 1, len: 1, pitch: 62 }, { pos: 2, len: 2, pitch: 64 }, { pos: 3, len: 1, pitch: 65 }] }, tl);
  assert.equal(mono.errors.length, 1);
  const clashes = findClashes({ A: { notes: [{ pos: 0, len: 4, pitch: 60 }] }, B: { notes: [{ pos: 1, len: 3, pitch: 61 }] } }, tl);
  assert.equal(clashes.length, 1);
  assert.equal(clashes[0].bar, 1);
});

test("bridge: items split at bounds, keep crossing notes whole and start each CC at its curve", () => {
  const tl = createTimeline([{ bar: 1, bpm: 120, num: 4, den: 4 }], 8);
  const d = {
    notes: [{ pos: 0, len: 2, pitch: 60, vel: 80 }, { pos: 14, len: 4, pitch: 62, vel: 90 }, { pos: 20, len: 1, pitch: 64, vel: 70 }],
    cc: [{ pos: 0, cc: 11, value: 40 }, { pos: 24, cc: 11, value: 100 }, { pos: 1, cc: 64, value: 127 }]
  };
  const items = trackItems(d, tl, { bounds: [1, 5, 9], names: { 1: "A", 5: "B" } });
  // the note at qn 14 crosses bar 5 (qn 16): no cut there, one item
  assert.equal(items.length, 1);
  const two = trackItems({ ...d, notes: [d.notes[0], d.notes[2]] }, tl, { bounds: [1, 5, 9], names: { 1: "A", 5: "B" } });
  assert.deepEqual(two.map((i) => [i.bar, i.bars, i.name]), [[1, 4, "A"], [5, 4, "B"]]);
  const startCC = two[1].cc.find((c) => c.cc === 11 && c.beat === 0);
  assert.equal(startCC.value, 80); // 40 → 100 over qn 0–24, at qn 16
  assert.equal(two[1].cc.find((c) => c.cc === 64).value, 127); // the pedal keeps its last value
  assert.equal(replaceMidi("X", two).type, "replace_midi");
  const spec = buildSpec(createTimeline([{ bar: 1, bpm: 90, num: 4, den: 4 }, { bar: 9, bpm: 100, num: 7, den: 8 }], 16), { tracks: [{ name: "A" }] });
  assert.deepEqual(spec.tempo_changes, [{ bar: 9, bpm: 100, timesig: [7, 8] }]);
});
