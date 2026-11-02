// Music engine queries for the CLI: which profiles exist, what a track declaration resolves to, and which
// values are still assumed (to calibrate). The engine itself lives in src/music (docs/music-engine.md).
import { listProfiles, loadProfiles, resolveTrack } from "../music/index.js";

// music profiles [--assumed]: every patch with its style and the blocks still marked A (assumed)
export function musicProfiles({ assumedOnly = false } = {}) {
  const rows = listProfiles(loadProfiles());
  return assumedOnly ? rows.filter((r) => r.assumed.length || r.template) : rows;
}

// music resolve --profile swam/flute-3 [--instrument flute] [--style modeled]: the merged config and warnings
export function musicResolve({ profile, patch, style, instrument, name = "TRACK" } = {}) {
  if (!profile && !patch && !style) throw new Error("music resolve needs --profile, --patch or --style.");
  return resolveTrack(loadProfiles(), name, { profile, patch, style, instrument });
}
