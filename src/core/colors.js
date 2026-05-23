import { COLOR_MAP } from "../constants.js";
import { CommandError } from "./errors.js";

export function parseColor(value) {
  if (Array.isArray(value) && value.length === 3) {
    return rgbObject(value);
  }

  const text = String(value || "").trim().toLowerCase();
  if (COLOR_MAP[text]) {
    return rgbObject(COLOR_MAP[text]);
  }

  const hex = text.match(/^#?([0-9a-f]{6})$/i);
  if (hex) {
    const packed = hex[1];
    return rgbObject([
      parseInt(packed.slice(0, 2), 16),
      parseInt(packed.slice(2, 4), 16),
      parseInt(packed.slice(4, 6), 16)
    ]);
  }

  const csv = text.match(/^(\d{1,3}),(\d{1,3}),(\d{1,3})$/);
  if (csv) {
    return rgbObject(csv.slice(1).map(Number));
  }

  throw new CommandError(`Unknown color "${value}". Use a name, #RRGGBB or r,g,b.`);
}

function rgbObject(values) {
  const [r, g, b] = values.map(Number);
  for (const channel of [r, g, b]) {
    if (!Number.isInteger(channel) || channel < 0 || channel > 255) {
      throw new CommandError(`Invalid RGB color: ${values.join(",")}`);
    }
  }
  return { r, g, b };
}
