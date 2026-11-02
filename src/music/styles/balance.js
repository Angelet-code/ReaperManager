// Contextual balance made with the performance, never with faders (user rule, orchestral-balance-by-midi).
// Piece rules: [track, fromBar, toBar (inclusive), dB]; rules add up and ramp over half a beat at the edges.
// The track's profile says how a dB becomes MIDI (cfg.trim.method):
//   cc11-then-cc1      expression as gain (×10^(dB/40)) kept in [floor, 127]; what doesn't fit goes to the
//                      dynamics CC at cc1PerDb points per dB (the player really plays louder or softer)
//   cc11-and-velocity  expression gain (floor 70) plus velocity × velPerDb (shorts)
//   modeled-cc11       expression at ccPerDb points per dB, scaled down at low levels so phrase ends still decay
//   velocity           velocity × velPerDb (piano, percussion, drums)
import { clamp } from "../core/util.js";
import { interp } from "../core/curves.js";

export function trimCurve(name, rules, timeline) {
  const rs = rules.filter(([t]) => t === name).map(([, a, b, db]) => ({ p0: timeline.pos(a, 0), p1: timeline.pos(b + 1, 0), db }));
  if (!rs.length) return null;
  const f = (p) => rs.reduce((s, r) => {
    if (p < r.p0 - 0.5 || p > r.p1 + 0.5) return s;
    const k = p < r.p0 ? (p - (r.p0 - 0.5)) / 0.5 : p > r.p1 ? 1 - (p - r.p1) / 0.5 : 1;
    return s + r.db * k;
  }, 0);
  f.edges = rs.flatMap((r) => [r.p0 - 0.5, r.p0, r.p1, r.p1 + 0.5]);
  return f;
}

export function applyBalance(name, d, cfg, ctx) {
  const t = trimCurve(name, ctx.balance, ctx.timeline);
  if (!t) return;
  const ccOf = (num) => interp(d.cc.filter((c) => c.cc === num).map((c) => ({ pos: c.pos, value: c.value })), null);
  const span = d.notes.length ? [Math.min(...d.notes.map((n) => n.pos)), Math.max(...d.notes.map((n) => n.pos + n.len))] : [0, 0];
  const exCc = cfg.expression?.cc ?? 11, dynCc = cfg.dynamics?.cc ?? 1;
  // extra points at the edges so the trim starts and ends where it should
  for (const num of [exCc, dynCc]) {
    const f = ccOf(num);
    if (!d.cc.some((c) => c.cc === num)) continue;
    for (const e of t.edges) if (e > span[0] && e < span[1]) d.cc.push({ pos: e, cc: num, value: Math.round(f(e)) });
  }
  const tr = cfg.trim || { method: "velocity", velPerDb: 3 };
  if (tr.method === "cc11-then-cc1" || tr.method === "cc11-and-velocity") {
    const short = tr.method === "cc11-and-velocity";
    const f11 = ccOf(exCc);
    for (const c of d.cc) if (c.cc === exCc) c.value = Math.max(tr.cc11Floor, Math.min(127, Math.round(c.value * 10 ** (t(c.pos) / 40))));
    if (!short) for (const c of d.cc) if (c.cc === dynCc) {
      const v11 = f11(c.pos) ?? 110, want = v11 * 10 ** (t(c.pos) / 40);
      const got = Math.max(tr.cc11Floor, Math.min(127, want));
      c.value = clamp(c.value + 40 * Math.log10(want / got) * tr.cc1PerDb);
    }
    if (short) for (const n of d.notes) if (!n.ks) n.vel = clamp(n.vel + t(n.pos) * tr.velPerDb);
  } else if (tr.method === "modeled-cc11") {
    const per = tr.ccPerDb || 6;
    for (const c of d.cc) if (c.cc === exCc) c.value = clamp(c.value + t(c.pos) * per * Math.min(1, Math.max(0.25, c.value / 90)), 6, 127);
  } else {
    for (const n of d.notes) if (!n.ks) n.vel = clamp(n.vel + t(n.pos) * (tr.velPerDb ?? 3));
  }
}
