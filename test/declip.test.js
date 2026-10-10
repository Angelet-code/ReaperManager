import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import { normalizeCommand } from "../src/commands.js";
import {
  DECLIP_SCRIPT,
  buildDeclipApplyCommand,
  buildDeclipArgs,
  declipSourceRange,
  resolveDeclipPython
} from "../src/declip.js";

const probe = {
  take_guid: "{TAKE}",
  source_file: "C:\\audio\\vox.wav",
  item_position: 10,
  item_length: 5,
  take_offset: 2,
  take_playrate: 1,
  time_selection: { start: 11, end: 12.5 },
  sample_edits_enabled: true
};

test("declipSourceRange maps the time selection into source seconds", () => {
  assert.deepEqual(declipSourceRange(probe), { startS: 3, endS: 4.5 });
});

test("declipSourceRange clamps the selection to the item and honours playrate", () => {
  const range = declipSourceRange({ ...probe, take_playrate: 2, time_selection: { start: 8, end: 11 } });
  assert.deepEqual(range, { startS: 2, endS: 4 });
});

test("declipSourceRange --item covers the whole item", () => {
  assert.deepEqual(declipSourceRange({ ...probe, time_selection: { start: 0, end: 0 } }, { item: true }), { startS: 2, endS: 7 });
});

test("declipSourceRange rejects a missing time selection", () => {
  assert.throws(() => declipSourceRange({ ...probe, time_selection: { start: 0, end: 0 } }), /No time selection/);
});

test("buildDeclipArgs passes tuning flags and validates them", () => {
  const args = buildDeclipArgs({ keep: "0.7", "slew-db": "2" }, "a.wav", { startS: 1, endS: 2 }, "out.json");
  assert.equal(args[0], DECLIP_SCRIPT);
  assert.deepEqual(args.slice(1, 8), ["a.wav", "--start-s", "1", "--end-s", "2", "--out", "out.json"]);
  assert.ok(args.includes("--slew-db") && args.includes("--keep"));
  assert.throws(() => buildDeclipArgs({ keep: 3 }, "a.wav", { startS: 0, endS: 1 }, "o"), /Crest keep/);
});

test("buildDeclipApplyCommand produces a valid sample_edit_apply command", () => {
  const command = buildDeclipApplyCommand(probe, {
    start: 100,
    end: 200,
    channels: [{ channel: 0, edits: [[150, 0.5]] }]
  });
  assert.equal(command.takeGuid, "{TAKE}");
  assert.deepEqual(command.channels[0], { channel: 0, start: 100, end: 200, edits: [[150, 0.5]] });
  assert.equal(normalizeCommand(command), command);
  assert.throws(() => normalizeCommand({ type: "sample_edit_apply", channels: [] }), /non-empty channels/);
  assert.equal(normalizeCommand({ type: "sample_edit_probe" }).type, "sample_edit_probe");
});

function writeWav24(file, samples, sampleRate) {
  const data = Buffer.alloc(samples.length * 3);
  samples.forEach((value, i) => {
    const v = Math.max(-8388608, Math.min(8388607, Math.round(value * 8388608)));
    data.writeIntLE(v, i * 3, 3);
  });
  const header = Buffer.alloc(44);
  header.write("RIFF", 0); header.writeUInt32LE(36 + data.length, 4); header.write("WAVE", 8);
  header.write("fmt ", 12); header.writeUInt32LE(16, 16); header.writeUInt16LE(1, 20); header.writeUInt16LE(1, 22);
  header.writeUInt32LE(sampleRate, 24); header.writeUInt32LE(sampleRate * 3, 28); header.writeUInt16LE(3, 32); header.writeUInt16LE(24, 34);
  header.write("data", 36); header.writeUInt32LE(data.length, 40);
  fs.writeFileSync(file, Buffer.concat([header, data]));
}

let python = null;
try { python = resolveDeclipPython(); } catch { python = null; }

test("declip.py rebuilds clipped peaks closer to the true waveform", { skip: !python && "python with numpy/scipy not available" }, () => {
  const sr = 48000;
  const clip = 0.4467; // -7 dB, like a take rendered down after clipping at 0 dBFS
  const truth = [];
  for (let i = 0; i < sr; i += 1) {
    const t = i / sr;
    const env = Math.min(1, t / 0.25) * Math.min(1, (1 - t) / 0.25);            // swell in and out
    const f0 = 180;
    const s = Math.sin(2 * Math.PI * f0 * t) + 0.5 * Math.sin(2 * Math.PI * 2 * f0 * t + 0.6) + 0.25 * Math.sin(2 * Math.PI * 3 * f0 * t + 1.1);
    truth.push(0.38 * env * s);                                                    // peaks up to ~1.6x clip
  }
  const clipped = truth.map((v) => Math.max(-clip, Math.min(clip, v)));

  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "rm-declip-"));
  const wav = path.join(dir, "clipped.wav");
  const out = path.join(dir, "edits.json");
  writeWav24(wav, clipped, sr);
  try {
    const stdout = execFileSync(python, [DECLIP_SCRIPT, wav, "--out", out], { encoding: "utf8" });
    const summary = JSON.parse(stdout.trim().split(/\r?\n/).pop());
    assert.equal(summary.ok, true);
    const { channels } = JSON.parse(fs.readFileSync(out, "utf8"));
    const edits = channels[0].edits;
    assert.ok(edits.length > 100, `expected many edits, got ${edits.length}`);

    let errClipped = 0;
    let errRestored = 0;
    for (const [index, value] of edits) {
      assert.ok(Math.abs(value) <= 0.98, "edits must stay below the absolute ceiling");
      errClipped += (clipped[index] - truth[index]) ** 2;
      errRestored += (value - truth[index]) ** 2;
    }
    assert.ok(errRestored < errClipped * 0.5, `restored error ${errRestored} should be well below clipped error ${errClipped}`);
  } finally {
    fs.rmSync(dir, { recursive: true, force: true });
  }
});

test("declip.py refuses sources without headroom", { skip: !python && "python with numpy/scipy not available" }, () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "rm-declip-"));
  const wav = path.join(dir, "full.wav");
  const sr = 48000;
  writeWav24(wav, Array.from({ length: sr / 2 }, (_, i) => Math.max(-1, Math.min(1, 1.5 * Math.sin(2 * Math.PI * 200 * i / sr)))), sr);
  try {
    let failed = false;
    try {
      execFileSync(python, [DECLIP_SCRIPT, wav, "--out", path.join(dir, "o.json")], { encoding: "utf8" });
    } catch (error) {
      failed = true;
      assert.match(String(error.stdout), /headroom/);
    }
    assert.ok(failed, "expected declip.py to fail without headroom");
  } finally {
    fs.rmSync(dir, { recursive: true, force: true });
  }
});

test("rm_sample_edit is registered in the bridge and installer", async () => {
  const { RUNTIME_FILES } = await import("../src/constants.js").catch(() => ({}));
  const reaperDir = path.resolve(path.dirname(DECLIP_SCRIPT), "..", "reaper");
  const registry = fs.readFileSync(path.join(reaperDir, "rm_registry.lua"), "utf8");
  const bridge = fs.readFileSync(path.join(reaperDir, "Reaper Manager Bridge.lua"), "utf8");
  const module = fs.readFileSync(path.join(reaperDir, "rm_sample_edit.lua"), "utf8");
  const constants = fs.readFileSync(path.resolve(reaperDir, "..", "src", "constants.js"), "utf8");
  assert.match(registry, /"rm_sample_edit"/);
  assert.match(bridge, /"rm_sample_edit"/);
  assert.match(constants, /"rm_sample_edit\.lua"/);
  assert.match(module, /registry\.command\("sample_edit_probe", command_sample_edit_probe, \{ read_only = true \}\)/);
  assert.match(module, /registry\.command\("sample_edit_apply", command_sample_edit_apply\)/);
  assert.ok(RUNTIME_FILES === undefined || Array.isArray(RUNTIME_FILES));
});
