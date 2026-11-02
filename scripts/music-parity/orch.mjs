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
