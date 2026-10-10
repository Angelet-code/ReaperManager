import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import { TOOLS_ACTION_ID, TOOLS_FILE } from "../src/constants.js";
import { install } from "../src/installer.js";
import { TOOLS, runToolToReport, summarizeDeclip, summarizeVocalLevel } from "../src/tools.js";

test("install adds the Herramientas toolbar menu with node/cli paths", () => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), "rm-tools-root-"));
  const resourcePath = fs.mkdtempSync(path.join(os.tmpdir(), "rm tools resource-"));
  install({ root, resourcePath });
  const scriptsDir = path.join(resourcePath, "Scripts", "Reaper Manager");
  const kb = fs.readFileSync(path.join(resourcePath, "reaper-kb.ini"), "utf8");
  const menu = fs.readFileSync(path.join(resourcePath, "reaper-menu.ini"), "utf8");
  const config = fs.readFileSync(path.join(scriptsDir, "rm_config.lua"), "utf8");

  assert.ok(fs.existsSync(path.join(scriptsDir, TOOLS_FILE)));
  assert.match(kb, /Reaper Manager Tools\.lua/);
  assert.match(menu, new RegExp(`${TOOLS_ACTION_ID} Herramientas`));
  assert.match(config, /node_path = ".+node(\.exe)?"/);
  assert.match(config, /cli_path = ".+\/bin\/reaper-manager\.js"/);
  assert.match(config, /select_items_action_id/);
});

test("the tools menu script launches every CLI tool it lists", () => {
  const lua = fs.readFileSync(path.resolve("reaper", TOOLS_FILE), "utf8");
  for (const name of [...lua.matchAll(/tool = "([a-z-]+)"/g)].map((m) => m[1])) {
    assert.ok(TOOLS[name], `menu tool "${name}" must exist in src/tools.js`);
  }
  assert.match(lua, /reaper\.ExecProcess\(cmd, -1\)/, "tools must not block REAPER while the bridge works");
});

test("summarizeDeclip reports runs and whether it was applied", () => {
  const { lines } = summarizeDeclip({
    applied: true,
    channels: [{ channel: 0, runs: 12, edits: 140, peak_db_over_clip: 4.2, headroom_db: 6.8 }]
  });
  assert.match(lines[0], /12 picos/);
  assert.match(lines.at(-1), /un solo undo/);
});

test("summarizeVocalLevel explains skips caused by an existing envelope", () => {
  const { lines } = summarizeVocalLevel({ ok: true, data: { applied: 0, skip_reasons: { "existing take volume envelope": 1 } } });
  assert.match(lines.join(" "), /replace-envelope/);
});

test("runToolToReport always writes a report, also on failure", async () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "rm-tool-report-"));
  const file = path.join(dir, "r.json");
  const report = await runToolToReport("declip", file, async () => ({ ok: false, error: "bridge stopped" }));
  assert.equal(report.ok, false);
  assert.deepEqual(JSON.parse(fs.readFileSync(file, "utf8")), report);
  assert.match(report.lines[0], /bridge stopped/);
});
