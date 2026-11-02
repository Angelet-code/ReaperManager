// Small numeric helpers shared by the music engine.

// Round and clamp to a MIDI range (1–127 by default, as note velocities).
export const clamp = (v, lo = 1, hi = 127) => Math.max(lo, Math.min(hi, Math.round(v)));
export const clampf = (v, lo, hi) => Math.max(lo, Math.min(hi, v));
export const sortedNotes = (ns) => [...ns].sort((a, b) => a.pos - b.pos || a.pitch - b.pitch);
export const round4 = (v) => +v.toFixed(4);

// Deep merge of plain objects (arrays and scalars replace).
export function merge(...objs) {
  const out = {};
  for (const o of objs) {
    if (!o) continue;
    for (const [k, v] of Object.entries(o)) {
      if (v && typeof v === "object" && !Array.isArray(v) && out[k] && typeof out[k] === "object" && !Array.isArray(out[k])) out[k] = merge(out[k], v);
      else out[k] = v;
    }
  }
  return out;
}
