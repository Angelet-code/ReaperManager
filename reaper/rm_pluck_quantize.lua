local M = {}

local core = require("rm_core")
local audio = require("rm_gain_stage")

local collect_items = core.collect_items
local item_summary = core.item_summary
local clamp = core.clamp
local gain_to_db = core.gain_to_db
local db_to_gain = core.db_to_gain
local sorted_number_copy = core.sorted_number_copy
local audio_accessor_range = audio.audio_accessor_range
local item_audio_context = audio.item_audio_context

local EPS = 0.000001

local function pluck_settings(command)
  return {
    preview = command.preview == true,
    pre_roll_s = clamp((tonumber(command.preRollMs) or 8) / 1000, 0, 0.25),
    fade_s = clamp((tonumber(command.fadeMs) or 3) / 1000, 0, 0.1),
    tolerance_s = clamp((tonumber(command.toleranceMs) or 2) / 1000, 0, 0.1),
    min_note_gap_s = clamp((tonumber(command.minNoteGapMs) or 35) / 1000, 0.01, 2),
    window_s = 0.002,
    cut_search_s = 0.006
  }
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

local function frame_abs_from_buffer(buffer, frame, channels)
  local peak = 0
  for ch = 1, channels do
    local sample = math.abs(buffer[frame * channels + ch] or 0)
    if sample > peak then peak = sample end
  end
  return peak
end

local function mono_sample_from_buffer(buffer, frame, channels)
  local sum = 0
  for ch = 1, channels do
    sum = sum + (buffer[frame * channels + ch] or 0)
  end
  return sum / math.max(1, channels)
end

local function read_peak(accessor, sample_rate, channels, start_time, end_time)
  if not start_time or not end_time or end_time <= start_time then return 0 end
  local sample_count = math.max(1, math.floor((end_time - start_time) * sample_rate) + 1)
  sample_count = math.min(sample_count, 16384)
  local buffer = reaper.new_array(sample_count * channels)
  buffer.clear()

  local retval = reaper.GetAudioAccessorSamples(accessor, sample_rate, channels, start_time, sample_count, buffer)
  if retval ~= 1 then return 0 end

  local peak = 0
  for frame = 0, sample_count - 1 do
    local sample = frame_abs_from_buffer(buffer, frame, channels)
    if sample > peak then peak = sample end
  end
  return peak
end

local function nearest_zero_crossing_time(accessor, sample_rate, channels, target_time, min_time, max_time, search_s)
  if not search_s or search_s <= 0 then return clamp(target_time, min_time, max_time), false end
  if not min_time or not max_time or max_time <= min_time then return target_time, false end

  local search_start = clamp(target_time - search_s, min_time, max_time)
  local search_end = clamp(target_time + search_s, min_time, max_time)
  if search_end <= search_start then return clamp(target_time, min_time, max_time), false end

  local sample_count = math.max(2, math.floor((search_end - search_start) * sample_rate) + 2)
  local buffer = reaper.new_array(sample_count * channels)
  buffer.clear()

  local retval = reaper.GetAudioAccessorSamples(accessor, sample_rate, channels, search_start, sample_count, buffer)
  if retval ~= 1 then return clamp(target_time, min_time, max_time), false end

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

  if best_crossing then return best_crossing, true end
  return best_low_time or clamp(target_time, min_time, max_time), false
end

local function build_peak_windows(accessor, sample_rate, channels, start_time, end_time, settings)
  local duration = end_time - start_time
  if duration <= 0 then return nil, "too short to analyze" end

  local window_count = math.max(1, math.ceil(duration / settings.window_s))
  local windows = {}
  for i = 1, window_count do
    local window_start = start_time + ((i - 1) * settings.window_s)
    windows[i] = {
      start = window_start,
      ["end"] = math.min(end_time, window_start + settings.window_s),
      peak = 0
    }
  end

  local total_samples = math.max(1, math.floor(duration * sample_rate))
  local block_samples = 16384
  local buffer = reaper.new_array(block_samples * channels)
  local remaining = total_samples
  local position = start_time
  local read_any = false

  while remaining > 0 do
    local want = math.min(block_samples, remaining)
    buffer.resize(want * channels)
    buffer.clear()

    local retval = reaper.GetAudioAccessorSamples(accessor, sample_rate, channels, position, want, buffer)
    if retval == -1 then return nil, "audio accessor error" end

    if retval == 1 then
      read_any = true
      for frame = 0, want - 1 do
        local time = position + (frame / sample_rate)
        local index = math.floor((time - start_time) / settings.window_s) + 1
        if windows[index] then
          local peak = frame_abs_from_buffer(buffer, frame, channels)
          if peak > windows[index].peak then windows[index].peak = peak end
        end
      end
    end

    remaining = remaining - want
    position = position + (want / sample_rate)
  end

  if not read_any then return nil, "no audio returned" end

  local levels = {}
  local max_db = -150
  for _, window in ipairs(windows) do
    window.db = gain_to_db(window.peak)
    levels[#levels + 1] = window.db
    if window.db > max_db then max_db = window.db end
  end

  return {
    windows = windows,
    levels = levels,
    max_db = max_db
  }
end

local function max_window_db(windows, start_index, end_index)
  local value = -150
  start_index = math.max(1, start_index)
  end_index = math.min(#windows, end_index)
  for i = start_index, end_index do
    if windows[i].db > value then value = windows[i].db end
  end
  return value
end

local function refine_onset_time(accessor, sample_rate, channels, candidate_time, local_peak, analysis_start, analysis_end)
  local search_start = math.max(analysis_start, candidate_time - 0.012)
  local search_end = math.min(analysis_end, candidate_time + 0.02)
  if search_end <= search_start then return candidate_time, local_peak end

  local sample_count = math.max(2, math.floor((search_end - search_start) * sample_rate) + 2)
  local buffer = reaper.new_array(sample_count * channels)
  buffer.clear()

  local retval = reaper.GetAudioAccessorSamples(accessor, sample_rate, channels, search_start, sample_count, buffer)
  if retval ~= 1 then return candidate_time, local_peak end

  local peak = local_peak or 0
  for frame = 0, sample_count - 1 do
    local sample = frame_abs_from_buffer(buffer, frame, channels)
    if sample > peak then peak = sample end
  end

  local threshold = math.max(peak * 0.12, db_to_gain(-72))
  for frame = 0, sample_count - 1 do
    if frame_abs_from_buffer(buffer, frame, channels) >= threshold then
      return search_start + (frame / sample_rate), peak
    end
  end

  return candidate_time, peak
end

local function detect_pluck_onsets(accessor, sample_rate, channels, analysis_start, analysis_end, settings)
  local envelope, reason = build_peak_windows(accessor, sample_rate, channels, analysis_start, analysis_end, settings)
  if not envelope then return nil, reason end
  if envelope.max_db < -80 then
    return {
      onsets = {},
      thresholds = { max_db = envelope.max_db }
    }
  end

  local noise_db = percentile(envelope.levels, 0.5) or -150
  local high_db = percentile(envelope.levels, 0.98) or envelope.max_db
  local dynamic_db = envelope.max_db - noise_db
  if dynamic_db < 8 then
    return {
      onsets = {},
      thresholds = {
        max_db = envelope.max_db,
        noise_db = noise_db,
        high_db = high_db,
        dynamic_db = dynamic_db
      }
    }
  end

  local threshold_db = math.max(noise_db + clamp(dynamic_db * 0.35, 10, 28), envelope.max_db - 28, -72)
  threshold_db = math.min(threshold_db, envelope.max_db - 6)

  local onsets = {}
  local windows = envelope.windows
  local skip_windows = math.max(1, math.floor(settings.min_note_gap_s / settings.window_s / 2))
  local last_onset = analysis_start - settings.min_note_gap_s
  local i = 1

  while i <= #windows do
    local window = windows[i]
    local previous_db = max_window_db(windows, i - 6, i - 1)
    local enough_gap = window.start - last_onset >= settings.min_note_gap_s
    local clear_rise = previous_db < threshold_db or (window.db - previous_db) >= 6

    if enough_gap and window.db >= threshold_db and clear_rise then
      local lookahead = math.max(1, math.floor(0.025 / settings.window_s))
      local local_peak = 0
      for j = i, math.min(#windows, i + lookahead) do
        if windows[j].peak > local_peak then local_peak = windows[j].peak end
      end

      local onset, refined_peak = refine_onset_time(
        accessor,
        sample_rate,
        channels,
        window.start,
        local_peak,
        analysis_start,
        analysis_end
      )

      if onset - last_onset >= settings.min_note_gap_s then
        onsets[#onsets + 1] = {
          time = onset,
          peak = refined_peak,
          window_db = window.db
        }
        last_onset = onset
        i = i + skip_windows
      else
        i = i + 1
      end
    else
      i = i + 1
    end
  end

  return {
    onsets = onsets,
    thresholds = {
      max_db = envelope.max_db,
      noise_db = noise_db,
      high_db = high_db,
      dynamic_db = dynamic_db,
      threshold_db = threshold_db
    }
  }
end

local function snap_to_grid(time)
  if reaper.GetSetProjectGrid and reaper.TimeMap2_timeToQN and reaper.TimeMap2_QNToTime then
    local ok, retval, division = pcall(reaper.GetSetProjectGrid, 0, false, 0, 0, 0)
    if ok then
      if type(retval) == "number" and (type(division) ~= "number" or division <= 0) then division = retval end
      if type(division) == "number" and division > 0 then
        local qn = reaper.TimeMap2_timeToQN(0, time)
        local snapped_qn = math.floor((qn / division) + 0.5) * division
        return reaper.TimeMap2_QNToTime(0, snapped_qn)
      end
    end
  end

  if reaper.SnapToGrid then
    local ok, snapped = pcall(reaper.SnapToGrid, 0, time)
    if ok and type(snapped) == "number" then return snapped end
  end
  return time
end

local function build_time_map(ctx, analysis_start, analysis_end)
  local accessor_duration = math.max(EPS, (analysis_end or ctx.item_end) - (analysis_start or ctx.item_start))
  local project_duration = math.max(EPS, ctx.item_length or (ctx.item_end - ctx.item_start))
  return {
    analysis_start = analysis_start or ctx.item_start,
    analysis_end = analysis_end or ctx.item_end,
    project_start = ctx.item_start,
    project_end = ctx.item_end,
    accessor_to_project_scale = project_duration / accessor_duration,
    project_to_accessor_scale = accessor_duration / project_duration
  }
end

local function accessor_to_project(time_map, accessor_time)
  local relative = (accessor_time or time_map.analysis_start) - time_map.analysis_start
  return clamp(time_map.project_start + (relative * time_map.accessor_to_project_scale), time_map.project_start, time_map.project_end)
end

local function project_to_accessor(time_map, project_time)
  local relative = (project_time or time_map.project_start) - time_map.project_start
  return clamp(time_map.analysis_start + (relative * time_map.project_to_accessor_scale), time_map.analysis_start, time_map.analysis_end)
end

local function find_safe_cut_before_onset(accessor, ctx, onset_accessor, onset_project, desired_delta_s, settings, time_map)
  desired_delta_s = desired_delta_s or 0
  local final_onset_project = onset_project - desired_delta_s
  local earliest_audible_project = math.min(onset_project, final_onset_project)
  if onset_project <= ctx.item_start + EPS then
    if ctx.item_start > final_onset_project - settings.pre_roll_s then
      return ctx.item_start, false, "not enough item-start pre-roll for slip"
    end
    return ctx.item_start, true, "item start"
  end

  local desired_project = earliest_audible_project - settings.pre_roll_s - settings.fade_s
  local latest_safe_project = math.min(earliest_audible_project - settings.fade_s, final_onset_project - settings.pre_roll_s)
  local max_project = math.min(latest_safe_project, ctx.item_end)
  local search_back_s = math.max(
    settings.pre_roll_s * 2 + settings.fade_s,
    math.abs(desired_delta_s) + settings.pre_roll_s + settings.fade_s,
    0.02
  )
  local min_project = math.max(ctx.item_start, desired_project - search_back_s)
  if max_project <= min_project then
    if ctx.item_start < onset_project - EPS and ctx.item_start <= latest_safe_project then
      return ctx.item_start, true, "item start"
    end
    return nil, false, "no room before onset"
  end

  local target_project = clamp(desired_project, min_project, max_project)
  local min_accessor = project_to_accessor(time_map, min_project)
  local max_accessor = project_to_accessor(time_map, max_project)
  local target_accessor = project_to_accessor(time_map, target_project)
  local cut_accessor = nearest_zero_crossing_time(
    accessor,
    ctx.sample_rate,
    ctx.channels,
    target_accessor,
    min_accessor,
    max_accessor,
    math.min(settings.cut_search_s, math.max(0, (max_accessor - min_accessor) / 2))
  )

  local cut_peak = read_peak(
    accessor,
    ctx.sample_rate,
    ctx.channels,
    math.max(time_map.analysis_start, cut_accessor - 0.0015),
    math.min(time_map.analysis_end, cut_accessor + 0.0015)
  )
  local onset_peak = read_peak(
    accessor,
    ctx.sample_rate,
    ctx.channels,
    math.max(time_map.analysis_start, onset_accessor),
    math.min(time_map.analysis_end, onset_accessor + math.min(0.018, settings.min_note_gap_s / 2))
  )
  local cut_project = accessor_to_project(time_map, cut_accessor)

  if cut_project > final_onset_project - settings.pre_roll_s then
    return cut_project, false, "not enough pre-roll for slip"
  end

  if onset_peak > 0 and cut_peak > math.max(onset_peak * 0.5, db_to_gain(-64)) and cut_project > ctx.item_start + EPS then
    return cut_project, false, "cut point is too hot"
  end

  return cut_project, true, "safe"
end

local function source_bounds(ctx)
  local source = reaper.GetMediaItemTake_Source(ctx.take)
  if not source then return nil end
  local length, is_qn = reaper.GetMediaSourceLength(source)
  if is_qn or not length or length <= 0 then return nil end
  return length
end

local function take_playrate(ctx)
  local playrate = reaper.GetMediaItemTakeInfo_Value(ctx.take, "D_PLAYRATE")
  if not playrate or playrate <= 0 then return nil end
  return playrate
end

local function take_start_offset(ctx)
  return reaper.GetMediaItemTakeInfo_Value(ctx.take, "D_STARTOFFS") or 0
end

local function build_note_entries(accessor, ctx, onsets, settings, time_map)
  local entries = {}
  for _, onset in ipairs(onsets or {}) do
    local project_onset = accessor_to_project(time_map, onset.time)
    local grid = snap_to_grid(project_onset)
    local delta_s = project_onset - grid
    local desired_delta_s = math.abs(delta_s) <= settings.tolerance_s and 0 or delta_s
    local cut_time, cut_safe, cut_reason = find_safe_cut_before_onset(
      accessor,
      ctx,
      onset.time,
      project_onset,
      desired_delta_s,
      settings,
      time_map
    )

    entries[#entries + 1] = {
      onset = project_onset,
      accessor_onset = onset.time,
      grid = grid,
      delta_s = delta_s,
      desired_delta_s = desired_delta_s,
      cut_time = cut_time,
      cut_safe = cut_safe,
      cut_reason = cut_reason,
      peak_db = gain_to_db(onset.peak)
    }
  end
  return entries
end

local function build_delta_groups(entries, settings)
  local groups = {}
  for _, entry in ipairs(entries or {}) do
    local previous = groups[#groups]
    if not previous or math.abs(entry.desired_delta_s - previous.desired_delta_s) > settings.tolerance_s then
      groups[#groups + 1] = {
        desired_delta_s = entry.desired_delta_s,
        entries = { entry },
        start_onset = entry.onset,
        cut_time = entry.cut_time,
        cut_safe = entry.cut_safe,
        cut_reason = entry.cut_reason
      }
    else
      previous.entries[#previous.entries + 1] = entry
    end
  end
  return groups
end

local function unique_safe_cuts(entries, ctx)
  local cuts = {}
  local seen = {}

  for _, entry in ipairs(entries or {}) do
    local cut = entry.cut_time
    if entry.cut_safe and cut and cut > ctx.item_start + EPS and cut < ctx.item_end - EPS then
      local key = tostring(math.floor(cut * 1000000 + 0.5))
      if not seen[key] then
        cuts[#cuts + 1] = cut
        seen[key] = true
      end
    end
  end

  table.sort(cuts)
  return cuts
end

local function build_note_edit_plan(entries, ctx, settings)
  local edits = {}
  local warnings = {}
  local cuts = unique_safe_cuts(entries, ctx)

  for index, entry in ipairs(entries or {}) do
    local next_entry = entries[index + 1]
    local delta = entry.desired_delta_s or 0
    local reason = nil

    if math.abs(delta) <= settings.tolerance_s then
      reason = "within tolerance"
    elseif not entry.cut_safe or not entry.cut_time then
      reason = entry.cut_reason or "unsafe cut before note"
    elseif next_entry and (not next_entry.cut_safe or not next_entry.cut_time) then
      reason = next_entry.cut_reason or "unsafe cut before next note"
    end

    if reason and reason ~= "within tolerance" then
      warnings[#warnings + 1] = reason
    elseif not reason then
      edits[#edits + 1] = {
        note_index = index,
        segment_start = entry.cut_time,
        segment_end = next_entry and next_entry.cut_time or ctx.item_end,
        delta_s = delta,
        note_count = 1,
        onset = entry.onset,
        grid = entry.grid
      }
    end
  end

  return {
    cuts = cuts,
    edits = edits,
    warnings = warnings
  }
end

local function validate_group_edits(ctx, groups, settings)
  local source_length = source_bounds(ctx)
  local playrate = take_playrate(ctx)
  local original_offset = take_start_offset(ctx)
  local edits = {}
  local warnings = {}

  if not playrate then
    return edits, { "unsupported take playrate" }
  end

  for index, group in ipairs(groups) do
    local next_group = groups[index + 1]
    local delta_s = group.desired_delta_s or 0
    local effective_delta_s = delta_s
    local reason = nil

    if math.abs(delta_s) <= settings.tolerance_s then
      effective_delta_s = 0
    elseif not group.cut_safe or not group.cut_time then
      effective_delta_s = 0
      reason = group.cut_reason or "unsafe cut before note"
    elseif next_group and math.abs((next_group.desired_delta_s or 0) - delta_s) > settings.tolerance_s and not next_group.cut_safe then
      effective_delta_s = 0
      reason = next_group.cut_reason or "unsafe cut before next note"
    end

    local segment_start = group.cut_time or ctx.item_start
    if segment_start < ctx.item_start + EPS then segment_start = ctx.item_start end
    local segment_end = next_group and next_group.cut_time or ctx.item_end
    if not segment_end or segment_end <= segment_start then segment_end = ctx.item_end end

    if effective_delta_s ~= 0 and source_length then
      local offset_at_segment = original_offset + ((segment_start - ctx.item_start) * playrate)
      local shifted_offset = offset_at_segment + (effective_delta_s * playrate)
      local shifted_end = shifted_offset + ((segment_end - segment_start) * playrate)
      if shifted_offset < -EPS or shifted_end > source_length + EPS then
        effective_delta_s = 0
        reason = "slip would exceed media source bounds"
      end
    end

    if reason then
      warnings[#warnings + 1] = reason
    end

    group.effective_delta_s = effective_delta_s
    group.segment_start = segment_start
    group.segment_end = segment_end
  end

  local merged = {}
  for _, group in ipairs(groups) do
    local previous = merged[#merged]
    if previous and math.abs((group.effective_delta_s or 0) - (previous.effective_delta_s or 0)) <= settings.tolerance_s then
      previous.segment_end = group.segment_end
      for _, entry in ipairs(group.entries or {}) do
        previous.entries[#previous.entries + 1] = entry
      end
    else
      merged[#merged + 1] = group
    end
  end

  for index, group in ipairs(merged) do
    local delta = group.effective_delta_s or 0
    local previous_delta = index > 1 and (merged[index - 1].effective_delta_s or 0) or 0
    local needs_boundary = math.abs(delta) > settings.tolerance_s or math.abs(previous_delta) > settings.tolerance_s
    local starts_at_item = group.segment_start <= ctx.item_start + EPS

    if needs_boundary and (starts_at_item or group.cut_safe) then
      if math.abs(delta) > settings.tolerance_s then
        edits[#edits + 1] = {
          segment_start = group.segment_start,
          segment_end = group.segment_end,
          delta_s = delta,
          note_count = #(group.entries or {}),
          onset = group.entries[1] and group.entries[1].onset or group.segment_start,
          grid = group.entries[1] and group.entries[1].grid or group.segment_start
        }
      end
    elseif needs_boundary then
      warnings[#warnings + 1] = group.cut_reason or "unsafe boundary"
    end
  end

  return edits, warnings, merged
end

local function build_boundaries(ctx, groups, settings)
  local boundaries = {}
  local seen = {}

  for index, group in ipairs(groups or {}) do
    local delta = group.effective_delta_s or 0
    local previous_delta = index > 1 and (groups[index - 1].effective_delta_s or 0) or 0
    local needs_boundary = math.abs(delta) > settings.tolerance_s or math.abs(previous_delta) > settings.tolerance_s
    if needs_boundary and group.cut_safe and group.segment_start > ctx.item_start + EPS and group.segment_start < ctx.item_end - EPS then
      local key = tostring(math.floor(group.segment_start * 1000000 + 0.5))
      if not seen[key] then
        boundaries[#boundaries + 1] = group.segment_start
        seen[key] = true
      end
    end
  end

  table.sort(boundaries)
  return boundaries
end

local function set_boundary_fades(left_item, right_item, settings)
  if settings.fade_s <= 0 then return end
  local left_len = reaper.GetMediaItemInfo_Value(left_item, "D_LENGTH")
  local right_len = reaper.GetMediaItemInfo_Value(right_item, "D_LENGTH")
  local fade = math.min(settings.fade_s, math.max(0, left_len / 3), math.max(0, right_len / 3))
  if fade <= 0 then return end
  reaper.SetMediaItemInfo_Value(left_item, "D_FADEOUTLEN_AUTO", 0)
  reaper.SetMediaItemInfo_Value(right_item, "D_FADEINLEN_AUTO", 0)
  reaper.SetMediaItemInfo_Value(left_item, "D_FADEOUTLEN", fade)
  reaper.SetMediaItemInfo_Value(right_item, "D_FADEINLEN", fade)
end

local function cut_key(time)
  return tostring(math.floor((time or 0) * 1000000 + 0.5))
end

local function split_item_at_boundaries(item, boundaries, settings)
  local current = item
  local segments_by_start = {}
  local cut_count = 0

  local sorted = {}
  for _, boundary in ipairs(boundaries or {}) do
    sorted[#sorted + 1] = boundary
  end
  table.sort(sorted, function(a, b) return a > b end)

  for _, boundary in ipairs(sorted) do
    if current then
      local current_start = reaper.GetMediaItemInfo_Value(current, "D_POSITION")
      local current_end = current_start + reaper.GetMediaItemInfo_Value(current, "D_LENGTH")
      if boundary > current_start + EPS and boundary < current_end - EPS then
        local right = reaper.SplitMediaItem(current, boundary)
        if not right then error("could not split item for pluck quantize") end
        set_boundary_fades(current, right, settings)
        segments_by_start[cut_key(boundary)] = right
        cut_count = cut_count + 1
      end
    end
  end

  if current then
    local position = reaper.GetMediaItemInfo_Value(current, "D_POSITION")
    segments_by_start[cut_key(position)] = current
  end
  return segments_by_start, cut_count
end

local function apply_pluck_edits(analysis, settings)
  local segments_by_start, cut_count = split_item_at_boundaries(analysis.item, analysis.cuts or {}, settings)
  local changed = {}

  for _, edit in ipairs(analysis.edits or {}) do
    local segment = segments_by_start[cut_key(edit.segment_start)]
    if segment then
      local take = reaper.GetActiveTake(segment)
      local playrate = take and reaper.GetMediaItemTakeInfo_Value(take, "D_PLAYRATE") or nil
      if take and playrate and playrate > 0 then
        local before = reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS") or 0
        local after = before + (edit.delta_s * playrate)
        reaper.SetMediaItemTakeInfo_Value(take, "D_STARTOFFS", after)
        changed[#changed + 1] = {
          start = edit.segment_start,
          ["end"] = edit.segment_end,
          delta_ms = edit.delta_s * 1000,
          before_offset = before,
          after_offset = after,
          notes = edit.note_count
        }
      end
    end
  end

  return changed, cut_count
end

local function analyze_item_for_plucks(item, settings)
  local ctx, context_error = item_audio_context(item)
  if not ctx then return nil, context_error end

  local accessor = reaper.CreateTakeAudioAccessor(ctx.take)
  if not accessor then return nil, "could not create audio accessor" end

  local ok, result, reason = pcall(function()
    reaper.AudioAccessorUpdate(accessor)
    local analysis_start, analysis_end = audio_accessor_range(accessor, ctx.item_start, ctx.item_end)
    local detection, detection_reason = detect_pluck_onsets(accessor, ctx.sample_rate, ctx.channels, analysis_start, analysis_end, settings)
    if not detection then return nil, detection_reason end

    local time_map = build_time_map(ctx, analysis_start, analysis_end)
    local entries = build_note_entries(accessor, ctx, detection.onsets, settings, time_map)
    local plan = build_note_edit_plan(entries, ctx, settings)

    return {
      item = item,
      ctx = ctx,
      time_map = time_map,
      onsets = detection.onsets,
      note_entries = entries,
      groups = {},
      cuts = plan.cuts,
      edits = plan.edits,
      edit_warnings = plan.warnings,
      thresholds = detection.thresholds
    }
  end)

  reaper.DestroyAudioAccessor(accessor)
  if not ok then error(result) end
  return result, reason
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

local function add_text_warning(warnings, item, reason)
  if not reason then return end
  add_warning(warnings, item, reason)
end

local function append_examples(examples, analysis)
  if #examples >= 16 then return end
  local summary = item_summary(analysis.item)
  for _, entry in ipairs(analysis.note_entries or {}) do
    if #examples >= 16 then break end
    examples[#examples + 1] = {
      track = summary.track,
      item_index = summary.item_index,
      onset = entry.onset,
      grid = entry.grid,
      delta_ms = entry.delta_s * 1000,
      desired_delta_ms = entry.desired_delta_s * 1000,
      cut = entry.cut_time,
      cut_safe = entry.cut_safe,
      cut_reason = entry.cut_reason,
      peak_db = entry.peak_db
    }
  end
end

local function command_quantize_pluck_items(command)
  local item_filter = command.itemFilter or { type = "selected" }
  if item_filter.type ~= "selected" then error("quantize-plucks only supports selected items") end

  local settings = pluck_settings(command)
  local items = collect_items(item_filter)
  local analyses = {}
  local analyzed = 0
  local skipped = 0
  local detected = 0
  local planned = 0
  local changed_total = 0
  local cut_total = 0
  local warnings = {}
  local skip_reasons = {}
  local examples = {}
  local threshold_examples = {}

  for _, item in ipairs(items) do
    local ok, analysis, reason = pcall(analyze_item_for_plucks, item, settings)
    if not ok then
      reason = tostring(analysis)
      analysis = nil
    end

    if not analysis then
      skipped = skipped + 1
      reason = reason or "not analyzed"
      skip_reasons[reason] = (skip_reasons[reason] or 0) + 1
      add_warning(warnings, item, reason)
    else
      analyzed = analyzed + 1
      detected = detected + #(analysis.onsets or {})
      planned = planned + #(analysis.edits or {})
      append_examples(examples, analysis)
      if #threshold_examples < 4 and analysis.thresholds then
        threshold_examples[#threshold_examples + 1] = analysis.thresholds
      end

      for _, warning in ipairs(analysis.edit_warnings or {}) do
        add_text_warning(warnings, item, warning)
      end

      if #(analysis.edits or {}) > 0 then analyses[#analyses + 1] = analysis end
    end
  end

  if not settings.preview then
    for _, analysis in ipairs(analyses) do
      local changed, cuts = apply_pluck_edits(analysis, settings)
      changed_total = changed_total + #changed
      cut_total = cut_total + cuts
    end
    reaper.UpdateArrange()
  end

  return {
    preview = settings.preview,
    matched = #items,
    analyzed = analyzed,
    skipped = skipped,
    detected = detected,
    planned = planned,
    changed = settings.preview and 0 or changed_total,
    cuts = settings.preview and 0 or cut_total,
    pre_roll_ms = settings.pre_roll_s * 1000,
    fade_ms = settings.fade_s * 1000,
    tolerance_ms = settings.tolerance_s * 1000,
    min_note_gap_ms = settings.min_note_gap_s * 1000,
    skip_reasons = skip_reasons,
    warnings = warnings,
    examples = examples,
    thresholds = threshold_examples
  }
end

function M.register(registry)
  registry.command("quantize_pluck_items", command_quantize_pluck_items, {
    read_only = function(command) return command.preview == true end
  })
end

return M
