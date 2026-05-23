import { DEFAULT_ALIASES } from "./constants.js";
import { readJson, writeJsonAtomic } from "./fs-utils.js";
import { ensureManagerDirs, preferencesPath } from "./paths.js";

export function defaultPreferences() {
  return {
    defaultSendSource: null,
    aliases: DEFAULT_ALIASES
  };
}

export function loadPreferences(root) {
  const prefs = readJson(preferencesPath(root), null);
  if (!prefs) return defaultPreferences();

  return {
    ...defaultPreferences(),
    ...prefs,
    aliases: {
      ...DEFAULT_ALIASES,
      ...(prefs.aliases || {})
    }
  };
}

export function savePreferences(root, preferences) {
  ensureManagerDirs(root);
  writeJsonAtomic(preferencesPath(root), preferences);
}
