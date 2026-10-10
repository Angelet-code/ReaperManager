import { execFileSync } from "node:child_process";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { CommandError } from "./core/errors.js";

const MODULE_DIR = path.dirname(fileURLToPath(import.meta.url));
export const DECLIP_SCRIPT = path.resolve(MODULE_DIR, "..", "scripts", "declip.py");

const TUNING = [
  // [cli option, python flag, label, min, max]
  ["threshold", "--threshold", "Plateau threshold", 0.8, 0.999],
  ["edge", "--edge", "Edge samples", 0, 8],
  ["anchor-ms", "--anchor-ms", "Anchor window ms", 5, 500],
  ["slew-db", "--slew-db", "Slew dB", 0.1, 12],
  ["knee-db", "--knee-db", "Knee dB", 0, 12],
  ["max-db", "--max-db", "Max dB over clip", 0.5, 24],
  ["keep", "--keep", "Crest keep", 0, 1]
];

// Source-time range (seconds) to repair, from a sample_edit_probe response.
export function declipSourceRange(probe, { item = false } = {}) {
  const pos = Number(probe.item_position);
  const len = Number(probe.item_length);
  const rate = Number(probe.take_playrate) || 1;
  const offset = Number(probe.take_offset) || 0;
  let start = pos;
  let end = pos + len;

  if (!item) {
    const sel = probe.time_selection || {};
    if (!(Number(sel.end) > Number(sel.start))) {
      throw new CommandError("No time selection. Select the clipped part (or use --item for the whole item).");
    }
    start = Math.max(start, Number(sel.start));
    end = Math.min(end, Number(sel.end));
    if (end <= start) throw new CommandError("The time selection does not overlap the selected item.");
  }

  return {
    startS: Math.max(0, offset + (start - pos) * rate),
    endS: offset + (end - pos) * rate
  };
}

export function buildDeclipArgs(options, sourceFile, range, outFile) {
  const args = [DECLIP_SCRIPT, sourceFile, "--start-s", String(range.startS), "--end-s", String(range.endS), "--out", outFile];
  for (const [key, flag, label, min, max] of TUNING) {
    if (options[key] === undefined) continue;
    const value = Number(options[key]);
    if (!Number.isFinite(value) || value < min || value > max) {
      throw new CommandError(`${label} must be a number between ${min} and ${max}.`);
    }
    args.push(flag, String(value));
  }
  return args;
}

export function buildDeclipApplyCommand(probe, result) {
  return {
    type: "sample_edit_apply",
    takeGuid: probe.take_guid,
    channels: result.channels.map((entry) => ({
      channel: entry.channel,
      start: result.start,
      end: result.end,
      edits: entry.edits
    }))
  };
}

export function resolveDeclipPython(options = {}) {
  const candidates = [
    options.python,
    process.env.REAPER_MANAGER_PYTHON,
    path.join(os.homedir(), "AppData", "Local", "Programs", "Python", "Python314", "python.exe"),
    "python",
    "py"
  ].filter(Boolean);

  for (const candidate of candidates) {
    try {
      execFileSync(candidate, ["-c", "import numpy, scipy"], { stdio: "ignore", timeout: 20000 });
      return candidate;
    } catch {
      // Try the next candidate.
    }
  }
  throw new CommandError("declip needs Python with numpy and scipy. Install them (py -m pip install numpy scipy) or set REAPER_MANAGER_PYTHON.");
}

// probe -> python analysis -> (unless preview) one sample_edit_apply = one undo step.
export async function runDeclip(options, { request, tmpDir = os.tmpdir() }) {
  const probeResponse = await request({ type: "sample_edit_probe" });
  if (!probeResponse?.ok) throw new CommandError(probeResponse?.error || "sample_edit_probe failed.");
  const probe = probeResponse.data;

  if (!/\.wav$/i.test(probe.source_file || "")) {
    throw new CommandError(`declip reads WAV sources only (active take: ${probe.source_file || "none"}).`);
  }
  if (!options.preview && !probe.sample_edits_enabled) {
    throw new CommandError("Sample edits are not active on the active take. Enable them (Take settings > sample edits) and retry.");
  }

  const range = declipSourceRange(probe, { item: Boolean(options.item) });
  const outFile = path.join(tmpDir, `reaper-manager-declip-${process.pid}-${Date.now()}.json`);
  const python = resolveDeclipPython(options);
  let summary;
  try {
    const stdout = execFileSync(python, buildDeclipArgs(options, probe.source_file, range, outFile), {
      encoding: "utf8",
      timeout: Number(options.timeout || 15 * 60 * 1000),
      maxBuffer: 16 * 1024 * 1024
    });
    summary = JSON.parse(stdout.trim().split(/\r?\n/).pop());
  } catch (error) {
    const text = String(error.stdout || "").trim().split(/\r?\n/).pop();
    let detail = error.message;
    try { detail = JSON.parse(text).error || detail; } catch { /* keep message */ }
    throw new CommandError(`declip analysis failed: ${detail}`);
  }

  const result = JSON.parse(fs.readFileSync(outFile, "utf8"));
  fs.rmSync(outFile, { force: true });
  const report = {
    source: probe.source_file,
    rangeSeconds: [Number(range.startS.toFixed(4)), Number(range.endS.toFixed(4))],
    channels: summary.channels,
    preview: Boolean(options.preview)
  };

  const editCount = result.channels.reduce((sum, entry) => sum + entry.edits.length, 0);
  if (options.preview || editCount === 0) return { ...report, applied: false };

  const applied = await request(buildDeclipApplyCommand(probe, result));
  if (!applied?.ok) throw new CommandError(applied?.error || "sample_edit_apply failed.");
  return { ...report, applied: true, written: applied.data.written, totalSampleEdits: applied.data.total_sample_edits };
}
