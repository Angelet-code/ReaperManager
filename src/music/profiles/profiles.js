// Loads instrument profiles (data) and resolves a track declaration into one config for its style.
// Layers, later wins: generic style block → generic family block → player (instrument) → library defaults →
// patch → the piece's overrides. Missing or unknown data falls back to generic values with a warning.
import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import { merge } from "../core/util.js";

export const PROFILE_DIR = fileURLToPath(new URL(".", import.meta.url));
const STYLES = ["sampled-legato", "sampled-long", "sampled-short", "modeled", "piano", "percussion", "drums"];

const readJson = (file) => JSON.parse(readFileSync(file, "utf8"));
const get = (obj, path) => path.split(".").reduce((o, k) => (o == null ? undefined : o[k]), obj);

export function loadProfiles(dir = PROFILE_DIR) {
  const generic = readJson(join(dir, "_generic.json"));
  const players = readJson(join(dir, "_players.json"));
  const libraries = {};
  for (const f of readdirSync(dir)) {
    if (!f.endsWith(".json") || f.startsWith("_")) continue;
    libraries[f.replace(/\.json$/, "")] = readJson(join(dir, f));
  }
  return { dir, generic, players, libraries };
}

// Find a patch by "library/patch" id or by a plugin/patch name listed in its `match`.
export function findPatch(registry, { profile, patch } = {}) {
  if (profile) {
    const [lib, id] = profile.split("/");
    const L = registry.libraries[lib];
    if (L && id && L.patches?.[id]) return { libraryId: lib, patchId: id, library: L, patch: L.patches[id] };
    return null;
  }
  if (patch) {
    for (const [lib, L] of Object.entries(registry.libraries)) {
      if (L.template) continue;
      for (const [id, P] of Object.entries(L.patches || {})) if ((P.match || []).includes(patch)) return { libraryId: lib, patchId: id, library: L, patch: P };
    }
  }
  return null;
}

// Every block with status "A" (assumed), as dotted paths.
function assumedPaths(obj, prefix = "") {
  const out = [];
  for (const [k, v] of Object.entries(obj || {})) {
    if (!v || typeof v !== "object" || Array.isArray(v)) continue;
    const path = prefix ? `${prefix}.${k}` : k;
    if (v.status === "A") out.push(path);
    out.push(...assumedPaths(v, path));
  }
  return out;
}

// decl: { profile?: "lib/patch", patch?: "<plugin or patch name>", style?, instrument?, family?, overrides?, stamina? }
// Returns { name, style, family, instrument, cfg, warnings, assumed, source }.
export function resolveTrack(registry, name, decl = {}) {
  const warnings = [];
  const found = findPatch(registry, decl);
  if ((decl.profile || decl.patch) && !found) warnings.push(`${name}: profile ${decl.profile || decl.patch} not found; using generic defaults`);
  const libDefaults = found?.library.defaults || {};
  const patch = found?.patch || {};
  let style = decl.style || patch.style || libDefaults.style;
  if (!STYLES.includes(style)) {
    warnings.push(`${name}: ${style ? `unknown style ${style}` : "no style"}; using sampled-short (velocity only)`);
    style = "sampled-short";
  }
  const instrument = decl.instrument || patch.instrument || libDefaults.instrument || null;
  const player = (instrument && registry.players.instruments[instrument]) || null;
  if (instrument && !player) warnings.push(`${name}: instrument ${instrument} has no player data`);
  const family = decl.family || patch.family || libDefaults.family || player?.family || "other";
  const generic = registry.generic.styles[style] || {};
  const famBlock = registry.generic.families[family]?.[style] || {};
  const ensemble = decl.ensemble ?? patch.ensemble ?? libDefaults.ensemble ?? false;
  const stamina = decl.stamina ?? player?.stamina?.[ensemble ? "section" : "solo"] ?? null;
  const { required = [], ...genericCfg } = generic;
  const specific = merge(libDefaults, patch, decl.overrides || {});
  const cfg = merge(genericCfg, famBlock, { stamina, ensemble, family, instrument }, specific);
  delete cfg.match;
  for (const path of required) if (get(specific, path) === undefined && get(famBlock, path) === undefined) {
    warnings.push(`${name}: ${path} not in its profile; generic default ${JSON.stringify(get(genericCfg, path))}`);
  }
  return {
    name, style, family, instrument, cfg, warnings,
    assumed: assumedPaths(merge(libDefaults, patch)),
    source: found ? `${found.libraryId}/${found.patchId}` : "generic"
  };
}

// A short table of every patch and its assumed blocks (for `music profiles`).
export function listProfiles(registry) {
  const rows = [];
  for (const [lib, L] of Object.entries(registry.libraries)) for (const [id, P] of Object.entries(L.patches || {})) {
    rows.push({ id: `${lib}/${id}`, library: L.library, style: P.style || L.defaults?.style || "?", instrument: P.instrument || "", template: !!L.template, assumed: assumedPaths(merge(L.defaults, P)) });
  }
  return rows;
}
