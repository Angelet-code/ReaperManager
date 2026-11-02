// Timing feel: a shared band drift (one drummer), MPC-style swing and per-track humanization. These are the
// offline versions of the bridge's swing_midi / humanize_midi / lock_midi: same maths, but applied while
// generating, so the output is reproducible and testable. The bridge commands remain for editing live MIDI.

// Smooth random walk shared by the whole band, sampled per beat (folk metal generators): ±maxQn.
// rnd: a stream ({ rr }). Returns drift(pos) in qn.
export function bandDrift(rnd, beats, { maxQn = 0.012, step = 0.006, keep = 0.85 } = {}) {
  const pts = [];
  let v = 0;
  for (let i = 0; i <= beats + 8; i++) { v = Math.max(-maxQn, Math.min(maxQn, v * keep + rnd.rr(step))); pts.push(v); }
  return (t) => {
    const i = Math.floor(Math.max(0, t)), f = t - i;
    return (pts[i] ?? 0) * (1 - f) + (pts[i + 1] ?? 0) * f;
  };
}

// MPC-style swing on note positions (qn), as swing_midi: off-beats of the grid move later by
// (2·amount − 1)·grid; notes near on-beats stay (or snap with quantize). keep = human deviation kept (qn).
// Short grace notes ending where another note starts follow their main note.
export function swing(notes, { amount = 0.58, grid = 0.25, keep = 0.012, quantize = false, skip = () => false } = {}) {
  if (amount > 1) amount /= 100;
  const delta = (2 * amount - 1) * grid;
  const starts = notes.map((n) => n.pos);
  for (const n of notes) {
    const end = n.pos + n.len;
    const ornament = n.len < 0.1 && starts.some((o) => o > n.pos + 0.001 && Math.abs(o - end) < 0.012);
    const anchor = ornament ? end : n.pos;
    const step = Math.round(anchor / grid);
    const dev = anchor - step * grid;
    const near = step % 2 === 1 ? dev > -Math.min(grid * 0.36, 0.09) && dev < grid * 0.38 : Math.abs(dev) < Math.min(grid * 0.4, 0.09);
    if (near && (step % 2 === 1 || quantize) && !skip(anchor)) {
      const human = Math.max(-keep, Math.min(keep, dev));
      const target = step * grid + (step % 2 === 1 ? delta : 0) + human;
      n.pos += target - anchor;
    }
  }
  return notes;
}

// Per-track humanization: constant push/lay-back, random ±, slow sine drift over ~4 bars, velocity ±.
// Notes starting within 15 ms of each other (a chord) move together. ms values at the local tempo.
export function humanizeNotes(notes, timeline, rnd, { offsetMs = 0, timingMs = 0, driftMs = 0, velocity = 0 } = {}) {
  const phase = rnd.rnd() * Math.PI * 2;
  let groupPos = null, shift = 0;
  for (const n of [...notes].sort((a, b) => a.pos - b.pos)) {
    if (n.ks || n.keep) continue;
    if (groupPos === null || Math.abs(timeline.secOf(n.pos) - timeline.secOf(groupPos)) > 0.015) {
      groupPos = n.pos;
      const ms = offsetMs + rnd.rr(timingMs) + Math.sin((n.pos / 16) * Math.PI * 2 + phase) * driftMs;
      shift = timeline.ms2qn(ms, n.pos);
    }
    n.pos = Math.max(0, n.pos + shift);
    if (velocity && n.vel !== undefined) n.vel = Math.max(1, Math.min(127, Math.round(n.vel + rnd.rr(velocity))));
  }
  return notes;
}
