# Reaper Manager Agent Instructions

## Fast Path For New Chats

If the user asks for a REAPER action, do not start with broad repo exploration. Do this:

1. Run `node .\bin\reaper-manager.js status`.
2. If `heartbeat.bridge` is `running` and the request is clear, execute the matching CLI command immediately.
3. If the bridge is stopped or missing, ask the user to press the `Reaper Manager` toolbar button in REAPER. Do not reinstall unless the user asks for install/repair or the installed bridge is clearly outdated.
4. For simple requests, use one primitive command. For compound requests, use several primitive commands so REAPER undo stays granular.
5. Only inspect source files when adding/changing capabilities, debugging a failure, or when no existing command can satisfy the request. Only inspect `.reaper-manager\queue` after a timeout or suspected stale command.
6. Work on the active REAPER project/tab reported by `status`; do not try to switch tabs unless the user explicitly asks.
7. Reply in Spanish, concise and operational. Summarize what changed and how many tracks/items/sends were affected.

Common direct mappings:

```powershell
node .\bin\reaper-manager.js color --contains orden --color "#d8b4fe"
node .\bin\reaper-manager.js volume --selected --db -3
node .\bin\reaper-manager.js pan --contains GTR --pan L50
node .\bin\reaper-manager.js send-volume --selected --dest Reverb --db 2
node .\bin\reaper-manager.js item-volume --selected --db -3
node .\bin\reaper-manager.js gain-stage --all-items
node .\bin\reaper-manager.js vocal-level --selected-items --preview
node .\bin\reaper-manager.js vocal-level --selected-items
node .\bin\reaper-manager.js gain-stage --contains FLAUTA --preview
node .\bin\reaper-manager.js track-state --contains VOX --mute on
node .\bin\reaper-manager.js select-tracks --contains flauta
node .\bin\reaper-manager.js add-fx --selected --fx RVerb
node .\bin\reaper-manager.js remove-fx --selected
node .\bin\reaper-manager.js delete-tracks --selected
```

## Project Purpose

This workspace is a local Codex-to-REAPER mix assistant. The user writes mix/setup requests in Spanish, and Codex translates them into safe structured commands sent to REAPER through the local Node CLI.

The user is a sound engineer. Respond in Spanish by default unless they ask otherwise.

## Composition Knowledge

Before composing, arranging, harmonizing, voicing or orchestrating music (cues, songs, beats, chords, melodies, string/brass parts, forms, modulations, instrument ranges), read `knowledge/composition/START-HERE.md` and follow the workflow it routes to. It is an agent-oriented Obsidian vault distilled from the user's harmony, form, orchestration and film-scoring books:

- Load only the notes the workflow lists, stage by stage: 3–6 for a focused task, about 8–12 for a whole piece. Read each note's frontmatter `summary` first.
- `knowledge/composition/workflows/user-taste.md` (the user's ear-validated preferences) overrides book rules.
- Ranges: `knowledge/composition/data/instruments.json` (C4 = MIDI 60, concert pitch).
- Guitar: `orchestration/instruments/classical-guitar-solo.md` (playable fingering, structure) and
  `performance/guitar-ample-performance.md` (Ample keyswitches, velocity, legato, tremolo open work).
- Validate with `knowledge/composition/workflows/validate-generated-midi.md` before handing music over.
- Never read `index.json` whole; grep it or the `_meta/glossary-*.md` tables for Spanish terms.
- After editing the vault, run `node scripts/build-knowledge-index.mjs` (0 errors expected).
- Generate music with the engine in `src/music` (design `docs/music-engine.md`): `node scripts/new-piece.mjs` for a new piece; libraries are profiles in `src/music/profiles/*.json`; onboard a new one with `scripts/calibrate-instrument.mjs` (renders through REAPER only with the user's OK). Until merged, these live on branch `claude/beautiful-cori-2cb102`.

The source PDFs live in `composition/` (git-ignored). To add a book, follow `knowledge/composition/_meta/digest-spec.md` then `_meta/synthesis-spec.md`.

## Key Paths

- Workspace: `A:\PROYECTOS\OPENCODE\Reaper Manager`
- CLI entrypoint: `A:\PROYECTOS\OPENCODE\Reaper Manager\bin\reaper-manager.js`
- Local bridge state: `A:\PROYECTOS\OPENCODE\Reaper Manager\.reaper-manager`
- Command queue: `A:\PROYECTOS\OPENCODE\Reaper Manager\.reaper-manager\queue`
- Responses and heartbeat: `A:\PROYECTOS\OPENCODE\Reaper Manager\.reaper-manager\state`
- REAPER resource path: `C:\Users\sagar\AppData\Roaming\REAPER`
- Installed REAPER bridge: `C:\Users\sagar\AppData\Roaming\REAPER\Scripts\Reaper Manager\Reaper Manager Bridge.lua`
- REAPER config backups from installer: `A:\PROYECTOS\OPENCODE\Reaper Manager\.reaper-manager\backups`

## Health Checks

Before sending any command that changes REAPER, run:

```powershell
node .\bin\reaper-manager.js status
```

If `heartbeat` is `null`, missing, stale, or says the bridge is stopped, do not queue mutating commands. Tell the user to restart REAPER if needed and press the `Reaper Manager` toolbar button.

Use this to check live bridge response once heartbeat exists:

```powershell
node .\bin\reaper-manager.js ping
```

Run tests after changing JavaScript or command behavior:

```powershell
npm test
```

## Safe Command Patterns

Use the CLI rather than writing queue JSON by hand.

Color tracks by name:

```powershell
node .\bin\reaper-manager.js color --contains CLICK --color red
```

Color all tracks:

```powershell
node .\bin\reaper-manager.js color --all --color azul
```

Create FX returns and sends from selected tracks:

```powershell
node .\bin\reaper-manager.js returns --count 2 --fx RVerb --from selected
```

Create FX returns without automatically creating sends:

```powershell
node .\bin\reaper-manager.js returns --count 2 --fx RVerb --from none
```

Add FX to selected tracks:

```powershell
node .\bin\reaper-manager.js add-fx --selected --fx RVerb
```

Remove FX from all tracks only when explicitly requested:

```powershell
node .\bin\reaper-manager.js remove-fx --all
```

Delete tracks only when explicitly requested:

```powershell
node .\bin\reaper-manager.js delete-tracks --selected
node .\bin\reaper-manager.js delete-tracks --all
```

Adjust track volume relatively in dB:

```powershell
node .\bin\reaper-manager.js volume --all --db -3
```

Pan tracks:

```powershell
node .\bin\reaper-manager.js pan --selected --pan L35
```

Adjust send levels from matching source tracks, optionally filtered by destination:

```powershell
node .\bin\reaper-manager.js send-volume --selected --dest Reverb --db 2
```

Adjust selected item volume:

```powershell
node .\bin\reaper-manager.js item-volume --selected --db -3
```

Run automatic item gain staging:

```powershell
node .\bin\reaper-manager.js gain-stage --all-items
node .\bin\reaper-manager.js gain-stage --selected-items
node .\bin\reaper-manager.js gain-stage --selected-tracks
node .\bin\reaper-manager.js gain-stage --contains FLAUTA --preview
```

Level selected vocal items into take volume envelopes for pre-compressor gain staging, targeting the -18 dBFS working point with a smooth curve by default:

```powershell
node .\bin\reaper-manager.js vocal-level --selected-items --preview
node .\bin\reaper-manager.js vocal-level --selected-items
node .\bin\reaper-manager.js vocal-level --selected-items --replace-envelope
```

Rebuild clipped peaks (A-SPADE by default, plateau ripple aware) of the first selected item's active take as REAPER sample edits (non-destructive, one undo step). Works on the time selection by default, `--item` for the whole item. The take must have headroom (render it as a new take with lower gain first if it clips at 0 dBFS) and sample edits enabled in Take settings. Needs Python with numpy and scipy:

```powershell
node .\bin\reaper-manager.js declip --preview
node .\bin\reaper-manager.js declip
node .\bin\reaper-manager.js declip --item
```

Mark vocal syllables that sound thin: `LEJOS` (quieter: singer moved away; `--fix` gives back the physically expected proximity bass plus level) or `FUERTE` (louder: shouted; `--fix` only lowers level). Analyses the first selected item's active take (whole item, or `--selection`), drops `PROX n` markers where each correction starts (re-running replaces them) and, with `--fix`, writes take automation on the original take (volume envelope + automated "Proximity EQ" ReaEQ low shelf; `--replace-envelope` to overwrite) or, with `--fix --render`, adds a corrected render as a new take. Refuses to run on a `prox-fix` take. Needs Python with numpy and scipy:

```powershell
node .in
eaper-manager.js proximity-detect --preview
node .in
eaper-manager.js proximity-detect --fix
node .in
eaper-manager.js proximity-detect --fix --amount 0.7 --mic-cm 5
```

Undo the last Reaper Manager action during bench tests:

```powershell
node .\bin\reaper-manager.js undo --count 1
```

Set track states:

```powershell
node .\bin\reaper-manager.js track-state --contains VOX --mute on
node .\bin\reaper-manager.js track-state --selected --solo toggle
```

Select tracks:

```powershell
node .\bin\reaper-manager.js select-tracks --contains FLAUTA
node .\bin\reaper-manager.js select-tracks --contains GTR --mode add
node .\bin\reaper-manager.js select-tracks --all --mode remove
```

Rename tracks:

```powershell
node .\bin\reaper-manager.js rename --contains CLICK --prefix REF_
```

Create tracks:

```powershell
node .\bin\reaper-manager.js create-tracks --count 2 --name FX
```

Create a folder from contiguous selected tracks:

```powershell
node .\bin\reaper-manager.js folder --selected --name DRUMS
```

Route tracks to a bus:

```powershell
node .\bin\reaper-manager.js route-to-bus --selected --bus DRUMS --disable-main
```

Bypass or enable FX:

```powershell
node .\bin\reaper-manager.js fx-bypass --selected --fx RVerb --state toggle
```

Create a standard rock session structure. This clears existing tracks by default, so use it only after an explicit destructive request:

```powershell
node .\bin\reaper-manager.js rock-template
```

Translate a simple Spanish request through the local parser:

```powershell
node .\bin\reaper-manager.js ask "Coloreame todas las pistas que contengan la palabra CLICK de rojo"
```

## REAPER Safety Rules

- Treat the currently open REAPER project as live work.
- Do not queue mutating commands unless the bridge heartbeat is active and the user requested that specific action.
- Do not execute ambiguous requests. If the source tracks, target tracks, plugin, or routing intent is unclear, ask one concise clarification question.
- Never delete tracks, FX, sends, files, or REAPER configuration unless the user explicitly asks for that destructive action.
- The bridge wraps each supported command in one REAPER undo block. For multi-step user requests, prefer multiple focused commands so the user can undo task-by-task instead of one giant undo.
- If a plugin cannot be resolved, report the error instead of guessing a different plugin.

## Plugin Defaults

- Prefer VST3 variants.
- Prefer stereo variants when available.
- `RVerb` means `VST3:RVerb Stereo (Waves)`.
- The plugin cache is stored at `.reaper-manager\plugin-cache.json`.
- `JS: Volume Adjustment` (`JS:Utility/volume`) loads at **+6 dB**. Right after adding it, set
  `Adjustment (dB)` to 0.5 normalized (0 dB; range ±150 dB, so +1.5 dB = 0.505) and `Max Volume (dB)` to
  0.54 (+12 dB headroom). Automate it with `write_envelope` (`fx`, `param`) for section gain rides.
- CC11 on Albion patches is close to the ceiling at 110–112, so raising it gains only about 1 dB. For more,
  ride a bus gain plugin.

## Listening By Measurement

Claude cannot hear, but can render and measure. `{"type":"render_audio","from_bar":1,"to_bar":31,
"tail_ms":3000,"dir":"<abs dir>","name":"mix"}` renders the master (24-bit WAV, ~4x realtime). Add
`"stems":["TRACK",...]` to render each track's output instead (`<name>_<track>.wav`). The project's render
settings and track selection are restored afterwards. Use `--timeout 400000` on `send`. Measure level and
bands per half bar to locate holes, jumps and section balance. For stereo, measure L/R balance,
correlation and side/mid per stem. `{"type":"transport","action":"play","bar":5}` / `"stop"` drives
playback.

## Meter Changes And Saving

`build_beat` `tempo_changes` entries accept `"timesig": [num, denom]` (e.g. `{"bar":105,"bpm":138,"timesig":[7,8]}`);
later bars follow the new meter, and MIDI `beat` offsets stay in quarter notes. `{"type":"save_project"}` saves
the open project; `{"type":"save_project","path":"A:/.../name.rpp"}` writes a copy there without renaming the
tab, so follow it with `open_project` on that path for a new, empty project. Use forward slashes in JSON paths:
the bridge's JSON parser drops backslash escapes.

Load SWAM instruments one per command and keep their windows closed: with several SWAM GUIs floating, REAPER
froze during an autosave (Nov 2026). `add_track_fx`/`load_patch` now hide the floating window after loading.
`{"type":"fx_offline","track":"FL SOLO","fx_match":"SWAM","offline":false}` sets a plugin offline/online. To isolate
an unstable plugin, set suspects offline in a copy of the .rpp (`BYPASS 0 1 0` before its `<VST` block, and
`FLOAT` → `FLOATPOS` to close saved windows), then bring them back one at a time watching the heartbeat.
SWAM defaults to check after loading: Bassoon 3 Transpose -12 (normalized 0.5 = 0), Cello 3 Transpose -12
(0.6667 = 0), French Horn F Transpose -12 (0.93 = 0) and bend ±12 (0.0417 = ±2).

## Re-sending A Tempo Map

`build_beat` adds tempo markers on top of the existing ones. To rebuild a piece's map send it with
`"replace_tempo": true` (and `"replace_markers": true` for project markers), then re-send the MIDI so the notes
land on the new map. The response reports `tempo_markers`.

## Guitar Parts Carry Their Fingering

`build_beat`/`replace_midi`/`add_midi` notes accept `chan` (0-15). For guitar, `chan` 0-5 = string 1-6 (high e
= 0); the Tab Viewer then shows that string/fret instead of guessing. Ample guitars answer on every channel.
A full fingering solver and playability checker (left hand, barres, shifts, right hand) lives in
`A:\CERBATANA\Ableton\2026-11-02 Fantasia San Juan\generator\lib\fretboard.mjs`.

## Folder Tracks Carry MIDI

In REAPER a child track sends its MIDI to the folder parent as well as its audio. A folder parent must
therefore be an empty bus (no instrument, no MIDI items). In `build_beat` specs, open each family with a
dedicated folder track (`WOODS`, `BRASS`, `PERCUSSION`, `STRINGS`…) and never put `folder: 1` on an
instrument track. To fix an existing session: `{"type":"regroup_folders","groups":[{"name":"WOODS",
"color":"#6fb36f","tracks":["FL SOLO","WW LEGATO"]}],"flat":["REV PANORAMIC"]}` (contiguous tracks).

## Instrument Patches (Kontakt Without The UI)

A plugin's full state (e.g. Kontakt with an Albion ONE instrument loaded) can be saved once and recalled
on any track without touching the plugin window. Patches live in
`%APPDATA%\REAPER\FXChains\Reaper Manager\<name>.RfxChain`.

```powershell
# save FX 0 of a track whose patch was loaded by hand
node .\bin\reaper-manager.js send capture.json   # {"type":"capture_patch","track":"HN LEGATO","fx":0,"name":"Albion ONE - Brass Mid - Legato"}
node .\bin\reaper-manager.js send list.json      # {"type":"list_patches"}
node .\bin\reaper-manager.js send load.json      # {"type":"load_patch","track":"X","name":"...","replace":true}
```

`build_beat` and `add_track_fx` accept `{"patch": "<name>"}` as an FX spec. Check `list_patches` before
loading a library by hand. To load a new .nki by hand, Kontakt's browser only lists NKS presets; use
Kontakt `FILE > Load...` and type the .nki path into the Windows dialog for the rest (e.g. Brass legatos).

Captured so far (Nov 2026): Albion ONE `Woods High - Legato/Short`, `Brass Mid - Legato` (horns),
`Brass Low - Long/Short Nasty`, `Trumpets XL - Long/Short`, `Strings - Long/Long Tremolo/Short
Spiccato/Short Staccato Combo/Short Pizzicato`, `Strings High (Octave) - Legato`, `Strings Low XL -
8ves - Long/Short`, `Darwin Percussion Ensemble`; Symphony Series `Timpani`, `Cymbal 1`.

Articulation facts (Kontakt names C3 = MIDI 60):
- Albion longs: CC1 dynamics, CC11 expression, CC21 vibrato, CC17 release. Shorts: velocity. Legato
  patches are monophonic: overlap notes to slur. `8ves` low strings already double celli + basses an
  octave apart: write one note in the cello register.
- Darwin Percussion Ensemble: Sub hits 24–36, Low hits 40–52, Mid hits 57–67, High hits 71–81, High
  sticks 84–95, Metal 96–107. No timpani.
- Symphony Series Timpani (verified in Kontakt): keyswitch 36 hits, 38 tremolo roll (CC1 dynamics), 40
  cresc, 41 flam (keyswitches sit on white keys; 37 does nothing); 45 plays a damp. Hit keys 48–71 sound
  an octave lower (low D = key 50).
- Symphony Series Cymbal 1 (verified): keyswitch 36 hard / 38 soft mallets; 48 and 50 long hit, 52 and 53
  short (choke), 55 tremolo roll (CC1, use for swells), 57 recorded crescendo, 60–65 velocity layers.
- Never guess a keyswitch from a screenshot at 100%: set Kontakt `VIEW > Zoom 200%`, read the Mapping
  page, then confirm by sending one test note (`add_midi` at bar 1 beat 0.6), `transport` play/stop
  (`{"type":"transport","action":"play","bar":1}`), check which articulation lights up, and `undo`.
- SWAM: CC11 expression as one continuous phrase curve (never dip between slurred notes; fall to ~20
  before the last note-off for a natural release), CC1 vibrato depth (delayed on long notes); overlap =
  slur, gap = tongued. Velocity on a slurred note sets portamento time (Portamento Control = Velocity):
  use ~110–120 for clean slurs, lower only for a deliberate glide (horn max portamento is 2.4 s). On
  attacked notes velocity sets attack hardness. Check `Transpose` and `Pitch Bend Up/Down` with
  `fx_params` after loading: SWAM French Horn F defaults to Transpose -12 and ±12 bend (set to 0 and ±2,
  normalized Transpose 0.93 = 0). Load one per command.
- Albion longs/legato sample attacks are slow: start notes ~0.04–0.05 beat early, slurred legato notes
  ~0.06–0.1 beat early, so they speak on the beat.

## Install And Repair

The installer copies the Lua bridge into REAPER, registers the action, and touches `reaper-kb.ini` and `reaper-menu.ini` with backups. Use it only when the user asks to install/repair:

```powershell
npm run install:reaper
```

If REAPER is open during install/repair, tell the user to restart REAPER once so the action list and toolbar reload.

## Current Operating Model

This project is intentionally local. Do not create global instructions in `~/.codex/AGENTS.md` for this workflow. Future Codex chats should be opened from this workspace root so these project instructions are loaded.

## Code Organization

- `src/commands.js` is a compatibility facade.
- Command builders live under `src/commands/` by domain: tracks, sends, FX, items, folders and project helpers.
- Shared parsing/validation lives under `src/core/`.
- The REAPER runtime is still `reaper/Reaper Manager Bridge.lua`; split it only when actively refactoring bridge internals.
