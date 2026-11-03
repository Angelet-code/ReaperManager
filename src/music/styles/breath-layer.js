// Synthetic breath layer for modeled instruments (La Forja "soplo", SOPLO=1; docs/swam-performance-research.md
// §5). Runs after performModeled() on its expression/vibrato points and never touches notes, velocities or timing.
//   note shape   replaces B's fixed bump (0.55 → +5/+9, 0.88 → +2) with a shape of its own per long note
//   breath       low-band noise (3 sines 0.3–3 Hz + white noise low-passed at ~4 Hz) + slow drift; never 4–8 Hz
//   gesture      push at slurs (up +2–4, down 0–2)
//   vibrato ride the base vibrato ridden per breath segment: ×(1±0.2) slowly, smoothed shape, ±5
// Writes on a 30 ms (expression) / 50 ms (vibrato) grid, only when the integer changes. Off by default: the
// user has not chosen it by ear yet. Options: { end: "B" | "reo", shape, noise, ride, amount, ceil }.
import { clamp } from "../core/util.js";
import { interp, linear, smooth } from "../core/curves.js";
import { phrasesOf } from "./phrases.js";

// the measured residual (against a 300 ms moving average) sees only part of the band: NOISE_CAL makes `rms`
// the residual that played.mjs measures, comparable with played MIDI
const NOISE_CAL = 1.6;

const U = (r, [a, b]) => a + (b - a) * r.rnd();

function shapeOf(rk, ra, F, fam, dur, ctx) {
  if (ctx.repeated) return { pk: 0.5, up: 0, dn: 0, kind: "flat" };
  const draw = rk.rnd(), pkDraw = rk.rnd();
  let kind = draw < (F.mix.messa ?? F.mix.cresc ?? 0) ? (F.mix.messa ? "messa" : "cresc") : "bloom";
  if (ctx.toClimax && F.cresc) kind = "cresc"; // a note rising to the phrase peak grows
  if (ctx.beforeBreath && fam !== "brass") kind = "bloom"; // the last one before a breath (or bow change) dies away
  const S = F[kind] || F.bloom, k = Math.min(1, Math.sqrt(dur / 1.5)); // shorter notes, smaller shape
  return { kind, pk: S.pk[0] + (S.pk[1] - S.pk[0]) * pkDraw, up: U(ra, S.up) * k, dn: U(ra, S.dn) * k };
}
const shapeAt = (sh, x) => (x <= sh.pk ? sh.up * smooth(x / sh.pk) : sh.up - sh.dn * smooth((x - sh.pk) / Math.max(1e-6, 1 - sh.pk)));

function breathNoise(r, n, dt, rms) {
  const sines = [0, 1, 2].map(() => ({ f: U(r, [0.6, 3.5]), ph: r.rnd() * 2 * Math.PI, a: U(r, [0.5, 1]) }));
  const drift = { f: U(r, [0.1, 0.2]), ph: r.rnd() * 2 * Math.PI };
  const al = 1 - Math.exp(-2 * Math.PI * 4 * dt); // one-pole low-pass at ~4 Hz
  let lp = 0;
  const xs = [];
  for (let i = 0; i < n; i++) {
    const t = i * dt;
    lp += al * ((r.rnd() * 2 - 1) - lp);
    xs.push(sines.reduce((s, q) => s + q.a * Math.sin(2 * Math.PI * q.f * t + q.ph), 0) + 2.5 * lp);
  }
  const m = xs.reduce((a, b) => a + b, 0) / Math.max(1, n), sd = Math.sqrt(xs.reduce((a, b) => a + (b - m) ** 2, 0) / Math.max(1, n)) || 1;
  return xs.map((x, i) => ((x - m) / sd) * rms * NOISE_CAL + 2 * Math.sin(2 * Math.PI * drift.f * i * dt + drift.ph));
}

// Core of the layer on plain point lists. notes: final notes (pos/len in qn, slur, pitch, breath);
// cc11/cc1: { pos, value } left by the style; phrases: [[note, ...]]. Returns { cc11, cc1, stats }.
export function breathCurves(fam, F, r, rngKeyed, notes, cc11, cc1, phrases, tm, opts = {}) {
  const o = { end: "B", noise: true, shape: true, ride: true, amount: 1, ceil: 95, ...opts };
  const floor = 8, ceil = o.ceil;
  const out11 = [], out1 = [], stats = { notes: 0, kinds: {} };
  const base1 = linear(cc1);
  const nextOn = new Map(notes.map((n, i) => [n, notes[i + 1] ? notes[i + 1].pos : Infinity]));
  for (const ph of phrases) {
    const p0 = ph[0].pos, last = ph[ph.length - 1], p1 = last.pos + last.len;
    const peakPitch = Math.max(...ph.map((n) => n.pitch));
    // 1) a shape per long note (not the first of the phrase: its attack is B's)
    const shapes = new Map();
    ph.forEach((n, i) => {
      const dur = tm.secs(n.len, n.pos);
      if (!o.shape || i === 0 || dur < 0.6) return;
      // n.group: phrase id shared by doubled lines (same shape draw)
      const rk = n.group != null ? rngKeyed(`${n.group}@${n.pos.toFixed(2)}`) : r;
      const sh = shapeOf(rk, r, F, fam, dur, { repeated: ph[i - 1]?.pitch === n.pitch && ph[i + 1]?.pitch === n.pitch, toClimax: n.pitch === peakPitch && i < ph.length - 1, beforeBreath: n === last || n.breath });
      sh.up *= o.amount; sh.dn *= o.amount;
      shapes.set(n, sh); stats.notes++; stats.kinds[sh.kind] = (stats.kinds[sh.kind] || 0) + 1;
    });
    // B's fixed bump (0.55 and 0.88 of the note) is replaced: those points are ignored when sampling
    const bump = (p) => [...shapes.keys()].some((n) => Math.abs(p - (n.pos + n.len * 0.55)) < 1e-3 || Math.abs(p - (n.pos + n.len * 0.88)) < 1e-3);
    const anchors = cc11.filter((c) => c.pos >= p0 - tm.ms2qn(400, p0) && c.pos <= p1 + 1e-6 && !bump(c.pos));
    const B11 = linear(anchors.length ? anchors : cc11);
    // 2) 30 ms grid from the phrase lead-in to the last note-off
    const start = anchors.length ? Math.min(anchors[0].pos, p0) : p0, dq = tm.ms2qn(30, p0);
    const grid = [];
    for (let p = start; p < p1; p += dq) grid.push(p);
    const nz = o.noise ? breathNoise(r, grid.length, 0.03, F.rms) : grid.map(() => 0);
    const pushes = ph.slice(1).map((n, i) => ({ at: n.pos, amp: ph[i].slur ? U(r, n.pitch > ph[i].pitch ? F.slur : [1, 3]) : 0, w: tm.ms2qn(90, n.pos) }));
    const val = grid.map((p, k) => {
      let v = B11(p);
      const n = ph.find((m) => p >= m.pos && p < m.pos + m.len) || last;
      const sh = shapes.get(n);
      if (sh) v += shapeAt(sh, Math.min(1, Math.max(0, (p - n.pos) / n.len)));
      // noise faded ±60 ms around each note-on and in the lead-in; less noise at pp (more dB per point)
      const dOn = Math.min(...ph.map((m) => Math.abs(p - m.pos)));
      const fade = Math.min(1, dOn / tm.ms2qn(60, p)) * (p < p0 ? 0 : 1);
      const lvl = Math.min(1, Math.max(0.6, (v - 20) / 30 + 0.6));
      v += nz[k] * fade * lvl;
      for (const q of pushes) v += q.amp * Math.exp(-(((p - q.at) / q.w) ** 2));
      return v;
    });
    // phrase end: B (whatever the curve brings) or Reo (fall to 4–17 % of the peak over the last 300–450 ms)
    if (o.end === "reo") {
      const pk = Math.max(...val), tail = Math.min(tm.ms2qn(U(r, [300, 450]), p1), last.len * 0.6), goal = pk * U(r, [0.04, 0.17]);
      grid.forEach((p, k) => { if (p > p1 - tail) { const x = (p - (p1 - tail)) / tail; val[k] = val[k] + (goal - val[k]) * smooth(x); } });
    }
    let prev = null;
    grid.forEach((p, k) => {
      const v = Math.round(Math.min(ceil, Math.max(o.end === "reo" && p > p1 - tm.ms2qn(450, p1) ? 1 : floor, val[k])));
      if (v !== prev) { out11.push({ pos: p, value: v }); prev = v; }
    });
    out11.push({ pos: p1, value: prev ?? floor });
    // 3) vibrato ridden per segment (breath to breath), continuous through slurs
    const segs = [];
    let sg = [];
    ph.forEach((n) => { sg.push(n); if (n.breath || n === last) { segs.push(sg); sg = []; } });
    for (const seg of segs) {
      const s0 = seg[0].pos, sl = seg[seg.length - 1], s1 = Math.min(sl.pos + sl.len, nextOn.get(sl) - 0.01), d1 = tm.ms2qn(50, s0);
      const mw = { f: U(r, [0.15, 0.3]), ph: r.rnd() * 2 * Math.PI }, lf = { f: U(r, [0.5, 1]), ph: r.rnd() * 2 * Math.PI };
      const a = 1 - Math.exp(-0.05 / 0.08); // shape smoothed with τ = 80 ms: no jumps at note changes
      let sm = 0, pv = null;
      for (let p = s0; p < s1; p += d1) {
        let v = base1(p);
        if (o.ride) {
          const n = seg.find((m) => p >= m.pos && p < m.pos + m.len) || sl, sh = shapes.get(n);
          sm += a * ((sh ? shapeAt(sh, Math.min(1, (p - n.pos) / n.len)) / Math.max(4, sh.up) : 0) - sm);
          const t = tm.secs(p - s0, s0);
          // total factor bounded to ±20 %: sway and shape cannot add up to a dip that sounds like a restart
          v = v * Math.min(1.2, Math.max(0.8, (1 + 0.2 * F.vibRide * Math.sin(2 * Math.PI * mw.f * t + mw.ph)) * (1 + 0.25 * Math.max(-1, Math.min(1, sm)))))
            + 5 * F.vibRide * Math.min(1, v / 20) * Math.sin(2 * Math.PI * lf.f * t + lf.ph);
        }
        v = Math.round(Math.max(0, Math.min(127, v)));
        if (v !== pv) { out1.push({ pos: p, value: v }); pv = v; }
      }
    }
  }
  return { cc11: out11, cc1: out1, stats };
}

// Apply the layer to a performed modeled track: keep the same mean expression as B while the notes sound
// (the A/B compares the breath, not the level), rewrite expression inside each phrase (from its lead-in) and
// vibrato inside the notes; outside, B's points stay. Pitch bend is untouched.
export function breathLayer(name, d, cfg, ctx, evs, opts) {
  const fam = cfg.breathLayer, F = cfg.breathShapes?.[fam];
  if (!F) { ctx.warn(`${name}: breath layer family ${fam} has no shapes; layer skipped`); return; }
  const { ms2qn, secs } = ctx.timeline;
  const ex = cfg.expression.cc, vc = cfg.vibrato.cc;
  const o = { end: "B", shape: true, noise: true, ride: true, amount: 1, ceil: 127, ...(typeof opts === "object" ? opts : {}) };
  const nOf = (e) => e.notes[0], phs = phrasesOf(evs).map((ph) => ph.map(nOf));
  const cc11 = d.cc.filter((c) => c.cc === ex), cc1 = d.cc.filter((c) => c.cc === vc);
  const r = ctx.rng(name, "swamBreath");
  const res = breathCurves(fam, F, r, (key) => ctx.rngKeyed(key), evs.map(nOf), cc11, cc1, phs, { secs, ms2qn }, o);
  const fB = interp(cc11.map((c) => ({ pos: c.pos, value: c.value })), null), fS = interp(res.cc11, null);
  let dsum = 0, dn = 0;
  for (const e of evs) for (let p = e.pos; p < e.pos + e.len; p += 0.02) { dsum += fB(p) - fS(p); dn++; }
  const off = dn ? Math.round(dsum / dn) : 0;
  for (const c of res.cc11) c.value = clamp(c.value + off, 1, o.ceil);
  const win = phs.map((ph) => [ph[0].pos - ms2qn(400, ph[0].pos), ph[ph.length - 1].pos + ph[ph.length - 1].len]);
  const keep11 = cc11.filter((c) => !win.some(([a, b]) => c.pos >= a && c.pos <= b + 1e-6));
  const keep1 = cc1.filter((c) => !evs.some((e) => c.pos >= e.pos - 1e-6 && c.pos < e.pos + e.len));
  d.cc = [...d.cc.filter((c) => c.cc !== ex && c.cc !== vc), ...keep11, ...keep1,
    ...res.cc11.map((c) => ({ pos: c.pos, cc: ex, value: c.value })), ...res.cc1.map((c) => ({ pos: c.pos, cc: vc, value: c.value }))];
  ctx.stats[name] = { ...(ctx.stats[name] || {}), breathLayer: res.stats };
}
