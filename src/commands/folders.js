import { parseColor } from "../core/colors.js";
import { buildTrackFilter } from "../core/filters.js";

export function buildFolderCommand(options) {
  return {
    type: "create_folder_for_tracks",
    filter: buildTrackFilter(options, "folder children target"),
    name: options.name || "Folder",
    color: options.color ? parseColor(options.color) : null
  };
}
