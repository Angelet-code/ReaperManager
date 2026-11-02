// Library calibration: test MIDI per kind of patch (rendered through the bridge and measured by
// scripts/calibration/measure.py) and the mapping from measured results back into a profile.
// 120 BPM, 4/4: one beat = 0.5 s. Ported from calibracion-librerias/resultados/gen.mjs (2026-11-02).

const S = (beat) => beat * 0.5;
const VEL = [30, 60, 90, 120];
const STEPS = [10, 25, 40, 55, 70, 85, 100, 115, 127];

function steps(beat0, num, values, other) {
  const ccs = [{ beat: beat0 - 1, cc: other.num, value: other.value }];
  values.forEach((v, i) => ccs.push({ beat: beat0 + i * 3 - (i === 0 ? 1 : 0), cc: num, value: v }));
  return { ccs, steps: values.map((v, i) => ({ value: v, t0: S(beat0 + i * 3), t1: S(beat0 + i * 3 + 3) })) };
}

// Legato transition delay (energy share of the new pitch) and first-note attack, per slur velocity.
export function legatoTest(p1, p2, { cc = {}, vels = VEL, overlap = 0.16 } = {}) {
  const notes = [], ccList = [{ beat: 0, cc: cc.dynCc ?? 1, value: cc.dyn ?? 90 }, { beat: 0, cc: cc.exCc ?? 11, value: cc.ex ?? 110 }];
  if (cc.vibCc != null) ccList.push({ beat: 0, cc: cc.vibCc, value: 0 });
  const blocks = [];
  let b = 4;
  for (const v of vels) {
    notes.push({ pitch: p1, beat: b, len: 4 + overlap, vel: v }, { pitch: p2, beat: b + 4, len: 3, vel: v });
    blocks.push({ vel: v, t1: S(b), t2: S(b + 4), end: S(b + 7), p1, p2 });
    b += 12;
  }
  return { bars: Math.ceil(b / 4) + 1, notes, cc: ccList, spec: { kind: "legato", blocks } };
}
// Long notes: attack by dynamics layer, dynamics CC → dB and expression CC → dB on one sustained note each.
export function longTest(pitch, { dynCc = 1, exCc = 11, vibCc = null } = {}) {
  const notes = [], cc = [{ beat: 0, cc: exCc, value: 127 }], attacks = [];
  if (vibCc != null) cc.push({ beat: 0, cc: vibCc, value: 0 });
  let b = 4;
  for (const c of [40, 80, 120]) { cc.push({ beat: b - 1, cc: dynCc, value: c }); notes.push({ pitch, beat: b, len: 4, vel: 100 }); attacks.push({ cc1: c, t: S(b), end: S(b + 4) }); b += 8; }
  const s1 = steps(b + 2, dynCc, STEPS, { num: exCc, value: 127 });
  notes.push({ pitch, beat: b + 2, len: STEPS.length * 3, vel: 100 }); cc.push(...s1.ccs); b += 2 + STEPS.length * 3 + 4;
  const s2 = steps(b + 2, exCc, STEPS, { num: dynCc, value: 80 });
  notes.push({ pitch, beat: b + 2, len: STEPS.length * 3, vel: 100 }); cc.push(...s2.ccs); b += 2 + STEPS.length * 3 + 4;
  return { bars: Math.ceil(b / 4) + 1, notes, cc, spec: { kind: "long", attacks, cc1: s1.steps, cc11: s2.steps } };
}
// Shorts: velocity → peak level and onset, at two dynamics-CC values.
export function shortTest(pitch, { dynCc = 1, exCc = 11 } = {}) {
  const notes = [], cc = [{ beat: 0, cc: exCc, value: 127 }], hits = [];
  let b = 4;
  for (const c1 of [100, 40]) {
    cc.push({ beat: b - 1, cc: dynCc, value: c1 });
    for (const v of [20, 40, 60, 80, 100, 120, 127]) { notes.push({ pitch, beat: b, len: 0.5, vel: v }); hits.push({ cc1: c1, vel: v, t: S(b) }); b += 2; }
    b += 4;
  }
  return { bars: Math.ceil(b / 4) + 1, notes, cc, spec: { kind: "short", hits } };
}
// Modeled instruments: expression CC → dB on one note, and portamento time by slur velocity.
export function modeledTest(p1, p2, { exCc = 11, vibCc = 1 } = {}) {
  const notes = [], cc = [{ beat: 0, cc: vibCc, value: 0 }], blocks = [];
  const s = steps(6, exCc, [20, 35, 50, 65, 80, 95, 110, 127], { num: vibCc, value: 0 });
  notes.push({ pitch: p1, beat: 6, len: 8 * 3, vel: 90 }); cc.push(...s.ccs);
  let b = 6 + 24 + 4;
  cc.push({ beat: b - 1, cc: exCc, value: 80 });
  for (const v of [60, 80, 90, 100, 110, 120]) {
    notes.push({ pitch: p1, beat: b, len: 4.1, vel: 80 }, { pitch: p2, beat: b + 4, len: 3, vel: v });
    blocks.push({ vel: v, t1: S(b), t2: S(b + 4), end: S(b + 7), p1, p2 });
    b += 12;
  }
  cc.push({ beat: b, cc: exCc, value: 0 });
  return { bars: Math.ceil(b / 4) + 1, notes, cc, spec: { kind: "swam", cc11: s.steps, blocks } };
}

// Which tests a style needs, and a comfortable test pitch inside the patch's range.
export function testsFor(style) {
  return { "sampled-legato": ["legato"], "sampled-long": ["long"], "sampled-short": ["short"], modeled: ["swam"] }[style] || [];
}
export function testPitches(range) {
  const [lo, hi] = range?.practical || [55, 79];
  const p1 = Math.round(lo + (hi - lo) * 0.45);
  return [p1, Math.min(hi, p1 + 4)];
}

export function buildTest(kind, cfg) {
  const [p1, p2] = testPitches(cfg.range);
  const ccs = { dynCc: cfg.dynamics?.cc ?? 1, exCc: cfg.expression?.cc ?? 11, vibCc: cfg.vibrato?.cc ?? null };
  if (kind === "legato") return legatoTest(p1, p2, { cc: ccs });
  if (kind === "long") return longTest(p1, ccs);
  if (kind === "short") return shortTest(p1, ccs);
  if (kind === "swam") return modeledTest(p1, p2, { exCc: ccs.exCc, vibCc: ccs.vibCc ?? 1 });
  throw new Error(`unknown calibration test ${kind}`);
}

const median = (xs) => { const s = xs.filter((x) => x != null).sort((a, b) => a - b); return s.length ? s[Math.floor((s.length - 1) / 2)] : null; };
const curve = (rows, key = "cc") => rows.map((r) => [r[key], r.dB ?? r.rel_dB]);

// Measured result (measure.py JSON) → the profile blocks it supports, all with status M.
export function blocksFromResult(result, { date = new Date().toISOString().slice(0, 10), source = "calibrate-instrument" } = {}) {
  const src = `${source} ${date}`;
  const out = {};
  if (result.legato_by_vel) {
    const mids = result.legato_by_vel.map((r) => r["mid_ms(50%)"]);
    const spread = Math.max(...mids.filter((x) => x != null)) - Math.min(...mids.filter((x) => x != null));
    out.latency = { transitionMs: [median(result.legato_by_vel.map((r) => r["start_ms(20%)"])), median(mids), median(result.legato_by_vel.map((r) => r["done_ms(90%)"]))],
      firstNoteDb6Ms: median((result.attack_by_vel || []).map((r) => r["attack_ms(-6dB)"])), status: "M", source: src };
    out.velocity = spread <= 15 ? { slurEffect: "none", status: "M", source: src }
      : { slurEffect: "transition-speed", slurMidMsByVel: result.legato_by_vel.map((r) => [r.vel, r["mid_ms(50%)"]]), status: "M", source: src };
  }
  if (result.attack_by_cc1) out.latency = { ...(out.latency || {}), attackDb6Ms: [Math.min(...result.attack_by_cc1.map((r) => r["attack_ms(-6dB)"])), Math.max(...result.attack_by_cc1.map((r) => r["attack_ms(-6dB)"]))], status: "M", source: src };
  const cal = {};
  if (result.cc1_response) cal.cc1Db = curve(result.cc1_response);
  if (result.cc11_response) cal.cc11Db = curve(result.cc11_response);
  if (result.shorts) {
    cal.velDb = result.shorts.filter((h) => h.cc1 === 100).map((h) => [h.vel, h.rel_dB]);
    const byVel = (c1) => new Map(result.shorts.filter((h) => h.cc1 === c1).map((h) => [h.vel, h.peak_dB]));
    const hi = byVel(100), lo = byVel(40);
    cal.cc1Effect = `${Math.max(...[...hi].map(([v, d]) => Math.abs(d - (lo.get(v) ?? d)))).toFixed(1)} dB max (CC1 100 vs 40)`;
    out.latency = { onsetMs: median(result.shorts.map((h) => h.onset_ms)), toPeakMs: median(result.shorts.map((h) => h.to_peak_ms)), status: "M", source: src };
  }
  if (result.portamento_by_vel) {
    out.velocity = { slurEffect: "portamento", portamentoMidMs: result.portamento_by_vel.map((r) => [r.vel, r["mid_ms(50%)"]]), status: "M", source: src };
    const top = (result.cc11_response || []).find((r) => r.dB >= -0.6);
    if (top) out.expression = { levelCeiling: top.cc, status: "M", source: src };
    if (result.attack_first) out.latency = { attackDb6Ms: result.attack_first["attack_ms(-6dB)"], status: "M", source: src };
  }
  if (Object.keys(cal).length) out.calibration = { ...cal, status: "M", source: src };
  return out;
}

// Merge measured blocks into a library JSON's patch (block by block: measured keys replace, others stay).
export function applyBlocks(library, patchId, blocks) {
  const patch = library.patches?.[patchId];
  if (!patch) throw new Error(`patch ${patchId} not in ${library.library}`);
  const before = JSON.parse(JSON.stringify(patch));
  for (const [k, v] of Object.entries(blocks)) patch[k] = { ...(patch[k] || {}), ...v };
  return { before, after: patch };
}
