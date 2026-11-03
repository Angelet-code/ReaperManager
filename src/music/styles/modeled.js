// Modeled solo instruments (SWAM type). Winds: one continuous expression curve per phrase (no dips between
// slurred notes), CC1 = vibrato, velocity on a slurred note = portamento time (high = clean), on an attacked
// note = attack hardness. Strings: the same, with a small expression dip at bow changes.
// Performance B (user-taste R17): slur velocity by note length, expression leads the note-on from 60 % of
// its target, early phrase peak, short final fall, human timing.
import { clamp } from "../core/util.js";
import { interp } from "../core/curves.js";
import { sortNotes } from "./breath.js";
import { events, phrasesOf, unslurRepeats } from "./phrases.js";
import { breathLayer } from "./breath-layer.js";

export function performModeled(name, d, cfg, ctx) {
  const { timeline: { ms2qn, secs }, options } = ctx;
  const r = ctx.rng(name, "humanize");
  const string = cfg.kind === "string";
  const ex = cfg.expression, vib = cfg.vibrato, vel = cfg.velocity, lg = cfg.legato;
  const D = interp(d.dyn, 60);
  const ns = sortNotes(d.notes);
  unslurRepeats(ns);
  ctx.breaths.plan(name, cfg.stamina, ns, D);
  // durations: overlap on slurs, a gap on articulated notes (clean re-articulation)
  const [j1, j2] = cfg.timing.jitterMs;
  const [ov0, ov1] = lg.overlapMs;
  ns.forEach((n, i) => {
    const nx = ns[i + 1];
    n.pos = Math.max(0, n.pos + ms2qn(r.rr(j1) + r.rr(j2), n.pos));
    if (n.slur && nx) n.len = nx.pos - n.pos + ms2qn(ov0 + Math.abs(r.rr(ov1 - ov0)), nx.pos);
    else if (nx && nx.pos - (n.pos + n.len) < ms2qn(lg.tightMs, n.pos)) n.len = Math.max(0.05, nx.pos - n.pos - ms2qn(lg.gapMs, n.pos));
  });
  const evs = events(ns);
  // the vibrato of a slurred note may not pass the start of the next one (the overlap lengthens the note and
  // REAPER would sort its points after the next attack: a drop to 0 and a bounce)
  const nextPos = new Map(evs.map((e, i) => [e, evs[i + 1] ? evs[i + 1].pos : Infinity]));
  const [mapOff, mapK] = ex.dynMap;
  const toCC = (v) => mapOff + v * mapK;
  d.cc = d.cc.filter((c) => c.cc !== ex.cc && c.cc !== vib.cc);
  const sv = vel.slur;
  let prevEnd = -Infinity;
  for (const ph of phrasesOf(evs)) {
    const p0 = ph[0].pos, p1 = ph[ph.length - 1].pos + ph[ph.length - 1].len;
    const pitches = ph.map((e) => e.notes[0].pitch), mean = pitches.reduce((a, b) => a + b, 0) / pitches.length;
    ph.forEach((e, i) => {
      const n = e.notes[0];
      const slurredIn = i > 0 && ph[i - 1].notes[0].slur;
      if (n.grace) n.vel = vel.grace;
      else if (slurredIn && !n.gliss) {
        // slur velocity (portamento time) by note length; some instruments have a floor (horn: 2.4 s portamento)
        const dur = secs(e.len, e.pos);
        const base = (dur < sv.fastSec ? sv.fast : dur < sv.midSec ? sv.mid : sv.slow) + (string ? sv.stringOffset : 0);
        n.vel = clamp(Math.max(sv.floor || 0, base + r.rr(sv.jitter)));
      } else if (slurredIn) n.vel = vel.gliss + Math.round(r.rr(4));
      else n.vel = clamp(vel.attack.base + D(e.pos) * vel.attack.perDyn + (n.acc || 0) + r.rr(vel.attack.jitter));
    });
    const tg = [];
    let vlev = 0;
    const lead = ex.lead, atkMs = ex.attackMs, ln = ex.longNote;
    ph.forEach((e, i) => {
      const n = e.notes[0];
      const contour = (n.pitch - mean) * ex.contour;
      const x = (e.pos - p0 + e.len / 2) / Math.max(0.1, p1 - p0);
      // the phrase peak comes early (~0.37 of the phrase)
      const arc = ex.arc * Math.sin(Math.PI * Math.pow(Math.min(1, Math.max(0, x)), ex.arcSkew));
      const target = clamp(toCC(D(e.pos)) + contour + arc + (n.acc || 0) * 0.5, ex.floor, 127);
      const slurredIn = i > 0 && ph[i - 1].notes[0].slur;
      tg.push(target);
      const atk = i === 0 ? Math.min(ms2qn(string ? atkMs.string : atkMs.wind, e.pos), e.len * 0.3) : ms2qn(atkMs.inPhrase, e.pos);
      // the expression already moves before the note-on, from 60 % of the target
      if (i === 0) d.cc.push({ pos: Math.min(p0 - 0.005, Math.max(prevEnd + 0.02, p0 - ms2qn(string ? lead.stringMs : lead.windMs, p0), 0)), cc: ex.cc, value: clamp(target * lead.from, ex.floor) });
      if (i > 0 && !slurredIn) d.cc.push({ pos: e.pos, cc: ex.cc, value: clamp(target - (string ? ex.rearticulationDip.string : ex.rearticulationDip.wind)) });
      d.cc.push({ pos: e.pos + atk, cc: ex.cc, value: target });
      const dur = secs(e.len, e.pos);
      if (dur >= ln.minSec) {
        d.cc.push({ pos: e.pos + e.len * 0.55, cc: ex.cc, value: clamp(target + (dur >= ln.bigSec ? ln.bump[1] : ln.bump[0])) });
        d.cc.push({ pos: e.pos + e.len * 0.88, cc: ex.cc, value: clamp(target + ln.late) });
      }
      const depth = vib.depth * (0.55 + D(e.pos) / 180);
      if (options.vibrato === "note") {
        // per note (La Forja v3): only an attacked wind note starts without vibrato
        if (dur >= vib.minSec) {
          const dl = Math.min(ms2qn(vib.delaySec * 1000, e.pos), e.len * 0.45);
          const cut = nextPos.get(e) - 0.01;
          d.cc.push({ pos: e.pos, cc: vib.cc, value: string ? clamp(depth * 0.25, 0) : slurredIn ? clamp(depth * 0.3, 0) : 0 }, { pos: e.pos + dl, cc: vib.cc, value: clamp(depth * 0.35, 0) },
            { pos: Math.min(e.pos + e.len * 0.75, cut - 0.01), cc: vib.cc, value: clamp(depth, 0) }, { pos: Math.min(e.pos + e.len, cut), cc: vib.cc, value: clamp(depth * 0.7, 0) });
        } else d.cc.push({ pos: e.pos, cc: vib.cc, value: string ? clamp(depth * 0.3, 0) : slurredIn ? clamp(depth * 0.3, 0) : 0 });
      } else {
        // per phrase: delayed onset only on the first note of the phrase (or after a breath); inside the phrase it
        // carries on, barely yielding at slurs and bow changes, a little more at a wind re-articulation
        const keep = slurredIn || string;
        const into = i === 0 ? (string ? depth * (dur >= vib.minSec ? 0.25 : 0.3) : 0) : Math.max(vlev * (keep ? 0.95 : 0.8), depth * (keep ? 0.6 : 0.45));
        d.cc.push({ pos: e.pos, cc: vib.cc, value: clamp(into, 0) });
        if (dur >= vib.minSec) {
          const cut = nextPos.get(e) - 0.01;
          if (i === 0) d.cc.push({ pos: e.pos + Math.min(ms2qn(vib.delaySec * 1000, e.pos), e.len * 0.45), cc: vib.cc, value: clamp(depth * 0.35, 0) });
          d.cc.push({ pos: Math.min(e.pos + e.len * 0.75, cut - 0.01), cc: vib.cc, value: clamp(depth, 0) });
          if (i === ph.length - 1) d.cc.push({ pos: Math.min(e.pos + e.len, cut), cc: vib.cc, value: clamp(depth * 0.7, 0) });
          vlev = depth;
        } else vlev = into;
      }
    });
    // end of phrase: a short, moderate fall before the note-off; the note-off does the rest
    const tl = ex.tail, lt = tg[tg.length - 1], tail = Math.min(ms2qn(string ? tl.stringMs : tl.windMs, p1), (p1 - p0) * 0.2);
    d.cc.push({ pos: p1 - tail, cc: ex.cc, value: clamp(lt) }, { pos: p1, cc: ex.cc, value: clamp(Math.max(string ? tl.floor.string : tl.floor.wind, lt - tl.fall)) });
    prevEnd = p1;
    const pbc = cfg.pitchBend;
    if (pbc?.scoop && ph[0].notes[0].scoop !== false && secs(ph[0].len, p0) > 0.5) {
      const per = 8192 / pbc.range;
      d.cc.push({ pos: Math.max(0, p0 - 0.01), pb: -Math.round(pbc.scoop * per) }, { pos: p0 + ms2qn(120, p0), pb: 0 });
    }
  }
  if (options.swamBreath && cfg.breathLayer) breathLayer(name, d, cfg, ctx, evs, options.swamBreath);
}
