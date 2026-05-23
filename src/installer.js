import fs from "node:fs";
import path from "node:path";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import {
  ACTION_ID,
  ACTION_KB_ID,
  APP_NAME,
  BRIDGE_FILE,
  CHAT_ACTION_ID,
  CHAT_ACTION_KB_ID,
  CHAT_FILE,
  CONFIG_FILE,
  DETECT_ARRANGEMENT_ACTION_ID,
  DETECT_ARRANGEMENT_ACTION_KB_ID,
  DETECT_ARRANGEMENT_FILE,
  GAIN_STAGE_ACTION_ID,
  GAIN_STAGE_ACTION_KB_ID,
  GAIN_STAGE_FILE,
  JSON_FILE,
  SELECT_ALL_ITEMS_ACTION_ID,
  SELECT_ALL_ITEMS_ACTION_KB_ID,
  SELECT_ALL_ITEMS_FILE
} from "./constants.js";
import { backupFile, copyFileAtomic, writeJsonAtomic } from "./fs-utils.js";
import { backupsDir, ensureManagerDirs, reaperResourcePath, reaperScriptsDir, toLuaPath, workspaceRoot } from "./paths.js";
import { writePluginCache } from "./plugin-cache.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(__dirname, "..");

export function install({ root = workspaceRoot(), resourcePath = reaperResourcePath() } = {}) {
  ensureManagerDirs(root);

  const installReport = {
    root,
    resourcePath,
    backups: [],
    installedFiles: [],
    changedFiles: [],
    notes: []
  };

  const scriptsDir = reaperScriptsDir(resourcePath);
  fs.mkdirSync(scriptsDir, { recursive: true });

  const bridgeTarget = path.join(scriptsDir, BRIDGE_FILE);
  const chatTarget = path.join(scriptsDir, CHAT_FILE);
  const gainStageTarget = path.join(scriptsDir, GAIN_STAGE_FILE);
  const selectAllItemsTarget = path.join(scriptsDir, SELECT_ALL_ITEMS_FILE);
  const detectArrangementTarget = path.join(scriptsDir, DETECT_ARRANGEMENT_FILE);
  const jsonTarget = path.join(scriptsDir, JSON_FILE);
  copyFileAtomic(path.join(repoRoot, "reaper", BRIDGE_FILE), bridgeTarget);
  copyFileAtomic(path.join(repoRoot, "reaper", CHAT_FILE), chatTarget);
  copyFileAtomic(path.join(repoRoot, "reaper", GAIN_STAGE_FILE), gainStageTarget);
  copyFileAtomic(path.join(repoRoot, "reaper", SELECT_ALL_ITEMS_FILE), selectAllItemsTarget);
  copyFileAtomic(path.join(repoRoot, "reaper", DETECT_ARRANGEMENT_FILE), detectArrangementTarget);
  copyFileAtomic(path.join(repoRoot, "reaper", JSON_FILE), jsonTarget);
  installReport.installedFiles.push(bridgeTarget, chatTarget, gainStageTarget, selectAllItemsTarget, detectArrangementTarget, jsonTarget);

  const configTarget = path.join(scriptsDir, CONFIG_FILE);
  fs.writeFileSync(configTarget, renderLuaConfig(root), "utf8");
  installReport.installedFiles.push(configTarget);

  const backupRoot = backupsDir(root);
  const kbFile = path.join(resourcePath, "reaper-kb.ini");
  const menuFile = path.join(resourcePath, "reaper-menu.ini");

  const kbChanged = [
    ensureActionRegistered(kbFile, backupRoot, installReport, {
      actionId: ACTION_ID,
      actionKbId: ACTION_KB_ID,
      file: BRIDGE_FILE
    }),
    ensureActionRegistered(kbFile, backupRoot, installReport, {
      actionId: CHAT_ACTION_ID,
      actionKbId: CHAT_ACTION_KB_ID,
      file: CHAT_FILE
    }),
    ensureActionRegistered(kbFile, backupRoot, installReport, {
      actionId: GAIN_STAGE_ACTION_ID,
      actionKbId: GAIN_STAGE_ACTION_KB_ID,
      file: GAIN_STAGE_FILE
    }),
    ensureActionRegistered(kbFile, backupRoot, installReport, {
      actionId: SELECT_ALL_ITEMS_ACTION_ID,
      actionKbId: SELECT_ALL_ITEMS_ACTION_KB_ID,
      file: SELECT_ALL_ITEMS_FILE
    }),
    ensureActionRegistered(kbFile, backupRoot, installReport, {
      actionId: DETECT_ARRANGEMENT_ACTION_ID,
      actionKbId: DETECT_ARRANGEMENT_ACTION_KB_ID,
      file: DETECT_ARRANGEMENT_FILE
    })
  ].some(Boolean);
  const menuChanged = [
    ensureToolbarButton(menuFile, backupRoot, installReport, {
      actionId: ACTION_ID,
      label: APP_NAME,
      icon: "toolbar_audio_waveform_system.png",
      separator: true
    }),
    ensureToolbarButton(menuFile, backupRoot, installReport, {
      actionId: GAIN_STAGE_ACTION_ID,
      label: "Gain Stage"
    }),
    ensureToolbarButton(menuFile, backupRoot, installReport, {
      actionId: SELECT_ALL_ITEMS_ACTION_ID,
      label: "Select Items"
    }),
    ensureToolbarButton(menuFile, backupRoot, installReport, {
      actionId: DETECT_ARRANGEMENT_ACTION_ID,
      label: "Detect Parts"
    })
  ].some(Boolean);
  if (kbChanged) installReport.changedFiles.push(kbFile);
  if (menuChanged) installReport.changedFiles.push(menuFile);

  const entries = writePluginCache(root, resourcePath);
  writeJsonAtomic(path.join(root, ".reaper-manager", "install-report.json"), {
    ...installReport,
    pluginCount: entries.length,
    installedAt: new Date().toISOString()
  });

  if (isReaperRunning()) {
    installReport.notes.push("REAPER is currently running. Restart it once so toolbar/action changes are loaded.");
  }

  return {
    ...installReport,
    pluginCount: entries.length
  };
}

function renderLuaConfig(root) {
  return [
    "return {",
    `  workspace_root = ${JSON.stringify(toLuaPath(root))},`,
    `  bridge_action_id = ${JSON.stringify(ACTION_ID)},`,
    `  gain_stage_action_id = ${JSON.stringify(GAIN_STAGE_ACTION_ID)},`,
    "  quick_action_timeout_seconds = 90,",
    "  poll_interval = 0.25",
    "}",
    ""
  ].join("\n");
}

function ensureActionRegistered(kbFile, backupRoot, report, action) {
  let content = fs.existsSync(kbFile) ? fs.readFileSync(kbFile, "utf8") : "";
  if (content.includes(action.actionId) || content.includes(action.actionKbId)) return false;

  const backup = backupFile(kbFile, backupRoot);
  if (backup) report.backups.push(backup);

  const line = `SCR 4 0 ${action.actionKbId} "Custom: ${action.file}" "Reaper Manager/${action.file}"`;
  content = content.replace(/\s*$/, "");
  fs.writeFileSync(kbFile, `${content}\n${line}\n`, "utf8");
  return true;
}

function ensureToolbarButton(menuFile, backupRoot, report, action) {
  let content = fs.existsSync(menuFile) ? fs.readFileSync(menuFile, "utf8") : "";
  if (content.includes(action.actionId)) return false;

  const backup = backupFile(menuFile, backupRoot);
  if (backup) report.backups.push(backup);

  if (!content.includes("[Main toolbar]")) {
    content = `${content.replace(/\s*$/, "")}\n\n[Main toolbar]\ntitle=Main toolbar\n`;
  }

  const lines = content.split(/\r?\n/);
  const start = lines.findIndex((line) => line.trim() === "[Main toolbar]");
  let end = lines.length;
  for (let i = start + 1; i < lines.length; i += 1) {
    if (/^\[.+\]$/.test(lines[i].trim())) {
      end = i;
      break;
    }
  }

  const section = lines.slice(start + 1, end);
  const itemIndexes = section
    .map((line) => line.match(/^item_(\d+)=/))
    .filter(Boolean)
    .map((match) => Number(match[1]));
  const nextIndex = itemIndexes.length ? Math.max(...itemIndexes) + 1 : 0;

  const insert = [];
  let itemIndex = nextIndex;
  if (action.separator) {
    insert.push(`item_${itemIndex}=-1`);
    itemIndex += 1;
  }
  insert.push(`item_${itemIndex}=${action.actionId} ${action.label}`);
  if (action.icon) insert.push(`icon_${itemIndex}=${action.icon}`);

  lines.splice(end, 0, ...insert);
  fs.writeFileSync(menuFile, `${lines.join("\n").replace(/\s*$/, "")}\n`, "utf8");
  return true;
}

function isReaperRunning() {
  if (process.platform !== "win32") return false;
  try {
    const output = execFileSync("powershell.exe", [
      "-NoProfile",
      "-Command",
      "Get-Process -Name reaper -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Id"
    ], { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] });
    return output.trim().length > 0;
  } catch {
    return false;
  }
}
