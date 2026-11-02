// Percussion writing driven by profile data: timpani hits, rolls and damps, suspended cymbal hits and swells,
// and hand-alternating ensemble percussion (Darwin type). Keyswitch numbers, roll lanes and note zones come
// from the profile, so another timpani library only needs its own JSON.
import { clamp } from "../core/util.js";

// tracks: { timpani: { name, cfg }, cymbal: { name, cfg }, ensemble: { name, cfg } } (any may be missing)
// rnd: the writing stream ({ rr }).
export function percussionWriters(score, rnd, tracks = {}) {
  const { track, cc, ramp, noteAt, timeline: { pos, ms2qn } } = score;
  const ksNote = (t, p, ks, key) => track(t).notes.push({ pos: Math.max(0, p - ks.leadQn), len: ks.len, pitch: key, vel: ks.vel, keep: true, ks: true });
  const need = (k) => {
    if (!tracks[k]) throw new Error(`percussion writer: no ${k} track declared`);
    return tracks[k];
  };
  const rolls = [];

  // ---------- timpani ----------
  function timpHit(bar, beat, sounding, vel, len = 0.6, flam = false) {
    const { name, cfg } = need("timpani"), ks = cfg.keyswitches;
    const p = pos(bar, beat) + ms2qn(rnd.rr(4), pos(bar, beat));
    ksNote(name, p, ks, flam ? ks.map.flam : ks.map.hit);
    track(name).notes.push({ pos: p, len, pitch: sounding + (cfg.keyOffset || 0), vel: clamp(vel + rnd.rr(3)), keep: true });
  }
  // Roll with dynamics: pts [[bar, beat, value 0–127], ...]. Each lane in the profile maps the value to its CC
  // (Symphony Series: CC7 40→127 does the crescendo, CC1 follows curved). The first points sit before the note-on.
  function timpRoll(bar, beat, lenQ, sounding, pts) {
    const { name, cfg } = need("timpani"), ks = cfg.keyswitches, R = cfg.roll;
    const p = pos(bar, beat);
    ksNote(name, p, ks, ks.map.roll);
    for (const lane of R.lanes) {
      const c = lane.curve ?? 1, span = lane.to - lane.from;
      const f = (v) => (c === 1 ? lane.from + (span * v) / 127 : lane.from + span * Math.pow(v / 127, c));
      cc(name, Math.max(0, p - 0.02), lane.cc, f(pts[0][2]));
      for (let i = 1; i < pts.length; i++) ramp(name, pos(pts[i - 1][0], pts[i - 1][1]), f(pts[i - 1][2]), pos(pts[i][0], pts[i][1]), f(pts[i][2]), lane.cc, 0.25);
    }
    track(name).notes.push({ pos: p, len: lenQ - 0.03, pitch: sounding + (cfg.keyOffset || 0), vel: R.vel, keep: true });
    const last = pts[pts.length - 1];
    rolls.push({ start: p, end: p + lenQ, lastCC: pos(last[0], last[1]) });
  }
  // The roll's volume lane back to 127 at the start and before the first hit that follows each roll (if what
  // follows is another roll, that one sets its own). Call once all sections have written their notes.
  function timpVolumeReset() {
    if (!tracks.timpani) return;
    const { name, cfg } = tracks.timpani, R = cfg.roll;
    if (!R?.resetCc) return;
    const ns = track(name).notes.filter((n) => !n.ks).sort((a, b) => a.pos - b.pos);
    if (!rolls.some((r) => r.start < 0.05)) cc(name, 0, R.resetCc, 127);
    for (const r of rolls) {
      const next = ns.find((n) => n.pos > r.end - 0.05);
      if (!next || rolls.some((o) => Math.abs(o.start - next.pos) < 0.01)) continue;
      cc(name, Math.max(r.lastCC + 0.01, next.pos - R.resetLeadQn), R.resetCc, 127);
    }
  }
  function timpDamp(bar, beat) {
    const { name, cfg } = need("timpani");
    track(name).notes.push({ pos: pos(bar, beat), len: 0.2, pitch: cfg.damp, vel: 90, keep: true });
  }

  // ---------- suspended cymbal ----------
  let cymRR = 0;
  function cymHit(bar, beat, vel, o = {}) {
    const { name, cfg } = need("cymbal"), ks = cfg.keyswitches, H = cfg.hits;
    const p = pos(bar, beat);
    ksNote(name, p, ks, o.soft ? ks.map.soft : ks.map.hard);
    const keys = o.short ? H.short : H.long;
    track(name).notes.push({ pos: p, len: o.short ? 0.25 : (o.len || 4), pitch: cymRR++ % 2 ? keys[1] : keys[0], vel: clamp(vel + rnd.rr(2)), keep: true });
  }
  // swell that peaks exactly at endPos and lets the roll ring `ring` qn with a soft decay (cutting it at the
  // target made the tremolo die dead on the arrival)
  function cymSwell(endBar, endBeat, lenQ, peak = 116, start = 8, ring) {
    const { name, cfg } = need("cymbal"), ks = cfg.keyswitches, S = cfg.swell;
    ring = ring ?? S.ring;
    const end = pos(endBar, endBeat), p = end - lenQ;
    ksNote(name, p, ks, ks.map.soft);
    track(name).notes.push({ pos: p, len: lenQ + ring, pitch: cfg.hits.roll, vel: S.vel, keep: true });
    ramp(name, p, start, p + lenQ * 0.6, peak * 0.5, S.cc, 0.25);
    ramp(name, p + lenQ * 0.6, peak * 0.5, end - 0.02, peak, S.cc, 0.25);
    ramp(name, end, peak, end + ring - 0.02, peak * 0.3, S.cc, 0.25);
  }

  // ---------- ensemble percussion: alternating hands, optional flam (grace note before, softer) ----------
  const hand = {};
  function ensembleHit(bar, beat, kind, acc = 0, o = {}) {
    const { name, cfg } = need("ensemble");
    const keys = cfg.map[kind];
    if (!keys) throw new Error(`percussion: no ${kind} zone in ${name}'s profile`);
    const i = (hand[kind] = ((hand[kind] ?? -1) + 1) % keys.length);
    const p = pos(bar, beat);
    const n = noteAt(name, p, o.len || 0.25, keys[i], { acc });
    if (o.flam) noteAt(name, p - ms2qn(cfg.flam?.leadMs ?? 32, p), 0.15, keys[(i + 1) % keys.length], { acc: acc + (cfg.flam?.accent ?? -26), keep: true });
    return n;
  }

  return { timpHit, timpRoll, timpVolumeReset, timpDamp, cymHit, cymSwell, ensembleHit, rolls };
}
