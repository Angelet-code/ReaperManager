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

local audio = require("rm_gain_stage")
local audio_accessor_range = audio.audio_accessor_range
local analyze_audio_range_for_vocal_part = audio.analyze_audio_range_for_vocal_part
local item_audio_context = audio.item_audio_context

local function vocal_level_settings(command)
  return {
    preview = command.preview == true,
    calibration_db = tonumber(command.calibrationDb) or -18,
    target_vu = tonumber(command.targetVu) or 0,
    peak_ceiling_db = tonumber(command.peakCeilingDb) or -0.3,
    max_boost_db = tonumber(command.maxBoostDb) or 8,
    max_cut_db = tonumber(command.maxCutDb) or 8,
    replace_envelope = command.replaceEnvelope == true,
    window_ms = tonumber(command.windowMs) or 120,
    silence_db = tonumber(command.silenceDb) or -60,
    top_window_fraction = (tonumber(command.topWindowPercent) or 5) / 100,
    measurement_mode = tostring(command.measurementMode or "sustain_robust"):gsub("-", "_"),
    level_mode = tostring(command.levelMode or "macro_micro"):gsub("-", "_"),
    automation_mode = tostring(command.automationMode or "smooth_curve"):gsub("-", "_"),
    reference_percentile = tonumber(command.referencePercentile) or 65,
    stabilize_boost_db = tonumber(command.stabilizeBoostDb) or 3.2,
    stabilize_cut_db = tonumber(command.stabilizeCutDb) or 7,
    gain_deadband_db = tonumber(command.gainDeadbandDb) or 3,
    preserve_loudness = tonumber(command.preserveLoudness) or 1,
    macro_gap_s = (tonumber(command.macroGapMs) or 900) / 1000,
    macro_min_zone_s = (tonumber(command.macroMinZoneMs) or tonumber(command.macroMinBlockMs) or 1200) / 1000,
    macro_max_zones = math.max(1, math.floor(tonumber(command.macroMaxZones) or 8)),
    macro_strength = clamp(tonumber(command.macroStrength) or 0.65, 0, 1),
    macro_deadband_db = tonumber(command.macroDeadbandDb) or 1,
    macro_max_boost_db = tonumber(command.macroMaxBoostDb) or 8,
    macro_max_cut_db = tonumber(command.macroMaxCutDb) or 8,
    meso_gap_s = (tonumber(command.mesoGapMs) or 350) / 1000,
    meso_min_zone_s = (tonumber(command.mesoMinZoneMs) or 450) / 1000,
    meso_max_zones_per_macro = math.max(1, math.floor(tonumber(command.mesoMaxZonesPerMacro) or 24)),
    meso_strength = clamp(tonumber(command.mesoStrength) or 0.75, 0, 1),
    meso_deadband_db = tonumber(command.mesoDeadbandDb) or 1,
    meso_max_boost_db = tonumber(command.mesoMaxBoostDb) or 4,
    meso_max_cut_db = tonumber(command.mesoMaxCutDb) or 4,
    micro_repair = command.microRepair ~= false,
    micro_clear_drop_db = tonumber(command.microClearDropDb) or 4,
    micro_boost_strength = clamp(tonumber(command.microBoostStrength) or 0.45, 0, 1),
    micro_cut_strength = clamp(tonumber(command.microCutStrength) or 0.55, 0, 1),
    micro_deadband_db = tonumber(command.microDeadbandDb) or 1.5,
    micro_max_boost_db = tonumber(command.microMaxBoostDb) or 2.5,
    micro_max_cut_db = tonumber(command.microMaxCutDb) or 3,
    already_good_db = tonumber(command.alreadyGoodDb) or 1,
    protected_max_boost_db = tonumber(command.protectedMaxBoostDb) or 0,
    protected_crest_db = tonumber(command.protectedCrestDb) or 18,
    protected_low_relative_db = tonumber(command.protectedLowRelativeDb) or 12,
    point_density_warn_per_minute = tonumber(command.pointDensityWarnPerMinute) or 70,
    point_density_reject_per_minute = tonumber(command.pointDensityRejectPerMinute) or 100,
    sustain_low_fraction = (tonumber(command.sustainLowPercent) or 50) / 100,
    sustain_high_fraction = (tonumber(command.sustainHighPercent) or 90) / 100,
    transient_crest_db = tonumber(command.transientCrestDb) or 6,
    detect_window_ms = tonumber(command.detectWindowMs) or tonumber(command.gateWindowMs) or 15,
    detect_silence_db = tonumber(command.detectSilenceDb) or -45,
    detect_range_db = tonumber(command.detectRangeDb) or tonumber(command.gateRangeDb) or 35,
    part_merge_gap_s = (tonumber(command.partMergeGapMs) or tonumber(command.activationMergeGapMs) or 350) / 1000,
    min_part_s = (tonumber(command.minPartMs) or tonumber(command.minActivationMs) or tonumber(command.minPhraseMs) or 300) / 1000,
    syllable_split_db = tonumber(command.syllableSplitDb) or 20,
    syllable_split_hold_s = (tonumber(command.syllableSplitHoldMs) or 140) / 1000,
    min_gain_change_db = tonumber(command.minGainChangeDb) or 5,
    gain_merge_gap_s = (tonumber(command.gainMergeGapMs) or 0) / 1000,
    zero_crossing_enabled = command.zeroCrossing ~= false,
    zero_crossing_search_s = (tonumber(command.zeroCrossingSearchMs) or 12) / 1000,
    curve_smooth_s = (tonumber(command.curveSmoothMs) or 320) / 1000,
    curve_tolerance_db = tonumber(command.curveToleranceDb) or 2,
    curve_min_point_gap_s = (tonumber(command.curveMinPointGapMs) or 240) / 1000,
    curve_detail = tonumber(command.curveDetail) or 0.5,
    curve_edge_ramp_s = (tonumber(command.curveEdgeRampMs) or 80) / 1000,
    padding_s = (tonumber(command.paddingMs) or 8) / 1000,
    ramp_s = (tonumber(command.rampMs) or 0) / 1000,
    post_level_report = command.postLevelReport ~= false
  }
end

local function append_vocal_part(parts, part, item_start, item_end, settings)
  local padded_start = clamp(part.start - settings.padding_s, item_start, item_end)
  local padded_end = clamp(part["end"] + settings.padding_s, item_start, item_end)
  if padded_end - padded_start < settings.min_part_s then return end

  local previous = parts[#parts]
  if previous and padded_start <= previous["end"] then
    local previous_raw_end = previous.raw_end or previous["end"]
    if part.force_separate or part.start >= previous_raw_end then
      local boundary = part.start
      if part.start > previous_raw_end then boundary = (previous_raw_end + part.start) / 2 end
      previous["end"] = math.min(previous["end"], boundary)
      padded_start = math.max(padded_start, boundary)
    else
      previous["end"] = math.max(previous["end"], padded_end)
      previous.raw_end = math.max(previous.raw_end or previous["end"], part["end"])
      previous.peak = math.max(previous.peak or 0, part.peak or 0)
      previous.windows = (previous.windows or 0) + (part.windows or 0)
      return
    end
  end

  if padded_end - padded_start < settings.min_part_s then return end
  parts[#parts + 1] = {
    start = padded_start,
    ["end"] = padded_end,
    raw_start = part.start,
    raw_end = part["end"],
    peak = part.peak or 0,
    windows = part.windows or 0
  }
end

local function vocal_part_from_windows(windows, start_index, end_index, force_separate)
  if not windows or end_index < start_index then return nil end
  local first = windows[start_index]
  local last = windows[end_index]
  if not first or not last then return nil end

  local peak = 0
  for i = start_index, end_index do
    peak = math.max(peak, windows[i].peak or 0)
  end

  return {
    start = first.start,
    ["end"] = last["end"],
    peak = peak,
    windows = end_index - start_index + 1,
    force_separate = force_separate == true
  }
end

local function contiguous_window_duration(windows, start_index, predicate)
  local duration = 0
  for i = start_index, #windows do
    local window = windows[i]
    if not predicate(window) then break end
    duration = duration + math.max(0, (window["end"] or window.start) - window.start)
  end
  return duration
end

local function split_vocal_window_island(windows, settings)
  if #windows == 0 then return {} end
  local split_db = settings.syllable_split_db or 0
  if split_db <= 0 or #windows == 1 then
    local part = vocal_part_from_windows(windows, 1, #windows, false)
    return part and { part } or {}
  end

  local parts = {}
  local start_index = 1
  local high_db = windows[1].rms_db or -150
  local low_db = windows[1].rms_db or -150
  local i = 2

  while i <= #windows do
    local rms_db = windows[i].rms_db or -150
    local current_duration = windows[i].start - windows[start_index].start
    local should_split = false

    if current_duration >= settings.min_part_s then
      local drop_threshold = high_db - split_db
      if rms_db <= drop_threshold then
        local held = contiguous_window_duration(windows, i, function(window)
          return (window.rms_db or -150) <= drop_threshold
        end)
        if held >= settings.syllable_split_hold_s then should_split = true end
      end

      if not should_split then
        local rise_threshold = low_db + split_db
        if rms_db >= rise_threshold then
          local held = contiguous_window_duration(windows, i, function(window)
            return (window.rms_db or -150) >= rise_threshold
          end)
          if held >= settings.syllable_split_hold_s then should_split = true end
        end
      end
    end

    if should_split then
      local part = vocal_part_from_windows(windows, start_index, i - 1, true)
      if part then parts[#parts + 1] = part end
      start_index = i
      high_db = rms_db
      low_db = rms_db
    else
      if rms_db > high_db then high_db = rms_db end
      if rms_db < low_db then low_db = rms_db end
      i = i + 1
    end
  end

  local final_part = vocal_part_from_windows(windows, start_index, #windows, #parts > 0)
  if final_part then parts[#parts + 1] = final_part end
  return parts
end

local function build_vocal_parts_from_active_windows(active_windows, settings)
  local raw_parts = {}
  local island = {}

  local function flush_island()
    if #island == 0 then return end
    local split_parts = split_vocal_window_island(island, settings)
    for _, part in ipairs(split_parts) do
      raw_parts[#raw_parts + 1] = part
    end
    island = {}
  end

  for _, window in ipairs(active_windows) do
    local previous = island[#island]
    if previous and window.start - previous["end"] > settings.part_merge_gap_s then
      flush_island()
    end
    island[#island + 1] = window
  end

  flush_island()
  return raw_parts
end

local function mono_sample_from_buffer(buffer, frame, channels)
  local sum = 0
  for ch = 1, channels do
    sum = sum + (buffer[frame * channels + ch] or 0)
  end
  return sum / math.max(1, channels)
end

local function nearest_zero_crossing_time(accessor, sample_rate, channels, target_time, min_time, max_time, search_s)
  if not search_s or search_s <= 0 then return clamp(target_time, min_time, max_time) end
  if not min_time or not max_time or max_time <= min_time then return target_time end

  local search_start = clamp(target_time - search_s, min_time, max_time)
  local search_end = clamp(target_time + search_s, min_time, max_time)
  if search_end <= search_start then return clamp(target_time, min_time, max_time) end

  local sample_count = math.max(2, math.floor((search_end - search_start) * sample_rate) + 2)
  local buffer = reaper.new_array(sample_count * channels)
  buffer.clear()

  local retval = reaper.GetAudioAccessorSamples(accessor, sample_rate, channels, search_start, sample_count, buffer)
  if retval ~= 1 then return clamp(target_time, min_time, max_time) end

  local best_crossing = nil
  local best_crossing_distance = nil
  local best_low_time = nil
  local best_low_abs = nil
  local best_low_distance = nil
  local previous_value = nil
  local previous_time = nil

  for frame = 0, sample_count - 1 do
    local value = mono_sample_from_buffer(buffer, frame, channels)
    local time = search_start + (frame / sample_rate)
    if time >= min_time and time <= max_time then
      local abs_value = math.abs(value)
      local distance = math.abs(time - target_time)
      if not best_low_abs or abs_value < best_low_abs or (abs_value == best_low_abs and distance < best_low_distance) then
        best_low_abs = abs_value
        best_low_time = time
        best_low_distance = distance
      end

      if previous_value then
        local crossing_time = nil
        if previous_value == 0 then
          crossing_time = previous_time
        elseif value == 0 then
          crossing_time = time
        elseif (previous_value < 0 and value > 0) or (previous_value > 0 and value < 0) then
          local denom = math.abs(previous_value) + math.abs(value)
          local fraction = denom > 0 and (math.abs(previous_value) / denom) or 0
          crossing_time = previous_time + (fraction / sample_rate)
        end

        if crossing_time and crossing_time >= min_time and crossing_time <= max_time then
          local crossing_distance = math.abs(crossing_time - target_time)
          if not best_crossing_distance or crossing_distance < best_crossing_distance then
            best_crossing = crossing_time
            best_crossing_distance = crossing_distance
          end
        end
      end

      previous_value = value
      previous_time = time
    end
  end

  return best_crossing or best_low_time or clamp(target_time, min_time, max_time)
end

local function snap_vocal_parts_to_zero_crossings(accessor, sample_rate, channels, parts, item_start, item_end, settings)
  if not settings.zero_crossing_enabled then return parts end
  if not parts or #parts == 0 then return parts end

  local search_s = settings.zero_crossing_search_s or 0.012
  if search_s <= 0 then return parts end

  local minimum_edge_s = math.min(0.001, math.max(0.0001, (settings.min_part_s or 0.05) / 4))

  local function snap(time, lower, upper)
    lower = clamp(lower, item_start, item_end)
    upper = clamp(upper, item_start, item_end)
    if upper <= lower then return clamp(time, item_start, item_end) end
    return nearest_zero_crossing_time(accessor, sample_rate, channels, time, lower, upper, search_s)
  end

  for index, part in ipairs(parts) do
    if index == 1 or part.start - parts[index - 1]["end"] > 0.001 then
      part.start = snap(part.start, part.start - search_s, math.min(part.start + search_s, part["end"] - minimum_edge_s))
    end

    local next_part = parts[index + 1]
    if next_part and next_part.start - part["end"] <= 0.001 then
      local target = (part["end"] + next_part.start) / 2
      local boundary = snap(target, math.max(part.start + minimum_edge_s, target - search_s), math.min(next_part["end"] - minimum_edge_s, target + search_s))
      part["end"] = boundary
      next_part.start = boundary
    else
      part["end"] = snap(part["end"], math.max(part.start + minimum_edge_s, part["end"] - search_s), part["end"] + search_s)
    end
  end

  local snapped = {}
  for _, part in ipairs(parts) do
    if part["end"] - part.start > minimum_edge_s then snapped[#snapped + 1] = part end
  end
  return snapped
end

local function detect_vocal_parts(accessor, sample_rate, channels, item_start, item_end, settings)
  local total_samples = math.floor((item_end - item_start) * sample_rate)
  if total_samples <= 0 then return nil, "too short to analyze" end

  local window_samples = math.max(1, math.floor(sample_rate * settings.detect_window_ms / 1000))
  local block_samples = math.min(16384, math.max(2048, window_samples))
  local buffer = reaper.new_array(block_samples * channels)
  local windows = {}
  local window_sum = 0
  local window_count = 0
  local window_peak = 0
  local global_frame = 0
  local window_start_frame = 0
  local position = item_start
  local remaining = total_samples
  local read_any = false

  local function flush_window()
    if window_count <= 0 then return end
    local rms = math.sqrt(window_sum / window_count)
    windows[#windows + 1] = {
      start = item_start + (window_start_frame / sample_rate),
      ["end"] = item_start + (global_frame / sample_rate),
      rms_db = gain_to_db(rms),
      peak = window_peak
    }
    window_sum = 0
    window_count = 0
    window_peak = 0
    window_start_frame = global_frame
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
          if abs_sample > window_peak then window_peak = abs_sample end
          frame_square = frame_square + sample * sample
        end
        window_sum = window_sum + (frame_square / channels)
        window_count = window_count + 1
        global_frame = global_frame + 1
        if window_count >= window_samples then flush_window() end
      end
    else
      global_frame = global_frame + want
    end

    remaining = remaining - want
    position = position + (want / sample_rate)
  end

  flush_window()

  if not read_any then return nil, "no audio returned" end
  if #windows == 0 then return nil, "silent item" end

  local max_window_db = -150
  for _, window in ipairs(windows) do
    if window.rms_db and window.rms_db > max_window_db then max_window_db = window.rms_db end
  end

  local active_floor_db = math.max(settings.detect_silence_db, max_window_db - settings.detect_range_db)
  local active_windows = {}
  for _, window in ipairs(windows) do
    if window.rms_db and window.rms_db >= active_floor_db then
      active_windows[#active_windows + 1] = window
    end
  end

  if #active_windows == 0 then
    return nil, "silent item"
  end

  local parts = {}
  local raw_parts = build_vocal_parts_from_active_windows(active_windows, settings)
  for _, part in ipairs(raw_parts) do
    if part["end"] - part.start >= settings.min_part_s then
      append_vocal_part(parts, part, item_start, item_end, settings)
    end
  end

  if #parts == 0 then return nil, "no vocal parts" end

  parts = snap_vocal_parts_to_zero_crossings(accessor, sample_rate, channels, parts, item_start, item_end, settings)
  if #parts == 0 then return nil, "no vocal parts after zero crossing snap" end

  return {
    parts = parts,
    active_floor_db = active_floor_db,
    window_count = #windows,
    active_window_count = #active_windows
  }
end

local function copy_vocal_segment(segment)
  local copy = {}
  for key, value in pairs(segment) do
    copy[key] = value
  end
  copy.merged_parts = segment.merged_parts or 1
  copy.merge_weight = segment.selected_windows or segment.windows or math.max(1, (segment.length or 0) * 1000)
  return copy
end

local function vocal_segment_weight(segment)
  return math.max(1, segment.merge_weight or segment.selected_windows or segment.windows or (segment.length or 0) * 1000)
end

local function weighted_merge_value(a, b, weight_a, weight_b)
  if type(a) ~= "number" then return b end
  if type(b) ~= "number" then return a end
  return ((a * weight_a) + (b * weight_b)) / (weight_a + weight_b)
end

local function merge_vocal_segment(previous, segment, settings)
  local weight_a = vocal_segment_weight(previous)
  local weight_b = vocal_segment_weight(segment)
  local total_weight = weight_a + weight_b

  previous["end"] = segment["end"]
  previous.raw_end = segment.raw_end
  previous.accessor_end = segment.accessor_end
  previous.end_rel = segment.end_rel
  previous.length = math.max(0, (previous.accessor_end or previous["end"]) - (previous.accessor_start or previous.start))

  previous.gain_db = weighted_merge_value(previous.gain_db, segment.gain_db, weight_a, weight_b)
  previous.take_gain_db = weighted_merge_value(previous.take_gain_db, segment.take_gain_db, weight_a, weight_b)
  previous.measured_db = weighted_merge_value(previous.measured_db, segment.measured_db, weight_a, weight_b)
  previous.sustain_db = weighted_merge_value(previous.sustain_db, segment.sustain_db, weight_a, weight_b)

  previous.raw_peak_db = math.max(previous.raw_peak_db or -150, segment.raw_peak_db or -150)
  previous.final_peak_db = (previous.raw_peak_db or -150) + (previous.take_gain_db or 0)
  if previous.sustain_db and previous.take_gain_db then
    previous.final_vu = previous.sustain_db + previous.take_gain_db - settings.calibration_db
  end

  previous.windows = (previous.windows or 0) + (segment.windows or 0)
  previous.selected_windows = (previous.selected_windows or 0) + (segment.selected_windows or 0)
  previous.excluded_windows = (previous.excluded_windows or 0) + (segment.excluded_windows or 0)
  previous.transient_windows = (previous.transient_windows or 0) + (segment.transient_windows or 0)
  previous.detection_windows = (previous.detection_windows or 0) + (segment.detection_windows or 0)
  previous.limited_by_peak = previous.limited_by_peak or segment.limited_by_peak
  previous.limited_by_max_boost = previous.limited_by_max_boost or segment.limited_by_max_boost
  previous.limited_by_max_cut = previous.limited_by_max_cut or segment.limited_by_max_cut
  previous.merged_parts = (previous.merged_parts or 1) + (segment.merged_parts or 1)
  previous.merge_weight = total_weight
end

local function can_merge_vocal_segments(previous, segment, settings)
  local gain_a = previous.gain_db or 0
  local gain_b = segment.gain_db or 0
  if math.abs(gain_a - gain_b) > (settings.min_gain_change_db or 0) then return false end

  local gap = (segment.start_rel or segment.start or 0) - (previous.end_rel or previous["end"] or 0)
  return gap <= (settings.gain_merge_gap_s or 0)
end

local function consolidate_vocal_level_segments(segments, settings)
  if not segments or #segments <= 1 then return segments or {} end

  local consolidated = {}
  for _, segment in ipairs(segments) do
    local current = copy_vocal_segment(segment)
    local previous = consolidated[#consolidated]
    if previous and can_merge_vocal_segments(previous, current, settings) then
      merge_vocal_segment(previous, current, settings)
    else
      consolidated[#consolidated + 1] = current
    end
  end

  for index, segment in ipairs(consolidated) do
    segment.part_index = index
  end
  return consolidated
end

local function weighted_percentile(entries, percentile)
  if not entries or #entries == 0 then return nil end
  table.sort(entries, function(a, b) return (a.value or 0) < (b.value or 0) end)

  local total_weight = 0
  for _, entry in ipairs(entries) do
    total_weight = total_weight + math.max(0, entry.weight or 1)
  end
  if total_weight <= 0 then return entries[#entries].value end

  local threshold = total_weight * clamp((percentile or 50) / 100, 0, 1)
  local cumulative = 0
  for _, entry in ipairs(entries) do
    cumulative = cumulative + math.max(0, entry.weight or 1)
    if cumulative >= threshold then return entry.value end
  end

  return entries[#entries].value
end

local function apply_relative_vocal_stabilization(segments, ctx, settings)
  if not segments or #segments == 0 then return nil end

  local entries = {}
  local total_weight = 0
  for _, segment in ipairs(segments) do
    local weight = vocal_segment_weight(segment)
    local current_db = (segment.measured_db or segment.sustain_db or -150) + (ctx.original_combined_db or 0)
    segment.current_db = current_db
    segment.current_peak_db = (segment.raw_peak_db or -150) + (ctx.original_combined_db or 0)
    segment.absolute_gain_db = segment.gain_db
    entries[#entries + 1] = {
      value = current_db,
      weight = weight
    }
    total_weight = total_weight + weight
  end

  local reference_db = weighted_percentile(entries, settings.reference_percentile or 65)
  if not reference_db then return nil end

  local sum_correction = 0
  for _, segment in ipairs(segments) do
    local weight = vocal_segment_weight(segment)
    local desired = reference_db - (segment.current_db or reference_db)
    desired = clamp(desired, -(settings.stabilize_cut_db or 10), settings.stabilize_boost_db or 6)

    local peak_limit = (settings.peak_ceiling_db or -0.3) - (segment.current_peak_db or -150)
    if desired > peak_limit then
      desired = peak_limit
      segment.limited_by_peak = true
    end

    segment.relative_raw_gain_db = desired
    sum_correction = sum_correction + (desired * weight)
  end

  local average_correction = total_weight > 0 and (sum_correction / total_weight) or 0
  local preserve = clamp(settings.preserve_loudness or 1, 0, 1)
  local final_sum = 0

  for _, segment in ipairs(segments) do
    local desired = (segment.relative_raw_gain_db or 0) - (average_correction * preserve)
    desired = clamp(desired, -(settings.stabilize_cut_db or 10), settings.stabilize_boost_db or 6)

    local peak_limit = (settings.peak_ceiling_db or -0.3) - (segment.current_peak_db or -150)
    if desired > peak_limit then
      desired = peak_limit
      segment.limited_by_peak = true
    end

    if math.abs(desired) < (settings.gain_deadband_db or 0) then desired = 0 end

    segment.gain_db = desired
    segment.take_gain_db = (ctx.original_combined_db or 0) + desired
    segment.final_peak_db = (segment.current_peak_db or -150) + desired
    segment.final_vu = (segment.current_db or reference_db) + desired - (settings.calibration_db or -18)
    segment.reference_db = reference_db
    segment.relative_gain_db = desired
    segment.limited_by_max_boost = desired >= (settings.stabilize_boost_db or 6) - 0.0001
    segment.limited_by_max_cut = desired <= -((settings.stabilize_cut_db or 10) - 0.0001)
    final_sum = final_sum + (desired * vocal_segment_weight(segment))
  end

  return {
    reference_db = reference_db,
    average_raw_correction_db = average_correction,
    average_final_correction_db = total_weight > 0 and (final_sum / total_weight) or 0
  }
end

local function weighted_db_stats(entries, percentile)
  if not entries or #entries == 0 then return nil end

  local values = {}
  local sum = 0
  local total_weight = 0
  for _, entry in ipairs(entries) do
    local weight = math.max(0, entry.weight or 1)
    if entry.value and weight > 0 then
      values[#values + 1] = { value = entry.value, weight = weight }
      sum = sum + (entry.value * weight)
      total_weight = total_weight + weight
    end
  end
  if #values == 0 or total_weight <= 0 then return nil end

  local mean = sum / total_weight
  local variance = 0
  for _, entry in ipairs(values) do
    local delta = (entry.value or 0) - mean
    variance = variance + (delta * delta * (entry.weight or 1))
  end
  variance = variance / total_weight

  local function percentile_value(p)
    local copy = {}
    for _, entry in ipairs(values) do
      copy[#copy + 1] = { value = entry.value, weight = entry.weight }
    end
    return weighted_percentile(copy, p)
  end

  local p10 = percentile_value(10)
  local p90 = percentile_value(90)
  return {
    count = #values,
    average_db = mean,
    stdev_db = math.sqrt(math.max(0, variance)),
    reference_db = percentile_value(percentile or 65),
    p10_db = p10,
    p90_db = p90,
    spread_db = (p10 and p90) and (p90 - p10) or nil
  }
end

local function summarize_zone_balance(groups, percentile)
  local entries = {}
  local examples = {}
  for _, group in pairs(groups or {}) do
    if group.weight and group.weight > 0 then
      local before_db = group.before_sum / group.weight
      local after_db = group.after_sum / group.weight
      entries[#entries + 1] = {
        value = after_db,
        weight = group.weight
      }
      if #examples < 12 then
        examples[#examples + 1] = {
          index = group.index,
          parent_index = group.parent_index,
          segments = group.segments,
          before_db = before_db,
          after_db = after_db,
          delta_db = after_db - before_db,
          weight_s = group.weight
        }
      end
    end
  end

  return {
    count = #entries,
    stats = weighted_db_stats(entries, percentile),
    examples = examples
  }
end

local function take_envelope_gain_db_at_time(env, time)
  if not env or not reaper.Envelope_Evaluate then return nil end
  local ok, value = reaper.Envelope_Evaluate(env, time, 0, 0)
  if not ok then return nil end

  local gain = value
  if reaper.GetEnvelopeScalingMode and reaper.ScaleFromEnvelopeMode then
    gain = reaper.ScaleFromEnvelopeMode(reaper.GetEnvelopeScalingMode(env), value)
  end
  if not gain or gain <= 0 then return -150 end
  return gain_to_db(gain)
end

local function take_envelope_segment_gain_db(env, segment, item_length)
  if not env then return nil end
  local start_rel = clamp(segment.start_rel or 0, 0, item_length or segment.end_rel or 0)
  local end_rel = clamp(segment.end_rel or start_rel, 0, item_length or start_rel)
  local length = math.max(0, end_rel - start_rel)
  local center = start_rel + (length / 2)
  local inset = math.min(0.04, length / 4)
  local positions = { center }
  if length > 0.08 then
    positions[#positions + 1] = start_rel + inset
    positions[#positions + 1] = end_rel - inset
  end

  local sum = 0
  local count = 0
  for _, position in ipairs(positions) do
    local gain_db = take_envelope_gain_db_at_time(env, position)
    if gain_db then
      sum = sum + gain_db
      count = count + 1
    end
  end
  if count <= 0 then return nil end
  return sum / count
end

local function measure_vocal_level_result(analysis, settings, env, mode)
  if not analysis or not analysis.segments or #analysis.segments == 0 then return nil end

  local before_entries = {}
  local after_entries = {}
  local macro_groups = {}
  local meso_groups = {}
  local peak_outliers = 0
  local glottal_outliers = 0
  local silence_or_breath_protected = 0
  local boosted_protected = 0
  local boosted_low_energy = 0
  local unresolved_peak_outliers = 0
  local max_after_peak_db = nil

  for _, segment in ipairs(analysis.segments) do
    local weight = vocal_segment_weight(segment)
    local before_db = (segment.measured_db or segment.sustain_db or -150) + (analysis.original_combined_db or 0)
    local applied_gain_db = take_envelope_segment_gain_db(env, segment, analysis.item_length) or (segment.gain_db or 0)
    local after_db = before_db + applied_gain_db
    local after_peak_db = (segment.raw_peak_db or segment.source_peak_db or -150) + (analysis.original_combined_db or 0) + applied_gain_db

    before_entries[#before_entries + 1] = { value = before_db, weight = weight }
    after_entries[#after_entries + 1] = { value = after_db, weight = weight }

    max_after_peak_db = max_after_peak_db and math.max(max_after_peak_db, after_peak_db) or after_peak_db
    if after_peak_db > (settings.peak_ceiling_db or -0.3) + 0.001 then
      peak_outliers = peak_outliers + 1
      unresolved_peak_outliers = unresolved_peak_outliers + 1
    end

    if (segment.median_crest_db or 0) >= (settings.protected_crest_db or 18) then
      glottal_outliers = glottal_outliers + 1
    end
    if segment.safety_protected or segment.protected_reason then
      silence_or_breath_protected = silence_or_breath_protected + 1
      if applied_gain_db > 0.001 then boosted_protected = boosted_protected + 1 end
    end
    if before_db < (settings.detect_silence_db or -45) and applied_gain_db > 0.001 then
      boosted_low_energy = boosted_low_energy + 1
    end

    local macro_index = segment.macro_zone_index
    if macro_index then
      local key = tostring(macro_index)
      local group = macro_groups[key] or {
        index = macro_index,
        before_sum = 0,
        after_sum = 0,
        weight = 0,
        segments = 0
      }
      group.before_sum = group.before_sum + (before_db * weight)
      group.after_sum = group.after_sum + (after_db * weight)
      group.weight = group.weight + weight
      group.segments = group.segments + 1
      macro_groups[key] = group
    end

    local meso_index = segment.meso_zone_index
    if macro_index and meso_index then
      local key = tostring(macro_index) .. ":" .. tostring(meso_index)
      local group = meso_groups[key] or {
        index = meso_index,
        parent_index = macro_index,
        before_sum = 0,
        after_sum = 0,
        weight = 0,
        segments = 0
      }
      group.before_sum = group.before_sum + (before_db * weight)
      group.after_sum = group.after_sum + (after_db * weight)
      group.weight = group.weight + weight
      group.segments = group.segments + 1
      meso_groups[key] = group
    end
  end

  local before_stats = weighted_db_stats(before_entries, settings.reference_percentile or 65)
  local after_stats = weighted_db_stats(after_entries, settings.reference_percentile or 65)
  return {
    mode = mode or (env and "applied_take_envelope" or "estimated_envelope"),
    segment_count = #analysis.segments,
    before = before_stats,
    after = after_stats,
    improvement = {
      stdev_db = before_stats and after_stats and before_stats.stdev_db and after_stats.stdev_db and (before_stats.stdev_db - after_stats.stdev_db) or nil,
      spread_db = before_stats and after_stats and before_stats.spread_db and after_stats.spread_db and (before_stats.spread_db - after_stats.spread_db) or nil
    },
    macro_balance = summarize_zone_balance(macro_groups, settings.reference_percentile or 65),
    meso_balance = summarize_zone_balance(meso_groups, settings.reference_percentile or 65),
    peak_outliers = peak_outliers,
    glottal_outliers = glottal_outliers,
    silence_breath_safety = {
      protected_parts = silence_or_breath_protected,
      boosted_protected_parts = boosted_protected,
      boosted_low_energy_parts = boosted_low_energy
    },
    max_after_peak_db = max_after_peak_db,
    unresolved_peak_outliers = unresolved_peak_outliers
  }
end

local append_vocal_level_point

local function vocal_segment_center(segment)
  return ((segment.start_rel or segment.start or 0) + (segment.end_rel or segment["end"] or 0)) / 2
end

local function smooth_vocal_segments_for_curve(segments, settings)
  if not segments or #segments == 0 then return {} end

  local radius = settings.curve_smooth_s or 0.18
  local detail = clamp(settings.curve_detail or 0.65, 0, 1)
  local smoothed = {}

  for index, segment in ipairs(segments) do
    local current = copy_vocal_segment(segment)
    local desired_gain = segment.gain_db or 0
    local center = vocal_segment_center(segment)
    local weighted_sum = 0
    local total_weight = 0

    if radius > 0 and not segment.safety_protected then
      for _, candidate in ipairs(segments) do
        local distance = math.abs(vocal_segment_center(candidate) - center)
        if distance <= radius then
          local time_weight = 1 - (distance / radius)
          local duration_weight = math.max(0.02, (candidate.end_rel or 0) - (candidate.start_rel or 0))
          local weight = math.max(0.05, time_weight) * duration_weight
          weighted_sum = weighted_sum + ((candidate.gain_db or 0) * weight)
          total_weight = total_weight + weight
        end
      end
    end

    local local_average = total_weight > 0 and (weighted_sum / total_weight) or desired_gain
    current.desired_gain_db = desired_gain
    current.curve_gain_db = segment.safety_protected and desired_gain or ((desired_gain * detail) + (local_average * (1 - detail)))
    current.part_index = index
    smoothed[#smoothed + 1] = current
  end

  return smoothed
end

local function simplify_gain_curve_points(points, tolerance_db)
  if not points or #points <= 2 then return points or {} end

  local keep = {}
  keep[1] = true
  keep[#points] = true

  local function recurse(first_index, last_index)
    if last_index <= first_index + 1 then return end

    local first = points[first_index]
    local last = points[last_index]
    local span = (last.time or 0) - (first.time or 0)
    local max_error = -1
    local max_index = nil

    for i = first_index + 1, last_index - 1 do
      local point = points[i]
      local ratio = span ~= 0 and (((point.time or 0) - (first.time or 0)) / span) or 0
      local expected = (first.gain_db or 0) + (((last.gain_db or 0) - (first.gain_db or 0)) * ratio)
      local error_db = math.abs((point.gain_db or 0) - expected)
      if error_db > max_error then
        max_error = error_db
        max_index = i
      end
    end

    if max_index and max_error > tolerance_db then
      keep[max_index] = true
      recurse(first_index, max_index)
      recurse(max_index, last_index)
    end
  end

  recurse(1, #points)

  local simplified = {}
  for index, point in ipairs(points) do
    if keep[index] then simplified[#simplified + 1] = point end
  end
  return simplified
end

local function enforce_curve_point_gap(points, min_gap_s, tolerance_db)
  if not points or #points <= 2 or not min_gap_s or min_gap_s <= 0 then return points or {} end

  local spaced = { points[1] }
  local important_delta = math.max(0, tolerance_db or 0)
  for index = 2, #points - 1 do
    local point = points[index]
    local previous = spaced[#spaced]
    local next_point = points[index + 1]
    local is_extreme = ((point.gain_db or 0) > (previous.gain_db or 0) and (point.gain_db or 0) > (next_point.gain_db or 0))
      or ((point.gain_db or 0) < (previous.gain_db or 0) and (point.gain_db or 0) < (next_point.gain_db or 0))
    local extreme_is_meaningful = is_extreme
      and math.abs((point.gain_db or 0) - (previous.gain_db or 0)) >= important_delta
      and math.abs((point.gain_db or 0) - (next_point.gain_db or 0)) >= important_delta

    if (point.time or 0) - (previous.time or 0) >= min_gap_s or extreme_is_meaningful then
      spaced[#spaced + 1] = point
    elseif index < #points - 1
        and math.abs((point.gain_db or 0) - (previous.gain_db or 0)) >= important_delta
        and math.abs((point.gain_db or 0) - (previous.gain_db or 0)) > math.abs((next_point.gain_db or 0) - (previous.gain_db or 0)) then
      spaced[#spaced] = point
    end
  end

  spaced[#spaced + 1] = points[#points]
  return spaced
end

local function merge_same_time_curve_points(points)
  if not points or #points <= 1 then return points or {} end

  local merged = {}
  local current = nil
  local current_count = 0
  for _, point in ipairs(points) do
    if current and math.abs((point.time or 0) - (current.time or 0)) < 0.000001 then
      local next_count = current_count + 1
      current.gain_db = (((current.gain_db or 0) * current_count) + (point.gain_db or 0)) / next_count
      current_count = next_count
    else
      current = {
        time = point.time,
        gain_db = point.gain_db or 0
      }
      current_count = 1
      merged[#merged + 1] = current
    end
  end

  return merged
end

local function append_curve_phrase_points(points, phrase, settings, item_length)
  if not phrase or #phrase == 0 then return end

  local phrase_start = clamp(phrase[1].start_rel or 0, 0, item_length)
  local phrase_end = clamp(phrase[#phrase].end_rel or phrase_start, 0, item_length)
  if phrase_end <= phrase_start then return end

  local anchors = {}
  anchors[#anchors + 1] = {
    time = phrase_start,
    gain_db = phrase[1].curve_gain_db or phrase[1].gain_db or 0
  }

  for _, segment in ipairs(phrase) do
    local gain_db = segment.curve_gain_db or segment.gain_db or 0
    local start_rel = clamp(segment.start_rel or phrase_start, phrase_start, phrase_end)
    local center = clamp(vocal_segment_center(segment), phrase_start, phrase_end)
    local end_rel = clamp(segment.end_rel or center, phrase_start, phrase_end)

    anchors[#anchors + 1] = {
      time = start_rel,
      gain_db = gain_db
    }
    anchors[#anchors + 1] = {
      time = center,
      gain_db = gain_db
    }
    anchors[#anchors + 1] = {
      time = end_rel,
      gain_db = gain_db
    }
  end

  anchors[#anchors + 1] = {
    time = phrase_end,
    gain_db = phrase[#phrase].curve_gain_db or phrase[#phrase].gain_db or 0
  }

  table.sort(anchors, function(a, b) return (a.time or 0) < (b.time or 0) end)
  anchors = merge_same_time_curve_points(anchors)
  local simplified = simplify_gain_curve_points(anchors, settings.curve_tolerance_db or 1.2)
  simplified = enforce_curve_point_gap(simplified, settings.curve_min_point_gap_s or 0.12, settings.curve_tolerance_db or 1.2)

  local edge_ramp = settings.curve_edge_ramp_s or 0.035
  append_vocal_level_point(points, math.max(0, phrase_start - edge_ramp), 0, 0)
  for _, point in ipairs(simplified) do
    append_vocal_level_point(points, clamp(point.time or phrase_start, 0, item_length), point.gain_db or 0, 0)
  end
  append_vocal_level_point(points, math.min(item_length, phrase_end + edge_ramp), 0, 0)
end

local function build_vocal_level_curve_points(analysis)
  local points = {}
  local smoothed = smooth_vocal_segments_for_curve(analysis.segments, analysis.settings or {})
  local item_length = analysis.item_length or 0

  append_vocal_level_point(points, 0, 0, 0)

  local phrase = {}
  local function flush_phrase()
    append_curve_phrase_points(points, phrase, analysis.settings or {}, item_length)
    phrase = {}
  end

  local phrase_gap_s = math.max(0.001, analysis.settings and analysis.settings.part_merge_gap_s or 0.07)
  for _, segment in ipairs(smoothed) do
    local previous = phrase[#phrase]
    if previous and (segment.start_rel or 0) - (previous.end_rel or 0) > phrase_gap_s then
      flush_phrase()
    end
    phrase[#phrase + 1] = segment
  end

  flush_phrase()
  append_vocal_level_point(points, item_length, 0, 0)
  return points
end

local function limit_vocal_envelope_gain(envelope_gain_db, ctx, range_analysis, settings)
  local gain_db = envelope_gain_db or 0
  local limited_by_peak = range_analysis.limited_by_peak == true
  local limited_by_max_boost = range_analysis.limited_by_max_boost == true
  local limited_by_max_cut = range_analysis.limited_by_max_cut == true
  local raw_peak_db = range_analysis.source_peak_db or -150

  local peak_limited_gain_db = (settings.peak_ceiling_db or -0.3) - raw_peak_db - (ctx.original_combined_db or 0)
  if gain_db > peak_limited_gain_db then
    gain_db = peak_limited_gain_db
    limited_by_peak = true
  end

  local unresolved_peak = false

  if settings.max_boost_db and gain_db > settings.max_boost_db then
    gain_db = settings.max_boost_db
    limited_by_max_boost = true
  end

  if settings.max_cut_db and gain_db < -settings.max_cut_db then
    if limited_by_peak and peak_limited_gain_db < -settings.max_cut_db then
      unresolved_peak = true
    end
    gain_db = -settings.max_cut_db
    limited_by_max_cut = true
  end

  local take_gain_db = (ctx.original_combined_db or 0) + gain_db
  local measured_db = range_analysis.source_rms_db or range_analysis.sustain_db or -150

  return {
    gain_db = gain_db,
    take_gain_db = take_gain_db,
    final_peak_db = raw_peak_db + take_gain_db,
    final_vu = measured_db + take_gain_db - (settings.calibration_db or -18),
    limited_by_peak = limited_by_peak,
    limited_by_max_boost = limited_by_max_boost,
    limited_by_max_cut = limited_by_max_cut,
    unresolved_peak = unresolved_peak
  }
end

local function vocal_deadband_gain(delta_db, deadband_db, strength, max_boost_db, max_cut_db)
  local delta = delta_db or 0
  if math.abs(delta) <= (deadband_db or 0) then return 0 end
  return clamp(delta * (strength or 1), -(max_cut_db or max_boost_db or 0), max_boost_db or 0)
end

local function vocal_segment_current_db(segment, ctx)
  return (segment.measured_db or segment.sustain_db or -150) + (ctx.original_combined_db or 0)
end

local function vocal_segment_peak_db(segment, ctx)
  return (segment.raw_peak_db or segment.source_peak_db or -150) + (ctx.original_combined_db or 0)
end

local function merge_macro_zone(left, right)
  if not left then return right end
  if not right then return left end

  for _, segment in ipairs(right.segments or {}) do
    left.segments[#left.segments + 1] = segment
  end
  left.start_rel = math.min(left.start_rel or right.start_rel or 0, right.start_rel or left.start_rel or 0)
  left.end_rel = math.max(left.end_rel or right.end_rel or 0, right.end_rel or left.end_rel or 0)
  left.segment_count = #left.segments
  return left
end

local function macro_zone_gap(left, right)
  if not left or not right then return math.huge end
  return math.max(0, (right.start_rel or 0) - (left.end_rel or 0))
end

local function finalize_macro_zone_stats(zone, ctx, settings)
  local entries = {}
  local peak_db = -150
  local weight_sum = 0

  for _, segment in ipairs(zone.segments or {}) do
    local weight = vocal_segment_weight(segment)
    local current_db = vocal_segment_current_db(segment, ctx)
    entries[#entries + 1] = { value = current_db, weight = weight }
    peak_db = math.max(peak_db, vocal_segment_peak_db(segment, ctx))
    weight_sum = weight_sum + weight
  end

  zone.segment_count = #(zone.segments or {})
  zone.duration_s = math.max(0, (zone.end_rel or 0) - (zone.start_rel or 0))
  zone.reference_db = weighted_percentile(entries, settings.reference_percentile or 65)
  zone.current_peak_db = peak_db
  zone.weight = weight_sum
end

local function build_macro_zones(segments, ctx, settings)
  local zones = {}
  local current = nil
  local gap_s = settings.macro_gap_s or 0.9
  local min_zone_s = settings.macro_min_zone_s or 1.2

  for _, segment in ipairs(segments or {}) do
    local start_rel = segment.start_rel or 0
    local end_rel = segment.end_rel or start_rel
    local gap = current and (start_rel - (current.end_rel or start_rel)) or 0
    if current and gap > gap_s and ((current.end_rel or 0) - (current.start_rel or 0)) >= min_zone_s then
      zones[#zones + 1] = current
      current = nil
    end

    if not current then
      current = {
        start_rel = start_rel,
        end_rel = end_rel,
        segments = {}
      }
    end

    current.segments[#current.segments + 1] = segment
    current.end_rel = math.max(current.end_rel or end_rel, end_rel)
  end

  if current then zones[#zones + 1] = current end

  local changed = true
  while changed and #zones > 1 do
    changed = false
    for index, zone in ipairs(zones) do
      local duration = math.max(0, (zone.end_rel or 0) - (zone.start_rel or 0))
      if duration < min_zone_s then
        local merge_with_previous = index > 1 and (index == #zones or macro_zone_gap(zones[index - 1], zone) <= macro_zone_gap(zone, zones[index + 1]))
        if merge_with_previous then
          merge_macro_zone(zones[index - 1], zone)
          table.remove(zones, index)
        else
          merge_macro_zone(zone, zones[index + 1])
          table.remove(zones, index + 1)
        end
        changed = true
        break
      end
    end
  end

  local max_zones = settings.macro_max_zones or 8
  while #zones > max_zones do
    local best_index = 1
    local best_gap = math.huge
    for index = 1, #zones - 1 do
      local gap = macro_zone_gap(zones[index], zones[index + 1])
      if gap < best_gap then
        best_gap = gap
        best_index = index
      end
    end
    merge_macro_zone(zones[best_index], zones[best_index + 1])
    table.remove(zones, best_index + 1)
  end

  for index, zone in ipairs(zones) do
    zone.index = index
    finalize_macro_zone_stats(zone, ctx, settings)
  end

  return zones
end

local function macro_micro_segment_is_protected(segment, zone, settings)
  local zone_reference_db = zone.reference_db or segment.current_db or -150
  local current_db = segment.current_db or -150
  local relative_drop_db = zone_reference_db - current_db
  if relative_drop_db >= (settings.protected_low_relative_db or 12) then return true, "low confidence" end
  if (segment.median_crest_db or 0) >= (settings.protected_crest_db or 18) then return true, "high crest" end
  if (segment.selected_windows or 0) <= 0 then return true, "no sustain windows" end
  return false, nil
end

local function merge_meso_zone(left, right)
  if not left then return right end
  if not right then return left end

  for _, segment in ipairs(right.segments or {}) do
    left.segments[#left.segments + 1] = segment
  end
  left.start_rel = math.min(left.start_rel or right.start_rel or 0, right.start_rel or left.start_rel or 0)
  left.end_rel = math.max(left.end_rel or right.end_rel or 0, right.end_rel or left.end_rel or 0)
  left.segment_count = #left.segments
  return left
end

local function meso_zone_gap(left, right)
  if not left or not right then return math.huge end
  return math.max(0, (right.start_rel or 0) - (left.end_rel or 0))
end

local function finalize_meso_zone_stats(zone, settings)
  local entries = {}
  local weight_sum = 0
  for _, segment in ipairs(zone.segments or {}) do
    local weight = vocal_segment_weight(segment)
    entries[#entries + 1] = {
      value = segment.current_db or -150,
      weight = weight
    }
    weight_sum = weight_sum + weight
  end

  zone.segment_count = #(zone.segments or {})
  zone.duration_s = math.max(0, (zone.end_rel or 0) - (zone.start_rel or 0))
  zone.reference_db = weighted_percentile(entries, settings.reference_percentile or 65)
  zone.weight = weight_sum
end

local function build_meso_zones(segments, settings)
  local zones = {}
  local current = nil
  local gap_s = settings.meso_gap_s or 0.35
  local min_zone_s = settings.meso_min_zone_s or 0.45

  for _, segment in ipairs(segments or {}) do
    local start_rel = segment.start_rel or 0
    local end_rel = segment.end_rel or start_rel
    local gap = current and (start_rel - (current.end_rel or start_rel)) or 0
    if current and gap > gap_s and ((current.end_rel or 0) - (current.start_rel or 0)) >= min_zone_s then
      zones[#zones + 1] = current
      current = nil
    end

    if not current then
      current = {
        start_rel = start_rel,
        end_rel = end_rel,
        segments = {}
      }
    end

    current.segments[#current.segments + 1] = segment
    current.end_rel = math.max(current.end_rel or end_rel, end_rel)
  end

  if current then zones[#zones + 1] = current end

  local changed = true
  while changed and #zones > 1 do
    changed = false
    for index, zone in ipairs(zones) do
      local duration = math.max(0, (zone.end_rel or 0) - (zone.start_rel or 0))
      if duration < min_zone_s then
        local merge_with_previous = index > 1 and (index == #zones or meso_zone_gap(zones[index - 1], zone) <= meso_zone_gap(zone, zones[index + 1]))
        if merge_with_previous then
          merge_meso_zone(zones[index - 1], zone)
          table.remove(zones, index)
        else
          merge_meso_zone(zone, zones[index + 1])
          table.remove(zones, index + 1)
        end
        changed = true
        break
      end
    end
  end

  local max_zones = settings.meso_max_zones_per_macro or 24
  while #zones > max_zones do
    local best_index = 1
    local best_gap = math.huge
    for index = 1, #zones - 1 do
      local gap = meso_zone_gap(zones[index], zones[index + 1])
      if gap < best_gap then
        best_gap = gap
        best_index = index
      end
    end
    merge_meso_zone(zones[best_index], zones[best_index + 1])
    table.remove(zones, best_index + 1)
  end

  for index, zone in ipairs(zones) do
    zone.index = index
    finalize_meso_zone_stats(zone, settings)
  end

  return zones
end

local function classify_gain_direction(gain_db)
  if (gain_db or 0) > 0.001 then return "boost" end
  if (gain_db or 0) < -0.001 then return "cut" end
  return "none"
end

local function apply_macro_micro_vocal_leveling(segments, ctx, settings)
  local zones = build_macro_zones(segments, ctx, settings)
  if not zones or #zones == 0 then return nil, "no macro zones" end

  local target_dbfs = (settings.calibration_db or -18) + (settings.target_vu or 0)
  local item_entries = {}
  for _, segment in ipairs(segments) do
    segment.current_db = vocal_segment_current_db(segment, ctx)
    segment.current_peak_db = vocal_segment_peak_db(segment, ctx)
    item_entries[#item_entries + 1] = {
      value = segment.current_db,
      weight = vocal_segment_weight(segment)
    }
  end

  local item_reference_db = weighted_percentile(item_entries, settings.reference_percentile or 65)
  local item_gain_stage_db = vocal_deadband_gain(
    target_dbfs - (item_reference_db or target_dbfs),
    settings.macro_deadband_db,
    settings.macro_strength,
    settings.macro_max_boost_db,
    settings.macro_max_cut_db
  )

  local report = {
    item_reference_db = item_reference_db,
    item_gain_stage_db = item_gain_stage_db,
    macro_zone_count = #zones,
    macro_zones = {},
    meso_zone_count = 0,
    protected_parts = 0,
    corrected_parts = 0,
    meso_corrected_parts = 0,
    micro_corrected_parts = 0,
    macro_corrected_zones = 0,
    meso_corrected_zones = 0,
    macro_boost_zones = 0,
    macro_cut_zones = 0,
    meso_boost_zones = 0,
    meso_cut_zones = 0,
    safety_protected_parts = 0,
    safety_limited_parts = 0,
    micro_boost_parts = 0,
    micro_cut_parts = 0,
    max_boost_hits = 0,
    max_cut_hits = 0,
    phase_counts = {
      macro = { boost = 0, cut = 0 },
      meso = { boost = 0, cut = 0 },
      micro = { boost = 0, cut = 0 }
    }
  }

  for _, zone in ipairs(zones) do
    local macro_delta = target_dbfs - (zone.reference_db or target_dbfs)
    zone.zone_gain_db = 0
    zone.macro_gain_db = vocal_deadband_gain(
      macro_delta,
      settings.macro_deadband_db,
      settings.macro_strength,
      settings.macro_max_boost_db,
      settings.macro_max_cut_db
    )
    if math.abs(zone.macro_gain_db or 0) > 0.001 then
      report.macro_corrected_zones = report.macro_corrected_zones + 1
      local direction = classify_gain_direction(zone.macro_gain_db)
      if direction == "boost" then
        report.macro_boost_zones = report.macro_boost_zones + 1
        report.phase_counts.macro.boost = report.phase_counts.macro.boost + 1
      elseif direction == "cut" then
        report.macro_cut_zones = report.macro_cut_zones + 1
        report.phase_counts.macro.cut = report.phase_counts.macro.cut + 1
      end
    end

    zone.protected_parts = 0
    zone.corrected_parts = 0
    zone.meso_corrected_parts = 0
    zone.micro_corrected_parts = 0
    zone.meso_zone_count = 0
    zone.meso_corrected_zones = 0
    zone.meso_boost_zones = 0
    zone.meso_cut_zones = 0
    zone.safety_protected_parts = 0
    zone.safety_limited_parts = 0
    zone.micro_boost_parts = 0
    zone.micro_cut_parts = 0

    local meso_zones = build_meso_zones(zone.segments or {}, settings)
    zone.meso_zone_count = #meso_zones
    report.meso_zone_count = report.meso_zone_count + #meso_zones

    for _, meso_zone in ipairs(meso_zones) do
      local meso_delta_db = (zone.reference_db or meso_zone.reference_db or -150) - (meso_zone.reference_db or zone.reference_db or -150)
      meso_zone.meso_gain_db = vocal_deadband_gain(
        meso_delta_db,
        settings.meso_deadband_db,
        settings.meso_strength,
        settings.meso_max_boost_db,
        settings.meso_max_cut_db
      )
      if math.abs(meso_zone.meso_gain_db or 0) > 0.001 then
        report.meso_corrected_zones = report.meso_corrected_zones + 1
        zone.meso_corrected_zones = zone.meso_corrected_zones + 1
        local direction = classify_gain_direction(meso_zone.meso_gain_db)
        if direction == "boost" then
          report.meso_boost_zones = report.meso_boost_zones + 1
          report.phase_counts.meso.boost = report.phase_counts.meso.boost + 1
          zone.meso_boost_zones = zone.meso_boost_zones + 1
        elseif direction == "cut" then
          report.meso_cut_zones = report.meso_cut_zones + 1
          report.phase_counts.meso.cut = report.phase_counts.meso.cut + 1
          zone.meso_cut_zones = zone.meso_cut_zones + 1
        end
      end

      for _, segment in ipairs(meso_zone.segments or {}) do
        segment.macro_zone_index = zone.index
        segment.meso_zone_index = meso_zone.index
        segment.macro_reference_db = zone.reference_db
        segment.meso_reference_db = meso_zone.reference_db
        segment.item_gain_stage_db = item_gain_stage_db
        segment.zone_gain_db = zone.zone_gain_db
        segment.macro_gain_db = zone.macro_gain_db
        segment.meso_gain_db = meso_zone.meso_gain_db

        local local_delta_db = (meso_zone.reference_db or segment.current_db or -150) - (segment.current_db or -150)
        local protected, protected_reason = macro_micro_segment_is_protected(segment, zone, settings)
        local already_good = math.abs(local_delta_db) <= (settings.already_good_db or 1)
        local micro_gain_db = 0
        local correction_stage = "deadband"

        if already_good then
          segment.already_good = true
          correction_stage = "already_good"
        elseif settings.micro_repair ~= false then
          if local_delta_db < -math.max(settings.micro_deadband_db or 1.5, 0) then
            micro_gain_db = clamp(
              local_delta_db * (settings.micro_cut_strength or 0.55),
              -(settings.micro_max_cut_db or 3),
              0
            )
            correction_stage = "micro_cut"
          elseif local_delta_db >= (settings.micro_clear_drop_db or 4) then
            micro_gain_db = clamp(
              local_delta_db * (settings.micro_boost_strength or 0.45),
              0,
              settings.micro_max_boost_db or 2.5
            )
            correction_stage = "micro_boost"
            if protected then
              micro_gain_db = math.min(micro_gain_db, settings.protected_max_boost_db or 0)
              correction_stage = "protected"
            end
          elseif local_delta_db > (settings.micro_deadband_db or 1.5) then
            correction_stage = "low_not_clear"
          end
        end

        local detail_gain_db = (meso_zone.meso_gain_db or 0) + micro_gain_db
        if protected and detail_gain_db > (settings.protected_max_boost_db or 0) then
          detail_gain_db = settings.protected_max_boost_db or 0
          correction_stage = "protected"
        end
        local requested_gain_db = (zone.macro_gain_db or 0) + detail_gain_db
        local safety_limited = false
        if protected and requested_gain_db > (settings.protected_max_boost_db or 0) then
          requested_gain_db = settings.protected_max_boost_db or 0
          detail_gain_db = requested_gain_db - (zone.macro_gain_db or 0)
          safety_limited = true
          correction_stage = "protected"
        end
        local envelope = limit_vocal_envelope_gain(requested_gain_db, ctx, {
          source_peak_db = segment.raw_peak_db,
          source_rms_db = segment.measured_db,
          sustain_db = segment.sustain_db,
          limited_by_peak = segment.limited_by_peak,
          limited_by_max_boost = segment.limited_by_max_boost,
          limited_by_max_cut = segment.limited_by_max_cut
        }, settings)
        if envelope.unresolved_peak then
          return nil, "peak ceiling requires more cut than max-cut"
        end

        local effective_detail_gain_db = envelope.gain_db - (zone.macro_gain_db or 0)
        segment.detail_gain_db = effective_detail_gain_db
        segment.requested_detail_gain_db = detail_gain_db
        segment.micro_gain_db = micro_gain_db
        segment.gain_db = envelope.gain_db
        segment.take_gain_db = envelope.take_gain_db
        segment.final_peak_db = envelope.final_peak_db
        segment.final_vu = envelope.final_vu
        segment.limited_by_peak = envelope.limited_by_peak
        segment.limited_by_max_boost = envelope.limited_by_max_boost
        segment.limited_by_max_cut = envelope.limited_by_max_cut
        segment.correction_stage = correction_stage
        segment.safety_protected = protected
        segment.safety_limited = safety_limited
        local meso_applied = (not safety_limited) and math.abs(meso_zone.meso_gain_db or 0) > 0.001 and math.abs(effective_detail_gain_db) > 0.001
        local micro_applied = (not safety_limited) and math.abs(micro_gain_db or 0) > 0.001 and math.abs(effective_detail_gain_db) > 0.001
        local segment_corrected = (not safety_limited) and math.abs(effective_detail_gain_db) > 0.001
        segment.protected = protected or (not segment_corrected and (already_good or correction_stage == "deadband" or correction_stage == "low_not_clear"))
        segment.protected_reason = protected_reason
        segment.local_delta_db = local_delta_db

        if segment.protected then
          report.protected_parts = report.protected_parts + 1
          zone.protected_parts = zone.protected_parts + 1
        end

        if segment.safety_protected then
          report.safety_protected_parts = report.safety_protected_parts + 1
          zone.safety_protected_parts = zone.safety_protected_parts + 1
        end

        if segment.safety_limited then
          report.safety_limited_parts = report.safety_limited_parts + 1
          zone.safety_limited_parts = zone.safety_limited_parts + 1
        end

        if segment_corrected then
          report.corrected_parts = report.corrected_parts + 1
          zone.corrected_parts = zone.corrected_parts + 1
        end

        if meso_applied then
          report.meso_corrected_parts = report.meso_corrected_parts + 1
          zone.meso_corrected_parts = zone.meso_corrected_parts + 1
        end

        if micro_applied then
          report.micro_corrected_parts = report.micro_corrected_parts + 1
          zone.micro_corrected_parts = zone.micro_corrected_parts + 1
          local direction = classify_gain_direction(micro_gain_db)
          if direction == "boost" then
            report.micro_boost_parts = report.micro_boost_parts + 1
            report.phase_counts.micro.boost = report.phase_counts.micro.boost + 1
            zone.micro_boost_parts = zone.micro_boost_parts + 1
          elseif direction == "cut" then
            report.micro_cut_parts = report.micro_cut_parts + 1
            report.phase_counts.micro.cut = report.phase_counts.micro.cut + 1
            zone.micro_cut_parts = zone.micro_cut_parts + 1
          end
        end

        if segment.limited_by_max_boost then report.max_boost_hits = report.max_boost_hits + 1 end
        if segment.limited_by_max_cut then report.max_cut_hits = report.max_cut_hits + 1 end
      end
    end

    report.macro_zones[#report.macro_zones + 1] = {
      index = zone.index,
      start_rel = zone.start_rel,
      end_rel = zone.end_rel,
      duration_s = zone.duration_s,
      segments = zone.segment_count,
      reference_db = zone.reference_db,
      item_gain_stage_db = item_gain_stage_db,
      zone_gain_db = zone.zone_gain_db,
      macro_gain_db = zone.macro_gain_db,
      meso_zones = zone.meso_zone_count,
      meso_corrected_zones = zone.meso_corrected_zones,
      meso_boost_zones = zone.meso_boost_zones,
      meso_cut_zones = zone.meso_cut_zones,
      protected_parts = zone.protected_parts,
      safety_protected_parts = zone.safety_protected_parts,
      safety_limited_parts = zone.safety_limited_parts,
      corrected_parts = zone.corrected_parts,
      meso_corrected_parts = zone.meso_corrected_parts,
      micro_corrected_parts = zone.micro_corrected_parts,
      micro_boost_parts = zone.micro_boost_parts,
      micro_cut_parts = zone.micro_cut_parts
    }
  end

  return report
end

local function analyze_item_for_vocal_level(item, settings)
  local ctx, context_error = item_audio_context(item)
  if not ctx then return nil, context_error end

  local normalized_for_analysis = not settings.preview
  local ok_measure, result_or_error, reason_or_nil = pcall(function()
    if normalized_for_analysis then
      reaper.SetMediaItemInfo_Value(item, "D_VOL", 1)
      reaper.SetMediaItemTakeInfo_Value(ctx.take, "D_VOL", ctx.take_sign)
    end

    local accessor = reaper.CreateTakeAudioAccessor(ctx.take)
    if not accessor then error("could not create audio accessor") end

    local ok_accessor, result, skip_reason = pcall(function()
      reaper.AudioAccessorUpdate(accessor)
      local analysis_start, analysis_end = audio_accessor_range(accessor, ctx.item_start, ctx.item_end)

      local detection, detection_reason = detect_vocal_parts(
        accessor,
        ctx.sample_rate,
        ctx.channels,
        analysis_start,
        analysis_end,
        settings
      )
      if not detection then return nil, detection_reason end

      local segments = {}
      for part_index, part in ipairs(detection.parts) do
        local range_analysis, range_reason = analyze_audio_range_for_vocal_part(
          accessor,
          ctx.sample_rate,
          ctx.channels,
          part.start,
          part["end"],
          settings
        )

        if range_analysis then
          local envelope = nil
          if settings.level_mode == "macro_micro" then
            envelope = {
              gain_db = 0,
              take_gain_db = ctx.original_combined_db,
              final_peak_db = (range_analysis.source_peak_db or -150) + (ctx.original_combined_db or 0),
              final_vu = (range_analysis.source_rms_db or range_analysis.sustain_db or -150) + (ctx.original_combined_db or 0) - (settings.calibration_db or -18),
              limited_by_peak = false,
              limited_by_max_boost = false,
              limited_by_max_cut = false
            }
          else
            envelope = limit_vocal_envelope_gain(range_analysis.target_take_db - ctx.original_combined_db, ctx, range_analysis, settings)
            if envelope.unresolved_peak then
              return nil, "peak ceiling requires more cut than max-cut"
            end
          end
          local ramp = math.min(settings.ramp_s, math.max(0, (part["end"] - part.start) / 4))
          local start_rel = math.max(0, part.start - analysis_start)
          local end_rel = math.min(ctx.item_length, part["end"] - analysis_start)
          segments[#segments + 1] = {
            part_index = part_index,
            start = ctx.item_start + start_rel,
            ["end"] = ctx.item_start + end_rel,
            raw_start = part.raw_start,
            raw_end = part.raw_end,
            accessor_start = part.start,
            accessor_end = part["end"],
            start_rel = start_rel,
            end_rel = end_rel,
            length = part["end"] - part.start,
            ramp = ramp,
            gain_db = envelope.gain_db,
            take_gain_db = envelope.take_gain_db,
            measured_db = range_analysis.source_rms_db,
            sustain_db = range_analysis.sustain_db,
            source_peak_db = range_analysis.source_peak_db,
            raw_peak_db = range_analysis.source_peak_db,
            final_peak_db = envelope.final_peak_db,
            final_vu = envelope.final_vu,
            windows = range_analysis.windows,
            selected_windows = range_analysis.selected_windows,
            excluded_windows = range_analysis.excluded_windows,
            transient_windows = range_analysis.transient_windows,
            median_crest_db = range_analysis.median_crest_db,
            transient_threshold_db = range_analysis.transient_threshold_db,
            detection_windows = part.windows,
            limited_by_peak = envelope.limited_by_peak,
            limited_by_max_boost = envelope.limited_by_max_boost,
            limited_by_max_cut = envelope.limited_by_max_cut
          }
        elseif range_reason and range_reason ~= "silent item" then
          -- Detection only sets boundaries; unusable ranges are skipped instead of guessed.
        end
      end

      if #segments == 0 then return nil, "no usable vocal parts" end
      local detected_segment_count = #segments
      local relative_report = nil
      local macro_micro_report = nil
      if settings.level_mode == "relative" then
        relative_report = apply_relative_vocal_stabilization(segments, ctx, settings)
        segments = consolidate_vocal_level_segments(segments, settings)
      elseif settings.level_mode == "macro_micro" then
        local macro_report, macro_reason = apply_macro_micro_vocal_leveling(segments, ctx, settings)
        if not macro_report then return nil, macro_reason end
        macro_micro_report = macro_report
      else
        segments = consolidate_vocal_level_segments(segments, settings)
      end

      local analysis = {
        item_start = ctx.item_start,
        item_length = ctx.item_length,
        accessor_start = analysis_start,
        accessor_end = analysis_end,
        original_combined_db = ctx.original_combined_db,
        level_mode = settings.level_mode,
        reference_db = relative_report and relative_report.reference_db or nil,
        average_raw_correction_db = relative_report and relative_report.average_raw_correction_db or nil,
        average_final_correction_db = relative_report and relative_report.average_final_correction_db or nil,
        macro_micro = macro_micro_report,
        macro_zones = macro_micro_report and macro_micro_report.macro_zones or nil,
        macro_zone_count = macro_micro_report and macro_micro_report.macro_zone_count or 0,
        meso_zone_count = macro_micro_report and macro_micro_report.meso_zone_count or 0,
        macro_item_reference_db = macro_micro_report and macro_micro_report.item_reference_db or nil,
        macro_item_gain_stage_db = macro_micro_report and macro_micro_report.item_gain_stage_db or nil,
        macro_corrected_zones = macro_micro_report and macro_micro_report.macro_corrected_zones or 0,
        meso_corrected_zones = macro_micro_report and macro_micro_report.meso_corrected_zones or 0,
        macro_boost_zones = macro_micro_report and macro_micro_report.macro_boost_zones or 0,
        macro_cut_zones = macro_micro_report and macro_micro_report.macro_cut_zones or 0,
        meso_boost_zones = macro_micro_report and macro_micro_report.meso_boost_zones or 0,
        meso_cut_zones = macro_micro_report and macro_micro_report.meso_cut_zones or 0,
        micro_boost_parts = macro_micro_report and macro_micro_report.micro_boost_parts or 0,
        micro_cut_parts = macro_micro_report and macro_micro_report.micro_cut_parts or 0,
        phase_counts = macro_micro_report and macro_micro_report.phase_counts or nil,
        protected_parts = macro_micro_report and macro_micro_report.protected_parts or 0,
        safety_protected_parts = macro_micro_report and macro_micro_report.safety_protected_parts or 0,
        safety_limited_parts = macro_micro_report and macro_micro_report.safety_limited_parts or 0,
        corrected_parts = macro_micro_report and macro_micro_report.corrected_parts or 0,
        meso_corrected_parts = macro_micro_report and macro_micro_report.meso_corrected_parts or 0,
        micro_corrected_parts = macro_micro_report and macro_micro_report.micro_corrected_parts or 0,
        automation_mode = settings.automation_mode,
        settings = settings,
        zero_crossing_enabled = settings.zero_crossing_enabled,
        ramp_s = settings.ramp_s,
        detection_window_count = detection.window_count,
        active_window_count = detection.active_window_count,
        active_floor_db = detection.active_floor_db,
        detected_segment_count = detected_segment_count,
        part_count = #segments,
        segments = segments
      }
      if settings.post_level_report then
        analysis.post_level_measurement = measure_vocal_level_result(analysis, settings)
      end
      return analysis
    end)

    reaper.DestroyAudioAccessor(accessor)
    if not ok_accessor then error(result) end
    return result, skip_reason
  end)

  if normalized_for_analysis then
    reaper.SetMediaItemTakeInfo_Value(ctx.take, "D_VOL", ctx.original_take_gain)
    reaper.SetMediaItemInfo_Value(item, "D_VOL", ctx.original_item_gain)
  end
  if not ok_measure then error(result_or_error) end
  return result_or_error, reason_or_nil
end

local function envelope_point_count(env)
  if reaper.CountEnvelopePoints then return reaper.CountEnvelopePoints(env) end
  if reaper.CountEnvelopePointsEx then return reaper.CountEnvelopePointsEx(env, -1) end
  return 0
end

local function take_volume_envelope_value(env, gain)
  local mode = reaper.GetEnvelopeScalingMode and reaper.GetEnvelopeScalingMode(env) or 0
  if reaper.ScaleToEnvelopeMode then
    return reaper.ScaleToEnvelopeMode(mode, gain)
  end
  return gain
end

local function snapshot_selected_items()
  local selected = {}
  for i = 0, reaper.CountSelectedMediaItems(0) - 1 do
    selected[#selected + 1] = reaper.GetSelectedMediaItem(0, i)
  end
  return selected
end

local function restore_selected_items(selected)
  reaper.SelectAllMediaItems(0, false)
  for _, item in ipairs(selected) do
    if item then reaper.SetMediaItemSelected(item, true) end
  end
end

local function ensure_take_volume_envelope(item, take)
  if not reaper.GetTakeEnvelopeByName then return nil, "take envelope API unavailable" end
  local env = reaper.GetTakeEnvelopeByName(take, "Volume")
  if env then return env, false end

  if not reaper.Main_OnCommand then return nil, "could not create take volume envelope" end
  local selected = snapshot_selected_items()
  reaper.SelectAllMediaItems(0, false)
  reaper.SetMediaItemSelected(item, true)
  reaper.Main_OnCommand(40693, 0)
  restore_selected_items(selected)

  env = reaper.GetTakeEnvelopeByName(take, "Volume")
  if not env then return nil, "could not create take volume envelope" end
  if reaper.GetSetEnvelopeInfo_String then
    reaper.GetSetEnvelopeInfo_String(env, "ACTIVE", "1", true)
    reaper.GetSetEnvelopeInfo_String(env, "VISIBLE", "1", true)
  end
  return env, true
end

append_vocal_level_point = function(points, time, gain_db, shape)
  local point = {
    time = time,
    gain_db = gain_db,
    shape = shape or 0
  }
  local last = points[#points]
  if last
      and math.abs(last.time - point.time) < 0.000001
      and math.abs(last.gain_db - point.gain_db) < 0.000001
      and (last.shape or 0) == (point.shape or 0) then
    last.gain_db = point.gain_db
    last.shape = point.shape
  else
    points[#points + 1] = point
  end
end

local function build_vocal_level_points(analysis)
  if analysis.automation_mode == "smooth_curve" then
    return build_vocal_level_curve_points(analysis)
  end

  local points = {}
  local use_zero_crossing_steps = analysis.zero_crossing_enabled and (analysis.ramp_s or 0) <= 0
  local shape = use_zero_crossing_steps and 1 or 0

  append_vocal_level_point(points, 0, 0, shape)

  if use_zero_crossing_steps then
    for index, segment in ipairs(analysis.segments) do
      local start_rel = clamp(segment.start_rel, 0, analysis.item_length)
      local end_rel = clamp(segment.end_rel, 0, analysis.item_length)
      local next_segment = analysis.segments[index + 1]
      local next_start = next_segment and clamp(next_segment.start_rel, 0, analysis.item_length) or nil
      local leaves_to_silence = not next_start or next_start - end_rel > 0.001

      append_vocal_level_point(points, start_rel, segment.gain_db, shape)
      if leaves_to_silence then
        append_vocal_level_point(points, end_rel, 0, shape)
      end
    end

    append_vocal_level_point(points, analysis.item_length, 0, shape)
    return points
  end

  for index, segment in ipairs(analysis.segments) do
    local start_rel = clamp(segment.start_rel, 0, analysis.item_length)
    local end_rel = clamp(segment.end_rel, 0, analysis.item_length)
    local ramp = math.min(segment.ramp or 0, math.max(0, (end_rel - start_rel) / 4))

    local previous = analysis.segments[index - 1]
    local next_segment = analysis.segments[index + 1]
    local previous_end = previous and clamp(previous.end_rel, 0, analysis.item_length) or nil
    local next_start = next_segment and clamp(next_segment.start_rel, 0, analysis.item_length) or nil
    local enters_from_silence = not previous_end or start_rel - previous_end > 0.001
    local leaves_to_silence = not next_start or next_start - end_rel > 0.001

    if enters_from_silence then
      append_vocal_level_point(points, math.max(0, start_rel - ramp), 0, shape)
    end
    append_vocal_level_point(points, start_rel, segment.gain_db, shape)
    append_vocal_level_point(points, end_rel, segment.gain_db, shape)
    if leaves_to_silence then
      append_vocal_level_point(points, math.min(analysis.item_length, end_rel + ramp), 0, shape)
    end
  end
  append_vocal_level_point(points, analysis.item_length, 0, shape)
  return points
end

local function insert_vocal_level_points(env, analysis, clear_existing)
  if clear_existing and reaper.DeleteEnvelopePointRange then
    reaper.DeleteEnvelopePointRange(env, -1, analysis.item_length + 1)
  end

  local points = build_vocal_level_points(analysis)
  for _, point in ipairs(points) do
    local value = take_volume_envelope_value(env, db_to_gain(point.gain_db))
    local ok = reaper.InsertEnvelopePoint(env, point.time, value, point.shape or 0, 0, false, true)
    if not ok then error("could not insert envelope point") end
  end

  if reaper.Envelope_SortPoints then reaper.Envelope_SortPoints(env) end
  return #points
end

local function command_vocal_level_items(command)
  local settings = vocal_level_settings(command)
  local item_filter = command.itemFilter or { type = "selected" }
  if item_filter.type ~= "selected" then
    error("vocal-level only supports selected items")
  end

  local items = collect_items(item_filter)
  if command.selectedItemIndex then
    local selected_index = math.floor(tonumber(command.selectedItemIndex) or 0)
    if selected_index >= 1 and selected_index <= #items then
      items = { items[selected_index] }
    else
      items = {}
    end
  end

  local processed = 0
  local skipped = 0
  local total_detected_segments = 0
  local total_segments = 0
  local total_macro_zones = 0
  local total_meso_zones = 0
  local total_macro_corrected_zones = 0
  local total_meso_corrected_zones = 0
  local total_macro_boost_zones = 0
  local total_macro_cut_zones = 0
  local total_meso_boost_zones = 0
  local total_meso_cut_zones = 0
  local total_protected_parts = 0
  local total_safety_protected_parts = 0
  local total_safety_limited_parts = 0
  local total_corrected_parts = 0
  local total_meso_corrected_parts = 0
  local total_micro_corrected_parts = 0
  local total_micro_boost_parts = 0
  local total_micro_cut_parts = 0
  local total_points = 0
  local total_selected_windows = 0
  local total_excluded_windows = 0
  local total_transient_windows = 0
  local sum_gain_db = 0
  local sum_reference_db = 0
  local reference_count = 0
  local sum_average_final_correction_db = 0
  local sum_macro_item_gain_stage_db = 0
  local macro_item_gain_stage_count = 0
  local min_gain_db = nil
  local max_gain_db = nil
  local max_point_density_per_minute = 0
  local point_density_warnings = 0
  local point_density_rejects = 0
  local limited_by_peak = 0
  local limited_by_max_boost = 0
  local limited_by_max_cut = 0
  local warnings = {}
  local examples = {}
  local macro_zone_examples = {}
  local post_level_examples = {}
  local skip_reasons = {}
  local post_level_items = 0
  local sum_post_before_stdev_db = 0
  local sum_post_after_stdev_db = 0
  local sum_post_before_spread_db = 0
  local sum_post_after_spread_db = 0
  local sum_post_stdev_improvement_db = 0
  local sum_post_spread_improvement_db = 0
  local total_post_peak_outliers = 0
  local total_post_glottal_outliers = 0
  local total_post_unresolved_peak_outliers = 0
  local total_post_protected_parts = 0
  local total_post_boosted_protected_parts = 0
  local total_post_boosted_low_energy_parts = 0
  local max_post_after_peak_db = nil
  local post_level_mode = nil

  local function record_skip(item, reason)
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
  end

  for item_index, item in ipairs(items) do
    local take = reaper.GetActiveTake(item)
    local existing_env = take and reaper.GetTakeEnvelopeByName and reaper.GetTakeEnvelopeByName(take, "Volume") or nil
    if command.leaveFirstSelected == true and item_index == 1 then
      record_skip(item, "left unedited control item")
    elseif existing_env and envelope_point_count(existing_env) > 0 and not settings.replace_envelope then
      record_skip(item, "existing take volume envelope")
    else
      local ok, analysis, reason = pcall(analyze_item_for_vocal_level, item, settings)
      if not ok then
        record_skip(item, tostring(analysis))
      elseif not analysis then
        record_skip(item, reason)
      else
        local point_count = 0
        if settings.preview then
          point_count = #build_vocal_level_points(analysis)
        else
          local env, created_or_error = ensure_take_volume_envelope(item, take)
          if not env then
            record_skip(item, created_or_error)
          else
            point_count = insert_vocal_level_points(env, analysis, created_or_error == true or settings.replace_envelope == true)
            if point_count > 0 and settings.post_level_report then
              analysis.post_level_measurement = measure_vocal_level_result(analysis, settings, env, "applied_take_envelope")
            end
          end
        end

        if settings.preview or point_count > 0 then
          processed = processed + 1
          if not settings.preview and point_count > 0 and command.variantLabel and tostring(command.variantLabel) ~= "" then
            local track = reaper.GetMediaItemTrack(item)
            if track and reaper.GetSetMediaTrackInfo_String then
              reaper.GetSetMediaTrackInfo_String(track, "P_NAME", tostring(command.variantLabel), true)
            end
          end
          total_detected_segments = total_detected_segments + (analysis.detected_segment_count or #analysis.segments)
          total_segments = total_segments + #analysis.segments
          total_points = total_points + point_count
          if analysis.reference_db then
            sum_reference_db = sum_reference_db + analysis.reference_db
            reference_count = reference_count + 1
          end
          if analysis.average_final_correction_db then
            sum_average_final_correction_db = sum_average_final_correction_db + analysis.average_final_correction_db
          end
          total_macro_zones = total_macro_zones + (analysis.macro_zone_count or 0)
          total_meso_zones = total_meso_zones + (analysis.meso_zone_count or 0)
          total_macro_corrected_zones = total_macro_corrected_zones + (analysis.macro_corrected_zones or 0)
          total_meso_corrected_zones = total_meso_corrected_zones + (analysis.meso_corrected_zones or 0)
          total_macro_boost_zones = total_macro_boost_zones + (analysis.macro_boost_zones or 0)
          total_macro_cut_zones = total_macro_cut_zones + (analysis.macro_cut_zones or 0)
          total_meso_boost_zones = total_meso_boost_zones + (analysis.meso_boost_zones or 0)
          total_meso_cut_zones = total_meso_cut_zones + (analysis.meso_cut_zones or 0)
          total_protected_parts = total_protected_parts + (analysis.protected_parts or 0)
          total_safety_protected_parts = total_safety_protected_parts + (analysis.safety_protected_parts or 0)
          total_safety_limited_parts = total_safety_limited_parts + (analysis.safety_limited_parts or 0)
          total_corrected_parts = total_corrected_parts + (analysis.corrected_parts or 0)
          total_meso_corrected_parts = total_meso_corrected_parts + (analysis.meso_corrected_parts or 0)
          total_micro_corrected_parts = total_micro_corrected_parts + (analysis.micro_corrected_parts or 0)
          total_micro_boost_parts = total_micro_boost_parts + (analysis.micro_boost_parts or 0)
          total_micro_cut_parts = total_micro_cut_parts + (analysis.micro_cut_parts or 0)
          if analysis.macro_item_gain_stage_db then
            sum_macro_item_gain_stage_db = sum_macro_item_gain_stage_db + analysis.macro_item_gain_stage_db
            macro_item_gain_stage_count = macro_item_gain_stage_count + 1
          end
          if analysis.post_level_measurement then
            local measurement = analysis.post_level_measurement
            post_level_items = post_level_items + 1
            post_level_mode = post_level_mode or measurement.mode
            sum_post_before_stdev_db = sum_post_before_stdev_db + ((measurement.before and measurement.before.stdev_db) or 0)
            sum_post_after_stdev_db = sum_post_after_stdev_db + ((measurement.after and measurement.after.stdev_db) or 0)
            sum_post_before_spread_db = sum_post_before_spread_db + ((measurement.before and measurement.before.spread_db) or 0)
            sum_post_after_spread_db = sum_post_after_spread_db + ((measurement.after and measurement.after.spread_db) or 0)
            sum_post_stdev_improvement_db = sum_post_stdev_improvement_db + ((measurement.improvement and measurement.improvement.stdev_db) or 0)
            sum_post_spread_improvement_db = sum_post_spread_improvement_db + ((measurement.improvement and measurement.improvement.spread_db) or 0)
            total_post_peak_outliers = total_post_peak_outliers + (measurement.peak_outliers or 0)
            total_post_glottal_outliers = total_post_glottal_outliers + (measurement.glottal_outliers or 0)
            total_post_unresolved_peak_outliers = total_post_unresolved_peak_outliers + (measurement.unresolved_peak_outliers or 0)
            total_post_protected_parts = total_post_protected_parts + ((measurement.silence_breath_safety and measurement.silence_breath_safety.protected_parts) or 0)
            total_post_boosted_protected_parts = total_post_boosted_protected_parts + ((measurement.silence_breath_safety and measurement.silence_breath_safety.boosted_protected_parts) or 0)
            total_post_boosted_low_energy_parts = total_post_boosted_low_energy_parts + ((measurement.silence_breath_safety and measurement.silence_breath_safety.boosted_low_energy_parts) or 0)
            if measurement.max_after_peak_db then
              max_post_after_peak_db = max_post_after_peak_db and math.max(max_post_after_peak_db, measurement.max_after_peak_db) or measurement.max_after_peak_db
            end
            if #post_level_examples < 12 then
              local summary = item_summary(item)
              post_level_examples[#post_level_examples + 1] = {
                track = summary.track,
                item_index = summary.item_index,
                mode = measurement.mode,
                before = measurement.before,
                after = measurement.after,
                improvement = measurement.improvement,
                macro_balance = measurement.macro_balance,
                meso_balance = measurement.meso_balance,
                peak_outliers = measurement.peak_outliers,
                glottal_outliers = measurement.glottal_outliers,
                unresolved_peak_outliers = measurement.unresolved_peak_outliers,
                silence_breath_safety = measurement.silence_breath_safety,
                max_after_peak_db = measurement.max_after_peak_db
              }
            end
          end

          local duration_minutes = math.max(analysis.item_length or 0, 0.001) / 60
          local point_density = point_count / duration_minutes
          if point_density > max_point_density_per_minute then max_point_density_per_minute = point_density end
          if point_density > (settings.point_density_reject_per_minute or 100) then
            point_density_rejects = point_density_rejects + 1
            if #warnings < 12 then
              local summary = item_summary(item)
              warnings[#warnings + 1] = {
                reason = "point density reject threshold exceeded",
                track = summary.track,
                item_index = summary.item_index,
                point_density_per_minute = point_density
              }
            end
          elseif point_density > (settings.point_density_warn_per_minute or 70) then
            point_density_warnings = point_density_warnings + 1
            if #warnings < 12 then
              local summary = item_summary(item)
              warnings[#warnings + 1] = {
                reason = "point density warning threshold exceeded",
                track = summary.track,
                item_index = summary.item_index,
                point_density_per_minute = point_density
              }
            end
          end

          if analysis.macro_zones then
            for _, zone in ipairs(analysis.macro_zones) do
              if #macro_zone_examples < 12 then
                local summary = item_summary(item)
                macro_zone_examples[#macro_zone_examples + 1] = {
                  track = summary.track,
                  item_index = summary.item_index,
                  index = zone.index,
                  start_rel = zone.start_rel,
                  end_rel = zone.end_rel,
                  duration_s = zone.duration_s,
                  segments = zone.segments,
                  reference_db = zone.reference_db,
                  item_gain_stage_db = zone.item_gain_stage_db,
                  zone_gain_db = zone.zone_gain_db,
                  macro_gain_db = zone.macro_gain_db,
                  meso_zones = zone.meso_zones,
                  meso_corrected_zones = zone.meso_corrected_zones,
                  meso_boost_zones = zone.meso_boost_zones,
                  meso_cut_zones = zone.meso_cut_zones,
                  protected_parts = zone.protected_parts,
                  safety_protected_parts = zone.safety_protected_parts,
                  safety_limited_parts = zone.safety_limited_parts,
                  corrected_parts = zone.corrected_parts,
                  meso_corrected_parts = zone.meso_corrected_parts,
                  micro_corrected_parts = zone.micro_corrected_parts,
                  micro_boost_parts = zone.micro_boost_parts,
                  micro_cut_parts = zone.micro_cut_parts
                }
              end
            end
          end

          for _, segment in ipairs(analysis.segments) do
            sum_gain_db = sum_gain_db + segment.gain_db
            total_selected_windows = total_selected_windows + (segment.selected_windows or 0)
            total_excluded_windows = total_excluded_windows + (segment.excluded_windows or 0)
            total_transient_windows = total_transient_windows + (segment.transient_windows or 0)
            min_gain_db = min_gain_db and math.min(min_gain_db, segment.gain_db) or segment.gain_db
            max_gain_db = max_gain_db and math.max(max_gain_db, segment.gain_db) or segment.gain_db
            if segment.limited_by_peak then limited_by_peak = limited_by_peak + 1 end
            if segment.limited_by_max_boost then limited_by_max_boost = limited_by_max_boost + 1 end
            if segment.limited_by_max_cut then limited_by_max_cut = limited_by_max_cut + 1 end

            if #examples < 12 then
              local summary = item_summary(item)
              examples[#examples + 1] = {
                track = summary.track,
                item_index = summary.item_index,
                part_index = segment.part_index,
                start = segment.start,
                ["end"] = segment["end"],
                raw_start = segment.raw_start,
                raw_end = segment.raw_end,
                merged_parts = segment.merged_parts,
                current_db = segment.current_db,
                current_peak_db = segment.current_peak_db,
                reference_db = segment.reference_db,
                relative_gain_db = segment.relative_gain_db,
                absolute_gain_db = segment.absolute_gain_db,
                macro_zone_index = segment.macro_zone_index,
                meso_zone_index = segment.meso_zone_index,
                macro_reference_db = segment.macro_reference_db,
                meso_reference_db = segment.meso_reference_db,
                item_gain_stage_db = segment.item_gain_stage_db,
                zone_gain_db = segment.zone_gain_db,
                macro_gain_db = segment.macro_gain_db,
                meso_gain_db = segment.meso_gain_db,
                micro_gain_db = segment.micro_gain_db,
                detail_gain_db = segment.detail_gain_db,
                requested_detail_gain_db = segment.requested_detail_gain_db,
                correction_stage = segment.correction_stage,
                protected = segment.protected,
                safety_protected = segment.safety_protected,
                safety_limited = segment.safety_limited,
                protected_reason = segment.protected_reason,
                already_good = segment.already_good,
                local_delta_db = segment.local_delta_db,
                gain_db = segment.gain_db,
                take_gain_db = segment.take_gain_db,
                measured_db = segment.measured_db,
                sustain_db = segment.sustain_db,
                raw_peak_db = segment.raw_peak_db,
                final_vu = segment.final_vu,
                final_peak_db = segment.final_peak_db,
                windows = segment.windows,
                selected_windows = segment.selected_windows,
                excluded_windows = segment.excluded_windows,
                transient_windows = segment.transient_windows,
                limited_by_peak = segment.limited_by_peak,
                limited_by_max_boost = segment.limited_by_max_boost,
                limited_by_max_cut = segment.limited_by_max_cut
              }
            end
          end
        end
      end
    end
  end

  reaper.UpdateArrange()
  return {
    preview = settings.preview,
    leave_first_selected = command.leaveFirstSelected == true,
    selected_item_index = command.selectedItemIndex,
    variant_label = command.variantLabel,
    matched = #items,
    processed = processed,
    applied = settings.preview and 0 or processed,
    skipped = skipped,
    detected_parts = total_detected_segments,
    parts = total_segments,
    segments = total_segments,
    macro_zones = total_macro_zones,
    meso_zones = total_meso_zones,
    macro_corrected_zones = total_macro_corrected_zones,
    meso_corrected_zones = total_meso_corrected_zones,
    macro_boost_zones = total_macro_boost_zones,
    macro_cut_zones = total_macro_cut_zones,
    meso_boost_zones = total_meso_boost_zones,
    meso_cut_zones = total_meso_cut_zones,
    protected_parts = total_protected_parts,
    safety_protected_parts = total_safety_protected_parts,
    safety_limited_parts = total_safety_limited_parts,
    corrected_parts = total_corrected_parts,
    meso_corrected_parts = total_meso_corrected_parts,
    micro_corrected_parts = total_micro_corrected_parts,
    micro_boost_parts = total_micro_boost_parts,
    micro_cut_parts = total_micro_cut_parts,
    phase_counts = {
      macro = {
        boost = total_macro_boost_zones,
        cut = total_macro_cut_zones
      },
      meso = {
        boost = total_meso_boost_zones,
        cut = total_meso_cut_zones
      },
      micro = {
        boost = total_micro_boost_parts,
        cut = total_micro_cut_parts
      }
    },
    estimated_points = total_points,
    points = settings.preview and 0 or total_points,
    envelope_points_written = settings.preview and 0 or total_points,
    point_density_per_minute = max_point_density_per_minute,
    point_density_warn_per_minute = settings.point_density_warn_per_minute,
    point_density_reject_per_minute = settings.point_density_reject_per_minute,
    point_density_warnings = point_density_warnings,
    point_density_rejects = point_density_rejects,
    selected_windows = total_selected_windows,
    excluded_windows = total_excluded_windows,
    transient_windows = total_transient_windows,
    calibration_db = settings.calibration_db,
    target_vu = settings.target_vu,
    peak_ceiling_db = settings.peak_ceiling_db,
    max_boost_db = settings.max_boost_db,
    max_cut_db = settings.max_cut_db,
    replace_envelope = settings.replace_envelope,
    window_ms = settings.window_ms,
    silence_db = settings.silence_db,
    top_window_percent = settings.top_window_fraction * 100,
    measurement_mode = settings.measurement_mode,
    level_mode = settings.level_mode,
    reference_percentile = settings.reference_percentile,
    reference_db = reference_count > 0 and (sum_reference_db / reference_count) or nil,
    average_final_correction_db = reference_count > 0 and (sum_average_final_correction_db / reference_count) or nil,
    macro_item_gain_stage_db = macro_item_gain_stage_count > 0 and (sum_macro_item_gain_stage_db / macro_item_gain_stage_count) or nil,
    macro_gap_ms = settings.macro_gap_s * 1000,
    macro_min_zone_ms = settings.macro_min_zone_s * 1000,
    macro_max_zones = settings.macro_max_zones,
    macro_strength = settings.macro_strength,
    macro_deadband_db = settings.macro_deadband_db,
    macro_max_boost_db = settings.macro_max_boost_db,
    macro_max_cut_db = settings.macro_max_cut_db,
    meso_gap_ms = settings.meso_gap_s * 1000,
    meso_min_zone_ms = settings.meso_min_zone_s * 1000,
    meso_max_zones_per_macro = settings.meso_max_zones_per_macro,
    meso_strength = settings.meso_strength,
    meso_deadband_db = settings.meso_deadband_db,
    meso_max_boost_db = settings.meso_max_boost_db,
    meso_max_cut_db = settings.meso_max_cut_db,
    micro_repair = settings.micro_repair,
    micro_clear_drop_db = settings.micro_clear_drop_db,
    micro_boost_strength = settings.micro_boost_strength,
    micro_cut_strength = settings.micro_cut_strength,
    micro_deadband_db = settings.micro_deadband_db,
    micro_max_boost_db = settings.micro_max_boost_db,
    micro_max_cut_db = settings.micro_max_cut_db,
    already_good_db = settings.already_good_db,
    protected_max_boost_db = settings.protected_max_boost_db,
    protected_crest_db = settings.protected_crest_db,
    protected_low_relative_db = settings.protected_low_relative_db,
    stabilize_boost_db = settings.stabilize_boost_db,
    stabilize_cut_db = settings.stabilize_cut_db,
    gain_deadband_db = settings.gain_deadband_db,
    preserve_loudness = settings.preserve_loudness,
    automation_mode = settings.automation_mode,
    sustain_low_percent = settings.sustain_low_fraction * 100,
    sustain_high_percent = settings.sustain_high_fraction * 100,
    transient_crest_db = settings.transient_crest_db,
    detect_window_ms = settings.detect_window_ms,
    detect_silence_db = settings.detect_silence_db,
    detect_range_db = settings.detect_range_db,
    part_merge_gap_ms = settings.part_merge_gap_s * 1000,
    min_part_ms = settings.min_part_s * 1000,
    syllable_split_db = settings.syllable_split_db,
    syllable_split_hold_ms = settings.syllable_split_hold_s * 1000,
    min_gain_change_db = settings.min_gain_change_db,
    gain_merge_gap_ms = settings.gain_merge_gap_s * 1000,
    zero_crossing = settings.zero_crossing_enabled,
    zero_crossing_search_ms = settings.zero_crossing_search_s * 1000,
    curve_smooth_ms = settings.curve_smooth_s * 1000,
    curve_tolerance_db = settings.curve_tolerance_db,
    curve_min_point_gap_ms = settings.curve_min_point_gap_s * 1000,
    curve_detail = settings.curve_detail,
    curve_edge_ramp_ms = settings.curve_edge_ramp_s * 1000,
    padding_ms = settings.padding_s * 1000,
    ramp_ms = settings.ramp_s * 1000,
    limited_by_peak = limited_by_peak,
    limited_by_max_boost = limited_by_max_boost,
    limited_by_max_cut = limited_by_max_cut,
    max_boost_hit_ratio = total_segments > 0 and (limited_by_max_boost / total_segments) or 0,
    max_cut_hit_ratio = total_segments > 0 and (limited_by_max_cut / total_segments) or 0,
    gain_target = "take_volume_envelope",
    gain_db = {
      min = min_gain_db,
      max = max_gain_db,
      average = total_segments > 0 and (sum_gain_db / total_segments) or nil
    },
    post_level_measurement = {
      enabled = settings.post_level_report,
      mode = post_level_mode or (settings.preview and "estimated_envelope" or nil),
      items = post_level_items,
      before_stdev_db = post_level_items > 0 and (sum_post_before_stdev_db / post_level_items) or nil,
      after_stdev_db = post_level_items > 0 and (sum_post_after_stdev_db / post_level_items) or nil,
      stdev_improvement_db = post_level_items > 0 and (sum_post_stdev_improvement_db / post_level_items) or nil,
      before_spread_db = post_level_items > 0 and (sum_post_before_spread_db / post_level_items) or nil,
      after_spread_db = post_level_items > 0 and (sum_post_after_spread_db / post_level_items) or nil,
      spread_improvement_db = post_level_items > 0 and (sum_post_spread_improvement_db / post_level_items) or nil,
      peak_outliers = total_post_peak_outliers,
      glottal_outliers = total_post_glottal_outliers,
      unresolved_peak_outliers = total_post_unresolved_peak_outliers,
      max_after_peak_db = max_post_after_peak_db,
      silence_breath_safety = {
        protected_parts = total_post_protected_parts,
        boosted_protected_parts = total_post_boosted_protected_parts,
        boosted_low_energy_parts = total_post_boosted_low_energy_parts
      },
      examples = post_level_examples
    },
    skip_reasons = skip_reasons,
    warnings = warnings,
    macro_zone_examples = macro_zone_examples,
    examples = examples
  }
end

function M.register(registry)
  registry.command("vocal_level_items", command_vocal_level_items, {
    read_only = function(command) return command.preview == true end
  })
end

return M
