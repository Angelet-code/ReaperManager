// Pitch helpers: note names, a compact melody syntax, chord symbols and a voice-leading voicer.
// MIDI pitches at sounding pitch, C4 = 60.

const PCN = { C: 0, D: 2, E: 4, F: 5, G: 7, A: 9, B: 11 };
const NAMES = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"];

// "C#4" → 61, "Bb3" → 58
export function M(s) {
  const m = s.match(/^([A-G])([#b]?)(-?\d)$/);
  if (!m) throw new Error("note: " + s);
  return 12 * (+m[3] + 1) + PCN[m[1]] + (m[2] === "#" ? 1 : m[2] === "b" ? -1 : 0);
}
export const noteName = (p) => NAMES[((p % 12) + 12) % 12] + (Math.floor(p / 12) - 1);
export const pcOf = (name) => (PCN[name[0]] + (name[1] === "#" ? 1 : name[1] === "b" ? -1 : 0) + 12) % 12;

// Melody text: "D4:3 A4:1 | Bb4:2 r:1" ("|" is visual only). Suffixes after the duration:
// ! accent (+8), ^ re-articulate (no slur into the next), ~ expressive glissando (SWAM strings), g grace note.
// Returns a spec [[pitch|null, len, opts], ...] for line().
export function mel(str) {
  return str.split(/\s+/).filter((t) => t && t !== "|").map((tok) => {
    const [name, rest] = tok.split(":");
    const dur = parseFloat(rest);
    if (!(dur > 0)) throw new Error("duration: " + tok);
    const o = {};
    if (rest.includes("!")) o.acc = 8;
    if (rest.includes("^")) o.tie = false;
    if (rest.includes("~")) o.gliss = true;
    if (rest.includes("g")) o.grace = true;
    return [name === "r" ? null : M(name), dur, o];
  });
}
export const specLen = (spec) => spec.reduce((s, [, l]) => s + l, 0);
export const transpose = (spec, n) => spec.map(([p, l, o]) => [p === null ? null : p + n, l, o]);
export const augment = (spec, f) => spec.map(([p, l, o]) => [p, l * f, o]);
// Diatonic shift by scale steps (scale = list of pitch classes), for tonal sequences.
export function dshift(spec, steps, scale) {
  return spec.map(([p, l, o]) => {
    if (p === null) return [p, l, o];
    const oct = Math.floor(p / 12), pc = ((p % 12) + 12) % 12;
    const idx = scale.indexOf(pc);
    if (idx < 0) return [p + (steps > 0 ? 1 : -1), l, o];
    let k = idx + steps, o2 = oct;
    while (k >= scale.length) { k -= scale.length; o2++; }
    while (k < 0) { k += scale.length; o2--; }
    return [o2 * 12 + scale[k], l, o];
  });
}
export const SCALE = {
  Dm: [2, 4, 5, 7, 9, 10, 0], Dharm: [2, 4, 5, 7, 9, 10, 1], D: [2, 4, 6, 7, 9, 11, 1], F: [5, 7, 9, 10, 0, 2, 4],
  Gm: [7, 9, 10, 0, 2, 3, 5], Gharm: [7, 9, 10, 0, 2, 3, 6], A: [9, 11, 1, 2, 4, 6, 8], Bb: [10, 0, 2, 3, 5, 7, 9]
};
// Major/minor scale of any tonic: scaleOf("F#", "minor").
export function scaleOf(tonic, mode = "major") {
  const steps = { major: [0, 2, 4, 5, 7, 9, 11], minor: [0, 2, 3, 5, 7, 8, 10], harmonic: [0, 2, 3, 5, 7, 8, 11], dorian: [0, 2, 3, 5, 7, 9, 10], phrygian: [0, 1, 3, 5, 7, 8, 10] }[mode];
  if (!steps) throw new Error("mode: " + mode);
  return steps.map((s) => (pcOf(tonic) + s) % 12);
}

// Chord symbol → { sym, root, bass, tones [{pc, iv, w}], pcs }. w = how much a tone must not be missing.
export function parseChord(sym) {
  const m = sym.match(/^([A-G][#b]?)(.*?)(?:\/([A-G][#b]?))?$/);
  if (!m) throw new Error("chord: " + sym);
  const root = pcOf(m[1]);
  let rest = m[2];
  const take = (re) => { const x = rest.match(re); if (x) { rest = rest.slice(x[0].length); return true; } return false; };
  let iv;
  if (take(/^(ø7|m7b5)/)) iv = [0, 3, 6, 10];
  else if (take(/^dim7/)) iv = [0, 3, 6, 9];
  else if (take(/^dim/)) iv = [0, 3, 6];
  else if (take(/^(aug|\+)/)) iv = [0, 4, 8];
  else if (take(/^maj7?/)) iv = [0, 4, 7, 11];
  else if (take(/^m(?!aj)/)) iv = [0, 3, 7];
  else if (take(/^5/)) iv = [0, 7];
  else iv = [0, 4, 7];
  const has7 = () => iv.some((x) => x === 10 || x === 11) || (iv.includes(9) && iv.includes(6));
  while (rest.length) {
    if (take(/^maj7/)) iv.push(11);
    else if (take(/^7/)) { if (!has7()) iv.push(10); }
    else if (take(/^add9/)) iv.push(2);
    else if (take(/^b9/)) { if (!has7()) iv.push(10); iv.push(1); }
    else if (take(/^9/)) { if (!has7()) iv.push(10); iv.push(2); }
    else if (take(/^6/)) iv.push(9);
    else if (take(/^#11/)) iv.push(6);
    else if (take(/^11/)) iv.push(5);
    else if (take(/^b13/)) iv.push(8);
    else if (take(/^13/)) iv.push(9);
    else if (take(/^sus4/)) iv = iv.filter((x) => x !== 3 && x !== 4).concat(5);
    else if (take(/^sus2/)) iv = iv.filter((x) => x !== 3 && x !== 4).concat(2);
    else if (take(/^no3/)) iv = iv.filter((x) => x !== 3 && x !== 4);
    else throw new Error(`chord ${sym}: cannot parse "${rest}"`);
  }
  iv = [...new Set(iv)];
  const weight = (x) => (x === 0 ? 3 : x === 3 || x === 4 ? 5 : x === 7 ? 1 : x === 10 || x === 11 ? 4 : x === 9 && iv.includes(6) ? 4 : 3);
  const tones = iv.map((x) => ({ pc: (root + x) % 12, iv: x, w: weight(x) }));
  const bass = m[3] ? pcOf(m[3]) : root;
  return { sym, root, bass, tones, pcs: tones.map((t) => t.pc) };
}
// All chord pitches inside [lo, hi].
export function chordPitches(sym, lo, hi) {
  const { pcs } = typeof sym === "string" ? parseChord(sym) : sym;
  const out = [];
  for (let p = lo; p <= hi; p++) if (pcs.includes(p % 12)) out.push(p);
  return out;
}
// The chord's bass note nearest to `near` inside [lo, hi].
export function bassNote(sym, near, lo, hi) {
  const { bass } = parseChord(sym);
  let best = null;
  for (let p = lo; p <= hi; p++) if (p % 12 === bass && (best === null || Math.abs(p - near) < Math.abs(best - near))) best = p;
  return best;
}

function* combos(arr, k, start = 0, acc = []) {
  if (acc.length === k) { yield acc.slice(); return; }
  for (let i = start; i <= arr.length - (k - acc.length); i++) { acc.push(arr[i]); yield* combos(arr, k, i + 1, acc); acc.pop(); }
}
// Voicing of n upper voices inside [lo, hi], led from prev.
// opt: { center, maxTop, minTop, top (forced top note), bassCovers (bass already plays its pitch class), cluster, still }
export function voice(sym, n, lo, hi, prev = null, opt = {}) {
  const ch = parseChord(sym);
  const cand = chordPitches(ch, lo, hi);
  let best = null, bestCost = Infinity;
  for (const v of combos(cand, n)) {
    if (opt.maxTop && v[n - 1] > opt.maxTop) continue;
    if (opt.minTop && v[n - 1] < opt.minTop) continue;
    if (opt.top !== undefined && v[n - 1] !== opt.top) continue;
    let c = 0;
    const pcsIn = v.map((p) => p % 12);
    for (const t of ch.tones) if (!pcsIn.includes(t.pc) && !(t.pc === ch.bass && opt.bassCovers)) c += t.w * 10;
    const third = ch.tones.find((t) => t.iv === 3 || t.iv === 4);
    if (third && pcsIn.filter((x) => x === third.pc).length > 1) c += 6;
    if (third && opt.bassCovers && ch.bass === third.pc && pcsIn.includes(third.pc)) c += 4;
    const lead = ch.tones.find((t) => t.iv === 11 || t.iv === 1);
    if (lead && pcsIn.filter((x) => x === lead.pc).length > 1) c += 8;
    for (let i = 1; i < n; i++) {
      const g = v[i] - v[i - 1];
      if (g > (i === 1 ? 14 : 12)) c += 8;
      if (g < 2) c += 6; else if (g < 3) c += opt.cluster ? 0 : 2;
    }
    if (prev && prev.length === n) {
      for (let i = 0; i < n; i++) { const d = Math.abs(v[i] - prev[i]); c += d * (opt.still ?? 1); if (d > 7) c += 3; }
      for (let i = 0; i < n; i++) for (let j = i + 1; j < n; j++) {
        const a = (prev[j] - prev[i]) % 12, b = (v[j] - v[i]) % 12;
        const mi = v[i] - prev[i], mj = v[j] - prev[j];
        if ((a === 7 && b === 7) || (a === 0 && b === 0)) if (mi !== 0 && Math.sign(mi) === Math.sign(mj)) c += 5;
      }
    }
    if (opt.center !== undefined) c += 0.25 * Math.abs(v.reduce((s, x) => s + x, 0) / n - opt.center);
    if (c < bestCost) { bestCost = c; best = v; }
  }
  if (!best) throw new Error(`no voicing for ${sym} in [${lo},${hi}] n=${n} ${JSON.stringify(opt)}`);
  return best;
}
