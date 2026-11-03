// The written score: per-track notes, CC points, dynamic curves and phrase marks, positioned on a timeline.
// Notes: { pos, len, pitch, acc?, vel?, keep?, ks?, slur?, start?, line?, gliss?, grace?, ... }.
// Dynamics use the CC1-like scale pp 20, p 35, mp 50, mf 65, f 85, ff 105, fff 118.
import { clamp } from "./util.js";
import { rampPoints } from "./curves.js";

export function createScore(timeline, tracks = {}) {
  const { pos, barLen } = timeline;
  const track = (name) => (tracks[name] ??= { notes: [], cc: [], dyn: [] });
  const asOpts = (o) => (typeof o === "number" ? { acc: o } : o);

  // single note at bar/beat. o: { acc (relative accent), vel (absolute), keep (no humanize), ...marks }
  const note = (t, bar, beat, len, pitch, o = {}) => noteAt(t, pos(bar, beat), len, pitch, o);
  const noteAt = (t, p, len, pitch, o = {}) => {
    const n = { pos: p, len, pitch, ...asOpts(o) };
    track(t).notes.push(n);
    return n;
  };
  // several pitches at once (divisi, piano); voice index and top flag on each
  const chord = (t, bar, beat, len, pitches, o = {}) => {
    pitches.forEach((p, i) => note(t, bar, beat, len, p, { ...o, voice: i, top: i === pitches.length - 1 }));
  };
  const cc = (t, p, num, value) => track(t).cc.push({ pos: p, cc: num, value: clamp(value, 0, 127) });
  const pb = (t, p, value) => track(t).cc.push({ pos: p, pb: Math.round(value) });
  const ramp = (t, p0, v0, p1, v1, num = 1, step = 0.5) => {
    for (const pt of rampPoints(p0, v0, p1, v1, step)) cc(t, pt.pos, num, pt.value);
  };

  // Melodic line: spec = [[pitch|null, len, opts?], ...]. Marks slurs and phrase starts.
  // opts: { tie: false (re-articulate) | "start", acc, gliss, grace }. o: { tr, acc, legato: false, id }
  function line(t, bar, beat, spec, o = {}) {
    let p = pos(bar, beat);
    const out = [];
    spec.forEach(([pitch, len, opt = {}], i) => {
      if (pitch !== null) {
        const next = spec[i + 1], prev = spec[i - 1];
        const start = !prev || prev[0] === null || prev[2]?.tie === false || opt.tie === "start";
        const slur = !!next && next[0] !== null && opt.tie !== false && next[2]?.tie !== "start" && (o.legato !== false);
        const n = { pos: p, len, pitch: pitch + (o.tr || 0), acc: (opt.acc || 0) + (o.acc || 0), slur, start,
          line: true, gliss: !!opt.gliss, grace: !!opt.grace, phraseId: o.id };
        track(t).notes.push(n);
        out.push(n);
      }
      p += len;
    });
    return out;
  }

  // Dynamic curve for one or more tracks: pts [[bar, beat, value], ...]; two points at one position = subito.
  function dyn(tracksArg, pts) {
    for (const t of [].concat(tracksArg)) for (const [bar, beat, v] of pts) track(t).dyn.push({ pos: pos(bar, beat), value: v });
  }

  // Harmony by bar: harm(5, ["Dm", ["Gm", 2, "A7", 2]]) → rows { bar, beat, sym, len, pos }.
  function harm(startBar, entries) {
    const rows = [];
    entries.forEach((e, i) => {
      const bar = startBar + i;
      if (typeof e === "string") rows.push({ bar, beat: 0, sym: e, len: barLen(bar), pos: pos(bar, 0) });
      else { let b = 0; for (let k = 0; k < e.length; k += 2) { rows.push({ bar, beat: b, sym: e[k], len: e[k + 1], pos: pos(bar, b) }); b += e[k + 1]; } }
    });
    return rows;
  }
  const progression = (rows) => rows.map(([bar, beat, sym, len]) => ({ bar, beat, sym, len, pos: pos(bar, beat) }));

  return { timeline, tracks, track, note, noteAt, chord, cc, pb, ramp, line, dyn, harm, progression };
}
