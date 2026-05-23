import { parseColor } from "../core/colors.js";
import { buildTrackFilter } from "../core/filters.js";
import { parsePan } from "../core/pan.js";
import { parseDb, parseSwitch } from "../core/values.js";
import { CommandError } from "../core/errors.js";

export function buildColorTracksCommand({ contains, color, all = false }) {
  return {
    type: "color_tracks",
    filter: buildTrackFilter({ contains, all }, "color target"),
    color: parseColor(color)
  };
}

export function buildDeleteTracksCommand({ contains, selected = false, all = false }) {
  return {
    type: "delete_tracks",
    filter: buildTrackFilter({ contains, selected, all }, "delete-tracks target")
  };
}

export function buildSelectTracksCommand(options = {}) {
  return {
    type: "select_tracks",
    filter: buildTrackFilter(options, "select-tracks target"),
    mode: parseSelectionMode(options)
  };
}

export function buildAdjustVolumeCommand({ contains, selected = false, all = false, db }) {
  return {
    type: "adjust_track_volume_db",
    filter: buildTrackFilter({ contains, selected, all }, "volume target"),
    db: parseDb(db, "Volume dB adjustment")
  };
}

export function buildPanCommand({ contains, selected = false, all = false, pan, value }) {
  return {
    type: "set_track_pan",
    filter: buildTrackFilter({ contains, selected, all }, "pan target"),
    pan: parsePan(pan ?? value)
  };
}

export function buildCopyBalanceCommand(options = {}) {
  const sourceBus = options.from || options.source || options.sourceBus || options["source-bus"];
  const targetBus = options.to || options.target || options.targetBus || options["target-bus"];

  if (!sourceBus || !targetBus) {
    throw new CommandError("Missing copy-balance buses. Use --from SOURCE_BUS --to TARGET_BUS.");
  }

  return {
    type: "copy_track_balance",
    sourceBus: String(sourceBus),
    targetBus: String(targetBus),
    includeVolume: options["no-volume"] ? false : options.includeVolume !== false,
    includePan: options["no-pan"] ? false : options.includePan !== false,
    includeBus: options["no-bus"] ? false : options.includeBus !== false
  };
}

export function buildTrackStateCommand(options) {
  const changes = {};
  for (const [option, key] of [
    ["mute", "mute"],
    ["solo", "solo"],
    ["arm", "arm"],
    ["monitor", "monitor"],
    ["hideTcp", "hideTcp"],
    ["hide-tcp", "hideTcp"],
    ["hideMcp", "hideMcp"],
    ["hide-mcp", "hideMcp"]
  ]) {
    if (options[option] !== undefined) changes[key] = parseSwitch(options[option], option);
  }

  if (Object.keys(changes).length === 0) {
    throw new CommandError("Missing track-state change. Use --mute/--solo/--arm/--monitor/--hide-tcp/--hide-mcp on|off|toggle.");
  }

  return {
    type: "set_track_state",
    filter: buildTrackFilter(options, "track-state target"),
    changes
  };
}

export function buildRenameCommand(options) {
  const hasOperation = options.set || options.prefix || options.suffix || options.replace;
  if (!hasOperation) throw new CommandError("Missing rename operation. Use --set, --prefix, --suffix, or --replace with --with.");

  return {
    type: "rename_tracks",
    filter: buildTrackFilter(options, "rename target"),
    set: options.set || null,
    prefix: options.prefix || null,
    suffix: options.suffix || null,
    replace: options.replace ? { from: String(options.replace), to: String(options.with ?? "") } : null
  };
}

export function buildCreateTracksCommand({ count = 1, name = "Track", color = null }) {
  const numericCount = Number(count);
  if (!Number.isInteger(numericCount) || numericCount < 1 || numericCount > 128) {
    throw new CommandError("Track count must be an integer between 1 and 128.");
  }
  return {
    type: "create_tracks",
    count: numericCount,
    name,
    color: color ? parseColor(color) : null
  };
}

function parseSelectionMode(options) {
  if (options.add) return "add";
  if (options.remove) return "remove";
  if (options.toggle) return "toggle";

  const mode = String(options.mode || "replace").toLowerCase();
  if (["replace", "add", "remove", "toggle"].includes(mode)) return mode;
  throw new CommandError("Selection mode must be replace, add, remove, or toggle.");
}
