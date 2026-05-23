import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import { writeJsonAtomic, readJson } from "./fs-utils.js";
import { ensureManagerDirs, managerDir, queueDir, responseDir, stateDir } from "./paths.js";

export function enqueueCommand(command, { root = process.cwd() } = {}) {
  ensureManagerDirs(root);
  const id = command.id || `cmd-${Date.now()}-${crypto.randomBytes(4).toString("hex")}`;
  const payload = {
    id,
    createdAt: new Date().toISOString(),
    source: "codex",
    command: {
      ...command,
      id: undefined
    }
  };

  writeJsonAtomic(path.join(queueDir(root), `${id}.json`), payload);
  return id;
}

export async function waitForResponse(id, { root = process.cwd(), timeoutMs = 60000 } = {}) {
  const file = path.join(responseDir(root), `${id}.json`);
  const started = Date.now();

  while (Date.now() - started < timeoutMs) {
    if (fs.existsSync(file)) {
      return readJson(file);
    }
    await new Promise((resolve) => setTimeout(resolve, 200));
  }

  throw new Error(
    `Timed out waiting for REAPER response (${id}). Start the Reaper Manager bridge from the REAPER toolbar.`
  );
}

export function readStatus(root = process.cwd()) {
  return {
    managerDir: managerDir(root),
    heartbeat: readJson(path.join(stateDir(root), "heartbeat.json"), null),
    lastResponse: readJson(path.join(stateDir(root), "last-response.json"), null)
  };
}
