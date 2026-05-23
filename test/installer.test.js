import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import {
  ACTION_ID,
  BRIDGE_FILE,
  DETECT_ARRANGEMENT_ACTION_ID,
  DETECT_ARRANGEMENT_FILE,
  GAIN_STAGE_ACTION_ID,
  GAIN_STAGE_FILE,
  SELECT_ALL_ITEMS_ACTION_ID,
  SELECT_ALL_ITEMS_FILE
} from "../src/constants.js";
import { install } from "../src/installer.js";

test("install registers toolbar actions", () => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), "rm-install-root-"));
  const resourcePath = fs.mkdtempSync(path.join(os.tmpdir(), "rm-install-resource-"));

  const report = install({ root, resourcePath });
  const scriptsDir = path.join(resourcePath, "Scripts", "Reaper Manager");
  const kb = fs.readFileSync(path.join(resourcePath, "reaper-kb.ini"), "utf8");
  const menu = fs.readFileSync(path.join(resourcePath, "reaper-menu.ini"), "utf8");
  const config = fs.readFileSync(path.join(scriptsDir, "rm_config.lua"), "utf8");

  assert.ok(report.installedFiles.includes(path.join(scriptsDir, BRIDGE_FILE)));
  assert.ok(report.installedFiles.includes(path.join(scriptsDir, GAIN_STAGE_FILE)));
  assert.ok(report.installedFiles.includes(path.join(scriptsDir, SELECT_ALL_ITEMS_FILE)));
  assert.ok(report.installedFiles.includes(path.join(scriptsDir, DETECT_ARRANGEMENT_FILE)));
  assert.ok(fs.existsSync(path.join(scriptsDir, GAIN_STAGE_FILE)));
  assert.ok(fs.existsSync(path.join(scriptsDir, SELECT_ALL_ITEMS_FILE)));
  assert.ok(fs.existsSync(path.join(scriptsDir, DETECT_ARRANGEMENT_FILE)));
  assert.match(kb, new RegExp(GAIN_STAGE_FILE.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")));
  assert.match(kb, new RegExp(SELECT_ALL_ITEMS_FILE.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")));
  assert.match(kb, new RegExp(DETECT_ARRANGEMENT_FILE.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")));
  assert.match(menu, new RegExp(ACTION_ID));
  assert.match(menu, new RegExp(GAIN_STAGE_ACTION_ID));
  assert.match(menu, new RegExp(SELECT_ALL_ITEMS_ACTION_ID));
  assert.match(menu, new RegExp(DETECT_ARRANGEMENT_ACTION_ID));
  assert.match(config, /bridge_action_id/);
});
