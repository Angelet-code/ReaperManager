local _, script_path, section_id, command_id = reaper.get_action_context()
local script_dir = script_path:match("^(.*)[/\\][^/\\]+$")
package.path = script_dir .. "/?.lua;" .. script_dir .. "\\?.lua;" .. package.path

local json = require("rm_json")
local config = require("rm_config")

local root = config.workspace_root:gsub("\\", "/")
local queue_dir = root .. "/.reaper-manager/queue"
local state_dir = root .. "/.reaper-manager/state"
local response_dir = state_dir .. "/responses"
local running = true
local last_poll = 0
local BRIDGE_VERSION = "vocal-level-macro-micro-2026-05-24"

local function bridge_features()
  return {
    undo_command = true,
    vocal_level_estimated_points = true,
    vocal_level_zero_crossing_curve = true,
    vocal_level_phrase_safe_defaults = true,
    vocal_level_macro_micro = true
  }
end

local function join(a, b)
  return a .. "/" .. b
end

local function ensure_dirs()
  reaper.RecursiveCreateDirectory(root .. "/.reaper-manager", 0)
  reaper.RecursiveCreateDirectory(queue_dir, 0)
  reaper.RecursiveCreateDirectory(state_dir, 0)
  reaper.RecursiveCreateDirectory(response_dir, 0)
end

local function read_file(path)
  local file = io.open(path, "rb")
  if not file then return nil end
  local content = file:read("*a")
  file:close()
  return content
end

local function write_file(path, content)
  local tmp = path .. "." .. tostring(math.floor(reaper.time_precise() * 1000)) .. ".tmp"
  local file = assert(io.open(tmp, "wb"))
  file:write(content)
  file:close()
  os.remove(path)
  assert(os.rename(tmp, path))
end

local function respond(id, ok, data)
  local payload = {
    id = id,
    ok = ok,
    time = os.date("!%Y-%m-%dT%H:%M:%SZ")
  }
  if ok then
    payload.data = data
  else
    payload.error = tostring(data)
  end
  local encoded = json.encode(payload)
  write_file(join(response_dir, id .. ".json"), encoded)
  write_file(join(state_dir, "last-response.json"), encoded)
end

local function heartbeat()
  local _, project_path = reaper.EnumProjects(-1, "")
  local payload = {
    ok = true,
    bridge = "running",
    bridge_version = BRIDGE_VERSION,
    features = bridge_features(),
    time = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    project_path = project_path,
    track_count = reaper.CountTracks(0)
  }
  write_file(join(state_dir, "heartbeat.json"), json.encode(payload))
end

local function track_name(track)
  local _, name = reaper.GetTrackName(track)
  return name or ""
end

local function collect_tracks(filter)
  local tracks = {}
  filter = filter or { type = "all" }

  if filter.type == "selected" then
    for i = 0, reaper.CountSelectedTracks(0) - 1 do
      tracks[#tracks + 1] = reaper.GetSelectedTrack(0, i)
    end
    return tracks
  end

  local needle = nil
  if filter.type == "name_contains" then
    needle = filter.value or ""
    if not filter.caseSensitive then needle = needle:lower() end
  end

  for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    if filter.type == "all" then
      tracks[#tracks + 1] = track
    elseif filter.type == "all_audio" then
      if reaper.CountTrackMediaItems(track) > 0 then tracks[#tracks + 1] = track end
    elseif filter.type == "name_contains" then
      local name = track_name(track)
      local haystack = filter.caseSensitive and name or name:lower()
      if haystack:find(needle, 1, true) then tracks[#tracks + 1] = track end
    else
      error("unsupported track filter: " .. tostring(filter.type))
    end
  end

  return tracks
end

local function track_summaries(tracks)
  local out = {}
  for i, track in ipairs(tracks) do
    out[#out + 1] = {
      index = math.floor(reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")),
      name = track_name(track)
    }
  end
  return out
end

local function lower(value)
  return tostring(value or ""):lower()
end

local function trim(value)
  return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function balance_key_name(value)
  return trim(lower(value)):gsub("%s+", " ")
end

local function track_index(track)
  return math.floor(reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER"))
end

local function find_track_by_exact_name(name, label)
  local needle = balance_key_name(name)
  if needle == "" then error("missing " .. label .. " name") end

  local matches = {}
  for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    if balance_key_name(track_name(track)) == needle then
      matches[#matches + 1] = track
    end
  end

  if #matches == 0 then error(label .. " not found: " .. tostring(name)) end
  if #matches > 1 then error(label .. " is ambiguous: " .. tostring(name)) end
  return matches[1]
end

local function plain_gsub(value, from, to)
  from = tostring(from or "")
  if from == "" then return value end
  local result = {}
  local start = 1
  while true do
    local s, e = tostring(value):find(from, start, true)
    if not s then
      result[#result + 1] = tostring(value):sub(start)
      break
    end
    result[#result + 1] = tostring(value):sub(start, s - 1)
    result[#result + 1] = tostring(to or "")
    start = e + 1
  end
  return table.concat(result)
end

local function set_boolean_action(current, action)
  if action == "on" then return true end
  if action == "off" then return false end
  if action == "toggle" then return not current end
  error("invalid state action: " .. tostring(action))
end

local function find_track_by_exact_name(name)
  local wanted = lower(name)
  for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    if lower(track_name(track)) == wanted then return track end
  end
  return nil
end

local function sort_tracks_by_index(tracks)
  table.sort(tracks, function(a, b)
    return reaper.GetMediaTrackInfo_Value(a, "IP_TRACKNUMBER") < reaper.GetMediaTrackInfo_Value(b, "IP_TRACKNUMBER")
  end)
end

local function color_native(color)
  return reaper.ColorToNative(color.r or 0, color.g or 0, color.b or 0) | 0x1000000
end

local COLORS = {
  slate = { r = 95, g = 110, b = 125 },
  red = { r = 220, g = 55, b = 55 },
  orange = { r = 235, g = 140, b = 40 },
  yellow = { r = 230, g = 190, b = 45 },
  green = { r = 55, g = 170, b = 90 },
  blue = { r = 55, g = 115, b = 220 },
  purple = { r = 145, g = 85, b = 220 },
  pink = { r = 225, g = 90, b = 160 },
  teal = { r = 55, g = 175, b = 170 },
  gray = { r = 140, g = 140, b = 140 }
}

local function db_to_gain(db)
  return 10 ^ ((db or -18) / 20)
end

local function gain_to_db(gain)
  if not gain or gain <= 0 then return -150 end
  return 20 * math.log(gain, 10)
end

local function collect_items(item_filter)
  item_filter = item_filter or { type = "selected" }
  local items = {}

  if item_filter.type == "all" then
    for i = 0, reaper.CountMediaItems(0) - 1 do
      items[#items + 1] = reaper.GetMediaItem(0, i)
    end
    return items
  end

  if item_filter.type == "selected" then
    for i = 0, reaper.CountSelectedMediaItems(0) - 1 do
      items[#items + 1] = reaper.GetSelectedMediaItem(0, i)
    end
    return items
  end

  if item_filter.type == "tracks" then
    local tracks = collect_tracks(item_filter.trackFilter)
    for _, track in ipairs(tracks) do
      for i = 0, reaper.CountTrackMediaItems(track) - 1 do
        items[#items + 1] = reaper.GetTrackMediaItem(track, i)
      end
    end
    return items
  end

  error("unsupported item filter: " .. tostring(item_filter.type))
end

local function item_summary(item)
  local track = reaper.GetMediaItemTrack(item)
  return {
    track = track and track_name(track) or "",
    item_index = math.floor(reaper.GetMediaItemInfo_Value(item, "IP_ITEMNUMBER")),
    position = reaper.GetMediaItemInfo_Value(item, "D_POSITION"),
    length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  }
end

local function clamp(value, min_value, max_value)
  if value < min_value then return min_value end
  if value > max_value then return max_value end
  return value
end

local function top_mean(values, fraction)
  table.sort(values)
  local count = #values
  if count == 0 then return nil end
  local top_count = math.max(1, math.floor(count * (fraction or 0.2) + 0.5))
  local start_index = math.max(1, count - top_count + 1)
  local sum = 0
  for i = start_index, count do
    sum = sum + values[i]
  end
  return sum / (count - start_index + 1)
end

local function sorted_number_copy(values)
  local copy = {}
  for _, value in ipairs(values or {}) do
    copy[#copy + 1] = value
  end
  table.sort(copy)
  return copy
end

local function median(values)
  local sorted = sorted_number_copy(values)
  local count = #sorted
  if count == 0 then return nil end
  local middle = math.floor((count + 1) / 2)
  if count % 2 == 1 then return sorted[middle] end
  return (sorted[middle] + sorted[middle + 1]) / 2
end

local function try_add_fx(track, fx)
  local name = fx.fxName or fx.name or fx.query
  local candidates = { name }

  if name and name:match("^VST3:") and not name:match("^VST3: ") then
    candidates[#candidates + 1] = name:gsub("^VST3:", "VST3: ")
  end
  if name and name:match("^VST:") and not name:match("^VST: ") then
    candidates[#candidates + 1] = name:gsub("^VST:", "VST: ")
  end
  if fx.name then candidates[#candidates + 1] = fx.name end

  for _, candidate in ipairs(candidates) do
    if candidate and candidate ~= "" then
      local index = reaper.TrackFX_AddByName(track, candidate, false, -1)
      if index >= 0 then
        return index, candidate
      end
    end
  end

  error("could not add FX: " .. tostring(name))
end

local function command_ping()
  local _, project_path = reaper.EnumProjects(-1, "")
  return {
    bridge_version = BRIDGE_VERSION,
    features = bridge_features(),
    project_path = project_path,
    track_count = reaper.CountTracks(0),
    selected_track_count = reaper.CountSelectedTracks(0)
  }
end

local function command_undo(command)
  local count = math.floor(tonumber(command.count) or 1)
  if count < 1 then count = 1 end

  for _ = 1, count do
    if reaper.Undo_DoUndo2 then
      reaper.Undo_DoUndo2(0)
    else
      reaper.Main_OnCommand(40029, 0)
    end
  end

  reaper.UpdateArrange()
  return {
    undone = count
  }
end

local function command_color_tracks(command)
  local tracks = collect_tracks(command.filter)
  local color = color_native(command.color or {})

  for _, track in ipairs(tracks) do
    reaper.SetTrackColor(track, color)
  end

  reaper.UpdateArrange()
  return {
    changed = #tracks,
    tracks = track_summaries(tracks)
  }
end

local function track_selected(track)
  return reaper.GetMediaTrackInfo_Value(track, "I_SELECTED") > 0
end

local function command_select_tracks(command)
  local tracks = collect_tracks(command.filter)
  local mode = command.mode or "replace"
  local changed = {}

  if mode == "replace" then
    if #tracks > 0 then
      local target = {}
      for _, track in ipairs(tracks) do
        target[track] = true
      end

      for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local should_select = target[track] == true
        local before = track_selected(track)
        if before ~= should_select then
          reaper.SetTrackSelected(track, should_select)
          changed[#changed + 1] = {
            track = track_name(track),
            selected = should_select
          }
        end
      end
    end
  elseif mode == "add" or mode == "remove" or mode == "toggle" then
    for _, track in ipairs(tracks) do
      local before = track_selected(track)
      local after = before
      if mode == "add" then
        after = true
      elseif mode == "remove" then
        after = false
      elseif mode == "toggle" then
        after = not before
      end

      if before ~= after then
        reaper.SetTrackSelected(track, after)
        changed[#changed + 1] = {
          track = track_name(track),
          selected = after
        }
      end
    end
  else
    error("unsupported selection mode: " .. tostring(mode))
  end

  reaper.TrackList_AdjustWindows(false)
  reaper.UpdateArrange()
  return {
    mode = mode,
    matched = #tracks,
    changed = #changed,
    selected = reaper.CountSelectedTracks(0),
    tracks = track_summaries(tracks)
  }
end

local function item_selected(item)
  if reaper.IsMediaItemSelected then return reaper.IsMediaItemSelected(item) end
  return reaper.GetMediaItemInfo_Value(item, "B_UISEL") > 0
end

local function command_select_items(command)
  local items = collect_items(command.itemFilter or command.filter)
  local mode = command.mode or "replace"
  local changed = {}

  local function add_changed(item, selected)
    local summary = item_summary(item)
    changed[#changed + 1] = {
      track = summary.track,
      item_index = summary.item_index,
      position = summary.position,
      length = summary.length,
      selected = selected
    }
  end

  if mode == "replace" then
    if #items > 0 then
      local target = {}
      for _, item in ipairs(items) do
        target[item] = true
      end

      for i = 0, reaper.CountMediaItems(0) - 1 do
        local item = reaper.GetMediaItem(0, i)
        local should_select = target[item] == true
        local before = item_selected(item)
        if before ~= should_select then
          reaper.SetMediaItemSelected(item, should_select)
          add_changed(item, should_select)
        end
      end
    end
  elseif mode == "add" or mode == "remove" or mode == "toggle" then
    for _, item in ipairs(items) do
      local before = item_selected(item)
      local after = before
      if mode == "add" then
        after = true
      elseif mode == "remove" then
        after = false
      elseif mode == "toggle" then
        after = not before
      end

      if before ~= after then
        reaper.SetMediaItemSelected(item, after)
        add_changed(item, after)
      end
    end
  else
    error("unsupported selection mode: " .. tostring(mode))
  end

  reaper.UpdateArrange()
  return {
    mode = mode,
    matched = #items,
    changed = #changed,
    selected = reaper.CountSelectedMediaItems(0),
    items = changed
  }
end

local function command_add_fx(command)
  local tracks = collect_tracks(command.filter)
  local added = {}

  for _, track in ipairs(tracks) do
    local index, used_name = try_add_fx(track, command.fx or {})
    added[#added + 1] = {
      track = track_name(track),
      fx_index = index,
      fx_name = used_name
    }
  end

  return {
    changed = #added,
    added = added
  }
end

local function command_remove_fx(command)
  local tracks = collect_tracks(command.filter)
  local changed = {}
  local removed_total = 0

  for _, track in ipairs(tracks) do
    local count = reaper.TrackFX_GetCount(track)
    for fx = count - 1, 0, -1 do
      reaper.TrackFX_Delete(track, fx)
    end

    changed[#changed + 1] = {
      track = track_name(track),
      removed = count
    }
    removed_total = removed_total + count
  end

  reaper.UpdateArrange()
  return {
    tracks = changed,
    removed = removed_total
  }
end

local function command_delete_tracks(command)
  local tracks = collect_tracks(command.filter)
  sort_tracks_by_index(tracks)
  local deleted = track_summaries(tracks)

  for i = #tracks, 1, -1 do
    reaper.DeleteTrack(tracks[i])
  end

  reaper.TrackList_AdjustWindows(false)
  reaper.UpdateArrange()
  return {
    deleted = #deleted,
    tracks = deleted
  }
end

local function command_adjust_volume(command)
  local tracks = collect_tracks(command.filter)
  local delta_db = command.db or 0
  local factor = db_to_gain(delta_db)
  local changed = {}

  for _, track in ipairs(tracks) do
    local before = reaper.GetMediaTrackInfo_Value(track, "D_VOL")
    local after = before * factor
    reaper.SetMediaTrackInfo_Value(track, "D_VOL", after)
    changed[#changed + 1] = {
      track = track_name(track),
      before_db = gain_to_db(before),
      after_db = gain_to_db(after),
      delta_db = delta_db
    }
  end

  reaper.UpdateArrange()
  return {
    changed = #changed,
    tracks = changed
  }
end

local function command_set_pan(command)
  local tracks = collect_tracks(command.filter)
  local pan = command.pan or 0
  local changed = {}

  for _, track in ipairs(tracks) do
    local before = reaper.GetMediaTrackInfo_Value(track, "D_PAN")
    reaper.SetMediaTrackInfo_Value(track, "D_PAN", pan)
    changed[#changed + 1] = {
      track = track_name(track),
      before = before,
      after = pan
    }
  end

  reaper.UpdateArrange()
  return {
    changed = #changed,
    tracks = changed
  }
end

local function build_balance_entries(root_track, include_bus)
  local entries = {}

  if include_bus then
    entries[#entries + 1] = {
      key = "__bus__",
      track = root_track,
      name = track_name(root_track)
    }
  end

  local function receive_sources(parent)
    local sources = {}
    for i = 0, reaper.CountTracks(0) - 1 do
      local source = reaper.GetTrack(0, i)
      for send_index = 0, reaper.GetTrackNumSends(source, 0) - 1 do
        local dest = reaper.GetTrackSendInfo_Value(source, 0, send_index, "P_DESTTRACK")
        if dest == parent then
          sources[#sources + 1] = source
        end
      end
    end
    return sources
  end

  local function walk(parent, prefix)
    local received = receive_sources(parent)
    local ordinals = {}

    for _, child in ipairs(received) do
      if child then
        local base = balance_key_name(track_name(child))
        ordinals[base] = (ordinals[base] or 0) + 1
        local key_part = base .. "#" .. tostring(ordinals[base])
        local key = prefix and (prefix .. "/" .. key_part) or key_part

        entries[#entries + 1] = {
          key = key,
          track = child,
          name = track_name(child)
        }

        if #receive_sources(child) > 0 then
          walk(child, key)
        end
      end
    end
  end

  walk(root_track, nil)
  return entries
end

local function command_copy_track_balance(command)
  local source_bus_name = command.sourceBus or command.from or command.source
  local target_bus_name = command.targetBus or command.to or command.target
  local include_volume = command.includeVolume ~= false
  local include_pan = command.includePan ~= false
  local include_bus = command.includeBus ~= false

  local source_bus = find_track_by_exact_name(source_bus_name, "source bus")
  local target_bus = find_track_by_exact_name(target_bus_name, "target bus")
  local source_entries = build_balance_entries(source_bus, include_bus)
  local target_entries = build_balance_entries(target_bus, include_bus)
  local target_by_key = {}

  for _, entry in ipairs(target_entries) do
    target_by_key[entry.key] = entry
  end

  local changed = {}
  local skipped = {}

  for _, source in ipairs(source_entries) do
    local target = target_by_key[source.key]
    if target then
      local source_vol = reaper.GetMediaTrackInfo_Value(source.track, "D_VOL")
      local source_pan = reaper.GetMediaTrackInfo_Value(source.track, "D_PAN")
      local before_vol = reaper.GetMediaTrackInfo_Value(target.track, "D_VOL")
      local before_pan = reaper.GetMediaTrackInfo_Value(target.track, "D_PAN")

      if include_volume then reaper.SetMediaTrackInfo_Value(target.track, "D_VOL", source_vol) end
      if include_pan then reaper.SetMediaTrackInfo_Value(target.track, "D_PAN", source_pan) end

      changed[#changed + 1] = {
        key = source.key,
        source_index = track_index(source.track),
        source = source.name,
        target_index = track_index(target.track),
        target = target.name,
        before_db = gain_to_db(before_vol),
        after_db = gain_to_db(source_vol),
        before_pan = before_pan,
        after_pan = source_pan
      }
    else
      skipped[#skipped + 1] = {
        key = source.key,
        source_index = track_index(source.track),
        source = source.name
      }
    end
  end

  reaper.TrackList_AdjustWindows(false)
  reaper.UpdateArrange()
  return {
    changed = #changed,
    skipped = #skipped,
    source_bus = track_name(source_bus),
    target_bus = track_name(target_bus),
    tracks = changed,
    skipped_tracks = skipped
  }
end

local function command_adjust_send_volume(command)
  local tracks = collect_tracks(command.filter)
  local delta_db = command.db or 0
  local factor = db_to_gain(delta_db)
  local destination = command.destinationContains and lower(command.destinationContains) or nil
  local changed = {}

  for _, source in ipairs(tracks) do
    local send_count = reaper.GetTrackNumSends(source, 0)
    for send_index = 0, send_count - 1 do
      local dest = reaper.GetTrackSendInfo_Value(source, 0, send_index, "P_DESTTRACK")
      local dest_name = dest and track_name(dest) or ""
      if not destination or lower(dest_name):find(destination, 1, true) then
        local before = reaper.GetTrackSendInfo_Value(source, 0, send_index, "D_VOL")
        local after = before * factor
        reaper.SetTrackSendInfo_Value(source, 0, send_index, "D_VOL", after)
        changed[#changed + 1] = {
          source = track_name(source),
          destination = dest_name,
          send_index = send_index,
          before_db = gain_to_db(before),
          after_db = gain_to_db(after),
          delta_db = delta_db
        }
      end
    end
  end

  return {
    changed = #changed,
    sends = changed
  }
end

local function command_adjust_item_volume(command)
  local items = collect_items(command.itemFilter)
  local delta_db = command.db or 0
  local factor = db_to_gain(delta_db)
  local changed = {}

  for _, item in ipairs(items) do
    local before = reaper.GetMediaItemInfo_Value(item, "D_VOL")
    local after = before * factor
    reaper.SetMediaItemInfo_Value(item, "D_VOL", after)
    local track = reaper.GetMediaItem_Track(item)
    changed[#changed + 1] = {
      track = track and track_name(track) or "",
      before_db = gain_to_db(before),
      after_db = gain_to_db(after),
      delta_db = delta_db
    }
  end

  reaper.UpdateArrange()
  return {
    changed = #changed,
    items = changed
  }
end

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
    meso_strength = clamp(tonumber(command.mesoStrength) or 0.75, 0, 1),
    meso_deadband_db = tonumber(command.mesoDeadbandDb) or 1,
    meso_max_boost_db = tonumber(command.mesoMaxBoostDb) or 4,
    meso_max_cut_db = tonumber(command.mesoMaxCutDb) or 4,
    micro_repair = command.microRepair ~= false,
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
    ramp_s = (tonumber(command.rampMs) or 0) / 1000
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

    if radius > 0 then
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
    current.curve_gain_db = (desired_gain * detail) + (local_average * (1 - detail))
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
    protected_parts = 0,
    corrected_parts = 0,
    meso_corrected_parts = 0,
    micro_corrected_parts = 0,
    macro_corrected_zones = 0,
    max_boost_hits = 0,
    max_cut_hits = 0
  }

  for _, zone in ipairs(zones) do
    local zone_delta = target_dbfs - ((zone.reference_db or target_dbfs) + item_gain_stage_db)
    zone.zone_gain_db = vocal_deadband_gain(
      zone_delta,
      settings.macro_deadband_db,
      settings.macro_strength,
      settings.macro_max_boost_db,
      settings.macro_max_cut_db
    )
    zone.macro_gain_db = clamp(
      item_gain_stage_db + zone.zone_gain_db,
      -(settings.macro_max_cut_db or settings.max_cut_db or 8),
      settings.macro_max_boost_db or settings.max_boost_db or 8
    )
    if math.abs(zone.macro_gain_db or 0) > 0.001 then
      report.macro_corrected_zones = report.macro_corrected_zones + 1
    end

    zone.protected_parts = 0
    zone.corrected_parts = 0
    zone.meso_corrected_parts = 0
    zone.micro_corrected_parts = 0

    for _, segment in ipairs(zone.segments or {}) do
      segment.macro_zone_index = zone.index
      segment.macro_reference_db = zone.reference_db
      segment.item_gain_stage_db = item_gain_stage_db
      segment.zone_gain_db = zone.zone_gain_db
      segment.macro_gain_db = zone.macro_gain_db

      local local_delta_db = (zone.reference_db or segment.current_db or -150) - (segment.current_db or -150)
      local wants_boost = local_delta_db > 0
      local protected, protected_reason = macro_micro_segment_is_protected(segment, zone, settings)
      local already_good = math.abs(local_delta_db) <= (settings.already_good_db or 1)
      local short_repair = settings.micro_repair and (segment.length or 0) <= math.max(0.9, (settings.min_part_s or 0.3) * 2)
      local detail_gain_db = 0
      local correction_stage = "protected"

      if already_good then
        segment.already_good = true
        correction_stage = "already_good"
      else
        local deadband = short_repair and (settings.micro_deadband_db or 1.5) or (settings.meso_deadband_db or 1)
        if math.abs(local_delta_db) <= deadband then
          correction_stage = "deadband"
        else
          local boost_cap = short_repair and (settings.micro_max_boost_db or 2.5) or (settings.meso_max_boost_db or 4)
          local cut_cap = short_repair and (settings.micro_max_cut_db or 3) or (settings.meso_max_cut_db or 4)
          detail_gain_db = clamp(local_delta_db * (settings.meso_strength or 0.75), -cut_cap, boost_cap)
          correction_stage = short_repair and "micro" or "meso"

          if protected and wants_boost then
            detail_gain_db = math.min(detail_gain_db, settings.protected_max_boost_db or 0)
            correction_stage = "protected"
          end
        end
      end

      if correction_stage == "protected" or correction_stage == "already_good" or correction_stage == "deadband" then
        report.protected_parts = report.protected_parts + 1
        zone.protected_parts = zone.protected_parts + 1
      end

      local requested_gain_db = (zone.macro_gain_db or 0) + detail_gain_db
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

      segment.detail_gain_db = envelope.gain_db - (zone.macro_gain_db or 0)
      segment.requested_detail_gain_db = detail_gain_db
      segment.gain_db = envelope.gain_db
      segment.take_gain_db = envelope.take_gain_db
      segment.final_peak_db = envelope.final_peak_db
      segment.final_vu = envelope.final_vu
      segment.limited_by_peak = envelope.limited_by_peak
      segment.limited_by_max_boost = envelope.limited_by_max_boost
      segment.limited_by_max_cut = envelope.limited_by_max_cut
      segment.correction_stage = correction_stage
      segment.protected = protected or already_good or correction_stage == "deadband"
      segment.protected_reason = protected_reason
      segment.local_delta_db = local_delta_db

      if math.abs(segment.detail_gain_db or 0) > 0.001 then
        report.corrected_parts = report.corrected_parts + 1
        zone.corrected_parts = zone.corrected_parts + 1
        if correction_stage == "micro" then
          report.micro_corrected_parts = report.micro_corrected_parts + 1
          zone.micro_corrected_parts = zone.micro_corrected_parts + 1
        elseif correction_stage == "meso" then
          report.meso_corrected_parts = report.meso_corrected_parts + 1
          zone.meso_corrected_parts = zone.meso_corrected_parts + 1
        end
      end

      if segment.limited_by_max_boost then report.max_boost_hits = report.max_boost_hits + 1 end
      if segment.limited_by_max_cut then report.max_cut_hits = report.max_cut_hits + 1 end
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
      protected_parts = zone.protected_parts,
      corrected_parts = zone.corrected_parts,
      meso_corrected_parts = zone.meso_corrected_parts,
      micro_corrected_parts = zone.micro_corrected_parts
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

      return {
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
        macro_item_reference_db = macro_micro_report and macro_micro_report.item_reference_db or nil,
        macro_item_gain_stage_db = macro_micro_report and macro_micro_report.item_gain_stage_db or nil,
        macro_corrected_zones = macro_micro_report and macro_micro_report.macro_corrected_zones or 0,
        protected_parts = macro_micro_report and macro_micro_report.protected_parts or 0,
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

function append_vocal_level_point(points, time, gain_db, shape)
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
  local total_macro_corrected_zones = 0
  local total_protected_parts = 0
  local total_corrected_parts = 0
  local total_meso_corrected_parts = 0
  local total_micro_corrected_parts = 0
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
  local skip_reasons = {}

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
          total_macro_corrected_zones = total_macro_corrected_zones + (analysis.macro_corrected_zones or 0)
          total_protected_parts = total_protected_parts + (analysis.protected_parts or 0)
          total_corrected_parts = total_corrected_parts + (analysis.corrected_parts or 0)
          total_meso_corrected_parts = total_meso_corrected_parts + (analysis.meso_corrected_parts or 0)
          total_micro_corrected_parts = total_micro_corrected_parts + (analysis.micro_corrected_parts or 0)
          if analysis.macro_item_gain_stage_db then
            sum_macro_item_gain_stage_db = sum_macro_item_gain_stage_db + analysis.macro_item_gain_stage_db
            macro_item_gain_stage_count = macro_item_gain_stage_count + 1
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
                  protected_parts = zone.protected_parts,
                  corrected_parts = zone.corrected_parts,
                  meso_corrected_parts = zone.meso_corrected_parts,
                  micro_corrected_parts = zone.micro_corrected_parts
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
                macro_reference_db = segment.macro_reference_db,
                item_gain_stage_db = segment.item_gain_stage_db,
                zone_gain_db = segment.zone_gain_db,
                macro_gain_db = segment.macro_gain_db,
                detail_gain_db = segment.detail_gain_db,
                requested_detail_gain_db = segment.requested_detail_gain_db,
                correction_stage = segment.correction_stage,
                protected = segment.protected,
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
    macro_corrected_zones = total_macro_corrected_zones,
    protected_parts = total_protected_parts,
    corrected_parts = total_corrected_parts,
    meso_corrected_parts = total_meso_corrected_parts,
    micro_corrected_parts = total_micro_corrected_parts,
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
    meso_strength = settings.meso_strength,
    meso_deadband_db = settings.meso_deadband_db,
    meso_max_boost_db = settings.meso_max_boost_db,
    meso_max_cut_db = settings.meso_max_cut_db,
    micro_repair = settings.micro_repair,
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
    skip_reasons = skip_reasons,
    warnings = warnings,
    macro_zone_examples = macro_zone_examples,
    examples = examples
  }
end

local function normalize_words(value)
  local text = lower(value):gsub("[^a-z0-9]+", " ")
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  return " " .. text .. " "
end

local function compact_name(value)
  return lower(value):gsub("[^a-z0-9]+", "")
end

local function words_has(words, token)
  return words:find(" " .. token .. " ", 1, true) ~= nil
end

local function name_has_any(words, tokens)
  for _, token in ipairs(tokens) do
    if words_has(words, token) then return true end
  end
  return false
end

local function is_reference_name(name)
  local compact = compact_name(name)
  return compact == "ref" or compact == "reference" or compact:match("^ref%d+$") ~= nil or compact:match("^reference%d+$") ~= nil
end

local function send_mode_name(mode)
  if mode == 0 then return "post_fader_post_pan" end
  if mode == 1 then return "pre_fx" end
  if mode == 3 then return "pre_fader_post_fx" end
  return "mode_" .. tostring(mode)
end

local function classify_role(name)
  local words = normalize_words(name)
  local compact = compact_name(name)

  if is_reference_name(name) then return "reference" end
  if name_has_any(words, { "click", "metronome" }) then return "click" end
  if compact:find("leadvox", 1, true) or compact:find("leadvocal", 1, true) then return "lead_vocal" end
  if compact:find("backingvox", 1, true) or compact:find("backingvocal", 1, true) or compact:find("bvox", 1, true) then return "backing_vocal" end
  if compact:find("bass", 1, true) or compact:find("bajo", 1, true) then return "bass" end
  if compact:find("kick", 1, true) or compact:find("bombo", 1, true) then return "kick" end
  if compact:find("snare", 1, true) or compact:find("snr", 1, true) or compact:find("caja", 1, true) then return "snare" end
  if compact:find("hihat", 1, true) or compact:find("shaker", 1, true) then return "percussion" end
  if compact:find("elecgtr", 1, true) or compact:find("gtr", 1, true) or compact:find("guitar", 1, true) then return "guitar" end
  if compact:find("synth", 1, true) or compact:find("piano", 1, true) then return "keys" end
  if compact:find("sfx", 1, true) then return "fx" end
  if compact:find("loop", 1, true) or compact:find("chug", 1, true) then return "drums" end
  if (name_has_any(words, { "lead", "main", "principal" }) and name_has_any(words, { "vox", "vocal", "vocals", "voz" })) or words_has(words, "lv") then return "lead_vocal" end
  if name_has_any(words, { "backing", "bv", "bvox", "choir", "coro", "coros" }) then return "backing_vocal" end
  if name_has_any(words, { "vox", "vocal", "vocals", "voz" }) then return "vocal" end
  if name_has_any(words, { "bass", "bajo", "sub" }) then return "bass" end
  if name_has_any(words, { "kick", "bombo" }) then return "kick" end
  if name_has_any(words, { "snare", "snr", "caja" }) then return "snare" end
  if name_has_any(words, { "hihat", "hat", "shaker", "perc", "percussion" }) then return "percussion" end
  if name_has_any(words, { "drums", "drum", "loop", "chug" }) then return "drums" end
  if name_has_any(words, { "gtr", "guitar", "eguitar", "elecgtr", "acoustic", "guitarra" }) then return "guitar" end
  if name_has_any(words, { "synth", "piano", "keys", "key", "strings", "brass", "organ", "teclado", "teclas" }) then return "keys" end
  if name_has_any(words, { "sfx", "fx", "effect", "efecto" }) then return "fx" end
  return "unknown"
end

local function classify_category(entry)
  local words = normalize_words(entry.name)
  local compact = compact_name(entry.name)
  local has_receives = (entry.receive_count or 0) > 0
  local has_items = (entry.item_count or 0) > 0
  local is_reference = is_reference_name(entry.name)
  local is_click = name_has_any(words, { "click", "metronome" })
  local is_print = compact:find("mixprint", 1, true) or compact:find("referenceprint", 1, true)
  local is_final = name_has_any(words, { "render", "maxim" }) or compact == "sumitb" or compact == "allvocals" or compact == "allmusic"
  local is_mix_bus = entry.name:match("^Mix%s") ~= nil or is_final
  local is_parallel = (not has_items) and name_has_any(words, { "1176", "dbx", "tg1", "fairchild", "la2a", "parallel", "comp" })
  local is_return = (not has_items) and name_has_any(words, { "verb", "reverb", "delay", "echo", "room", "plate", "hall", "spring", "doubler", "air", "amb" })
  local is_bus = (not has_items) and has_receives

  entry.is_reference = is_reference
  entry.is_click = is_click
  entry.is_parallel = is_parallel
  entry.is_return = is_return
  entry.is_bus = is_bus or is_mix_bus

  if is_reference then
    entry.category = "reference"
    entry.excluded = true
    entry.exclude_reason = "reference"
  elseif is_click then
    entry.category = "click"
    entry.excluded = true
    entry.exclude_reason = "click"
  elseif is_print or is_final then
    entry.category = "final_bus"
    entry.excluded = true
    entry.exclude_reason = "final_or_print"
  elseif is_parallel then
    entry.category = "parallel"
    entry.excluded = true
    entry.exclude_reason = "parallel"
  elseif is_return then
    entry.category = "return"
    entry.excluded = true
    entry.exclude_reason = "return"
  elseif is_mix_bus then
    entry.category = "mix_bus"
    entry.excluded = true
    entry.exclude_reason = "mix_bus"
  elseif is_bus then
    entry.category = "group_bus"
    entry.excluded = true
    entry.exclude_reason = "bus"
  elseif has_items then
    entry.category = "source"
    entry.excluded = false
    entry.exclude_reason = nil
  else
    entry.category = "empty"
    entry.excluded = true
    entry.exclude_reason = "no_audio"
  end
end

local function media_source_file(source)
  if not source or not reaper.GetMediaSourceFileName then return nil end
  local ok, retval, filename = pcall(reaper.GetMediaSourceFileName, source, "")
  if not ok then return nil end
  if type(retval) == "string" then return retval end
  if type(filename) == "string" then return filename end
  return nil
end

local function reference_media_summary(track)
  local item_count = reaper.CountTrackMediaItems(track)
  local media = {
    itemCount = item_count
  }
  if item_count ~= 1 then return media end

  local item = reaper.GetTrackMediaItem(track, 0)
  local take = item and reaper.GetActiveTake(item) or nil
  local source = take and reaper.GetMediaItemTake_Source(take) or nil
  local source_file = media_source_file(source)
  media.sourceFile = source_file
  media.position = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  media.length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  media.startOffset = take and reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS") or 0
  media.playrate = take and reaper.GetMediaItemTakeInfo_Value(take, "D_PLAYRATE") or 1
  media.takeName = take and ({ reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", "", false) })[2] or ""
  if source_file then
    media.extension = lower(source_file:match("%.([^%.\\/]+)$") or "")
  end
  return media
end

local function is_chorus_section_name(name)
  local words = normalize_words(name)
  local compact = compact_name(name)
  return words_has(words, "chorus")
    or words_has(words, "hook")
    or words_has(words, "coro")
    or words_has(words, "coros")
    or compact:find("estribillo", 1, true) ~= nil
end

local function collect_project_sections()
  local _, marker_count, region_count = reaper.CountProjectMarkers(0)
  local total = (marker_count or 0) + (region_count or 0)
  local entries = {}
  local boundaries = {}
  local sections = {
    all = {},
    chorus = {}
  }

  for i = 0, total - 1 do
    local ok, is_region, pos, region_end, name, marker_index, color = reaper.EnumProjectMarkers3(0, i)
    if ok then
      local entry = {
        index = marker_index,
        name = tostring(name or ""),
        type = is_region and "region" or "marker",
        start = tonumber(pos) or 0,
        ["end"] = is_region and tonumber(region_end) or nil,
        color = color
      }
      entries[#entries + 1] = entry
      boundaries[#boundaries + 1] = entry.start

      if is_region and entry["end"] and entry["end"] > entry.start then
        local section = {
          index = entry.index,
          name = entry.name,
          type = "region",
          start = entry.start,
          ["end"] = entry["end"]
        }
        sections.all[#sections.all + 1] = section
        if is_chorus_section_name(entry.name) then
          sections.chorus[#sections.chorus + 1] = section
        end
      end
    end
  end

  table.sort(boundaries)
  local project_length = reaper.GetProjectLength and reaper.GetProjectLength(0) or 0

  local function next_boundary_after(position)
    for _, boundary in ipairs(boundaries) do
      if boundary > position + 0.25 then return boundary end
    end
    if project_length and project_length > position + 0.25 then return project_length end
    return nil
  end

  for _, entry in ipairs(entries) do
    if entry.type == "marker" and is_chorus_section_name(entry.name) then
      local section_end = next_boundary_after(entry.start)
      if section_end and section_end > entry.start then
        sections.chorus[#sections.chorus + 1] = {
          index = entry.index,
          name = entry.name,
          type = "marker_span",
          start = entry.start,
          ["end"] = section_end
        }
      end
    end
  end

  table.sort(sections.chorus, function(a, b) return a.start < b.start end)

  return {
    markers = entries,
    sections = sections.all,
    chorus = sections.chorus
  }
end

local function collect_project_inspection()
  local _, project_path = reaper.EnumProjects(-1, "")
  local tracks = {}
  local track_entries = {}
  local warnings = {}
  local project_sections = collect_project_sections()

  for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    local volume = reaper.GetMediaTrackInfo_Value(track, "D_VOL")
    local entry = {
      index = i + 1,
      guid = reaper.GetTrackGUID and reaper.GetTrackGUID(track) or "",
      name = track_name(track),
      role = classify_role(track_name(track)),
      category = "unknown",
      item_count = reaper.CountTrackMediaItems(track),
      fx_count = reaper.TrackFX_GetCount(track),
      volume = volume,
      volume_db = gain_to_db(volume),
      pan = reaper.GetMediaTrackInfo_Value(track, "D_PAN"),
      mainsend = reaper.GetMediaTrackInfo_Value(track, "B_MAINSEND") == 1,
      folder_depth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH"),
      selected = reaper.GetMediaTrackInfo_Value(track, "I_SELECTED") > 0,
      muted = reaper.GetMediaTrackInfo_Value(track, "B_MUTE") == 1,
      solo = reaper.GetMediaTrackInfo_Value(track, "I_SOLO") > 0,
      sends = {},
      receives = {},
      send_count = 0,
      receive_count = 0
    }
    tracks[#tracks + 1] = entry
    track_entries[track] = entry
  end

  for i = 0, reaper.CountTracks(0) - 1 do
    local source = reaper.GetTrack(0, i)
    local source_entry = track_entries[source]
    local send_count = reaper.GetTrackNumSends(source, 0)
    source_entry.send_count = send_count
    for send_index = 0, send_count - 1 do
      local dest = reaper.GetTrackSendInfo_Value(source, 0, send_index, "P_DESTTRACK")
      local dest_entry = dest and track_entries[dest] or nil
      local mode = math.floor(reaper.GetTrackSendInfo_Value(source, 0, send_index, "I_SENDMODE") or 0)
      local send = {
        send_index = send_index,
        destination_index = dest_entry and dest_entry.index or nil,
        destination_name = dest_entry and dest_entry.name or "",
        volume_db = gain_to_db(reaper.GetTrackSendInfo_Value(source, 0, send_index, "D_VOL")),
        pan = reaper.GetTrackSendInfo_Value(source, 0, send_index, "D_PAN"),
        mode = mode,
        mode_name = send_mode_name(mode)
      }
      source_entry.sends[#source_entry.sends + 1] = send
      if dest_entry then
        dest_entry.receives[#dest_entry.receives + 1] = {
          source_index = source_entry.index,
          source_name = source_entry.name,
          send_index = send_index,
          volume_db = send.volume_db,
          pan = send.pan,
          mode = mode,
          mode_name = send.mode_name
        }
        dest_entry.receive_count = #dest_entry.receives
      end
    end
  end

  local references = {}
  local sources = {}
  local buses = {}
  local parallels = {}
  local returns = {}
  local pre_fader_sends = {}

  for _, entry in ipairs(tracks) do
    classify_category(entry)
    if entry.is_reference then
      entry.media = reference_media_summary(reaper.GetTrack(0, entry.index - 1))
      references[#references + 1] = entry
    end
    if entry.category == "source" then sources[#sources + 1] = entry end
    if entry.category == "group_bus" or entry.category == "mix_bus" or entry.category == "final_bus" then buses[#buses + 1] = entry end
    if entry.category == "parallel" then parallels[#parallels + 1] = entry end
    if entry.category == "return" then returns[#returns + 1] = entry end

    if entry.category == "source" then
      for _, send in ipairs(entry.sends) do
        if send.mode ~= 0 then
          pre_fader_sends[#pre_fader_sends + 1] = {
            source = entry.name,
            destination = send.destination_name,
            mode = send.mode_name
          }
        end
      end
    end
  end

  if #references == 0 then
    warnings[#warnings + 1] = "No live reference track named REF or REFERENCE was found."
  end
  if #pre_fader_sends > 0 then
    warnings[#warnings + 1] = "Some source sends are pre-fader; source fader moves will not fully preserve those routing balances."
  end

  return {
    project_path = project_path,
    track_count = reaper.CountTracks(0),
    selected_track_count = reaper.CountSelectedTracks(0),
    references = references,
    reference = references[1] or nil,
    tracks = tracks,
    sections = project_sections,
    routing = {
      source_count = #sources,
      bus_count = #buses,
      parallel_count = #parallels,
      return_count = #returns,
      pre_fader_sends = pre_fader_sends,
      sources = sources,
      buses = buses,
      parallels = parallels,
      returns = returns
    },
    warnings = warnings
  }
end

local function command_inspect_project()
  return collect_project_inspection()
end

local function command_set_project_regions(command)
  local regions = command.regions or {}
  if #regions == 0 then error("no regions provided") end

  local created = {}
  for _, region in ipairs(regions) do
    local name = tostring(region.name or "")
    local start_time = tonumber(region.start)
    local end_time = tonumber(region["end"] or region.finish)
    if name == "" then error("region name is required") end
    if not start_time then error("region start is required for " .. name) end
    if not end_time then error("region end is required for " .. name) end
    if end_time <= start_time then error("region end must be after start for " .. name) end

    local color = 0
    if region.color then color = color_native(region.color) end
    local index = reaper.AddProjectMarker2(0, true, start_time, end_time, name, -1, color)
    created[#created + 1] = {
      index = index,
      name = name,
      start = start_time,
      ["end"] = end_time
    }
  end

  reaper.UpdateArrange()
  return {
    created = #created,
    regions = created
  }
end

local function delete_project_markers_by_names(names, clear_markers, clear_regions)
  local _, marker_count, region_count = reaper.CountProjectMarkers(0)
  local total = (marker_count or 0) + (region_count or 0)
  local to_delete = {}
  for i = 0, total - 1 do
    local ok, is_region, _, _, name, marker_index = reaper.EnumProjectMarkers3(0, i)
    if ok and names[tostring(name or "")] then
      if (is_region and clear_regions == true) or ((not is_region) and clear_markers == true) then
        to_delete[#to_delete + 1] = { index = marker_index, is_region = is_region }
      end
    end
  end
  for _, item in ipairs(to_delete) do
    reaper.DeleteProjectMarker(0, item.index, item.is_region)
  end
  return #to_delete
end

local function command_set_project_markers(command)
  local markers = command.markers or {}
  if #markers == 0 then error("no markers provided") end

  local names = {}
  for _, marker in ipairs(markers) do
    if marker.name then names[tostring(marker.name)] = true end
  end

  if command.clearRegions == true or command.clearMarkers == true then
    delete_project_markers_by_names(names, command.clearMarkers == true, command.clearRegions == true)
  end

  local created = {}
  for _, marker in ipairs(markers) do
    local name = tostring(marker.name or "")
    local position = tonumber(marker.position or marker.start)
    if name == "" then error("marker name is required") end
    if not position then error("marker position is required for " .. name) end

    local color = 0
    if marker.color then color = color_native(marker.color) end
    local index = reaper.AddProjectMarker2(0, false, position, 0, name, -1, color)
    created[#created + 1] = {
      index = index,
      name = name,
      position = position
    }
  end

  reaper.UpdateArrange()
  return {
    created = #created,
    markers = created
  }
end

local ARRANGEMENT_GROUPS = { "drums", "bass", "guitar", "keys", "lead", "backing", "fx", "music" }

local function arrangement_group_for_role(role)
  if role == "lead_vocal" or role == "vocal" then return "lead" end
  if role == "backing_vocal" then return "backing" end
  if role == "bass" then return "bass" end
  if role == "kick" or role == "snare" or role == "percussion" or role == "drums" then return "drums" end
  if role == "guitar" then return "guitar" end
  if role == "keys" then return "keys" end
  if role == "fx" then return "fx" end
  return "music"
end

local function zero_array(count)
  local out = {}
  for i = 1, count do out[i] = 0 end
  return out
end

local function project_tempo_grid()
  local tempo = 120
  if reaper.Master_GetTempo then tempo = tonumber(reaper.Master_GetTempo()) or tempo end
  local numerator = 4
  local denominator = 4
  if reaper.TimeMap_GetTimeSigAtTime then
    local ok, a, b, c = pcall(reaper.TimeMap_GetTimeSigAtTime, 0, 0)
    if ok then
      if tonumber(a) and tonumber(a) > 0 then numerator = tonumber(a) end
      if tonumber(b) and tonumber(b) > 0 then denominator = tonumber(b) end
      if tonumber(c) and tonumber(c) > 0 then tempo = tonumber(c) end
    end
  end
  return {
    tempo = tempo,
    numerator = numerator,
    denominator = denominator,
    seconds_per_bar = (60 / tempo) * numerator * (4 / denominator)
  }
end

local function measure_start_time(measure_index, fallback)
  if reaper.TimeMap_GetMeasureInfo and reaper.TimeMap2_QNToTime then
    local ok, qn_start = pcall(reaper.TimeMap_GetMeasureInfo, 0, measure_index)
    if ok and tonumber(qn_start) then
      local ok_time, time = pcall(reaper.TimeMap2_QNToTime, 0, qn_start)
      if ok_time and tonumber(time) then return tonumber(time) end
    end
  end
  return fallback
end

local function collect_arrangement_tracks()
  local tracks = {}
  local max_item_end = 0
  for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    local item_count = reaper.CountTrackMediaItems(track)
    local entry = {
      index = i + 1,
      name = track_name(track),
      role = classify_role(track_name(track)),
      item_count = item_count,
      receive_count = reaper.GetTrackNumSends(track, -1),
      category = "unknown"
    }
    classify_category(entry)
    if not entry.excluded and item_count > 0 then
      entry.group = arrangement_group_for_role(entry.role)
      entry.track = track
      tracks[#tracks + 1] = entry
      for item_index = 0, item_count - 1 do
        local item = reaper.GetTrackMediaItem(track, item_index)
        local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local item_end = item_start + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        if item_end > max_item_end then max_item_end = item_end end
      end
    end
  end
  return tracks, max_item_end
end

local function build_arrangement_units(project_end, units_per_bar)
  local grid = project_tempo_grid()
  local starts = {}
  local max_bars = math.max(1, math.ceil(project_end / grid.seconds_per_bar) + 2)
  for measure = 0, max_bars do
    local fallback = measure * grid.seconds_per_bar
    local start_time = measure_start_time(measure, fallback)
    if #starts > 0 and start_time <= starts[#starts] then
      start_time = starts[#starts] + grid.seconds_per_bar
    end
    starts[#starts + 1] = start_time
    if start_time >= project_end then break end
  end

  if #starts < 2 then
    starts = { 0, math.max(project_end, grid.seconds_per_bar) }
  end

  local units = {}
  for bar = 1, #starts - 1 do
    local bar_start = starts[bar]
    local bar_end = starts[bar + 1]
    local span = bar_end - bar_start
    for division = 1, units_per_bar do
      local start_time = bar_start + span * ((division - 1) / units_per_bar)
      local end_time = bar_start + span * (division / units_per_bar)
      units[#units + 1] = {
        bar = bar,
        division = division,
        start = start_time,
        ["end"] = end_time
      }
    end
  end

  return units, starts, grid
end

local function init_group_stats(unit_count)
  local stats = {}
  for _, group in ipairs(ARRANGEMENT_GROUPS) do
    stats[group] = {
      sum = zero_array(unit_count),
      count = zero_array(unit_count)
    }
  end
  return stats
end

local function analyze_item_for_arrangement(item, group, units, stats, settings)
  local take = reaper.GetActiveTake(item)
  if not take then return false, "no active take" end
  if reaper.TakeIsMIDI and reaper.TakeIsMIDI(take) then return false, "MIDI take" end

  local source = reaper.GetMediaItemTake_Source(take)
  if not source then return false, "no media source" end

  local sample_rate = math.floor(reaper.GetMediaSourceSampleRate(source) or 0)
  if sample_rate <= 0 then sample_rate = 48000 end

  local channels = math.floor(reaper.GetMediaSourceNumChannels(source) or 0)
  if channels <= 0 then return false, "no audio channels" end
  channels = math.min(channels, 8)

  local item_gain = math.abs(reaper.GetMediaItemInfo_Value(item, "D_VOL") or 1)
  local take_gain = math.abs(reaper.GetMediaItemTakeInfo_Value(take, "D_VOL") or 1)
  local combined_gain = item_gain * take_gain
  if combined_gain <= 0 then return false, "item/take volume is -inf" end

  local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local item_end = item_start + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  local accessor = reaper.CreateTakeAudioAccessor(take)
  if not accessor then return false, "could not create audio accessor" end

  local ok, err = pcall(function()
    reaper.AudioAccessorUpdate(accessor)
    local stride = math.max(1, math.floor(settings.sample_stride or 128))
    local block_samples = math.max(2048, math.floor(sample_rate * 0.25))
    block_samples = math.min(block_samples, 16384)
    local buffer = reaper.new_array(block_samples * channels)

    for unit_index, unit in ipairs(units) do
      local range_start = math.max(unit.start, item_start)
      local range_end = math.min(unit["end"], item_end)
      if range_end > range_start then
        local remaining = math.floor((range_end - range_start) * sample_rate)
        local position = range_start

        while remaining > 0 do
          local want = math.min(block_samples, remaining)
          buffer.resize(want * channels)
          buffer.clear()

          local retval = reaper.GetAudioAccessorSamples(accessor, sample_rate, channels, position, want, buffer)
          if retval == -1 then error("audio accessor error") end

          if retval == 1 then
            for frame = 0, want - 1, stride do
              local frame_square = 0
              for ch = 1, channels do
                local sample = (buffer[frame * channels + ch] or 0) * combined_gain
                frame_square = frame_square + sample * sample
              end
              stats[group].sum[unit_index] = stats[group].sum[unit_index] + (frame_square / channels)
              stats[group].count[unit_index] = stats[group].count[unit_index] + 1
            end
          end

          remaining = remaining - want
          position = position + (want / sample_rate)
        end
      end
    end
  end)

  reaper.DestroyAudioAccessor(accessor)
  if not ok then return false, tostring(err) end
  return true
end

local function compute_arrangement_features(stats, units, unit_count, units_per_bar, settings)
  local rel_db = {}
  local strengths = {}
  local active_floor = tonumber(settings.active_db) or -30

  for _, group in ipairs(ARRANGEMENT_GROUPS) do
    local rms = {}
    local max_rms = 0
    for i = 1, unit_count do
      local count = stats[group].count[i]
      local value = count > 0 and math.sqrt(stats[group].sum[i] / count) or 0
      rms[i] = value
      if value > max_rms then max_rms = value end
    end
    if max_rms <= 0 then max_rms = 1e-12 end

    rel_db[group] = {}
    strengths[group] = {}
    for i = 1, unit_count do
      local db = gain_to_db((rms[i] + 1e-12) / max_rms)
      rel_db[group][i] = db
      strengths[group][i] = clamp((db - active_floor) / (0 - active_floor), 0, 1)
    end
  end

  local bar_count = math.ceil(unit_count / units_per_bar)
  local bars = {}
  for bar = 1, bar_count do
    local feature = {
      bar = bar,
      start = units[(bar - 1) * units_per_bar + 1] and units[(bar - 1) * units_per_bar + 1].start or 0
    }
    for _, group in ipairs(ARRANGEMENT_GROUPS) do
      local total = 0
      local count = 0
      for division = 1, units_per_bar do
        local unit_index = (bar - 1) * units_per_bar + division
        if strengths[group][unit_index] then
          total = total + strengths[group][unit_index]
          count = count + 1
        end
      end
      feature[group] = count > 0 and (total / count) or 0
    end
    feature.music_strength = math.max(feature.guitar or 0, feature.keys or 0, (feature.fx or 0) * 0.65, feature.music or 0)
    feature.vocal_strength = math.max(feature.lead or 0, feature.backing or 0)
    feature.density = (
      (feature.drums or 0) * 1.1 +
      (feature.bass or 0) +
      feature.music_strength * 1.1 +
      (feature.lead or 0) * 0.9 +
      (feature.backing or 0) * 1.2 +
      (feature.fx or 0) * 0.4
    ) / 5.7
    feature.chorus_score = feature.density * 0.45 +
      (feature.backing or 0) * 0.24 +
      (feature.lead or 0) * 0.12 +
      (feature.bass or 0) * 0.08 +
      feature.music_strength * 0.11
    feature.vocal_active = feature.vocal_strength >= (tonumber(settings.vocal_threshold) or 0.45)
    feature.chorus_start = feature.chorus_score >= (tonumber(settings.chorus_start_threshold) or 0.82)
      and ((feature.backing or 0) >= 0.5 or ((feature.lead or 0) >= 0.75 and feature.density >= 0.78))
    feature.chorus_continue = feature.chorus_score >= (tonumber(settings.chorus_continue_threshold) or 0.74)
      and ((feature.backing or 0) >= 0.45 or feature.density >= 0.8)
    bars[#bars + 1] = feature
  end

  local unit_features = {}
  for i = 1, unit_count do
    local drums = strengths.drums[i] or 0
    local bass = strengths.bass[i] or 0
    local lead = strengths.lead[i] or 0
    local backing = strengths.backing[i] or 0
    local music = math.max(strengths.guitar[i] or 0, strengths.keys[i] or 0, (strengths.fx[i] or 0) * 0.65, strengths.music[i] or 0)
    unit_features[i] = {
      index = i,
      bar = units[i].bar,
      division = units[i].division,
      start = units[i].start,
      ["end"] = units[i]["end"],
      energy = (drums * 1.1 + bass + music * 1.1 + lead * 0.9 + backing * 1.2 + (strengths.fx[i] or 0) * 0.4) / 5.7,
      vocal = math.max(lead, backing)
    }
  end

  return {
    bars = bars,
    units = unit_features,
    rel_db = rel_db
  }
end

local function find_chorus_runs(bars)
  local runs = {}
  local i = 1
  while i <= #bars do
    if bars[i].chorus_start then
      local start_bar = i
      local end_bar = i
      local j = i + 1
      while j <= #bars and bars[j].chorus_continue do
        end_bar = j
        j = j + 1
      end
      runs[#runs + 1] = {
        start_bar = start_bar,
        end_bar = end_bar
      }
      i = j
    else
      i = i + 1
    end
  end
  return runs
end

local function first_vocal_bar_between(bars, start_bar, end_bar)
  for bar = math.max(1, start_bar), math.min(#bars, end_bar) do
    if bars[bar].vocal_active then return bar end
  end
  return nil
end

local function add_arrangement_marker(markers, name, position, color)
  if #markers > 0 and math.abs((markers[#markers].position or -999) - position) < 0.01 then
    return
  end
  markers[#markers + 1] = {
    name = name,
    position = position,
    color = color
  }
end

local function bar_position(bar_starts, bar)
  return bar_starts[bar] or 0
end

local function detect_break_unit(unit_features, from_unit, min_time)
  local best = nil
  local best_score = 0
  for i = math.max(2, from_unit or 2), #unit_features - 1 do
    local unit = unit_features[i]
    if unit.start >= min_time then
      local prev = unit_features[i - 1]
      local next_unit = unit_features[i + 1]
      local drop = prev.energy - unit.energy
      local recovery = next_unit.energy - unit.energy
      local score = math.min(drop, recovery)
      if score > best_score and drop >= 0.16 and recovery >= 0.10 and unit.vocal >= 0.35 then
        best_score = score
        best = unit
      end
    end
  end
  return best, best_score
end

local function known_arrangement_names()
  local names = {
    INTRO = true,
    BREAK = true,
    FINAL = true,
    OUTRO = true,
    PUENTE = true,
    BRIDGE = true,
    SOLO = true
  }
  for i = 1, 20 do
    names["VERSO " .. tostring(i)] = true
    names["VERSE " .. tostring(i)] = true
    names["PRECHORUS " .. tostring(i)] = true
    names["PRE-CHORUS " .. tostring(i)] = true
    names["ESTRIBILLO " .. tostring(i)] = true
    names["CHORUS " .. tostring(i)] = true
    names["PUENTE " .. tostring(i)] = true
    names["BRIDGE " .. tostring(i)] = true
    names["PARTE " .. tostring(i)] = true
  end
  return names
end

local function build_deterministic_arrangement_markers(features, bar_starts, project_end, units_per_bar, settings)
  local bars = features.bars
  local chorus_runs = find_chorus_runs(bars)
  local markers = {}
  local colors = {
    intro = COLORS.slate,
    verse = COLORS.blue,
    pre = COLORS.teal,
    chorus = COLORS.orange,
    break_part = COLORS.red,
    final = COLORS.purple,
    fallback = COLORS.gray
  }

  if #chorus_runs == 0 then
    add_arrangement_marker(markers, "INTRO", 0, colors.intro)
    local last = 1
    local part = 1
    for bar = 2, #bars do
      local previous = bars[bar - 1]
      local current = bars[bar]
      local change = math.abs((current.density or 0) - (previous.density or 0))
        + math.abs((current.vocal_strength or 0) - (previous.vocal_strength or 0))
        + math.abs((current.backing or 0) - (previous.backing or 0))
      if change >= 0.6 and bar - last >= 4 then
        add_arrangement_marker(markers, "PARTE " .. tostring(part), bar_position(bar_starts, bar), colors.fallback)
        last = bar
        part = part + 1
      end
    end
    if #markers == 1 then
      add_arrangement_marker(markers, "PARTE 1", 0, colors.fallback)
    end
    return markers, chorus_runs
  end

  local first_vocal = first_vocal_bar_between(bars, 1, chorus_runs[1].start_bar - 1)
  if first_vocal and first_vocal > 1 then
    add_arrangement_marker(markers, "INTRO", 0, colors.intro)
  else
    add_arrangement_marker(markers, "INTRO", 0, colors.intro)
  end

  local previous_after_chorus = 1
  for index, run in ipairs(chorus_runs) do
    local verse_start = first_vocal_bar_between(bars, previous_after_chorus, run.start_bar - 1)
    if verse_start then
      add_arrangement_marker(markers, "VERSO " .. tostring(index), bar_position(bar_starts, verse_start), colors.verse)
      local pre_start = run.start_bar - (tonumber(settings.prechorus_bars) or 4)
      if pre_start > verse_start and (run.start_bar - verse_start) >= (tonumber(settings.prechorus_min_gap_bars) or 8) then
        add_arrangement_marker(markers, "PRECHORUS " .. tostring(index), bar_position(bar_starts, pre_start), colors.pre)
      end
    end
    add_arrangement_marker(markers, "ESTRIBILLO " .. tostring(index), bar_position(bar_starts, run.start_bar), colors.chorus)
    previous_after_chorus = run.end_bar + 1
  end

  local last_run = chorus_runs[#chorus_runs]
  local from_unit = math.max(2, (last_run.start_bar - 1) * units_per_bar + 1)
  local break_unit = nil
  if settings.detect_breaks ~= false then
    break_unit = detect_break_unit(features.units, from_unit, project_end * 0.55)
  end
  if break_unit and project_end - break_unit["end"] >= 4 then
    add_arrangement_marker(markers, "BREAK", break_unit.start, colors.break_part)
    add_arrangement_marker(markers, "FINAL", break_unit["end"], colors.final)
  elseif previous_after_chorus <= #bars and project_end - bar_position(bar_starts, previous_after_chorus) >= 4 then
    add_arrangement_marker(markers, "FINAL", bar_position(bar_starts, previous_after_chorus), colors.final)
  end

  return markers, chorus_runs
end

local function command_detect_arrangement(command)
  local settings = {
    units_per_bar = math.max(1, math.floor(tonumber(command.unitsPerBar) or 2)),
    sample_stride = math.max(1, math.floor(tonumber(command.sampleStride) or 128)),
    active_db = tonumber(command.activeDb) or -30,
    vocal_threshold = tonumber(command.vocalThreshold) or 0.45,
    chorus_start_threshold = tonumber(command.chorusStartThreshold) or 0.82,
    chorus_continue_threshold = tonumber(command.chorusContinueThreshold) or 0.74,
    prechorus_bars = tonumber(command.prechorusBars) or 4,
    prechorus_min_gap_bars = tonumber(command.prechorusMinGapBars) or 8,
    detect_breaks = command.detectBreaks ~= false
  }

  local tracks, max_item_end = collect_arrangement_tracks()
  if #tracks == 0 then error("no source audio tracks found for arrangement detection") end

  local project_end = max_item_end
  if project_end <= 0 and reaper.GetProjectLength then project_end = reaper.GetProjectLength(0) end
  if project_end <= 0 then error("project is too short for arrangement detection") end

  local units, bar_starts, grid = build_arrangement_units(project_end, settings.units_per_bar)
  local stats = init_group_stats(#units)
  local skipped = {}
  local analyzed_items = 0

  for _, track_entry in ipairs(tracks) do
    for item_index = 0, reaper.CountTrackMediaItems(track_entry.track) - 1 do
      local item = reaper.GetTrackMediaItem(track_entry.track, item_index)
      local ok, reason = analyze_item_for_arrangement(item, track_entry.group, units, stats, settings)
      if ok then
        analyzed_items = analyzed_items + 1
      else
        skipped[reason or "unknown"] = (skipped[reason or "unknown"] or 0) + 1
      end
    end
  end

  if analyzed_items == 0 then error("no audio items could be analyzed") end

  local features = compute_arrangement_features(stats, units, #units, settings.units_per_bar, settings)
  local markers, chorus_runs = build_deterministic_arrangement_markers(features, bar_starts, project_end, settings.units_per_bar, settings)
  if #markers == 0 then error("arrangement detection produced no markers") end

  local created = {}
  local deleted = 0
  local apply_markers = command.applyMarkers ~= false and command.preview ~= true
  if apply_markers then
    if command.clearExisting ~= false then
      deleted = delete_project_markers_by_names(known_arrangement_names(), true, true)
    end
    for _, marker in ipairs(markers) do
      local color = marker.color and color_native(marker.color) or 0
      local index = reaper.AddProjectMarker2(0, false, marker.position, 0, marker.name, -1, color)
      created[#created + 1] = {
        index = index,
        name = marker.name,
        position = marker.position
      }
    end
    reaper.UpdateArrange()
  end

  local marker_summary = {}
  for _, marker in ipairs(markers) do
    marker_summary[#marker_summary + 1] = {
      name = marker.name,
      position = marker.position
    }
  end

  return {
    deterministic = true,
    applied = apply_markers,
    created = #created,
    deleted = deleted,
    markers = apply_markers and created or marker_summary,
    analyzed_tracks = #tracks,
    analyzed_items = analyzed_items,
    skipped = skipped,
    project_end = project_end,
    tempo = grid.tempo,
    time_signature = tostring(grid.numerator) .. "/" .. tostring(grid.denominator),
    units_per_bar = settings.units_per_bar,
    chorus_runs = chorus_runs
  }
end

local function balance_analysis_settings(command)
  return {
    window_ms = tonumber(command.windowMs) or 300,
    silence_db = tonumber(command.silenceDb) or -60,
    top_window_fraction = (tonumber(command.topWindowPercent) or 100) / 100,
    sample_stride = math.max(1, math.floor(tonumber(command.sampleStride) or 4))
  }
end

local function mean_top_window_metrics(windows, fraction)
  table.sort(windows, function(a, b) return a.total > b.total end)
  local count = #windows
  local top_count = math.max(1, math.floor(count * (fraction or 0.2) + 0.5))
  local totals = { total = 0, low = 0, mid = 0, high = 0, center = 0, side = 0, frames = 0 }
  for i = 1, top_count do
    local w = windows[i]
    totals.total = totals.total + w.total
    totals.low = totals.low + w.low
    totals.mid = totals.mid + w.mid
    totals.high = totals.high + w.high
    totals.center = totals.center + w.center
    totals.side = totals.side + w.side
    totals.frames = totals.frames + w.frames
  end
  if totals.frames <= 0 then return nil end
  return {
    rms_db = gain_to_db(math.sqrt(totals.total / totals.frames)),
    low_db = gain_to_db(math.sqrt(totals.low / totals.frames)),
    mid_db = gain_to_db(math.sqrt(totals.mid / totals.frames)),
    high_db = gain_to_db(math.sqrt(totals.high / totals.frames)),
    center_db = gain_to_db(math.sqrt(totals.center / totals.frames)),
    side_db = gain_to_db(math.sqrt(totals.side / totals.frames)),
    active_frames = totals.frames
  }
end

local function analyze_item_for_balance(item, settings)
  local take = reaper.GetActiveTake(item)
  if not take then return nil, "no active take" end
  if reaper.TakeIsMIDI and reaper.TakeIsMIDI(take) then return nil, "MIDI take" end

  local source = reaper.GetMediaItemTake_Source(take)
  if not source then return nil, "no media source" end

  local sample_rate = math.floor(reaper.GetMediaSourceSampleRate(source) or 0)
  if sample_rate <= 0 then sample_rate = 48000 end

  local channels = math.floor(reaper.GetMediaSourceNumChannels(source) or 0)
  if channels <= 0 then return nil, "no audio channels" end
  channels = math.min(channels, 8)

  local item_gain = math.abs(reaper.GetMediaItemInfo_Value(item, "D_VOL") or 1)
  local take_gain = math.abs(reaper.GetMediaItemTakeInfo_Value(take, "D_VOL") or 1)
  local combined_gain = item_gain * take_gain
  if combined_gain <= 0 then return nil, "item/take volume is -inf" end

  local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  local item_end = item_start + item_length
  local ranges = {}
  if settings.sections and #settings.sections > 0 then
    for _, section in ipairs(settings.sections) do
      local section_start = tonumber(section.start)
      local section_end = tonumber(section["end"] or section.finish)
      if section_start and section_end then
        local start_time = math.max(item_start, section_start)
        local end_time = math.min(item_end, section_end)
        if end_time > start_time then
          ranges[#ranges + 1] = { start = start_time, ["end"] = end_time }
        end
      end
    end
  else
    ranges[#ranges + 1] = { start = item_start, ["end"] = item_end }
  end

  if #ranges == 0 then return nil, "outside chorus section" end

  local accessor = reaper.CreateTakeAudioAccessor(take)
  if not accessor then return nil, "could not create audio accessor" end

  local ok, result_or_error, skip_reason = pcall(function()
    reaper.AudioAccessorUpdate(accessor)
    local stride = settings.sample_stride or 1
    local analysis_rate = sample_rate / stride
    local window_samples = math.max(1, math.floor(analysis_rate * settings.window_ms / 1000))
    local block_samples = math.min(16384, math.max(2048, window_samples))
    local buffer = reaper.new_array(block_samples * channels)
    local windows = {}
    local window = { total = 0, low = 0, mid = 0, high = 0, center = 0, side = 0, frames = 0 }
    local peak = 0
    local read_any = false
    local low_state = 0
    local high_cut_state = 0
    local low_alpha = 1 / (1 + analysis_rate / (2 * math.pi * 150))
    local high_alpha = 1 / (1 + analysis_rate / (2 * math.pi * 4000))

    local function flush_window()
      if window.frames <= 0 then return end
      local rms = math.sqrt(window.total / window.frames)
      if gain_to_db(rms) >= settings.silence_db then
        windows[#windows + 1] = window
      end
      window = { total = 0, low = 0, mid = 0, high = 0, center = 0, side = 0, frames = 0 }
    end

    for _, range in ipairs(ranges) do
      local remaining = math.floor((range["end"] - range.start) * sample_rate)
      local position = range.start

      while remaining > 0 do
        local want = math.min(block_samples, remaining)
        buffer.resize(want * channels)
        buffer.clear()

        local retval = reaper.GetAudioAccessorSamples(accessor, sample_rate, channels, position, want, buffer)
        if retval == -1 then return nil, "audio accessor error" end

        if retval == 1 then
          read_any = true
          for frame = 0, want - 1, stride do
            local frame_square = 0
            local mono = 0
            local left = (buffer[frame * channels + 1] or 0) * combined_gain
            local right = channels > 1 and ((buffer[frame * channels + 2] or 0) * combined_gain) or left

            for ch = 1, channels do
              local sample = (buffer[frame * channels + ch] or 0) * combined_gain
              local abs_sample = math.abs(sample)
              if abs_sample > peak then peak = abs_sample end
              frame_square = frame_square + sample * sample
              mono = mono + sample
            end

            mono = mono / channels
            low_state = low_state + low_alpha * (mono - low_state)
            high_cut_state = high_cut_state + high_alpha * (mono - high_cut_state)
            local low_sample = low_state
            local mid_sample = high_cut_state - low_state
            local high_sample = mono - high_cut_state
            local center = (left + right) * 0.5
            local side = (left - right) * 0.5

            window.total = window.total + (frame_square / channels)
            window.low = window.low + low_sample * low_sample
            window.mid = window.mid + mid_sample * mid_sample
            window.high = window.high + high_sample * high_sample
            window.center = window.center + center * center
            window.side = window.side + side * side
            window.frames = window.frames + 1

            if window.frames >= window_samples then flush_window() end
          end
        end

        remaining = remaining - want
        position = position + (want / sample_rate)
      end
      flush_window()
    end

    flush_window()
    if not read_any then return nil, "no audio returned" end
    if #windows == 0 or peak <= 0 then return nil, "silent item" end

    local metrics = mean_top_window_metrics(windows, settings.top_window_fraction)
    if not metrics then return nil, "silent item" end
    metrics.peak_db = gain_to_db(peak)
    metrics.window_count = #windows
    metrics.active_seconds = (metrics.active_frames * stride) / sample_rate
    return metrics
  end)

  reaper.DestroyAudioAccessor(accessor)
  if not ok then error(result_or_error) end
  return result_or_error, skip_reason
end

local function power_from_db(db)
  local gain = db_to_gain(db)
  return gain * gain
end

local function analyze_track_for_balance(track, settings)
  local totals = { total = 0, low = 0, mid = 0, high = 0, center = 0, side = 0, weight = 0 }
  local peak_db = nil
  local processed = 0
  local skipped = 0
  local skip_reasons = {}

  for i = 0, reaper.CountTrackMediaItems(track) - 1 do
    local item = reaper.GetTrackMediaItem(track, i)
    local ok, metrics, reason = pcall(analyze_item_for_balance, item, settings)
    if not ok then
      reason = tostring(metrics)
      metrics = nil
    end

    if metrics then
      processed = processed + 1
      local weight = math.max(metrics.active_seconds or 0, 0.001)
      totals.total = totals.total + power_from_db(metrics.rms_db) * weight
      totals.low = totals.low + power_from_db(metrics.low_db) * weight
      totals.mid = totals.mid + power_from_db(metrics.mid_db) * weight
      totals.high = totals.high + power_from_db(metrics.high_db) * weight
      totals.center = totals.center + power_from_db(metrics.center_db) * weight
      totals.side = totals.side + power_from_db(metrics.side_db) * weight
      totals.weight = totals.weight + weight
      peak_db = peak_db and math.max(peak_db, metrics.peak_db) or metrics.peak_db
    else
      skipped = skipped + 1
      reason = reason or "not analyzed"
      skip_reasons[reason] = (skip_reasons[reason] or 0) + 1
    end
  end

  if processed == 0 or totals.weight <= 0 then return nil, skip_reasons end

  return {
    rms_db = gain_to_db(math.sqrt(totals.total / totals.weight)),
    low_db = gain_to_db(math.sqrt(totals.low / totals.weight)),
    mid_db = gain_to_db(math.sqrt(totals.mid / totals.weight)),
    high_db = gain_to_db(math.sqrt(totals.high / totals.weight)),
    center_db = gain_to_db(math.sqrt(totals.center / totals.weight)),
    side_db = gain_to_db(math.sqrt(totals.side / totals.weight)),
    peak_db = peak_db,
    processed_items = processed,
    skipped_items = skipped,
    skip_reasons = skip_reasons
  }
end

local DEFAULT_FAMILY_ORDER = { "lead_vocal", "backing_vocal", "drums", "bass", "guitar", "piano", "other" }

local function reference_has_family(reference_hierarchy, family)
  return reference_hierarchy and reference_hierarchy.families and reference_hierarchy.families[family] ~= nil
end

local function family_order(reference_hierarchy)
  local out = {}
  for _, family in ipairs(DEFAULT_FAMILY_ORDER) do
    if family == "lead_vocal"
      or family == "backing_vocal"
      or reference_has_family(reference_hierarchy, family)
      or family == "drums"
      or family == "bass"
      or family == "other" then
      out[#out + 1] = family
    end
  end
  return out
end

local function role_family(role, reference_hierarchy)
  if role == "lead_vocal" or role == "vocal" then return "lead_vocal" end
  if role == "backing_vocal" then return "backing_vocal" end
  if role == "bass" then return "bass" end
  if role == "kick" or role == "snare" or role == "percussion" or role == "drums" then return "drums" end
  if role == "guitar" and reference_has_family(reference_hierarchy, "guitar") then return "guitar" end
  if role == "keys" and reference_has_family(reference_hierarchy, "piano") then return "piano" end
  return "other"
end

local function family_template()
  return { power = 0, count = 0, tracks = {} }
end

local function power_average_db(values)
  if #values == 0 then return nil end
  local total = 0
  for _, value in ipairs(values) do
    total = total + power_from_db(value)
  end
  return gain_to_db(math.sqrt(total / #values))
end

local function drum_role_relative_db(role)
  if role == "kick" or role == "snare" then return 0 end
  if role == "drums" then return -2.5 end
  if role == "percussion" then return -5.5 end
  return -3
end

local function drum_anchor_from_track_summaries(tracks)
  local primary = {}
  local fallback = {}
  for _, item in ipairs(tracks or {}) do
    if item.audible_db then
      if item.role == "kick" or item.role == "snare" then
        primary[#primary + 1] = item.audible_db
      end
      fallback[#fallback + 1] = item.audible_db
    end
  end
  return power_average_db(primary) or power_average_db(fallback)
end

local function drum_anchor_from_entries(entries, internal_deltas)
  local summaries = {}
  for _, entry in ipairs(entries or {}) do
    summaries[#summaries + 1] = {
      role = entry.role,
      audible_db = entry.audible_db + ((internal_deltas and internal_deltas[entry.index]) or 0)
    }
  end
  return drum_anchor_from_track_summaries(summaries)
end

local function build_drum_internal_balance(sources)
  local drums = {}
  for _, entry in ipairs(sources) do
    if entry.family == "drums" then drums[#drums + 1] = entry end
  end

  if #drums == 0 then
    return { deltas = {}, changes = {}, anchor_db = nil, adjusted_anchor_db = nil }
  end

  local anchor_db = drum_anchor_from_entries(drums, nil)
  if not anchor_db then
    return { deltas = {}, changes = {}, anchor_db = nil, adjusted_anchor_db = nil }
  end

  local deltas = {}
  local changes = {}
  local max_internal_delta_db = 6

  for _, entry in ipairs(drums) do
    local relative = drum_role_relative_db(entry.role)
    local target_db = anchor_db + relative
    local raw_delta_db = target_db - entry.audible_db
    local delta_db = clamp(raw_delta_db, -max_internal_delta_db, max_internal_delta_db)
    deltas[entry.index] = delta_db
    changes[#changes + 1] = {
      index = entry.index,
      track = entry.name,
      role = entry.role,
      current_db = entry.audible_db,
      target_db = target_db,
      raw_delta_db = raw_delta_db,
      delta_db = delta_db,
      limited = math.abs(delta_db - raw_delta_db) > 0.001
    }
  end

  return {
    deltas = deltas,
    changes = changes,
    anchor_db = anchor_db,
    adjusted_anchor_db = drum_anchor_from_entries(drums, deltas),
    method = "kick_snare_anchor"
  }
end

local function session_hierarchy_from_sources(sources, reference_hierarchy, internal_deltas)
  local families = {}
  local order = family_order(reference_hierarchy)
  for _, family in ipairs(order) do
    families[family] = family_template()
  end

  for _, entry in ipairs(sources) do
    local family = role_family(entry.role, reference_hierarchy)
    local data = families[family]
    local internal_delta = (internal_deltas and internal_deltas[entry.index]) or 0
    local adjusted_audible_db = entry.audible_db + internal_delta
    local power = power_from_db(adjusted_audible_db)
    data.power = data.power + power
    data.count = data.count + 1
    data.tracks[#data.tracks + 1] = {
      index = entry.index,
      name = entry.name,
      role = entry.role,
      raw_audible_db = entry.audible_db,
      internal_delta_db = internal_delta,
      audible_db = adjusted_audible_db
    }
  end

  for _, family in ipairs(order) do
    local data = families[family]
    data.aggregate_level_db = data.power > 0 and gain_to_db(math.sqrt(data.power)) or nil
    if family == "drums" then
      data.level_db = drum_anchor_from_track_summaries(data.tracks) or data.aggregate_level_db
      data.level_method = "kick_snare_anchor_after_internal_balance"
    else
      data.level_db = data.aggregate_level_db
      data.level_method = "family_energy_sum"
    end
    data.power = nil
  end

  return {
    anchor_family = "lead_vocal",
    family_order = order,
    families = families
  }
end

local function reference_family_name(family)
  if family == "lead_vocal" or family == "backing_vocal" then return "vocals" end
  return family
end

local function reference_family(reference_hierarchy, family)
  local ref_name = reference_family_name(family)
  return reference_hierarchy and reference_hierarchy.families and reference_hierarchy.families[ref_name] or nil
end

local function family_width(reference_hierarchy, family)
  if family == "lead_vocal" then return 0 end
  local ref = reference_family(reference_hierarchy, family)
  local width = ref and tonumber(ref.width) or 0
  if width >= 0.75 then return 1 end
  if width <= 0.1 then return 0 end
  return clamp(width, 0, 1)
end

local function pan_from_sequence(index, count, sequence, width)
  if count <= 1 or width <= 0 then return 0 end
  local value = sequence[((index - 1) % #sequence) + 1] * width
  return clamp(value, -1, 1)
end

local function target_pan_for_role(role, family, position, count, reference_hierarchy)
  if role == "lead_vocal" or role == "vocal" or role == "bass" or role == "kick" or role == "snare" then return 0 end
  local width = family_width(reference_hierarchy, family)
  if role == "backing_vocal" then return pan_from_sequence(position, count, { -1, 1, -0.6, 0.6, 0 }, width) end
  if role == "guitar" then return pan_from_sequence(position, count, { -1, 1, -0.65, 0.65, -0.35, 0.35 }, width) end
  if role == "keys" then return pan_from_sequence(position, count, { -0.7, 0.7, -0.35, 0.35, 0 }, width) end
  if role == "percussion" or role == "drums" or role == "fx" then return pan_from_sequence(position, count, { 0.6, -0.6, 1, -1, 0.3, -0.3 }, width) end
  return 0
end

local POP_ROCK_RELATIVE_LIMITS = {
  backing_vocal = { min = -18, max = -4 },
  drums = { min = -14, max = -1.5 },
  bass = { min = -14, max = -2.5 },
  guitar = { min = -20, max = -4 },
  piano = { min = -20, max = -4 },
  other = { min = -24, max = -6 }
}

local function target_relative_to_lead(family, ref_family)
  if family == "lead_vocal" then return 0, "lead_anchor" end

  if family == "backing_vocal" then
    local width = ref_family and tonumber(ref_family.width) or 0
    local relative = -8 + (clamp(width, 0, 1) * 2)
    local limits = POP_ROCK_RELATIVE_LIMITS.backing_vocal
    return clamp(relative, limits.min, limits.max), "vocal_role"
  end

  local ref_relative = ref_family and tonumber(ref_family.levelDb) or nil
  if not ref_relative then return nil, "missing_reference_family" end
  local limits = POP_ROCK_RELATIVE_LIMITS[family] or POP_ROCK_RELATIVE_LIMITS.other
  return clamp(ref_relative, limits.min, limits.max), "reference_chorus_bounded"
end

local function valid_sections(sections)
  local out = {}
  for _, section in ipairs(sections or {}) do
    local start_time = tonumber(section.start)
    local end_time = tonumber(section["end"] or section.finish)
    if start_time and end_time and end_time > start_time then
      out[#out + 1] = {
        name = tostring(section.name or "chorus"),
        type = section.type or "region",
        start = start_time,
        ["end"] = end_time
      }
    end
  end
  table.sort(out, function(a, b) return a.start < b.start end)
  return out
end

local function select_balance_sections(command, inspection)
  local sections = valid_sections(command.balanceSections or (inspection.sections and inspection.sections.chorus) or {})
  if #sections == 0 then
    error("auto-balance requires CHORUS/ESTRIBILLO/HOOK/CORO regions or marker spans; no faders moved")
  end
  return sections
end

local function command_auto_balance_mix(command)
  local genre = command.genre or "pop-rock"
  if genre ~= "pop-rock" then error("unsupported auto-balance genre: " .. tostring(genre)) end

  local preview = command.preview == true
  local reference_hierarchy = command.referenceHierarchy
  if not reference_hierarchy or not reference_hierarchy.families then
    error("auto-balance requires referenceHierarchy from separated REF stems")
  end

  local settings = balance_analysis_settings(command)
  local max_delta_db = tonumber(command.maxDeltaDb) or 12
  local inspection = collect_project_inspection()
  if not inspection.reference then error("reference track not found: expected a live track named REF or REFERENCE") end
  local balance_sections = select_balance_sections(command, inspection)
  settings.sections = balance_sections

  local source_entries = inspection.routing.sources
  local analyzed_sources = {}
  local warnings = {}
  for _, warning in ipairs(inspection.warnings) do warnings[#warnings + 1] = warning end

  for _, entry in ipairs(source_entries) do
    local track = reaper.GetTrack(0, entry.index - 1)
    local metrics, skip_reasons = analyze_track_for_balance(track, settings)
    if metrics then
      local audible_db = entry.volume_db + metrics.rms_db
      entry.analysis = metrics
      entry.audible_db = audible_db
      entry.family = role_family(entry.role, reference_hierarchy)
      analyzed_sources[#analyzed_sources + 1] = entry
    else
      warnings[#warnings + 1] = "Skipped " .. entry.name .. ": audio could not be analyzed."
    end
  end

  if #analyzed_sources == 0 then error("no source tracks could be analyzed") end
  local drum_internal_balance = build_drum_internal_balance(analyzed_sources)
  local internal_deltas = drum_internal_balance.deltas or {}
  local session_hierarchy = session_hierarchy_from_sources(analyzed_sources, reference_hierarchy, internal_deltas)
  local session_anchor = session_hierarchy.families.lead_vocal and session_hierarchy.families.lead_vocal.level_db or nil
  if not session_anchor then error("no clear lead vocal was found inside the chorus window; no faders moved") end

  local family_deltas = {}
  for _, family in ipairs(session_hierarchy.family_order) do
    local session_family = session_hierarchy.families[family]
    local ref_family = reference_family(reference_hierarchy, family)
    if session_family and session_family.level_db then
      local target_relative_db, target_reason = target_relative_to_lead(family, ref_family)
      if target_relative_db then
        local target_family_db = session_anchor + target_relative_db
        local raw_delta_db = target_family_db - session_family.level_db
        if family == "lead_vocal" then raw_delta_db = 0 end
        local delta_db = clamp(raw_delta_db, -max_delta_db, max_delta_db)
        family_deltas[family] = {
          current_db = session_family.level_db,
          reference_family = reference_family_name(family),
          reference_relative_db = ref_family and ref_family.levelDb or nil,
          target_relative_db = target_relative_db,
          target_reason = target_reason,
          target_db = target_family_db,
          raw_delta_db = raw_delta_db,
          delta_db = delta_db,
          limited = math.abs(delta_db - raw_delta_db) > 0.001,
          width = family_width(reference_hierarchy, family)
        }
      else
        family_deltas[family] = {
          skipped = true,
          reason = target_reason or "missing reference family"
        }
      end
    else
      family_deltas[family] = {
        skipped = true,
        reason = "missing session family"
      }
    end
  end

  local role_positions = {}
  local role_counts = {}
  for _, entry in ipairs(analyzed_sources) do
    local role = entry.role or "unknown"
    role_counts[role] = (role_counts[role] or 0) + 1
  end

  local changes = {}

  for _, entry in ipairs(analyzed_sources) do
    local role = entry.role or "unknown"
    local family = entry.family or role_family(role, reference_hierarchy)
    local family_delta = family_deltas[family] and family_deltas[family].delta_db or 0
    local internal_delta = internal_deltas[entry.index] or 0
    role_positions[role] = (role_positions[role] or 0) + 1
    local position = role_positions[role]
    local target_fader_db = entry.volume_db
    if family ~= "lead_vocal" then
      target_fader_db = clamp(entry.volume_db + family_delta + internal_delta, -24, 6)
    end
    local target_pan = target_pan_for_role(role, family, position, role_counts[role] or 1, reference_hierarchy)
    local before_fader_db = entry.volume_db
    local before_pan = entry.pan
    local fader_delta = target_fader_db - before_fader_db
    local pan_delta = target_pan - before_pan

    if math.abs(fader_delta) >= 0.05 or math.abs(pan_delta) >= 0.001 then
      changes[#changes + 1] = {
        track = entry.name,
        index = entry.index,
        role = role,
        family = family,
        before_fader_db = before_fader_db,
        after_fader_db = target_fader_db,
        delta_db = fader_delta,
        family_delta_db = family_delta,
        internal_delta_db = internal_delta,
        before_pan = before_pan,
        after_pan = target_pan,
        rms_db = entry.analysis.rms_db
      }

      if not preview then
        local track = reaper.GetTrack(0, entry.index - 1)
        reaper.SetMediaTrackInfo_Value(track, "D_VOL", db_to_gain(target_fader_db))
        reaper.SetMediaTrackInfo_Value(track, "D_PAN", target_pan)
      end
    end
  end

  if not preview then
    reaper.TrackList_AdjustWindows(false)
    reaper.UpdateArrange()
  end

  return {
    preview = preview,
    genre = genre,
    reference = {
      index = inspection.reference.index,
      name = inspection.reference.name
    },
    balanceSections = balance_sections,
    referenceHierarchy = reference_hierarchy,
    sessionHierarchy = session_hierarchy,
    familyDeltas = family_deltas,
    internalBalances = {
      drums = {
        method = drum_internal_balance.method,
        anchor_db = drum_internal_balance.anchor_db,
        adjusted_anchor_db = drum_internal_balance.adjusted_anchor_db,
        changes = drum_internal_balance.changes
      }
    },
    routing = {
      track_count = inspection.track_count,
      source_count = #source_entries,
      parallel_count = inspection.routing.parallel_count,
      return_count = inspection.routing.return_count,
      pre_fader_sends = inspection.routing.pre_fader_sends
    },
    considered = #analyzed_sources,
    changed = #changes,
    applied = preview and 0 or #changes,
    warnings = warnings,
    changes = changes
  }
end

local function command_set_track_state(command)
  local tracks = collect_tracks(command.filter)
  local changes = command.changes or {}
  local changed = {}

  for _, track in ipairs(tracks) do
    local entry = { track = track_name(track) }

    if changes.mute then
      local before = reaper.GetMediaTrackInfo_Value(track, "B_MUTE") == 1
      local after = set_boolean_action(before, changes.mute)
      reaper.SetMediaTrackInfo_Value(track, "B_MUTE", after and 1 or 0)
      entry.mute = after
    end

    if changes.solo then
      local before = reaper.GetMediaTrackInfo_Value(track, "I_SOLO") > 0
      local after = set_boolean_action(before, changes.solo)
      reaper.SetMediaTrackInfo_Value(track, "I_SOLO", after and 1 or 0)
      entry.solo = after
    end

    if changes.arm then
      local before = reaper.GetMediaTrackInfo_Value(track, "I_RECARM") == 1
      local after = set_boolean_action(before, changes.arm)
      reaper.SetMediaTrackInfo_Value(track, "I_RECARM", after and 1 or 0)
      entry.arm = after
    end

    if changes.monitor then
      local before = reaper.GetMediaTrackInfo_Value(track, "I_RECMON") > 0
      local after = set_boolean_action(before, changes.monitor)
      reaper.SetMediaTrackInfo_Value(track, "I_RECMON", after and 1 or 0)
      entry.monitor = after
    end

    if changes.hideTcp then
      local before_hidden = reaper.GetMediaTrackInfo_Value(track, "B_SHOWINTCP") == 0
      local hidden = set_boolean_action(before_hidden, changes.hideTcp)
      reaper.SetMediaTrackInfo_Value(track, "B_SHOWINTCP", hidden and 0 or 1)
      entry.hideTcp = hidden
    end

    if changes.hideMcp then
      local before_hidden = reaper.GetMediaTrackInfo_Value(track, "B_SHOWINMIXER") == 0
      local hidden = set_boolean_action(before_hidden, changes.hideMcp)
      reaper.SetMediaTrackInfo_Value(track, "B_SHOWINMIXER", hidden and 0 or 1)
      entry.hideMcp = hidden
    end

    changed[#changed + 1] = entry
  end

  reaper.TrackList_AdjustWindows(false)
  reaper.UpdateArrange()
  return {
    changed = #changed,
    tracks = changed
  }
end

local function command_rename_tracks(command)
  local tracks = collect_tracks(command.filter)
  local changed = {}

  for i, track in ipairs(tracks) do
    local old = track_name(track)
    local name = old
    if command.set then
      name = #tracks == 1 and command.set or (command.set .. " " .. tostring(i))
    end
    if command.replace then
      name = plain_gsub(name, command.replace.from, command.replace.to)
    end
    if command.prefix then name = command.prefix .. name end
    if command.suffix then name = name .. command.suffix end

    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", name, true)
    changed[#changed + 1] = { old = old, name = name }
  end

  return {
    changed = #changed,
    tracks = changed
  }
end

local function command_create_tracks(command)
  local count = command.count or 1
  local base = command.name or "Track"
  local created = {}
  local start_index = reaper.CountTracks(0)

  for i = 1, count do
    reaper.InsertTrackAtIndex(start_index + i - 1, false)
    local track = reaper.GetTrack(0, start_index + i - 1)
    local name = count == 1 and base or (base .. " " .. tostring(i))
    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", name, true)
    if command.color then reaper.SetTrackColor(track, color_native(command.color)) end
    created[#created + 1] = {
      index = math.floor(reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")),
      name = name
    }
  end

  reaper.TrackList_AdjustWindows(false)
  reaper.UpdateArrange()
  return {
    created = created
  }
end

local function insert_named_track(name, color, pan)
  reaper.InsertTrackAtIndex(reaper.CountTracks(0), false)
  local track = reaper.GetTrack(0, reaper.CountTracks(0) - 1)
  reaper.GetSetMediaTrackInfo_String(track, "P_NAME", name, true)
  if color then reaper.SetTrackColor(track, color_native(color)) end
  if pan then reaper.SetMediaTrackInfo_Value(track, "D_PAN", pan) end
  reaper.SetTrackSelected(track, false)
  return track
end

local function create_folder_group(name, color, children)
  local folder = insert_named_track(name, color, 0)
  reaper.SetMediaTrackInfo_Value(folder, "I_FOLDERDEPTH", 1)

  for i, child in ipairs(children) do
    local track = insert_named_track(child.name, child.color or color, child.pan or 0)
    if i == #children then
      reaper.SetMediaTrackInfo_Value(track, "I_FOLDERDEPTH", -1)
    end
  end

  return {
    name = name,
    children = #children
  }
end

local function command_create_rock_template(command)
  local cleared = 0
  if command.clearExisting ~= false then
    for i = reaper.CountTracks(0) - 1, 0, -1 do
      reaper.DeleteTrack(reaper.GetTrack(0, i))
      cleared = cleared + 1
    end
  end

  local created_groups = {}

  insert_named_track("CLICK", COLORS.gray, 0)
  insert_named_track("REF", COLORS.gray, 0)

  created_groups[#created_groups + 1] = create_folder_group("DRUMS", COLORS.red, {
    { name = "KICK IN", pan = 0 },
    { name = "KICK OUT", pan = 0 },
    { name = "SNARE TOP", pan = 0 },
    { name = "SNARE BOTTOM", pan = 0 },
    { name = "HI HAT", pan = 0.35 },
    { name = "TOM 1", pan = -0.35 },
    { name = "TOM 2", pan = 0.1 },
    { name = "FLOOR TOM", pan = 0.45 },
    { name = "OH L", pan = -1 },
    { name = "OH R", pan = 1 },
    { name = "ROOM L", pan = -0.8 },
    { name = "ROOM R", pan = 0.8 }
  })

  created_groups[#created_groups + 1] = create_folder_group("BASS", COLORS.orange, {
    { name = "BASS DI", pan = 0 },
    { name = "BASS AMP", pan = 0 }
  })

  created_groups[#created_groups + 1] = create_folder_group("GUITARS", COLORS.green, {
    { name = "GTR RHYTHM L", pan = -1 },
    { name = "GTR RHYTHM R", pan = 1 },
    { name = "GTR LEAD", pan = 0 },
    { name = "GTR SOLO", pan = 0 },
    { name = "ACOUSTIC L", pan = -0.65 },
    { name = "ACOUSTIC R", pan = 0.65 }
  })

  created_groups[#created_groups + 1] = create_folder_group("KEYS", COLORS.teal, {
    { name = "PIANO L", pan = -0.7 },
    { name = "PIANO R", pan = 0.7 },
    { name = "SYNTH", pan = 0 }
  })

  created_groups[#created_groups + 1] = create_folder_group("VOCALS", COLORS.blue, {
    { name = "LEAD VOX", pan = 0 },
    { name = "VOX DOUBLE", pan = 0 },
    { name = "BV L", pan = -0.6 },
    { name = "BV R", pan = 0.6 },
    { name = "BV CENTER", pan = 0 }
  })

  created_groups[#created_groups + 1] = create_folder_group("FX RETURNS", COLORS.purple, {
    { name = "ROOM VERB", pan = 0 },
    { name = "PLATE VERB", pan = 0 },
    { name = "SLAP DELAY", pan = 0 },
    { name = "LONG DELAY", pan = 0 },
    { name = "PARALLEL COMP", pan = 0 }
  })

  created_groups[#created_groups + 1] = create_folder_group("PRINT", COLORS.pink, {
    { name = "MIX PRINT", pan = 0 },
    { name = "REFERENCE PRINT", pan = 0 }
  })

  reaper.TrackList_AdjustWindows(false)
  reaper.UpdateArrange()

  return {
    cleared = cleared,
    created_track_count = reaper.CountTracks(0),
    groups = created_groups
  }
end

local function command_create_folder(command)
  local tracks = collect_tracks(command.filter)
  if #tracks == 0 then error("no tracks matched folder command") end
  sort_tracks_by_index(tracks)

  local first = math.floor(reaper.GetMediaTrackInfo_Value(tracks[1], "IP_TRACKNUMBER"))
  for i, track in ipairs(tracks) do
    local index = math.floor(reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER"))
    if index ~= first + i - 1 then
      error("folder command requires contiguous tracks")
    end
  end

  local insert_index = first - 1
  reaper.InsertTrackAtIndex(insert_index, false)
  local folder = reaper.GetTrack(0, insert_index)
  local name = command.name or "Folder"
  reaper.GetSetMediaTrackInfo_String(folder, "P_NAME", name, true)
  reaper.SetMediaTrackInfo_Value(folder, "I_FOLDERDEPTH", 1)
  if command.color then reaper.SetTrackColor(folder, color_native(command.color)) end

  local last_child = reaper.GetTrack(0, insert_index + #tracks)
  local current_depth = reaper.GetMediaTrackInfo_Value(last_child, "I_FOLDERDEPTH")
  reaper.SetMediaTrackInfo_Value(last_child, "I_FOLDERDEPTH", current_depth - 1)

  reaper.TrackList_AdjustWindows(false)
  reaper.UpdateArrange()
  return {
    folder = {
      name = name,
      index = math.floor(reaper.GetMediaTrackInfo_Value(folder, "IP_TRACKNUMBER"))
    },
    children = #tracks
  }
end

local function has_send_to(source, dest)
  local send_count = reaper.GetTrackNumSends(source, 0)
  for send_index = 0, send_count - 1 do
    if reaper.GetTrackSendInfo_Value(source, 0, send_index, "P_DESTTRACK") == dest then
      return true, send_index
    end
  end
  return false, nil
end

local function command_route_to_bus(command)
  local sources = collect_tracks(command.filter)
  local bus_name = command.busName or "Bus"
  local bus = find_track_by_exact_name(bus_name)
  if not bus and command.create ~= false then
    reaper.InsertTrackAtIndex(reaper.CountTracks(0), false)
    bus = reaper.GetTrack(0, reaper.CountTracks(0) - 1)
    reaper.GetSetMediaTrackInfo_String(bus, "P_NAME", bus_name, true)
  end
  if not bus then error("bus not found: " .. tostring(bus_name)) end

  local sends = {}
  for _, source in ipairs(sources) do
    if source ~= bus then
      local exists, existing_index = has_send_to(source, bus)
      local send_index = existing_index
      if not exists then
        send_index = reaper.CreateTrackSend(source, bus)
      end
      reaper.SetTrackSendInfo_Value(source, 0, send_index, "D_VOL", db_to_gain(command.sendVolumeDb or 0))
      if command.disableMain then reaper.SetMediaTrackInfo_Value(source, "B_MAINSEND", 0) end
      sends[#sends + 1] = {
        source = track_name(source),
        destination = track_name(bus),
        send_index = send_index,
        already_existed = exists
      }
    end
  end

  reaper.TrackList_AdjustWindows(false)
  reaper.UpdateArrange()
  return {
    bus = track_name(bus),
    sends = sends
  }
end

local function command_set_fx_bypass(command)
  local tracks = collect_tracks(command.filter)
  local needle = command.fxContains and lower(command.fxContains) or nil
  local action = command.state or "toggle"
  local changed = {}

  for _, track in ipairs(tracks) do
    for fx = 0, reaper.TrackFX_GetCount(track) - 1 do
      local _, fx_name = reaper.TrackFX_GetFXName(track, fx, "")
      if not needle or lower(fx_name):find(needle, 1, true) then
        local before_bypassed = not reaper.TrackFX_GetEnabled(track, fx)
        local after_bypassed = set_boolean_action(before_bypassed, action)
        reaper.TrackFX_SetEnabled(track, fx, not after_bypassed)
        changed[#changed + 1] = {
          track = track_name(track),
          fx = fx_name,
          bypassed = after_bypassed
        }
      end
    end
  end

  return {
    changed = #changed,
    fx = changed
  }
end

local function command_create_fx_returns(command)
  local sources = command.sourceFilter and collect_tracks(command.sourceFilter) or {}
  local created = {}
  local start_index = reaper.CountTracks(0)
  local count = command.count or 1
  local base = command.baseName or "FX Return"

  for i = 1, count do
    reaper.InsertTrackAtIndex(start_index + i - 1, false)
    local track = reaper.GetTrack(0, start_index + i - 1)
    if not track then error("could not create return track") end

    local name = count == 1 and base or (base .. " " .. tostring(i))
    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", name, true)
    reaper.SetMediaTrackInfo_Value(track, "I_NCHAN", 2)
    reaper.SetMediaTrackInfo_Value(track, "B_MAINSEND", 1)

    local ok_fx, fx_index, used_name = pcall(try_add_fx, track, command.fx or {})
    if not ok_fx then
      reaper.DeleteTrack(track)
      for _, item in ipairs(created) do
        reaper.DeleteTrack(item.track)
      end
      error(fx_index)
    end

    created[#created + 1] = {
      track = track,
      name = name,
      fx_index = fx_index,
      fx_name = used_name
    }
  end

  local sends = {}
  if command.sourceFilter then
    for _, source in ipairs(sources) do
      for _, dest in ipairs(created) do
        local send_index = reaper.CreateTrackSend(source, dest.track)
        reaper.SetTrackSendInfo_Value(source, 0, send_index, "D_VOL", db_to_gain(command.sendVolumeDb or -18))
        sends[#sends + 1] = {
          source = track_name(source),
          destination = dest.name,
          send_index = send_index
        }
      end
    end
  end

  reaper.UpdateArrange()

  local returns = {}
  for _, item in ipairs(created) do
    returns[#returns + 1] = {
      name = item.name,
      fx_index = item.fx_index,
      fx_name = item.fx_name
    }
  end

  return {
    returns = returns,
    sends = sends
  }
end

local handlers = {
  ping = command_ping,
  inspect_project = command_inspect_project,
  set_project_regions = command_set_project_regions,
  set_project_markers = command_set_project_markers,
  detect_arrangement = command_detect_arrangement,
  auto_balance_mix = command_auto_balance_mix,
  color_tracks = command_color_tracks,
  select_tracks = command_select_tracks,
  select_items = command_select_items,
  add_fx_to_tracks = command_add_fx,
  remove_fx_from_tracks = command_remove_fx,
  delete_tracks = command_delete_tracks,
  adjust_track_volume_db = command_adjust_volume,
  set_track_pan = command_set_pan,
  copy_track_balance = command_copy_track_balance,
  adjust_send_volume_db = command_adjust_send_volume,
  adjust_item_volume_db = command_adjust_item_volume,
  gain_stage_items = command_gain_stage_items,
  vocal_level_items = command_vocal_level_items,
  set_track_state = command_set_track_state,
  rename_tracks = command_rename_tracks,
  create_tracks = command_create_tracks,
  create_rock_template = command_create_rock_template,
  create_folder_for_tracks = command_create_folder,
  route_tracks_to_bus = command_route_to_bus,
  set_fx_bypass = command_set_fx_bypass,
  create_fx_returns = command_create_fx_returns
}

local read_only_commands = {
  ping = true,
  inspect_project = true
}

local function is_read_only_command(command)
  return read_only_commands[command.type] == true
    or (command.type == "auto_balance_mix" and command.preview == true)
    or (command.type == "detect_arrangement" and (command.preview == true or command.applyMarkers == false))
    or (command.type == "vocal_level_items" and command.preview == true)
end

local function run_command(command)
  if command.type == "shutdown" then
    running = false
    return { bridge = "stopping" }
  end

  if command.type == "undo" then
    return command_undo(command)
  end

  local handler = handlers[command.type]
  if not handler then error("unsupported command type: " .. tostring(command.type)) end

  if is_read_only_command(command) then
    local ok, result = pcall(handler, command)
    if not ok then error(result) end
    return result
  end

  reaper.Undo_BeginBlock2(0)
  local ok, result = pcall(handler, command)
  local undo_name = "Reaper Manager: " .. tostring(command.type)
  reaper.Undo_EndBlock2(0, undo_name, -1)
  if not ok then error(result) end
  return result
end

local function process_file(filename)
  local path = join(queue_dir, filename)
  local content = read_file(path)
  if not content then return end

  local ok, payload = pcall(json.decode, content)
  local id = filename:gsub("%.json$", "")

  if not ok then
    respond(id, false, payload)
    os.remove(path)
    return
  end

  id = payload.id or id
  local command = payload.command or payload
  local ok_command, result = pcall(run_command, command)
  respond(id, ok_command, result)
  os.remove(path)
end

local function poll()
  ensure_dirs()
  local i = 0
  while true do
    local filename = reaper.EnumerateFiles(queue_dir, i)
    if not filename then break end
    if filename:match("%.json$") then
      process_file(filename)
    end
    i = i + 1
  end
  heartbeat()
end

local function loop()
  if not running then return end
  local now = reaper.time_precise()
  if now - last_poll >= (config.poll_interval or 0.25) then
    last_poll = now
    local ok, err = pcall(poll)
    if not ok then
      respond("bridge-error", false, err)
    end
  end
  reaper.defer(loop)
end

local function cleanup()
  if command_id and command_id ~= 0 then
    reaper.SetToggleCommandState(section_id, command_id, 0)
    reaper.RefreshToolbar2(section_id, command_id)
  end
  local payload = {
    ok = true,
    bridge = "stopped",
    bridge_version = BRIDGE_VERSION,
    time = os.date("!%Y-%m-%dT%H:%M:%SZ")
  }
  write_file(join(state_dir, "heartbeat.json"), json.encode(payload))
end

ensure_dirs()
if reaper.set_action_options then reaper.set_action_options(1 | 4) end
if command_id and command_id ~= 0 then
  reaper.SetToggleCommandState(section_id, command_id, 1)
  reaper.RefreshToolbar2(section_id, command_id)
end
reaper.atexit(cleanup)
heartbeat()
loop()
