import test from "node:test";
import assert from "node:assert/strict";
import { createPiece, loadProfiles, resolveTrack, findPatch, listProfiles, interp } from "../src/music/index.js";

const tempo = [{ bar: 1, bpm: 72, num: 4, den: 4 }];
const lane = (d, num) => d.cc.filter((c) => c.cc === num).sort((a, b) => a.pos - b.pos);
const at = (d, num, p) => interp(lane(d, num).map((c) => ({ pos: c.pos, value: c.value })), null)(p);

test("profiles: resolve layers, find by plugin name, warn instead of failing", () => {
  const reg = loadProfiles();
  const hn = resolveTrack(reg, "HN", { profile: "swam/french-horn-f" });
  assert.equal(hn.style, "modeled");
  assert.equal(hn.cfg.velocity.slur.floor, 100);
  assert.deepEqual(hn.cfg.stamina, { sec: 8, gapMs: 280 });
  assert.deepEqual(hn.warnings, []);
  const str = resolveTrack(reg, "STR", { patch: "Albion ONE - Strings High (Octave) - Legato", overrides: { vibrato: { scale: 0.5 } } });
  assert.equal(str.source, "albion-one/strings-high-octave-legato");
  assert.equal(str.cfg.vibrato.scale, 0.5);
  assert.equal(str.cfg.vibrato.cc, 21);
  assert.deepEqual(str.cfg.stamina, { sec: 7, gapMs: 120 }); // ensemble patch → section stamina
  const unknown = resolveTrack(reg, "NEW", { profile: "bbc-so/violins-1-legato" });
  assert.equal(unknown.source, "generic");
  assert.ok(unknown.warnings.some((w) => /not found/.test(w)));
  const bare = resolveTrack(reg, "SYN", { style: "modeled" });
  assert.ok(bare.warnings.some((w) => /vibrato.depth/.test(w)));
  assert.equal(findPatch(reg, { patch: "VST3:SWAM Cello 3 (Audio Modeling)" }).patchId, "cello-3");
  assert.equal(findPatch(reg, { patch: "nothing" }), null);
  const rows = listProfiles(reg);
  assert.ok(rows.some((r) => r.template));
  assert.ok(rows.find((r) => r.id === "swam/viola-3").assumed.length > 0);
});

test("modeled: phrase vibrato never drops at a slur, slur velocity by length, horn floor, expression leads the note", () => {
  const piece = createPiece({ seed: 5, tempo, lastBar: 8, sections: [{ bar: 1, name: "A", vib: 60 }],
    tracks: { VLN: { profile: "swam/violin-3" }, HN: { profile: "swam/french-horn-f" } } });
  piece.line("VLN", 1, 0, piece.mel("A4:2 B4:1 C5:1 D5:4"));
  piece.line("HN", 3, 0, piece.mel("F3:1 G3:.5 A3:3"));
  piece.dyn(["VLN", "HN"], [[1, 0, 60], [5, 0, 60]]);
  piece.perform();
  const v = piece.tracks.VLN;
  const ns = [...v.notes].sort((a, b) => a.pos - b.pos);
  for (const n of ns.slice(1)) assert.ok(at(v, 1, n.pos + 0.01) > 10, `vibrato at slur ${n.pos}: ${at(v, 1, n.pos + 0.01)}`);
  assert.ok(ns[1].vel >= 78 && ns[1].vel <= 90, `slur velocity ${ns[1].vel}`); // 0.83 s note → "slow" 88 − 4 (strings) ± 6
  assert.ok(lane(v, 11)[0].pos < ns[0].pos, "expression leads the first note-on");
  const hn = piece.tracks.HN.notes.sort((a, b) => a.pos - b.pos);
  assert.ok(hn.slice(1).every((n) => n.vel >= 100));
  assert.ok(piece.tracks.HN.cc.some((c) => c.pb !== undefined && c.pb < 0), "horn scoop");
});

test("sampled legato: early starts, overlap slurs, layered dynamics and section release", () => {
  const piece = createPiece({ seed: 2, tempo, lastBar: 8, sections: [{ bar: 1, name: "A", vib: 50, rel: 90 }],
    tracks: { STR: { profile: "albion-one/strings-high-octave-legato" } } });
  piece.line("STR", 1, 0, piece.mel("A4:2 C5:2 E5:4"));
  piece.dyn("STR", [[1, 0, 80], [4, 0, 80]]);
  piece.perform();
  const d = piece.tracks.STR, ns = d.notes.sort((a, b) => a.pos - b.pos);
  assert.ok(ns[0].pos < 1e-9 || ns[0].pos === 0);
  assert.ok(ns[1].pos < 2 && ns[1].pos > 1.9, "slurred note starts ~50 ms early");
  assert.ok(ns[0].pos + ns[0].len > ns[1].pos, "overlap = slur");
  const mid = at(d, 1, 6);
  assert.ok(Math.abs(mid - (0.78 * 80 + 6)) < 12, `CC1 ≈ 0.78·80+6 (${mid})`);
  assert.equal(lane(d, 17)[0].value, 90);
  assert.ok(lane(d, 21).length > 0);
});

test("a section without vib gets the default vibrato and a warning, never a CC point without a value", () => {
  const piece = createPiece({ seed: 3, tempo, lastBar: 8, sections: [{ bar: 1, name: "A" }, { bar: 5, name: "B", vib: 30 }],
    tracks: { STR: { profile: "albion-one/strings-long" } } });
  piece.pad("STR", piece.harm(1, ["E", "A", "B7", "E", "C", "D", "E", "E"]), 3, 52, 64);
  piece.dyn("STR", [[1, 0, 40], [8, 3, 30]]);
  const report = piece.check();
  assert.deepEqual(report.errors, []);
  assert.ok(report.warnings.some((w) => /section A has no vib/.test(w)));
  assert.ok(!report.warnings.some((w) => /section B has no vib/.test(w)));
  assert.ok(piece.tracks.STR.cc.every((c) => Number.isFinite(c.pb ?? c.value)));
  assert.ok(lane(piece.tracks.STR, 21).length > 0);
  // a blank CC point (written by hand or by a style) is an error before it reaches REAPER
  piece.cc("STR", 0, 7, NaN);
  assert.ok(piece.check().errors.some((e) => /STR: 1 CC points without a value \(CC 7\)/.test(e)));
});

test("shared breaths: a doubled melody breathes in the same place", () => {
  const piece = createPiece({ seed: 1, tempo: [{ bar: 1, bpm: 60, num: 4, den: 4 }], lastBar: 12, sections: [{ bar: 1, name: "A", vib: 50 }],
    tracks: { STR: { profile: "albion-one/strings-high-octave-legato" }, WW: { profile: "albion-one/woods-high-legato" } },
    breathGroups: { melody: ["STR", "WW"] } });
  const spec = piece.mel("D5:2 E5:2 F5:2 G5:2 A5:4 G5:2 F5:2 E5:2 D5:2 C5:4 D5:4");
  piece.line("STR", 1, 0, spec);
  piece.line("WW", 1, 0, spec);
  piece.dyn(["STR", "WW"], [[1, 0, 65], [10, 0, 65]]);
  piece.perform();
  const cut = (t) => piece.tracks[t].notes.filter((n) => n.breath).map((n) => piece.timeline.barOf(n.pos));
  assert.ok(cut("STR").length > 0);
  assert.deepEqual(cut("WW"), cut("STR"));
  assert.ok(piece.breathLog.length >= 2);
});

test("independent streams: rewriting one track leaves the others' humanization alone", () => {
  const build = (extra) => {
    const p = createPiece({ seed: 9, tempo, lastBar: 4, tracks: { A: { profile: "albion-one/strings-short-spiccato" }, B: { profile: "albion-one/strings-short-spiccato" } } });
    for (let i = 0; i < 8; i++) p.note("A", 1, i * 0.5, 0.25, 60);
    for (let i = 0; i < (extra ? 16 : 8); i++) p.note("B", 1, i * 0.25, 0.2, 67);
    p.dyn(["A", "B"], [[1, 0, 70]]);
    return p.perform().tracks.A.notes.map((n) => [n.pos, n.vel]);
  };
  assert.deepEqual(build(false), build(true));
});

test("percussion: timpani roll by CC7 with reset before the next hit; cymbal swell rings past the arrival", () => {
  const piece = createPiece({ seed: 3, tempo, lastBar: 8,
    tracks: { TIMP: { profile: "symphony-series/timpani" }, CYM: { profile: "symphony-series/cymbal-1" } } });
  piece.timpRoll(1, 0, 8, 38, [[1, 0, 10], [2, 2, 110]]);
  piece.timpHit(3, 0, 38, 110);
  piece.cymSwell(3, 0, 4, 116);
  piece.timpVolumeReset();
  const t = piece.tracks.TIMP;
  const cc7 = lane(t, 7);
  assert.ok(Math.abs(cc7[0].value - 47) <= 1, `roll starts at CC7 ≈ 40+87·10/127 (${cc7[0].value})`);
  const hit = t.notes.find((n) => !n.ks && n.vel !== 90);
  const reset = cc7.filter((c) => c.value === 127 && c.pos < hit.pos && c.pos > 7);
  assert.equal(reset.length, 1, "CC7 back to 127 right before the hit");
  assert.ok(t.notes.some((n) => n.ks && n.pitch === 38), "roll keyswitch");
  const c = piece.tracks.CYM, roll = c.notes.find((n) => n.pitch === 55);
  assert.ok(roll.pos + roll.len > piece.pos(3, 0) + 1, "tremolo rings after the arrival");
  assert.ok(Math.abs(at(c, 1, piece.pos(3, 0)) - 116) < 2);
  piece.perform();
  assert.ok(lane(t, 7).length > 2);
});

test("writing: harp arpeggio stays at or above its floor, pizz bass second note is a chord root or fifth", () => {
  const piece = createPiece({ seed: 1, tempo: [{ bar: 1, bpm: 76, num: 3, den: 4 }], lastBar: 8, tracks: { PIANO: { profile: "arturia/piano-v3" }, PIZZ: { profile: "albion-one/strings-short-pizzicato" } } });
  const rows = piece.harm(1, ["F", "Gm7/Bb", "C7/E", "F"]);
  piece.harpArp("PIANO", rows, 48, 70, { per: 2 });
  assert.ok(piece.tracks.PIANO.notes.every((n) => n.pitch >= 48));
  assert.ok(piece.tracks.PIANO.cc.some((c) => c.cc === 64));
  piece.pizzBass("PIZZ", rows);
  const second = piece.tracks.PIZZ.notes.filter((n) => Math.abs(n.pos - piece.pos(2, 2)) < 1e-9)[0];
  assert.ok([7, 2].includes(second.pitch % 12), `Gm7/Bb: G or D, got ${second.pitch}`);
});

test("balance: dB rules become velocity on shorts and expression on modeled tracks", () => {
  const make = (rules) => {
    const p = createPiece({ seed: 4, tempo, lastBar: 6, sections: [{ bar: 1, name: "A", vib: 40 }], balance: rules,
      tracks: { S: { profile: "albion-one/strings-short-spiccato" }, F: { profile: "swam/flute-3" } } });
    for (let i = 0; i < 8; i++) p.note("S", 2, i * 0.5, 0.25, 60);
    p.line("F", 2, 0, p.mel("A5:2 G5:2"));
    p.dyn(["S", "F"], [[1, 0, 70]]);
    return p.perform();
  };
  const flat = make([]), quiet = make([["S", 2, 2, -6], ["F", 2, 2, -3]]);
  const vels = (p) => p.tracks.S.notes.map((n) => n.vel);
  vels(quiet).forEach((v, i) => assert.ok(Math.abs(vels(flat)[i] - 18 - v) <= 1));
  assert.ok(at(quiet.tracks.F, 11, quiet.pos(2, 1)) < at(flat.tracks.F, 11, flat.pos(2, 1)) - 10);
});

test("drums: the kit rides one drift; groups keep their own placement", () => {
  const piece = createPiece({ seed: 8, tempo: [{ bar: 1, bpm: 120, num: 4, den: 4 }], lastBar: 4,
    tracks: { KIT: { profile: "toontrack/ezdrummer-3", overrides: { feel: { offsetsMs: { snare: 6, hats: 5 } } } } } });
  const map = piece.resolve("KIT").cfg.map;
  for (let b = 0; b < 4; b++) {
    piece.noteAt("KIT", b, 0.2, map.kick, { vel: 110 });
    piece.noteAt("KIT", b, 0.2, map.snare, { vel: 100 });
    piece.noteAt("KIT", b, 0.2, map.hat, { vel: 70 });
  }
  piece.perform();
  const byBeat = (pitch) => piece.tracks.KIT.notes.filter((n) => n.pitch === pitch).sort((a, b) => a.pos - b.pos).map((n) => n.pos);
  const k = byBeat(map.kick), s = byBeat(map.snare), h = byBeat(map.hat);
  k.forEach((kp, i) => {
    assert.ok(Math.abs(s[i] - kp - 0.012) < 1e-9, "snare 6 ms behind the kick, same drift");
    assert.ok(Math.abs(h[i] - kp - 0.01) < 1e-9, "hats 5 ms laid back");
  });
});

test("check and bridge output: ranges, monophony and per-section items", () => {
  const piece = createPiece({ seed: 1, title: "T", tempo, lastBar: 8, sections: [{ bar: 1, name: "A" }, { bar: 5, name: "B" }],
    tracks: { FL: { profile: "swam/flute-3" } } });
  piece.line("FL", 1, 0, piece.mel("C4:2 A5:2"));
  piece.line("FL", 5, 0, piece.mel("Bb6:2 C8:2"));
  piece.dyn("FL", [[1, 0, 60]]);
  const r = piece.check();
  assert.ok(r.errors.some((e) => /out of range 108/.test(e)), r.errors.join("; "));
  assert.ok(r.warnings.some((w) => /practical range 94/.test(w)), r.warnings.join("; "));
  const midi = piece.toBridge();
  assert.deepEqual(midi.FL.map((i) => [i.bar, i.name]), [[1, "A"], [5, "B"]]);
});
