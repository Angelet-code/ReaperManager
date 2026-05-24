local M = {}

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

M.track_name = track_name
M.collect_tracks = collect_tracks
M.track_summaries = track_summaries
M.lower = lower
M.trim = trim
M.balance_key_name = balance_key_name
M.track_index = track_index
M.find_track_by_exact_name = find_track_by_exact_name
M.plain_gsub = plain_gsub
M.set_boolean_action = set_boolean_action
M.sort_tracks_by_index = sort_tracks_by_index
M.color_native = color_native
M.db_to_gain = db_to_gain
M.gain_to_db = gain_to_db
M.collect_items = collect_items
M.item_summary = item_summary
M.clamp = clamp
M.top_mean = top_mean
M.sorted_number_copy = sorted_number_copy
M.median = median
M.try_add_fx = try_add_fx
M.COLORS = COLORS

return M
