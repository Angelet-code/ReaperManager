// Output for the REAPER bridge: MIDI items per track (replace_midi) and the session spec (build_beat).
import { mkdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { clamp } from "./util.js";

// Split a performed track into items at section bounds, never cutting a note that crosses a bound.
// bounds: bars where items may start (first = 1, last = end bar + 1); names: item names by start bar.
// single: one item for the whole piece. Each item starts every CC at its curve's value (no jump at the start).
export function trackItems(d, timeline, { bounds, names = {}, single = false, title = "" }) {
  const { pos } = timeline;
  const first = bounds[0], lastB = bounds[bounds.length - 1];
  let cuts = single ? [first, lastB] : [...bounds];
  cuts = cuts.filter((b, i) => i === 0 || i === cuts.length - 1 || !d.notes.some((n) => n.pos < pos(b) - 0.3 && n.pos + n.len > pos(b) + 0.01));
  const out = [];
  for (let i = 0; i < cuts.length - 1; i++) {
    const a = cuts[i], b = cuts[i + 1], p0 = pos(a), p1 = pos(b);
    const isFirst = i === 0, isLast = i === cuts.length - 2;
    const inSeg = (p) => (isFirst || p >= p0 - 0.3) && (isLast || p < p1 - 0.3);
    const notes = d.notes.filter((n) => inSeg(n.pos)).map((n) => ({ pitch: n.pitch, beat: +Math.max(0, n.pos - p0).toFixed(4), len: +(n.len - Math.max(0, p0 - n.pos)).toFixed(4), vel: n.vel }));
    if (!notes.length) continue;
    const ccs = d.cc.filter((c) => c.pos >= p0 - 1e-6 && (isLast || c.pos < p1 - 1e-6))
      .map((c) => (c.pb !== undefined ? { beat: +(c.pos - p0).toFixed(4), pb: c.pb } : { beat: +(c.pos - p0).toFixed(4), cc: c.cc, value: clamp(c.value, 0, 127) }));
    const nums = new Set(d.cc.filter((c) => c.cc !== undefined).map((c) => c.cc));
    for (const num of nums) {
      if (ccs.some((c) => c.cc === num && c.beat < 0.01)) continue;
      const pts = d.cc.filter((c) => c.cc === num).sort((x, y) => x.pos - y.pos);
      const before = pts.filter((c) => c.pos <= p0).pop(), after = pts.find((c) => c.pos > p0);
      let v = num === 64 ? 0 : undefined;
      if (before && after && num !== 64) v = Math.round(before.value + ((after.value - before.value) * (p0 - before.pos)) / (after.pos - before.pos));
      // the sustain pedal (CC64) always starts lifted, never inherited from the previous passage
      else if (before && num !== 64) v = before.value; else if (after && num !== 64) v = after.value;
      if (v !== undefined) ccs.unshift({ beat: 0, cc: num, value: clamp(v, 0, 127) });
    }
    // item length: up to the bound or until the last note is covered (whole bars)
    const endQ = Math.max(p1 - p0, ...notes.map((n) => n.beat + n.len)) + p0;
    let endBar = b;
    while (pos(endBar) < endQ - 1e-6) endBar++;
    out.push({ bar: a, bars: endBar - a, name: cuts.length > 2 ? names[a] ?? `c.${a}` : title, notes, cc: ccs });
  }
  return out;
}

export const replaceMidi = (track, items) => ({ type: "replace_midi", track, midi: items });
export const fileNameOf = (track) => track.replace(/[^A-Z0-9]+/gi, "_");

// build_beat spec from the tempo map, markers and track specs ({ name, color, folder, volume_db, pan, sends, fx }).
export function buildSpec(timeline, { tracks = [], markers = [] } = {}) {
  const [c0, ...rest] = timeline.changes;
  return {
    type: "build_beat", tempo: c0.bpm, timesig: [c0.num || 4, c0.den || 4],
    tempo_changes: rest.map((c) => ({ bar: c.bar, bpm: c.bpm, ...(c.num ? { timesig: [c.num, c.den] } : {}) })),
    tracks, markers
  };
}

// Write out/midi.json, out/cmd/<track>.json (replace_midi each) and, if given, out/build.json.
export function writeBridgeFiles(dir, midi, build) {
  mkdirSync(join(dir, "cmd"), { recursive: true });
  writeFileSync(join(dir, "midi.json"), JSON.stringify(midi));
  for (const [t, its] of Object.entries(midi)) writeFileSync(join(dir, "cmd", `${fileNameOf(t)}.json`), JSON.stringify(replaceMidi(t, its)));
  if (build) writeFileSync(join(dir, "build.json"), JSON.stringify(build));
}
