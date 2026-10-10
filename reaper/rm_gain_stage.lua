local M = {}
local core = require("rm_core")
local track_name = core.track_name
local collect_tracks = core.collect_tracks
local track_summaries = core.track_summaries
local lower = core.lower
local trim = core.trim
local balance_key_name = core.balance_key_name
local track_index = core.track_index
local find_track_by_exact_name = core.find_track_by_exact_name
local plain_gsub = core.plain_gsub
local set_boolean_action = core.set_boolean_action
local sort_tracks_by_index = core.sort_tracks_by_index
local color_native = core.color_native
local COLORS = core.COLORS
local db_to_gain = core.db_to_gain
local gain_to_db = core.gain_to_db
local collect_items = core.collect_items
local item_summary = core.item_summary
local clamp = core.clamp
local top_mean = core.top_mean
local sorted_number_copy = core.sorted_number_copy
local median = core.median
local try_add_fx = core.try_add_fx

local function gain_stage_settings(command)
  return {
    preview = command.preview == true,
    calibration_db = tonumber(command.calibrationDb) or -18,
    target_vu = tonumber(command.targetVu) or 0,
    peak_ceiling_db = tonumber(command.peakCeilingDb) or -0.3,
    max_boost_db = tonumber(command.maxBoostDb) or 24,
    window_ms = tonumber(command.windowMs) or 300,
    silence_db = tonumber(command.silenceDb) or -60,
    top_window_fraction = (tonumber(command.topWindowPercent) or 5) / 100
  }
end

local function audio_accessor_range(accessor, fallback_start, fallback_end)
  local start_time = fallback_start
  local end_time = fallback_end

  if reaper.GetAudioAccessorStartTime then
    local ok, value = pcall(reaper.GetAudioAccessorStartTime, accessor)
    if ok and type(value) == "number" then start_time = value end
  end

  if reaper.GetAudioAccessorEndTime then
    local ok, value = pcall(reaper.GetAudioAccessorEndTime, accessor)
    if ok and type(value) == "number" then end_time = value end
  end

  if not start_time or not end_time or end_time <= start_time then
    return fallback_start, fallback_end
  end

  return start_time, end_time
end

local function analyze_audio_range_for_gain_stage(accessor, sample_rate, channels, start_time, end_time, settings)
  local total_samples = math.floor((end_time - start_time) * sample_rate)
  if total_samples <= 0 then return nil, "too short to analyze" end

  local window_samples = math.max(1, math.floor(sample_rate * settings.window_ms / 1000))
  local block_samples = math.min(16384, math.max(2048, window_samples))
  local buffer = reaper.new_array(block_samples * channels)
  local useful_windows = {}
  local window_sum = 0
  local window_count = 0
  local peak = 0
  local position = start_time
  local remaining = total_samples
  local read_any = false

  local function flush_window()
    if window_count <= 0 then return end
    local rms = math.sqrt(window_sum / window_count)
    if gain_to_db(rms) >= settings.silence_db then
      useful_windows[#useful_windows + 1] = rms
    end
    window_sum = 0
    window_count = 0
  end

  while remaining > 0 do
    local want = math.min(block_samples, remaining)
    buffer.resize(want * channels)
    buffer.clear()

    local retval = reaper.GetAudioAccessorSamples(accessor, sample_rate, channels, position, want, buffer)
    if retval == -1 then return nil, "audio accessor error" end

    if retval == 1 then
      read_any = true
      for frame = 0, want - 1 do
        local frame_square = 0
        for ch = 1, channels do
          local sample = buffer[frame * channels + ch] or 0
          local abs_sample = math.abs(sample)
          if abs_sample > peak then peak = abs_sample end
          frame_square = frame_square + sample * sample
        end
        window_sum = window_sum + (frame_square / channels)
        window_count = window_count + 1
        if window_count >= window_samples then flush_window() end
      end
    end

    remaining = remaining - want
    position = position + (want / sample_rate)
  end

  flush_window()

  if not read_any then return nil, "no audio returned" end
  if #useful_windows == 0 or peak <= 0 then return nil, "silent item" end

  local representative_rms = top_mean(useful_windows, settings.top_window_fraction)
  if not representative_rms or representative_rms <= 0 then return nil, "silent item" end

  local measured_db = gain_to_db(representative_rms)
  local raw_peak_db = gain_to_db(peak)
  local target_dbfs = settings.calibration_db + settings.target_vu
  local target_take_db = target_dbfs - measured_db
  local peak_limited_db = settings.peak_ceiling_db - raw_peak_db
  local limited_by_peak = false
  local limited_by_max_boost = false

  if target_take_db > peak_limited_db then
    target_take_db = peak_limited_db
    limited_by_peak = true
  end

  if target_take_db > settings.max_boost_db then
    target_take_db = settings.max_boost_db
    limited_by_max_boost = true
  end

  return {
    source_rms_db = measured_db,
    source_peak_db = raw_peak_db,
    target_take_db = target_take_db,
    final_peak_db = raw_peak_db + target_take_db,
    final_vu = measured_db + target_take_db - settings.calibration_db,
    windows = #useful_windows,
    limited_by_peak = limited_by_peak,
    limited_by_max_boost = limited_by_max_boost
  }
end

local function select_sustain_windows(windows, settings)
  local crest_values = {}
  for _, window in ipairs(windows) do
    crest_values[#crest_values + 1] = window.crest_db or 0
  end

  local median_crest = median(crest_values) or 0
  local transient_threshold = median_crest + (settings.transient_crest_db or 6)
  local stable_windows = {}
  local transient_windows = 0

  for _, window in ipairs(windows) do
    if (window.crest_db or 0) > transient_threshold then
      transient_windows = transient_windows + 1
    else
      stable_windows[#stable_windows + 1] = window
    end
  end

  if #stable_windows == 0 then stable_windows = windows end

  table.sort(stable_windows, function(a, b)
    return (a.rms or 0) < (b.rms or 0)
  end)

  local count = #stable_windows
  local low_fraction = clamp(settings.sustain_low_fraction or 0.5, 0, 0.99)
  local high_fraction = clamp(settings.sustain_high_fraction or 0.9, 0.01, 1)
  if high_fraction <= low_fraction then high_fraction = math.min(1, low_fraction + 0.1) end

  local start_index = math.floor(count * low_fraction) + 1
  local end_index = math.floor(count * high_fraction + 0.5)
  start_index = clamp(start_index, 1, count)
  end_index = clamp(end_index, start_index, count)

  local selected = {}
  local sum = 0
  for i = start_index, end_index do
    local window = stable_windows[i]
    selected[#selected + 1] = window
    sum = sum + (window.rms or 0)
  end

  if #selected == 0 then
    for _, window in ipairs(stable_windows) do
      selected[#selected + 1] = window
      sum = sum + (window.rms or 0)
    end
  end

  return {
    rms = #selected > 0 and (sum / #selected) or nil,
    selected_count = #selected,
    transient_windows = transient_windows,
    excluded_windows = math.max(0, #windows - #selected),
    median_crest_db = median_crest,
    transient_threshold_db = transient_threshold
  }
end

local function analyze_audio_range_for_vocal_part(accessor, sample_rate, channels, start_time, end_time, settings)
  if settings.measurement_mode == "gain_stage" then
    local analysis, reason = analyze_audio_range_for_gain_stage(accessor, sample_rate, channels, start_time, end_time, settings)
    if not analysis then return nil, reason end
    analysis.sustain_db = analysis.source_rms_db
    analysis.selected_windows = analysis.windows
    analysis.excluded_windows = 0
    analysis.transient_windows = 0
    analysis.measurement_mode = "gain_stage"
    if settings.max_cut_db and analysis.target_take_db and analysis.target_take_db < -settings.max_cut_db then
      analysis.target_take_db = -settings.max_cut_db
      analysis.final_peak_db = (analysis.source_peak_db or -150) + analysis.target_take_db
      analysis.final_vu = (analysis.source_rms_db or -150) + analysis.target_take_db - settings.calibration_db
      analysis.limited_by_max_cut = true
    end
    return analysis
  end

  local total_samples = math.floor((end_time - start_time) * sample_rate)
  if total_samples <= 0 then return nil, "too short to analyze" end

  local window_samples = math.max(1, math.floor(sample_rate * settings.window_ms / 1000))
  local block_samples = math.min(16384, math.max(2048, window_samples))
  local buffer = reaper.new_array(block_samples * channels)
  local useful_windows = {}
  local window_sum = 0
  local window_count = 0
  local window_peak = 0
  local peak = 0
  local position = start_time
  local remaining = total_samples
  local read_any = false

  local function flush_window()
    if window_count <= 0 then return end
    local rms = math.sqrt(window_sum / window_count)
    local rms_db = gain_to_db(rms)
    if rms_db >= settings.silence_db and window_peak > 0 then
      local peak_db = gain_to_db(window_peak)
      useful_windows[#useful_windows + 1] = {
        rms = rms,
        rms_db = rms_db,
        peak = window_peak,
        peak_db = peak_db,
        crest_db = peak_db - rms_db
      }
    end
    window_sum = 0
    window_count = 0
    window_peak = 0
  end

  while remaining > 0 do
    local want = math.min(block_samples, remaining)
    buffer.resize(want * channels)
    buffer.clear()

    local retval = reaper.GetAudioAccessorSamples(accessor, sample_rate, channels, position, want, buffer)
    if retval == -1 then return nil, "audio accessor error" end

    if retval == 1 then
      read_any = true
      for frame = 0, want - 1 do
        local frame_square = 0
        for ch = 1, channels do
          local sample = buffer[frame * channels + ch] or 0
          local abs_sample = math.abs(sample)
          if abs_sample > peak then peak = abs_sample end
          if abs_sample > window_peak then window_peak = abs_sample end
          frame_square = frame_square + sample * sample
        end
        window_sum = window_sum + (frame_square / channels)
        window_count = window_count + 1
        if window_count >= window_samples then flush_window() end
      end
    end

    remaining = remaining - want
    position = position + (want / sample_rate)
  end

  flush_window()

  if not read_any then return nil, "no audio returned" end
  if #useful_windows == 0 or peak <= 0 then return nil, "silent item" end

  local sustain = select_sustain_windows(useful_windows, settings)
  if not sustain.rms or sustain.rms <= 0 then return nil, "silent item" end

  local sustain_db = gain_to_db(sustain.rms)
  local raw_peak_db = gain_to_db(peak)
  local target_dbfs = settings.calibration_db + settings.target_vu
  local target_take_db = target_dbfs - sustain_db
  local peak_limited_db = settings.peak_ceiling_db - raw_peak_db
  local limited_by_peak = false
  local limited_by_max_boost = false
  local limited_by_max_cut = false

  if target_take_db > peak_limited_db then
    target_take_db = peak_limited_db
    limited_by_peak = true
  end

  if target_take_db > settings.max_boost_db then
    target_take_db = settings.max_boost_db
    limited_by_max_boost = true
  end

  if settings.max_cut_db and target_take_db < -settings.max_cut_db then
    target_take_db = -settings.max_cut_db
    limited_by_max_cut = true
  end

  return {
    source_rms_db = sustain_db,
    sustain_db = sustain_db,
    source_peak_db = raw_peak_db,
    target_take_db = target_take_db,
    final_peak_db = raw_peak_db + target_take_db,
    final_vu = sustain_db + target_take_db - settings.calibration_db,
    windows = #useful_windows,
    selected_windows = sustain.selected_count,
    excluded_windows = sustain.excluded_windows,
    transient_windows = sustain.transient_windows,
    median_crest_db = sustain.median_crest_db,
    transient_threshold_db = sustain.transient_threshold_db,
    measurement_mode = "sustain_robust",
    limited_by_peak = limited_by_peak,
    limited_by_max_boost = limited_by_max_boost,
    limited_by_max_cut = limited_by_max_cut
  }
end

local function item_audio_context(item)
  local original_item_gain = reaper.GetMediaItemInfo_Value(item, "D_VOL")
  if not original_item_gain or original_item_gain <= 0 then return nil, "item volume is -inf" end

  local take = reaper.GetActiveTake(item)
  if not take then return nil, "no active take" end
  if reaper.TakeIsMIDI and reaper.TakeIsMIDI(take) then return nil, "MIDI take" end

  local original_take_gain = reaper.GetMediaItemTakeInfo_Value(take, "D_VOL")
  if not original_take_gain or original_take_gain == 0 then return nil, "take volume is -inf" end

  local source = reaper.GetMediaItemTake_Source(take)
  if not source then return nil, "no media source" end

  local sample_rate = math.floor(reaper.GetMediaSourceSampleRate(source) or 0)
  if sample_rate <= 0 then sample_rate = 48000 end

  local channels = math.floor(reaper.GetMediaSourceNumChannels(source) or 0)
  if channels <= 0 then return nil, "no audio channels" end
  channels = math.min(channels, 8)

  local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

  return {
    item = item,
    take = take,
    sample_rate = sample_rate,
    channels = channels,
    item_start = item_start,
    item_length = item_length,
    item_end = item_start + item_length,
    original_item_gain = original_item_gain,
    original_take_gain = original_take_gain,
    take_sign = original_take_gain < 0 and -1 or 1,
    original_combined_db = gain_to_db(math.abs(original_item_gain * original_take_gain))
  }
end

local function analyze_item_for_gain_stage(item, settings)
  local ctx, context_error = item_audio_context(item)
  if not ctx then return nil, context_error end

  local ok_measure, analysis_or_error, reason_or_nil = pcall(function()
    reaper.SetMediaItemInfo_Value(item, "D_VOL", 1)
    reaper.SetMediaItemTakeInfo_Value(ctx.take, "D_VOL", ctx.take_sign)

    local accessor = reaper.CreateTakeAudioAccessor(ctx.take)
    if not accessor then error("could not create audio accessor") end

    local ok_accessor, result_or_error, skip_reason = pcall(function()
      reaper.AudioAccessorUpdate(accessor)
      local analysis_start, analysis_end = audio_accessor_range(accessor, ctx.item_start, ctx.item_end)
      return analyze_audio_range_for_gain_stage(accessor, ctx.sample_rate, ctx.channels, analysis_start, analysis_end, settings)
    end)

    reaper.DestroyAudioAccessor(accessor)
    if not ok_accessor then error(result_or_error) end
    return result_or_error, skip_reason
  end)

  reaper.SetMediaItemTakeInfo_Value(ctx.take, "D_VOL", ctx.original_take_gain)
  reaper.SetMediaItemInfo_Value(item, "D_VOL", ctx.original_item_gain)
  if not ok_measure then error(analysis_or_error) end
  if not analysis_or_error then return nil, reason_or_nil end

  local analysis = analysis_or_error
  analysis.target_take_gain = ctx.take_sign * db_to_gain(analysis.target_take_db)
  analysis.original_item_db = gain_to_db(ctx.original_item_gain)
  analysis.original_take_db = gain_to_db(math.abs(ctx.original_take_gain))
  analysis.original_combined_db = ctx.original_combined_db
  analysis.applied_db = analysis.target_take_db - ctx.original_combined_db
  return analysis
end

local function command_gain_stage_items(command)
  local settings = gain_stage_settings(command)
  local items = collect_items(command.itemFilter)
  local processed = 0
  local skipped = 0
  local limited_by_peak = 0
  local limited_by_max_boost = 0
  local sum_gain_db = 0
  local min_gain_db = nil
  local max_gain_db = nil
  local warnings = {}
  local examples = {}
  local skip_reasons = {}

  for _, item in ipairs(items) do
    local ok, analysis, reason = pcall(analyze_item_for_gain_stage, item, settings)
    if not ok then
      reason = tostring(analysis)
      analysis = nil
    end

    if not analysis then
      skipped = skipped + 1
      reason = reason or "not analyzed"
      skip_reasons[reason] = (skip_reasons[reason] or 0) + 1
      if #warnings < 12 then
        local summary = item_summary(item)
        warnings[#warnings + 1] = {
          reason = reason,
          track = summary.track,
          item_index = summary.item_index
        }
      end
    else
      processed = processed + 1
      if not settings.preview then
        local take = reaper.GetActiveTake(item)
        reaper.SetMediaItemInfo_Value(item, "D_VOL", 1)
        reaper.SetMediaItemTakeInfo_Value(take, "D_VOL", analysis.target_take_gain)
      end

      local applied_db = analysis.applied_db
      sum_gain_db = sum_gain_db + applied_db
      min_gain_db = min_gain_db and math.min(min_gain_db, applied_db) or applied_db
      max_gain_db = max_gain_db and math.max(max_gain_db, applied_db) or applied_db

      if analysis.limited_by_peak then limited_by_peak = limited_by_peak + 1 end
      if analysis.limited_by_max_boost then limited_by_max_boost = limited_by_max_boost + 1 end

      if #examples < 12 then
        local summary = item_summary(item)
        examples[#examples + 1] = {
          track = summary.track,
          item_index = summary.item_index,
          gain_db = applied_db,
          take_gain_db = analysis.target_take_db,
          final_vu = analysis.final_vu,
          final_peak_db = analysis.final_peak_db,
          limited_by_peak = analysis.limited_by_peak,
          limited_by_max_boost = analysis.limited_by_max_boost
        }
      end
    end
  end

  reaper.UpdateArrange()
  return {
    preview = settings.preview,
    matched = #items,
    processed = processed,
    applied = settings.preview and 0 or processed,
    skipped = skipped,
    limited_by_peak = limited_by_peak,
    limited_by_max_boost = limited_by_max_boost,
    calibration_db = settings.calibration_db,
    target_vu = settings.target_vu,
    peak_ceiling_db = settings.peak_ceiling_db,
    top_window_percent = settings.top_window_fraction * 100,
    gain_target = "take",
    gain_db = {
      min = min_gain_db,
      max = max_gain_db,
      average = processed > 0 and (sum_gain_db / processed) or nil
    },
    skip_reasons = skip_reasons,
    warnings = warnings,
    examples = examples
  }
end

function M.register(registry)
  registry.command("gain_stage_items", command_gain_stage_items)
end

M.audio_accessor_range = audio_accessor_range
M.analyze_audio_range_for_gain_stage = analyze_audio_range_for_gain_stage
M.select_sustain_windows = select_sustain_windows
M.analyze_audio_range_for_vocal_part = analyze_audio_range_for_vocal_part
M.item_audio_context = item_audio_context
M.analyze_item_for_gain_stage = analyze_item_for_gain_stage

return M
