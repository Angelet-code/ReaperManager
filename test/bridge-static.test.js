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

test("vocal-level preview cannot create or write take envelopes", () => {
  const source = readBridge();
  const body = extractFunction(source, "command_vocal_level_items", "normalize_words");

  assert.match(
    body,
    /if not settings\.preview then\s+local env, created_or_error = ensure_take_volume_envelope\(item, take\)[\s\S]+point_count = insert_vocal_level_points\(env, analysis, created_or_error == true or settings\.replace_envelope == true\)[\s\S]+end/
  );
  assert.doesNotMatch(body, /if settings\.preview[\s\S]+ensure_take_volume_envelope/);
  assert.doesNotMatch(body, /if settings\.preview[\s\S]+insert_vocal_level_points/);
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

test("gain-stage remains take-gain based and does not create take envelopes", () => {
  const source = readBridge();
  const body = extractFunction(source, "command_gain_stage_items", "vocal_level_settings");

  assert.match(body, /gain_target = "take"/);
  assert.match(body, /applied = settings\.preview and 0 or processed/);
  assert.doesNotMatch(body, /ensure_take_volume_envelope/);
  assert.doesNotMatch(body, /insert_vocal_level_points/);
});
