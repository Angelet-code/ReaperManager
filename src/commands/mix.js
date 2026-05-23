import { CommandError } from "../core/errors.js";

export function buildInspectProjectCommand() {
  return {
    type: "inspect_project"
  };
}

export function buildDetectArrangementCommand(options = {}) {
  const preview = Boolean(options.preview);
  const command = {
    type: "detect_arrangement",
    preview,
    applyMarkers: options.applyMarkers === false ? false : !preview,
    clearExisting: options.clearExisting !== false && !options["no-clear"],
    detectBreaks: options.detectBreaks !== false && !options["no-breaks"]
  };

  addNumberOption(command, "unitsPerBar", options.unitsPerBar ?? options["units-per-bar"], 1, 8);
  addNumberOption(command, "sampleStride", options.sampleStride ?? options["sample-stride"], 1, 4096);
  addNumberOption(command, "activeDb", options.activeDb ?? options["active-db"], -80, -6);
  addNumberOption(command, "vocalThreshold", options.vocalThreshold ?? options["vocal-threshold"], 0, 1);
  addNumberOption(command, "chorusStartThreshold", options.chorusStartThreshold ?? options["chorus-start-threshold"], 0, 1);
  addNumberOption(command, "chorusContinueThreshold", options.chorusContinueThreshold ?? options["chorus-continue-threshold"], 0, 1);
  addNumberOption(command, "prechorusBars", options.prechorusBars ?? options["prechorus-bars"], 1, 16);
  addNumberOption(command, "prechorusMinGapBars", options.prechorusMinGapBars ?? options["prechorus-min-gap-bars"], 1, 32);

  return command;
}

export function buildAutoBalanceCommand(options = {}) {
  const genre = normalizeGenre(options.genre || options.g || "pop-rock");
  const command = {
    type: "auto_balance_mix",
    genre,
    preview: Boolean(options.preview),
    maxDeltaDb: parseNumberOption(options.maxDelta ?? options["max-delta"] ?? 12, "Max auto-balance movement", 0.5, 24)
  };
  if (options.referenceHierarchy) command.referenceHierarchy = options.referenceHierarchy;
  if (options.balanceSections) command.balanceSections = options.balanceSections;
  return command;
}

function addNumberOption(command, key, value, min, max) {
  if (value === undefined || value === null || value === false) return;
  command[key] = parseNumberOption(value, key, min, max);
}

function normalizeGenre(value) {
  const text = String(value || "").trim().toLowerCase();
  if (text === "pop-rock" || text === "poprock" || text === "pop rock") return "pop-rock";
  throw new CommandError("Unsupported auto-balance genre. Use --genre pop-rock.");
}

function parseNumberOption(value, label, min, max) {
  const numeric = Number(value);
  if (!Number.isFinite(numeric) || numeric < min || numeric > max) {
    throw new CommandError(`${label} must be a number between ${min} and ${max}.`);
  }
  return numeric;
}
