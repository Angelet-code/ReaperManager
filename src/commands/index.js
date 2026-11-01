import { parseColor } from "../core/colors.js";
import { CommandError } from "../core/errors.js";
import { parsePan } from "../core/pan.js";
import { buildAddFxCommand } from "./fx.js";
import { buildAutoBalanceCommand, buildDetectArrangementCommand } from "./mix.js";
import { buildCreateReturnsCommand } from "./sends.js";

export { parseColor } from "../core/colors.js";
export { AmbiguousCommandError, CommandError } from "../core/errors.js";
export { buildTrackFilter, filterByContains, filterFromSource } from "../core/filters.js";
export { parsePan } from "../core/pan.js";
export { buildColorTracksCommand, buildDeleteTracksCommand, buildSelectTracksCommand, buildAdjustVolumeCommand, buildPanCommand, buildCopyBalanceCommand, buildTrackStateCommand, buildRenameCommand, buildCreateTracksCommand } from "./tracks.js";
export { buildCreateReturnsCommand, buildSendVolumeCommand, buildRouteToBusCommand } from "./sends.js";
export { buildAddFxCommand, buildRemoveFxCommand, buildFxBypassCommand } from "./fx.js";
export { buildGainStageCommand, buildItemVolumeCommand, buildQuantizePlucksCommand, buildSelectItemsCommand, buildSeparateSibilantsCommand, buildVocalLevelCommand } from "./items.js";
export { buildAutoBalanceCommand, buildDetectArrangementCommand, buildInspectProjectCommand } from "./mix.js";
export { buildFolderCommand } from "./folders.js";
export { buildRockTemplateCommand, buildUndoCommand } from "./project.js";

export function normalizeCommand(command, context = {}) {
  if (!command || typeof command !== "object") {
    throw new CommandError("Command must be a JSON object.");
  }

  switch (command.type) {
    case "ping":
    case "shutdown":
    case "undo":
    case "inspect_project":
    case "set_project_regions":
    case "set_project_markers":
    case "sample_edit_probe":
    case "sample_edit_dump":
    case "item_chunk_dump":
      return command;
    case "take_fx_report":
    case "reload_modules":
    case "apply_take_automation":
    case "take_to_new_item":
    case "build_beat":
    case "fx_params":
    case "set_sampler":
    case "replace_midi":
    case "add_midi":
    case "add_track_fx":
    case "swing_midi":
    case "humanize_midi":
    case "lock_midi":
    case "dump_midi":
    case "delete_midi_notes":
    case "shift_pitch":
    case "set_cc_shape":
    case "show_fx":
    case "adjust_velocity":
    case "write_envelope":
    case "open_project":
    case "flatten_tempo":
      return command;
    case "remove_takes_matching":
      if (!command.match) throw new CommandError("remove_takes_matching needs a match string.");
      return command;
    case "add_take_from_file":
      if (!command.file) throw new CommandError("add_take_from_file needs a file.");
      return command;
    case "sample_edit_apply":
      if (!Array.isArray(command.channels) || command.channels.length === 0) {
        throw new CommandError("sample_edit_apply needs a non-empty channels array.");
      }
      return command;
    case "detect_arrangement":
      return buildDetectArrangementCommand(command);
    case "auto_balance_mix":
      return buildAutoBalanceCommand(command);
    case "color_tracks":
      return {
        type: "color_tracks",
        filter: command.filter,
        color: parseColor(command.color)
      };
    case "create_fx_returns":
      return buildCreateReturnsCommand({
        count: command.count,
        fx: command.fx?.query || command.fx?.name || command.fx,
        from: command.sendSource,
        prefs: context.prefs,
        aliases: context.aliases,
        pluginEntries: context.pluginEntries
      });
    case "add_fx_to_tracks":
      return buildAddFxCommand({
        contains: command.filter?.value,
        selected: command.filter?.type === "selected",
        fx: command.fx?.query || command.fx?.name || command.fx,
        aliases: context.aliases,
        pluginEntries: context.pluginEntries
      });
    case "remove_fx_from_tracks":
    case "delete_tracks":
      return {
        type: command.type,
        filter: command.filter || { type: "selected" }
      };
    case "select_tracks":
      return {
        type: "select_tracks",
        filter: command.filter || { type: "selected" },
        mode: command.mode || "replace"
      };
    case "select_items":
      return {
        type: "select_items",
        itemFilter: command.itemFilter || command.filter || { type: "selected" },
        mode: command.mode || "replace"
      };
    case "adjust_track_volume_db":
      return {
        type: "adjust_track_volume_db",
        filter: command.filter || { type: "selected" },
        db: Number(command.db)
      };
    case "set_track_pan":
      return { type: "set_track_pan", filter: command.filter || { type: "selected" }, pan: parsePan(command.pan) };
    case "copy_track_balance":
      return {
        type: "copy_track_balance",
        sourceBus: command.sourceBus || command.from || command.source,
        targetBus: command.targetBus || command.to || command.target,
        includeVolume: command.includeVolume !== false,
        includePan: command.includePan !== false,
        includeBus: command.includeBus !== false
      };
    case "adjust_send_volume_db":
      return {
        type: "adjust_send_volume_db",
        filter: command.filter || { type: "selected" },
        destinationContains: command.destinationContains || null,
        db: Number(command.db)
      };
    case "adjust_item_volume_db":
    case "gain_stage_items":
    case "quantize_pluck_items":
    case "separate_vocal_sibilants":
    case "vocal_level_items":
    case "set_track_state":
    case "rename_tracks":
    case "create_tracks":
    case "create_folder_for_tracks":
    case "route_tracks_to_bus":
    case "set_fx_bypass":
    case "create_rock_template":
      return command;
    default:
      throw new CommandError(`Unsupported command type "${command.type}".`);
  }
}
