import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import {
  buildAdjustVolumeCommand,
  buildAutoBalanceCommand,
  buildColorTracksCommand,
  buildCopyBalanceCommand,
  buildCreateReturnsCommand,
  buildDeleteTracksCommand,
  buildDetectArrangementCommand,
  buildFolderCommand,
  buildFxBypassCommand,
  buildGainStageCommand,
  buildInspectProjectCommand,
  buildItemVolumeCommand,
  buildPanCommand,
  buildRemoveFxCommand,
  buildRockTemplateCommand,
  buildRouteToBusCommand,
  buildSendVolumeCommand,
  buildSelectItemsCommand,
  buildSelectTracksCommand,
  buildTrackStateCommand,
  buildVocalLevelCommand,
  parseColor,
  parsePan
} from "../src/commands.js";
import { parseNatural } from "../src/natural.js";
import { resolvePlugin } from "../src/plugin-cache.js";
import { analyzeWavFile, buildHierarchy, mapSectionsToReferenceRanges, resolveChorusSections } from "../src/reference-stems.js";

const pluginEntries = [
  {
    name: "RVerb Stereo (Waves)",
    type: "VST3",
    fxName: "VST3:RVerb Stereo (Waves)"
  },
  {
    name: "RVerb Mono/Stereo (Waves)",
    type: "VST3",
    fxName: "VST3:RVerb Mono/Stereo (Waves)"
  }
];

test("parseColor accepts Spanish color names", () => {
  assert.deepEqual(parseColor("rojo"), { r: 255, g: 0, b: 0 });
});

test("buildColorTracksCommand creates a contains filter", () => {
  const command = buildColorTracksCommand({ contains: "CLICK", color: "red" });
  assert.equal(command.type, "color_tracks");
  assert.equal(command.filter.value, "CLICK");
  assert.deepEqual(command.color, { r: 255, g: 0, b: 0 });
});

test("buildColorTracksCommand can target all tracks", () => {
  const command = buildColorTracksCommand({ all: true, color: "azul" });
  assert.equal(command.type, "color_tracks");
  assert.deepEqual(command.filter, { type: "all" });
  assert.deepEqual(command.color, { r: 40, g: 105, b: 255 });
});

test("resolvePlugin prefers VST3 stereo RVerb", () => {
  const plugin = resolvePlugin("RVerb", { entries: pluginEntries });
  assert.equal(plugin.fxName, "VST3:RVerb Stereo (Waves)");
});

test("buildRemoveFxCommand can target all tracks", () => {
  const command = buildRemoveFxCommand({ all: true });
  assert.equal(command.type, "remove_fx_from_tracks");
  assert.deepEqual(command.filter, { type: "all" });
});

test("buildDeleteTracksCommand can target selected tracks", () => {
  const command = buildDeleteTracksCommand({ selected: true });
  assert.equal(command.type, "delete_tracks");
  assert.deepEqual(command.filter, { type: "selected" });
});

test("buildSelectTracksCommand replaces selection by default", () => {
  const command = buildSelectTracksCommand({ contains: "FLAUTA" });
  assert.equal(command.type, "select_tracks");
  assert.deepEqual(command.filter, { type: "name_contains", value: "FLAUTA", caseSensitive: false });
  assert.equal(command.mode, "replace");
});

test("buildSelectTracksCommand supports add mode", () => {
  const command = buildSelectTracksCommand({ all: true, add: true });
  assert.equal(command.type, "select_tracks");
  assert.deepEqual(command.filter, { type: "all" });
  assert.equal(command.mode, "add");
});

test("buildAdjustVolumeCommand supports relative dB changes", () => {
  const command = buildAdjustVolumeCommand({ all: true, db: "-3" });
  assert.equal(command.type, "adjust_track_volume_db");
  assert.deepEqual(command.filter, { type: "all" });
  assert.equal(command.db, -3);
});

test("parsePan accepts musical pan values", () => {
  assert.equal(parsePan("L50"), -0.5);
  assert.equal(parsePan("R25"), 0.25);
  assert.equal(parsePan("center"), 0);
});

test("buildPanCommand targets selected tracks", () => {
  const command = buildPanCommand({ selected: true, pan: "L35" });
  assert.equal(command.type, "set_track_pan");
  assert.deepEqual(command.filter, { type: "selected" });
  assert.equal(command.pan, -0.35);
});

test("buildCopyBalanceCommand copies volume and pan between buses", () => {
  const command = buildCopyBalanceCommand({ from: "DRUMS 2", to: "DRUMS SOFT" });
  assert.equal(command.type, "copy_track_balance");
  assert.equal(command.sourceBus, "DRUMS 2");
  assert.equal(command.targetBus, "DRUMS SOFT");
  assert.equal(command.includeVolume, true);
  assert.equal(command.includePan, true);
  assert.equal(command.includeBus, true);
});

test("buildSendVolumeCommand can filter by destination", () => {
  const command = buildSendVolumeCommand({ selected: true, dest: "Plate", db: "2" });
  assert.equal(command.type, "adjust_send_volume_db");
  assert.equal(command.destinationContains, "Plate");
  assert.equal(command.db, 2);
});

test("buildItemVolumeCommand uses selected items", () => {
  const command = buildItemVolumeCommand({ selected: true, db: "-3" });
  assert.equal(command.type, "adjust_item_volume_db");
  assert.deepEqual(command.itemFilter, { type: "selected" });
});

test("buildGainStageCommand targets all items with defaults", () => {
  const command = buildGainStageCommand({ "all-items": true });
  assert.equal(command.type, "gain_stage_items");
  assert.deepEqual(command.itemFilter, { type: "all" });
  assert.equal(command.preview, false);
  assert.equal(command.calibrationDb, -18);
  assert.equal(command.targetVu, 0);
  assert.equal(command.peakCeilingDb, -0.3);
  assert.equal(command.maxBoostDb, 24);
  assert.equal(command.windowMs, 300);
  assert.equal(command.silenceDb, -60);
  assert.equal(command.topWindowPercent, 5);
});

test("buildGainStageCommand can target selected tracks in preview", () => {
  const command = buildGainStageCommand({ "selected-tracks": true, preview: true, "peak-ceiling": "-1" });
  assert.equal(command.type, "gain_stage_items");
  assert.deepEqual(command.itemFilter, { type: "tracks", trackFilter: { type: "selected" } });
  assert.equal(command.preview, true);
  assert.equal(command.peakCeilingDb, -1);
});

test("buildVocalLevelCommand requires selected items", () => {
  assert.throws(
    () => buildVocalLevelCommand({}),
    /Use --selected-items/
  );
});

test("buildVocalLevelCommand rejects broad targets even when requested", () => {
  assert.throws(
    () => buildVocalLevelCommand({ "all-items": true }),
    /Use --selected-items/
  );
});

test("buildVocalLevelCommand targets selected items with safe defaults", () => {
  const command = buildVocalLevelCommand({ "selected-items": true });
  assert.equal(command.type, "vocal_level_items");
  assert.deepEqual(command.itemFilter, { type: "selected" });
  assert.equal(command.preview, false);
  assert.equal(command.leaveFirstSelected, false);
  assert.equal(command.selectedItemIndex, undefined);
  assert.equal(command.variantLabel, undefined);
  assert.equal(command.calibrationDb, -18);
  assert.equal(command.targetVu, 0);
  assert.equal(command.peakCeilingDb, -0.3);
  assert.equal(command.maxBoostDb, 12);
  assert.equal(command.maxCutDb, 12);
  assert.equal(command.replaceEnvelope, false);
  assert.equal(command.windowMs, 120);
  assert.equal(command.silenceDb, -60);
  assert.equal(command.topWindowPercent, 5);
  assert.equal(command.measurementMode, "sustain_robust");
  assert.equal(command.levelMode, "absolute");
  assert.equal(command.automationMode, "smooth_curve");
  assert.equal(command.referencePercentile, 65);
  assert.equal(command.stabilizeBoostDb, 3.2);
  assert.equal(command.stabilizeCutDb, 7);
  assert.equal(command.gainDeadbandDb, 1.5);
  assert.equal(command.preserveLoudness, 1);
  assert.equal(command.sustainLowPercent, 50);
  assert.equal(command.sustainHighPercent, 90);
  assert.equal(command.transientCrestDb, 6);
  assert.equal(command.detectWindowMs, 15);
  assert.equal(command.detectSilenceDb, -45);
  assert.equal(command.detectRangeDb, 35);
  assert.equal(command.partMergeGapMs, 90);
  assert.equal(command.minPartMs, 80);
  assert.equal(command.syllableSplitDb, 8);
  assert.equal(command.syllableSplitHoldMs, 45);
  assert.equal(command.minGainChangeDb, 3);
  assert.equal(command.gainMergeGapMs, 0);
  assert.equal(command.zeroCrossing, true);
  assert.equal(command.zeroCrossingSearchMs, 12);
  assert.equal(command.curveSmoothMs, 120);
  assert.equal(command.curveToleranceDb, 1.5);
  assert.equal(command.curveMinPointGapMs, 90);
  assert.equal(command.curveDetail, 0.75);
  assert.equal(command.curveEdgeRampMs, 45);
  assert.equal(command.paddingMs, 8);
  assert.equal(command.rampMs, 0);
});

test("buildVocalLevelCommand supports preview and safety overrides", () => {
  const command = buildVocalLevelCommand({
    "selected-items": true,
    preview: true,
    "leave-first-selected": true,
    "selected-item-index": "3",
    "variant-label": "ROBUST_REL",
    "max-boost": "12",
    "max-cut-db": "9",
    "replace-envelope": true,
    "peak-ceiling": "-1",
    "measurement-mode": "sustain-robust",
    "level-mode": "absolute",
    "automation-mode": "steps",
    "reference-percentile": "70",
    "stabilize-boost-db": "5",
    "stabilize-cut-db": "8",
    "gain-deadband-db": "1",
    "preserve-loudness": "0.5",
    "sustain-low-percent": "40",
    "sustain-high-percent": "85",
    "transient-crest-db": "8",
    "detect-window-ms": "25",
    "part-merge-gap-ms": "700",
    "min-part-ms": "500",
    "syllable-split-db": "5",
    "syllable-split-hold-ms": "40",
    "min-gain-change-db": "2",
    "gain-merge-gap-ms": "40",
    "zero-crossing": "false",
    "zero-crossing-search-ms": "20",
    "curve-smooth-ms": "250",
    "curve-tolerance-db": "2",
    "curve-min-point-gap-ms": "160",
    "curve-detail": "0.5",
    "curve-edge-ramp-ms": "50",
    "padding-ms": "20"
  });
  assert.equal(command.preview, true);
  assert.equal(command.leaveFirstSelected, true);
  assert.equal(command.selectedItemIndex, 3);
  assert.equal(command.variantLabel, "ROBUST_REL");
  assert.equal(command.maxBoostDb, 12);
  assert.equal(command.maxCutDb, 9);
  assert.equal(command.replaceEnvelope, true);
  assert.equal(command.peakCeilingDb, -1);
  assert.equal(command.measurementMode, "sustain_robust");
  assert.equal(command.levelMode, "absolute");
  assert.equal(command.automationMode, "steps");
  assert.equal(command.referencePercentile, 70);
  assert.equal(command.stabilizeBoostDb, 5);
  assert.equal(command.stabilizeCutDb, 8);
  assert.equal(command.gainDeadbandDb, 1);
  assert.equal(command.preserveLoudness, 0.5);
  assert.equal(command.sustainLowPercent, 40);
  assert.equal(command.sustainHighPercent, 85);
  assert.equal(command.transientCrestDb, 8);
  assert.equal(command.detectWindowMs, 25);
  assert.equal(command.partMergeGapMs, 700);
  assert.equal(command.minPartMs, 500);
  assert.equal(command.syllableSplitDb, 5);
  assert.equal(command.syllableSplitHoldMs, 40);
  assert.equal(command.minGainChangeDb, 2);
  assert.equal(command.gainMergeGapMs, 40);
  assert.equal(command.zeroCrossing, false);
  assert.equal(command.zeroCrossingSearchMs, 20);
  assert.equal(command.curveSmoothMs, 250);
  assert.equal(command.curveToleranceDb, 2);
  assert.equal(command.curveMinPointGapMs, 160);
  assert.equal(command.curveDetail, 0.5);
  assert.equal(command.curveEdgeRampMs, 50);
  assert.equal(command.paddingMs, 20);
});

test("buildVocalLevelCommand accepts legacy aliases for advanced options", () => {
  const command = buildVocalLevelCommand({
    "selected-items": true,
    "max-cut": "7",
    "gate-window-ms": "30",
    "gate-range-db": "32",
    "min-phrase-ms": "450"
  });
  assert.equal(command.maxCutDb, 7);
  assert.equal(command.detectWindowMs, 30);
  assert.equal(command.detectRangeDb, 32);
  assert.equal(command.minPartMs, 450);
});

test("buildVocalLevelCommand rejects invalid sustain percentile band", () => {
  assert.throws(
    () => buildVocalLevelCommand({ "selected-items": true, "sustain-low-percent": "90", "sustain-high-percent": "50" }),
    /Sustain high percent/
  );
});

test("buildVocalLevelCommand rejects unsafe numeric ranges", () => {
  assert.throws(
    () => buildVocalLevelCommand({ "selected-items": true, "curve-detail": "1.2" }),
    /Curve detail/
  );
  assert.throws(
    () => buildVocalLevelCommand({ "selected-items": true, "preserve-loudness": "1.5" }),
    /Preserve loudness/
  );
  assert.throws(
    () => buildVocalLevelCommand({ "selected-items": true, "reference-percentile": "0" }),
    /Reference percentile/
  );
  assert.throws(
    () => buildVocalLevelCommand({ "selected-items": true, "reference-percentile": "100" }),
    /Reference percentile/
  );
});

test("buildVocalLevelCommand keeps legacy relative mode explicit", () => {
  const command = buildVocalLevelCommand({
    "selected-items": true,
    "level-mode": "relative",
    "reference-percentile": "60",
    "preserve-loudness": "0.25"
  });
  assert.equal(command.levelMode, "relative");
  assert.equal(command.referencePercentile, 60);
  assert.equal(command.preserveLoudness, 0.25);
});

test("buildSelectItemsCommand can select items from selected tracks", () => {
  const command = buildSelectItemsCommand({ "selected-tracks": true });
  assert.equal(command.type, "select_items");
  assert.deepEqual(command.itemFilter, { type: "tracks", trackFilter: { type: "selected" } });
  assert.equal(command.mode, "replace");
});

test("inspect-project command is read-only", () => {
  assert.deepEqual(buildInspectProjectCommand(), { type: "inspect_project" });
});

test("detect-arrangement defaults to deterministic marker creation", () => {
  const command = buildDetectArrangementCommand({ "units-per-bar": "2" });
  assert.equal(command.type, "detect_arrangement");
  assert.equal(command.preview, false);
  assert.equal(command.applyMarkers, true);
  assert.equal(command.clearExisting, true);
  assert.equal(command.detectBreaks, true);
  assert.equal(command.unitsPerBar, 2);
});

test("detect-arrangement preview does not create markers", () => {
  const command = buildDetectArrangementCommand({ preview: true, "no-clear": true, "sample-stride": "256" });
  assert.equal(command.type, "detect_arrangement");
  assert.equal(command.preview, true);
  assert.equal(command.applyMarkers, false);
  assert.equal(command.clearExisting, false);
  assert.equal(command.sampleStride, 256);
});

test("auto-balance command supports pop-rock preview", () => {
  const referenceHierarchy = { families: { vocals: { levelDb: 0 } } };
  const balanceSections = [{ name: "CHORUS", start: 10, end: 30 }];
  const command = buildAutoBalanceCommand({ genre: "pop rock", preview: true, referenceHierarchy, balanceSections, "max-delta": "6" });
  assert.equal(command.type, "auto_balance_mix");
  assert.equal(command.genre, "pop-rock");
  assert.equal(command.preview, true);
  assert.equal(command.maxDeltaDb, 6);
  assert.equal(command.referenceHierarchy, referenceHierarchy);
  assert.equal(command.balanceSections, balanceSections);
});

test("auto-balance rejects unsupported genres", () => {
  assert.throws(
    () => buildAutoBalanceCommand({ genre: "jazz" }),
    /Unsupported auto-balance genre/
  );
});

test("reference hierarchy uses vocals as family anchor", () => {
  const hierarchy = buildHierarchy({
    sourceFile: "ref.wav",
    sourceHash: "abc",
    cacheDir: "cache",
    stems: {},
    metrics: {
      vocals: { rmsDb: -12, peakDb: -2, centerDb: -12, sideDb: -24, activeSeconds: 10 },
      drums: { rmsDb: -15, peakDb: -1, centerDb: -15, sideDb: -18, activeSeconds: 10 },
      bass: { rmsDb: -18, peakDb: -3, centerDb: -18, sideDb: -80, activeSeconds: 10 },
      piano: { rmsDb: -120, peakDb: -120, centerDb: -120, sideDb: -120, activeSeconds: 0, silent: true },
      other: { rmsDb: -20, peakDb: -4, centerDb: -21, sideDb: -12, activeSeconds: 10 }
    }
  });
  assert.equal(hierarchy.anchorFamily, "vocals");
  assert.equal(hierarchy.families.vocals.levelDb, 0);
  assert.equal(hierarchy.families.drums.levelDb, -3);
  assert.equal(hierarchy.families.bass.levelDb, -6);
  assert.equal(hierarchy.families.piano.levelDb, -108);
  assert.equal(hierarchy.families.other.levelDb, -8);
  assert.equal(hierarchy.families.other.width, 1);
});

test("reference chorus sections map onto the REF item source timeline", () => {
  const sections = resolveChorusSections({
    sections: {
      chorus: [
        { name: "ESTRIBILLO 1", start: 40, end: 72 },
        { name: "CHORUS 2", start: 120, end: 150 }
      ]
    }
  });
  const ranges = mapSectionsToReferenceRanges(sections, {
    position: 10,
    length: 200,
    startOffset: 1.5,
    playrate: 1
  });
  assert.equal(ranges.length, 2);
  assert.equal(ranges[0].start, 31.5);
  assert.equal(ranges[0].end, 63.5);
});

test("reference chorus detection fails without an identified section", () => {
  assert.throws(
    () => resolveChorusSections({ sections: { chorus: [] } }),
    /No CHORUS\/ESTRIBILLO/
  );
});

test("analyzeWavFile measures simple stereo WAV width", () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "rm-wav-"));
  const file = path.join(dir, "wide.wav");
  writeTestWav(file);
  const metrics = analyzeWavFile(file, { sampleStride: 1, topWindowPercent: 100 });
  assert.equal(metrics.channels, 2);
  assert.ok(metrics.rmsDb > -12 && metrics.rmsDb < -6);
  assert.ok(metrics.sideDb > -12);
});

test("analyzeWavFile can restrict analysis to chorus sections", () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), "rm-wav-section-"));
  const file = path.join(dir, "section.wav");
  writeTwoLevelTestWav(file);
  const full = analyzeWavFile(file, { sampleStride: 1, topWindowPercent: 100 });
  const chorus = analyzeWavFile(file, {
    sampleStride: 1,
    topWindowPercent: 100,
    sections: [{ start: 0.5, end: 1 }]
  });
  assert.ok(chorus.rmsDb > full.rmsDb + 3);
});

test("buildTrackStateCommand maps state changes", () => {
  const command = buildTrackStateCommand({ contains: "VOX", mute: "on", solo: "toggle" });
  assert.equal(command.type, "set_track_state");
  assert.deepEqual(command.changes, { mute: "on", solo: "toggle" });
});

test("folder, route and fx bypass commands build structured payloads", () => {
  assert.equal(buildFolderCommand({ selected: true, name: "DRUMS" }).type, "create_folder_for_tracks");
  assert.equal(buildRouteToBusCommand({ selected: true, bus: "DRUMS" }).type, "route_tracks_to_bus");
  assert.equal(buildFxBypassCommand({ selected: true, fx: "RVerb", state: "toggle" }).type, "set_fx_bypass");
});

test("buildRockTemplateCommand clears by default", () => {
  const command = buildRockTemplateCommand();
  assert.equal(command.type, "create_rock_template");
  assert.equal(command.clearExisting, true);
});

function writeTestWav(file) {
  const sampleRate = 48000;
  const frames = 4800;
  const channels = 2;
  const bitsPerSample = 16;
  const blockAlign = channels * (bitsPerSample / 8);
  const dataSize = frames * blockAlign;
  const buffer = Buffer.alloc(44 + dataSize);
  buffer.write("RIFF", 0, "ascii");
  buffer.writeUInt32LE(36 + dataSize, 4);
  buffer.write("WAVE", 8, "ascii");
  buffer.write("fmt ", 12, "ascii");
  buffer.writeUInt32LE(16, 16);
  buffer.writeUInt16LE(1, 20);
  buffer.writeUInt16LE(channels, 22);
  buffer.writeUInt32LE(sampleRate, 24);
  buffer.writeUInt32LE(sampleRate * blockAlign, 28);
  buffer.writeUInt16LE(blockAlign, 32);
  buffer.writeUInt16LE(bitsPerSample, 34);
  buffer.write("data", 36, "ascii");
  buffer.writeUInt32LE(dataSize, 40);

  for (let frame = 0; frame < frames; frame += 1) {
    const left = Math.round(Math.sin((frame / sampleRate) * Math.PI * 2 * 440) * 18000);
    const right = -left;
    const offset = 44 + frame * blockAlign;
    buffer.writeInt16LE(left, offset);
    buffer.writeInt16LE(right, offset + 2);
  }
  fs.writeFileSync(file, buffer);
}

function writeTwoLevelTestWav(file) {
  const sampleRate = 48000;
  const frames = 48000;
  const channels = 2;
  const bitsPerSample = 16;
  const blockAlign = channels * (bitsPerSample / 8);
  const dataSize = frames * blockAlign;
  const buffer = Buffer.alloc(44 + dataSize);
  buffer.write("RIFF", 0, "ascii");
  buffer.writeUInt32LE(36 + dataSize, 4);
  buffer.write("WAVE", 8, "ascii");
  buffer.write("fmt ", 12, "ascii");
  buffer.writeUInt32LE(16, 16);
  buffer.writeUInt16LE(1, 20);
  buffer.writeUInt16LE(channels, 22);
  buffer.writeUInt32LE(sampleRate, 24);
  buffer.writeUInt32LE(sampleRate * blockAlign, 28);
  buffer.writeUInt16LE(blockAlign, 32);
  buffer.writeUInt16LE(bitsPerSample, 34);
  buffer.write("data", 36, "ascii");
  buffer.writeUInt32LE(dataSize, 40);

  for (let frame = 0; frame < frames; frame += 1) {
    const amp = frame < frames / 2 ? 300 : 18000;
    const sample = Math.round(Math.sin((frame / sampleRate) * Math.PI * 2 * 220) * amp);
    const offset = 44 + frame * blockAlign;
    buffer.writeInt16LE(sample, offset);
    buffer.writeInt16LE(sample, offset + 2);
  }
  fs.writeFileSync(file, buffer);
}

test("create returns requires a send source", () => {
  assert.throws(
    () => buildCreateReturnsCommand({ count: 2, fx: "RVerb", pluginEntries }),
    /No send source/
  );
});

test("natural color command parses the CLICK example", () => {
  const command = parseNatural("Coloreame todas las pistas que contengan la palabra CLICK de rojo");
  assert.equal(command.type, "color_tracks");
  assert.equal(command.filter.value, "CLICK");
  assert.deepEqual(command.color, { r: 255, g: 0, b: 0 });
});

test("natural select command parses tracks by instrument name", () => {
  const command = parseNatural("Selecciona todas las pistas de flauta");
  assert.equal(command.type, "select_tracks");
  assert.equal(command.filter.value, "flauta");
  assert.equal(command.mode, "replace");
});

test("natural deselect command parses remove mode", () => {
  const command = parseNatural("Deselecciona todas las pistas");
  assert.equal(command.type, "select_tracks");
  assert.deepEqual(command.filter, { type: "all" });
  assert.equal(command.mode, "remove");
});

test("natural gain stage command parses whole project", () => {
  const command = parseNatural("Haz etapa de ganancia a todo el proyecto");
  assert.equal(command.type, "gain_stage_items");
  assert.deepEqual(command.itemFilter, { type: "all" });
});

test("natural gain stage command parses selected items", () => {
  const command = parseNatural("Ajusta la ganancia de los items seleccionados");
  assert.equal(command.type, "gain_stage_items");
  assert.deepEqual(command.itemFilter, { type: "selected" });
});

test("natural gain stage command parses tracks by name", () => {
  const command = parseNatural("Etapa de ganancia a las pistas de flauta");
  assert.equal(command.type, "gain_stage_items");
  assert.equal(command.itemFilter.trackFilter.value, "flauta");
});

test("natural vocal level command parses selected vocal items", () => {
  const command = parseNatural("Nivela la voz en los items seleccionados");
  assert.equal(command.type, "vocal_level_items");
  assert.deepEqual(command.itemFilter, { type: "selected" });
  assert.equal(command.preview, false);
});

test("natural vocal level command parses selected voice shorthand", () => {
  const command = parseNatural("nivela la voz seleccionada");
  assert.equal(command.type, "vocal_level_items");
  assert.deepEqual(command.itemFilter, { type: "selected" });
});

test("natural vocal level command can request preview", () => {
  const command = parseNatural("Previsualiza vocal level en los clips seleccionados");
  assert.equal(command.type, "vocal_level_items");
  assert.equal(command.preview, true);
});

test("natural returns command parses selected source", () => {
  const command = parseNatural("Creame dos envios de reverb con una RVerb desde las seleccionadas", {
    pluginEntries
  });
  assert.equal(command.type, "create_fx_returns");
  assert.equal(command.count, 2);
  assert.equal(command.fx.fxName, "VST3:RVerb Stereo (Waves)");
  assert.equal(command.sendSource, "selected");
});

test("natural volume command parses the both tracks example", () => {
  const command = parseNatural("baja 3db el volumen de ambas pistas");
  assert.equal(command.type, "adjust_track_volume_db");
  assert.deepEqual(command.filter, { type: "all" });
  assert.equal(command.db, -3);
});

test("natural volume command parses simple instrument shorthand", () => {
  const command = parseNatural("baja guitarras 1 dB");
  assert.equal(command.type, "adjust_track_volume_db");
  assert.equal(command.filter.value, "GTR");
  assert.equal(command.db, -1);
});

test("natural create tracks command parses simple requests", () => {
  const command = parseNatural("Genera 2 pistas");
  assert.equal(command.type, "create_tracks");
  assert.equal(command.count, 2);
  assert.equal(command.name, "Track");
});

test("natural create tracks command can infer an instrument name", () => {
  const command = parseNatural("Crea una pista de guitarra");
  assert.equal(command.type, "create_tracks");
  assert.equal(command.count, 1);
  assert.equal(command.name, "GTR");
});

test("natural rock template command parses destructive request", () => {
  const command = parseNatural("Borra todas las pistas y crea una estructura de pistas para un grupo de rock estándar");
  assert.equal(command.type, "create_rock_template");
  assert.equal(command.clearExisting, true);
});
