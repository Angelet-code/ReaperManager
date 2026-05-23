import { CommandError } from "./errors.js";

export function filterByContains(value) {
  const text = String(value || "").trim();
  if (!text) throw new CommandError("Missing track name filter.");
  return {
    type: "name_contains",
    value: text,
    caseSensitive: false
  };
}

export function buildTrackFilter(options = {}, label = "target") {
  const { contains, selected = false, all = false, allAudio = false } = options;
  if (all) return { type: "all" };
  if (allAudio || options["all-audio"]) return { type: "all_audio" };
  if (selected) return { type: "selected" };
  if (contains) return filterByContains(contains);
  throw new CommandError(`Missing ${label}. Use --all, --selected, --all-audio, or --contains NAME.`);
}

export function filterFromSource(source) {
  if (source === "selected") return { type: "selected" };
  if (source === "all-audio") return { type: "all_audio" };
  if (source === "all") return { type: "all" };
  if (source === "none") return null;
  throw new CommandError(`Unknown track source "${source}".`);
}
