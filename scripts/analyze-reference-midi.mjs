#!/usr/bin/env node
// Measures how a MIDI performance is programmed: legato overlaps, attack offsets against the grid,
// expression (CC) shape per phrase, vibrato delay and velocity habits. Works on professional reference
// MIDI (reference-midi/, git-ignored) and on our own generator output, so both can be compared.
// Only aggregated numbers come out; no notes or curves are copied.
// The report separates what the PLAYER does (phrase shape relative to its peak, timing, breaths, relative
// vibrato delay: transferable between libraries) from how the LIBRARY translates it (which CC, absolute CC
// level, what velocity means, overlap needed: not transferable). See performance/library-translation-table.
//
// Usage:
//   node scripts/analyze-reference-midi.mjs --inspect file.mid            track names, channels, CCs
//   node scripts/analyze-reference-midi.mjs --catalog reference-midi/catalog.json [--only group,...]
//   node scripts/analyze-reference-midi.mjs --file label=path.mid[,path2.mid] [--expr 11 --vib 1]
//   node scripts/analyze-reference-midi.mjs --generator <out dir> --gen-groups "swam=^(FL|OB) SOLO$;..."
//   ...any of the above plus --compare refGroup:ourGroup (repeatable) and --json summary.json
//
// Generator output = a folder with build.json (tempo map) and cmd/*.json (replace_midi per track), as
// written by the piece generators (e.g. La Forja del Alba). Its CC points are linear ramps in REAPER;
// SMF CC events are steps. Both are sampled accordingly.

import { readFileSync, writeFileSync, readdirSync, statSync, existsSync } from "node:fs";
import { join, dirname, basename, resolve } from "node:path";

// ---------- Standard MIDI File reader ----------
function readSmf(buf) {
  let p = 0;
  const u32 = () => { const v = buf.readUInt32BE(p); p += 4; return v; };
  const u16 = () => { const v = buf.readUInt16BE(p); p += 2; return v; };
  if (buf.toString("latin1", 0, 4) !== "MThd") throw new Error("not a MIDI file");
  p = 4; const hlen = u32(); const format = u16(); const ntrk = u16(); const division = u16(); p = 8 + hlen;
  if (division & 0x8000) throw new Error("SMPTE time division not supported");
  const tracks = [];
  for (let t = 0; t < ntrk && p < buf.length; t++) {
    const id = buf.toString("latin1", p, p + 4); p += 4; const len = u32(); const end = p + len;
    if (id !== "MTrk") { p = end; t--; continue; }
    const events = []; let tick = 0, status = 0, name = "";
    const vlq = () => { let v = 0, b; do { b = buf[p++]; v = (v << 7) | (b & 0x7f); } while (b & 0x80); return v; };
    while (p < end) {
      tick += vlq();
      let s = buf[p];
      if (s & 0x80) p++; else s = status; // running status
      if (s === 0xff) {
        const type = buf[p++]; const l = vlq(); const data = buf.subarray(p, p + l); p += l;
        if (type === 0x03 && !name) name = data.toString("latin1").trim();
        else if (type === 0x51) events.push({ tick, kind: "tempo", uspq: (data[0] << 16) | (data[1] << 8) | data[2] });
        else if (type === 0x58) events.push({ tick, kind: "ts", num: data[0], den: 2 ** data[1] });
        continue;
      }
      if (s === 0xf0 || s === 0xf7) { const l = vlq(); p += l; continue; }
      status = s;
      const hi = s & 0xf0, ch = s & 0x0f;
      const a = buf[p++], b = hi === 0xc0 || hi === 0xd0 ? 0 : buf[p++];
      if (hi === 0x90 && b > 0) events.push({ tick, kind: "on", ch, pitch: a, vel: b });
      else if (hi === 0x80 || hi === 0x90) events.push({ tick, kind: "off", ch, pitch: a });
      else if (hi === 0xb0) events.push({ tick, kind: "cc", ch, cc: a, value: b });
      else if (hi === 0xe0) events.push({ tick, kind: "pb", ch, value: ((b << 7) | a) - 8192 });
    }
    p = end;
    tracks.push({ name, events });
  }
  return { format, division, tracks };
}

// Tempo map in quarter notes: segments { q, sec, spq } (seconds per quarter from q on).
function tempoMap(points) {
  const segs = []; let sec = 0;
  points.sort((a, b) => a.q - b.q);
  for (const pt of points) {
    if (segs.length) { const s = segs[segs.length - 1]; sec = s.sec + (pt.q - s.q) * s.spq; }
    if (segs.length && Math.abs(segs[segs.length - 1].q - pt.q) < 1e-9) segs.pop();
    segs.push({ q: pt.q, sec, spq: pt.spq });
  }
  if (!segs.length || segs[0].q > 0) segs.unshift({ q: 0, sec: 0, spq: 0.5 });
  const segAt = (q) => { let s = segs[0]; for (const x of segs) { if (x.q <= q + 1e-9) s = x; else break; } return s; };
  return { secOf: (q) => { const s = segAt(q); return s.sec + (q - s.q) * s.spq; }, spqAt: (q) => segAt(q).spq };
}

function songFromSmf(file) {
  const smf = readSmf(readFileSync(file));
  const tp = [];
  for (const tr of smf.tracks) for (const e of tr.events) if (e.kind === "tempo") tp.push({ q: e.tick / smf.division, spq: e.uspq / 1e6 });
  const tempo = tempoMap(tp);
  const out = [];
  for (const tr of smf.tracks) {
    const chans = [...new Set(tr.events.filter((e) => e.kind === "on").map((e) => e.ch))];
    for (const ch of chans) {
      const notes = [], cc = {}, open = new Map();
      for (const e of tr.events) {
        if (e.ch !== ch) continue;
        const q = e.tick / smf.division;
        if (e.kind === "on") {
          const k = e.pitch; if (!open.has(k)) open.set(k, []);
          open.get(k).push({ q0: q, pitch: e.pitch, vel: e.vel });
        } else if (e.kind === "off") {
          const st = open.get(e.pitch); if (!st || !st.length) continue;
          const n = st.shift(); n.q1 = q; notes.push(n);
        } else if (e.kind === "cc") (cc[e.cc] ||= []).push({ q, v: e.value });
      }
      const label = (tr.name || basename(file)) + (chans.length > 1 ? ` ch${ch + 1}` : "");
      out.push({ name: label, notes, cc, interp: "step" });
    }
  }
  // CC on a channel without notes in another track (e.g. a CC-only lane): attach to the track with notes on that channel
  return finish({ tempo, tracks: out });
}

// Our generator output: build.json tempo map + cmd/*.json replace_midi items (beats relative to the item's bar).
function songFromGenerator(dir) {
  const build = JSON.parse(readFileSync(join(dir, "build.json"), "utf8"));
  const changes = build.tempo_changes || [];
  let ts = build.timesig || [4, 4], bpm = build.tempo || build.bpm || 120;
  const barQ = [0, 0]; // barQ[bar] = quarter notes at the start of bar (1-based)
  const tp = [{ q: 0, spq: 60 / bpm }];
  const maxBar = 2000;
  for (let bar = 1; bar <= maxBar; bar++) {
    const ch = changes.find((c) => c.bar === bar);
    if (ch) { if (ch.timesig) ts = ch.timesig; if (ch.bpm) { bpm = ch.bpm; tp.push({ q: barQ[bar], spq: 60 / bpm }); } }
    barQ[bar + 1] = barQ[bar] + (ts[0] * 4) / ts[1];
  }
  const tempo = tempoMap(tp);
  const tracks = [];
  for (const f of readdirSync(join(dir, "cmd")).filter((x) => x.endsWith(".json"))) {
    const cmd = JSON.parse(readFileSync(join(dir, "cmd", f), "utf8"));
    const notes = [], cc = {};
    for (const it of cmd.midi || []) {
      const q0 = barQ[it.bar];
      for (const n of it.notes) notes.push({ q0: q0 + n.beat, q1: q0 + n.beat + n.len, pitch: n.pitch, vel: n.vel });
      for (const c of it.cc || []) if (c.cc !== undefined) (cc[c.cc] ||= []).push({ q: q0 + c.beat, v: c.value });
    }
    tracks.push({ name: cmd.track, notes, cc, interp: "linear" });
  }
  return finish({ tempo, tracks });
}

function finish(song) {
  for (const tr of song.tracks) {
    for (const n of tr.notes) { n.t0 = song.tempo.secOf(n.q0); n.t1 = song.tempo.secOf(n.q1 ?? n.q0 + 0.25); }
    tr.notes.sort((a, b) => a.t0 - b.t0 || a.pitch - b.pitch);
    for (const k of Object.keys(tr.cc)) {
      const pts = tr.cc[k].map((c) => ({ t: song.tempo.secOf(c.q), v: c.v })).sort((a, b) => a.t - b.t);
      tr.cc[k] = pts;
    }
  }
  return song;
}

// ---------- helpers ----------
const pct = (arr, p) => {
  if (!arr.length) return null;
  const s = [...arr].sort((a, b) => a - b); const i = (s.length - 1) * p; const lo = Math.floor(i), hi = Math.ceil(i);
  return s[lo] + (s[hi] - s[lo]) * (i - lo);
};
const mean = (a) => (a.length ? a.reduce((x, y) => x + y, 0) / a.length : null);
const sd = (a) => { if (a.length < 2) return null; const m = mean(a); return Math.sqrt(mean(a.map((x) => (x - m) ** 2))); };
function sampler(pts, interp) {
  return (t) => {
    if (!pts.length) return null;
    if (t <= pts[0].t) return pts[0].v;
    let lo = 0, hi = pts.length - 1;
    while (hi - lo > 1) { const m = (lo + hi) >> 1; if (pts[m].t <= t) lo = m; else hi = m; }
    if (pts[hi].t <= t) return pts[hi].v;
    if (interp === "step") return pts[lo].v;
    const a = pts[lo], b = pts[hi]; return a.v + ((b.v - a.v) * (t - a.t)) / Math.max(1e-9, b.t - a.t);
  };
}
const maxOn = (f, a, b, step = 0.01) => { let m = -Infinity, at = a; for (let t = a; t <= b + 1e-9; t += step) { const v = f(t); if (v > m) { m = v; at = t; } } return { m, at }; };
const minOn = (f, a, b, step = 0.01) => { let m = Infinity; for (let t = a; t <= b + 1e-9; t += step) m = Math.min(m, f(t)); return m; };

const KEYSWITCH_MAX = 23; // Kontakt keyswitches below A0 (21..23 are rarely played)
const BREAK = 0.3; // seconds of silence that end a phrase
const SHAPE_N = 20;

// ---------- per-track measurement (raw samples, merged per group later) ----------
function measure(song, tr, map) {
  const notes = tr.notes.filter((n) => n.pitch > KEYSWITCH_MAX);
  const R = { tracks: 1, notes: notes.length, ccNums: {}, poly: 0, overlaps: [], overlapByVel: { lo: [], mid: [], hi: [] },
    slurVel: { fast: [], mid: [], slow: [] }, slurVelLeap: [], attackVel: [], gaps: [], phraseSec: [], phraseNotes: [],
    offAttack: [], offSlur: [], onGrid: 0, gridN: 0, durRatio: { short: [], long: [] }, shortVel: { strong: [], weak: [] },
    expr: null, dyn: null, vib: null };
  if (notes.length < 4) return R;
  // polyphony: notes starting while another (different pitch) note keeps sounding for >= 0.25 s
  let chordal = 0;
  for (let i = 0; i < notes.length; i++) {
    const n = notes[i];
    for (let j = i - 1; j >= 0 && j >= i - 12; j--) {
      const m = notes[j];
      if (m.pitch !== n.pitch && m.t0 <= n.t0 && m.t1 - n.t0 >= 0.25 && n.t0 - m.t0 > 0.03) { chordal++; break; }
    }
  }
  R.poly = chordal / notes.length;
  const mono = R.poly < 0.15;
  // ----- phrases and transitions (monophonic lines) -----
  const phrases = [];
  let cur = [notes[0]];
  for (let i = 1; i < notes.length; i++) {
    const a = notes[i - 1], b = notes[i];
    const gap = b.t0 - a.t1;
    if (gap >= BREAK) { phrases.push(cur); cur = [b]; } else cur.push(b);
    if (!mono) continue;
    const ioi = b.t0 - a.t0;
    if (gap < -0.004 && b.pitch !== a.pitch && ioi > 0.03) {
      const ov = -gap * 1000;
      R.overlaps.push(ov);
      (b.vel < 64 ? R.overlapByVel.lo : b.vel <= 100 ? R.overlapByVel.mid : R.overlapByVel.hi).push(ov);
      const durB = b.t1 - b.t0; // our generator picks legato velocity from the slurred note's own length
      (durB < 0.25 ? R.slurVel.fast : durB < 0.5 ? R.slurVel.mid : R.slurVel.slow).push(b.vel);
      if (Math.abs(b.pitch - a.pitch) >= 5) R.slurVelLeap.push(b.vel);
      b.slurredIn = true;
    } else if (gap >= 0 && gap < BREAK) R.gaps.push(gap * 1000);
  }
  phrases.push(cur);
  for (const ph of phrases) {
    R.phraseSec.push(ph[ph.length - 1].t1 - ph[0].t0); R.phraseNotes.push(ph.length);
    for (const n of ph) if (!n.slurredIn) R.attackVel.push(n.vel);
  }
  // ----- timing against the grid (16ths or 8th-note triplets, whichever is closer) -----
  for (const n of notes) {
    const spq = song.tempo.spqAt(n.q0);
    let best = null;
    for (const g of [0.25, 1 / 3]) { const off = n.q0 - Math.round(n.q0 / g) * g; if (best === null || Math.abs(off) < Math.abs(best.off)) best = { off, g }; }
    const ms = best.off * spq * 1000;
    R.gridN++;
    if (Math.abs(ms) < 3) R.onGrid++;
    if (Math.abs(best.off) > best.g * 0.4) continue; // ambiguous: could belong to the neighbouring step
    (n.slurredIn ? R.offSlur : R.offAttack).push(ms);
  }
  // ----- note length vs inter-onset interval; short-note velocity by metric position -----
  for (let i = 0; i < notes.length - 1; i++) {
    const n = notes[i], ioi = notes[i + 1].t0 - n.t0; if (ioi <= 0.03) continue;
    const dur = n.t1 - n.t0;
    if (ioi < 0.4) R.durRatio.short.push(dur / ioi); else R.durRatio.long.push(dur / ioi);
    if (dur < 0.3) { const strong = Math.abs(n.q0 - Math.round(n.q0)) * song.tempo.spqAt(n.q0) < 0.04; (strong ? R.shortVel.strong : R.shortVel.weak).push(n.vel); }
  }
  // ----- CC lanes -----
  for (const [k, pts] of Object.entries(tr.cc)) {
    if (pts.length < 2) continue;
    const span = pts[pts.length - 1].t - pts[0].t;
    const d = pts.slice(1).map((p, i) => Math.abs(p.v - pts[i].v)).filter((x) => x > 0);
    R.ccNums[k] = { n: pts.length, perSec: span > 0 ? pts.length / span : 0, vals: pts.map((p) => p.v), steps: d };
  }
  const lane = (num) => (num != null && tr.cc[num] && tr.cc[num].length >= 6 ? sampler(tr.cc[num], tr.interp) : null);
  R.expr = phraseShapes(lane(map.expr), phrases, notes);
  if (map.dyn != null && map.dyn !== map.expr) R.dyn = phraseShapes(lane(map.dyn), phrases, notes);
  R.vib = vibrato(lane(map.vib), notes);
  return R;
}

// Expression/dynamics curve over each phrase (>= 0.6 s): normalized shape, rise, lead-in, fall and dips.
function phraseShapes(f, phrases, notes) {
  if (!f) return null;
  const S = { shapes: [], startV: [], peakV: [], endV: [], range: [], peakPos: [], riseMs: [], leadMs: [], fallMs: [], fallDrop: [],
    afterOff: [], dipSlur: [], dipArtic: [], levels: [], startRel: [], endRel: [], fallRel: [], dipSlurRel: [], dipArticRel: [] };
  for (const ph of phrases) {
    const p0 = ph[0].t0, p1 = ph[ph.length - 1].t1, L = p1 - p0;
    if (L < 0.6) continue;
    const { m: peak, at } = maxOn(f, p0, p1);
    const start = f(p0 + 0.005), end = f(p1 - 0.005);
    if (peak - Math.min(start, end) < 1 && peak < 1) continue;
    S.shapes.push(Array.from({ length: SHAPE_N }, (_, k) => f(p0 + (L * k) / (SHAPE_N - 1))));
    S.startV.push(start); S.peakV.push(peak); S.endV.push(end); S.range.push(peak - minOn(f, p0, p1)); S.peakPos.push((at - p0) / L);
    const pk = Math.max(1, peak);
    S.startRel.push(start / pk); S.endRel.push(end / pk);
    S.levels.push(...ph.map((n) => f((n.t0 + n.t1) / 2)));
    // rise: from the first note-on to 90 % of the way to the first note's maximum
    const first = ph[0];
    const fm = maxOn(f, first.t0, first.t1).m;
    if (fm - start >= 3) { const target = start + 0.9 * (fm - start); for (let t = first.t0; t <= first.t1; t += 0.005) if (f(t) >= target) { S.riseMs.push((t - first.t0) * 1000); break; } }
    // lead-in: the rise toward the first note starts at the curve's low point in the second before it
    let low = p0, lv = f(p0);
    for (let t = p0; t >= p0 - 1; t -= 0.005) if (f(t) < lv - 0.5) { lv = f(t); low = t; }
    S.leadMs.push(start - lv >= 2 ? (p0 - low) * 1000 : 0);
    // fall: last note, from where the curve leaves 95 % of its maximum to the note-off
    const last = ph[ph.length - 1];
    const lm = maxOn(f, last.t0, last.t1);
    if (lm.m - end >= 3) {
      let fs = lm.at; for (let t = lm.at; t <= last.t1; t += 0.005) if (f(t) >= lm.m - 0.05 * (lm.m - end)) fs = t;
      S.fallMs.push((last.t1 - fs) * 1000); S.fallDrop.push(lm.m - end);
    } else { S.fallMs.push(0); S.fallDrop.push(lm.m - end); }
    S.fallRel.push((lm.m - end) / Math.max(1, lm.m));
    S.afterOff.push(f(p1 + 0.15));
    // dips at internal transitions, relative to the mean of the two notes' middles
    for (let i = 1; i < ph.length; i++) {
      const a = ph[i - 1], b = ph[i]; if (b.t0 - a.t0 < 0.15) continue;
      const ref = (f((a.t0 + a.t1) / 2) + f((b.t0 + b.t1) / 2)) / 2;
      const dip = ref - minOn(f, b.t0 - 0.12, b.t0 + 0.12);
      (b.slurredIn ? S.dipSlur : S.dipArtic).push(dip);
      (b.slurredIn ? S.dipSlurRel : S.dipArticRel).push(dip / Math.max(1, ref));
    }
  }
  return S.shapes.length ? S : null;
}

// Vibrato lane on long notes: start value, maximum, and delay to half-way between them.
function vibrato(f, notes) {
  if (!f) return null;
  const V = { delayMs: [], delayRel: [], startV: [], maxV: [], noteSec: [] };
  for (const n of notes) {
    const dur = n.t1 - n.t0; if (dur < 0.8) continue;
    const s = f(n.t0 + 0.01), { m } = maxOn(f, n.t0, n.t1);
    V.startV.push(s); V.maxV.push(m); V.noteSec.push(dur);
    if (m - s < 4) continue;
    for (let t = n.t0; t <= n.t1; t += 0.005) if (f(t) >= s + (m - s) / 2) { V.delayMs.push((t - n.t0) * 1000); V.delayRel.push((t - n.t0) / dur); break; }
  }
  return V.startV.length ? V : null;
}

// ---------- grouping and summaries ----------
function merge(into, r) {
  for (const [k, v] of Object.entries(r)) {
    if (k === "ccNums") { for (const [num, c] of Object.entries(v)) { const t = (into.ccNums[num] ||= { n: 0, perSec: [], vals: [], steps: [] }); t.n += c.n; t.perSec.push(c.perSec); t.vals.push(...c.vals); t.steps.push(...c.steps); } continue; }
    if (typeof v === "number") into[k] = (into[k] || 0) + v;
    else if (Array.isArray(v)) (into[k] ||= []).push(...v);
    else if (v && typeof v === "object") { into[k] ||= {}; merge(into[k], v); }
  }
  return into;
}
const r1 = (x, d = 0) => (x == null || Number.isNaN(x) ? null : +x.toFixed(d));
const dist = (a, d = 0) => (a && a.length ? { n: a.length, p10: r1(pct(a, 0.1), d), p50: r1(pct(a, 0.5), d), p90: r1(pct(a, 0.9), d) } : null);
function summarize(g) {
  const shape = (S) => S && {
    phrases: S.shapes.length,
    meanShape: Array.from({ length: SHAPE_N }, (_, k) => r1(mean(S.shapes.map((s) => s[k])))),
    normShape: Array.from({ length: SHAPE_N }, (_, k) => r1(mean(S.shapes.map((s) => s[k] / Math.max(1, Math.max(...s)))), 2)),
    start: dist(S.startV), peak: dist(S.peakV), end: dist(S.endV), range: dist(S.range), peakPos: dist(S.peakPos, 2),
    riseMs: dist(S.riseMs), leadMs: dist(S.leadMs), fallMs: dist(S.fallMs), fallDrop: dist(S.fallDrop), afterOff: dist(S.afterOff),
    dipSlur: dist(S.dipSlur, 1), dipArtic: dist(S.dipArtic, 1), noteLevel: dist(S.levels),
    startRel: dist(S.startRel, 2), endRel: dist(S.endRel, 2), fallRel: dist(S.fallRel, 2), dipSlurRel: dist(S.dipSlurRel, 2), dipArticRel: dist(S.dipArticRel, 2),
    shareAbove95: S.levels?.length ? r1(S.levels.filter((v) => v > 95).length / S.levels.length, 2) : null
  };
  return {
    tracks: g.tracks, notes: g.notes,
    quantizedShare: g.gridN ? r1(g.onGrid / g.gridN, 2) : null,
    overlapMs: dist(g.overlaps), overlapByVel: { lt64: dist(g.overlapByVel?.lo), v64_100: dist(g.overlapByVel?.mid), gt100: dist(g.overlapByVel?.hi) },
    slurVel: { noteLt250ms: dist(g.slurVel?.fast), note250_500ms: dist(g.slurVel?.mid), noteGe500ms: dist(g.slurVel?.slow), leapGe5: dist(g.slurVelLeap) },
    attackVel: dist(g.attackVel), rearticGapMs: dist(g.gaps),
    offsetAttackMs: dist(g.offAttack), offsetSlurMs: dist(g.offSlur),
    durRatio: { short: dist(g.durRatio?.short, 2), long: dist(g.durRatio?.long, 2) },
    shortVel: { strong: dist(g.shortVel?.strong), weak: dist(g.shortVel?.weak), sdAll: r1(sd([...(g.shortVel?.strong || []), ...(g.shortVel?.weak || [])]), 1) },
    phraseSec: dist(g.phraseSec, 1), phraseNotes: dist(g.phraseNotes),
    cc: Object.fromEntries(Object.entries(g.ccNums || {}).map(([k, c]) => [k, { events: c.n, perSec: r1(mean(c.perSec), 1), value: dist(c.vals), step: dist(c.steps) }])),
    expr: shape(g.expr), dyn: shape(g.dyn),
    vib: g.vib && { delayMs: dist(g.vib.delayMs), delayRel: dist(g.vib.delayRel, 2), start: dist(g.vib.startV), max: dist(g.vib.maxV) }
  };
}

// ---------- reporting ----------
const fmt = (d) => (d ? `${d.p50} (${d.p10}–${d.p90}, n=${d.n})` : "—");
// Two layers: PLAYER (transferable: relative shape, timing, breaths) and LIBRARY (absolute CC, velocity meaning).
const playerRows = (s) => [
  ["Desfase vs rejilla, atacadas (ms)", s.offsetAttackMs], ["Desfase vs rejilla, ligadas (ms)", s.offsetSlurMs],
  ["Frase (s)", s.phraseSec], ["Notas por frase", s.phraseNotes], ["Hueco de rearticulación/respiración (ms)", s.rearticGapMs],
  ["Duración/IOI, cortas", s.durRatio.short], ["Duración/IOI, largas", s.durRatio.long],
  ["Expr: inicio / pico", s.expr?.startRel], ["Expr: final / pico", s.expr?.endRel], ["Expr: pos. del pico (0–1)", s.expr?.peakPos],
  ["Expr: anticipo antes del note-on (ms)", s.expr?.leadMs], ["Expr: subida (ms)", s.expr?.riseMs], ["Expr: caída final (ms)", s.expr?.fallMs],
  ["Expr: caída final / máx. de la nota", s.expr?.fallRel], ["Expr: valle en ligadas / nivel", s.expr?.dipSlurRel],
  ["Expr: valle en rearticuladas / nivel", s.expr?.dipArticRel], ["Vibrato: retardo relativo a la nota", s.vib?.delayRel],
  ["Vibrato: retardo (ms)", s.vib?.delayMs]
];
const libraryRows = (s) => [
  ["Solape de legato (ms)", s.overlapMs],
  ["Vel. ligada, nota <250 ms", s.slurVel.noteLt250ms], ["Vel. ligada, nota 250–500 ms", s.slurVel.note250_500ms],
  ["Vel. ligada, nota ≥500 ms", s.slurVel.noteGe500ms], ["Vel. ligada en salto ≥5 st", s.slurVel.leapGe5],
  ["Vel. de ataque", s.attackVel], ["Vel. cortas, tiempo fuerte", s.shortVel.strong], ["Vel. cortas, tiempo débil", s.shortVel.weak],
  ["Expr: inicio (CC)", s.expr?.start], ["Expr: pico (CC)", s.expr?.peak], ["Expr: final (CC)", s.expr?.end],
  ["Expr: nivel en notas (CC)", s.expr?.noteLevel], ["Expr: cuánto cae (CC)", s.expr?.fallDrop],
  ["Dyn: nivel en notas (CC)", s.dyn?.noteLevel], ["Vibrato: máx (CC)", s.vib?.max]
];
function report(name, s, map, about) {
  const L = [`## ${name}`, `${s.tracks} pista(s), ${s.notes} notas; cuantizado (|Δ|<3 ms): ${s.quantizedShare ?? "—"}; CC expr=${map.expr ?? "—"} dyn=${map.dyn ?? "—"} vib=${map.vib ?? "—"}`];
  if (about) L.push(`Librería: ${about}`);
  L.push("", "### Intérprete (transferible)", "", "| Métrica | mediana (p10–p90, n) |", "|---|---|");
  for (const [label, d] of playerRows(s)) if (d) L.push(`| ${label} | ${fmt(d)} |`);
  if (s.expr) L.push(`| Expr: forma normalizada (20 pts) | ${s.expr.normShape.join(" ")} |`);
  L.push("", "### Traducción de la librería (no transferible)", "", "| Métrica | mediana (p10–p90, n) |", "|---|---|");
  for (const [label, d] of libraryRows(s)) if (d) L.push(`| ${label} | ${fmt(d)} |`);
  L.push(`| Vel. cortas, sd | ${s.shortVel.sdAll ?? "—"} |`);
  if (s.expr) L.push(`| Expr: % de notas >95 | ${s.expr.shareAbove95} |`, `| Expr: forma media en CC (20 pts) | ${s.expr.meanShape.join(" ")} |`);
  const ccs = Object.entries(s.cc).map(([k, c]) => `CC${k}: ${c.events} ev, ${c.perSec}/s, valor ${fmt(c.value)}, paso ${fmt(c.step)}`);
  if (ccs.length) L.push("", "CC: " + ccs.join(" · "));
  return L.join("\n");
}
function compare(aName, a, bName, b) {
  const L = [`## ${aName} (ref) vs ${bName} (nuestro)`];
  const table = (title, ra, rb) => {
    L.push("", `### ${title}`, "", "| Métrica | referencia | nuestro | Δ mediana |", "|---|---|---|---|");
    ra.forEach(([label, x], i) => {
      const y = rb[i][1];
      if (!x && !y) return;
      const d = x && y ? r1(y.p50 - x.p50, Math.abs(y.p50 - x.p50) < 2 ? 2 : 0) : "—";
      L.push(`| ${label} | ${fmt(x)} | ${fmt(y)} | ${d} |`);
    });
  };
  table("Intérprete (transferible: comparar directamente)", playerRows(a), playerRows(b));
  if (a.expr && b.expr) L.push(`| Expr: forma normalizada | ${a.expr.normShape.join(" ")} | ${b.expr.normShape.join(" ")} | |`);
  table("Traducción de la librería (solo comparable si es la misma librería o una equivalente)", libraryRows(a), libraryRows(b));
  return L.join("\n");
}

// ---------- CLI ----------
const args = process.argv.slice(2);
const opt = (name) => { const i = args.indexOf(name); return i >= 0 ? args[i + 1] : undefined; };
const all = (name) => args.flatMap((a, i) => (a === name ? [args[i + 1]] : []));
const num = (x) => (x === undefined || x === "" || x === "none" ? null : Number(x));

if (opt("--inspect")) {
  const file = opt("--inspect");
  const smf = readSmf(readFileSync(file));
  const song = songFromSmf(file);
  console.log(`${basename(file)}: format ${smf.format}, ${smf.division} ppq, ${smf.tracks.length} tracks`);
  const tempos = smf.tracks.flatMap((t) => t.events.filter((e) => e.kind === "tempo")).map((e) => (60e6 / e.uspq).toFixed(1));
  console.log(`tempo: ${[...new Set(tempos)].slice(0, 12).join(", ")}${tempos.length > 12 ? ` … (${tempos.length} changes)` : ""}`);
  for (const tr of song.tracks) {
    const p = tr.notes.map((n) => n.pitch);
    const ccs = Object.entries(tr.cc).map(([k, v]) => `${k}:${v.length}[${Math.min(...v.map((x) => x.v))}-${Math.max(...v.map((x) => x.v))}]`).join(" ");
    console.log(`- ${tr.name}: ${tr.notes.length} notes ${p.length ? `${Math.min(...p)}-${Math.max(...p)}` : ""} vel ${tr.notes.length ? `${Math.min(...tr.notes.map((n) => n.vel))}-${Math.max(...tr.notes.map((n) => n.vel))}` : ""} | CC ${ccs}`);
  }
  process.exit(0);
}

// --tracks file.mid [--window-bars 4]: tutti balance of a full mock-up. Per track: CC1/CC11/CC7 and velocity at
// the notes, register, polyphony and how much of the piece it plays; then, per window, how many tracks play and
// how high each family's dynamics sit, to compare melody and accompaniment inside the same tutti.
if (opt("--tracks")) {
  const file = opt("--tracks");
  const song = songFromSmf(file);
  const end = Math.max(...song.tracks.flatMap((t) => t.notes.map((n) => n.t1)));
  const at = (tr, num) => { const pts = tr.cc[num]; if (!pts || pts.length < 2) return null; const f = sampler(pts, tr.interp); return tr.notes.map((n) => f((n.t0 + n.t1) / 2)); };
  const rows = [];
  for (const tr of song.tracks) {
    const notes = tr.notes.filter((n) => n.pitch > KEYSWITCH_MAX);
    if (notes.length < 4) continue;
    let active = 0, last = -1;
    for (const n of notes) { const a = Math.max(n.t0, last); if (n.t1 > a) active += n.t1 - a; last = Math.max(last, n.t1); }
    const r = measure(song, tr, { expr: null, dyn: null, vib: null });
    const d = (a) => (a && a.length ? dist(a) : null);
    rows.push({ name: tr.name, notes: notes.length, pitch: dist(notes.map((n) => n.pitch)), poly: r1(r.poly, 2), active: r1(active / end, 2),
      vel: dist(notes.map((n) => n.vel)), cc1: d(at(tr, 1)), cc11: d(at(tr, 11)), cc7: d(at(tr, 7)), cc2: d(at(tr, 2)) });
  }
  const p = (x) => (x ? `${x.p50} (${x.p10}–${x.p90})` : "—");
  console.log(`## ${basename(file)}: ${rows.length} pistas con notas, ${end.toFixed(0)} s`, "", "| Pista | notas | registro | polif. | tiempo activo | vel | CC1 en notas | CC11 en notas | CC7 | CC2 |", "|---|---|---|---|---|---|---|---|---|---|");
  for (const r of rows) console.log(`| ${r.name} | ${r.notes} | ${p(r.pitch)} | ${r.poly} | ${r.active} | ${p(r.vel)} | ${p(r.cc1)} | ${p(r.cc11)} | ${p(r.cc7)} | ${p(r.cc2)} |`);
  if (opt("--json")) writeFileSync(opt("--json"), JSON.stringify(rows, null, 1));
  process.exit(0);
}

const groups = new Map(); // name -> { raw, map, about }
function add(group, song, tr, map, about) {
  const g = groups.get(group) || { raw: { tracks: 0, notes: 0, ccNums: {} }, map, about };
  merge(g.raw, measure(song, tr, map));
  groups.set(group, g);
}
const defaultMap = { expr: num(opt("--expr") ?? 11), dyn: num(opt("--dyn") ?? 1), vib: num(opt("--vib") ?? "none") };

if (opt("--catalog")) {
  const catPath = resolve(opt("--catalog"));
  const cat = JSON.parse(readFileSync(catPath, "utf8"));
  const only = opt("--only")?.split(",");
  for (const e of cat.files) {
    if (e.kind !== "perf" || (only && !only.includes(e.group))) continue;
    const file = resolve(dirname(catPath), e.path);
    if (!existsSync(file)) { console.error(`falta ${e.path}`); continue; }
    const song = songFromSmf(file);
    for (const tr of song.tracks) {
      if (e.tracks && !new RegExp(e.tracks, "i").test(tr.name)) continue;
      const rule = (e.trackGroups || []).find((r) => new RegExp(r.match, "i").test(tr.name));
      if (e.trackGroups && !rule) continue;
      const map = { ...defaultMap, ...cat.groups?.[rule?.group ?? e.group]?.cc, ...e.cc, ...rule?.cc };
      const gname = rule?.group ?? e.group;
      add(gname, song, tr, map, cat.groups?.[gname] && `${cat.groups[gname].library}. ${cat.groups[gname].about ?? ""}`);
    }
  }
}
for (const spec of all("--file")) {
  const [label, paths] = spec.includes("=") ? spec.split(/=(.*)/s) : [basename(spec), spec];
  for (const p of paths.split(",")) {
    const files = statSync(p).isDirectory() ? readdirSync(p).filter((f) => /\.midi?$/i.test(f)).map((f) => join(p, f)) : [p];
    for (const f of files) { const song = songFromSmf(f); for (const tr of song.tracks) add(label, song, tr, defaultMap); }
  }
}
if (opt("--generator")) {
  const song = songFromGenerator(resolve(opt("--generator")));
  const rules = (opt("--gen-groups") || "").split(";").filter(Boolean).map((r) => { const [g, re, cc] = r.split("="); return { g, re: new RegExp(re), cc }; });
  for (const tr of song.tracks) {
    const rule = rules.find((r) => r.re.test(tr.name));
    if (rules.length && !rule) continue;
    const [expr, dyn, vib] = (rule?.cc || "").split(",").map((x) => (x ? num(x) : undefined));
    const pick = (x, d) => (x === undefined ? d : x);
    add(rule ? rule.g : tr.name, song, tr, { expr: pick(expr, defaultMap.expr), dyn: pick(dyn, defaultMap.dyn), vib: pick(vib, defaultMap.vib) });
  }
}

const summaries = Object.fromEntries([...groups].map(([k, g]) => [k, summarize(g.raw)]));
const pairs = all("--compare").map((c) => c.split(":"));
if (!pairs.length || args.includes("--detail")) for (const [k, s] of Object.entries(summaries)) console.log(report(k, s, groups.get(k).map) + "\n");
for (const [a, b] of pairs) {
  if (!summaries[a] || !summaries[b]) { console.error(`grupo desconocido: ${!summaries[a] ? a : b} (hay: ${Object.keys(summaries).join(", ")})`); continue; }
  console.log(compare(a, summaries[a], b, summaries[b]) + "\n");
}
if (opt("--json")) writeFileSync(opt("--json"), JSON.stringify(summaries, null, 1));
