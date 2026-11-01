-- Reaper Manager Tab Viewer: guitar tablature of a MIDI track, synced to the play cursor,
-- so the user can read the part while playing along.
-- Page mode (default): a still page of bars; when the cursor reaches the last bar of the
-- page, the page jumps so that bar comes first. Scroll mode: the tab runs continuously.
-- Standard tuning (E A D G B e). Frets are chosen per chord/note to keep the hand still.
-- Mouse wheel: bars per page (seconds in scroll mode) | click a tab: change track |
-- P: page/scroll | M: day/night | D: dock/undock | Esc: close.

local TITLE = "Reaper Manager - Tablatura"
local EXT = "ReaperManagerTabViewer"

local TUNING = { 64, 59, 55, 50, 45, 40 } -- string 1 (high e) .. string 6 (low E)
local STRING_NAMES = { "e", "B", "G", "D", "A", "E" }
local NOTE_NAMES = { "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B" }
local MAX_FRET = 22
local MAX_SPAN = 4
local KS_SUSTAIN, KS_PALM_MUTE = 24, 26 -- Ample Guitar articulation keyswitches (C0, D0)

local THEMES = {
  night = {
    bg = { 0.11, 0.11, 0.13 },
    line = { 0.42, 0.42, 0.46 },
    bar = { 0.36, 0.36, 0.40 },
    beat = { 0.19, 0.19, 0.22 },
    text = { 0.94, 0.94, 0.94 },
    dim = { 0.45, 0.45, 0.48 },
    active = { 1.0, 0.62, 0.15 },
    sustain = { 0.35, 0.55, 0.85 },
    playhead = { 1.0, 0.3, 0.25 },
    marker = { 0.55, 0.85, 0.55 },
    chord = { 0.95, 0.85, 0.45 },
    tab_on = { 0.25, 0.42, 0.65 },
    tab_off = { 0.2, 0.2, 0.24 },
    tab_text = { 0.94, 0.94, 0.94 }
  },
  day = {
    bg = { 1.0, 1.0, 1.0 },
    line = { 0.55, 0.55, 0.58 },
    bar = { 0.25, 0.25, 0.28 },
    beat = { 0.88, 0.88, 0.90 },
    text = { 0.05, 0.05, 0.07 },
    dim = { 0.68, 0.68, 0.70 },
    active = { 0.88, 0.38, 0.0 },
    sustain = { 0.30, 0.50, 0.85 },
    playhead = { 0.90, 0.12, 0.10 },
    marker = { 0.10, 0.50, 0.20 },
    chord = { 0.55, 0.38, 0.0 },
    tab_on = { 0.25, 0.45, 0.78 },
    tab_off = { 0.88, 0.88, 0.90 },
    tab_text = { 0.1, 0.1, 0.12 }
  }
}

local state = {
  track_guid = reaper.GetExtState(EXT, "track_guid"),
  seconds_ahead = tonumber(reaper.GetExtState(EXT, "seconds_ahead")) or 4,
  bars_per_page = tonumber(reaper.GetExtState(EXT, "bars_per_page")) or 4,
  page_mode = reaper.GetExtState(EXT, "page_mode") ~= "0",
  theme = reaper.GetExtState(EXT, "theme") == "day" and "day" or "night",
  page_start = nil,
  buttons = {},
  change_count = -1,
  groups = {},
  tracks = {},
  tab_hitboxes = {},
  last_mouse = 0
}

local COLORS = THEMES[state.theme]

local function set_color(c, a) gfx.set(c[1], c[2], c[3], a or 1) end

local function track_guid(track) return reaper.GetTrackGUID(track) end

local function track_has_midi(track)
  for i = 0, reaper.CountTrackMediaItems(track) - 1 do
    local take = reaper.GetActiveTake(reaper.GetTrackMediaItem(track, i))
    if take and reaper.TakeIsMIDI(take) then return true end
  end
  return false
end

-- Guitar-named MIDI tracks first; any MIDI track when none is named like a guitar.
local function list_tracks()
  local guitars, others = {}, {}
  for i = 0, reaper.CountTracks(0) - 1 do
    local track = reaper.GetTrack(0, i)
    if track_has_midi(track) then
      local _, name = reaper.GetTrackName(track)
      local entry = { track = track, name = name, guid = track_guid(track) }
      local upper = name:upper()
      if upper:find("GTR") or upper:find("GUIT") or upper:find("TAB") then
        guitars[#guitars + 1] = entry
      else
        others[#others + 1] = entry
      end
    end
  end
  return #guitars > 0 and guitars or others
end

local function current_track()
  for _, entry in ipairs(state.tracks) do
    if entry.guid == state.track_guid then return entry end
  end
  local first = state.tracks[1]
  if first then state.track_guid = first.guid end
  return first
end

local function beats_at(time)
  local _, _, _, fullbeats = reaper.TimeMap2_timeToBeats(0, time)
  return fullbeats
end

-- start and end of a measure (0-based) in quarter notes
local function measure_bounds(measure)
  local _, qn_start, qn_end = reaper.TimeMap_GetMeasureInfo(0, measure)
  return qn_start, qn_end
end

local function snap_position(pos)
  local s16 = math.floor(pos * 4 + 0.5) / 4
  local s12 = math.floor(pos * 3 + 0.5) / 3
  if math.abs(pos - s12) + 0.02 < math.abs(pos - s16) then return s12, true end
  return s16, false
end

-- standard note values in quarter notes, longest first
local VALUES = { 4, 3, 2, 1.5, 1, 0.75, 0.5, 0.375, 0.25 }
local DOTTED = { [3] = true, [1.5] = true, [0.75] = true, [0.375] = true }

local function note_value(qn, triplet)
  if triplet then return qn >= 0.5 and 2 / 3 or 1 / 3 end
  for _, value in ipairs(VALUES) do
    if value <= qn + 0.001 then return value end
  end
  return 0.25
end

-- Picks a string per note (higher notes on higher strings), keeping the fretted notes
-- within MAX_SPAN frets and as close as possible to the current hand position.
local function fret_group(pitches, hand)
  local best, best_cost
  local choice = {}
  local function score()
    local min_f, max_f, fretted = 99, -1, 0
    for _, c in ipairs(choice) do
      if c.fret > 0 then
        fretted = fretted + 1
        if c.fret < min_f then min_f = c.fret end
        if c.fret > max_f then max_f = c.fret end
      end
    end
    if fretted == 0 then return 0.5, hand end
    local span = max_f - min_f
    if span > MAX_SPAN then return nil end
    local center = (min_f + max_f) / 2
    local cost = math.abs(center - hand) + span * 0.8
    -- chords as a guitarist grabs them: adjacent strings, root on the 6th/5th string,
    -- no open string ringing above a fretted note (G5 = 3-5-5, not 3 + open D)
    if #choice >= 2 then
      local lowest_fretted = false
      for k, c in ipairs(choice) do
        if k > 1 then cost = cost + (choice[k - 1].string - c.string - 1) * 4 end
        if c.fret == 0 and lowest_fretted then cost = cost + 3 end
        if c.fret > 0 then lowest_fretted = true end
      end
      if choice[1].string <= 4 then cost = cost + 8 end
    end
    if max_f > 15 then cost = cost + (max_f - 15) * 0.6 end
    return cost, center
  end
  local function search(index, max_string)
    if index > #pitches then
      local cost, center = score()
      if cost and (not best_cost or cost < best_cost) then
        best_cost = cost
        best = { center = center }
        for k, c in ipairs(choice) do best[k] = { string = c.string, fret = c.fret } end
      end
      return
    end
    -- lowest note gets the lowest string; each following note a higher (smaller index) string
    for s = max_string, 1, -1 do
      local fret = pitches[index] - TUNING[s]
      if fret >= 0 and fret <= MAX_FRET then
        choice[index] = { string = s, fret = fret }
        search(index + 1, s - 1)
        choice[index] = nil
      end
    end
  end
  search(1, 6)
  if not best then return nil, hand end
  return best, hand * 0.5 + best.center * 0.5
end

local function chord_name(pitches)
  if #pitches < 2 then return nil end
  local root = pitches[1]
  local has_fifth = false
  for i = 2, #pitches do
    local interval = (pitches[i] - root) % 12
    if interval == 7 then has_fifth = true elseif interval ~= 0 then return nil end
  end
  if not has_fifth then return nil end
  return NOTE_NAMES[root % 12 + 1] .. "5"
end

local function rebuild(entry)
  local notes, switches = {}, {}
  if entry then
    local track = entry.track
    for i = 0, reaper.CountTrackMediaItems(track) - 1 do
      local item = reaper.GetTrackMediaItem(track, i)
      local take = reaper.GetActiveTake(item)
      if take and reaper.TakeIsMIDI(take) and reaper.GetMediaItemInfo_Value(item, "B_MUTE") == 0 then
        local item_start = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        local item_end = item_start + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        local _, note_count = reaper.MIDI_CountEvts(take)
        for n = 0, note_count - 1 do
          local _, _, muted, start_ppq, end_ppq, _, pitch = reaper.MIDI_GetNote(take, n)
          -- notes below C2 are articulation keyswitches (Ample Guitar C0/D0...), not played notes
          if not muted and pitch < 36 then
            if pitch == KS_SUSTAIN or pitch == KS_PALM_MUTE then
              switches[#switches + 1] = { t = reaper.MIDI_GetProjTimeFromPPQPos(take, start_ppq), mute = pitch == KS_PALM_MUTE }
            end
          elseif not muted then
            local t0 = reaper.MIDI_GetProjTimeFromPPQPos(take, start_ppq)
            local t1 = reaper.MIDI_GetProjTimeFromPPQPos(take, end_ppq)
            if t0 >= item_start - 0.001 and t0 < item_end then
              notes[#notes + 1] = { t0 = t0, t1 = math.min(t1, item_end), pitch = pitch }
            end
          end
        end
      end
    end
  end
  table.sort(notes, function(a, b) return a.t0 < b.t0 or (a.t0 == b.t0 and a.pitch < b.pitch) end)
  table.sort(switches, function(a, b) return a.t < b.t end)
  -- palm mute from the Ample keyswitches when the part has them, else guessed from length
  local switch_index, muting = 0, false
  local function muted_at(time)
    while switches[switch_index + 1] and switches[switch_index + 1].t <= time + 0.001 do
      switch_index = switch_index + 1
      muting = switches[switch_index].mute
    end
    return muting
  end

  -- a chord is a run of notes each starting within 25 ms of the previous one (a downstroke
  -- spreads the strings a few ms apart); a repeated pitch always starts a new chord
  local groups, i = {}, 1
  while i <= #notes do
    local group = { t0 = notes[i].t0, t1 = notes[i].t1, notes = {} }
    local seen, last_t = {}, notes[i].t0
    while i <= #notes and notes[i].t0 - last_t < 0.025 and not seen[notes[i].pitch] do
      seen[notes[i].pitch] = true
      last_t = notes[i].t0
      group.notes[#group.notes + 1] = notes[i]
      if notes[i].t1 > group.t1 then group.t1 = notes[i].t1 end
      i = i + 1
    end
    groups[#groups + 1] = group
  end

  local hand = entry and entry.name:upper():find("LEAD") and 7 or 3
  for _, group in ipairs(groups) do
    local pitches, seen = {}, {}
    for _, note in ipairs(group.notes) do
      if not seen[note.pitch] then seen[note.pitch] = true; pitches[#pitches + 1] = note.pitch end
    end
    table.sort(pitches)
    local frets
    frets, hand = fret_group(pitches, hand)
    group.frets = frets or {}
    group.unplayable = frets == nil
    group.chord = chord_name(pitches)
    if #switches > 0 then
      group.palm_mute = muted_at(group.t0)
    else
      group.palm_mute = #pitches <= 2 and (beats_at(group.t1) - beats_at(group.t0)) < 0.3
    end
    for k, note in ipairs(group.notes) do
      for p, pitch in ipairs(pitches) do
        if pitch == note.pitch and group.frets[p] then note.string, note.fret = group.frets[p].string, group.frets[p].fret end
      end
      note.index = k
    end
  end
  -- written rhythm: the (humanized) start snapped to the 16th grid, or to 8th triplets when
  -- clearly closer, as a position inside its measure
  for _, group in ipairs(groups) do
    local _, measure = reaper.TimeMap2_timeToBeats(0, group.t0)
    local qn_start, qn_end = measure_bounds(measure)
    local qn0 = reaper.TimeMap2_timeToQN(0, group.t0)
    local pos, triplet = snap_position(qn0 - qn_start)
    if pos >= qn_end - qn_start - 0.001 then
      measure, pos, triplet = measure + 1, 0, false
      qn_start, qn_end = measure_bounds(measure)
    end
    group.measure, group.pos, group.triplet, group.measure_len = measure, pos, triplet, qn_end - qn_start
    local sounding = reaper.TimeMap2_timeToQN(0, group.t1) - qn0
    group.len_qn = math.max(0.25, math.floor(sounding * 4 + 0.5) / 4)
  end
  -- note value: up to the next attack (a choked chug still reads as an 8th), or the sounding
  -- length when a real rest follows; beamed per beat like Guitar Pro
  local beam_id = 0
  for g, group in ipairs(groups) do
    local prev, next_group = groups[g - 1], groups[g + 1]
    local same_next = next_group and next_group.measure == group.measure
    local ioi = (same_next and next_group.pos or group.measure_len) - group.pos
    local raw = ioi <= group.len_qn + 0.26 and ioi or math.min(group.len_qn, ioi)
    group.value = note_value(raw, group.triplet)
    if group.triplet then
      group.flags = group.value < 0.5 and 1 or 0
    else
      group.flags = group.value < 0.5 - 0.001 and 2 or group.value < 1 - 0.001 and 1 or 0
    end
    group.dot = DOTTED[group.value] == true
    local joins = prev and prev.measure == group.measure and prev.flags > 0 and group.flags > 0
      and math.floor(prev.pos + 0.001) == math.floor(group.pos + 0.001)
      and math.abs(prev.pos + prev.value - group.pos) < 0.01
    if not joins then beam_id = beam_id + 1 end
    group.beam = group.flags > 0 and beam_id or nil
  end
  -- label a chord only when it changes; palm mutes as one "PM - - -" run
  for g, group in ipairs(groups) do
    local prev, next_group = groups[g - 1], groups[g + 1]
    group.show_chord = group.chord and (not prev or prev.chord ~= group.chord or group.t0 - prev.t1 > 0.5)
    group.pm_start = group.palm_mute and not (prev and prev.palm_mute)
    group.pm_continues = group.palm_mute and next_group and next_group.palm_mute
  end
  state.groups = groups
end

local function refresh()
  local count = reaper.GetProjectStateChangeCount(0)
  if count == state.change_count then return end
  state.change_count = count
  state.tracks = list_tracks()
  rebuild(current_track())
end

local function now_position()
  if reaper.GetPlayState() & 1 == 1 then return reaper.GetPlayPosition() end
  return reaper.GetCursorPosition()
end

local function draw_text(text, x, y, color, align_center)
  set_color(color)
  local w, h = gfx.measurestr(text)
  gfx.x = align_center and math.floor(x - w / 2) or math.floor(x)
  gfx.y = math.floor(y - h / 2)
  gfx.drawstr(text)
  return w, h
end

local HEADER_H = 32

local function toggle_theme()
  state.theme = state.theme == "day" and "night" or "day"
  COLORS = THEMES[state.theme]
  reaper.SetExtState(EXT, "theme", state.theme, true)
end

local function toggle_page_mode()
  state.page_mode = not state.page_mode
  state.page_start = nil
  reaper.SetExtState(EXT, "page_mode", state.page_mode and "1" or "0", true)
end

local function draw_button(label, x, on_click)
  local w = gfx.measurestr(label) + 18
  set_color(COLORS.tab_off)
  gfx.rect(x - w, 5, w, HEADER_H - 10, 1)
  draw_text(label, x - w + 9, HEADER_H / 2, COLORS.tab_text)
  state.buttons[#state.buttons + 1] = { x = x - w, w = w, action = on_click }
  return x - w - 6
end

local function draw_header()
  state.tab_hitboxes, state.buttons = {}, {}
  gfx.setfont(2)
  local x = 8
  for _, entry in ipairs(state.tracks) do
    local label = entry.name ~= "" and entry.name or "(sin nombre)"
    local w = gfx.measurestr(label) + 18
    local on = entry.guid == state.track_guid
    set_color(on and COLORS.tab_on or COLORS.tab_off)
    gfx.rect(x, 5, w, HEADER_H - 10, 1)
    draw_text(label, x + 9, HEADER_H / 2, on and { 1, 1, 1 } or COLORS.tab_text)
    state.tab_hitboxes[#state.tab_hitboxes + 1] = { x = x, w = w, guid = entry.guid }
    x = x + w + 6
  end
  if #state.tracks == 0 then draw_text("No hay pistas MIDI en el proyecto", 8, HEADER_H / 2, COLORS.dim) end
  local right = gfx.w - 8
  right = draw_button(state.theme == "day" and "Modo noche" or "Modo día", right, toggle_theme)
  right = draw_button(state.page_mode and "Scroll continuo" or "Por páginas", right, toggle_page_mode)
  local help = state.page_mode and "Rueda: compases por página" or "Rueda: zoom"
  draw_text(help, right - gfx.measurestr(help) - 6, HEADER_H / 2, COLORS.dim)
end

local function section_at(time)
  local name
  local _, markers, regions = reaper.CountProjectMarkers(0)
  for i = 0, markers + regions - 1 do
    local _, is_region, pos, _, marker_name = reaper.EnumProjectMarkers(i)
    if not is_region and pos <= time + 0.001 then name = marker_name end
  end
  return name
end

-- Page mode: keep the page still; when the cursor enters the last bar of the page (or
-- jumps outside it) the page restarts at the cursor's bar.
local function update_page(measure)
  local bpp = state.bars_per_page
  local start = state.page_start
  if not start or measure < start or measure >= start + bpp or (bpp > 1 and measure == start + bpp - 1) then
    state.page_start = measure
  end
end

-- Guitar Pro style spacing: every measure keeps a margin after its bar line and before the
-- next one, so a downbeat never sits on the bar line.
local PAD_LEFT, PAD_RIGHT = 30, 14
local PAD = PAD_LEFT + PAD_RIGHT

local function draw_rhythm(groups, g, x_of_group, y_top, color)
  local group = groups[g]
  local x = x_of_group(group)
  local y_bottom = y_top + 38
  if group.value >= 4 - 0.001 then return end
  set_color(color)
  local stem_top = group.value >= 2 - 0.001 and y_top + 19 or y_top
  gfx.rect(x - 1, stem_top, 2, y_bottom - stem_top, 1)
  if group.dot then gfx.rect(x + 6, y_bottom - 4, 4, 4, 1) end
  if group.flags == 0 then return end
  local prev, next_group = groups[g - 1], groups[g + 1]
  local beam_prev = prev and prev.beam == group.beam
  local beam_next = next_group and next_group.beam == group.beam
  if beam_next then
    local nx = x_of_group(next_group)
    gfx.rect(x - 1, y_bottom - 3, nx - x + 2, 4, 1)
    if group.flags == 2 and next_group.flags == 2 then gfx.rect(x - 1, y_bottom - 10, nx - x + 2, 4, 1) end
  end
  if group.flags == 2 and not (beam_next and next_group.flags == 2) and not (beam_prev and prev.flags == 2) then
    if beam_next then gfx.rect(x - 1, y_bottom - 10, 10, 4, 1)
    elseif beam_prev then gfx.rect(x - 9, y_bottom - 10, 10, 4, 1) end
  end
  if not beam_prev and not beam_next then -- lone 8th/16th: flags
    for f = 0, group.flags - 1 do
      gfx.line(x, y_bottom - f * 7, x + 10, y_bottom - f * 7 - 9)
      gfx.line(x + 1, y_bottom - f * 7, x + 11, y_bottom - f * 7 - 9)
    end
  end
  if group.triplet and not beam_prev then draw_text("3", x + (beam_next and 12 or 4), y_bottom + 12, color, true) end
end

local function draw()
  set_color(COLORS.bg)
  gfx.rect(0, 0, gfx.w, gfx.h, 1)
  draw_header()

  local now = now_position()
  local left = 44
  local right = gfx.w - 16
  local staff_top = 124
  local spacing = math.max(36, (gfx.h - 96 - staff_top) / 5)
  local function y_of(s) return staff_top + (s - 1) * spacing end
  local _, now_measure = reaper.TimeMap2_timeToBeats(0, now)
  local qn_now = reaper.TimeMap2_timeToQN(0, now)

  local bar_x, m_first, m_last, pxqn
  if state.page_mode then
    update_page(now_measure)
    local start = state.page_start
    local qn0 = measure_bounds(start)
    local qn1 = measure_bounds(start + state.bars_per_page)
    pxqn = (right - left - state.bars_per_page * PAD) / (qn1 - qn0)
    bar_x = function(m) return left + (measure_bounds(m) - qn0) * pxqn + (m - start) * PAD end
    m_first, m_last = start, start + state.bars_per_page - 1
  else
    local play_x = left + (gfx.w - left) * 0.18
    pxqn = (gfx.w - play_x) / (state.seconds_ahead * reaper.Master_GetTempo() / 60)
    bar_x = function(m) return play_x + (measure_bounds(m) - qn_now) * pxqn + (m - now_measure) * PAD - PAD_LEFT end
    m_first = math.max(0, now_measure - 3)
    m_last = now_measure
    while bar_x(m_last + 1) < gfx.w do m_last = m_last + 1 end
  end
  local function note_x(m, pos) return bar_x(m) + PAD_LEFT + pos * pxqn end
  local function x_of_group(group) return note_x(group.measure, group.pos) end

  -- strings
  for s = 1, 6 do
    set_color(COLORS.line)
    gfx.line(left, y_of(s), state.page_mode and bar_x(m_last + 1) or right, y_of(s))
    gfx.setfont(2)
    draw_text(STRING_NAMES[s], 14, y_of(s), COLORS.dim)
  end

  -- bar lines, numbers and section markers
  local section_by_measure = {}
  local _, markers, regions = reaper.CountProjectMarkers(0)
  for i = 0, markers + regions - 1 do
    local _, is_region, pos, _, name = reaper.EnumProjectMarkers(i)
    if not is_region then
      local _, m = reaper.TimeMap2_timeToBeats(0, pos + 0.001)
      section_by_measure[m] = name
    end
  end
  gfx.setfont(2)
  for m = m_first, m_last + 1 do
    local x = bar_x(m)
    set_color(COLORS.bar)
    gfx.rect(x, y_of(1), 2, y_of(6) - y_of(1), 1)
    if m <= m_last then
      draw_text(tostring(m + 1), x + 5, y_of(1) - 14, COLORS.dim)
      if section_by_measure[m] then draw_text(section_by_measure[m], x + 5, HEADER_H + 14, COLORS.marker) end
    end
  end

  -- notes
  local groups = state.groups
  local rhythm_top = y_of(6) + 18
  for g = 1, #groups do
    local group = groups[g]
    if group.measure >= m_first and group.measure <= m_last then
      local x = x_of_group(group)
      local active = group.t0 <= now + 0.01 and group.t1 > now
      local past = group.t1 <= now
      local color = active and COLORS.active or past and COLORS.dim or COLORS.text
      gfx.setfont(active and 3 or 1)
      for _, note in ipairs(group.notes) do
        if note.string then
          local label = tostring(note.fret)
          local w, h = gfx.measurestr(label)
          set_color(COLORS.bg)
          gfx.rect(x - w / 2 - 3, y_of(note.string) - h / 2 + 2, w + 6, h - 4, 1)
          draw_text(label, x, y_of(note.string), color, true)
        end
      end
      gfx.setfont(2)
      draw_rhythm(groups, g, x_of_group, rhythm_top, past and COLORS.dim or COLORS.text)
      local tag = group.unplayable and "?" or group.show_chord and group.chord
      if tag then draw_text(tag, x, HEADER_H + 40, past and COLORS.dim or COLORS.chord, true) end
      if group.palm_mute then
        local pm_color = past and COLORS.dim or COLORS.text
        local pm_y = HEADER_H + 64
        if group.pm_start then draw_text("PM", x, pm_y, pm_color, true) end
        local next_group = groups[g + 1]
        if group.pm_continues and next_group.measure <= m_last then
          set_color(pm_color, 0.7)
          local x1, x2 = x + (group.pm_start and 16 or 2), x_of_group(next_group) - 2
          for dash = x1, x2 - 3, 8 do gfx.line(dash, pm_y, math.min(dash + 4, x2), pm_y) end
        end
      end
    end
  end

  -- playhead: on the written position of the current beat, inside the measure margins
  local qn_start, qn_end = measure_bounds(now_measure)
  local play_x = note_x(now_measure, math.min(qn_now - qn_start, qn_end - qn_start))
  set_color(COLORS.playhead)
  gfx.rect(play_x - 1, HEADER_H + 2, 3, rhythm_top + 40 - HEADER_H, 1)

  local beat_in_bar = reaper.TimeMap2_timeToBeats(0, now)
  local info = string.format("Compás %d.%d", now_measure + 1, math.floor(beat_in_bar) + 1)
  local section = section_at(now)
  if section then info = section .. "   " .. info end
  gfx.setfont(2)
  draw_text(info, gfx.w - gfx.measurestr(info) - 12, gfx.h - 16, COLORS.text)
end

local function handle_input()
  local char = gfx.getchar()
  if char < 0 or char == 27 then return false end
  if char == 100 or char == 68 then -- d / D
    local dock = gfx.dock(-1)
    gfx.dock(dock & 1 == 1 and 0 or 1)
    reaper.SetExtState(EXT, "dock", tostring(gfx.dock(-1)), true)
  elseif char == 109 or char == 77 then -- m / M
    toggle_theme()
  elseif char == 112 or char == 80 then -- p / P
    toggle_page_mode()
  end
  if gfx.mouse_wheel ~= 0 then
    if state.page_mode then
      local step = gfx.mouse_wheel > 0 and -1 or 1
      state.bars_per_page = math.max(2, math.min(8, state.bars_per_page + step))
      state.page_start = nil
      reaper.SetExtState(EXT, "bars_per_page", tostring(state.bars_per_page), true)
    else
      local factor = gfx.mouse_wheel > 0 and 0.85 or 1 / 0.85
      state.seconds_ahead = math.max(1.5, math.min(16, state.seconds_ahead * factor))
      reaper.SetExtState(EXT, "seconds_ahead", tostring(state.seconds_ahead), true)
    end
    gfx.mouse_wheel = 0
  end
  local mouse = gfx.mouse_cap & 1
  if mouse == 1 and state.last_mouse == 0 and gfx.mouse_y <= HEADER_H then
    for _, box in ipairs(state.tab_hitboxes) do
      if gfx.mouse_x >= box.x and gfx.mouse_x <= box.x + box.w then
        state.track_guid = box.guid
        reaper.SetExtState(EXT, "track_guid", box.guid, true)
        state.change_count = -1
      end
    end
    for _, button in ipairs(state.buttons) do
      if gfx.mouse_x >= button.x and gfx.mouse_x <= button.x + button.w then button.action() end
    end
  end
  state.last_mouse = mouse
  return true
end

local function loop()
  if not handle_input() then
    gfx.quit()
    return
  end
  refresh()
  draw()
  gfx.update()
  reaper.defer(loop)
end

gfx.init(TITLE, 1300, 560, tonumber(reaper.GetExtState(EXT, "dock")) or 0)
gfx.setfont(1, "Consolas", 36, string.byte("b"))
gfx.setfont(2, "Segoe UI", 17)
gfx.setfont(3, "Consolas", 44, string.byte("b"))
gfx.setfont(1)
reaper.defer(loop)
