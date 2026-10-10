local M = {}

local core = require("rm_core")
local audio = require("rm_gain_stage")

local track_name = core.track_name
local track_index = core.track_index
local lower = core.lower
local trim = core.trim
local collect_items = core.collect_items
local item_summary = core.item_summary
local clamp = core.clamp
local gain_to_db = core.gain_to_db
local sorted_number_copy = core.sorted_number_copy
local audio_accessor_range = audio.audio_accessor_range
local item_audio_context = audio.item_audio_context

local EPS = 0.000001

local function sibilant_settings(command)
  local sensitivity = clamp(tonumber(command.sensitivity) or 0.65, 0, 1)
  local window_s = (tonumber(command.detectionWindowMs) or tonumber(command.windowMs) or 4) / 1000
  local min_sibilant_s = (tonumber(command.minSibilantMs) or 5) / 1000
  local max_sibilant_s = (tonumber(command.maxSibilantMs) or 220) / 1000
  if max_sibilant_s <= min_sibilant_s then max_sibilant_s = min_sibilant_s + 0.001 end

  local band_low_hz = tonumber(command.bandLowHz) or 3500
  local band_high_hz = tonumber(command.bandHighHz) or 12000
  if band_high_hz <= band_low_hz then band_high_hz = band_low_hz + 1000 end

  local destination_track_name = trim(command.destinationTrackName or command.destinationTrack or "VOX SIBILANTS")
  if destination_track_name == "" then destination_track_name = "VOX SIBILANTS" end

  return {
    preview = command.preview == true,
    destination_track_name = destination_track_name,
    consonants = command.consonants or { "s" },
    zero_crossing_enabled = command.zeroCrossing ~= false,
    zero_crossing_search_s = (tonumber(command.zeroCrossingSearchMs) or 8) / 1000,
    padding_s = (tonumber(command.paddingMs) or 0) / 1000,
    crossfade_s = (tonumber(command.crossfadeMs) or 0) / 1000,
    merge_gap_s = (tonumber(command.mergeGapMs) or 12) / 1000,
    min_sibilant_s = min_sibilant_s,
    max_sibilant_s = max_sibilant_s,
    window_s = clamp(window_s, 0.001, 0.05),
    band_low_hz = band_low_hz,
    band_high_hz = band_high_hz,
    sensitivity = sensitivity
  }
end

local function contains_any_consonant(consonants, names)
  for _, value in ipairs(consonants or {}) do
    local normalized = lower(value)
    for _, name in ipairs(names) do
      if normalized == name then return true end
    end
  end
  return false
end

local function percentile(values, fraction)
  local sorted = sorted_number_copy(values)
  local count = #sorted
  if count == 0 then return nil end
  fraction = clamp(fraction or 0.5, 0, 1)
  local position = 1 + (count - 1) * fraction
  local lower_index = math.floor(position)
  local upper_index = math.ceil(position)
  if lower_index == upper_index then return sorted[lower_index] end
  local weight = position - lower_index
  return sorted[lower_index] * (1 - weight) + sorted[upper_index] * weight
end

local function mono_sample_from_buffer(buffer, frame, channels)
  local sum = 0
  for ch = 1, channels do
    sum = sum + (buffer[frame * channels + ch] or 0)
  end
  return sum / math.max(1, channels)
end

local function frame_square_from_buffer(buffer, frame, channels)
  local sum = 0
  for ch = 1, channels do
    local sample = buffer[frame * channels + ch] or 0
    sum = sum + sample * sample
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

local function merge_regions(regions, merge_gap_s)
  table.sort(regions, function(a, b) return a.start < b.start end)
  local merged = {}

  for _, region in ipairs(regions) do
    local previous = merged[#merged]
    if previous and region.start <= previous["end"] + merge_gap_s then
      previous["end"] = math.max(previous["end"], region["end"])
      previous.raw_start = math.min(previous.raw_start or previous.start, region.raw_start or region.start)
      previous.raw_end = math.max(previous.raw_end or previous["end"], region.raw_end or region["end"])
      previous.windows = (previous.windows or 0) + (region.windows or 0)
      previous.confidence = math.max(previous.confidence or 0, region.confidence or 0)
      previous.profile = previous.profile == region.profile and previous.profile or "mixed"
    else
      merged[#merged + 1] = region
    end
  end

  return merged
end

local function filter_regions_by_length(regions, settings)
  local filtered = {}
  for _, region in ipairs(regions or {}) do
    local length = region["end"] - region.start
    if length >= settings.min_sibilant_s and length <= settings.max_sibilant_s then
      filtered[#filtered + 1] = region
    end
  end
  return filtered
end

local function append_region(regions, start_time, end_time, confidence, profile, windows, item_start, item_end, settings)
  local padded_start = clamp(start_time - settings.padding_s, item_start, item_end)
  local padded_end = clamp(end_time + settings.padding_s, item_start, item_end)
  local length = padded_end - padded_start
  if length < settings.min_sibilant_s or length > settings.max_sibilant_s then return end

  regions[#regions + 1] = {
    start = padded_start,
    ["end"] = padded_end,
    raw_start = start_time,
    raw_end = end_time,
    confidence = confidence,
    profile = profile,
    windows = windows or 0
  }
end

local function finalize_active_region(active, regions, item_start, item_end, settings)
  if not active then return end
  if (active.core_windows or 0) <= 0 then return end
  append_region(
    regions,
    active.start,
    active["end"],
    active.confidence_sum / math.max(1, active.windows),
    active.profile,
    active.windows,
    item_start,
    item_end,
    settings
  )
end

local function classify_windows(windows, item_start, item_end, settings)
  local band_values = {}
  local contrast_values = {}
  local body_values = {}
  local ratio_values = {}
  for _, window in ipairs(windows) do
    if window.full_db > -90 and window.band_db > -120 then
      band_values[#band_values + 1] = window.band_db
      contrast_values[#contrast_values + 1] = window.contrast_db
      body_values[#body_values + 1] = window.body_db
      ratio_values[#ratio_values + 1] = window.high_ratio_db
    end
  end

  if #band_values == 0 then return nil, "silent item" end

  local sensitivity = settings.sensitivity
  local band_threshold = math.max(-78, percentile(band_values, 0.45 + ((1 - sensitivity) * 0.20)) or -78)
  local contrast_threshold = math.max(percentile(contrast_values, 0.55 + ((1 - sensitivity) * 0.22)) or -12, -18 + ((1 - sensitivity) * 10))
  local body_threshold = percentile(body_values, 0.55 + (sensitivity * 0.25)) or -20
  local ratio_threshold = math.max(percentile(ratio_values, 0.58 + ((1 - sensitivity) * 0.22)) or -18, -24 + ((1 - sensitivity) * 10))
  local zcr_threshold = 600 + ((1 - sensitivity) * 900)
  local allow_ch = contains_any_consonant(settings.consonants, { "ch", "j", "x" })
  local thresholds = {
    band_db = band_threshold,
    contrast_db = contrast_threshold,
    body_db = body_threshold,
    ratio_db = ratio_threshold,
    zcr = zcr_threshold
  }
  local edge_thresholds = {
    band_db = math.max(-86, band_threshold - 12),
    contrast_db = contrast_threshold - 10,
    body_db = body_threshold + 10,
    ratio_db = ratio_threshold - 10,
    zcr = zcr_threshold * 0.65
  }
  local regions = {}
  local active = nil
  local active_windows = 0

  for _, window in ipairs(windows) do
    local band_score = (window.band_db - band_threshold) / 16
    local contrast_score = (window.contrast_db - contrast_threshold) / 14
    local body_score = (body_threshold - window.body_db) / 16
    local ratio_score = (window.high_ratio_db - ratio_threshold) / 14
    local zcr_score = (window.zcr - zcr_threshold) / 2600
    local confidence = clamp(0.52 + band_score * 0.22 + contrast_score * 0.35 + body_score * 0.18 + ratio_score * 0.18 + zcr_score * 0.07, 0, 1)
    local band_ok = window.band_db >= band_threshold
    local contrast_ok = window.contrast_db >= contrast_threshold
    local ratio_ok = window.high_ratio_db >= ratio_threshold
    local body_ok = window.body_db <= body_threshold or window.contrast_db >= contrast_threshold + 4
    local s_like = band_ok and contrast_ok and ratio_ok and body_ok
    local ch_like = allow_ch and band_ok and window.contrast_db >= contrast_threshold - 3 and ratio_ok
    local core_window = s_like or ch_like
    local edge_band_ok = window.band_db >= edge_thresholds.band_db
    local edge_contrast_ok = window.contrast_db >= edge_thresholds.contrast_db
    local edge_ratio_ok = window.high_ratio_db >= edge_thresholds.ratio_db
    local edge_body_ok = window.body_db <= edge_thresholds.body_db or window.zcr >= edge_thresholds.zcr
    local s_edge = edge_band_ok and edge_contrast_ok and edge_ratio_ok and edge_body_ok
    local ch_edge = allow_ch and edge_band_ok and edge_ratio_ok and window.contrast_db >= edge_thresholds.contrast_db - 2
    local active_window = s_edge or ch_edge
    local profile = (s_like or s_edge) and "s" or "ch"

    if active_window then
      if core_window then active_windows = active_windows + 1 end
      if active and window.start - active["end"] <= settings.merge_gap_s then
        active["end"] = window["end"]
        active.windows = active.windows + 1
        if core_window then active.core_windows = (active.core_windows or 0) + 1 end
        active.confidence_sum = active.confidence_sum + confidence
        active.profile = active.profile == profile and active.profile or "mixed"
      else
        finalize_active_region(active, regions, item_start, item_end, settings)
        active = {
          start = window.start,
          ["end"] = window["end"],
          windows = 1,
          core_windows = core_window and 1 or 0,
          confidence_sum = confidence,
          profile = profile
        }
      end
    else
      finalize_active_region(active, regions, item_start, item_end, settings)
      active = nil
    end
  end

  finalize_active_region(active, regions, item_start, item_end, settings)
  regions = filter_regions_by_length(merge_regions(regions, settings.merge_gap_s), settings)
  thresholds.active_windows = active_windows
  thresholds.edge_band_db = edge_thresholds.band_db
  thresholds.edge_contrast_db = edge_thresholds.contrast_db
  thresholds.edge_body_db = edge_thresholds.body_db
  thresholds.edge_ratio_db = edge_thresholds.ratio_db

  return {
    regions = regions,
    thresholds = thresholds
  }
end

local function detect_sibilant_regions(accessor, sample_rate, channels, start_time, end_time, settings)
  local total_samples = math.floor((end_time - start_time) * sample_rate)
  if total_samples <= 0 then return nil, "too short to analyze" end

  local nyquist = sample_rate / 2
  local low_cut = math.min(settings.band_low_hz, nyquist * 0.9)
  local high_cut = math.min(settings.band_high_hz, nyquist * 0.98)
  local window_samples = math.max(1, math.floor(sample_rate * settings.window_s))
  local block_samples = math.min(16384, math.max(2048, window_samples * 8))
  local buffer = reaper.new_array(block_samples * channels)
  local dt = 1 / sample_rate
  local hp_rc = 1 / (2 * math.pi * math.max(20, low_cut))
  local hp_alpha = hp_rc / (hp_rc + dt)
  local body_cut = math.min(math.max(700, low_cut * 0.7), nyquist * 0.45)
  local body_rc = 1 / (2 * math.pi * body_cut)
  local body_alpha = dt / (body_rc + dt)
  local lp_alpha = nil
  if high_cut < nyquist * 0.95 then
    local lp_rc = 1 / (2 * math.pi * high_cut)
    lp_alpha = dt / (lp_rc + dt)
  end

  local windows = {}
  local position = start_time
  local remaining = total_samples
  local sample_index = 0
  local window_start_sample = 0
  local window_full_sum = 0
  local window_band_sum = 0
  local window_body_sum = 0
  local window_count = 0
  local window_peak = 0
  local window_crossings = 0
  local previous_sample = 0
  local previous_hp = 0
  local previous_band = nil
  local band_lp = 0
  local body_lp = 0
  local read_any = false

  local function flush_window(end_sample_index)
    if window_count <= 0 then return end
    local full_rms = math.sqrt(window_full_sum / window_count)
    local band_rms = math.sqrt(window_band_sum / window_count)
    local body_rms = math.sqrt(window_body_sum / window_count)
    local rest_square = math.max(0, (full_rms * full_rms) - (band_rms * band_rms))
    local rest_rms = math.sqrt(rest_square)
    local window_start = start_time + (window_start_sample / sample_rate)
    local window_end = start_time + (end_sample_index / sample_rate)
    local full_db = gain_to_db(full_rms)
    local band_db = gain_to_db(band_rms)
    local body_db = gain_to_db(body_rms)
    local rest_db = gain_to_db(rest_rms)
    windows[#windows + 1] = {
      start = window_start,
      ["end"] = window_end,
      full_db = full_db,
      band_db = band_db,
      body_db = body_db,
      rest_db = rest_db,
      contrast_db = band_db - body_db,
      high_ratio_db = band_db - full_db,
      zcr = window_crossings / math.max(0.001, window_end - window_start),
      peak_db = gain_to_db(window_peak)
    }
    window_start_sample = end_sample_index
    window_full_sum = 0
    window_band_sum = 0
    window_body_sum = 0
    window_count = 0
    window_peak = 0
    window_crossings = 0
    previous_band = nil
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
        local sample = mono_sample_from_buffer(buffer, frame, channels)
        local hp = hp_alpha * (previous_hp + sample - previous_sample)
        previous_hp = hp
        previous_sample = sample
        if lp_alpha then
          band_lp = band_lp + lp_alpha * (hp - band_lp)
        else
          band_lp = hp
        end
        body_lp = body_lp + body_alpha * (sample - body_lp)

        if previous_band and ((previous_band < 0 and band_lp > 0) or (previous_band > 0 and band_lp < 0)) then
          window_crossings = window_crossings + 1
        end
        previous_band = band_lp

        local full_square = frame_square_from_buffer(buffer, frame, channels)
        window_full_sum = window_full_sum + full_square
        window_band_sum = window_band_sum + (band_lp * band_lp)
        window_body_sum = window_body_sum + (body_lp * body_lp)
        window_peak = math.max(window_peak, math.sqrt(full_square))
        window_count = window_count + 1
        sample_index = sample_index + 1

        if window_count >= window_samples then flush_window(sample_index) end
      end
    end

    remaining = remaining - want
    position = position + (want / sample_rate)
  end

  flush_window(sample_index)
  if not read_any then return nil, "no audio returned" end
  if #windows == 0 then return nil, "too short to analyze" end

  return classify_windows(windows, start_time, end_time, settings)
end

local function snap_regions_to_zero_crossings(accessor, sample_rate, channels, regions, item_start, item_end, settings)
  if not settings.zero_crossing_enabled or settings.zero_crossing_search_s <= 0 then return regions end

  local snapped = {}
  local minimum_edge_s = math.min(0.001, math.max(0.0001, settings.min_sibilant_s / 4))

  for _, region in ipairs(regions or {}) do
    local start_time = nearest_zero_crossing_time(
      accessor,
      sample_rate,
      channels,
      region.start,
      math.max(item_start, region.start - settings.zero_crossing_search_s),
      math.min(region["end"] - minimum_edge_s, region.start + settings.zero_crossing_search_s),
      settings.zero_crossing_search_s
    )
    local end_time = nearest_zero_crossing_time(
      accessor,
      sample_rate,
      channels,
      region["end"],
      math.max(start_time + minimum_edge_s, region["end"] - settings.zero_crossing_search_s),
      math.min(item_end, region["end"] + settings.zero_crossing_search_s),
      settings.zero_crossing_search_s
    )
    if end_time - start_time >= settings.min_sibilant_s and end_time - start_time <= settings.max_sibilant_s then
      region.start = start_time
      region["end"] = end_time
      snapped[#snapped + 1] = region
    end
  end

  return filter_regions_by_length(merge_regions(snapped, settings.merge_gap_s), settings)
end

local function map_region_to_project(region, ctx, analysis_start)
  local start_rel = math.max(0, region.start - analysis_start)
  local end_rel = math.min(ctx.item_length, region["end"] - analysis_start)
  return {
    start = clamp(ctx.item_start + start_rel, ctx.item_start, ctx.item_end),
    ["end"] = clamp(ctx.item_start + end_rel, ctx.item_start, ctx.item_end),
    raw_start = region.raw_start,
    raw_end = region.raw_end,
    confidence = region.confidence,
    profile = region.profile,
    windows = region.windows
  }
end

local function analyze_item_for_sibilants(item, settings)
  local ctx, context_error = item_audio_context(item)
  if not ctx then return nil, context_error end

  local accessor = reaper.CreateTakeAudioAccessor(ctx.take)
  if not accessor then return nil, "could not create audio accessor" end

  local ok, result, reason = pcall(function()
    reaper.AudioAccessorUpdate(accessor)
    local analysis_start, analysis_end = audio_accessor_range(accessor, ctx.item_start, ctx.item_end)
    local detection, detection_reason = detect_sibilant_regions(
      accessor,
      ctx.sample_rate,
      ctx.channels,
      analysis_start,
      analysis_end,
      settings
    )
    if not detection then return nil, detection_reason end
    detection.regions = snap_regions_to_zero_crossings(accessor, ctx.sample_rate, ctx.channels, detection.regions, analysis_start, analysis_end, settings)

    local regions = {}
    for _, region in ipairs(detection.regions or {}) do
      local mapped = map_region_to_project(region, ctx, analysis_start)
      if mapped["end"] - mapped.start >= settings.min_sibilant_s then regions[#regions + 1] = mapped end
    end

    return {
      item = item,
      ctx = ctx,
      regions = merge_regions(regions, 0),
      thresholds = detection.thresholds
    }
  end)

  reaper.DestroyAudioAccessor(accessor)
  if not ok then error(result) end
  return result, reason
end

local function find_track_by_name(name)
  local wanted = lower(name)
  for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    if lower(track_name(track)) == wanted then return track end
  end
  return nil
end

local function capture_selected_tracks()
  local selected = {}
  for i = 0, reaper.CountSelectedTracks(0) - 1 do
    selected[#selected + 1] = reaper.GetSelectedTrack(0, i)
  end
  return selected
end

local function restore_selected_tracks(selected)
  for i = 0, reaper.CountTracks(0) - 1 do
    reaper.SetTrackSelected(reaper.GetTrack(0, i), false)
  end
  for _, track in ipairs(selected or {}) do
    if track then reaper.SetTrackSelected(track, true) end
  end
end

local function place_track_below_source(track, source_track)
  if not track or not source_track or track == source_track then return end
  local insert_index = track_index(source_track)
  if reaper.ReorderSelectedTracks then
    local selected = capture_selected_tracks()
    reaper.SetOnlyTrackSelected(track)
    reaper.ReorderSelectedTracks(insert_index, 0)
    restore_selected_tracks(selected)
  end
end

local function ensure_destination_track(settings, source_track)
  local track = find_track_by_name(settings.destination_track_name)
  if track then
    place_track_below_source(track, source_track)
    return track, false
  end

  local insert_index = source_track and track_index(source_track) or reaper.CountTracks(0)
  reaper.InsertTrackAtIndex(insert_index, false)
  track = reaper.GetTrack(0, insert_index)
  if not track then error("could not create destination track") end
  reaper.GetSetMediaTrackInfo_String(track, "P_NAME", settings.destination_track_name, true)
  reaper.SetMediaTrackInfo_Value(track, "I_NCHAN", 2)
  return track, true
end

local function clear_item_fades(item)
  if not item then return end
  reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", 0)
  reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", 0)
  reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN_AUTO", 0)
  reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN_AUTO", 0)
end

local function set_short_fades(item, length, settings)
  clear_item_fades(item)
  local fade = math.min(settings.crossfade_s, math.max(0, length / 3))
  if fade <= 0 then return end
  reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", fade)
  reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", fade)
end

local function apply_analysis_regions(analysis, destination_track, settings)
  local source_track = reaper.GetMediaItem_Track(analysis.item)
  if source_track == destination_track then return {}, "destination is source track" end

  local regions = analysis.regions or {}
  table.sort(regions, function(a, b) return a.start > b.start end)

  local working_item = analysis.item
  local current_start = analysis.ctx.item_start
  local current_end = analysis.ctx.item_end
  local moved = {}

  for _, region in ipairs(regions) do
    if not working_item then break end
    local start_time = clamp(region.start, current_start, current_end)
    local end_time = clamp(region["end"], current_start, current_end)
    if end_time - start_time > EPS then
      if end_time < current_end - EPS then
        local tail = reaper.SplitMediaItem(working_item, end_time)
        if not tail then error("could not split item at sibilant end") end
        clear_item_fades(tail)
        clear_item_fades(working_item)
      end

      local sibilant_item = working_item
      if start_time > current_start + EPS then
        sibilant_item = reaper.SplitMediaItem(working_item, start_time)
        if not sibilant_item then error("could not split item at sibilant start") end
        clear_item_fades(working_item)
        clear_item_fades(sibilant_item)
      else
        working_item = nil
      end

      local length = end_time - start_time
      set_short_fades(sibilant_item, length, settings)
      reaper.MoveMediaItemToTrack(sibilant_item, destination_track)
      reaper.SetMediaItemSelected(sibilant_item, true)

      moved[#moved + 1] = {
        start = start_time,
        ["end"] = end_time,
        length = length,
        confidence = region.confidence,
        profile = region.profile
      }

      if working_item then current_end = start_time end
    end
  end

  clear_item_fades(working_item)
  return moved
end

local function add_warning(warnings, item, reason)
  if #warnings >= 12 then return end
  local summary = item_summary(item)
  warnings[#warnings + 1] = {
    reason = reason,
    track = summary.track,
    item_index = summary.item_index
  }
end

local function append_examples(examples, analysis)
  if #examples >= 12 then return end
  local summary = item_summary(analysis.item)
  for _, region in ipairs(analysis.regions or {}) do
    if #examples >= 12 then break end
    examples[#examples + 1] = {
      track = summary.track,
      item_index = summary.item_index,
      start = region.start,
      ["end"] = region["end"],
      length = region["end"] - region.start,
      confidence = region.confidence,
      profile = region.profile
    }
  end
end

local function command_separate_vocal_sibilants(command)
  local item_filter = command.itemFilter or { type = "selected" }
  if item_filter.type ~= "selected" then error("separate-sibilants only supports selected items") end

  local settings = sibilant_settings(command)
  local items = collect_items(item_filter)
  local analyses = {}
  local matched_regions = 0
  local analyzed = 0
  local skipped = 0
  local moved_total = 0
  local duration_total = 0
  local warnings = {}
  local examples = {}
  local skip_reasons = {}
  local threshold_examples = {}

  for _, item in ipairs(items) do
    local ok, analysis, reason = pcall(analyze_item_for_sibilants, item, settings)
    if not ok then
      reason = tostring(analysis)
      analysis = nil
    end

    if not analysis then
      skipped = skipped + 1
      reason = reason or "not analyzed"
      skip_reasons[reason] = (skip_reasons[reason] or 0) + 1
      add_warning(warnings, item, reason)
    elseif #(analysis.regions or {}) == 0 then
      analyzed = analyzed + 1
      skip_reasons["no sibilants detected"] = (skip_reasons["no sibilants detected"] or 0) + 1
      if #threshold_examples < 4 and analysis.thresholds then
        threshold_examples[#threshold_examples + 1] = analysis.thresholds
      end
    else
      analyzed = analyzed + 1
      analyses[#analyses + 1] = analysis
      matched_regions = matched_regions + #analysis.regions
      for _, region in ipairs(analysis.regions) do
        duration_total = duration_total + math.max(0, region["end"] - region.start)
      end
      append_examples(examples, analysis)
      if #threshold_examples < 4 and analysis.thresholds then
        threshold_examples[#threshold_examples + 1] = analysis.thresholds
      end
    end
  end

  local destination_track = nil
  local destination_created = false
  if not settings.preview and matched_regions > 0 then
    local source_track = analyses[1] and reaper.GetMediaItem_Track(analyses[1].item) or nil
    destination_track, destination_created = ensure_destination_track(settings, source_track)
    for _, analysis in ipairs(analyses) do
      local moved, reason = apply_analysis_regions(analysis, destination_track, settings)
      if reason then
        skipped = skipped + 1
        skip_reasons[reason] = (skip_reasons[reason] or 0) + 1
        add_warning(warnings, analysis.item, reason)
      else
        moved_total = moved_total + #moved
      end
    end
  end

  reaper.TrackList_AdjustWindows(false)
  reaper.UpdateArrange()

  return {
    preview = settings.preview,
    matched = #items,
    analyzed = analyzed,
    skipped = skipped,
    detected = matched_regions,
    changed = settings.preview and 0 or moved_total,
    moved = settings.preview and 0 or moved_total,
    total_duration = duration_total,
    destination_track = settings.destination_track_name,
    destination_track_exists = find_track_by_name(settings.destination_track_name) ~= nil,
    destination_track_created = destination_created,
    zero_crossing = settings.zero_crossing_enabled,
    zero_crossing_search_ms = settings.zero_crossing_search_s * 1000,
    padding_ms = settings.padding_s * 1000,
    crossfade_ms = settings.crossfade_s * 1000,
    band_low_hz = settings.band_low_hz,
    band_high_hz = settings.band_high_hz,
    sensitivity = settings.sensitivity,
    consonants = settings.consonants,
    skip_reasons = skip_reasons,
    warnings = warnings,
    examples = examples,
    thresholds = threshold_examples
  }
end

function M.register(registry)
  registry.command("separate_vocal_sibilants", command_separate_vocal_sibilants, {
    read_only = function(command) return command.preview == true end
  })
end

return M
