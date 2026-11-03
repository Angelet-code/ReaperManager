// Velocity-driven styles: sampled shorts, piano and percussion.
import { clamp } from "../core/util.js";
import { interp, thin } from "../core/curves.js";
import { sortNotes } from "./breath.js";
import { events } from "./phrases.js";
import { swing } from "../core/humanize.js";

// Shorts (spiccato, staccato, pizzicato, short brass/woods, plucked): dynamics = velocity from the curve;
// the expression CC smooths hairpins between attacks.
export function performShort(name, d, cfg, ctx) {
  const { ms2qn } = ctx.timeline;
  const r = ctx.rng(name, "humanize");
  const D = interp(d.dyn, 70);
  const v = cfg.velocity, hum = cfg.humanize?.ms ?? 0;
  for (const n of d.notes) {
    if (n.ks) continue;
    if (!n.keep) n.pos = Math.max(0, n.pos + ms2qn(r.rr(hum), n.pos) + (cfg.feel?.followBand ? ctx.band()(n.pos) : 0));
    n.vel = n.vel !== undefined ? clamp(n.vel + r.rr(v.keepJitter)) : clamp(D(n.pos) + v.offset + (n.acc || 0) + r.rr(v.jitter));
    n.len = Math.max(v.minLenQn, n.len);
  }
  const ns = sortNotes(d.notes.filter((n) => !n.ks));
  const hp = cfg.expression?.hairpin;
  if (!ns.length || !hp || cfg.expression.cc == null) return;
  const pts = [];
  const end = Math.max(...ns.map((n) => n.pos + n.len));
  for (let p = Math.floor(ns[0].pos); p <= end + 1; p += 1) pts.push({ pos: p, value: clamp(hp.center + (D(p) - 64) * hp.perDyn, hp.floor, 127) });
  thin(pts).forEach((c) => d.cc.push({ pos: c.pos, cc: cfg.expression.cc, value: c.value }));
}

// Piano: chords move together, the top voice sings, the bass is a little louder than inner voices.
export function performPiano(name, d, cfg, ctx) {
  const { ms2qn } = ctx.timeline;
  const r = ctx.rng(name, "humanize");
  const D = interp(d.dyn, 50);
  const v = cfg.velocity, h = cfg.humanize;
  for (const g of events(d.notes)) {
    const top = Math.max(...g.notes.map((n) => n.pitch)), bottom = Math.min(...g.notes.map((n) => n.pitch));
    const shift = ms2qn(r.rr(h.ms), g.pos);
    for (const n of g.notes) {
      if (!n.keep) n.pos = Math.max(0, n.pos + shift + (n.roll ? 0 : ms2qn(r.rr(h.noteMs), n.pos)));
      const weight = n.pitch === top && g.notes.length > 1 ? v.top : n.pitch === bottom ? v.bottom : v.inner;
      n.vel = n.vel !== undefined ? clamp(n.vel + r.rr(v.keepJitter)) : clamp(D(n.pos) * v.perDyn + v.offset + weight + (n.acc || 0) + r.rr(v.jitter));
    }
  }
}

// Percussion: the composer's velocities (absolute) or the dynamic curve; keyswitches untouched.
export function performPercussion(name, d, cfg, ctx) {
  const { ms2qn } = ctx.timeline;
  const r = ctx.rng(name, "humanize");
  const D = interp(d.dyn, 80);
  const v = cfg.velocity, hum = cfg.humanize?.ms ?? 0;
  for (const n of d.notes) {
    if (!n.keep && hum) n.pos = Math.max(0, n.pos + ms2qn(r.rr(hum), n.pos));
    n.vel = n.vel !== undefined ? clamp(n.vel + (n.ks ? 0 : r.rr(v.keepJitter))) : clamp(D(n.pos) + (n.acc || 0) + r.rr(v.jitter));
  }
}

// Band drums: the kit plays as ONE drummer. Every piece rides the shared band drift; groups get their own
// constant placement (snare a few ms behind, hats laid back); optional swing on the written grid first.
// cfg.map: name → note; cfg.groups: group → [names]; cfg.feel: { offsetsMs: { group: ms }, swing: { amount, grid } }.
export function performDrums(name, d, cfg, ctx) {
  const { ms2qn } = ctx.timeline;
  const r = ctx.rng(name, "humanize");
  const D = interp(d.dyn, 100);
  const tf = ctx.options.feel?.[name];
  const feel = { ...(cfg.feel || {}), ...(typeof tf === "object" ? tf : {}) };
  const groupOf = new Map();
  for (const [g, names] of Object.entries(cfg.groups || {})) for (const n of names) if (cfg.map?.[n] !== undefined) groupOf.set(cfg.map[n], g);
  const ns = d.notes.filter((n) => !n.ks);
  if (feel.swing) swing(ns, feel.swing);
  const drift = ctx.band();
  const vj = cfg.humanize?.velocity ?? 0;
  for (const n of ns) {
    if (!n.keep) {
      const off = feel.offsetsMs?.[groupOf.get(n.pitch)] ?? 0;
      n.pos = Math.max(0, n.pos + drift(n.pos) + ms2qn(off, n.pos));
    }
    n.vel = n.vel !== undefined ? clamp(n.vel + r.rr(vj)) : clamp(D(n.pos) + (n.acc || 0) + r.rr(vj));
  }
}
