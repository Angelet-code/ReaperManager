// Deterministic random streams. A piece gets one stream per (track, layer) so that changing one layer
// (breaths, the SWAM breath layer, a new note) never moves the humanization of another track or layer.
// mode "shared" reproduces La Forja's generator: one Park–Miller stream for everything, consumed in
// call order (only for the parity check against that piece).

// Park–Miller minimal standard (La Forja's core.mjs).
export function parkMiller(seed) {
  let s = seed % 2147483647;
  if (s <= 0) s += 2147483646;
  return () => (s = (s * 16807) % 2147483647) / 2147483647;
}

// String → 32-bit seed (FNV-1a style mixing, as La Forja's soplo.mjs).
export function hashSeed(...parts) {
  let a = 0;
  for (const ch of parts.join("\u0001")) a = (Math.imul(a ^ ch.charCodeAt(0), 2654435761) + 1) >>> 0;
  return a;
}

// mulberry32; a string seed is mixed exactly as La Forja's soplo.mjs rng() does.
export function mulberry(seed) {
  let a = typeof seed === "number" ? seed >>> 0 : hashSeed(seed);
  return () => {
    a = (a + 0x6d2b79f5) >>> 0;
    let t = a;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

// Helpers over a uniform generator: rr(s) = uniform ±s, tri(s) = triangular ±s, range([a, b]).
export function withHelpers(rnd) {
  return {
    rnd,
    rr: (s) => (rnd() * 2 - 1) * s,
    tri: (s) => ((rnd() * 2 - 1) * s + (rnd() * 2 - 1) * s) / 2,
    range: ([a, b]) => a + (b - a) * rnd(),
    pick: (arr) => arr[Math.floor(rnd() * arr.length)]
  };
}

export function createRandom({ seed = 1, mode = "streams" } = {}) {
  const shared = mode === "shared" ? withHelpers(parkMiller(seed)) : null;
  const cache = new Map();
  return {
    mode,
    seed,
    // stream(track, layer): independent per (track, layer) in "streams" mode.
    stream(track = "", layer = "") {
      if (shared) return shared;
      const key = `${track}\u0000${layer}`;
      if (!cache.has(key)) cache.set(key, withHelpers(mulberry(hashSeed(String(seed), track, layer))));
      return cache.get(key);
    },
    // A fresh stream keyed by an arbitrary string (used by layers that seed per phrase or per group).
    keyed(key) {
      return withHelpers(mulberry(shared ? key : `${seed}:${key}`));
    }
  };
}
