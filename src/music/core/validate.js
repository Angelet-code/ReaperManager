// Validators over performed tracks. Rules are keyed by instrument and style (from the track's profile), never
// by track name, so they follow the piece's declarations. Each returns { errors, warnings } lines.
import { interp } from "./curves.js";

// Same pitch overlapping: the first note's note-off would kill the second → trim the first; an identical
// onset is a duplicate and is dropped. Mutates and returns the track's notes (sorted).
export function fixSamePitchOverlaps(d) {
  d.notes.sort((a, b) => a.pos - b.pos || a.pitch - b.pitch);
  for (let i = 0; i < d.notes.length; i++) for (let k = i + 1; k < d.notes.length; k++) {
    const a = d.notes[i], b = d.notes[k];
    if (b.pos > a.pos + a.len + 0.01) break;
    if (b.pitch !== a.pitch) continue;
    if (Math.abs(b.pos - a.pos) < 0.005) { b.dup = true; continue; }
    a.len = Math.max(0.04, b.pos - a.pos - 0.02);
  }
  d.notes = d.notes.filter((n) => !n.dup);
  return d.notes;
}

export function checkNotes(name, d, range, timeline) {
  const errors = [], warnings = [];
  for (const n of d.notes) {
    if (!(n.len > 0) || !Number.isFinite(n.pos) || !Number.isFinite(n.pitch)) errors.push(`${name} invalid note ${JSON.stringify(n)}`);
    if (range && !n.ks) {
      if (n.pitch < range.full[0] || n.pitch > range.full[1]) errors.push(`${name} out of range ${n.pitch} at ${timeline.fmtPos(n.pos)}`);
      else if (n.pitch < range.practical[0] || n.pitch > range.practical[1]) warnings.push(`${name} outside practical range ${n.pitch} at ${timeline.fmtPos(n.pos)}`);
    }
  }
  return { errors, warnings };
}

// Monophonic patches: no note may start while another sounds, except a slur overlap (< maxSec).
export function checkMonophonic(name, d, timeline, maxSec = 0.12) {
  const errors = [];
  const ns = d.notes.filter((n) => !n.ks);
  for (let i = 1; i < ns.length; i++) {
    const a = ns[i - 1], b = ns[i];
    if (a.pos + a.len - b.pos > 0 && timeline.secOf(a.pos + a.len) - timeline.secOf(b.pos) > maxSec) errors.push(`${name} polyphony in a monophonic patch at ${timeline.fmtPos(b.pos)} (${a.pitch}→${b.pitch})`);
  }
  return { errors, warnings: [] };
}

// Sustained semitone / minor-ninth clashes between long notes of different tracks (or inside a pad track).
// tracks: { name: { notes } }; skip: names to ignore (unpitched); selfOk: tracks whose own notes may be compared.
export function findClashes(tracks, timeline, { skip = [], selfCheck = [], minLen = 0.9, minOverlap = 0.9 } = {}) {
  const SK = new Set(skip), SELF = new Set(selfCheck);
  const longs = [];
  for (const [t, d] of Object.entries(tracks)) if (!SK.has(t)) for (const n of d.notes) if (n.len >= minLen && !n.ks) longs.push({ t, ...n });
  longs.sort((a, b) => a.pos - b.pos);
  const out = new Map();
  for (let i = 0; i < longs.length; i++) for (let k = i + 1; k < longs.length; k++) {
    const a = longs[i], b = longs[k];
    if (b.pos > a.pos + a.len) break;
    if (a.t === b.t && !SELF.has(a.t)) continue;
    const ov = Math.min(a.pos + a.len, b.pos + b.len) - Math.max(a.pos, b.pos);
    if (ov < minOverlap) continue;
    const ic = Math.abs(a.pitch - b.pitch) % 12;
    if (ic !== 1 && ic !== 11) continue;
    const bar = timeline.barOf(Math.max(a.pos, b.pos));
    if (!out.has(bar)) out.set(bar, []);
    out.get(bar).push(`${a.t}:${a.pitch} × ${b.t}:${b.pitch} (${ov.toFixed(1)})`);
  }
  return [...out].map(([bar, l]) => ({ bar, clashes: [...new Set(l)] }));
}

// Idiom lint (vault: instruments + orchestration-errors-checklist). perf: [{ name, d, instrument, style, cfg }].
export function lintIdiom(perf, timeline) {
  const out = [];
  const { secOf, barOf } = timeline;
  const flag = (t, p, msg) => out.push(`${t.padEnd(15)} c.${barOf(p)}  ${msg}`);
  const notesOf = (d) => d.notes.filter((n) => !n.ks).sort((a, b) => a.pos - b.pos);
  const lane = (d, num, fb) => interp(d.cc.filter((c) => c.cc === num), fb);
  const lastBar = timeline.totalBars;
  for (const { name, d, instrument, style, cfg } of perf) {
    const ns = notesOf(d);
    if (!ns.length) continue;
    const st = cfg.stamina;
    // 1) breathing: a wind phrase with no gap ≥ 0.15 s longer than ~1.4× its stamina
    if (st?.gapMs) {
      const lim = st.sec * (cfg.ensemble ? 2 : 1.4);
      let s0 = null;
      ns.forEach((n, i) => {
        if (s0 === null) s0 = secOf(n.pos);
        const nx = ns[i + 1], e = secOf(n.pos + n.len);
        if (!nx || secOf(nx.pos) - e >= 0.15) { if (e - s0 > lim) flag(name, n.pos, `${(e - s0).toFixed(1)} s phrase without a breath (max ${lim.toFixed(1)})`); s0 = null; }
      });
    }
    // 2) horn endurance: more than 4 bars in a row in the high register
    if (instrument === "horn") {
      const hi = new Set(ns.filter((n) => n.pitch >= 72).map((n) => barOf(n.pos)));
      let run = 0;
      for (let b = 1; b <= lastBar; b++) { run = hi.has(b) ? run + 1 : 0; if (run === 5) flag(name, timeline.pos(b), "more than 4 bars high without a rest"); }
    }
    // trumpets: a bar of rest every 8 on sustained parts
    if (instrument?.startsWith("trumpet") && style !== "sampled-short") {
      const busy = new Set();
      ns.forEach((n) => { for (let b = barOf(n.pos); b <= barOf(n.pos + n.len - 0.01); b++) busy.add(b); });
      let run = 0;
      for (let b = 1; b <= lastBar; b++) { run = busy.has(b) ? run + 1 : 0; if (run === 9) flag(name, timeline.pos(b), "9 bars in a row without a bar of rest"); }
    }
    // 3) nothing fast in the low strings and low brass
    if (style === "sampled-short" && (instrument === "strings-low" || instrument === "double_bass")) {
      for (let i = 1; i < ns.length; i++) if (secOf(ns[i].pos) - secOf(ns[i - 1].pos) < 0.2 && ns[i].pos - ns[i - 1].pos > 0.01) { flag(name, ns[i - 1].pos, `notes ${((secOf(ns[i].pos) - secOf(ns[i - 1].pos)) * 1000).toFixed(0)} ms apart in the basses`); break; }
    }
    if (style === "sampled-short" && (instrument === "tuba" || instrument === "brass-low")) {
      const low = ns.filter((n) => n.pitch < 38);
      for (let i = 1; i < low.length; i++) if (low[i].pos - low[i - 1].pos < 1 && low[i].pos - low[i - 1].pos > 0.01) { flag(name, low[i - 1].pos, "low tuba in values shorter than a quarter"); break; }
    }
    // 4) timpani: pitches per 8-bar window (more than 4 drums only for a chromatic run)
    if (instrument === "timpani") {
      const off = cfg.keyOffset || 0, tn = ns.filter((n) => n.pitch - off >= 36 && n.pitch !== cfg.damp);
      for (let b = 1; b <= lastBar; b += 4) {
        const w = tn.filter((n) => barOf(n.pos) >= b && barOf(n.pos) < b + 8);
        const ps = [...new Set(w.map((n) => n.pitch - off))].sort((x, y) => x - y);
        const chrom = ps.every((p, i, a) => i === 0 || p - a[i - 1] === 1 || p - a[i - 1] > 4);
        if (ps.length > 4 && !chrom) flag(name, w[0].pos, `${ps.length} pitches in 8 bars (${ps.join(",")})`);
      }
    }
    // 5) register against dynamics
    const dynCc = cfg.dynamics?.cc, exCc = cfg.expression?.cc;
    if (instrument === "horn" && dynCc != null) { const f = lane(d, dynCc, 64); for (const n of ns) if (n.pitch >= 74 && f(n.pos) < 40) flag(name, n.pos, `high ${n.pitch} at piano`); }
    if (instrument?.startsWith("trumpet") && dynCc != null && style !== "modeled") { const f = lane(d, dynCc, 64); for (const n of ns) if (n.pitch >= 78 && f(n.pos) < 50) flag(name, n.pos, `high ${n.pitch} at piano`); }
    if (instrument === "flute" && style === "modeled" && exCc != null) { const f = lane(d, exCc, 100); for (const n of ns) if (n.pitch <= 63 && f(n.pos) > 95) flag(name, n.pos, `low ${n.pitch} at forte`); }
    if (instrument === "bassoon" && style === "modeled") for (const n of ns) if (n.pitch <= 44 && n.vel < 70) flag(name, n.pos, `low ${n.pitch} with a soft attack (vel ${n.vel})`);
    if (instrument === "oboe" && style === "modeled") for (const n of ns) if (n.pitch <= 60 && n.vel < 70) flag(name, n.pos, `low ${n.pitch} with a soft attack (vel ${n.vel})`);
    // 6) articulation speed (notes/s) on shorts: profile maxRate, else 12.5
    if (style === "sampled-short" && cfg.maxRate !== 0) {
      const max = cfg.maxRate ?? 12.5;
      let worst = 0, at = 0;
      for (let i = 1; i < ns.length; i++) { const dt = secOf(ns[i].pos) - secOf(ns[i - 1].pos); if (dt > 0.02 && 1 / dt > worst) { worst = 1 / dt; at = ns[i].pos; } }
      if (worst > max) flag(name, at, `${worst.toFixed(1)} notes/s (max ${max})`);
    }
    // 7) a static dynamics CC for more than 8 bars on longs
    if (style === "sampled-long" && dynCc != null) {
      const c = d.cc.filter((x) => x.cc === dynCc).sort((a, b) => a.pos - b.pos);
      for (let i = 1; i < c.length; i++) if (c[i].value === c[i - 1].value && barOf(c[i].pos) - barOf(c[i - 1].pos) > 8) flag(name, c[i - 1].pos, "dynamics CC static for more than 8 bars");
    }
  }
  return out;
}
