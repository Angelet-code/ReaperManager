// Parity adapter: La Forja's expr.mjs entry points on the engine's perform().
import { getPiece } from "./core.mjs";
import { BAL } from "./bal.mjs";
import { FORJA_TRACKS } from "./forja-tracks.mjs";

export const BREATHS = [];
export const SWAM_GAIN = {};
const KIND = { "sampled-legato": "albLegato", "sampled-long": "albLong", "sampled-short": "short", piano: "piano", percussion: "perc" };
export const PROFILE = new Proxy({}, {
  get(_, name) {
    if (!FORJA_TRACKS[name]) return undefined;
    const r = getPiece().resolve(name);
    return { kind: r.style === "modeled" ? (r.cfg.kind === "string" ? "swamStr" : "swam") : KIND[r.style] };
  },
  ownKeys: () => Object.keys(FORJA_TRACKS),
  getOwnPropertyDescriptor: () => ({ enumerable: true, configurable: true })
});
export const setSections = (s) => getPiece().setSections(s, { placed: true });
export function interpret() {
  const p = getPiece();
  p.spec.balance = BAL;
  p.perform();
  BREATHS.push(...p.breathLog);
}
