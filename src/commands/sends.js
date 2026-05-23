import { VALID_SEND_SOURCES } from "../constants.js";
import { AmbiguousCommandError, CommandError } from "../core/errors.js";
import { buildTrackFilter, filterFromSource } from "../core/filters.js";
import { parseDb } from "../core/values.js";
import { resolvePlugin } from "../plugin-cache.js";

export function buildCreateReturnsCommand({ count = 1, fx, from, prefs, aliases, pluginEntries }) {
  const numericCount = Number(count);
  if (!Number.isInteger(numericCount) || numericCount < 1 || numericCount > 16) {
    throw new CommandError("Return count must be an integer between 1 and 16.");
  }

  const source = from || prefs?.defaultSendSource;
  if (!source) {
    throw new AmbiguousCommandError(
      "No send source specified. Use --from selected, --from none, or set prefs.defaultSendSource."
    );
  }

  if (!VALID_SEND_SOURCES.has(source)) {
    throw new CommandError(`Invalid send source "${source}".`);
  }

  const resolvedFx = resolvePlugin(fx, { aliases, entries: pluginEntries });

  return {
    type: "create_fx_returns",
    count: numericCount,
    baseName: resolvedFx.name || String(fx),
    fx: resolvedFx,
    sendSource: source,
    sourceFilter: filterFromSource(source),
    sendVolumeDb: -18
  };
}

export function buildSendVolumeCommand({ contains, selected = false, all = false, db, dest, destination }) {
  return {
    type: "adjust_send_volume_db",
    filter: buildTrackFilter({ contains, selected, all }, "send source target"),
    destinationContains: dest || destination || null,
    db: parseDb(db, "Send dB adjustment")
  };
}

export function buildRouteToBusCommand(options) {
  return {
    type: "route_tracks_to_bus",
    filter: buildTrackFilter(options, "route source target"),
    busName: options.bus || options.name || "Bus",
    create: options.create !== "false",
    disableMain: Boolean(options["disable-main"] || options.disableMain),
    sendVolumeDb: options.db !== undefined ? Number(options.db) : 0
  };
}
