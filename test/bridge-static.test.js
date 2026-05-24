import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";

const bridgePath = path.resolve("reaper", "Reaper Manager Bridge.lua");

function readBridge() {
  return fs.readFileSync(bridgePath, "utf8");
}

function extractFunction(source, name, nextName) {
  const start = source.indexOf(`local function ${name}`);
  assert.notEqual(start, -1, `${name} should exist`);
  const end = source.indexOf(`local function ${nextName}`, start + 1);
  assert.notEqual(end, -1, `${nextName} should follow ${name}`);
  return source.slice(start, end);
}

test("bridge reports runtime version and vocal-level capabilities", () => {
  const source = readBridge();
  const heartbeat = extractFunction(source, "heartbeat", "track_name");
  const ping = extractFunction(source, "command_ping", "command_undo");

  assert.match(source, /local BRIDGE_VERSION = "vocal-level-measured-macro-micro-2026-05-24"/);
  assert.match(source, /vocal_level_estimated_points = true/);
  assert.match(source, /vocal_level_zero_crossing_curve = true/);
  assert.match(source, /vocal_level_phrase_safe_defaults = true/);
  assert.match(source, /vocal_level_macro_micro = true/);
  assert.match(source, /vocal_level_post_level_measurement = true/);
  assert.match(heartbeat, /bridge_version = BRIDGE_VERSION/);
  assert.match(heartbeat, /features = bridge_features\(\)/);
  assert.match(ping, /bridge_version = BRIDGE_VERSION/);
  assert.match(ping, /features = bridge_features\(\)/);
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
  assert.match(macro, /if protected and detail_gain_db > \(settings\.protected_max_boost_db or 0\) then/);
  assert.match(macro, /settings\.protected_max_boost_db/);
  assert.match(macro, /local segment_corrected = math\.abs\(effective_detail_gain_db\) > 0\.001/);
  assert.match(macro, /segment\.protected = not segment_corrected/);
  assert.match(macro, /limit_vocal_envelope_gain\(requested_gain_db, ctx/);
  assert.match(analyzer, /elseif settings\.level_mode == "macro_micro" then\s+local macro_report, macro_reason = apply_macro_micro_vocal_leveling\(segments, ctx, settings\)/);
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
  const readOnly = extractFunction(source, "is_read_only_command", "run_command");
  const commandBody = extractFunction(source, "command_vocal_level_items", "normalize_words");

  assert.match(readOnly, /command\.type == "vocal_level_items" and command\.preview == true/);
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

  assert.match(analyzer, /analysis\.post_level_measurement = measure_vocal_level_result\(analysis, settings\)/);
  assert.match(measurement, /take_envelope_segment_gain_db\(env, segment, analysis\.item_length\)/);
  assert.match(measurement, /mode = mode or \(env and "applied_take_envelope" or "estimated_envelope"\)/);
  assert.match(measurement, /before = before_stats/);
  assert.match(measurement, /after = after_stats/);
  assert.match(measurement, /macro_balance = summarize_zone_balance\(macro_groups/);
  assert.match(measurement, /meso_balance = summarize_zone_balance\(meso_groups/);
  assert.match(measurement, /glottal_outliers = glottal_outliers/);
  assert.match(measurement, /silence_breath_safety = \{/);
  assert.match(body, /post_level_measurement = \{/);
  assert.match(body, /measure_vocal_level_result\(analysis, settings, env, "applied_take_envelope"\)/);
  assert.match(body, /stdev_improvement_db = post_level_items > 0/);
  assert.match(body, /peak_outliers = total_post_peak_outliers/);
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
  const body = extractFunction(source, "command_gain_stage_items", "vocal_level_settings");

  assert.match(body, /gain_target = "take"/);
  assert.match(body, /applied = settings\.preview and 0 or processed/);
  assert.doesNotMatch(body, /ensure_take_volume_envelope/);
  assert.doesNotMatch(body, /insert_vocal_level_points/);
});

test("undo command bypasses normal undo wrapping", () => {
  const source = readBridge();
  const undoBody = extractFunction(source, "command_undo", "command_color_tracks");
  const runBody = extractFunction(source, "run_command", "process_file");

  assert.match(undoBody, /reaper\.Undo_DoUndo2\(0\)/);
  assert.match(runBody, /if command\.type == "undo" then\s+return command_undo\(command\)\s+end/);
});
