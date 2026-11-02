// Writing helpers with no library in them: voice-led pads (common tones held), bass lines, harp-like piano
// arpeggios, piano rolls and syncopated pedal, and a pizzicato bass that stays on chord tones.
import { voice, bassNote, chordPitches, parseChord } from "../core/pitch.js";

export function orchestraWriters(score) {
  const { noteAt, note, cc, timeline: { pos, ms2qn } } = score;

  // prog: rows from harm()/progression(). Writes n voices in [lo, hi]; returns the voicings.
  // opt: { center, maxTop, minTop, top: fn(row) → forced top, acc, hold (join common tones, default true), cluster, bassCovers, prev }
  function pad(t, prog, n, lo, hi, opt = {}) {
    let prev = opt.prev || null;
    const held = new Array(n).fill(null);
    const out = [];
    for (const row of prog) {
      if (row.sym === "-") { held.fill(null); prev = null; continue; }
      const top = opt.top ? opt.top(row) : undefined;
      const v = voice(row.sym, n, lo, hi, prev, { center: opt.center, maxTop: opt.maxTop, minTop: opt.minTop, top, cluster: opt.cluster, bassCovers: opt.bassCovers });
      const p = row.pos ?? pos(row.bar, row.beat);
      v.forEach((pitch, i) => {
        const h = held[i];
        if (opt.hold !== false && h && h.pitch === pitch && Math.abs(h.pos + h.len - p) < 0.02) { h.len += row.len; return; }
        held[i] = noteAt(t, p, row.len, pitch, { acc: (opt.acc || 0) + (i === n - 1 ? 3 : 0), voice: i });
      });
      out.push({ ...row, v });
      prev = v;
    }
    return out;
  }

  // bass: each chord's bass note, nearest to the previous one inside [lo, hi]; repeated notes are joined
  function bass(t, prog, lo, hi, opt = {}) {
    let near = opt.near ?? Math.round((lo + hi) / 2), last = null;
    for (const row of prog) {
      if (row.sym === "-") { last = null; continue; }
      const p = row.pos ?? pos(row.bar, row.beat);
      const b = bassNote(row.sym, near, lo, hi);
      if (opt.hold !== false && last && last.pitch === b && Math.abs(last.pos + last.len - p) < 0.02) last.len += row.len;
      else last = noteAt(t, p, row.len, b, { acc: opt.acc || 0 });
      near = b;
    }
  }

  // Harp-like piano arpeggio, up and down per chord. per = notes per beat (2 eighths, 3 triplets, 4 sixteenths).
  // Keep lo at C3 (48) or above: lower, the thirds and seconds turn to mud (La Forja c.64 review).
  function harpArp(t, prog, lo, hi, opt = {}) {
    const per = opt.per || 2;
    for (const row of prog) {
      if (row.sym === "-") continue;
      const tones = chordPitches(row.sym, lo, hi);
      const p0 = row.pos ?? pos(row.bar, row.beat);
      const steps = Math.round(row.len * per);
      const up = [...tones], cyc = up.concat(up.slice(1, -1).reverse());
      for (let i = 0; i < steps; i++) {
        const pitch = opt.upOnly ? up[i % up.length] : cyc[i % cyc.length];
        const len = Math.min((opt.ring || 1.5) / per, row.len - i / per + 0.05);
        noteAt(t, p0 + i / per, len, pitch, { acc: (i % per === 0 ? 4 : -2) + (opt.acc || 0) });
      }
      if (opt.pedal !== false) pedal(t, p0, p0 + row.len);
    }
  }
  // piano chord rolled from the bottom, notes `ms` apart
  function roll(t, p, len, pitches, ms = 28, acc = 0) {
    [...pitches].sort((a, b) => a - b).forEach((pitch, i) => noteAt(t, p + ms2qn(i * ms, p), len - ms2qn(i * ms, p), pitch, { acc, roll: true, keep: true }));
  }
  // syncopated sustain pedal: up right at the change, down 60 ms later
  function pedal(t, p0, p1) {
    cc(t, Math.max(0, p0 - 0.01), 64, 0);
    cc(t, p0 + ms2qn(60, p0), 64, 127);
    cc(t, p1 - 0.02, 64, 127);
  }

  // Pizzicato bass: the chord's bass on the downbeat; in a 3-beat chord a second note on beat 3 taken from the
  // chord's root or fifth (never "bass + 7", which leaves the chord on inverted chords). The bass note is
  // taken from [lo, hi] (one per pitch class with the defaults), the second note from [lo, top].
  function pizzBass(t, rows, { lo = 40, hi = 51, top = 52, acc = 0, near = 46 } = {}) {
    let last = near;
    for (const r of rows) {
      const ch = parseChord(r.sym);
      const b = bassNote(r.sym, last, lo, hi) ?? last;
      note(t, r.bar, r.beat, 0.5, b, { acc: acc + (r.beat === 0 ? 4 : -2) });
      if (r.len === 3) {
        const want = b + 7 > top ? b - 5 : b + 7;
        const opts = [];
        for (let p = lo; p <= top; p++) if ((p % 12 === ch.root || p % 12 === (ch.root + 7) % 12) && p % 12 !== b % 12) opts.push(p);
        opts.sort((x, y) => Math.abs(x - want) - Math.abs(y - want));
        note(t, r.bar, 2, 0.4, opts[0] ?? want, { acc: acc - 10 });
      }
      last = b;
    }
  }

  return { pad, bass, harpArp, roll, pedal, pizzBass };
}
