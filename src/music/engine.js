// The engine: a piece declares tempo, sections and tracks (→ profile + style); its sections write notes and
// dynamic curves; perform() turns them into a performance by reading each track's profile; toBridge() writes
// the bridge commands. Nothing here knows a track name, a style of music or a library.
import { createTimeline } from "./core/timeline.js";
import { createScore } from "./core/score.js";
import { createRandom, mulberry, withHelpers } from "./core/random.js";
import { interp } from "./core/curves.js";
import { clamp } from "./core/util.js";
import * as pitch from "./core/pitch.js";
import { fixSamePitchOverlaps, checkNotes, checkMonophonic, findClashes, lintIdiom } from "./core/validate.js";
import { trackItems, buildSpec, writeBridgeFiles } from "./core/bridge.js";
import { loadProfiles, resolveTrack } from "./profiles/profiles.js";
import { createBreathPlanner } from "./styles/breath.js";
import { performSampled } from "./styles/sampled.js";
import { performShort, performPiano, performPercussion, performDrums } from "./styles/simple.js";
import { bandDrift } from "./core/humanize.js";
import { performModeled } from "./styles/modeled.js";
import { applyBalance } from "./styles/balance.js";
import { orchestraWriters } from "./writing/orchestra.js";
import { percussionWriters } from "./writing/percussion.js";

const STYLE = {
  "sampled-legato": performSampled,
  "sampled-long": performSampled,
  "sampled-short": performShort,
  modeled: performModeled,
  piano: performPiano,
  percussion: performPercussion,
  drums: performDrums
};

// Performance options and their defaults. They follow what the user validated by ear; La Forja's v4 breath
// sharing and per-phrase vibrato are the current default of its generator, the SWAM breath layer is off.
export const DEFAULT_OPTIONS = {
  breaths: "shared", // "shared" (v4: sections breathe together, arrivals and sighs respected) | "independent" (v3)
  vibrato: "phrase", // "phrase" (v4: no restart inside a phrase) | "note" (v3)
  swamBreath: false, // false | true | { end: "B"|"reo", shape, noise, ride, amount, ceil }
  feel: {} // { sampled: "laid-back"|"on-beat", "<track>": ... }: on-beat uses the latencies measured in context
};
// vibrato level of a section that does not give one (the new-piece templates use 50)
export const SECTION_VIB = 50;

/**
 * spec: {
 *   title, seed, rng: "streams" (default) | "shared" (La Forja parity only),
 *   tempo: [{ bar, bpm, num?, den? }], lastBar,
 *   sections: [{ bar, end?, name, vib?, rel? }],
 *   tracks: { "<name>": { profile?, patch?, style?, instrument?, overrides?, stamina? } },
 *   breathGroups: { "<group>": ["<track>", ...] } (in order: the first chooses, the others copy),
 *   balance: [["<track>", fromBar, toBar, dB], ...],
 *   options: { ...DEFAULT_OPTIONS }, profilesDir
 * }
 */
export function createPiece(spec) {
  const lastBar = spec.lastBar ?? Math.max(...spec.tempo.map((c) => c.bar));
  const timeline = createTimeline(spec.tempo, lastBar + 2);
  const score = createScore(timeline, spec.store);
  const random = createRandom({ seed: spec.seed ?? 1, mode: spec.rng || "streams" });
  const registry = loadProfiles(spec.profilesDir);
  const options = { ...DEFAULT_OPTIONS, ...(spec.options || {}) };
  const warnings = [];
  const resolved = {};
  const resolve = (name) => {
    if (!resolved[name]) {
      const decl = spec.tracks?.[name];
      if (!decl) warnings.push(`${name}: written but not declared; generic defaults`);
      resolved[name] = resolveTrack(registry, name, decl || {});
      warnings.push(...resolved[name].warnings);
    }
    return resolved[name];
  };
  for (const name of Object.keys(spec.tracks || {})) resolve(name);

  // streams: one per (track, layer); in "shared" mode the SWAM breath layer keeps its own per-track stream
  // (as La Forja's soplo.mjs) so it never moves the rest
  const ownShared = new Map();
  const rng = (track, layer) => {
    if (random.mode === "shared" && layer === "swamBreath") {
      if (!ownShared.has(track)) ownShared.set(track, withHelpers(mulberry(track)));
      return ownShared.get(track);
    }
    return random.stream(track, layer);
  };

  // sections: [{ bar, end? (first bar after it), name, vib?, rel? }] → with pos/end in qn
  // A section without vib used to write CC21 points with no value, and REAPER refused the whole item: fill it
  // with SECTION_VIB and say so (rel stays optional: no release CC is written without it)
  const withVib = (s) => {
    if (Number.isFinite(s.vib)) return s;
    warnings.push(`section ${s.name ?? `c.${s.bar}`} has no vib: vibrato CC at ${SECTION_VIB}`);
    return { ...s, vib: SECTION_VIB };
  };
  const placeSections = (list) => list.map((s, i, all) => withVib({ ...s, pos: timeline.pos(s.bar, 0), end: timeline.pos(Math.min(s.end ?? all[i + 1]?.bar ?? lastBar + 2, lastBar + 2), 0) }));
  const sections = placeSections(spec.sections || []);
  // placed: the list already carries pos/end in qn
  const setSections = (list, { placed = false } = {}) => { sections.splice(0, sections.length, ...(placed ? list.map(withVib) : placeSections(list))); };
  const sectionAt = (p) => sections.filter((s) => p >= s.pos - 0.01).pop() || sections[0] || { vib: 0 };

  // percussion writers bind to the declared tracks whose profile has the matching data
  const role = (test) => {
    const name = Object.keys(spec.tracks || {}).find((n) => test(resolve(n).cfg));
    return name ? { name, cfg: resolve(name).cfg } : undefined;
  };
  const writeRng = random.stream("", "write");
  const perc = percussionWriters(score, writeRng, {
    timpani: role((c) => c.roll && c.keyswitches),
    cymbal: role((c) => c.swell && c.hits),
    ensemble: role((c) => c.zones && c.map)
  });
  const orch = orchestraWriters(score);

  // one shared drift for the whole band (drums, and tracks whose profile says followBand), ±maxMs at 120 BPM
  let drift = null;
  const band = () => (drift ??= (() => {
    const b = options.band || {};
    const maxQn = ((b.maxMs ?? 4.5) / 1000) * 2;
    return bandDrift(random.stream("", "band"), timeline.pos(lastBar + 1), { maxQn, step: maxQn / 2 });
  })());

  const breathLog = [];
  const stats = {};
  let performed = false;

  function perform() {
    if (performed) throw new Error("perform() already ran on this piece");
    performed = true;
    // arrivals: hits flagged by their profile (not rolls) and section starts; nobody breathes just before one
    const arrivals = [];
    for (const [name, d] of Object.entries(score.tracks)) {
      const a = resolve(name).cfg.arrivals;
      if (!a) continue;
      const ks = resolve(name).cfg.keyswitches;
      if (a.notRolls) arrivals.push(...d.notes.filter((n) => !n.ks && !d.notes.some((k) => k.ks && k.pitch === ks.map.roll && Math.abs(k.pos + ks.leadQn - n.pos) < 0.02)).map((n) => n.pos));
      if (a.pitches) arrivals.push(...d.notes.filter((n) => !n.ks && a.pitches.includes(n.pitch)).map((n) => n.pos));
    }
    arrivals.push(...sections.map((s) => s.pos));
    const breaths = createBreathPlanner({ timeline, arrivals, mode: options.breaths, log: breathLog });
    for (const names of Object.values(spec.breathGroups || {})) {
      breaths.planShared(names.filter((n) => score.tracks[n]).map((name) => {
        const r = resolve(name);
        return { name, notes: score.tracks[name].notes, dyn: interp(score.tracks[name].dyn, 64), stamina: r.cfg.stamina, wind: r.family !== "strings" };
      }));
    }
    const ctx = { timeline, rng, band, rngKeyed: (k) => random.keyed(k), options, breaths, sections, sectionAt, balance: spec.balance || [], stats, warn: (w) => warnings.push(w) };
    for (const [name, d] of Object.entries(score.tracks)) {
      const r = resolve(name);
      const cfg = { ...r.cfg, style: r.style };
      STYLE[r.style](name, d, cfg, ctx);
      applyBalance(name, d, cfg, ctx);
    }
    return api;
  }

  // Trim same-pitch overlaps, default velocities, then check ranges, monophony and idiom.
  function check({ clashSkip } = {}) {
    if (!performed) perform();
    const errors = [], warns = [];
    const perf = [];
    for (const [name, d] of Object.entries(score.tracks)) {
      const r = resolve(name);
      fixSamePitchOverlaps(d);
      for (const n of d.notes) n.vel = clamp(n.vel ?? 90);
      // a CC point without a number reaches the bridge as null and REAPER rejects the whole item
      const blank = d.cc.filter((c) => !Number.isFinite(c.pb ?? c.value));
      if (blank.length) errors.push(`${name}: ${blank.length} CC points without a value (CC ${[...new Set(blank.map((c) => c.cc ?? "pb"))].join(", ")}), first at ${timeline.fmtPos(blank[0].pos)}`);
      const c = checkNotes(name, d, r.cfg.range, timeline);
      errors.push(...c.errors); warns.push(...c.warnings);
      if (r.cfg.monophonic) errors.push(...checkMonophonic(name, d, timeline).errors);
      if (d.notes.length && !d.dyn.length && r.style !== "percussion" && r.style !== "drums") warns.push(`${name} has no dynamic curve`);
      perf.push({ name, d, instrument: r.instrument, style: r.style, cfg: r.cfg });
    }
    const unpitched = Object.keys(score.tracks).filter((n) => ["percussion", "drums"].includes(resolve(n).style));
    const clashes = findClashes(score.tracks, timeline, { skip: clashSkip ?? unpitched, selfCheck: Object.keys(score.tracks).filter((n) => resolve(n).style === "sampled-long") });
    return { errors, warnings: [...warnings, ...warns], lint: lintIdiom(perf, timeline), clashes, breaths: breathLog };
  }

  // items per track, split at the section bars (single-item tracks: { single: [names] })
  function toBridge({ bounds, names, single = [], title = spec.title || "" } = {}) {
    const B = bounds || [...new Set([1, ...sections.map((s) => s.bar), lastBar + 3])].sort((a, b) => a - b);
    const N = names || Object.fromEntries(sections.map((s) => [s.bar, s.name]));
    const S = new Set(single);
    return Object.fromEntries(Object.entries(score.tracks).map(([t, d]) => [t, trackItems(d, timeline, { bounds: B, names: N, single: S.has(t), title })]));
  }
  function writeBridge(dir, { build, ...opts } = {}) {
    const midi = toBridge(opts);
    writeBridgeFiles(dir, midi, build ? buildSpec(timeline, build) : null);
    return midi;
  }

  const api = {
    spec, timeline, score, tracks: score.tracks, random, rng, registry, options, sections, sectionAt, warnings, stats, breathLog,
    resolve, setSections, perform, check, toBridge, writeBridge,
    // writing
    pos: timeline.pos, barLen: timeline.barLen, note: score.note, noteAt: score.noteAt, chord: score.chord, cc: score.cc, pb: score.pb,
    ramp: score.ramp, line: score.line, dyn: score.dyn, harm: score.harm, progression: score.progression,
    write: writeRng, ...pitch, ...orch, ...perc
  };
  return api;
}
