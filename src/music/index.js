// Public API of the music engine. Design: docs/music-engine.md.
export { createPiece, DEFAULT_OPTIONS } from "./engine.js";
export { createTimeline } from "./core/timeline.js";
export { createScore } from "./core/score.js";
export { createRandom } from "./core/random.js";
export * from "./core/pitch.js";
export { interp, linear, thin, rampPoints, smooth, arc } from "./core/curves.js";
export { clamp } from "./core/util.js";
export { fixSamePitchOverlaps, checkNotes, checkMonophonic, findClashes, lintIdiom } from "./core/validate.js";
export { trackItems, replaceMidi, buildSpec, writeBridgeFiles, fileNameOf } from "./core/bridge.js";
export { loadProfiles, resolveTrack, findPatch, listProfiles, PROFILE_DIR } from "./profiles/profiles.js";
export { swing, bandDrift, humanizeNotes } from "./core/humanize.js";
