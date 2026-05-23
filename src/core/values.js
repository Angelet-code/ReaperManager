import { CommandError } from "./errors.js";

export function parseDb(value, label = "dB adjustment") {
  const dbValue = Number(value);
  if (!Number.isFinite(dbValue) || Math.abs(dbValue) > 60) {
    throw new CommandError(`${label} must be a number between -60 and 60.`);
  }
  return dbValue;
}

export function parseSwitch(value, name) {
  const text = String(value ?? "").trim().toLowerCase();
  if (["on", "true", "1", "yes", "si"].includes(text)) return "on";
  if (["off", "false", "0", "no"].includes(text)) return "off";
  if (["toggle", "alternar"].includes(text)) return "toggle";
  throw new CommandError(`${name} must be on, off, or toggle.`);
}
