-- Builds a session from a declarative spec: tempo, tracks, audio loops, MIDI parts,
-- FX with named parameters and sends. Positions and lengths are in bars (1-based
-- positions) so the arrangement follows the project tempo map.
local M = {}

local function db_to_gain(db)
  return 10 ^ ((tonumber(db) or 0) / 20)
end

local function hex_color(value)
  if type(value) ~= "string" then return nil end
  local r, g, b = value:match("^#?(%x%x)(%x%x)(%x%x)$")
  if not r then return nil end
  return reaper.ColorToNative(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)) | 0x1000000
end

local function beats_per_bar()
  local _, num = reaper.TimeMap_GetTimeSigAtTime(0, 0)
  return num or 4
end

-- bar is 1-based and may be fractional; returns its position in quarter notes from the measure map,
-- so projects with only the header tempo (no tempo marker) are placed at their real tempo too.
local function bar_qn(bar)
  local whole = math.floor(bar)
  local _, qn_start, qn_end = reaper.TimeMap_GetMeasureInfo(0, whole - 1)
  return qn_start + (bar - whole) * (qn_end - qn_start)
end

-- bar is 1-based and may be fractional; returns project time in seconds.
local function bar_time(bar)
  return reaper.TimeMap2_QNToTime(0, bar_qn(bar))
end

local function bars_length(start_bar, bars)
  return bar_time(start_bar + bars) - bar_time(start_bar)
end

local function find_track(name)
  for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    local _, track_name = reaper.GetTrackName(track)
    if track_name == name then return track end
  end
  return nil
end

local function fx_param_index(track, fx, wanted)
  local lower = wanted:lower()
  local count = reaper.TrackFX_GetNumParams(track, fx)
  for p = 0, count - 1 do
    local _, name = reaper.TrackFX_GetParamName(track, fx, p, "")
    if name:lower() == lower then return p end
  end
  for p = 0, count - 1 do
    local _, name = reaper.TrackFX_GetParamName(track, fx, p, "")
    if name:lower():find(lower, 1, true) then return p end
  end
  return nil
end

local function describe_params(track, fx)
  local params = {}
  for p = 0, reaper.TrackFX_GetNumParams(track, fx) - 1 do
    local _, name = reaper.TrackFX_GetParamName(track, fx, p, "")
    local _, formatted = reaper.TrackFX_GetFormattedParamValue(track, fx, p, "")
    params[#params + 1] = {
      index = p,
      name = name,
      value = reaper.TrackFX_GetParamNormalized(track, fx, p),
      formatted = formatted
    }
  end
  return params
end

-- params: { ["Param name"] = normalized 0..1 }
local function apply_fx_params(track, fx, params, report)
  for name, value in pairs(params or {}) do
    local p = fx_param_index(track, fx, name)
    if p then
      reaper.TrackFX_SetParamNormalized(track, fx, p, tonumber(value) or 0)
      local _, formatted = reaper.TrackFX_GetFormattedParamValue(track, fx, p, "")
      report[#report + 1] = { param = name, formatted = formatted }
    else
      report[#report + 1] = { param = name, missing = true }
    end
  end
end

-- ReaSamplOmatic5000 playing a slice of a file: { file, start, len (seconds), note, note_end }.
-- Without a note it answers to every note, which suits one-drum-per-track samplers.
local function add_sampler(track, spec, sampler)
  local source = reaper.PCM_Source_CreateFromFile(sampler.file)
  local source_length = source and reaper.GetMediaSourceLength(source) or 0
  if source then reaper.PCM_Source_Destroy(source) end
  if source_length <= 0 then error("could not open sampler file: " .. tostring(sampler.file)) end

  local index = reaper.TrackFX_AddByName(track, "ReaSamplOmatic5000", false, -1)
  if index < 0 then error("could not add ReaSamplOmatic5000") end
  reaper.TrackFX_SetNamedConfigParm(track, index, "FILE0", sampler.file)
  reaper.TrackFX_SetNamedConfigParm(track, index, "DONE", "")

  local start = tonumber(sampler.start) or 0
  local stop = sampler.len and math.min(source_length, start + sampler.len) or source_length
  local params = {
    ["Sample start offset"] = start / source_length,
    ["Sample end offset"] = stop / source_length,
    ["Obey note-offs"] = sampler.obey_noteoff and 1 or 0
  }
  if sampler.note then
    params["Note range start"] = sampler.note / 127
    params["Note range end"] = (sampler.note_end or sampler.note) / 127
  end
  for name, value in pairs(spec.params or {}) do params[name] = value end

  local report = { fx = "ReaSamplOmatic5000", index = index, slice = { start, stop }, params = {} }
  apply_fx_params(track, index, params, report.params)
  if spec.rename then
    reaper.TrackFX_SetNamedConfigParm(track, index, "renamed_name", spec.rename)
  end
  if spec.describe then report.available = describe_params(track, index) end
  return report
end

-- Patch library: a plugin's full state (e.g. Kontakt with an instrument loaded) saved as an
-- .RfxChain under <resource>/FXChains/Reaper Manager, so it can be recalled without the plugin UI.
local function patch_dir()
  return reaper.GetResourcePath() .. "\\FXChains\\Reaper Manager"
end

local function patch_path(name)
  local safe = tostring(name):gsub('[\\/:*?"<>|]', "_")
  return patch_dir() .. "\\" .. safe .. ".RfxChain"
end

-- Splits the track chunk's FXCHAIN into one text block per FX (BYPASS ... WAK), keeping order.
local function fx_blocks(chunk)
  local lines = {}
  for line in (chunk .. "\n"):gmatch("(.-)\r?\n") do lines[#lines + 1] = line end
  local blocks, current, depth, in_chain = {}, nil, 0, false
  local chain_start, chain_end
  for i, line in ipairs(lines) do
    local trimmed = line:match("^%s*(.-)%s*$")
    if not in_chain then
      if trimmed == "<FXCHAIN" then in_chain, depth, chain_start = true, 1, i end
    else
      if depth == 1 and trimmed:match("^BYPASS ") then
        current = { line }
        blocks[#blocks + 1] = current
      elseif depth == 1 and trimmed == ">" then
        chain_end = i
        break
      elseif current then
        current[#current + 1] = line
      end
      if trimmed:sub(1, 1) == "<" then depth = depth + 1 elseif trimmed == ">" then depth = depth - 1 end
    end
  end
  return blocks, lines, chain_start, chain_end
end

local function capture_patch(track, fx, name)
  local _, chunk = reaper.GetTrackStateChunk(track, "", false)
  local blocks = fx_blocks(chunk)
  local block = blocks[fx + 1]
  if not block then error("FX " .. fx .. " not found in the track chunk") end
  local out = {}
  for _, line in ipairs(block) do
    if not line:match("^%s*FXID ") and not line:match("^%s*FLOATPOS ") then out[#out + 1] = line:match("^%s*(.-)$") end
  end
  reaper.RecursiveCreateDirectory(patch_dir(), 0)
  local path = patch_path(name)
  local file = io.open(path, "wb")
  if not file then error("could not write " .. path) end
  file:write(table.concat(out, "\n") .. "\n")
  file:close()
  local _, fx_name = reaper.TrackFX_GetFXName(track, fx, "")
  return { patch = name, file = path, fx = fx_name, bytes = #table.concat(out, "\n") }
end

-- Appends a saved patch to the track's FX chain by editing the track chunk.
local function load_patch(track, name)
  local path = patch_path(name)
  local file = io.open(path, "rb")
  if not file then error("patch not found: " .. tostring(name) .. " (" .. path .. ")") end
  local body = file:read("*a")
  file:close()
  local before = reaper.TrackFX_GetCount(track)
  local _, chunk = reaper.GetTrackStateChunk(track, "", false)
  local _, lines, chain_start, chain_end = fx_blocks(chunk)
  local new_chunk
  if chain_start and chain_end then
    table.insert(lines, chain_end, (body:gsub("\n$", "")))
    new_chunk = table.concat(lines, "\n")
  else
    local chain = "<FXCHAIN\nSHOW 0\nLASTSEL 0\nDOCKED 0\n" .. body .. ">"
    local at = chunk:find("\n<ITEM") or chunk:match("^.*()\n>")
    new_chunk = chunk:sub(1, at) .. chain .. "\n" .. chunk:sub(at + 1)
  end
  if not reaper.SetTrackStateChunk(track, new_chunk, false) then error("SetTrackStateChunk refused patch " .. name) end
  local count = reaper.TrackFX_GetCount(track)
  if count <= before then error("patch did not add an FX: " .. name) end
  local _, fx_name = reaper.TrackFX_GetFXName(track, count - 1, "")
  reaper.TrackFX_Show(track, count - 1, 2) -- no floating window: many open plugin GUIs froze REAPER
  return { patch = name, fx = fx_name, index = count - 1 }
end

local function add_fx(track, spec)
  if spec.patch then return load_patch(track, spec.patch) end
  if spec.sampler then return add_sampler(track, spec, spec.sampler) end
  local candidates = spec.candidates or { spec.name }
  for _, candidate in ipairs(candidates) do
    local index = reaper.TrackFX_AddByName(track, candidate, false, -1)
    if index >= 0 then
      reaper.TrackFX_Show(track, index, 2) -- no floating window (auto-float would open every GUI)
      local report = { fx = candidate, index = index, params = {} }
      apply_fx_params(track, index, spec.params, report.params)
      if spec.describe then report.available = describe_params(track, index) end
      return report
    end
  end
  if spec.optional then
    return { fx = candidates[1], skipped = true }
  end
  error("could not add FX: " .. tostring(candidates[1]))
end

local function add_audio_item(track, spec)
  local source = reaper.PCM_Source_CreateFromFile(spec.file)
  if not source then error("could not open audio file: " .. tostring(spec.file)) end
  local source_length = reaper.GetMediaSourceLength(source)
  if not source_length or source_length <= 0 then
    error("audio file has no length (missing or unsupported?): " .. tostring(spec.file))
  end

  local start_bar = tonumber(spec.bar) or 1
  local position = bar_time(start_bar)
  local length = spec.bars and bars_length(start_bar, spec.bars) or tonumber(spec.length) or source_length

  local item = reaper.AddMediaItemToTrack(track)
  local take = reaper.AddTakeToMediaItem(item)
  reaper.SetMediaItemTake_Source(take, source)
  reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", spec.name or spec.file:match("([^\\/]+)$"), true)

  -- source_bars: how many bars the file spans, so it is stretched to the project tempo.
  local playrate = tonumber(spec.playrate) or 1
  if spec.source_bars then
    local target = bars_length(1, spec.source_bars)
    local usable = source_length - (tonumber(spec.offset) or 0)
    playrate = usable / target
  end
  reaper.SetMediaItemTakeInfo_Value(take, "D_PLAYRATE", playrate)
  reaper.SetMediaItemTakeInfo_Value(take, "B_PPITCH", spec.preserve_pitch == false and 0 or 1)
  reaper.SetMediaItemTakeInfo_Value(take, "D_STARTOFFS", tonumber(spec.offset) or 0)
  if spec.pitch then reaper.SetMediaItemTakeInfo_Value(take, "D_PITCH", tonumber(spec.pitch)) end
  if spec.volume_db then reaper.SetMediaItemTakeInfo_Value(take, "D_VOL", db_to_gain(spec.volume_db)) end

  reaper.SetMediaItemInfo_Value(item, "D_POSITION", position)
  reaper.SetMediaItemInfo_Value(item, "D_LENGTH", length)
  reaper.SetMediaItemInfo_Value(item, "B_LOOPSRC", spec.loop == false and 0 or 1)
  if spec.fade_in then
    reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", spec.fade_in_bars and bars_length(start_bar, spec.fade_in) or spec.fade_in)
  end
  if spec.fade_out then
    reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", spec.fade_out_bars and bars_length(start_bar, spec.fade_out) or spec.fade_out)
  end
  reaper.UpdateItemInProject(item)

  return { kind = "audio", bar = start_bar, position = position, length = length, playrate = playrate, source_length = source_length }
end

-- notes: { pitch, beat (0-based from the item start), len (beats), vel, chan (0-15, optional;
-- guitar parts use chan 0-5 = string 1-6 so the Tab Viewer shows the intended fingering) }
local function add_midi_item(track, spec)
  local start_bar = tonumber(spec.bar) or 1
  local bars = tonumber(spec.bars) or 1
  local position = bar_time(start_bar)
  local item = reaper.CreateNewMIDIItemInProj(track, position, bar_time(start_bar + bars), false)
  local take = reaper.GetActiveTake(item)
  if spec.name then reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", spec.name, true) end

  local start_qn = bar_qn(start_bar)
  local count = 0
  for _, note in ipairs(spec.notes or {}) do
    local on_time = reaper.TimeMap2_QNToTime(0, start_qn + note.beat)
    local off_time = reaper.TimeMap2_QNToTime(0, start_qn + note.beat + note.len)
    local on_ppq = reaper.MIDI_GetPPQPosFromProjTime(take, on_time)
    local off_ppq = reaper.MIDI_GetPPQPosFromProjTime(take, off_time)
    reaper.MIDI_InsertNote(take, false, false, on_ppq, off_ppq, math.floor(tonumber(note.chan) or 0) & 15, note.pitch, note.vel or 90, true)
    count = count + 1
  end
  -- cc: { beat, cc, value } on channel 1 (e.g. cc 64 for the sustain pedal),
  -- { beat, pb = -8192..8191 } for pitch bend, { beat, at = 0..127 } for channel aftertouch.
  for _, cc in ipairs(spec.cc or {}) do
    local ppq = reaper.MIDI_GetPPQPosFromProjTime(take, reaper.TimeMap2_QNToTime(0, start_qn + cc.beat))
    if cc.pb then
      local value = math.max(0, math.min(16383, math.floor(cc.pb + 8192 + 0.5)))
      reaper.MIDI_InsertCC(take, false, false, ppq, 0xE0, 0, value & 0x7F, (value >> 7) & 0x7F, true)
    elseif cc.at then
      reaper.MIDI_InsertCC(take, false, false, ppq, 0xD0, 0, cc.at, 0, true)
    else
      reaper.MIDI_InsertCC(take, false, false, ppq, 0xB0, 0, cc.cc, cc.value, true)
    end
  end
  reaper.MIDI_Sort(take)
  -- CC points ramp between each other (linear by default) instead of REAPER's square steps
  local shape = ({ square = 0, linear = 1, slow = 2, fast_start = 3, fast_end = 4, bezier = 5 })[spec.cc_shape or "linear"] or 1
  local _, _, cc_count = reaper.MIDI_CountEvts(take)
  for c = 0, cc_count - 1 do
    local _, _, _, _, chanmsg = reaper.MIDI_GetCC(take, c)
    if chanmsg == 0xB0 then reaper.MIDI_SetCCShape(take, c, shape, 0, true) end
  end
  reaper.MIDI_Sort(take)
  reaper.UpdateItemInProject(item)

  return { kind = "midi", bar = start_bar, bars = bars, notes = count }
end

local function command_build_beat(command)
  local result = { tracks = {} }

  -- replace_tempo: rebuild the tempo map from scratch (re-sending a map otherwise adds markers on top of the
  -- old ones); replace_markers: same for project markers (regions are kept)
  if command.replace_tempo then
    for i = reaper.CountTempoTimeSigMarkers(0) - 1, 0, -1 do reaper.DeleteTempoTimeSigMarker(0, i) end
  end
  if command.replace_markers then
    local _, markers, regions = reaper.CountProjectMarkers(0)
    for i = markers + regions - 1, 0, -1 do
      local _, is_region, _, _, _, index = reaper.EnumProjectMarkers(i)
      if not is_region then reaper.DeleteProjectMarker(0, index, false) end
    end
  end

  if command.tempo then
    local num = command.timesig and command.timesig[1] or 4
    local denom = command.timesig and command.timesig[2] or 4
    if reaper.CountTempoTimeSigMarkers(0) > 0 then
      reaper.SetTempoTimeSigMarker(0, 0, 0, -1, -1, command.tempo, num, denom, false)
    else
      reaper.SetTempoTimeSigMarker(0, -1, 0, -1, -1, command.tempo, num, denom, false)
    end
    reaper.UpdateTimeline()
    result.tempo = reaper.Master_GetTempo()
  end

  -- tempo_changes: { bar, bpm, linear, timesig = {num, denom} } in ascending bar order, added before any
  -- item so every position below is computed on the final tempo map. linear ramps to the next marker.
  -- A timesig change is placed by measure so the later bars follow the new meter.
  for _, change in ipairs(command.tempo_changes or {}) do
    if change.timesig then
      reaper.SetTempoTimeSigMarker(0, -1, -1, math.floor(change.bar) - 1, 0, change.bpm,
        change.timesig[1], change.timesig[2], change.linear == true)
    else
      reaper.SetTempoTimeSigMarker(0, -1, bar_time(change.bar), -1, -1, change.bpm, 0, 0, change.linear == true)
    end
    reaper.UpdateTimeline()
  end
  if command.tempo_changes then reaper.UpdateTimeline() end
  result.tempo_markers = reaper.CountTempoTimeSigMarkers(0)

  -- Pass 1: create tracks so sends can target any of them.
  local created = {}
  -- insert_after: add the new tracks right below an existing track (e.g. inside its folder)
  local next_index = reaper.CountTracks(0)
  if command.insert_after then
    local anchor = find_track(command.insert_after)
    if not anchor then error("insert_after track not found: " .. tostring(command.insert_after)) end
    next_index = math.floor(reaper.GetMediaTrackInfo_Value(anchor, "IP_TRACKNUMBER"))
  end
  for _, spec in ipairs(command.tracks or {}) do
    local index = next_index
    next_index = next_index + 1
    reaper.InsertTrackAtIndex(index, true)
    local track = reaper.GetTrack(0, index)
    reaper.GetSetMediaTrackInfo_String(track, "P_NAME", spec.name, true)
    local color = hex_color(spec.color)
    if color then reaper.SetTrackColor(track, color) end
    if spec.volume_db then reaper.SetMediaTrackInfo_Value(track, "D_VOL", db_to_gain(spec.volume_db)) end
    if spec.pan then reaper.SetMediaTrackInfo_Value(track, "D_PAN", tonumber(spec.pan)) end
    -- folder: 1 opens a folder on this track, -1 (or -2...) closes it after this track.
    if spec.folder then reaper.SetMediaTrackInfo_Value(track, "I_FOLDERDEPTH", tonumber(spec.folder)) end
    created[#created + 1] = { track = track, spec = spec }
  end

  if command.master_fx then
    result.master_fx = {}
    local master = reaper.GetMasterTrack(0)
    for _, fx in ipairs(command.master_fx) do
      result.master_fx[#result.master_fx + 1] = add_fx(master, fx)
    end
  end

  -- Pass 2: content, FX and sends.
  for _, entry in ipairs(created) do
    local track, spec = entry.track, entry.spec
    local report = { name = spec.name, items = {}, fx = {}, sends = {} }

    for _, item in ipairs(spec.items or {}) do
      report.items[#report.items + 1] = add_audio_item(track, item)
    end
    for _, midi in ipairs(spec.midi or {}) do
      report.items[#report.items + 1] = add_midi_item(track, midi)
    end
    for _, fx in ipairs(spec.fx or {}) do
      report.fx[#report.fx + 1] = add_fx(track, fx)
    end
    for _, send in ipairs(spec.sends or {}) do
      local dest = find_track(send.dest)
      if not dest then error("send destination not found: " .. tostring(send.dest)) end
      local send_index = reaper.CreateTrackSend(track, dest)
      reaper.SetTrackSendInfo_Value(track, 0, send_index, "D_VOL", db_to_gain(send.db or 0))
      report.sends[#report.sends + 1] = { dest = send.dest, db = send.db or 0 }
    end
    if spec.input_midi then
      reaper.SetMediaTrackInfo_Value(track, "I_RECINPUT", 4096 | (63 << 5))
    end

    result.tracks[#result.tracks + 1] = report
  end

  if command.loop_bars then
    local start = bar_time(command.loop_bars[1])
    local stop = bar_time(command.loop_bars[2])
    reaper.GetSet_LoopTimeRange(true, true, start, stop, false)
  end
  if command.markers then
    for _, marker in ipairs(command.markers) do
      reaper.AddProjectMarker(0, false, bar_time(marker.bar), 0, marker.name, -1)
    end
  end

  reaper.SetEditCurPos(0, true, false)
  reaper.TrackList_AdjustWindows(false)
  reaper.UpdateArrange()
  return result
end

-- Read or set FX parameters on a named track: { track, fx (index), params = {name = norm} }
local function command_fx_params(command)
  local track = command.track == "MASTER" and reaper.GetMasterTrack(0) or find_track(command.track)
  if not track then error("track not found: " .. tostring(command.track)) end
  -- fx_match applies the same params to every FX on the track whose name contains it.
  if command.fx_match then
    local changed = {}
    for fx = 0, reaper.TrackFX_GetCount(track) - 1 do
      local _, fx_name = reaper.TrackFX_GetFXName(track, fx, "")
      if fx_name:lower():find(command.fx_match:lower(), 1, true) then
        local report = {}
        apply_fx_params(track, fx, command.params, report)
        changed[#changed + 1] = { fx = fx_name, changed = report }
      end
    end
    return { track = command.track, matched = #changed, changed = changed }
  end

  local fx = tonumber(command.fx) or 0
  local report = {}
  apply_fx_params(track, fx, command.params, report)
  local _, fx_name = reaper.TrackFX_GetFXName(track, fx, "")
  return { track = command.track, fx = fx_name, changed = report, params = describe_params(track, fx) }
end

-- Swap a track's MIDI part: removes its MIDI items and writes new ones { track, midi = {...} }.
local function command_replace_midi(command)
  local track = find_track(command.track)
  if not track then error("track not found: " .. tostring(command.track)) end
  local removed = 0
  for i = reaper.CountTrackMediaItems(track) - 1, 0, -1 do
    local item = reaper.GetTrackMediaItem(track, i)
    local take = reaper.GetActiveTake(item)
    if take and reaper.TakeIsMIDI(take) then
      reaper.DeleteTrackMediaItem(track, item)
      removed = removed + 1
    end
  end
  local items = {}
  for _, midi in ipairs(command.midi or {}) do
    items[#items + 1] = add_midi_item(track, midi)
  end
  reaper.UpdateArrange()
  return { track = command.track, removed = removed, items = items }
end

-- Add MIDI items to an existing track, leaving its current items alone: { track, midi = {...} }.
local function command_add_midi(command)
  local track = find_track(command.track)
  if not track then error("track not found: " .. tostring(command.track)) end
  local items = {}
  for _, midi in ipairs(command.midi or {}) do
    items[#items + 1] = add_midi_item(track, midi)
  end
  reaper.UpdateArrange()
  return { track = command.track, items = items }
end

-- Track selection shared by the MIDI feel commands: an exact name list (tracks) or a substring (contains).
local function track_matches(name, command)
  if command.tracks then
    for _, wanted in ipairs(command.tracks) do
      if wanted == name then return true end
    end
    return false
  end
  return not command.contains or name:lower():find(command.contains:lower(), 1, true) ~= nil
end

-- Optional skip ranges for the feel commands: { {from_bar, to_bar}, ... } in 1-based fractional bars
-- (e.g. {12.48, 13} = from just before beat 3 of bar 12 to the next downbeat). Notes starting there are left alone.
local function skip_ranges(command)
  local ranges = {}
  for _, r in ipairs(command.skip or {}) do
    local function qn_of(bar)
      local whole = math.floor(bar)
      local _, qn_start, qn_end = reaper.TimeMap_GetMeasureInfo(0, whole - 1)
      return qn_start + (bar - whole) * (qn_end - qn_start)
    end
    ranges[#ranges + 1] = { qn_of(r[1]), qn_of(r[2]) }
  end
  return function(qn)
    for _, r in ipairs(ranges) do
      if qn >= r[1] - 1e-6 and qn < r[2] - 1e-6 then return true end
    end
    return false
  end
end

-- Swing existing MIDI: notes near an off-beat grid step move to an absolute MPC-style swing.
-- { amount = 0.5..0.75 (or 50..75), grid = quarter notes per step (0.25 = 16ths), tracks | contains,
--   keep = max humanize kept around the new position (quarter notes),
--   quantize = also pull the on-grid notes back to the grid (keeping 'keep') }
local function command_swing_midi(command)
  local amount = tonumber(command.amount) or 0.58
  if amount > 1 then amount = amount / 100 end
  local grid = tonumber(command.grid) or 0.25
  local delta = (2 * amount - 1) * grid
  local keep = tonumber(command.keep) or 0.012
  local skipped = skip_ranges(command)
  local report = {}
  for t = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, t)
    local _, name = reaper.GetTrackName(track)
    if track_matches(name, command) then
      local moved = 0
      for i = 0, reaper.CountTrackMediaItems(track) - 1 do
        local take = reaper.GetActiveTake(reaper.GetTrackMediaItem(track, i))
        if take and reaper.TakeIsMIDI(take) then
          local _, notes = reaper.MIDI_CountEvts(take)
          -- note starts before anything moves, to recognise ornaments (a short grace note that
          -- ends where another note starts): those follow their main note instead of the grid
          local starts = {}
          for n = 0, notes - 1 do
            local _, _, _, sppq = reaper.MIDI_GetNote(take, n)
            starts[#starts + 1] = reaper.MIDI_GetProjQNFromPPQPos(take, sppq)
          end
          for n = 0, notes - 1 do
            local _, _, _, sppq, eppq = reaper.MIDI_GetNote(take, n)
            local qn = reaper.MIDI_GetProjQNFromPPQPos(take, sppq)
            local qn_end = reaper.MIDI_GetProjQNFromPPQPos(take, eppq)
            local ornament = false
            if qn_end - qn < 0.1 then
              for _, other in ipairs(starts) do
                if other > qn + 0.001 and math.abs(other - qn_end) < 0.012 then ornament = true break end
              end
            end
            local anchor = ornament and qn_end or qn
            local step = math.floor(anchor / grid + 0.5)
            local dev = anchor - step * grid
            -- swing only ever moves off-beats later, so their window reaches further to the right;
            -- it still stops short of the neighbouring 16ths (swung "e" ~0.3, "a" ~0.77 of the beat)
            local near
            if step % 2 == 1 then
              near = dev > -math.min(grid * 0.36, 0.09) and dev < grid * 0.38
            else
              near = math.abs(dev) < math.min(grid * 0.4, 0.09)
            end
            if command.inspect then
              -- read-only: report where the notes sit inside the beat
              local key = string.format("%.2f", qn % 1)
              report.positions = report.positions or {}
              report.positions[key] = (report.positions[key] or 0) + 1
            elseif near and (step % 2 == 1 or command.quantize) and not skipped(anchor) then
              local human = math.max(-keep, math.min(keep, dev))
              local target = step * grid + (step % 2 == 1 and delta or 0) + human
              local shift = reaper.MIDI_GetPPQPosFromProjQN(take, target) - reaper.MIDI_GetPPQPosFromProjQN(take, anchor)
              reaper.MIDI_SetNote(take, n, nil, nil, sppq + shift, eppq + shift, nil, nil, nil, true)
              moved = moved + 1
            end
          end
          reaper.MIDI_Sort(take)
        end
      end
      if moved > 0 then report[#report + 1] = { track = name, moved = moved } end
    end
  end
  reaper.UpdateArrange()
  return { amount = amount, grid = grid, tracks = report, positions = report.positions }
end

-- Humanize existing MIDI per track: { contains, offset_ms (constant push/lay back), timing_ms (random +-),
--   drift_ms (slow sine drift over ~4 bars), velocity (random +-), seed }.
-- Notes starting within 15 ms of each other (a chord) move together.
local function command_humanize_midi(command)
  local offset = (tonumber(command.offset_ms) or 0) / 1000
  local timing = (tonumber(command.timing_ms) or 0) / 1000
  local drift = (tonumber(command.drift_ms) or 0) / 1000
  local velocity = tonumber(command.velocity) or 0
  math.randomseed(tonumber(command.seed) or 1)
  local phase = math.random() * math.pi * 2
  local report = {}
  for t = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, t)
    local _, name = reaper.GetTrackName(track)
    if track_matches(name, command) then
      local moved = 0
      for i = 0, reaper.CountTrackMediaItems(track) - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local take = reaper.GetActiveTake(item)
        if take and reaper.TakeIsMIDI(take) then
          local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
          local _, notes = reaper.MIDI_CountEvts(take)
          local group_time, group_shift = nil, 0
          for n = 0, notes - 1 do
            local _, _, _, sppq, eppq, _, _, vel = reaper.MIDI_GetNote(take, n)
            local time = reaper.MIDI_GetProjTimeFromPPQPos(take, sppq)
            if not group_time or math.abs(time - group_time) > 0.015 then
              group_time = time
              local qn = reaper.MIDI_GetProjQNFromPPQPos(take, sppq)
              group_shift = offset + (math.random() * 2 - 1) * timing + math.sin(qn / 16 * math.pi * 2 + phase) * drift
            end
            local new_time = math.max(item_start, time + group_shift)
            local new_start = reaper.MIDI_GetPPQPosFromProjTime(take, new_time)
            local new_vel = math.max(1, math.min(127, math.floor(vel + (math.random() * 2 - 1) * velocity + 0.5)))
            reaper.MIDI_SetNote(take, n, nil, nil, new_start, eppq + (new_start - sppq), nil, nil, new_vel, true)
            moved = moved + 1
          end
          reaper.MIDI_Sort(take)
        end
      end
      if moved > 0 then report[#report + 1] = { track = name, notes = moved } end
    end
  end
  reaper.UpdateArrange()
  return { tracks = report }
end

-- Bar (1-based) and beat (0-based, quarter notes) of a project time.
local function bar_beat(time)
  local beats, measure = reaper.TimeMap2_timeToBeats(0, time)
  return measure + 1, beats
end

-- Read the MIDI notes of tracks (read-only): { tracks | contains, from_bar, to_bar } ->
-- per track: items { from_bar, to_bar, muted } and notes { bar, beat, len (qn), pitch, vel }.
local function command_dump_midi(command)
  local from_bar = tonumber(command.from_bar) or 1
  local to_bar = tonumber(command.to_bar) or 100000
  local report = {}
  for t = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, t)
    local _, name = reaper.GetTrackName(track)
    if track_matches(name, command) then
      local entry = { track = name, items = {}, notes = {} }
      for i = 0, reaper.CountTrackMediaItems(track) - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local ib, ibeat = bar_beat(pos)
        local eb, ebeat = bar_beat(pos + reaper.GetMediaItemInfo_Value(item, "D_LENGTH"))
        entry.items[#entry.items + 1] = { from_bar = ib + ibeat / 4, to_bar = eb + ebeat / 4,
          muted = reaper.GetMediaItemInfo_Value(item, "B_MUTE") == 1 }
        local take = reaper.GetActiveTake(item)
        if take and reaper.TakeIsMIDI(take) then
          local _, count, cc_count = reaper.MIDI_CountEvts(take)
          entry.cc_count = (entry.cc_count or 0) + cc_count
          for n = 0, count - 1 do
            local _, _, muted, sppq, eppq, _, pitch, vel = reaper.MIDI_GetNote(take, n)
            local time = reaper.MIDI_GetProjTimeFromPPQPos(take, sppq)
            local bar, beat = bar_beat(time)
            if bar >= from_bar and bar <= to_bar and not muted and time >= pos - 0.001 then
              local qn = reaper.MIDI_GetProjQNFromPPQPos(take, sppq)
              entry.notes[#entry.notes + 1] = { bar = bar, beat = math.floor(beat * 1000 + 0.5) / 1000,
                len = math.floor((reaper.MIDI_GetProjQNFromPPQPos(take, eppq) - qn) * 1000 + 0.5) / 1000, pitch = pitch, vel = vel }
            end
          end
        end
      end
      report[#report + 1] = entry
    end
  end
  return { tracks = report }
end

-- Delete MIDI notes in ranges: { tracks | contains, ranges = { {from_bar, to_bar}, ... } (1-based fractional bars),
--   min_vel, max_vel, pitch } -- e.g. to open a silence or remove a fill. Notes starting in a range are removed.
local function command_delete_midi_notes(command)
  local in_range = skip_ranges({ skip = command.ranges })
  local report = {}
  for t = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, t)
    local _, name = reaper.GetTrackName(track)
    if track_matches(name, command) then
      local removed = 0
      for i = 0, reaper.CountTrackMediaItems(track) - 1 do
        local take = reaper.GetActiveTake(reaper.GetTrackMediaItem(track, i))
        if take and reaper.TakeIsMIDI(take) then
          local _, count = reaper.MIDI_CountEvts(take)
          for n = count - 1, 0, -1 do
            local _, _, _, sppq, _, _, pitch, vel = reaper.MIDI_GetNote(take, n)
            local qn = reaper.MIDI_GetProjQNFromPPQPos(take, sppq)
            if in_range(qn) and (not command.min_vel or vel >= command.min_vel) and (not command.max_vel or vel <= command.max_vel)
              and (not command.pitch or pitch == command.pitch) then
              reaper.MIDI_DeleteNote(take, n)
              removed = removed + 1
            end
          end
          reaper.MIDI_Sort(take)
        end
      end
      if removed > 0 then report[#report + 1] = { track = name, removed = removed } end
    end
  end
  reaper.UpdateArrange()
  return { tracks = report }
end

-- Move notes of one pitch class by some semitones inside bar ranges, e.g. to turn a minor third major:
-- { tracks | contains, ranges = { {from_bar, to_bar}, ... }, pitch_class = 0..11, semitones }.
local function command_shift_pitch(command)
  local in_range = skip_ranges({ skip = command.ranges })
  local pc = tonumber(command.pitch_class)
  local semis = tonumber(command.semitones) or 0
  local report = {}
  for t = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, t)
    local _, name = reaper.GetTrackName(track)
    if track_matches(name, command) then
      local moved = 0
      for i = 0, reaper.CountTrackMediaItems(track) - 1 do
        local take = reaper.GetActiveTake(reaper.GetTrackMediaItem(track, i))
        if take and reaper.TakeIsMIDI(take) then
          local _, count = reaper.MIDI_CountEvts(take)
          for n = 0, count - 1 do
            local _, _, _, sppq, _, _, pitch = reaper.MIDI_GetNote(take, n)
            if pitch % 12 == pc and in_range(reaper.MIDI_GetProjQNFromPPQPos(take, sppq)) then
              reaper.MIDI_SetNote(take, n, nil, nil, nil, nil, nil, pitch + semis, nil, true)
              moved = moved + 1
            end
          end
          reaper.MIDI_Sort(take)
        end
      end
      if moved > 0 then report[#report + 1] = { track = name, moved = moved } end
    end
  end
  reaper.UpdateArrange()
  return { tracks = report }
end

-- MIDI CC shapes as REAPER names them: square steps, linear ramps or curves between points.
local CC_SHAPES = { square = 0, linear = 1, slow = 2, fast_start = 3, fast_end = 4, bezier = 5 }

-- Set the curve shape of existing CC events: { tracks | contains, cc (number, all when omitted),
--   shape = "linear" | "slow" | ..., ranges (optional, 1-based fractional bars) }.
local function command_set_cc_shape(command)
  local shape = CC_SHAPES[command.shape or "linear"]
  if not shape then error("unknown cc shape: " .. tostring(command.shape)) end
  local in_range = command.ranges and skip_ranges({ skip = command.ranges }) or function() return true end
  local report = {}
  for t = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, t)
    local _, name = reaper.GetTrackName(track)
    if track_matches(name, command) then
      local changed = 0
      for i = 0, reaper.CountTrackMediaItems(track) - 1 do
        local take = reaper.GetActiveTake(reaper.GetTrackMediaItem(track, i))
        if take and reaper.TakeIsMIDI(take) then
          local _, _, ccs = reaper.MIDI_CountEvts(take)
          for c = 0, ccs - 1 do
            local _, _, _, ppq, chanmsg, _, msg2 = reaper.MIDI_GetCC(take, c)
            if chanmsg == 0xB0 and (not command.cc or msg2 == command.cc) and in_range(reaper.MIDI_GetProjQNFromPPQPos(take, ppq)) then
              reaper.MIDI_SetCCShape(take, c, shape, 0, true)
              changed = changed + 1
            end
          end
          reaper.MIDI_Sort(take)
        end
      end
      if changed > 0 then report[#report + 1] = { track = name, changed = changed } end
    end
  end
  reaper.UpdateArrange()
  return { shape = command.shape or "linear", tracks = report }
end

-- Change note velocities inside bar ranges: { tracks | contains, ranges, delta } or a ramp across each range
-- { from_delta, to_delta } (e.g. to soften an entrance and let it grow back). Clamped to 1..127.
local function command_adjust_velocity(command)
  local report = {}
  local ranges = {}
  for _, r in ipairs(command.ranges or {}) do
    local function qn_of(bar) return bar_qn(bar) end
    ranges[#ranges + 1] = { qn_of(r[1]), qn_of(r[2]) }
  end
  local from_delta = tonumber(command.from_delta or command.delta) or 0
  local to_delta = tonumber(command.to_delta or command.delta) or from_delta
  for t = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, t)
    local _, name = reaper.GetTrackName(track)
    if track_matches(name, command) then
      local changed = 0
      for i = 0, reaper.CountTrackMediaItems(track) - 1 do
        local take = reaper.GetActiveTake(reaper.GetTrackMediaItem(track, i))
        if take and reaper.TakeIsMIDI(take) then
          local _, count = reaper.MIDI_CountEvts(take)
          for n = 0, count - 1 do
            local _, _, _, sppq, _, _, _, vel = reaper.MIDI_GetNote(take, n)
            local qn = reaper.MIDI_GetProjQNFromPPQPos(take, sppq)
            for _, r in ipairs(ranges) do
              if qn >= r[1] - 1e-6 and qn < r[2] - 1e-6 then
                local f = (qn - r[1]) / math.max(1e-6, r[2] - r[1])
                local delta = from_delta + (to_delta - from_delta) * f
                local new_vel = math.max(1, math.min(127, math.floor(vel + delta + 0.5)))
                reaper.MIDI_SetNote(take, n, nil, nil, nil, nil, nil, nil, new_vel, true)
                changed = changed + 1
                break
              end
            end
          end
          reaper.MIDI_Sort(take)
        end
      end
      if changed > 0 then report[#report + 1] = { track = name, changed = changed } end
    end
  end
  reaper.UpdateArrange()
  return { tracks = report }
end

-- Write automation: { track, fx (index) | fx_match, param (name) -- or send_dest (send volume, values in dB) --,
--   points = { {bar, value, shape}, ... } (1-based fractional bars; FX values normalized 0..1; shape: 0 linear, 1 square) }.
-- Points already in the covered span are replaced.
local function command_write_envelope(command)
  local track = find_track(command.track)
  if not track then error("track not found: " .. tostring(command.track)) end
  local env, to_value
  if command.send_dest then
    for s = 0, reaper.GetTrackNumSends(track, 0) - 1 do
      local _, dest_name = reaper.GetTrackName(reaper.GetTrackSendInfo_Value(track, 0, s, "P_DESTTRACK"))
      if dest_name == command.send_dest then env = reaper.GetTrackSendInfo_Value(track, 0, s, "P_ENV:<VOLENV") end
    end
    if not env then error("send not found: " .. tostring(command.send_dest)) end
    local mode = reaper.GetEnvelopeScalingMode(env)
    to_value = function(db) return reaper.ScaleToEnvelopeMode(mode, db_to_gain(db)) end
  else
    local fx = tonumber(command.fx)
    if not fx and command.fx_match then
      for i = 0, reaper.TrackFX_GetCount(track) - 1 do
        local _, fx_name = reaper.TrackFX_GetFXName(track, i, "")
        if fx_name:lower():find(command.fx_match:lower(), 1, true) then fx = i break end
      end
    end
    if not fx then error("fx not found on " .. tostring(command.track)) end
    local param
    for p = 0, reaper.TrackFX_GetNumParams(track, fx) - 1 do
      local _, pname = reaper.TrackFX_GetParamName(track, fx, p, "")
      if pname == command.param then param = p break end
    end
    if not param then error("param not found: " .. tostring(command.param)) end
    env = reaper.GetFXEnvelope(track, fx, param, true)
    local _, minv, maxv = reaper.TrackFX_GetParam(track, fx, param)
    to_value = function(norm) return minv + norm * (maxv - minv) end
  end
  if not env then error("could not get envelope") end
  local points = command.points or {}
  if #points == 0 then return { points = 0 } end
  local function time_of(bar)
    local whole = math.floor(bar)
    local _, qn_start, qn_end = reaper.TimeMap_GetMeasureInfo(0, whole - 1)
    return reaper.TimeMap2_QNToTime(0, qn_start + (bar - whole) * (qn_end - qn_start))
  end
  local t0, t1 = time_of(points[1][1]), time_of(points[#points][1])
  reaper.DeleteEnvelopePointRange(env, t0 - 0.0005, t1 + 0.0005)
  for _, p in ipairs(points) do
    reaper.InsertEnvelopePoint(env, time_of(p[1]), to_value(p[2]), tonumber(p[3]) or 0, 0, false, true)
  end
  reaper.Envelope_SortPoints(env)
  -- an envelope created through the API can stay inactive/hidden: switch it on so it plays and shows
  local _, chunk = reaper.GetEnvelopeStateChunk(env, "", false)
  local fixed = chunk:gsub("\nACT 0", "\nACT 1"):gsub("\nVIS 0", "\nVIS 1")
  if fixed ~= chunk then reaper.SetEnvelopeStateChunk(env, fixed, false) end
  local _, final = reaper.GetEnvelopeStateChunk(env, "", false)
  reaper.UpdateArrange()
  return { track = command.track, points = #points, total = reaper.CountEnvelopePoints(env),
    active = final:find("\nACT 1") ~= nil, visible = final:find("\nVIS 1") ~= nil }
end

-- Open a project file in a new tab (or in the current tab when it is empty and unsaved): { path }
local function command_open_project(command)
  local path = tostring(command.path or "")
  local file = io.open(path, "rb")
  if not file then error("project file not found: " .. path) end
  file:close()
  local _, current = reaper.EnumProjects(-1, "")
  if reaper.CountTracks(0) > 0 or (current and current ~= "") then
    reaper.Main_OnCommand(40859, 0) -- New project tab
  end
  reaper.Main_openProject("noprompt:" .. path)
  local _, opened = reaper.EnumProjects(-1, "")
  return { path = opened, tracks = reaper.CountTracks(0) }
end

-- Save the current project, optionally to a new path ("Save as" without a dialog): { path }.
local function command_save_project(command)
  local path = command.path and tostring(command.path) or nil
  if path and path ~= "" then
    local dir = path:match("^(.*)[/\\][^/\\]+$")
    if dir then reaper.RecursiveCreateDirectory(dir, 0) end
    reaper.Main_SaveProjectEx(0, path, 0)
  else
    reaper.Main_SaveProject(0, false)
  end
  local _, saved = reaper.EnumProjects(-1, "")
  return { path = saved }
end

-- Lock one part to another's real timing (a bass to the kick): { tracks | contains (followers), to (guide track),
--   window_ms (default 45), offset_ms (lag behind the guide, default 0) }.
-- Follower notes within the window of a guide note start exactly on it (+ offset); the rest take the shift of
-- the nearest locked note, so they ride the same drift. 'skip' ranges (see skip_ranges) stay where they are. Ornaments (keyswitches, grace notes) follow their main note.
local function command_lock_midi(command)
  local guide = find_track(command.to)
  if not guide then error("guide track not found: " .. tostring(command.to)) end
  local window = (tonumber(command.window_ms) or 45) / 1000
  local offset = (tonumber(command.offset_ms) or 0) / 1000
  local skipped = skip_ranges(command)
  local hits = {}
  for i = 0, reaper.CountTrackMediaItems(guide) - 1 do
    local take = reaper.GetActiveTake(reaper.GetTrackMediaItem(guide, i))
    if take and reaper.TakeIsMIDI(take) then
      local _, notes = reaper.MIDI_CountEvts(take)
      for n = 0, notes - 1 do
        local _, _, _, sppq = reaper.MIDI_GetNote(take, n)
        hits[#hits + 1] = reaper.MIDI_GetProjTimeFromPPQPos(take, sppq)
      end
    end
  end
  table.sort(hits)
  local function nearest_hit(time)
    local best
    for _, h in ipairs(hits) do
      if math.abs(h - time) <= window and (not best or math.abs(h - time) < math.abs(best - time)) then best = h end
      if h > time + window then break end
    end
    return best
  end
  local report = {}
  for t = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, t)
    local _, name = reaper.GetTrackName(track)
    if track ~= guide and track_matches(name, command) then
      local locked, followed = 0, 0
      for i = 0, reaper.CountTrackMediaItems(track) - 1 do
        local take = reaper.GetActiveTake(reaper.GetTrackMediaItem(track, i))
        if take and reaper.TakeIsMIDI(take) then
          local _, count = reaper.MIDI_CountEvts(take)
          local notes, starts = {}, {}
          for n = 0, count - 1 do
            local _, _, _, sppq, eppq = reaper.MIDI_GetNote(take, n)
            local note = { index = n, sppq = sppq, eppq = eppq,
              time = reaper.MIDI_GetProjTimeFromPPQPos(take, sppq), time_end = reaper.MIDI_GetProjTimeFromPPQPos(take, eppq) }
            notes[#notes + 1] = note
            starts[#starts + 1] = note.time
          end
          for _, note in ipairs(notes) do
            note.anchor = note.time
            if note.time_end - note.time < 0.06 then
              for _, other in ipairs(starts) do
                if other > note.time + 0.0005 and math.abs(other - note.time_end) < 0.008 then note.anchor = note.time_end break end
              end
            end
            note.skip = skipped(reaper.TimeMap2_timeToQN(0, note.anchor))
            local hit = not note.skip and nearest_hit(note.anchor)
            if hit then note.shift = hit + offset - note.anchor end
          end
          for _, note in ipairs(notes) do
            if note.skip then
              note.follow = 0
            elseif not note.shift then
              local best
              for _, other in ipairs(notes) do
                if other.shift ~= nil and other.anchor ~= note.anchor and (not best or math.abs(other.anchor - note.anchor) < math.abs(best.anchor - note.anchor)) then best = other end
              end
              note.follow = best and best.shift or 0
            end
          end
          for _, note in ipairs(notes) do
            local shift = note.shift or note.follow
            if note.shift then locked = locked + 1 elseif not note.skip then followed = followed + 1 end
            local new_start = reaper.MIDI_GetPPQPosFromProjTime(take, note.time + shift)
            reaper.MIDI_SetNote(take, note.index, nil, nil, new_start, note.eppq + (new_start - note.sppq), nil, nil, nil, true)
          end
          reaper.MIDI_Sort(take)
        end
      end
      report[#report + 1] = { track = name, locked = locked, followed = followed }
    end
  end
  reaper.UpdateArrange()
  return { to = command.to, guide_hits = #hits, tracks = report }
end

-- Set every tempo marker to one bpm (no ramps), e.g. to drop a ritardando: { bpm }
local function command_flatten_tempo(command)
  local bpm = tonumber(command.bpm)
  if not bpm then error("flatten_tempo needs a bpm") end
  local count = reaper.CountTempoTimeSigMarkers(0)
  for i = 0, count - 1 do
    local _, timepos, measurepos, beatpos, _, num, denom = reaper.GetTempoTimeSigMarker(0, i)
    reaper.SetTempoTimeSigMarker(0, i, timepos, measurepos, beatpos, bpm, num, denom, false)
  end
  reaper.UpdateTimeline()
  return { markers = count, bpm = bpm }
end

-- Set FX offline/online by name match: { track, fx_match, offline = true|false }. An offline plugin is not
-- instantiated, so a heavy or unstable plugin can be brought back one at a time.
local function command_fx_offline(command)
  local track = find_track(command.track)
  if not track then error("track not found: " .. tostring(command.track)) end
  local changed = {}
  for fx = 0, reaper.TrackFX_GetCount(track) - 1 do
    local _, fx_name = reaper.TrackFX_GetFXName(track, fx, "")
    if fx_name:lower():find(tostring(command.fx_match or ""):lower(), 1, true) then
      reaper.TrackFX_SetOffline(track, fx, command.offline ~= false)
      reaper.TrackFX_Show(track, fx, 2)
      changed[#changed + 1] = { fx = fx_name, offline = reaper.TrackFX_GetOffline(track, fx) }
    end
  end
  return { track = command.track, changed = changed }
end

-- Add FX (same specs as build_beat, samplers included) to an existing track: { track, fx = {...} }
local function command_add_track_fx(command)
  local track = find_track(command.track)
  if not track then error("track not found: " .. tostring(command.track)) end
  local added = {}
  for _, fx in ipairs(command.fx or {}) do added[#added + 1] = add_fx(track, fx) end
  local sends = {}
  for _, send in ipairs(command.sends or {}) do
    local dest = find_track(send.dest)
    if not dest then error("send destination not found: " .. tostring(send.dest)) end
    local send_index = reaper.CreateTrackSend(track, dest)
    reaper.SetTrackSendInfo_Value(track, 0, send_index, "D_VOL", db_to_gain(send.db or 0))
    sends[#sends + 1] = { dest = send.dest, db = send.db or 0 }
  end
  return { track = command.track, fx = added, sends = sends, count = reaper.TrackFX_GetCount(track) }
end

-- Open or close an FX as a floating window, e.g. to load a patch by hand: { track, fx (index, default 0), show = true }
local function command_show_fx(command)
  local track = find_track(command.track)
  if not track then error("track not found: " .. tostring(command.track)) end
  local fx = tonumber(command.fx) or 0
  reaper.TrackFX_Show(track, fx, command.show == false and 2 or 3)
  local _, fx_name = reaper.TrackFX_GetFXName(track, fx, "")
  return { track = command.track, fx = fx_name, open = command.show ~= false }
end

-- Point an existing RS5k at another file slice: { track, fx (index), file, start, len }
local function command_set_sampler(command)
  local track = find_track(command.track)
  if not track then error("track not found: " .. tostring(command.track)) end
  local fx = tonumber(command.fx) or 0
  local source = reaper.PCM_Source_CreateFromFile(command.file)
  local source_length = source and reaper.GetMediaSourceLength(source) or 0
  if source then reaper.PCM_Source_Destroy(source) end
  if source_length <= 0 then error("could not open sampler file: " .. tostring(command.file)) end

  reaper.TrackFX_SetNamedConfigParm(track, fx, "FILE0", command.file)
  reaper.TrackFX_SetNamedConfigParm(track, fx, "DONE", "")
  local start = tonumber(command.start) or 0
  local stop = command.len and math.min(source_length, start + command.len) or source_length
  local report = {}
  apply_fx_params(track, fx, {
    ["Sample start offset"] = start / source_length,
    ["Sample end offset"] = stop / source_length
  }, report)
  local _, fx_name = reaper.TrackFX_GetFXName(track, fx, "")
  return { track = command.track, fx = fx_name, slice = { start, stop } }
end

function M.register(registry)
  registry.command("build_beat", command_build_beat)
  -- { track, fx (index, default 0), name }: save that FX's full state as a recallable patch
  registry.command("capture_patch", function(command)
    local track = find_track(command.track)
    if not track then error("track not found: " .. tostring(command.track)) end
    return capture_patch(track, tonumber(command.fx) or 0, command.name)
  end, { read_only = true })
  -- { track, name, replace }: load a saved patch onto a track (replace removes its FX first)
  registry.command("load_patch", function(command)
    local track = find_track(command.track)
    if not track then error("track not found: " .. tostring(command.track)) end
    if command.replace then
      for fx = reaper.TrackFX_GetCount(track) - 1, 0, -1 do reaper.TrackFX_Delete(track, fx) end
    end
    return load_patch(track, command.name)
  end)
  -- { groups = { {name, color, tracks = {...contiguous names...}} } }: put each group under a new EMPTY
  -- folder track. Children send their MIDI to the parent too, so a folder must never host an instrument.
  registry.command("regroup_folders", function(command)
    local done = {}
    for _, name in ipairs(command.flat or {}) do
      local track = find_track(name)
      if track then reaper.SetMediaTrackInfo_Value(track, "I_FOLDERDEPTH", 0) end
    end
    for _, group in ipairs(command.groups or {}) do
      local first, last
      for _, name in ipairs(group.tracks) do
        local track = find_track(name)
        if not track then error("track not found: " .. tostring(name)) end
        reaper.SetMediaTrackInfo_Value(track, "I_FOLDERDEPTH", 0)
        local index = math.floor(reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER")) - 1
        first = first and math.min(first, index) or index
        last = last and math.max(last, index) or index
      end
      if last - first + 1 ~= #group.tracks then error("group tracks are not contiguous: " .. group.name) end
      reaper.InsertTrackAtIndex(first, false)
      local folder = reaper.GetTrack(0, first)
      reaper.GetSetMediaTrackInfo_String(folder, "P_NAME", group.name, true)
      local color = hex_color(group.color)
      if color then reaper.SetTrackColor(folder, color) end
      reaper.SetMediaTrackInfo_Value(folder, "I_FOLDERDEPTH", 1)
      reaper.SetMediaTrackInfo_Value(reaper.GetTrack(0, last + 1), "I_FOLDERDEPTH", -1)
      done[#done + 1] = { folder = group.name, children = #group.tracks }
    end
    reaper.TrackList_AdjustWindows(false)
    return { groups = done }
  end)
  -- { from_bar, to_bar, dir, name, tail_ms }: render the master mix of a bar range to <dir>\<name>.wav
  -- (24-bit default WAV) so it can be measured. The project's own render settings are restored afterwards.
  registry.command("render_audio", function(command)
    local num = { "RENDER_SETTINGS", "RENDER_BOUNDSFLAG", "RENDER_STARTPOS", "RENDER_ENDPOS", "RENDER_TAILFLAG",
      "RENDER_TAILMS", "RENDER_ADDTOPROJ", "RENDER_CHANNELS", "RENDER_SRATE" }
    local str = { "RENDER_FILE", "RENDER_PATTERN", "RENDER_FORMAT" }
    local saved_num, saved_str = {}, {}
    for _, key in ipairs(num) do saved_num[key] = reaper.GetSetProjectInfo(0, key, 0, false) end
    for _, key in ipairs(str) do local _, value = reaper.GetSetProjectInfo_String(0, key, "", false); saved_str[key] = value end

    local start = bar_time(tonumber(command.from_bar) or 1)
    local stop = bar_time(tonumber(command.to_bar) or 2)
    reaper.RecursiveCreateDirectory(command.dir, 0)
    -- stems: { "TRACK", ... } renders each listed track's output (pre-master, no sends) as <name>_<track>.wav
    local saved_selection = {}
    if command.stems then
      for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        saved_selection[track] = reaper.IsTrackSelected(track)
        reaper.SetTrackSelected(track, false)
      end
      for _, name in ipairs(command.stems) do
        local track = find_track(name)
        if not track then error("stem track not found: " .. tostring(name)) end
        reaper.SetTrackSelected(track, true)
      end
    end
    reaper.GetSetProjectInfo(0, "RENDER_SETTINGS", command.stems and 3 or 0, true)
    reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", 0, true)
    reaper.GetSetProjectInfo(0, "RENDER_STARTPOS", start, true)
    reaper.GetSetProjectInfo(0, "RENDER_ENDPOS", stop, true)
    reaper.GetSetProjectInfo(0, "RENDER_TAILFLAG", command.tail_ms and 0xFF or 0, true)
    reaper.GetSetProjectInfo(0, "RENDER_TAILMS", tonumber(command.tail_ms) or 0, true)
    reaper.GetSetProjectInfo(0, "RENDER_ADDTOPROJ", 0, true)
    reaper.GetSetProjectInfo(0, "RENDER_CHANNELS", 2, true)
    reaper.GetSetProjectInfo(0, "RENDER_SRATE", 48000, true)
    reaper.GetSetProjectInfo_String(0, "RENDER_FILE", command.dir, true)
    reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", (command.name or "render") .. (command.stems and "_$track" or ""), true)
    reaper.GetSetProjectInfo_String(0, "RENDER_FORMAT", "evaw", true)
    local clock = os.clock()
    reaper.Main_OnCommand(42230, 0) -- File: Render project, using the most recent render settings, auto-close

    for key, value in pairs(saved_num) do reaper.GetSetProjectInfo(0, key, value, true) end
    for key, value in pairs(saved_str) do reaper.GetSetProjectInfo_String(0, key, value, true) end
    if command.stems then
      for track, selected in pairs(saved_selection) do reaper.SetTrackSelected(track, selected) end
      local files, i = {}, 0
      while true do
        local file = reaper.EnumerateFiles(command.dir, i)
        if not file then break end
        if file:find((command.name or "render") .. "_", 1, true) == 1 then files[#files + 1] = file end
        i = i + 1
      end
      return { dir = command.dir, stems = files, seconds = stop - start, render_cpu = os.clock() - clock }
    end
    local file = command.dir .. "\\" .. (command.name or "render") .. ".wav"
    local handle = io.open(file, "rb")
    local size = handle and handle:seek("end") or 0
    if handle then handle:close() end
    if size == 0 then error("render produced no file: " .. file) end
    return { file = file, bytes = size, seconds = stop - start, render_cpu = os.clock() - clock }
  end, { bypass_undo = true })
  -- { tracks = { ["EXACT NAME"] = { pan = -1..1, volume_db, sends = { ["DEST"] = db } } } }: exact-name mix
  -- settings (pan is REAPER's balance for stereo tracks; -1 = left). Existing sends are updated, not duplicated.
  registry.command("set_track_mix", function(command)
    local report = {}
    for name, mix in pairs(command.tracks or {}) do
      local track = find_track(name)
      if not track then error("track not found: " .. tostring(name)) end
      if mix.pan then reaper.SetMediaTrackInfo_Value(track, "D_PAN", tonumber(mix.pan)) end
      if mix.volume_db then reaper.SetMediaTrackInfo_Value(track, "D_VOL", db_to_gain(mix.volume_db)) end
      for dest_name, db in pairs(mix.sends or {}) do
        local dest = find_track(dest_name)
        if not dest then error("send destination not found: " .. tostring(dest_name)) end
        local found
        for s = 0, reaper.GetTrackNumSends(track, 0) - 1 do
          if reaper.GetTrackSendInfo_Value(track, 0, s, "P_DESTTRACK") == dest then found = s end
        end
        found = found or reaper.CreateTrackSend(track, dest)
        reaper.SetTrackSendInfo_Value(track, 0, found, "D_VOL", db_to_gain(db))
      end
      report[#report + 1] = { track = name, pan = reaper.GetMediaTrackInfo_Value(track, "D_PAN"),
        volume_db = 20 * math.log(reaper.GetMediaTrackInfo_Value(track, "D_VOL"), 10) }
    end
    return { tracks = report }
  end)
  -- { action = "play" | "stop", bar }: transport, e.g. to audition or to test keyswitches
  registry.command("transport", function(command)
    if command.action == "stop" then reaper.OnStopButton()
    else
      if command.bar then reaper.SetEditCurPos(bar_time(tonumber(command.bar)), true, false) end
      reaper.OnPlayButton()
    end
    return { action = command.action or "play", position = reaper.GetPlayPosition() }
  end, { bypass_undo = true })
  registry.command("list_patches", function()
    local patches, i = {}, 0
    while true do
      local file = reaper.EnumerateFiles(patch_dir(), i)
      if not file then break end
      if file:match("%.RfxChain$") then patches[#patches + 1] = file:gsub("%.RfxChain$", "") end
      i = i + 1
    end
    table.sort(patches)
    return { dir = patch_dir(), patches = patches }
  end, { read_only = true })
  registry.command("set_sampler", command_set_sampler)
  registry.command("replace_midi", command_replace_midi)
  registry.command("add_midi", command_add_midi)
  registry.command("add_track_fx", command_add_track_fx)
  registry.command("fx_offline", command_fx_offline)
  registry.command("swing_midi", command_swing_midi, {
    read_only = function(command) return command.inspect == true end
  })
  registry.command("humanize_midi", command_humanize_midi)
  registry.command("lock_midi", command_lock_midi)
  registry.command("dump_midi", command_dump_midi, { read_only = true })
  registry.command("delete_midi_notes", command_delete_midi_notes)
  registry.command("shift_pitch", command_shift_pitch)
  registry.command("set_cc_shape", command_set_cc_shape)
  registry.command("show_fx", command_show_fx, { read_only = true })
  registry.command("adjust_velocity", command_adjust_velocity)
  registry.command("write_envelope", command_write_envelope)
  registry.command("open_project", command_open_project, { bypass_undo = true })
  registry.command("save_project", command_save_project, { bypass_undo = true })
  registry.command("flatten_tempo", command_flatten_tempo)
  registry.command("fx_params", command_fx_params, {
    read_only = function(command) return command.params == nil end
  })
end

return M
