import { CommandError } from "./errors.js";

export function parsePan(value) {
  const text = String(value ?? "").trim().toLowerCase();
  if (!text) throw new CommandError("Missing pan value.");
  if (["c", "center", "centro"].includes(text)) return 0;

  const lr = text.match(/^([lr])\s*(\d+(?:\.\d+)?)$/i) || text.match(/^(\d+(?:\.\d+)?)\s*([lr])$/i);
  if (lr) {
    const side = Number.isNaN(Number(lr[1])) ? lr[1].toLowerCase() : lr[2].toLowerCase();
    const amount = Number(Number.isNaN(Number(lr[1])) ? lr[2] : lr[1]);
    if (amount < 0 || amount > 100) throw new CommandError("Pan L/R amount must be between 0 and 100.");
    return side === "l" ? -amount / 100 : amount / 100;
  }

  const numeric = Number(text);
  if (!Number.isFinite(numeric)) throw new CommandError(`Invalid pan value "${value}".`);
  if (numeric >= -1 && numeric <= 1) return numeric;
  if (numeric >= -100 && numeric <= 100) return numeric / 100;
  throw new CommandError("Pan must be -100..100, -1..1, L50, R50, or center.");
}
