// Parity adapter: La Forja's orch.mjs helpers from the engine's writers.
import { getPiece } from "./core.mjs";
const P = () => getPiece();
export const pad = (...a) => P().pad(...a);
export const bass = (...a) => P().bass(...a);
export const harpArp = (...a) => P().harpArp(...a);
export const roll = (...a) => P().roll(...a);
export const pedal = (...a) => P().pedal(...a);
export const timpHit = (...a) => P().timpHit(...a);
export const timpRoll = (...a) => P().timpRoll(...a);
export const timpVolumeReset = () => P().timpVolumeReset();
export const timpDamp = (...a) => P().timpDamp(...a);
export const cymHit = (...a) => P().cymHit(...a);
export const cymSwell = (...a) => P().cymSwell(...a);
export const dw = (...a) => P().ensembleHit(...a);

// La Forja's isolate(): rewrite a region with its own generator and burn from the shared one what the old
// notes consumed (only needed in the shared-RNG mode; the engine's per-track streams make it unnecessary).
function mulberry(seed) {
  let a = 0x9e3779b9;
  for (const ch of String(seed)) a = (Math.imul(a ^ ch.charCodeAt(0), 2654435761) + 1) >>> 0;
  return () => { a = (a + 0x6d2b79f5) >>> 0; let t = a; t = Math.imul(t ^ (t >>> 15), t | 1); t ^= t + Math.imul(t ^ (t >>> 7), t | 61); return ((t ^ (t >>> 14)) >>> 0) / 4294967296; };
}
export function isolate(t, oldBuild, newBuild, seed) {
  const T = P().tracks, tmp = "__isolate";
  oldBuild(tmp);
  const old = T[tmp] ? T[tmp].notes.length : 0;
  delete T[tmp];
  const before = new Set(P().score.track(t).notes);
  newBuild(t);
  const added = P().score.track(t).notes.filter((n) => !before.has(n));
  const r = mulberry(seed);
  for (const n of added) n.rng = (s) => (r() * 2 - 1) * s;
  const first = [...added].sort((a, b) => a.pos - b.pos || a.pitch - b.pitch)[0];
  if (first) first.burn = old;
}
