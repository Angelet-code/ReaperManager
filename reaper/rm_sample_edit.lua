-- Per-take sample edits (REAPER 7.70+): read the active take of the first selected
-- item and write SPL values into its SAMPLEEDITS block. The heavy lifting (finding
-- and rebuilding clipped peaks) happens outside REAPER in scripts/declip.py.
local M = {}

local function first_selected_take()
  local item = reaper.GetSelectedMediaItem(0, 0)
  if not item then error("No selected media item.") end
  local take = reaper.GetActiveTake(item)
  if not take then error("Selected item has no active take.") end
  if reaper.TakeIsMIDI(take) then error("Active take is MIDI; sample edits need audio.") end
  return item, take
end

-- Splits an item chunk into the item header (take 0) and one segment per extra take.
local function split_takes(chunk)
  local segments = {}
  local pos = 1
  while true do
    local s = chunk:find("\nTAKE[ \n]", pos)
    if not s then break end
    segments[#segments + 1] = chunk:sub(pos, s)
    pos = s + 1
  end
  segments[#segments + 1] = chunk:sub(pos)
  return segments
end

local function active_take_segment(item, chunk)
  local segments = split_takes(chunk)
  local index = math.floor(reaper.GetMediaItemInfo_Value(item, "I_CURTAKE")) + 1
  if not segments[index] then error("Active take not found in item chunk.") end
  return segments, index
end

-- SAMPLEEDITS header line followed by zero or more <SPLS channel ... > blocks.
local function parse_sample_edits(segment)
  local h_start, h_end, header = segment:find("(SAMPLEEDITS[^\n]*)\n")
  if not h_start then return nil end
  local blocks = {}
  local pos = h_end + 1
  while true do
    local b_start, b_end, channel, body = segment:find("^<SPLS (%d+)\n(.-)\n?>\n", pos)
    if not b_start then break end
    local values = {}
    for index, value in body:gmatch("SPL (%d+) ([^\n]+)") do values[tonumber(index)] = value end
    blocks[tonumber(channel)] = values
    pos = b_end + 1
  end
  return { header = header, start = h_start, finish = pos - 1, blocks = blocks }
end

local function render_sample_edits(header, blocks)
  local channels = {}
  for channel in pairs(blocks) do channels[#channels + 1] = channel end
  table.sort(channels)
  local lines = { header }
  for _, channel in ipairs(channels) do
    local values = blocks[channel]
    local indices = {}
    for n in pairs(values) do indices[#indices + 1] = n end
    if #indices > 0 then
      table.sort(indices)
      lines[#lines + 1] = "<SPLS " .. channel
      for _, n in ipairs(indices) do lines[#lines + 1] = "SPL " .. n .. " " .. values[n] end
      lines[#lines + 1] = ">"
    end
  end
  return table.concat(lines, "\n") .. "\n"
end

local function count_edits(blocks)
  local total = 0
  for _, values in pairs(blocks) do
    for _ in pairs(values) do total = total + 1 end
  end
  return total
end

local function command_sample_edit_probe()
  local item, take = first_selected_take()
  local source = reaper.GetMediaItemTake_Source(take)
  local sel_start, sel_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
  local _, chunk = reaper.GetItemStateChunk(item, "", false)
  local segments, index = active_take_segment(item, chunk)
  local parsed = parse_sample_edits(segments[index])
  local _, take_guid = reaper.GetSetMediaItemTakeInfo_String(take, "GUID", "", false)

  return {
    take_guid = take_guid,
    take_index = index - 1,
    source_file = reaper.GetMediaSourceFileName(source, ""),
    source_type = reaper.GetMediaSourceType(source, ""),
    source_channels = reaper.GetMediaSourceNumChannels(source),
    item_position = reaper.GetMediaItemInfo_Value(item, "D_POSITION"),
    item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH"),
    take_offset = reaper.GetMediaItemTakeInfo_Value(take, "D_STARTOFFS"),
    take_playrate = reaper.GetMediaItemTakeInfo_Value(take, "D_PLAYRATE"),
    time_selection = { start = sel_start, ["end"] = sel_end },
    sample_edits_enabled = parsed ~= nil,
    sample_edit_count = parsed and count_edits(parsed.blocks) or 0
  }
end

-- Read-only: writes the active take's sample edits with source index in
-- [command.start, command["end"]) to command.out as "channel index value" lines.
local function command_sample_edit_dump(command)
  local item = first_selected_take()
  local _, chunk = reaper.GetItemStateChunk(item, "", false)
  local segments, index = active_take_segment(item, chunk)
  local parsed = parse_sample_edits(segments[index])
  if not parsed then error("Sample edits are not active on this take.") end
  local first = math.floor(tonumber(command.start) or 0)
  local last = math.floor(tonumber(command["end"]) or math.huge)
  local file = io.open(tostring(command.out), "w")
  if not file then error("Cannot write " .. tostring(command.out)) end
  local written = 0
  for channel, values in pairs(parsed.blocks) do
    for n, value in pairs(values) do
      if n >= first and n < last then
        file:write(channel, " ", n, " ", value, "\n")
        written = written + 1
      end
    end
  end
  file:close()
  return { written = written, out = command.out }
end

-- command.channels = { { channel = 0, start = s0, ["end"] = s1, edits = { {index, value}, ... } }, ... }
-- Existing edits of a channel inside [start, end) are replaced, everything else is kept.
local function command_sample_edit_apply(command)
  local item, take = first_selected_take()
  local _, take_guid = reaper.GetSetMediaItemTakeInfo_String(take, "GUID", "", false)
  if command.takeGuid and command.takeGuid ~= take_guid then
    error("Active take changed since the analysis; run the command again.")
  end
  if type(command.channels) ~= "table" or #command.channels == 0 then
    error("No sample edits supplied.")
  end

  local _, chunk = reaper.GetItemStateChunk(item, "", false)
  local segments, index = active_take_segment(item, chunk)
  local segment = segments[index]
  local parsed = parse_sample_edits(segment)
  if not parsed then
    error("Sample edits are not active on this take. Enable them (Take settings > sample edits, action 41668) and retry.")
  end

  local written = 0
  for _, entry in ipairs(command.channels) do
    local channel = math.floor(tonumber(entry.channel) or 0)
    local range_start = math.floor(tonumber(entry.start) or 0)
    local range_end = math.floor(tonumber(entry["end"]) or math.huge)
    local values = parsed.blocks[channel] or {}
    for n in pairs(values) do
      if n >= range_start and n < range_end then values[n] = nil end
    end
    for _, edit in ipairs(entry.edits or {}) do
      values[math.floor(edit[1])] = string.format("%.9g", edit[2])
      written = written + 1
    end
    parsed.blocks[channel] = values
  end

  segments[index] = segment:sub(1, parsed.start - 1)
    .. render_sample_edits(parsed.header, parsed.blocks)
    .. segment:sub(parsed.finish + 1)
  if not reaper.SetItemStateChunk(item, table.concat(segments), false) then
    error("SetItemStateChunk failed.")
  end
  reaper.UpdateArrange()
  return { take_index = index - 1, written = written, total_sample_edits = count_edits(parsed.blocks) }
end

-- Adds a take playing an already rendered file (same length/timing as the active
-- take's source) and makes it active, so the user can A/B by switching takes.
-- Take gain, pan, pitch and the take volume envelope are copied from the active take.
local function command_add_take_from_file(command)
  local item, take = first_selected_take()
  local _, take_guid = reaper.GetSetMediaItemTakeInfo_String(take, "GUID", "", false)
  if command.takeGuid and command.takeGuid ~= take_guid then
    error("Active take changed since the analysis; run the command again.")
  end
  local file = tostring(command.file or "")
  if file == "" or not reaper.file_exists(file) then error("Rendered file not found: " .. file) end
  local source = reaper.PCM_Source_CreateFromFile(file)
  if not source then error("REAPER could not open " .. file) end

  local new_take = reaper.AddTakeToMediaItem(item)
  reaper.SetMediaItemTake_Source(new_take, source)
  for _, key in ipairs({ "D_STARTOFFS", "D_PLAYRATE", "D_VOL", "D_PAN", "D_PITCH", "B_PPITCH", "I_CHANMODE" }) do
    reaper.SetMediaItemTakeInfo_Value(new_take, key, reaper.GetMediaItemTakeInfo_Value(take, key))
  end
  local _, name = reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", "", false)
  reaper.GetSetMediaItemTakeInfo_String(new_take, "P_NAME", tostring(command.name or (name .. " fix")), true)

  local env_points = 0
  local env = reaper.GetTakeEnvelopeByName(take, "Volume")
  if env then
    local ok, env_chunk = reaper.GetEnvelopeStateChunk(env, "", false)
    env_points = reaper.CountEnvelopePoints(env)
    if ok and env_points > 0 then
      -- the new take has no envelope yet: append it to its segment of the item chunk
      reaper.SetActiveTake(new_take)
      local _, chunk = reaper.GetItemStateChunk(item, "", false)
      local segments, index = active_take_segment(item, chunk)
      local seg = segments[index]
      if env_chunk:sub(-1) ~= "\n" then env_chunk = env_chunk .. "\n" end
      local close = seg:match(".*()\n>")
      if index == #segments and close then
        segments[index] = seg:sub(1, close) .. env_chunk .. seg:sub(close + 1)
      else
        segments[index] = seg .. env_chunk
      end
      reaper.SetItemStateChunk(item, table.concat(segments), false)
      new_take = reaper.GetActiveTake(item)
    end
  end

  reaper.SetActiveTake(new_take)
  reaper.UpdateItemInProject(item)
  reaper.UpdateArrange()
  return {
    take_count = reaper.CountTakes(item),
    file = file,
    copied_volume_envelope_points = env_points
  }
end

-- Deletes the takes of the first selected item whose source file name contains
-- command.match (plain text), e.g. earlier " prox-fix" renders, and leaves the
-- first surviving take active. Uses "Take: Delete active take from items"
-- (40129) with only this item selected, then restores the item selection.
local function command_remove_takes_matching(command)
  local item = reaper.GetSelectedMediaItem(0, 0)
  if not item then error("No selected media item.") end
  local match = tostring(command.match or "")
  if match == "" then error("remove_takes_matching needs a match string.") end

  local doomed = {}
  for i = 0, reaper.CountTakes(item) - 1 do
    local take = reaper.GetTake(item, i)
    if take and not reaper.TakeIsMIDI(take) then
      local name = reaper.GetMediaSourceFileName(reaper.GetMediaItemTake_Source(take), "")
      if name:find(match, 1, true) then doomed[#doomed + 1] = take end
    end
  end
  if #doomed == reaper.CountTakes(item) then error("Refusing to delete every take of the item.") end

  local selected = {}
  for i = 0, reaper.CountSelectedMediaItems(0) - 1 do selected[#selected + 1] = reaper.GetSelectedMediaItem(0, i) end
  for _, other in ipairs(selected) do reaper.SetMediaItemSelected(other, false) end
  reaper.SetMediaItemSelected(item, true)
  for _, take in ipairs(doomed) do
    reaper.SetActiveTake(take)
    reaper.Main_OnCommand(40129, 0)
  end
  reaper.SetActiveTake(reaper.GetTake(item, 0))
  for _, other in ipairs(selected) do reaper.SetMediaItemSelected(other, true) end

  reaper.UpdateItemInProject(item)
  reaper.UpdateArrange()
  local active = reaper.GetActiveTake(item)
  return {
    removed = #doomed,
    take_count = reaper.CountTakes(item),
    active_source = active and reaper.GetMediaSourceFileName(reaper.GetMediaItemTake_Source(active), "") or ""
  }
end

local PROXIMITY_EQ_NAME = "Proximity EQ"

local function ensure_take_volume_envelope(item, take)
  local env = reaper.GetTakeEnvelopeByName(take, "Volume")
  if env then return env end
  local selected = {}
  for i = 0, reaper.CountSelectedMediaItems(0) - 1 do selected[#selected + 1] = reaper.GetSelectedMediaItem(0, i) end
  reaper.SelectAllMediaItems(0, false)
  reaper.SetMediaItemSelected(item, true)
  reaper.Main_OnCommand(40693, 0) -- Take: Toggle take volume envelope
  for _, other in ipairs(selected) do reaper.SetMediaItemSelected(other, true) end
  env = reaper.GetTakeEnvelopeByName(take, "Volume")
  if not env then error("Could not create the take volume envelope.") end
  reaper.GetSetEnvelopeInfo_String(env, "ACTIVE", "1", true)
  reaper.GetSetEnvelopeInfo_String(env, "VISIBLE", "1", true)
  return env
end

local function parse_formatted(text)
  text = tostring(text or ""):lower()
  if text:find("inf") then return -1000 end
  local number = tonumber(text:match("[-+]?%d*%.?%d+"))
  if not number then return nil end
  if text:find("k") then number = number * 1000 end
  return number
end

-- Raw parameter value (TakeFX_GetParam units, the ones FX envelopes store) whose
-- displayed value is target. ReaEQ's raw and normalized scales differ, so the
-- search runs on SetParam/raw. The parameter must rise with its value.
local function raw_for(take, fx, param, target)
  local _, lo, hi = reaper.TakeFX_GetParam(take, fx, param)
  for _ = 1, 48 do
    local mid = (lo + hi) / 2
    reaper.TakeFX_SetParam(take, fx, param, mid)
    local _, shown = reaper.TakeFX_GetFormattedParamValue(take, fx, param, "")
    local value = parse_formatted(shown)
    if not value then error("Could not read FX parameter value '" .. tostring(shown) .. "'.") end
    if value < target then lo = mid else hi = mid end
  end
  return (lo + hi) / 2
end

local function find_proximity_eq(take)
  for i = 0, reaper.TakeFX_GetCount(take) - 1 do
    local ok, name = reaper.TakeFX_GetNamedConfigParm(take, i, "renamed_name")
    if ok and name == PROXIMITY_EQ_NAME then return i end
  end
  return nil
end

local function find_param(take, fx, words)
  for i = 0, reaper.TakeFX_GetNumParams(take, fx) - 1 do
    local _, name = reaper.TakeFX_GetParamName(take, fx, i, "")
    local lower = name:lower()
    local all = true
    for _, word in ipairs(words) do
      if not lower:find(word, 1, true) then all = false end
    end
    if all then return i, name end
  end
  return nil
end

local function clear_envelope(env, length)
  reaper.DeleteEnvelopePointRange(env, -1, length + 1)
end

-- command = { takeGuid, replace, shelfFreqHz, volumePoints = {{time, db}}, eqPoints = {{time, db}} }
-- times are item-relative seconds. Volume goes to the take volume envelope; the
-- shelf goes to a "Proximity EQ" ReaEQ take FX (band 1, low shelf) whose gain is automated.
local function command_apply_take_automation(command)
  local item, take = first_selected_take()
  local _, take_guid = reaper.GetSetMediaItemTakeInfo_String(take, "GUID", "", false)
  if command.takeGuid and command.takeGuid ~= take_guid then
    error("Active take changed since the analysis; run the command again.")
  end
  local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  local result = { volume_points = 0, eq_points = 0 }

  local volume_points = command.volumePoints or {}
  if #volume_points > 0 then
    local env = ensure_take_volume_envelope(item, take)
    if reaper.CountEnvelopePoints(env) > 0 then
      if command.replace ~= true then
        error("The take volume envelope already has points. Run with --replace-envelope to overwrite it.")
      end
      clear_envelope(env, length)
    end
    local mode = reaper.GetEnvelopeScalingMode(env)
    for _, point in ipairs(volume_points) do
      local gain = 10 ^ (tonumber(point[2]) / 20)
      reaper.InsertEnvelopePoint(env, tonumber(point[1]), reaper.ScaleToEnvelopeMode(mode, gain), 0, 0, false, true)
    end
    reaper.Envelope_SortPoints(env)
    result.volume_points = #volume_points
  end

  local eq_points = command.eqPoints or {}
  if #eq_points > 0 then
    local fx = find_proximity_eq(take)
    local created = false
    if not fx then
      fx = reaper.TakeFX_AddByName(take, "ReaEQ (Cockos)", -1)
      if fx < 0 then error("Could not add ReaEQ to the take.") end
      reaper.TakeFX_SetNamedConfigParm(take, fx, "renamed_name", PROXIMITY_EQ_NAME)
      reaper.TakeFX_SetNamedConfigParm(take, fx, "BANDTYPE0", "0") -- band 1: low shelf
      created = true
    end
    local freq_param, freq_name = find_param(take, fx, { "freq" })
    local gain_param, gain_name = find_param(take, fx, { "gain" })
    if not freq_param or not gain_param then error("Could not find band 1 frequency/gain in ReaEQ.") end

    reaper.TakeFX_SetParam(take, fx, freq_param, raw_for(take, fx, freq_param, tonumber(command.shelfFreqHz) or 273))
    local cache = {}
    local function gain_raw(db)
      local key = string.format("%.2f", db)
      if not cache[key] then cache[key] = raw_for(take, fx, gain_param, db) end
      return cache[key]
    end
    local zero = gain_raw(0)

    local env = reaper.TakeFX_GetEnvelope(take, fx, gain_param, true)
    if not env then error("Could not create the ReaEQ gain envelope.") end
    if reaper.CountEnvelopePoints(env) > 0 then
      if command.replace ~= true and not created then
        error("Proximity EQ already has automation. Run with --replace-envelope to overwrite it.")
      end
      clear_envelope(env, length)
    end
    for _, point in ipairs(eq_points) do
      reaper.InsertEnvelopePoint(env, tonumber(point[1]), gain_raw(tonumber(point[2])), 0, 0, false, true)
    end
    reaper.Envelope_SortPoints(env)
    reaper.TakeFX_SetParam(take, fx, gain_param, zero)
    reaper.GetSetEnvelopeInfo_String(env, "VISIBLE", "1", true)
    local _, shown = reaper.TakeFX_GetFormattedParamValue(take, fx, freq_param, "")
    result.eq_points = #eq_points
    result.eq_fx_index = fx
    local check = {}
    for _, db in ipairs({ 0, 3 }) do
      reaper.TakeFX_SetParam(take, fx, gain_param, gain_raw(db))
      local _, shown_db = reaper.TakeFX_GetFormattedParamValue(take, fx, gain_param, "")
      check[#check + 1] = { db = db, raw = gain_raw(db), shown = shown_db }
    end
    reaper.TakeFX_SetParam(take, fx, gain_param, zero)
    result.eq_params = { freq = freq_name, gain = gain_name, freq_shown = shown, gain_check = check }
  end

  reaper.UpdateItemInProject(item)
  reaper.UpdateArrange()
  return result
end

-- Read-only: FX of the active take with band 1 parameters and their envelopes,
-- plus the take volume envelope, to check what automation actually does.
local function command_take_fx_report(command)
  local item, take = first_selected_take()
  local limit = math.floor(tonumber(command and command.limit) or 8)
  local report = { fx = {} }
  local function env_points(env, limit)
    local points = {}
    for i = 0, math.min(reaper.CountEnvelopePoints(env), limit) - 1 do
      local _, time, value = reaper.GetEnvelopePoint(env, i)
      points[#points + 1] = { time, value }
    end
    return points
  end
  for fx = 0, reaper.TakeFX_GetCount(take) - 1 do
    local _, name = reaper.TakeFX_GetFXName(take, fx, "")
    local _, renamed = reaper.TakeFX_GetNamedConfigParm(take, fx, "renamed_name")
    local entry = { name = name, renamed = renamed, enabled = reaper.TakeFX_GetEnabled(take, fx), params = {} }
    for p = 0, math.min(reaper.TakeFX_GetNumParams(take, fx), 4) - 1 do
      local _, pname = reaper.TakeFX_GetParamName(take, fx, p, "")
      local raw, minv, maxv = reaper.TakeFX_GetParam(take, fx, p)
      local _, shown = reaper.TakeFX_GetFormattedParamValue(take, fx, p, "")
      local param = { index = p, name = pname, raw = raw, min = minv, max = maxv,
        normalized = reaper.TakeFX_GetParamNormalized(take, fx, p), shown = shown }
      local env = reaper.TakeFX_GetEnvelope(take, fx, p, false)
      if env then
        local _, active = reaper.GetSetEnvelopeInfo_String(env, "ACTIVE", "", false)
        param.envelope = { active = active, count = reaper.CountEnvelopePoints(env), points = env_points(env, limit) }
      end
      entry.params[#entry.params + 1] = param
    end
    report.fx[#report.fx + 1] = entry
  end
  local vol = reaper.GetTakeEnvelopeByName(take, "Volume")
  if vol then
    local mode = reaper.GetEnvelopeScalingMode(vol)
    local points = env_points(vol, limit)
    for _, point in ipairs(points) do
      local gain = reaper.ScaleFromEnvelopeMode(mode, point[2])
      point[3] = gain > 0 and 20 * math.log(gain, 10) or -150
    end
    report.volume = { count = reaper.CountEnvelopePoints(vol), scaling = mode, points = points }
  end
  report.item_position = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  return report
end

function M.register(registry)
  registry.command("sample_edit_probe", command_sample_edit_probe, { read_only = true })
  registry.command("sample_edit_dump", command_sample_edit_dump, { read_only = true })
  registry.command("sample_edit_apply", command_sample_edit_apply)
  registry.command("add_take_from_file", command_add_take_from_file)
  registry.command("remove_takes_matching", command_remove_takes_matching)
  registry.command("apply_take_automation", command_apply_take_automation)
  registry.command("take_fx_report", command_take_fx_report, { read_only = true })
end

return M
