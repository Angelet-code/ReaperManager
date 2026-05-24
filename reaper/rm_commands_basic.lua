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

function M.register(registry)
  registry.command("color_tracks", command_color_tracks)
  registry.command("select_tracks", command_select_tracks)
  registry.command("select_items", command_select_items)
  registry.command("add_fx_to_tracks", command_add_fx)
  registry.command("remove_fx_from_tracks", command_remove_fx, { destructive = true })
  registry.command("delete_tracks", command_delete_tracks, { destructive = true })
  registry.command("adjust_track_volume_db", command_adjust_volume)
  registry.command("set_track_pan", command_set_pan)
  registry.command("copy_track_balance", command_copy_track_balance)
  registry.command("adjust_send_volume_db", command_adjust_send_volume)
  registry.command("adjust_item_volume_db", command_adjust_item_volume)
end

return M
