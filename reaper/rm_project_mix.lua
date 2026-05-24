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

function M.register(registry)
  registry.command("inspect_project", command_inspect_project, { read_only = true })
  registry.command("set_project_regions", command_set_project_regions)
  registry.command("set_project_markers", command_set_project_markers)
  registry.command("detect_arrangement", command_detect_arrangement, {
    read_only = function(command) return command.preview == true or command.applyMarkers == false end
  })
  registry.command("auto_balance_mix", command_auto_balance_mix, {
    read_only = function(command) return command.preview == true end
  })
  registry.command("set_track_state", command_set_track_state)
  registry.command("rename_tracks", command_rename_tracks)
  registry.command("create_tracks", command_create_tracks)
  registry.command("create_rock_template", command_create_rock_template, { destructive = true })
  registry.command("create_folder_for_tracks", command_create_folder)
  registry.command("route_tracks_to_bus", command_route_to_bus)
  registry.command("set_fx_bypass", command_set_fx_bypass)
  registry.command("create_fx_returns", command_create_fx_returns)
end

return M
