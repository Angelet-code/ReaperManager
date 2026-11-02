// Sampled longs and legato (Albion ONE type): CC1 = dynamic layer (section curve + a shape per note),
// CC11 = phrase breath, vibrato CC (CC21) per phrase, release CC (CC17) per section. Slow attacks start early;
// legato patches are monophonic and slur on overlap. All numbers come from the track's resolved profile.
import { clamp } from "../core/util.js";
import { interp, thin } from "../core/curves.js";
import { sortNotes } from "./breath.js";
import { events, phrasesOf, unslurRepeats } from "./phrases.js";

function noteShape(e, dip) {
  const L = e.len, o = e.pos;
  const startDip = e.start ? -dip : -Math.round(dip * 0.4);
  if (L < 0.75) return [[o, startDip * 0.4], [o + L * 0.5, 1], [o + L, e.phraseEnd ? -3 : 0]];
  const peak = L >= 3 ? 8 : L >= 2 ? 6 : 4;
  return [[o, startDip], [o + Math.min(0.35, L * 0.25), -1], [o + L * 0.55, peak], [o + L - 0.2, e.phraseEnd ? -2 : 1], [o + L, e.phraseEnd ? -9 : 0]];
}

export function performSampled(name, d, cfg, ctx) {
  const { timeline: { ms2qn, bpmAt, secs }, options } = ctx;
  const r = ctx.rng(name, "humanize");
  const legato = cfg.style === "sampled-legato";
  const D = interp(d.dyn, 64);
  const ns = sortNotes(d.notes);
  unslurRepeats(ns);
  ctx.breaths.plan(name, cfg.stamina, ns, D);
  const feel = options.feel || {};
  const onBeat = (feel[name] ?? feel.sampled) === "on-beat";
  const lat = cfg.latency;
  const ob = onBeat && lat.onBeat ? lat.onBeat : null;
  const lg = cfg.legato || {};
  // 1) early starts and legato overlaps
  ns.forEach((n, i) => {
    n.nominalEnd = n.pos + n.len;
    let ms = legato && !n.start && !n.afterBreath ? lat.slurMs : lat.attackMs;
    if (ob) {
      // a legato transition only exists if the previous note slurs into this one; otherwise it is an attack
      const prev = ns[i - 1], slurredIn = legato && prev && prev.slur && !n.afterBreath;
      ms = slurredIn ? ob.slurMs ?? ob.attackMs : ob.attackMs;
    }
    const a = ms2qn(ms + (lat.jitterMs ? r.rr(lat.jitterMs) : 0), n.pos);
    n.pos -= Math.min(a, n.pos);
  });
  const vel = cfg.velocity || {};
  if (legato) {
    const m = vel.slurMap || {};
    ns.forEach((n, i) => {
      const nx = ns[i + 1];
      if (n.slur && nx) n.len = nx.pos - n.pos + ms2qn(lg.overlapMs, nx.pos);
      else n.len = n.nominalEnd - n.pos - ms2qn(n.stacc ? lg.staccatoGapMs : lg.releaseGapMs, n.pos);
      // with large early starts, an attacked note that follows must not overlap this one (an unwanted slur)
      if (ob && nx && !n.slur) n.len = Math.max(0.05, Math.min(n.len, nx.pos - n.pos - ms2qn(30, n.pos)));
      // velocity = legato transition speed: fast notes → fast transition (Albion ignores it, measured; kept for
      // libraries where it matters and as part of the validated set)
      const dur = secs(n.nominalEnd - n.pos, n.pos);
      const prev = ns[i - 1];
      const leap = prev && prev.slur ? Math.abs(n.pitch - prev.pitch) : 0;
      // expressive leap at a slow tempo: slow transition (section portamento)
      const slowLeap = leap >= 5 && bpmAt(n.pos) <= 76 && dur >= 0.45;
      n.vel = n.vel ?? (n.start ? clamp(vel.attack.base + D(n.pos) * vel.attack.perDyn + (n.acc || 0))
        : slowLeap ? clamp(m.slowLeap + r.rr(m.leapJitter))
        : clamp((dur < m.fastSec ? m.fast : dur < m.midSec ? m.mid : m.slow) + r.rr(m.jitter)));
    });
  } else {
    for (const n of ns) {
      n.len = n.nominalEnd - n.pos - (n.tieNext ? 0 : ms2qn(lg.releaseGapMs ?? 20, n.pos));
      n.vel = n.vel ?? clamp(D(n.pos) * vel.attack.perDyn + vel.attack.base + (n.acc || 0) + r.rr(vel.attack.jitter));
    }
  }
  const evs = events(ns);
  const dip = cfg.noteShape.dip;
  // 2) dynamics CC = section curve + the shape of each note (in pads the last attack rules)
  const shapes = evs.map((e) => ({ e, f: interp(noteShape(e, dip).map(([pos, value]) => ({ pos, value })), 0) }));
  const offsetAt = (p) => { const s = shapes.filter(({ e }) => p >= e.pos - 1e-6 && p <= e.pos + e.len + 1e-6).pop(); return s ? s.f(p) : 0; };
  const times = new Set();
  for (const e of evs) { for (let p = e.pos; p < e.pos + e.len; p += 0.25) times.add(+p.toFixed(3)); times.add(+(e.pos + e.len).toFixed(3)); }
  for (const { e } of shapes) noteShape(e, dip).forEach(([p]) => times.add(+p.toFixed(3)));
  for (const pt of d.dyn) times.add(+pt.pos.toFixed(3));
  const t1 = [...times].sort((a, b) => a - b);
  const [da, db] = cfg.dynamics.drift || [0, 0];
  const drift = (p) => da * Math.sin(p * 0.83 + name.length) + db * Math.sin(p * 0.31 + name.charCodeAt(0));
  const [k, off] = cfg.dynamics.layerMap || [1, 0];
  const layer = (v) => k * v + off;
  const dynCc = cfg.dynamics.cc;
  thin(t1.map((p) => ({ pos: p, value: clamp(layer(D(p) + offsetAt(p) + drift(p))) }))).forEach((c) => d.cc.push({ pos: c.pos, cc: dynCc, value: c.value }));
  // 3) vibrato
  const vibCc = cfg.vibrato?.cc, scale = cfg.vibrato?.scale ?? 0;
  if (vibCc != null && scale > 0) {
    const vibOf = (e) => ctx.sectionAt(e.pos).vib * scale * (0.6 + D(e.pos) / 250);
    if (options.vibrato === "note") {
      // per note (La Forja v3): delayed onset on every long note
      evs.forEach((e, i) => {
        const vt = vibOf(e);
        const cut = evs[i + 1] ? evs[i + 1].pos : Infinity;
        if (e.len >= 0.9) {
          [[e.pos, vt * 0.2], [e.pos + Math.min(0.6, e.len * 0.35), vt * 0.3], [e.pos + e.len * 0.75, vt], [e.pos + e.len, vt * 0.85]]
            .filter(([p]) => p < cut - 0.01).forEach(([p, v]) => d.cc.push({ pos: p, cc: vibCc, value: clamp(v) }));
        } else d.cc.push({ pos: e.pos, cc: vibCc, value: clamp(vt * 0.45) });
      });
    } else {
      // per phrase: delayed onset only at the start of a phrase (or after a breath) on a long note; inside the
      // phrase it carries on from note to note (no restart on every slur or chord change) and grows on long notes
      for (const ph of phrasesOf(evs)) {
        let level = 0;
        ph.forEach((e, i) => {
          const vt = vibOf(e);
          const cut = ph[i + 1] ? ph[i + 1].pos : Infinity;
          const into = i === 0 ? (e.len >= 0.9 ? vt * 0.2 : vt * 0.45) : Math.max(level * 0.95, vt * 0.6);
          const pts = [[e.pos, into]];
          if (i === 0 && e.len >= 0.9) pts.push([e.pos + Math.min(0.6, e.len * 0.35), vt * 0.3]);
          if (e.len >= 0.9) pts.push([e.pos + e.len * 0.75, vt]);
          if (i === ph.length - 1 && e.len >= 0.9) pts.push([e.pos + e.len, vt * 0.85]);
          pts.filter(([p], j) => j === 0 || p < cut - 0.01).forEach(([p, v]) => d.cc.push({ pos: p, cc: vibCc, value: clamp(v) }));
          level = e.len >= 0.9 ? vt : into;
        });
      }
    }
  }
  // 4) expression CC = phrase breath; `lift` gives back the level the lower dynamic layer takes away
  const ex = cfg.expression, up = ex.lift || 0, ph11 = ex.phrase;
  for (const ph of phrasesOf(evs)) {
    const p0 = ph[0].pos, p1 = Math.max(...ph.map((e) => e.pos + e.len)), L = p1 - p0;
    d.cc.push({ pos: p0, cc: ex.cc, value: ph11.start + up }, { pos: p0 + Math.min(0.75, L * 0.2), cc: ex.cc, value: ph11.peak + up });
    if (L > 1.5) d.cc.push({ pos: p1 - Math.min(0.75, L * 0.2), cc: ex.cc, value: ph11.hold + up });
    d.cc.push({ pos: p1, cc: ex.cc, value: ph11.end + up });
  }
  // 5) release CC per section
  const relCc = cfg.release?.cc;
  if (relCc != null) for (const s of ctx.sections) if (s.rel != null && ns.some((n) => n.pos >= s.pos && n.pos < s.end)) d.cc.push({ pos: s.pos, cc: relCc, value: s.rel });
}
