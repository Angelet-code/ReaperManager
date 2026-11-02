// Curve primitives over { pos, value } points (pos in qn).

// Linear interpolation over points; two points at the same position make a step (subito).
export function interp(pts, fallback) {
  const s = [...pts].sort((a, b) => a.pos - b.pos);
  return (p) => {
    if (!s.length) return fallback;
    if (p <= s[0].pos) return s[0].value;
    for (let i = 1; i < s.length; i++) if (p < s[i].pos || (p === s[i].pos && i === s.length - 1)) {
      const a = s[i - 1], b = s[i];
      if (b.pos - a.pos < 1e-6) return b.value;
      return a.value + ((b.value - a.value) * (p - a.pos)) / (b.pos - a.pos);
    }
    return s[s.length - 1].value;
  };
}

// Linear ramps as REAPER plays them (used to resample an existing CC lane).
export function linear(pts) {
  const s = [...pts].sort((a, b) => a.pos - b.pos);
  return (p) => {
    if (!s.length) return 0;
    if (p <= s[0].pos) return s[0].value;
    for (let i = 1; i < s.length; i++) if (s[i].pos >= p) { const a = s[i - 1], b = s[i]; return a.value + ((b.value - a.value) * (p - a.pos)) / Math.max(1e-9, b.pos - a.pos); }
    return s[s.length - 1].value;
  };
}

// Drop points that a straight line between their neighbours already gives (within 1 unit).
export const thin = (pts) => pts.filter((p, i) => {
  if (i === 0 || i === pts.length - 1) return true;
  const a = pts[i - 1], b = pts[i + 1];
  const f = (p.pos - a.pos) / Math.max(1e-6, b.pos - a.pos);
  return Math.abs(a.value + (b.value - a.value) * f - p.value) >= 1;
});

// Points of a straight ramp, one every `step` qn (both ends included).
export function rampPoints(p0, v0, p1, v1, step = 0.5) {
  const n = Math.max(1, Math.round((p1 - p0) / step));
  const out = [];
  for (let i = 0; i <= n; i++) out.push({ pos: p0 + ((p1 - p0) * i) / n, value: v0 + ((v1 - v0) * i) / n });
  return out;
}

// Smoothstep 0..1, for shapes between anchors.
export const smooth = (x) => x * x * (3 - 2 * x);

// Phrase arc: 0 at the ends, 1 at `peakAt` (share of the phrase), sine-shaped. skew < 1 pulls the peak earlier
// the way performance B does (x^0.7 puts the sine's top at ~0.37).
export const arc = (x, skew = 1) => Math.sin(Math.PI * (skew === 1 ? x : Math.pow(Math.min(1, Math.max(0, x)), skew)));
