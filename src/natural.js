import {
  AmbiguousCommandError,
  CommandError,
  buildAdjustVolumeCommand,
  buildColorTracksCommand,
  buildCreateTracksCommand,
  buildCreateReturnsCommand,
  buildGainStageCommand,
  buildItemVolumeCommand,
  buildPanCommand,
  buildRockTemplateCommand,
  buildSendVolumeCommand,
  buildSelectTracksCommand,
  buildTrackStateCommand,
  buildVocalLevelCommand
} from "./commands.js";

const SPANISH_NUMBERS = new Map([
  ["un", 1],
  ["una", 1],
  ["uno", 1],
  ["dos", 2],
  ["tres", 3],
  ["cuatro", 4],
  ["cinco", 5],
  ["seis", 6],
  ["siete", 7],
  ["ocho", 8]
]);

export function parseNatural(text, context = {}) {
  const input = String(text || "").trim();
  const lower = input.toLowerCase();

  if (!input) throw new CommandError("Missing natural language command.");

  if (/(estructura|plantilla|template).*(rock|grupo)|rock.*(estructura|plantilla|template)/i.test(lower)) {
    return buildRockTemplateCommand({ clear: /(borra|borrar|limpia|desde cero|clear)/i.test(lower) });
  }

  if (/(etapa\s+de\s+ganancia|gain\s*stage|gainstage)/i.test(lower) || (/\bganancia\b/i.test(lower) && !/(db|d b|decibel)/i.test(lower) && /(items?|clips?|pistas?|tracks?|proyecto)/i.test(lower))) {
    return buildGainStageCommand({
      ...extractGainStageTarget(input),
      preview: /(preview|previsual|solo\s+calcula|sin\s+aplicar)/i.test(lower)
    });
  }

  if (/(nivela|nivelar|level|vocal\s*level|vocal\s*ride)/i.test(lower) && /(voz|voces|vocal|vox|items?|clips?|seleccionad[ao]s?)/i.test(lower)) {
    return buildVocalLevelCommand({
      selectedItems: true,
      preview: /(preview|previsual|solo\s+calcula|sin\s+aplicar)/i.test(lower)
    });
  }

  if (/\b(crea|crear|genera|generar|a[nÃ±]ade|agrega|inserta|nuevo|nueva)\b/i.test(lower) && /\b(pistas?|tracks?)\b/i.test(lower) && !/(envios?|sends?|retornos?|returns?|reverb|carpeta|folder|bus|proyecto)/i.test(lower)) {
    return buildCreateTracksCommand({
      count: extractCount(input) || 1,
      name: extractCreateTrackName(input) || "Track"
    });
  }

  if (isTrackDbCommand(lower)) {
    return buildAdjustVolumeCommand({
      ...extractTrackTarget(input),
      db: extractDb(input)
    });
  }

  if (/(envios?|sends?)/i.test(lower) && /(db|d b|decibel)/i.test(lower)) {
    return buildSendVolumeCommand({
      ...extractTrackTarget(input),
      db: extractDb(input),
      dest: extractAfter(input, /\b(?:a|hacia|to)\s+([A-Za-z0-9 ._-]+)/i)
    });
  }

  if (/(items?|clips?)/i.test(lower) && /(db|d b|decibel)/i.test(lower)) {
    return buildItemVolumeCommand({
      selected: /seleccionad[ao]s?|selected/i.test(lower),
      all: /todos?|all/i.test(lower),
      contains: extractContains(input),
      db: extractDb(input)
    });
  }

  if (/(pan|panea|paneo|panorama)/i.test(lower)) {
    return buildPanCommand({
      ...extractTrackTarget(input),
      pan: extractPan(input)
    });
  }

  if (/(mutea|muta|silencia|solo)/i.test(lower)) {
    return buildTrackStateCommand({
      ...extractTrackTarget(input),
      mute: /(mutea|muta|silencia)/i.test(lower) ? "on" : undefined,
      solo: /\bsolo\b/i.test(lower) ? "on" : undefined
    });
  }

  if (/\b(?:selecciona|seleccionar|seleccione|select|deselecciona|desmarca|quita\s+de\s+la\s+selecci[oó]n)\b/i.test(lower) && /(pistas?|tracks?)/i.test(lower)) {
    return buildSelectTracksCommand({
      ...extractSelectionTarget(input),
      mode: extractSelectionMode(lower)
    });
  }

  if (/(colou?r|colore|pinta|pon).*(pistas?|tracks?)/i.test(lower)) {
    const contains = extractContains(input);
    const color = extractColor(input);
    const target = contains ? {} : extractTrackTarget(input);
    if (!contains && !target.all && !target.selected) throw new AmbiguousCommandError("I could not tell which tracks to color.");
    if (!color) throw new AmbiguousCommandError("I could not tell which color to apply.");
    return buildColorTracksCommand({ ...target, contains, color });
  }

  if (/(envios?|sends?|retornos?|returns?|reverb)/i.test(lower)) {
    const count = extractCount(input) || 1;
    const fx = /rverb/i.test(input) ? "RVerb" : extractAfter(input, /\bcon\s+(?:una?\s+)?([A-Za-z0-9 ._-]+)/i);
    const from = extractSource(lower) || context.prefs?.defaultSendSource;
    return buildCreateReturnsCommand({
      count,
      fx: fx || "RVerb",
      from,
      prefs: context.prefs,
      aliases: context.aliases,
      pluginEntries: context.pluginEntries
    });
  }

  throw new CommandError("I do not know how to translate that request yet.");
}

function extractContains(input) {
  const patterns = [
    /palabra\s+["']?([^"'\s]+)["']?/i,
    /contengan?\s+(?:la\s+palabra\s+)?["']?([^"'\s]+)["']?/i,
    /containing\s+["']?([^"'\s]+)["']?/i
  ];

  for (const pattern of patterns) {
    const match = input.match(pattern);
    if (match) return match[1].trim();
  }
  return null;
}

function extractTrackTarget(input) {
  const lower = input.toLowerCase();
  const contains = extractContains(input);
  if (/seleccionad[ao]s?|selected/.test(lower)) return { selected: true };
  if (/todas?\s+las\s+pistas|ambas\s+pistas|las\s+dos\s+pistas|todos?\s+los\s+tracks|all/.test(lower)) return { all: true };
  if (contains) return { contains };
  const family = extractInstrumentFamily(input);
  if (family) return { contains: family };
  return { selected: true };
}

function extractSelectionTarget(input) {
  const contains = extractContains(input);
  if (contains) return { contains };
  const named = extractSelectionName(input);
  if (named) return { contains: named };
  return extractTrackTarget(input);
}

function extractSelectionName(input) {
  const patterns = [
    /pistas?\s+(?:de|del|con|llamad[ao]s?)\s+["']?([A-Za-z0-9À-ÿ ._-]+?)["']?\s*$/i,
    /tracks?\s+(?:named|called|containing)\s+["']?([A-Za-z0-9À-ÿ ._-]+?)["']?\s*$/i
  ];

  for (const pattern of patterns) {
    const match = input.match(pattern);
    if (match) return match[1].trim();
  }
  return null;
}

function extractGainStageTarget(input) {
  const lower = input.toLowerCase();
  if (/(todo\s+el\s+proyecto|proyecto\s+completo|all\s+(?:items?|project)|todos?\s+los\s+items?)/i.test(lower)) {
    return { allItems: true };
  }
  if (/(items?|clips?).*(seleccionad[ao]s?|selected)|(seleccionad[ao]s?|selected).*(items?|clips?)/i.test(lower)) {
    return { selectedItems: true };
  }
  if (/(pistas?|tracks?).*(seleccionad[ao]s?|selected)|(seleccionad[ao]s?|selected).*(pistas?|tracks?)/i.test(lower)) {
    return { selectedTracks: true };
  }

  const contains = extractContains(input);
  if (contains) return { contains };
  const named = extractSelectionName(input);
  if (named) return { contains: named };
  return { selectedItems: true };
}

function extractSelectionMode(lower) {
  if (/(deselecciona|desmarca|quita\s+de\s+la\s+selecci[oó]n|remove)/i.test(lower)) return "remove";
  if (/(alterna|toggle)/i.test(lower)) return "toggle";
  if (/(a[nñ]ade|agrega|suma|mant[eé]n|sin\s+deseleccionar|add)/i.test(lower)) return "add";
  return "replace";
}

function extractDb(input) {
  const match = input.match(/([+-]?\d+(?:[.,]\d+)?)\s*(?:db|d b|decibel)/i);
  if (!match) throw new AmbiguousCommandError("I could not tell the dB amount.");
  const amount = Number(match[1].replace(",", "."));
  const lower = input.toLowerCase();
  if (/(baja|bajar|reduce|quita|menos)/.test(lower) && amount > 0) return -amount;
  if (/(sube|subir|aumenta|mas|más)/.test(lower) && amount < 0) return Math.abs(amount);
  return amount;
}

function extractPan(input) {
  const center = input.match(/\b(centro|center|c)\b/i);
  if (center) return "center";
  const lr = input.match(/\b([lr])\s*(\d+(?:[.,]\d+)?)\b/i) || input.match(/\b(izquierda|left|derecha|right)\s*(\d+(?:[.,]\d+)?)?\b/i);
  if (!lr) throw new AmbiguousCommandError("I could not tell the pan value.");
  const side = lr[1].toLowerCase();
  const amount = (lr[2] || "100").replace(",", ".");
  if (side === "l" || side === "left" || side === "izquierda") return `L${amount}`;
  return `R${amount}`;
}

function extractColor(input) {
  const match = input.match(/\b(rojo|red|verde|green|azul|blue|amarillo|yellow|naranja|orange|morado|purple|rosa|pink|gris|gray|grey|blanco|white|negro|black|#[0-9a-f]{6})\b/i);
  return match?.[1] || null;
}

function extractCount(input) {
  const digit = input.match(/\b(\d+)\b/);
  if (digit) return Number(digit[1]);

  const words = input.toLowerCase().split(/\s+/);
  for (const word of words) {
    if (SPANISH_NUMBERS.has(word)) return SPANISH_NUMBERS.get(word);
  }
  return null;
}

function extractSource(lower) {
  if (/seleccionad[ao]s?|selected/.test(lower)) return "selected";
  if (/solo\s+(retornos?|aux|buses)|sin\s+envios?/.test(lower)) return "none";
  if (/todas?\s+las\s+pistas|all\s+audio/.test(lower)) return "all-audio";
  return null;
}

function extractAfter(input, pattern) {
  const match = input.match(pattern);
  return match?.[1]?.trim() || null;
}

function extractCreateTrackName(input) {
  const explicit = extractAfter(input, /\b(?:llamad[ao]s?|nombre|name)\s+["']?([A-Za-z0-9À-ÿ ._-]+?)["']?\s*$/i);
  if (explicit) return explicit;

  const lower = input.toLowerCase();
  if (/\bguitarras?\b/i.test(lower)) return "GTR";
  if (/\b(voces|voz|vocales|vox)\b/i.test(lower)) return "VOX";
  if (/\b(bajos?|bass)\b/i.test(lower)) return "BASS";
  if (/\b(bateria|batería|drums?)\b/i.test(lower)) return "DRUM";
  if (/\b(pianos?)\b/i.test(lower)) return "PIANO";
  if (/\b(teclas?|keys?|sintes?|synths?)\b/i.test(lower)) return "SYNTH";
  return null;
}

function isTrackDbCommand(lower) {
  if (!/(db|d b|decibel)/i.test(lower)) return false;
  if (/(envios?|sends?|items?|clips?)/i.test(lower)) return false;
  if (/(volumen|fader|ganancia)/i.test(lower)) return true;
  return /\b(baja|bajar|sube|subir|reduce|aumenta|quita|pon|ajusta|levanta)\b/i.test(lower);
}

function extractInstrumentFamily(input) {
  const lower = input.toLowerCase();
  const families = [
    { pattern: /\b(guitarras?|gtrs?|elec\s*gtr|acusticas?|ac[uú]sticas?)\b/i, contains: "GTR" },
    { pattern: /\b(voces|voz|vocales|vox|coros?|backings?|bv)\b/i, contains: "VOX" },
    { pattern: /\b(bajos?|bass|sub)\b/i, contains: "BASS" },
    { pattern: /\b(bateria|bater[ií]a|drums?|kick|snare|caja|bombo)\b/i, contains: "DRUM" },
    { pattern: /\b(teclas?|keys?|sintes?|synths?|sintetizadores?)\b/i, contains: "SYNTH" },
    { pattern: /\b(pianos?)\b/i, contains: "PIANO" },
    { pattern: /\b(flautas?)\b/i, contains: "FLAUTA" }
  ];

  for (const family of families) {
    if (family.pattern.test(lower)) return family.contains;
  }
  return null;
}
