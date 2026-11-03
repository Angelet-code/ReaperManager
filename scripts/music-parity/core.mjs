// Parity adapter: La Forja's core.mjs API on top of the music engine (shared-RNG mode).
import { createPiece, clamp as engineClamp, interp as engineInterp } from "__ENGINE__";
import * as P from "__ENGINE__";
import { FORJA_TRACKS, FORJA_BREATH_GROUPS } from "./forja-tracks.mjs";

export const MAP = { changes: [], measures: [], total: 0 };
export const T = {};
let piece = null;
export const getPiece = () => piece;
export function setForm(changes, totalBars) {
  piece = createPiece({
    title: "LA FORJA DEL ALBA", seed: 20261102, rng: "shared", tempo: changes, lastBar: totalBars - 2, store: T,
    tracks: FORJA_TRACKS, breathGroups: FORJA_BREATH_GROUPS, options: globalThis.__FORJA_OPTIONS || {}
  });
  Object.assign(MAP, { changes, measures: piece.timeline.measures, total: totalBars });
}
const P_ = () => piece;
export const rnd = () => P_().write.rnd();
export const rr = (s) => P_().write.rr(s);
export const clamp = engineClamp;
export const pos = (b, beat) => P_().timeline.pos(b, beat);
export const barLen = (b) => P_().timeline.barLen(b);
export const measureAt = (p) => P_().timeline.measureAt(p);
export const bpmAt = (p) => P_().timeline.bpmAt(p);
export const secOf = (p) => P_().timeline.secOf(p);
export const ms2qn = (ms, p) => P_().timeline.ms2qn(ms, p);
export const tr = (n) => P_().score.track(n);
export const N = (...a) => P_().note(...a);
export const Np = (...a) => P_().noteAt(...a);
export const C = (...a) => P_().chord(...a);
export const cc = (...a) => P_().cc(...a);
export const pb = (...a) => P_().pb(...a);
export const line = (...a) => P_().line(...a);
export const dyn = (...a) => P_().dyn(...a);
export const ramp = (...a) => P_().ramp(...a);
export const harm = (...a) => P_().harm(...a);
export const progression = (...a) => P_().progression(...a);
export const interp = engineInterp;
export const { M, mel, specLen, transpose, dshift, augment, pcOf, parseChord, chordPitches, bassNote, voice, SCALE } = P;
