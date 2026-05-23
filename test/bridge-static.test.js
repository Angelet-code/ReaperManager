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
