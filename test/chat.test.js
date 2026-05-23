import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import {
  isBridgeReady,
  inferRootFromChatRequest,
  normalizeChatPlan,
  planLocalChatAction,
  planChatActions,
  processChatRequestFile,
  runChatText
} from "../src/chat.js";
import { writeJsonAtomic } from "../src/fs-utils.js";
import { chatRequestDir, chatResponseDir, ensureManagerDirs, stateDir } from "../src/paths.js";

const NOW = new Date("2026-05-23T02:00:00.000Z");

test("chat detects a live bridge heartbeat", () => {
  assert.equal(isBridgeReady({
    ok: true,
    bridge: "running",
    time: "2026-05-23T01:59:55.000Z"
  }, NOW), true);
  assert.equal(isBridgeReady({
    ok: true,
    bridge: "running",
    time: "2026-05-23T01:59:00.000Z"
  }, NOW), false);
});

test("chat request paths infer the workspace root", () => {
  const root = tempRoot();
  const requestFile = path.join(chatRequestDir(root), "chat-1.json");
  assert.equal(inferRootFromChatRequest(requestFile), root);
});

test("chat planner normalizes a simple model command", async () => {
  const fakeClient = {
    responses: {
      create: async (request) => {
        assert.equal(request.model, "gpt-5.5");
        assert.equal(request.reasoning.effort, "low");
        return {
          output_text: JSON.stringify({
            status: "execute",
            message: "Bajo guitarras 1 dB.",
            commands: [
              {
                type: "adjust_track_volume_db",
                filter: { type: "name_contains", value: "GTR", caseSensitive: false },
                db: -1
              }
            ]
          })
        };
      }
    }
  };

  const plan = await planChatActions("baja guitarras 1 dB", {
    openaiClient: fakeClient,
    context: {},
    inspection: { tracks: [{ index: 1, name: "GTR L" }] }
  });

  assert.equal(plan.kind, "execute");
  assert.equal(plan.commands.length, 1);
  assert.equal(plan.commands[0].type, "adjust_track_volume_db");
  assert.equal(plan.commands[0].db, -1);
});

test("local chat planner handles simple known commands", () => {
  const plan = planLocalChatAction("baja 1 dB las pistas que contengan GTR", {});

  assert.equal(plan.kind, "execute");
  assert.equal(plan.commands.length, 1);
  assert.equal(plan.commands[0].type, "adjust_track_volume_db");
  assert.equal(plan.commands[0].db, -1);
  assert.equal(plan.commands[0].filter.value, "GTR");
});

test("local chat planner rejects unclear commands with fixed wording", () => {
  const plan = planLocalChatAction("genera un proyecto para jazz", {});

  assert.equal(plan.kind, "not_understood");
  assert.equal(plan.message, "No entiendo lo que quieres.");
  assert.equal(plan.commands.length, 0);
});

test("chat planner supports compound commands", () => {
  const plan = normalizeChatPlan({
    status: "execute",
    commands: [
      {
        type: "color_tracks",
        filter: { type: "name_contains", value: "VOX", caseSensitive: false },
        color: "azul"
      },
      {
        type: "set_track_pan",
        filter: { type: "name_contains", value: "GTR", caseSensitive: false },
        pan: "L50"
      }
    ]
  }, "colorea voces de azul y panea guitarras L50", {});

  assert.equal(plan.kind, "execute");
  assert.equal(plan.commands.length, 2);
  assert.deepEqual(plan.commands[0].color, { r: 40, g: 105, b: 255 });
  assert.equal(plan.commands[1].pan, -0.5);
});

test("chat planner returns clarifications without commands", () => {
  const plan = normalizeChatPlan({
    status: "clarify",
    message: "Que pistas quieres tocar?",
    commands: []
  }, "baja un poco", {});

  assert.equal(plan.kind, "clarify");
  assert.equal(plan.commands.length, 0);
});

test("chat safety blocks destructive commands without explicit intent", () => {
  const blocked = normalizeChatPlan({
    status: "execute",
    commands: [{ type: "delete_tracks", filter: { type: "selected" } }]
  }, "limpia la sesion un poco", {});

  assert.equal(blocked.kind, "clarify");

  const allowed = normalizeChatPlan({
    status: "execute",
    commands: [{ type: "delete_tracks", filter: { type: "selected" } }]
  }, "borra las pistas seleccionadas", {});

  assert.equal(allowed.kind, "execute");
});

test("chat returns bridge guidance before calling the model", async () => {
  const root = tempRoot();
  const response = await runChatText("baja guitarras 1 dB", {
    root,
    env: {},
    openaiClient: {
      responses: {
        create: async () => {
          throw new Error("should not call model");
        }
      }
    }
  });

  assert.equal(response.ok, false);
  assert.equal(response.kind, "needs_bridge");
  assert.match(response.message, /Pulsa.*Reaper Manager/);
});

test("chat executes simple commands without OPENAI_API_KEY", async () => {
  const root = tempRoot();
  writeLiveHeartbeat(root);

  const response = await runChatText("baja guitarras 1 dB", {
    root,
    env: {},
    now: NOW,
    commandRunner: async (command) => ({
      ok: true,
      id: "cmd-test",
      data: {
        changed: 1,
        command
      }
    })
  });

  assert.equal(response.ok, true);
  assert.equal(response.kind, "executed");
  assert.equal(response.actions[0].type, "adjust_track_volume_db");
});

test("chat uses OpenAI fallback for unclear local commands", async () => {
  const root = tempRoot();
  writeLiveHeartbeat(root);

  const response = await runChatText("genera un proyecto para jazz", {
    root,
    env: { OPENAI_API_KEY: "test-key" },
    now: NOW,
    inspection: { tracks: [] },
    openaiClient: {
      responses: {
        create: async () => ({
          output_text: JSON.stringify({
            status: "execute",
            message: "Creo dos pistas para jazz.",
            commands: [
              { type: "create_tracks", count: 2, name: "JAZZ" }
            ]
          })
        })
      }
    },
    commandRunner: async (command) => {
      assert.equal(command.type, "create_tracks");
      assert.equal(command.count, 2);
      assert.equal(command.name, "JAZZ");
      return {
        ok: true,
        id: "cmd-ai",
        data: { created: [{ name: "JAZZ 1" }, { name: "JAZZ 2" }] }
      };
    }
  });

  assert.equal(response.ok, true);
  assert.equal(response.kind, "executed");
  assert.equal(response.actions[0].type, "create_tracks");
});

test("chat answers fixed not-understood when fallback has no API key", async () => {
  const root = tempRoot();
  writeLiveHeartbeat(root);

  const response = await runChatText("haz algo jazzistico", {
    root,
    env: {},
    now: NOW
  });

  assert.equal(response.ok, false);
  assert.equal(response.kind, "not_understood");
  assert.equal(response.message, "No entiendo lo que quieres.");
});

test("chat converts AI clarifications to fixed not-understood wording", async () => {
  const root = tempRoot();
  writeLiveHeartbeat(root);

  const response = await runChatText("hazlo mejor", {
    root,
    env: { OPENAI_API_KEY: "test-key" },
    now: NOW,
    inspection: { tracks: [] },
    openaiClient: {
      responses: {
        create: async () => ({
          output_text: JSON.stringify({
            status: "clarify",
            message: "Que quieres cambiar?",
            commands: []
          })
        })
      }
    }
  });

  assert.equal(response.ok, false);
  assert.equal(response.kind, "not_understood");
  assert.equal(response.message, "No entiendo lo que quieres.");
});

test("chat request file writes a response without REAPER", async () => {
  const root = tempRoot();
  const id = "chat-test-request";
  const requestFile = path.join(chatRequestDir(root), `${id}.json`);
  writeJsonAtomic(requestFile, { id, text: "baja guitarras 1 dB" });

  const response = await processChatRequestFile(requestFile, { root });
  const responseFile = path.join(chatResponseDir(root), `${id}.json`);
  const written = JSON.parse(fs.readFileSync(responseFile, "utf8"));

  assert.equal(response.kind, "needs_bridge");
  assert.equal(written.id, id);
  assert.equal(written.ok, false);
});

function tempRoot() {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), "rm-chat-"));
  ensureManagerDirs(root);
  return root;
}

function writeLiveHeartbeat(root) {
  writeJsonAtomic(path.join(stateDir(root), "heartbeat.json"), {
    ok: true,
    bridge: "running",
    time: "2026-05-23T01:59:55.000Z"
  });
}
