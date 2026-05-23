import fs from "node:fs";
import os from "node:os";
import path from "node:path";

export function workspaceRoot() {
  return process.cwd();
}

export function managerDir(root = workspaceRoot()) {
  return path.join(root, ".reaper-manager");
}

export function queueDir(root = workspaceRoot()) {
  return path.join(managerDir(root), "queue");
}

export function stateDir(root = workspaceRoot()) {
  return path.join(managerDir(root), "state");
}

export function responseDir(root = workspaceRoot()) {
  return path.join(stateDir(root), "responses");
}

export function chatDir(root = workspaceRoot()) {
  return path.join(managerDir(root), "chat");
}

export function chatRequestDir(root = workspaceRoot()) {
  return path.join(chatDir(root), "requests");
}

export function chatResponseDir(root = workspaceRoot()) {
  return path.join(chatDir(root), "responses");
}

export function chatHistoryPath(root = workspaceRoot()) {
  return path.join(chatDir(root), "history.json");
}

export function chatStatePath(root = workspaceRoot()) {
  return path.join(chatDir(root), "state.json");
}

export function backupsDir(root = workspaceRoot()) {
  return path.join(managerDir(root), "backups");
}

export function preferencesPath(root = workspaceRoot()) {
  return path.join(managerDir(root), "preferences.json");
}

export function pluginCachePath(root = workspaceRoot()) {
  return path.join(managerDir(root), "plugin-cache.json");
}

export function reaperResourcePath() {
  if (process.env.REAPER_RESOURCE_PATH) {
    return process.env.REAPER_RESOURCE_PATH;
  }

  if (process.env.APPDATA) {
    return path.join(process.env.APPDATA, "REAPER");
  }

  return path.join(os.homedir(), "AppData", "Roaming", "REAPER");
}

export function reaperScriptsDir(resourcePath = reaperResourcePath()) {
  return path.join(resourcePath, "Scripts", "Reaper Manager");
}

export function ensureManagerDirs(root = workspaceRoot()) {
  for (const dir of [
    managerDir(root),
    queueDir(root),
    stateDir(root),
    responseDir(root),
    chatDir(root),
    chatRequestDir(root),
    chatResponseDir(root),
    backupsDir(root)
  ]) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

export function toLuaPath(value) {
  return String(value).replaceAll("\\", "/");
}
