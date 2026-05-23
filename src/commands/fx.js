import { buildTrackFilter } from "../core/filters.js";
import { parseSwitch } from "../core/values.js";
import { resolvePlugin } from "../plugin-cache.js";

export function buildAddFxCommand({ contains, selected = false, fx, aliases, pluginEntries }) {
  const resolvedFx = resolvePlugin(fx, { aliases, entries: pluginEntries });
  return {
    type: "add_fx_to_tracks",
    filter: buildTrackFilter({ contains, selected }, "FX target"),
    fx: resolvedFx
  };
}

export function buildRemoveFxCommand({ contains, selected = false, all = false }) {
  return {
    type: "remove_fx_from_tracks",
    filter: buildTrackFilter({ contains, selected, all }, "remove-fx target")
  };
}

export function buildFxBypassCommand(options) {
  const state = parseSwitch(options.state ?? options.bypass ?? "toggle", "fx bypass state");
  return {
    type: "set_fx_bypass",
    filter: buildTrackFilter(options, "FX bypass target"),
    fxContains: options.fx || options.plugin || null,
    state
  };
}
