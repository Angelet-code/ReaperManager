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

function M.register(registry)
  registry.command("sample_edit_probe", command_sample_edit_probe, { read_only = true })
  registry.command("sample_edit_apply", command_sample_edit_apply)
end

return M
