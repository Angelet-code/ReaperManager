import crypto from "node:crypto";
import { execFileSync } from "node:child_process";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { CommandError } from "./core/errors.js";
import { readJson, writeJsonAtomic } from "./fs-utils.js";

const MODULE_DIR = path.dirname(fileURLToPath(import.meta.url));
const WAV_DEMUCS_RUNNER = path.resolve(MODULE_DIR, "..", "scripts", "demucs-wav-runner.py");
const ANALYSIS_VERSION = 2;

const MODEL_STEMS = {
  htdemucs: ["vocals", "drums", "bass", "other"],
  htdemucs_ft: ["vocals", "drums", "bass", "other"],
  hdemucs_mmi: ["vocals", "drums", "bass", "other"],
  mdx: ["vocals", "drums", "bass", "other"],
  mdx_extra: ["vocals", "drums", "bass", "other"],
  mdx_q: ["vocals", "drums", "bass", "other"],
  mdx_extra_q: ["vocals", "drums", "bass", "other"],
  htdemucs_6s: ["vocals", "drums", "bass", "other", "guitar", "piano"]
};
const SUPPORTED_REFERENCE_EXTENSIONS = new Set([".wav", ".wave", ".aif", ".aiff"]);

export function prepareReferenceHierarchy(inspection, options = {}) {
  const reference = inspection?.reference;
  if (!reference) {
    throw new CommandError("No REF/REFERENCE track found. Add one reference track before auto-balance.");
  }

  const media = reference.media;
  if (!media?.sourceFile) {
    throw new CommandError("REF track must contain one file-backed audio item.");
  }
  if (media.itemCount !== 1) {
    throw new CommandError("REF track must contain exactly one audio item for stem-based auto-balance.");
  }

  const sourceFile = path.resolve(media.sourceFile);
  const stemModel = normalizeStemModel(options.stemModel || options["stem-model"] || "htdemucs_6s");
  const stemNames = MODEL_STEMS[stemModel];
  const ext = path.extname(sourceFile).toLowerCase();
  if (!SUPPORTED_REFERENCE_EXTENSIONS.has(ext)) {
    throw new CommandError("REF must be WAV/AIFF for stem-based auto-balance. Convert/import the reference as WAV or AIFF.");
  }
  if (!fs.existsSync(sourceFile)) {
    throw new CommandError(`REF source file not found: ${sourceFile}`);
  }

  const sourceHash = hashFile(sourceFile);
  const projectSections = resolveChorusSections(inspection, options);
  const referenceRanges = mapSectionsToReferenceRanges(projectSections, media);
  const sectionsHash = hashJson(referenceRanges);
  const projectDir = inspection.project_path ? path.dirname(inspection.project_path) : path.dirname(sourceFile);
  const cacheDir = path.join(projectDir, "Reaper Manager Stems", `${sourceHash.slice(0, 16)}-${stemModel}`);
  const cacheFile = path.join(cacheDir, "reference-hierarchy.json");
  const cached = readJson(cacheFile, null);
  if (
    !options.force &&
    cached?.analysisVersion === ANALYSIS_VERSION &&
    cached?.sourceHash === sourceHash &&
    cached?.model === stemModel &&
    cached?.sectionsHash === sectionsHash &&
    stemsExist(cached.stems, stemNames)
  ) {
    return cached;
  }

  fs.mkdirSync(cacheDir, { recursive: true });
  const stems = findStemFiles(cacheDir, stemNames);
  if (!stemsExist(stems, stemNames)) {
    runDemucs(sourceFile, cacheDir, { ...options, stemModel });
  }

  const resolvedStems = findStemFiles(cacheDir, stemNames);
  if (!stemsExist(resolvedStems, stemNames)) {
    throw new CommandError(`Demucs finished, but expected ${stemNames.join("/")} stems were not found.`);
  }

  const stemMetrics = {};
  const warnings = [];
  for (const stem of stemNames) {
    try {
      stemMetrics[stem] = analyzeWavFile(resolvedStems[stem], {
        ...options,
        sections: referenceRanges,
        topWindowPercent: options.topWindowPercent || options["top-window-percent"] || 100
      });
    } catch (error) {
      if (stem === "vocals") throw error;
      stemMetrics[stem] = silentStemMetrics(resolvedStems[stem], referenceRanges);
      warnings.push(`${stem} stem is silent inside the chorus window; treating it as absent.`);
    }
  }

  const hierarchy = buildHierarchy({
    sourceFile,
    sourceHash,
    cacheDir,
    model: stemModel,
    stemNames,
    stems: resolvedStems,
    metrics: stemMetrics,
    warnings,
    projectSections,
    referenceRanges,
    sectionsHash
  });
  writeJsonAtomic(cacheFile, hierarchy);
  return hierarchy;
}

export function buildHierarchy({
  sourceFile,
  sourceHash,
  cacheDir,
  model = "htdemucs",
  stemNames = null,
  stems,
  metrics,
  warnings = [],
  projectSections = [],
  referenceRanges = [],
  sectionsHash = null
}) {
  const vocalRms = metrics.vocals?.rmsDb;
  if (!Number.isFinite(vocalRms)) {
    throw new CommandError("Could not analyze vocals stem from reference.");
  }

  const families = {};
  const names = stemNames || Object.keys(metrics);
  for (const stem of names) {
    const item = metrics[stem];
    if (!item || !Number.isFinite(item.rmsDb)) {
      throw new CommandError(`Could not analyze ${stem} stem from reference.`);
    }
    const sideToCenterDb = item.sideDb - item.centerDb;
    families[stem] = {
      levelDb: stem === "vocals" ? 0 : item.rmsDb - vocalRms,
      rmsDb: item.rmsDb,
      peakDb: item.peakDb,
      width: widthFromSideToCenter(sideToCenterDb),
      sideToCenterDb,
      activeSeconds: item.activeSeconds
    };
  }

  return {
    analysisVersion: ANALYSIS_VERSION,
    source: "demucs-stems",
    model,
    stemNames: names,
    createdAt: new Date().toISOString(),
    sourceFile,
    sourceHash,
    cacheDir,
    stems,
    analysisWindow: "chorus",
    sectionsHash,
    projectSections,
    referenceRanges,
    anchorFamily: "vocals",
    warnings,
    families
  };
}

export function analyzeWavFile(file, options = {}) {
  const buffer = fs.readFileSync(file);
  const wav = parseWav(buffer, file);
  const stride = Math.max(1, Number(options.sampleStride || 8));
  const windowMs = Number(options.windowMs || 300);
  const silenceDb = Number(options.silenceDb || -60);
  const topWindowFraction = Number(options.topWindowPercent || 20) / 100;
  const frameRanges = analysisFrameRanges(wav, options.sections);
  const analysisRate = wav.sampleRate / stride;
  const windowFrames = Math.max(1, Math.floor((analysisRate * windowMs) / 1000));

  const windows = [];
  let window = emptyWindow();
  let peak = 0;

  function flushWindow() {
    if (window.frames <= 0) return;
    const rms = Math.sqrt(window.total / window.frames);
    if (gainToDb(rms) >= silenceDb) windows.push(window);
    window = emptyWindow();
  }

  for (const range of frameRanges) {
    for (let frame = range.startFrame; frame < range.endFrame; frame += stride) {
      let frameSquare = 0;
      const left = readSample(wav, frame, 0);
      const right = wav.channels > 1 ? readSample(wav, frame, 1) : left;
      const center = (left + right) * 0.5;
      const side = (left - right) * 0.5;

      for (let ch = 0; ch < wav.channels; ch += 1) {
        const sample = readSample(wav, frame, ch);
        peak = Math.max(peak, Math.abs(sample));
        frameSquare += sample * sample;
      }

      window.total += frameSquare / wav.channels;
      window.center += center * center;
      window.side += side * side;
      window.frames += 1;
      if (window.frames >= windowFrames) flushWindow();
    }
    flushWindow();
  }

  flushWindow();
  if (windows.length === 0 || peak <= 0) {
    throw new CommandError(`Stem is silent or unreadable: ${file}`);
  }

  windows.sort((a, b) => b.total - a.total);
  const topCount = Math.max(1, Math.floor(windows.length * topWindowFraction + 0.5));
  const total = emptyWindow();
  for (const item of windows.slice(0, topCount)) {
    total.total += item.total;
    total.center += item.center;
    total.side += item.side;
    total.frames += item.frames;
  }

  return {
    file,
    sampleRate: wav.sampleRate,
    channels: wav.channels,
    rmsDb: gainToDb(Math.sqrt(total.total / total.frames)),
    centerDb: gainToDb(Math.sqrt(total.center / total.frames)),
    sideDb: gainToDb(Math.sqrt(total.side / total.frames)),
    peakDb: gainToDb(peak),
    activeSeconds: (total.frames * stride) / wav.sampleRate,
    sections: options.sections || null,
    windowCount: windows.length
  };
}

export function resolveChorusSections(inspection, options = {}) {
  const explicit = options.sections || options.chorusSections || options.balanceSections;
  const sections = explicit || inspection?.sections?.chorus || [];
  const normalized = sections
    .map((section, index) => normalizeSection(section, index))
    .filter(Boolean);

  if (normalized.length === 0) {
    throw new CommandError("No CHORUS/ESTRIBILLO/HOOK/CORO region was found. Add chorus regions before auto-balance.");
  }

  return normalized;
}

export function mapSectionsToReferenceRanges(sections, media) {
  const position = Number(media?.position || 0);
  const length = Number(media?.length || 0);
  const startOffset = Number(media?.startOffset || 0);
  const playrate = Number(media?.playrate || 1);
  const itemEnd = position + length;
  const ranges = [];

  for (const section of sections) {
    const overlapStart = Math.max(section.start, position);
    const overlapEnd = Math.min(section.end, itemEnd);
    if (overlapEnd <= overlapStart) continue;
    ranges.push({
      name: section.name,
      start: startOffset + (overlapStart - position) * playrate,
      end: startOffset + (overlapEnd - position) * playrate,
      projectStart: overlapStart,
      projectEnd: overlapEnd
    });
  }

  if (ranges.length === 0) {
    throw new CommandError("REF item does not overlap any chorus region, so the reference chorus cannot be analyzed.");
  }

  return ranges;
}

function runDemucs(sourceFile, cacheDir, options = {}) {
  const python = resolveDemucsPython(options);
  const stemModel = normalizeStemModel(options.stemModel || "htdemucs_6s");
  const timeoutMs = Number(options.stemTimeout || options["stem-timeout"] || 30 * 60 * 1000);
  const ext = path.extname(sourceFile).toLowerCase();
  let wavRunnerError = null;

  if ([".wav", ".wave"].includes(ext) && fs.existsSync(WAV_DEMUCS_RUNNER)) {
    const runnerArgs = [WAV_DEMUCS_RUNNER, "--model", stemModel, "--out", cacheDir, sourceFile];
    if (options.stemDevice || options["stem-device"] || options.device) {
      runnerArgs.splice(1, 0, "--device", options.stemDevice || options["stem-device"] || options.device);
    }
    try {
      execFileSync(python, runnerArgs, {
        stdio: "inherit",
        timeout: timeoutMs
      });
      return;
    } catch (error) {
      wavRunnerError = error;
    }
  }

  const args = ["-m", "demucs", "-n", stemModel, "--out", cacheDir, sourceFile];
  try {
    execFileSync(python, args, {
      stdio: "inherit",
      timeout: timeoutMs
    });
  } catch (error) {
    const runnerDetail = wavRunnerError ? ` WAV runner failed first: ${wavRunnerError.message}.` : "";
    throw new CommandError(
      `Demucs is not available or failed.${runnerDetail} Install it with "py -m pip install demucs" and retry. (${error.message})`
    );
  }
}

function resolveDemucsPython(options = {}) {
  const candidates = [
    options.python,
    options.demucsPython,
    process.env.REAPER_MANAGER_DEMUCS_PYTHON,
    path.join(os.homedir(), "AppData", "Local", "Programs", "Python", "Python314", "python.exe"),
    "py"
  ].filter(Boolean);

  for (const candidate of candidates) {
    try {
      execFileSync(candidate, ["-m", "demucs", "--help"], {
        stdio: "ignore",
        timeout: 15000
      });
      return candidate;
    } catch {
      // Try the next candidate.
    }
  }

  throw new CommandError("Demucs is installed, but no runnable Python could execute it. Set REAPER_MANAGER_DEMUCS_PYTHON to the Python executable that has Demucs.");
}

function findStemFiles(cacheDir, stemNames) {
  const out = {};
  if (!fs.existsSync(cacheDir)) return out;
  for (const file of walkFiles(cacheDir)) {
    const stem = path.basename(file, path.extname(file)).toLowerCase();
    if (stemNames.includes(stem) && path.extname(file).toLowerCase() === ".wav") {
      out[stem] = file;
    }
  }
  return out;
}

function stemsExist(stems = {}, stemNames) {
  return stemNames.every((stem) => stems[stem] && fs.existsSync(stems[stem]));
}

function normalizeStemModel(value) {
  const text = String(value || "").trim().toLowerCase();
  if (["6", "6s", "6-stem", "6-stems", "six"].includes(text)) return "htdemucs_6s";
  if (["4", "4s", "4-stem", "4-stems", "four"].includes(text)) return "htdemucs";
  if (MODEL_STEMS[text]) return text;
  throw new CommandError(`Unsupported Demucs model "${value}". Use htdemucs_6s, htdemucs, htdemucs_ft, or an MDX model.`);
}

function walkFiles(dir) {
  const out = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) out.push(...walkFiles(full));
    if (entry.isFile()) out.push(full);
  }
  return out;
}

function hashFile(file) {
  const hash = crypto.createHash("sha256");
  hash.update(fs.readFileSync(file));
  return hash.digest("hex");
}

function hashJson(value) {
  return crypto.createHash("sha256").update(JSON.stringify(value)).digest("hex");
}

function silentStemMetrics(file, sections) {
  return {
    file,
    sampleRate: null,
    channels: null,
    rmsDb: -120,
    centerDb: -120,
    sideDb: -120,
    peakDb: -120,
    activeSeconds: 0,
    sections,
    windowCount: 0,
    silent: true
  };
}

function normalizeSection(section, index) {
  const start = Number(section?.start);
  const end = Number(section?.end ?? section?.finish);
  if (!Number.isFinite(start) || !Number.isFinite(end) || end <= start) return null;
  return {
    name: String(section.name || `chorus ${index + 1}`),
    start,
    end,
    type: section.type || "region"
  };
}

function analysisFrameRanges(wav, sections) {
  if (!sections || sections.length === 0) {
    return [{ startFrame: 0, endFrame: wav.frameCount }];
  }

  const ranges = [];
  for (const section of sections) {
    const start = Math.max(0, Number(section.start));
    const end = Math.min(wav.frameCount / wav.sampleRate, Number(section.end));
    if (!Number.isFinite(start) || !Number.isFinite(end) || end <= start) continue;
    const startFrame = clamp(Math.floor(start * wav.sampleRate), 0, wav.frameCount);
    const endFrame = clamp(Math.ceil(end * wav.sampleRate), 0, wav.frameCount);
    if (endFrame > startFrame) ranges.push({ startFrame, endFrame });
  }

  if (ranges.length === 0) {
    throw new CommandError("No analysis section overlaps the WAV file.");
  }

  return ranges;
}

function parseWav(buffer, file) {
  if (buffer.toString("ascii", 0, 4) !== "RIFF" || buffer.toString("ascii", 8, 12) !== "WAVE") {
    throw new CommandError(`Only WAV stem analysis is supported. Invalid WAV: ${file}`);
  }

  let fmt = null;
  let dataOffset = null;
  let dataSize = null;
  let offset = 12;
  while (offset + 8 <= buffer.length) {
    const id = buffer.toString("ascii", offset, offset + 4);
    const size = buffer.readUInt32LE(offset + 4);
    const start = offset + 8;
    if (id === "fmt ") {
      fmt = {
        audioFormat: buffer.readUInt16LE(start),
        channels: buffer.readUInt16LE(start + 2),
        sampleRate: buffer.readUInt32LE(start + 4),
        blockAlign: buffer.readUInt16LE(start + 12),
        bitsPerSample: buffer.readUInt16LE(start + 14)
      };
    } else if (id === "data") {
      dataOffset = start;
      dataSize = size;
    }
    offset = start + size + (size % 2);
  }

  if (!fmt || dataOffset === null) throw new CommandError(`Invalid WAV structure: ${file}`);
  if (![1, 3].includes(fmt.audioFormat)) throw new CommandError(`Unsupported WAV encoding in ${file}`);
  if (![16, 24, 32].includes(fmt.bitsPerSample)) throw new CommandError(`Unsupported WAV bit depth in ${file}`);
  const frameCount = Math.floor(dataSize / fmt.blockAlign);
  return { ...fmt, buffer, dataOffset, dataSize, frameCount };
}

function readSample(wav, frame, channel) {
  const bytes = wav.bitsPerSample / 8;
  const offset = wav.dataOffset + frame * wav.blockAlign + channel * bytes;
  if (wav.audioFormat === 3 && wav.bitsPerSample === 32) return wav.buffer.readFloatLE(offset);
  if (wav.bitsPerSample === 16) return wav.buffer.readInt16LE(offset) / 32768;
  if (wav.bitsPerSample === 24) {
    let value = wav.buffer[offset] | (wav.buffer[offset + 1] << 8) | (wav.buffer[offset + 2] << 16);
    if (value & 0x800000) value |= 0xff000000;
    return value / 8388608;
  }
  return wav.buffer.readInt32LE(offset) / 2147483648;
}

function widthFromSideToCenter(sideToCenterDb) {
  if (!Number.isFinite(sideToCenterDb)) return 0;
  return clamp((sideToCenterDb + 24) / 15, 0, 1);
}

function emptyWindow() {
  return { total: 0, center: 0, side: 0, frames: 0 };
}

function gainToDb(gain) {
  if (!gain || gain <= 0) return -150;
  return 20 * Math.log10(gain);
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}
