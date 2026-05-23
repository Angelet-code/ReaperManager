import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import { enqueueCommand, readStatus, waitForResponse } from "./client.js";
import { normalizeCommand } from "./commands.js";
import { CommandError } from "./core/errors.js";
import { readJson, writeJsonAtomic } from "./fs-utils.js";
import {
  chatHistoryPath,
  chatResponseDir,
  chatStatePath,
  ensureManagerDirs,
  workspaceRoot
} from "./paths.js";
import { loadPluginEntries } from "./plugin-cache.js";
import { loadPreferences } from "./preferences.js";
import { parseNatural } from "./natural.js";

const DEFAULT_MODEL = "gpt-5.5";
const DEFAULT_REASONING_EFFORT = "low";
const HEARTBEAT_MAX_AGE_MS = 10000;
const CHAT_HISTORY_LIMIT = 100;
const NOT_UNDERSTOOD_MESSAGE = "No entiendo lo que quieres.";

const CHAT_ALLOWED_COMMANDS = new Set([
  "color_tracks",
  "select_tracks",
  "select_items",
  "adjust_track_volume_db",
  "set_track_pan",
  "adjust_send_volume_db",
  "adjust_item_volume_db",
  "gain_stage_items",
  "set_track_state",
  "rename_tracks",
  "create_tracks",
  "create_folder_for_tracks",
  "route_tracks_to_bus",
  "set_fx_bypass",
  "create_fx_returns",
  "add_fx_to_tracks",
  "remove_fx_from_tracks",
  "delete_tracks",
  "create_rock_template",
  "auto_balance_mix"
]);

export async function runChatText(text, options = {}) {
  const root = options.root || workspaceRoot();
  ensureManagerDirs(root);

  const requestText = String(text || "").trim();
  const id = options.id || `chat-${Date.now()}-${crypto.randomBytes(4).toString("hex")}`;
  const startedAt = new Date().toISOString();

  if (!requestText) {
    return finishChatResponse(root, {
      id,
      ok: false,
      kind: "error",
      message: "Escribe una orden para Reaper Manager.",
      actions: [],
      startedAt
    });
  }

  appendChatHistory(root, [{ role: "user", text: requestText, time: startedAt }]);

  const context = commonContext(root);
  let plan = planLocalChatAction(requestText, context);
  const status = options.status || readStatus(root);
  if (!isBridgeReady(status.heartbeat, options.now)) {
    return finishChatResponse(root, {
      id,
      ok: false,
      kind: "needs_bridge",
      message: "Pulsa el botón Reaper Manager en REAPER para arrancar el puente.",
      actions: [],
      startedAt
    });
  }

  try {
    if (plan.kind !== "execute") {
      plan = await planChatWithAiFallback(requestText, {
        ...options,
        root,
        context,
        status,
        env: options.env || process.env
      });
    }

    if (plan.kind !== "execute") {
      return finishChatResponse(root, {
        id,
        ok: false,
        kind: "not_understood",
        message: NOT_UNDERSTOOD_MESSAGE,
        actions: [],
        startedAt
      });
    }

    const actions = await executeChatCommands(plan.commands, {
      root,
      timeoutMs: Number(options.timeout || options.timeoutMs || 60000),
      commandRunner: options.commandRunner
    });
    const ok = actions.every((action) => action.ok);
    return finishChatResponse(root, {
      id,
      ok,
      kind: ok ? "executed" : "error",
      message: ok ? summarizeActions(actions) : summarizeFailure(actions),
      planMessage: plan.message,
      actions,
      startedAt
    });
  } catch (error) {
    return finishChatResponse(root, {
      id,
      ok: false,
      kind: "error",
      message: `No pude completar la orden: ${error.message || String(error)}`,
      actions: [],
      startedAt
    });
  }
}

async function planChatWithAiFallback(text, options = {}) {
  const env = options.env || process.env;
  if (!options.openaiClient && !env.OPENAI_API_KEY) {
    return {
      kind: "not_understood",
      message: NOT_UNDERSTOOD_MESSAGE,
      commands: []
    };
  }

  try {
    const inspection = options.inspection || await inspectProject(options.root, options);
    const plan = await planChatActions(text, {
      ...options,
      inspection,
      context: options.context || {}
    });
    if (plan.kind !== "execute") {
      return {
        kind: "not_understood",
        message: NOT_UNDERSTOOD_MESSAGE,
        commands: []
      };
    }
    return plan;
  } catch {
    return {
      kind: "not_understood",
      message: NOT_UNDERSTOOD_MESSAGE,
      commands: []
    };
  }
}

export function planLocalChatAction(text, context = {}) {
  try {
    const command = parseNatural(text, context);
    if (isDestructiveCommand(command) && !hasExplicitDestructiveIntent(text, command)) {
      return {
        kind: "not_understood",
        message: NOT_UNDERSTOOD_MESSAGE,
        commands: []
      };
    }
    return {
      kind: "execute",
      message: "Aplicando la orden.",
      commands: [normalizeCommand(command, context)]
    };
  } catch {
    return {
      kind: "not_understood",
      message: NOT_UNDERSTOOD_MESSAGE,
      commands: []
    };
  }
}

export async function processChatRequestFile(requestFile, options = {}) {
  const root = options.root || inferRootFromChatRequest(requestFile) || workspaceRoot();
  const request = readJson(requestFile, null);
  const id = request?.id || path.basename(requestFile, path.extname(requestFile));
  const response = await runChatText(request?.text, { ...options, root, id });
  writeChatResponse(root, id, response);
  return response;
}

export function inferRootFromChatRequest(requestFile) {
  const resolved = path.resolve(requestFile);
  const requestDir = path.dirname(resolved);
  const chatDir = path.dirname(requestDir);
  const managerDir = path.dirname(chatDir);
  if (path.basename(requestDir).toLowerCase() !== "requests") return null;
  if (path.basename(chatDir).toLowerCase() !== "chat") return null;
  if (path.basename(managerDir).toLowerCase() !== ".reaper-manager") return null;
  return path.dirname(managerDir);
}

export async function planChatActions(text, options = {}) {
  const client = options.openaiClient || await createOpenAIClient(options.env || process.env);
  const response = await client.responses.create({
    model: options.model || DEFAULT_MODEL,
    reasoning: { effort: options.reasoningEffort || DEFAULT_REASONING_EFFORT },
    input: [
      {
        role: "system",
        content: buildSystemPrompt()
      },
      {
        role: "user",
        content: JSON.stringify({
          request: text,
          project: summarizeInspection(options.inspection),
          availableCommands: [...CHAT_ALLOWED_COMMANDS]
        })
      }
    ],
    text: { format: { type: "json_object" } }
  });

  const rawText = extractResponseText(response);
  const parsed = parsePlannerJson(rawText);
  return normalizeChatPlan(parsed, text, options.context || {});
}

export function normalizeChatPlan(parsed, originalText, context = {}) {
  const kind = normalizeKind(parsed.status || parsed.kind);
  const message = cleanMessage(parsed.message || parsed.reply);
  const rawCommands = parsed.commands || parsed.actions || [];

  if (kind === "clarify" || kind === "refuse") {
    return {
      kind,
      message: message || (kind === "clarify" ? "Necesito una aclaración antes de tocar REAPER." : "No puedo ejecutar esa orden."),
      commands: []
    };
  }

  if (!Array.isArray(rawCommands) || rawCommands.length === 0) {
    return {
      kind: "clarify",
      message: message || "No he podido convertir esa orden en una acción clara.",
      commands: []
    };
  }

  const commands = [];
  for (const raw of rawCommands) {
    const command = raw.command || raw;
    if (!CHAT_ALLOWED_COMMANDS.has(command.type)) {
      return {
        kind: "clarify",
        message: `No tengo habilitado el comando "${command.type}" desde el chat.`,
        commands: []
      };
    }

    if (isDestructiveCommand(command) && !hasExplicitDestructiveIntent(originalText, command)) {
      return {
        kind: "clarify",
        message: "Eso puede borrar pistas, FX o una estructura existente. Dímelo explícitamente con borrar, eliminar o quitar para aplicarlo.",
        commands: []
      };
    }

    try {
      commands.push(normalizeCommand(command, context));
    } catch (error) {
      const detail = error instanceof CommandError ? error.message : String(error.message || error);
      return {
        kind: "clarify",
        message: `No pude validar la acción propuesta: ${detail}`,
        commands: []
      };
    }
  }

  return {
    kind: "execute",
    message: message || "Aplicando la orden.",
    commands
  };
}

export async function executeChatCommands(commands, options = {}) {
  const out = [];
  for (const command of commands) {
    const result = options.commandRunner
      ? await options.commandRunner(command)
      : await runSingleCommand(command, options);
    out.push({
      type: command.type,
      command,
      ...result
    });
    if (!result.ok) break;
  }
  return out;
}

export function isBridgeReady(heartbeat, now = new Date()) {
  if (!heartbeat || heartbeat.bridge !== "running" || heartbeat.ok === false) return false;
  const time = Date.parse(heartbeat.time);
  if (!Number.isFinite(time)) return false;
  return Number(now) - time <= HEARTBEAT_MAX_AGE_MS;
}

function commonContext(root) {
  const prefs = loadPreferences(root);
  return {
    prefs,
    aliases: prefs.aliases,
    pluginEntries: loadPluginEntries(root)
  };
}

async function inspectProject(root, options = {}) {
  const response = await runSingleCommand({ type: "inspect_project" }, {
    root,
    timeoutMs: Number(options.inspectTimeout || options["inspect-timeout"] || 30000)
  });
  if (!response.ok) throw new Error(response.error || "inspect-project failed.");
  return response.data;
}

async function runSingleCommand(command, options = {}) {
  const id = enqueueCommand(command, { root: options.root });
  const response = await waitForResponse(id, {
    root: options.root,
    timeoutMs: options.timeoutMs || 60000
  });
  return response;
}

async function createOpenAIClient(env) {
  const { default: OpenAI } = await import("openai");
  return new OpenAI({ apiKey: env.OPENAI_API_KEY });
}

function buildSystemPrompt() {
  return [
    "Eres Reaper Manager Chat, un asistente de mezcla dentro de REAPER para un ingeniero de sonido.",
    "Devuelve solo JSON valido con status, message y commands.",
    "status debe ser execute, clarify o refuse.",
    "commands debe ser un array de comandos estructurados de Reaper Manager; nunca inventes comandos fuera de la lista.",
    "Usa filtros {type:'selected'}, {type:'all'}, {type:'all_audio'} o {type:'name_contains', value:'texto', caseSensitive:false}.",
    "Si la pista destino no esta clara, usa status clarify en vez de adivinar.",
    "No propongas delete_tracks, remove_fx_from_tracks ni create_rock_template destructivo salvo que el usuario lo pida explicitamente.",
    "Responde en espanol, corto y operacional."
  ].join("\n");
}

function summarizeInspection(inspection) {
  if (!inspection) return null;
  return {
    project_path: inspection.project_path,
    track_count: inspection.track_count,
    selected_track_count: inspection.selected_track_count,
    reference: inspection.reference ? { index: inspection.reference.index, name: inspection.reference.name } : null,
    tracks: (inspection.tracks || []).slice(0, 160).map((track) => ({
      index: track.index,
      name: track.name,
      role: track.role,
      selected: Boolean(track.selected),
      item_count: track.item_count,
      fx_count: track.fx_count,
      sends: track.send_count,
      receives: track.receive_count,
      muted: Boolean(track.muted),
      solo: Boolean(track.solo)
    })),
    sections: inspection.sections
  };
}

function parsePlannerJson(rawText) {
  try {
    return JSON.parse(rawText);
  } catch {
    throw new Error("La respuesta del modelo no fue JSON valido.");
  }
}

function extractResponseText(response) {
  if (typeof response?.output_text === "string") return response.output_text;

  const chunks = [];
  for (const item of response?.output || []) {
    for (const content of item.content || []) {
      if (typeof content.text === "string") chunks.push(content.text);
    }
  }

  const text = chunks.join("").trim();
  if (!text) throw new Error("El modelo no devolvio texto.");
  return text;
}

function normalizeKind(value) {
  const text = String(value || "execute").toLowerCase();
  if (["execute", "clarify", "refuse"].includes(text)) return text;
  return "clarify";
}

function cleanMessage(value) {
  return String(value || "").trim();
}

function isDestructiveCommand(command) {
  if (command.type === "delete_tracks" || command.type === "remove_fx_from_tracks") return true;
  return command.type === "create_rock_template" && command.clearExisting !== false;
}

function hasExplicitDestructiveIntent(text, command) {
  const lower = String(text || "").toLowerCase();
  if (command.type === "delete_tracks") {
    return /\b(borra|borrar|elimina|eliminar|suprime|delete|deletes|remove tracks|borralas|b[oó]rralas)\b/i.test(lower);
  }
  if (command.type === "remove_fx_from_tracks") {
    return /(quita|quitar|elimina|eliminar|borra|borrar|remove|delete).*(fx|efectos?|plugins?|insertos?)|(fx|efectos?|plugins?|insertos?).*(quita|quitar|elimina|eliminar|borra|borrar|remove|delete)/i.test(lower);
  }
  if (command.type === "create_rock_template") {
    return /\b(borra|borrar|limpia|limpiar|desde cero|clear|delete|elimina|eliminar)\b/i.test(lower);
  }
  return false;
}

function summarizeActions(actions) {
  const summaries = actions.map((action) => summarizeAction(action.type, action.data)).filter(Boolean);
  const undo = actions.length > 1 ? "Ctrl+Z revierte cada paso por separado." : "Ctrl+Z revierte la acción.";
  return `Hecho. ${summaries.join(" ")} ${undo}`;
}

function summarizeFailure(actions) {
  const failed = actions.find((action) => !action.ok);
  if (!failed) return "No pude completar la orden.";
  return `Se paró en ${failed.type}: ${failed.error || "REAPER devolvió un error"}.`;
}

function summarizeAction(type, data = {}) {
  if (type === "color_tracks") return `${count(data.changed)} pistas coloreadas.`;
  if (type === "select_tracks") return `${count(data.changed)} cambios de selección; ${count(data.selected)} pistas seleccionadas.`;
  if (type === "select_items") return `${count(data.changed)} cambios de selección; ${count(data.selected)} items seleccionados.`;
  if (type === "adjust_track_volume_db") return `${count(data.changed)} faders ajustados.`;
  if (type === "set_track_pan") return `${count(data.changed)} panoramas ajustados.`;
  if (type === "adjust_send_volume_db") return `${count(data.changed)} envíos ajustados.`;
  if (type === "adjust_item_volume_db") return `${count(data.changed)} items ajustados.`;
  if (type === "gain_stage_items") return `${count(data.applied ?? data.changed)} items procesados.`;
  if (type === "set_track_state") return `${count(data.changed)} pistas actualizadas.`;
  if (type === "rename_tracks") return `${count(data.changed)} pistas renombradas.`;
  if (type === "create_tracks") return `${count(data.created?.length ?? data.created)} pistas creadas.`;
  if (type === "create_folder_for_tracks") return `Carpeta "${data.folder || data.name || "creada"}" creada.`;
  if (type === "route_tracks_to_bus") return `${count(data.sends?.length)} rutas enviadas a ${data.bus || "bus"}.`;
  if (type === "set_fx_bypass") return `${count(data.changed)} FX actualizados.`;
  if (type === "create_fx_returns") return `${count(data.returns?.length)} retornos y ${count(data.sends?.length)} envíos creados.`;
  if (type === "add_fx_to_tracks") return `${count(data.changed)} FX añadidos.`;
  if (type === "remove_fx_from_tracks") return `${count(data.removed)} FX quitados.`;
  if (type === "delete_tracks") return `${count(data.deleted)} pistas borradas.`;
  if (type === "create_rock_template") return `${count(data.created_track_count)} pistas en la plantilla; ${count(data.cleared)} borradas antes.`;
  if (type === "auto_balance_mix") return `${count(data.applied)} pistas auto-balanceadas.`;
  return `${type} aplicado.`;
}

function count(value) {
  const number = Number(value);
  return Number.isFinite(number) ? number : 0;
}

function finishChatResponse(root, response) {
  const finished = {
    ...response,
    time: new Date().toISOString()
  };
  appendChatHistory(root, [{ role: "assistant", text: finished.message, ok: finished.ok, kind: finished.kind, time: finished.time }]);
  writeJsonAtomic(chatStatePath(root), {
    lastResponse: finished,
    updatedAt: finished.time
  });
  return finished;
}

function writeChatResponse(root, id, response) {
  writeJsonAtomic(path.join(chatResponseDir(root), `${id}.json`), response);
}

function appendChatHistory(root, entries) {
  const file = chatHistoryPath(root);
  const history = readJson(file, []);
  const next = Array.isArray(history) ? history.concat(entries) : entries;
  writeJsonAtomic(file, next.slice(-CHAT_HISTORY_LIMIT));
}
