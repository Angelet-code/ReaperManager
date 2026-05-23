import { buildTrackFilter } from "../core/filters.js";
import { CommandError } from "../core/errors.js";
import { parseDb } from "../core/values.js";

export function buildItemVolumeCommand({ selected = false, contains, all = false, db }) {
  return {
    type: "adjust_item_volume_db",
    itemFilter: selected ? { type: "selected" } : { type: "tracks", trackFilter: buildTrackFilter({ contains, all }, "item target") },
    db: parseDb(db, "Item dB adjustment")
  };
}

export function buildSelectItemsCommand(options = {}) {
  return {
    type: "select_items",
    itemFilter: buildItemFilter(options, "select-items target"),
    mode: parseSelectionMode(options)
  };
}

export function buildGainStageCommand(options = {}) {
  return {
    type: "gain_stage_items",
    itemFilter: buildItemFilter(options, "gain-stage target"),
    preview: Boolean(options.preview),
    calibrationDb: parseNumberOption(options.calibration ?? options.cal ?? -18, "Calibration dB", -30, -6),
    targetVu: parseNumberOption(options.targetVu ?? options["target-vu"] ?? options.target ?? 0, "Target VU", -12, 12),
    peakCeilingDb: parseNumberOption(options.peakCeiling ?? options["peak-ceiling"] ?? options.ceiling ?? -0.3, "Peak ceiling dBFS", -24, 0),
    maxBoostDb: parseNumberOption(options.maxBoost ?? options["max-boost"] ?? 24, "Max boost dB", 0, 60),
    windowMs: parseNumberOption(options.windowMs ?? options["window-ms"] ?? 300, "Window length ms", 50, 2000),
    silenceDb: parseNumberOption(options.silenceDb ?? options["silence-db"] ?? -60, "Silence threshold dBFS", -120, -20),
    topWindowPercent: parseNumberOption(options.topWindowPercent ?? options["top-window-percent"] ?? 5, "Top window percent", 1, 50)
  };
}

export function buildVocalLevelCommand(options = {}) {
  if (!options.selectedItems && !options["selected-items"]) {
    throw new CommandError("Missing vocal-level target. Use --selected-items.");
  }

  const sustainLowPercent = parseNumberOption(options.sustainLowPercent ?? options["sustain-low-percent"] ?? 50, "Sustain low percent", 0, 99);
  const sustainHighPercent = parseNumberOption(options.sustainHighPercent ?? options["sustain-high-percent"] ?? 90, "Sustain high percent", 1, 100);
  if (sustainHighPercent <= sustainLowPercent) {
    throw new CommandError("Sustain high percent must be greater than sustain low percent.");
  }

  return {
    type: "vocal_level_items",
    itemFilter: { type: "selected" },
    preview: Boolean(options.preview),
    leaveFirstSelected: parseBooleanOption(options.leaveFirstSelected ?? options["leave-first-selected"], "Leave first selected", false),
    selectedItemIndex: parseOptionalIntegerOption(options.selectedItemIndex ?? options["selected-item-index"], "Selected item index", 1, 10000),
    variantLabel: parseOptionalStringOption(options.variantLabel ?? options["variant-label"]),
    calibrationDb: parseNumberOption(options.calibration ?? options.cal ?? -18, "Calibration dB", -30, -6),
    targetVu: parseNumberOption(options.targetVu ?? options["target-vu"] ?? options.target ?? 0, "Target VU", -12, 12),
    peakCeilingDb: parseNumberOption(options.peakCeiling ?? options["peak-ceiling"] ?? options.ceiling ?? -0.3, "Peak ceiling dBFS", -24, 0),
    maxBoostDb: parseNumberOption(options.maxBoost ?? options["max-boost"] ?? 12, "Max boost dB", 0, 60),
    maxCutDb: parseNumberOption(options.maxCut ?? options["max-cut"] ?? options.maxCutDb ?? options["max-cut-db"] ?? 12, "Max cut dB", 0, 60),
    replaceEnvelope: parseBooleanOption(options.replaceEnvelope ?? options["replace-envelope"], "Replace envelope", false),
    windowMs: parseNumberOption(options.windowMs ?? options["window-ms"] ?? 120, "Window length ms", 30, 2000),
    silenceDb: parseNumberOption(options.silenceDb ?? options["silence-db"] ?? -60, "Silence threshold dBFS", -120, -20),
    topWindowPercent: parseNumberOption(options.topWindowPercent ?? options["top-window-percent"] ?? 5, "Top window percent", 1, 50),
    measurementMode: parseMeasurementMode(options.measurementMode ?? options["measurement-mode"] ?? "sustain_robust"),
    levelMode: parseLevelMode(options.levelMode ?? options["level-mode"] ?? "absolute"),
    automationMode: parseAutomationMode(options.automationMode ?? options["automation-mode"] ?? "smooth_curve"),
    referencePercentile: parseNumberOption(options.referencePercentile ?? options["reference-percentile"] ?? 65, "Reference percentile", 1, 99),
    stabilizeBoostDb: parseNumberOption(options.stabilizeBoostDb ?? options["stabilize-boost-db"] ?? 3.2, "Stabilize boost dB", 0, 24),
    stabilizeCutDb: parseNumberOption(options.stabilizeCutDb ?? options["stabilize-cut-db"] ?? 7, "Stabilize cut dB", 0, 24),
    gainDeadbandDb: parseNumberOption(options.gainDeadbandDb ?? options["gain-deadband-db"] ?? 3, "Gain deadband dB", 0, 12),
    preserveLoudness: parseNumberOption(options.preserveLoudness ?? options["preserve-loudness"] ?? 1, "Preserve loudness", 0, 1),
    sustainLowPercent,
    sustainHighPercent,
    transientCrestDb: parseNumberOption(options.transientCrestDb ?? options["transient-crest-db"] ?? 6, "Transient crest dB", 0, 30),
    detectWindowMs: parseNumberOption(options.detectWindowMs ?? options["detect-window-ms"] ?? options.gateWindowMs ?? options["gate-window-ms"] ?? 15, "Detection window length ms", 10, 500),
    detectSilenceDb: parseNumberOption(options.detectSilenceDb ?? options["detect-silence-db"] ?? -45, "Detection silence threshold dBFS", -120, -20),
    detectRangeDb: parseNumberOption(options.detectRangeDb ?? options["detect-range-db"] ?? options.gateRangeDb ?? options["gate-range-db"] ?? 35, "Detection range dB", 6, 100),
    partMergeGapMs: parseNumberOption(options.partMergeGapMs ?? options["part-merge-gap-ms"] ?? options.activationMergeGapMs ?? options["activation-merge-gap-ms"] ?? 350, "Part merge gap ms", 0, 3000),
    minPartMs: parseNumberOption(options.minPartMs ?? options["min-part-ms"] ?? options.minActivationMs ?? options["min-activation-ms"] ?? options.minPhraseMs ?? options["min-phrase-ms"] ?? 300, "Minimum part length ms", 50, 10000),
    syllableSplitDb: parseNumberOption(options.syllableSplitDb ?? options["syllable-split-db"] ?? 20, "Syllable split dB", 0, 40),
    syllableSplitHoldMs: parseNumberOption(options.syllableSplitHoldMs ?? options["syllable-split-hold-ms"] ?? 140, "Syllable split hold ms", 0, 1000),
    minGainChangeDb: parseNumberOption(options.minGainChangeDb ?? options["min-gain-change-db"] ?? 5, "Minimum gain change dB", 0, 24),
    gainMergeGapMs: parseNumberOption(options.gainMergeGapMs ?? options["gain-merge-gap-ms"] ?? 0, "Gain merge gap ms", 0, 500),
    zeroCrossing: parseBooleanOption(options.zeroCrossing ?? options["zero-crossing"], "Zero crossing", true),
    zeroCrossingSearchMs: parseNumberOption(options.zeroCrossingSearchMs ?? options["zero-crossing-search-ms"] ?? 12, "Zero crossing search ms", 0, 100),
    curveSmoothMs: parseNumberOption(options.curveSmoothMs ?? options["curve-smooth-ms"] ?? 320, "Curve smoothing ms", 0, 1000),
    curveToleranceDb: parseNumberOption(options.curveToleranceDb ?? options["curve-tolerance-db"] ?? 2, "Curve tolerance dB", 0, 12),
    curveMinPointGapMs: parseNumberOption(options.curveMinPointGapMs ?? options["curve-min-point-gap-ms"] ?? 240, "Curve minimum point gap ms", 0, 1000),
    curveDetail: parseNumberOption(options.curveDetail ?? options["curve-detail"] ?? 0.5, "Curve detail", 0, 1),
    curveEdgeRampMs: parseNumberOption(options.curveEdgeRampMs ?? options["curve-edge-ramp-ms"] ?? 80, "Curve edge ramp ms", 0, 500),
    paddingMs: parseNumberOption(options.paddingMs ?? options["padding-ms"] ?? 8, "Part padding ms", 0, 500),
    rampMs: parseNumberOption(options.rampMs ?? options["ramp-ms"] ?? 0, "Ramp length ms", 0, 500)
  };
}

function buildItemFilter(options, label) {
  if (options.allItems || options["all-items"]) return { type: "all" };
  if (options.selectedItems || options["selected-items"] || options.selected) return { type: "selected" };
  if (options.selectedTracks || options["selected-tracks"]) {
    return { type: "tracks", trackFilter: { type: "selected" } };
  }
  if (options.contains) return { type: "tracks", trackFilter: buildTrackFilter({ contains: options.contains }, label) };
  if (options.all) return { type: "all" };

  throw new CommandError(`Missing ${label}. Use --all-items, --selected-items, --selected-tracks, or --contains NAME.`);
}

function parseNumberOption(value, label, min, max) {
  const numeric = Number(value);
  if (!Number.isFinite(numeric) || numeric < min || numeric > max) {
    throw new CommandError(`${label} must be a number between ${min} and ${max}.`);
  }
  return numeric;
}

function parseBooleanOption(value, label, fallback) {
  if (value === undefined || value === null) return fallback;
  if (typeof value === "boolean") return value;

  const normalized = String(value).trim().toLowerCase();
  if (["1", "true", "yes", "on", "si", "sí"].includes(normalized)) return true;
  if (["0", "false", "no", "off"].includes(normalized)) return false;

  throw new CommandError(`${label} must be true or false.`);
}

function parseOptionalIntegerOption(value, label, min, max) {
  if (value === undefined || value === null || value === false) return undefined;
  const numeric = Number(value);
  if (!Number.isInteger(numeric) || numeric < min || numeric > max) {
    throw new CommandError(`${label} must be an integer between ${min} and ${max}.`);
  }
  return numeric;
}

function parseOptionalStringOption(value) {
  if (value === undefined || value === null || value === false) return undefined;
  return String(value);
}

function parseMeasurementMode(value) {
  const mode = String(value || "gain_stage").toLowerCase().replace(/-/g, "_");
  if (["sustain_robust", "gain_stage"].includes(mode)) return mode;
  throw new CommandError("Measurement mode must be sustain_robust or gain_stage.");
}

function parseLevelMode(value) {
  const mode = String(value || "relative").toLowerCase().replace(/-/g, "_");
  if (["relative", "absolute"].includes(mode)) return mode;
  throw new CommandError("Level mode must be relative or absolute.");
}

function parseAutomationMode(value) {
  const mode = String(value || "smooth_curve").toLowerCase().replace(/-/g, "_");
  if (["smooth_curve", "steps"].includes(mode)) return mode;
  throw new CommandError("Automation mode must be smooth_curve or steps.");
}

function parseSelectionMode(options) {
  if (options.add) return "add";
  if (options.remove) return "remove";
  if (options.toggle) return "toggle";

  const mode = String(options.mode || "replace").toLowerCase();
  if (["replace", "add", "remove", "toggle"].includes(mode)) return mode;
  throw new CommandError("Selection mode must be replace, add, remove, or toggle.");
}
