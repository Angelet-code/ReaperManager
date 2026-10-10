import fs from "node:fs";
import path from "node:path";
import { buildVocalLevelCommand } from "./commands.js";
import { runDeclip } from "./declip.js";

// Tools launched from the REAPER "Herramientas" toolbar menu. Each returns a short
// Spanish summary ({ title, lines }) that the Lua menu shows when the run ends.
export const TOOLS = {
  declip: {
    title: "Declip (selección de tiempo)",
    run: (request) => runDeclip({}, { request }).then(summarizeDeclip)
  },
  "declip-item": {
    title: "Declip (item completo)",
    run: (request) => runDeclip({ item: true }, { request }).then(summarizeDeclip)
  },
  "vocal-level": {
    title: "Nivelar voz",
    run: async (request) => summarizeVocalLevel(await request(buildVocalLevelCommand({ "selected-items": true })))
  }
};

const db = (value) => (Number.isFinite(Number(value)) ? `${Number(value).toFixed(1)} dB` : "-");

export function summarizeDeclip(report) {
  const lines = [];
  for (const channel of report.channels || []) {
    const prefix = (report.channels.length > 1) ? `Canal ${channel.channel + 1}: ` : "";
    lines.push(`${prefix}${channel.runs} picos recortados reconstruidos (${channel.edits} muestras).`);
    if (channel.runs > 0) lines.push(`${prefix}pico máximo +${db(channel.peak_db_over_clip)} sobre el clip, margen ${db(channel.headroom_db)}.`);
  }
  if (!lines.length) lines.push("No se encontraron picos recortados.");
  lines.push(report.applied ? "Aplicado como sample edits (un solo undo)." : "No se ha aplicado nada.");
  return { lines };
}

export function summarizeVocalLevel(response) {
  if (!response?.ok) throw new Error(response?.error || "vocal-level falló.");
  const data = response.data || {};
  const post = data.post_level_measurement || {};
  const lines = [];
  if (!Number(data.applied)) {
    const raw = data.skip_reasons || {};
    const reasons = (Array.isArray(raw) ? raw : Object.keys(raw)).join(", ");
    lines.push(`No se ha aplicado${reasons ? `: ${reasons}` : "."}`);
    if (/envelope/i.test(reasons)) lines.push("El take ya tiene envolvente de volumen; bórrala o usa el CLI con --replace-envelope.");
    return { lines };
  }
  lines.push(`${data.corrected_parts} de ${data.parts} frases corregidas, ${data.envelope_points_written} puntos de envolvente.`);
  lines.push(`Dispersión entre frases: ${db(post.before_spread_db)} -> ${db(post.after_spread_db)}.`);
  lines.push(`Desviación típica: ${db(post.before_stdev_db)} -> ${db(post.after_stdev_db)}.`);
  if (Number(post.max_after_peak_db) > 0) lines.push(`Atención: un pico llega a +${db(post.max_after_peak_db)} sobre 0 dBFS.`);
  return { lines };
}

// Runs a tool and always writes a report file (the Lua side polls for it).
export async function runToolToReport(name, reportPath, request) {
  const tool = TOOLS[name];
  let report;
  try {
    if (!tool) throw new Error(`Herramienta desconocida: ${name}`);
    report = { ok: true, title: tool.title, ...(await tool.run(request)) };
  } catch (error) {
    report = { ok: false, title: tool?.title || name, lines: [String(error.message || error)] };
  }
  if (reportPath) {
    fs.mkdirSync(path.dirname(reportPath), { recursive: true });
    const tmp = `${reportPath}.tmp`;
    fs.writeFileSync(tmp, JSON.stringify(report), "utf8");
    fs.renameSync(tmp, reportPath);
  }
  return report;
}
