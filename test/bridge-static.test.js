import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { BRIDGE_FILE, REAPER_RUNTIME_FILES } from "../src/constants.js";

const luaRuntimeFiles = [BRIDGE_FILE, ...REAPER_RUNTIME_FILES];

function readLuaFile(file) {
  return fs.readFileSync(path.resolve("reaper", file), "utf8");
}

function readBridge() {
  return luaRuntimeFiles
    .map((file) => `\n-- FILE: ${file}\n${readLuaFile(file)}`)
    .join("\n");
}

function extractFunction(source, name, nextName) {
  const startMatch = new RegExp(`(?:^|\\n)\\s*(?:local\\s+)?function\\s+${name}\\b`).exec(source);
  const start = startMatch?.index ?? -1;
  assert.notEqual(start, -1, `${name} should exist`);
  const nextMatch = new RegExp(`(?:^|\\n)\\s*(?:local\\s+)?function\\s+${nextName}\\b`).exec(
    source.slice(start + 1),
  );
  const end = nextMatch ? start + 1 + nextMatch.index : -1;
  assert.notEqual(end, -1, `${nextName} should follow ${name}`);
  return source.slice(start, end);
}

test("Lua runtime files stay below ReaScript Lua main local limit", () => {
  for (const file of luaRuntimeFiles) {
    const source = readLuaFile(file);
    const topLevelLocals = source.match(/^(?:local function |local [A-Za-z_][A-Za-z0-9_]*\s*=)/gm) ?? [];

    assert.ok(topLevelLocals.length <= 160, `${file} has ${topLevelLocals.length} top-level locals`);
  }
});

test("Lua runtime avoids accidental global function declarations", () => {
  for (const file of luaRuntimeFiles) {
    const source = readLuaFile(file);
    const globals = source.match(/^function\s+[A-Za-z_][A-Za-z0-9_]*\s*\(/gm) ?? [];

    assert.deepEqual(globals, [], `${file} should not declare global functions`);
  }
});

test("Lua rm_* requires are listed in the installer manifest", () => {
  const installedModules = new Set(REAPER_RUNTIME_FILES.map((file) => file.replace(/\.lua$/, "")));

  for (const file of luaRuntimeFiles) {
    const source = readLuaFile(file);
    const requiredModules = [...source.matchAll(/require\("(?<name>rm_[A-Za-z0-9_]+)"\)/g)]
      .map((match) => match.groups.name);

    for (const name of requiredModules) {
      if (name === "rm_config") continue;
      assert.ok(installedModules.has(name), `${file} requires ${name}, but it is not in REAPER_RUNTIME_FILES`);
    }
  }
});

test("bridge clears cached runtime modules before requiring rm_bridge", () => {
  const bridge = readLuaFile(BRIDGE_FILE);
  const clearIndex = bridge.indexOf("package.loaded[module_name] = nil");
  const requireIndex = bridge.indexOf('pcall(require, "rm_bridge")');

  assert.match(bridge, /local runtime_modules = \{/);
  assert.ok(clearIndex > -1, "bridge should clear package.loaded entries");
  assert.ok(clearIndex < requireIndex, "bridge should clear runtime module cache before requiring rm_bridge");
});

test("bridge reports runtime version and vocal-level capabilities", () => {
  const source = readBridge();
  const bridge = readLuaFile("rm_bridge.lua");
  const registry = readLuaFile("rm_registry.lua");
  const ping = extractFunction(source, "command_ping", "command_undo");

  assert.match(registry, /local BRIDGE_VERSION = "vocal-level-measured-macro-micro-2026-05-24"/);
  assert.match(registry, /vocal_level_estimated_points = true/);
  assert.match(registry, /vocal_level_zero_crossing_curve = true/);
  assert.match(registry, /vocal_level_phrase_safe_defaults = true/);
  assert.match(registry, /vocal_level_macro_micro = true/);
  assert.match(registry, /vocal_level_post_level_measurement = true/);
  assert.match(bridge, /bridge_version = registry_module\.version\(\)/);
  assert.match(bridge, /features = registry_module\.features\(\)/);
  assert.match(bridge, /selected_item_count = reaper\.CountSelectedMediaItems\(0\)/);
  assert.match(ping, /bridge_version = M\.version\(\)/);
  assert.match(ping, /features = M\.features\(\)/);
  assert.match(ping, /selected_item_count = reaper\.CountSelectedMediaItems\(0\)/);
});

test("vocal-level macro_micro is the runtime default with V2 safety settings", () => {
  const source = readBridge();
  const settings = extractFunction(source, "vocal_level_settings", "append_vocal_part");

  assert.match(settings, /level_mode = tostring\(command\.levelMode or "macro_micro"\):gsub/);
  assert.match(settings, /max_boost_db = tonumber\(command\.maxBoostDb\) or 8/);
  assert.match(settings, /max_cut_db = tonumber\(command\.maxCutDb\) or 8/);
  assert.match(settings, /macro_gap_s = \(tonumber\(command\.macroGapMs\) or 900\) \/ 1000/);
  assert.match(settings, /macro_min_zone_s = \(tonumber\(command\.macroMinZoneMs\).*1200\) \/ 1000/);
  assert.match(settings, /macro_max_zones = math\.max\(1, math\.floor\(tonumber\(command\.macroMaxZones\) or 8\)\)/);
  assert.match(settings, /macro_deadband_db = tonumber\(command\.macroDeadbandDb\) or 1/);
  assert.match(settings, /macro_max_boost_db = tonumber\(command\.macroMaxBoostDb\) or 8/);
  assert.match(settings, /meso_gap_s = \(tonumber\(command\.mesoGapMs\) or 350\) \/ 1000/);
  assert.match(settings, /meso_min_zone_s = \(tonumber\(command\.mesoMinZoneMs\) or 450\) \/ 1000/);
  assert.match(settings, /meso_max_zones_per_macro = math\.max\(1, math\.floor\(tonumber\(command\.mesoMaxZonesPerMacro\) or 24\)\)/);
  assert.match(settings, /micro_repair = command\.microRepair ~= false/);
  assert.match(settings, /micro_clear_drop_db = tonumber\(command\.microClearDropDb\) or 4/);
  assert.match(settings, /micro_boost_strength = clamp\(tonumber\(command\.microBoostStrength\) or 0\.45, 0, 1\)/);
  assert.match(settings, /micro_cut_strength = clamp\(tonumber\(command\.microCutStrength\) or 0\.55, 0, 1\)/);
  assert.match(settings, /micro_max_boost_db = tonumber\(command\.microMaxBoostDb\) or 2\.5/);
  assert.match(settings, /protected_max_boost_db = tonumber\(command\.protectedMaxBoostDb\) or 0/);
  assert.match(settings, /post_level_report = command\.postLevelReport ~= false/);
  assert.match(settings, /point_density_reject_per_minute = tonumber\(command\.pointDensityRejectPerMinute\) or 100/);
});

test("vocal-level preview does not normalize item or take gain", () => {
  const source = readBridge();
  const body = extractFunction(source, "analyze_item_for_vocal_level", "envelope_point_count");

  assert.match(body, /local normalized_for_analysis = not settings\.preview/);
  assert.match(
    body,
    /if normalized_for_analysis then\s+reaper\.SetMediaItemInfo_Value\(item, "D_VOL", 1\)\s+reaper\.SetMediaItemTakeInfo_Value\(ctx\.take, "D_VOL", ctx\.take_sign\)\s+end/
  );
  assert.match(
    body,
    /if normalized_for_analysis then\s+reaper\.SetMediaItemTakeInfo_Value\(ctx\.take, "D_VOL", ctx\.original_take_gain\)\s+reaper\.SetMediaItemInfo_Value\(item, "D_VOL", ctx\.original_item_gain\)\s+end/
  );
});

test("vocal-level clamps envelope gain after item and take compensation", () => {
  const source = readBridge();
  const limiter = extractFunction(source, "limit_vocal_envelope_gain", "analyze_item_for_vocal_level");
  const analyzer = extractFunction(source, "analyze_item_for_vocal_level", "envelope_point_count");

  assert.match(limiter, /if settings\.max_boost_db and gain_db > settings\.max_boost_db then/);
  assert.match(limiter, /if settings\.max_cut_db and gain_db < -settings\.max_cut_db then/);
  assert.match(limiter, /unresolved_peak = true/);
  assert.match(analyzer, /if envelope\.unresolved_peak then\s+return nil, "peak ceiling requires more cut than max-cut"\s+end/);
  assert.match(analyzer, /limit_vocal_envelope_gain\(range_analysis\.target_take_db - ctx\.original_combined_db, ctx, range_analysis, settings\)/);
});

test("vocal-level macro_micro levels macro zones before local detail", () => {
  const source = readBridge();
  const macro = extractFunction(source, "apply_macro_micro_vocal_leveling", "analyze_item_for_vocal_level");
  const analyzer = extractFunction(source, "analyze_item_for_vocal_level", "envelope_point_count");

  assert.match(macro, /local zones = build_macro_zones\(segments, ctx, settings\)/);
  assert.match(macro, /local meso_zones = build_meso_zones\(zone\.segments or \{\}, settings\)/);
  assert.match(macro, /item_gain_stage_db = vocal_deadband_gain/);
  assert.match(macro, /zone\.macro_gain_db = vocal_deadband_gain/);
  assert.match(macro, /meso_zone\.meso_gain_db = vocal_deadband_gain/);
  assert.match(macro, /local_delta_db = \(meso_zone\.reference_db/);
  assert.match(macro, /settings\.micro_repair/);
  assert.match(macro, /local_delta_db < -math\.max\(settings\.micro_deadband_db/);
  assert.match(macro, /local_delta_db >= \(settings\.micro_clear_drop_db or 4\)/);
  assert.match(macro, /settings\.micro_cut_strength/);
  assert.match(macro, /settings\.micro_boost_strength/);
  assert.match(macro, /macro_micro_segment_is_protected/);
  assert.match(macro, /if protected and requested_gain_db > \(settings\.protected_max_boost_db or 0\) then/);
  assert.match(macro, /detail_gain_db = requested_gain_db - \(zone\.macro_gain_db or 0\)/);
  assert.match(macro, /local safety_limited = false/);
  assert.match(macro, /settings\.protected_max_boost_db/);
  assert.match(macro, /segment\.safety_protected = protected/);
  assert.match(macro, /segment\.safety_limited = safety_limited/);
  assert.match(macro, /report\.safety_protected_parts = report\.safety_protected_parts \+ 1/);
  assert.match(macro, /report\.safety_limited_parts = report\.safety_limited_parts \+ 1/);
  assert.match(macro, /local segment_corrected = \(not safety_limited\) and math\.abs\(effective_detail_gain_db\) > 0\.001/);
  assert.match(macro, /segment\.protected = protected or \(not segment_corrected and \(already_good or correction_stage == "deadband" or correction_stage == "low_not_clear"\)\)/);
  assert.match(macro, /limit_vocal_envelope_gain\(requested_gain_db, ctx/);
  assert.match(analyzer, /elseif settings\.level_mode == "macro_micro" then\s+local macro_report, macro_reason = apply_macro_micro_vocal_leveling\(segments, ctx, settings\)/);
  assert.match(analyzer, /safety_protected_parts = macro_micro_report and macro_micro_report\.safety_protected_parts or 0/);
  assert.match(analyzer, /safety_limited_parts = macro_micro_report and macro_micro_report\.safety_limited_parts or 0/);
  assert.doesNotMatch(macro, /command_gain_stage_items/);
});

test("vocal-level preview cannot create or write take envelopes", () => {
  const source = readBridge();
  const body = extractFunction(source, "command_vocal_level_items", "normalize_words");

  assert.match(
    body,
    /else\s+local env, created_or_error = ensure_take_volume_envelope\(item, take\)[\s\S]+point_count = insert_vocal_level_points\(env, analysis, created_or_error == true or settings\.replace_envelope == true\)[\s\S]+end/
  );
  const previewStart = body.indexOf("if settings.preview then");
  const previewEnd = body.indexOf("else", previewStart);
  const previewBranch = body.slice(previewStart, previewEnd);
  assert.doesNotMatch(previewBranch, /ensure_take_volume_envelope/);
  assert.doesNotMatch(previewBranch, /insert_vocal_level_points/);
  assert.match(body, /if settings\.preview then\s+point_count = #build_vocal_level_points\(analysis\)/);
  assert.match(body, /estimated_points = total_points/);
  assert.match(body, /points = settings\.preview and 0 or total_points/);
  assert.match(body, /envelope_points_written = settings\.preview and 0 or total_points/);
});

test("vocal-level snaps detected parts to zero crossings before curve generation", () => {
  const source = readBridge();
  const body = extractFunction(source, "detect_vocal_parts", "copy_vocal_segment");

  assert.match(body, /parts = snap_vocal_parts_to_zero_crossings\(accessor, sample_rate, channels, parts, item_start, item_end, settings\)/);
  assert.doesNotMatch(body, /settings\.automation_mode ~= "smooth_curve"[\s\S]+snap_vocal_parts_to_zero_crossings/);
});

test("vocal-level preview is dispatcher read-only and cannot rename tracks", () => {
  const source = readBridge();
  const registry = readLuaFile("rm_registry.lua");
  const vocal = readLuaFile("rm_vocal_level.lua");
  const commandBody = extractFunction(source, "command_vocal_level_items", "normalize_words");

  assert.match(registry, /function M\.is_read_only\(registry, command\)/);
  assert.match(vocal, /registry\.command\("vocal_level_items", command_vocal_level_items, \{\s+read_only = function\(command\) return command\.preview == true end\s+\}\)/);
  assert.match(
    commandBody,
    /if not settings\.preview and point_count > 0 and command\.variantLabel and tostring\(command\.variantLabel\) ~= "" then/
  );
});

test("vocal-level skips existing take envelopes unless replace-envelope is explicit", () => {
  const source = readBridge();
  const body = extractFunction(source, "command_vocal_level_items", "normalize_words");

  assert.match(body, /existing_env and envelope_point_count\(existing_env\) > 0 and not settings\.replace_envelope/);
  assert.match(body, /record_skip\(item, "existing take volume envelope"\)/);
  assert.match(body, /created_or_error == true or settings\.replace_envelope == true/);
});

test("vocal-level bridge rejects non-selected raw item filters", () => {
  const source = readBridge();
  const body = extractFunction(source, "command_vocal_level_items", "normalize_words");

  assert.match(body, /local item_filter = command\.itemFilter or \{ type = "selected" \}/);
  assert.match(body, /if item_filter\.type ~= "selected" then\s+error\("vocal-level only supports selected items"\)\s+end/);
  assert.match(body, /local items = collect_items\(item_filter\)/);
});

test("vocal-level report includes macro_micro telemetry and point density", () => {
  const source = readBridge();
  const body = extractFunction(source, "command_vocal_level_items", "normalize_words");

  assert.match(body, /total_macro_zones = total_macro_zones \+ \(analysis\.macro_zone_count or 0\)/);
  assert.match(body, /total_meso_zones = total_meso_zones \+ \(analysis\.meso_zone_count or 0\)/);
  assert.match(body, /total_protected_parts = total_protected_parts \+ \(analysis\.protected_parts or 0\)/);
  assert.match(body, /total_safety_protected_parts = total_safety_protected_parts \+ \(analysis\.safety_protected_parts or 0\)/);
  assert.match(body, /total_safety_limited_parts = total_safety_limited_parts \+ \(analysis\.safety_limited_parts or 0\)/);
  assert.match(body, /total_corrected_parts = total_corrected_parts \+ \(analysis\.corrected_parts or 0\)/);
  assert.match(body, /point_density_rejects = point_density_rejects \+ 1/);
  assert.match(body, /macro_zone_examples\[#macro_zone_examples \+ 1\]/);
  assert.match(body, /macro_zones = total_macro_zones/);
  assert.match(body, /meso_zones = total_meso_zones/);
  assert.match(body, /macro_corrected_zones = total_macro_corrected_zones/);
  assert.match(body, /meso_corrected_zones = total_meso_corrected_zones/);
  assert.match(body, /macro_boost_zones = total_macro_boost_zones/);
  assert.match(body, /macro_cut_zones = total_macro_cut_zones/);
  assert.match(body, /meso_boost_zones = total_meso_boost_zones/);
  assert.match(body, /meso_cut_zones = total_meso_cut_zones/);
  assert.match(body, /protected_parts = total_protected_parts/);
  assert.match(body, /safety_protected_parts = total_safety_protected_parts/);
  assert.match(body, /safety_limited_parts = total_safety_limited_parts/);
  assert.match(body, /corrected_parts = total_corrected_parts/);
  assert.match(body, /micro_boost_parts = total_micro_boost_parts/);
  assert.match(body, /micro_cut_parts = total_micro_cut_parts/);
  assert.match(body, /phase_counts = \{/);
  assert.match(body, /point_density_per_minute = max_point_density_per_minute/);
  assert.match(body, /max_boost_db = settings\.max_boost_db/);
  assert.match(body, /limited_by_max_boost = limited_by_max_boost/);
  assert.match(body, /max_boost_hit_ratio = total_segments > 0 and \(limited_by_max_boost \/ total_segments\) or 0/);
});

test("vocal-level report includes post-level audio balance measurements", () => {
  const source = readBridge();
  const analyzer = extractFunction(source, "analyze_item_for_vocal_level", "envelope_point_count");
  const body = extractFunction(source, "command_vocal_level_items", "normalize_words");
  const measurement = extractFunction(source, "measure_vocal_level_result", "vocal_segment_center");
  const curveSmoothing = extractFunction(source, "smooth_vocal_segments_for_curve", "build_vocal_level_curve_points");

  assert.match(analyzer, /analysis\.post_level_measurement = measure_vocal_level_result\(analysis, settings\)/);
  assert.match(measurement, /take_envelope_segment_gain_db\(env, segment, analysis\.item_length\)/);
  assert.match(measurement, /mode = mode or \(env and "applied_take_envelope" or "estimated_envelope"\)/);
  assert.match(measurement, /before = before_stats/);
  assert.match(measurement, /after = after_stats/);
  assert.match(measurement, /macro_balance = summarize_zone_balance\(macro_groups/);
  assert.match(measurement, /meso_balance = summarize_zone_balance\(meso_groups/);
  assert.match(measurement, /glottal_outliers = glottal_outliers/);
  assert.match(measurement, /if segment\.safety_protected or segment\.protected_reason then/);
  assert.match(measurement, /silence_breath_safety = \{/);
  assert.match(measurement, /local post_level_segments = \{\}/);
  assert.match(measurement, /residual_reference_db = residual_reference_db/);
  assert.match(measurement, /worst_after_segments = ranked_post_level_segments\(post_level_segments, "risk_score_db", 8\)/);
  assert.match(measurement, /largest_residual_deviations = ranked_post_level_segments\(post_level_segments, "absolute_residual_db", 8\)/);
  assert.match(measurement, /high_gain_hits = ranked_post_level_segments\(post_level_segments, "gain_pressure_db", 8, is_high_gain_hit\)/);
  assert.match(curveSmoothing, /if radius > 0 and not segment\.safety_protected then/);
  assert.match(curveSmoothing, /segment\.safety_protected and desired_gain/);
  assert.match(body, /post_level_measurement = \{/);
  assert.match(body, /measure_vocal_level_result\(analysis, settings, env, "applied_take_envelope"\)/);
  assert.match(body, /stdev_improvement_db = post_level_items > 0/);
  assert.match(body, /spread_improvement_db = post_level_items > 0/);
  assert.match(body, /peak_outliers = total_post_peak_outliers/);
  assert.match(body, /glottal_outliers = total_post_glottal_outliers/);
  assert.match(body, /unresolved_peak_outliers = total_post_unresolved_peak_outliers/);
  assert.match(body, /boosted_protected_parts = total_post_boosted_protected_parts/);
  assert.match(body, /boosted_low_energy_parts = total_post_boosted_low_energy_parts/);
  assert.match(body, /append_ranked_post_level_segments\(post_level_worst_after_segments, measurement\.worst_after_segments/);
  assert.match(body, /worst_after_segments = post_level_worst_after_segments/);
  assert.match(body, /largest_residual_deviations = post_level_largest_residual_deviations/);
  assert.match(body, /high_gain_hits = post_level_high_gain_hits/);
  assert.match(body, /post_level_examples/);
});

test("vocal-level applied measurement evaluates the written take envelope", () => {
  const source = readBridge();
  const evaluator = extractFunction(source, "take_envelope_gain_db_at_time", "measure_vocal_level_result");

  assert.match(evaluator, /reaper\.Envelope_Evaluate\(env, time, 0, 0\)/);
  assert.match(evaluator, /reaper\.ScaleFromEnvelopeMode\(reaper\.GetEnvelopeScalingMode\(env\), value\)/);
  assert.match(evaluator, /return gain_to_db\(gain\)/);
});

test("gain-stage remains take-gain based and does not create take envelopes", () => {
  const source = readBridge();
  const gainStage = readLuaFile("rm_gain_stage.lua");
  const body = extractFunction(source, "command_gain_stage_items", "vocal_level_settings");

  assert.match(body, /gain_target = "take"/);
  assert.match(body, /applied = settings\.preview and 0 or processed/);
  assert.doesNotMatch(body, /ensure_take_volume_envelope/);
  assert.doesNotMatch(body, /insert_vocal_level_points/);
  assert.doesNotMatch(gainStage, /GetTakeEnvelopeByName|InsertEnvelopePoint|DeleteEnvelopePointRange|Main_OnCommand\(40693\)/);
});

test("undo command bypasses normal undo wrapping", () => {
  const source = readBridge();
  const undoBody = extractFunction(source, "command_undo", "command_color_tracks");
  const runBody = extractFunction(source, "run_command", "process_file");
  const readOnlyIndex = runBody.indexOf("registry_module.is_read_only(registry, command)");
  const undoBeginIndex = runBody.indexOf("reaper.Undo_BeginBlock2(0)");

  assert.match(undoBody, /reaper\.Undo_DoUndo2\(0\)/);
  assert.match(runBody, /registry_module\.bypasses_undo\(registry, command\)/);
  assert.match(runBody, /reaper\.Undo_BeginBlock2\(0\)/);
  assert.ok(readOnlyIndex > -1, "run_command should check read-only commands");
  assert.ok(readOnlyIndex < undoBeginIndex, "read-only commands should bypass undo wrapping");
});

test("bridge claims queue files into processing before execution", () => {
  const source = readBridge();
  const claimBody = extractFunction(source, "claim_file", "process_file");
  const processBody = extractFunction(source, "process_file", "poll");

  assert.match(source, /processing_dir = state_dir \.\. "\/processing"/);
  assert.match(claimBody, /os\.rename\(queue_path, processing_path\)/);
  assert.ok(
    processBody.indexOf("claim_file(filename)") < processBody.indexOf("pcall(run_command, command)"),
    "queue file should be claimed before run_command executes",
  );
});

test("registry reports the module name when a runtime module is invalid", () => {
  const registry = readLuaFile("rm_registry.lua");

  assert.match(registry, /local module_names = \{/);
  assert.match(registry, /runtime module missing register: /);
  assert.match(registry, /type\(module\.register\) ~= "function"/);
});

test("gain-stage toolbar reports empty item selection clearly", () => {
  const source = readLuaFile("Reaper Manager Gain Stage.lua");

  assert.match(source, /if matched == 0 then/);
  assert.match(source, /No hay items seleccionados para gain staging/);
  assert.match(source, /Select Items/);
});
