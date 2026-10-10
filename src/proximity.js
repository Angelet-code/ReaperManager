import { execFileSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { CommandError } from "./core/errors.js";
import { declipSourceRange, resolveDeclipPython } from "./declip.js";

const MODULE_DIR = path.dirname(fileURLToPath(import.meta.url));
export const PROXIMITY_SCRIPT = path.resolve(MODULE_DIR, "..", "scripts", "proximity.py");
export const PROXIMITY_MARKER_PREFIX = "PROX";
const MARKER_COLOR = "#ff8c00";

const TUNING = [
  // [cli option, python flag, label, min, max]
  ["h12-drop-db", "--h12-drop-db", "H1+H2 drop dB", 1, 40],
  ["min-z", "--min-z", "Take model sigmas", 0, 5],
  ["level-drop-db", "--level-drop-db", "Level drop dB", 0, 20],
  ["loud-db", "--loud-db", "Loud dB", 0, 20],
  ["amount", "--amount", "Amount", 0, 2],
  ["level-amount", "--level-amount", "Level amount", 0, 2],
  ["loud-amount", "--loud-amount", "Loud amount", 0, 2],
  ["hit-share", "--hit-share", "Hit share", 0, 1.5],
  ["mic-cm", "--mic-cm", "Mic distance cm", 1, 100],
  ["min-level-db", "--min-level-db", "Min level dB below take", 3, 60]
];

// Whole item by default; --selection limits the report to the time selection.
export function proximitySourceRange(probe, { selection = false } = {}) {
  return declipSourceRange(probe, { item: !selection });
}

// "<source> prox-fix.wav" next to the source, so the project media folder keeps it.
// Numbered when taken: an earlier render may still be open as a take in REAPER.
export function proximityFixPath(sourceFile, exists = fs.existsSync) {
  const parsed = path.parse(sourceFile);
  let candidate = path.join(parsed.dir, `${parsed.name} prox-fix.wav`);
  for (let n = 2; exists(candidate); n += 1) {
    candidate = path.join(parsed.dir, `${parsed.name} prox-fix ${n}.wav`);
  }
  return candidate;
}

export function buildProximityArgs(options, sourceFile, range, { max = 30, render = null } = {}) {
  const args = [PROXIMITY_SCRIPT, sourceFile, "--start-s", String(range.startS), "--end-s", String(range.endS), "--max", String(max)];
  if (render) args.push("--render", render);
  for (const [key, flag, label, min, max] of TUNING) {
    if (options[key] === undefined) continue;
    const value = Number(options[key]);
    if (!Number.isFinite(value) || value < min || value > max) {
      throw new CommandError(`${label} must be a number between ${min} and ${max}.`);
    }
    args.push(flag, String(value));
  }
  return args;
}

export function sourceToProjectTime(probe, sourceS) {
  const rate = Number(probe.take_playrate) || 1;
  return Number(probe.item_position) + (sourceS - (Number(probe.take_offset) || 0)) / rate;
}

// "PROX 1 LEJOS x2.0 lvl -6" / "PROX 4 FUERTE lvl +2.8": diagnosis, distance ratio, level vs neighbours.
export function markerName(rank, syl) {
  const gap = syl.fix_level_gap_db ?? -syl.level_drop_db;
  const level = `lvl ${gap > 0 ? "-" : "+"}${Math.abs(gap)}`;
  if (syl.kind === "fuerte") return `${PROXIMITY_MARKER_PREFIX} ${rank} FUERTE ${level}`;
  if (syl.kind === "lejos") return `${PROXIMITY_MARKER_PREFIX} ${rank} LEJOS x${Number(syl.distance_ratio).toFixed(1)} ${level}`;
  return `${PROXIMITY_MARKER_PREFIX} ${rank} H12 ${syl.h12_drop_db} lvl ${syl.level_drop_db}`;
}

// Rank = position in score order, so "PROX 1" is the strongest suspect.
export function buildProximityMarkers(probe, syllables, { max = 30 } = {}) {
  const ranked = [...syllables].sort((a, b) => b.score - a.score).slice(0, max);
  return ranked
    .map((syl, index) => ({
      name: markerName(index + 1, syl),
      position: Number(sourceToProjectTime(probe, syl.fix_start ?? syl.start).toFixed(4)),
      color: MARKER_COLOR
    }))
    .sort((a, b) => a.position - b.position);
}

// Item-relative envelope points (seconds, dB). Each correction window becomes a
// plateau with linear ramps of fadeS outside it; windows closer than 2 * fadeS with
// the same values are merged. Touching plateaus with different values (a FUERTE
// hit followed by its vowel) are joined by a direct ramp ending where the next one
// starts, without dropping back to 0 dB. FUERTE windows only carry volume.
export function buildAutomationPoints(probe, syllables, { fadeS = 0.02 } = {}) {
  const rate = Number(probe.take_playrate) || 1;
  const offset = Number(probe.take_offset) || 0;
  const length = Number(probe.item_length);
  const rel = (sourceS) => (sourceS - offset) / rate;
  const spans = [];
  for (const syl of syllables) {
    if (syl.hit_window && syl.hit_gain_db) {
      spans.push({ start: rel(syl.hit_window[0]), end: rel(syl.hit_window[1]), gain: syl.hit_gain_db, eq: 0 });
    }
    for (const [a, b] of syl.windows || [[syl.fix_start ?? syl.start, syl.fix_end ?? syl.end]]) {
      spans.push({ start: rel(a), end: rel(b), gain: syl.fix_level_db || 0, eq: syl.shelf_db || 0 });
    }
  }
  spans.sort((x, y) => x.start - y.start);

  const envelope = (key) => {
    const merged = [];
    for (const span of spans.filter((item) => item[key] !== 0)) {
      const last = merged[merged.length - 1];
      if (last && span.start - last.end < 2 * fadeS && last.value === span[key]) {
        last.end = Math.max(last.end, span.end);
      } else {
        merged.push({ start: span.start, end: span.end, value: span[key] });
      }
    }
    const points = [[0, 0]];
    merged.forEach((span, index) => {
      const prev = merged[index - 1];
      const next = merged[index + 1];
      const joinedPrev = prev && span.start - prev.end < 2 * fadeS;
      const joinedNext = next && next.start - span.end < 2 * fadeS;
      const value = Number(span.value.toFixed(2));
      if (!joinedPrev) {
        const room = prev ? (span.start - prev.end) / 2 : span.start;
        points.push([span.start - Math.max(0, Math.min(fadeS, room)), 0]);
      }
      points.push([span.start, value]);
      if (joinedNext) {
        points.push([Math.max(span.start, Math.min(span.end, next.start) - fadeS), value]);
      } else {
        points.push([span.end, value]);
        const room = next ? (next.start - span.end) / 2 : length - span.end;
        points.push([span.end + Math.max(0, Math.min(fadeS, room)), 0]);
      }
    });
    points.push([length, 0]);
    return points.map(([t, db]) => [Number(Math.max(0, Math.min(length, t)).toFixed(4)), db]);
  };

  const eq = envelope("eq");
  return { volume: envelope("gain"), eq: eq.length > 2 ? eq : [] };
}

// --fix: earlier prox-fix takes removed (undo step) -> probe -> python analysis
// -> (unless preview) one set_project_markers = one undo step
// -> with --fix, take automation (volume envelope + "Proximity EQ" ReaEQ shelf) on the
//    original take = another undo step; with --fix --render, a corrected render as a new take.
export async function runProximityDetect(options, { request }) {
  if (options.fix && !options.preview) {
    // keep the item at original + one fix: earlier prox-fix takes go, the original is reactivated
    const cleanup = await request({ type: "remove_takes_matching", match: " prox-fix" });
    if (!cleanup?.ok) throw new CommandError(cleanup?.error || "remove_takes_matching failed.");
  }
  const probeResponse = await request({ type: "sample_edit_probe" });
  if (!probeResponse?.ok) throw new CommandError(probeResponse?.error || "sample_edit_probe failed.");
  const probe = probeResponse.data;
  if (/ prox-fix( \d+)?\.wav$/i.test(probe.source_file || "")) {
    throw new CommandError("The active take is already a prox-fix render; activate the original take first.");
  }
  if (!/\.wav$/i.test(probe.source_file || "")) {
    throw new CommandError(`proximity-detect reads WAV sources only (active take: ${probe.source_file || "none"}).`);
  }

  const max = options.max === undefined ? 30 : Number(options.max);
  if (!Number.isInteger(max) || max < 1 || max > 200) throw new CommandError("--max must be an integer between 1 and 200.");

  const range = proximitySourceRange(probe, { selection: Boolean(options.selection) });
  const python = resolveDeclipPython(options);
  let result;
  try {
    const render = options.fix && options.render && !options.preview ? proximityFixPath(probe.source_file) : null;
    const stdout = execFileSync(python, buildProximityArgs(options, probe.source_file, range, { max, render }), {
      encoding: "utf8",
      timeout: Number(options.timeout || 10 * 60 * 1000),
      maxBuffer: 16 * 1024 * 1024
    });
    result = JSON.parse(stdout.trim().split(/\r?\n/).pop());
  } catch (error) {
    const text = String(error.stdout || "").trim().split(/\r?\n/).pop();
    let detail = error.message;
    try { detail = JSON.parse(text).error || detail; } catch { /* keep message */ }
    throw new CommandError(`proximity analysis failed: ${detail}`);
  }

  const markers = buildProximityMarkers(probe, result.syllables, { max });
  const report = {
    source: probe.source_file,
    model: result.model,
    found: result.syllables.length,
    markers: markers.map((marker) => ({ name: marker.name, position: marker.position })),
    preview: Boolean(options.preview)
  };
  if (options.preview) return { ...report, applied: false };

  const applied = await request({
    type: "set_project_markers",
    clearPrefix: `${PROXIMITY_MARKER_PREFIX} `,
    markers
  });
  if (!applied?.ok) throw new CommandError(applied?.error || "set_project_markers failed.");
  const done = { ...report, applied: true, created: applied.data.created, cleared: applied.data.cleared };
  if (!options.fix) return done;

  const fixes = result.syllables.map((syl) => ({
    kind: syl.kind,
    position: Number(sourceToProjectTime(probe, syl.fix_start ?? syl.start).toFixed(3)),
    end: Number(sourceToProjectTime(probe, syl.fix_end ?? syl.end).toFixed(3)),
    distance_ratio: syl.distance_ratio,
    shelf_db: syl.shelf_db,
    eq_level_db: syl.fix_level_from_eq_db,
    gain_db: syl.fix_level_db
  }));

  if (options.render) {
    if (!result.rendered) throw new CommandError("proximity render produced no file.");
    const take = await request({ type: "add_take_from_file", takeGuid: probe.take_guid, file: result.rendered, name: path.parse(result.rendered).name });
    if (!take?.ok) throw new CommandError(take?.error || "add_take_from_file failed.");
    return { ...done, fixes, fixTake: take.data };
  }

  const fadeMs = options["fade-ms"] === undefined ? 20 : Number(options["fade-ms"]);
  if (!Number.isFinite(fadeMs) || fadeMs < 0 || fadeMs > 500) throw new CommandError("--fade-ms must be between 0 and 500.");
  const shelfHz = result.syllables.find((syl) => syl.shelf_hz)?.shelf_hz ?? 273;
  const points = buildAutomationPoints(probe, result.syllables, { fadeS: fadeMs / 1000 });
  const automation = await request({
    type: "apply_take_automation",
    takeGuid: probe.take_guid,
    replace: Boolean(options["replace-envelope"]),
    shelfFreqHz: shelfHz,
    volumePoints: points.volume,
    eqPoints: points.eq
  });
  if (!automation?.ok) throw new CommandError(automation?.error || "apply_take_automation failed.");
  return { ...done, fixes, shelfHz, automation: automation.data };
}
