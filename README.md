# Reaper Manager

Local bridge between Codex and REAPER for mix assistant commands.

## What it does

- Installs a persistent Lua ReaScript bridge into the REAPER resource path.
- Adds a toolbar button that starts/stops the bridge.
- Adds a `Gain Stage` toolbar button that applies deterministic gain staging to selected items.
- Adds a `Select Items` toolbar button that selects every item in the project.
- Adds `vocal-level` for pre-compressor vocal clip gain on selected item take volume envelopes, using macro-to-micro leveling around the `-18 dBFS = 0 VU` working point.
- Adds `separate-sibilants` for selected vocal items: detects bright consonants, cuts near zero crossings, and moves them to a dedicated processing track.
- Lets Codex send structured commands through `.reaper-manager/queue`.
- Writes command responses and bridge heartbeat into `.reaper-manager/state`.

## Quick commands

```powershell
npm run install:reaper
node .\bin\reaper-manager.js status
node .\bin\reaper-manager.js ping
node .\bin\reaper-manager.js color --contains CLICK --color red
node .\bin\reaper-manager.js color --all --color azul
node .\bin\reaper-manager.js returns --count 2 --fx RVerb --from selected
node .\bin\reaper-manager.js add-fx --selected --fx RVerb
node .\bin\reaper-manager.js remove-fx --all
node .\bin\reaper-manager.js delete-tracks --selected
node .\bin\reaper-manager.js select-tracks --contains FLAUTA
node .\bin\reaper-manager.js select-tracks --all --mode remove
node .\bin\reaper-manager.js volume --all --db -3
node .\bin\reaper-manager.js pan --selected --pan L35
node .\bin\reaper-manager.js send-volume --selected --dest Reverb --db 2
node .\bin\reaper-manager.js item-volume --selected --db -3
node .\bin\reaper-manager.js gain-stage --all-items
node .\bin\reaper-manager.js vocal-level --selected-items --preview
node .\bin\reaper-manager.js vocal-level --selected-items
node .\bin\reaper-manager.js vocal-level --selected-items --replace-envelope
node .\bin\reaper-manager.js gain-stage --selected-items --preview
node .\bin\reaper-manager.js track-state --contains VOX --mute on
node .\bin\reaper-manager.js rename --contains CLICK --prefix REF_
node .\bin\reaper-manager.js create-tracks --count 2 --name FX
node .\bin\reaper-manager.js folder --selected --name DRUMS
node .\bin\reaper-manager.js route-to-bus --selected --bus DRUMS --disable-main
node .\bin\reaper-manager.js fx-bypass --selected --fx RVerb --state toggle
node .\bin\reaper-manager.js undo --count 1
node .\bin\reaper-manager.js rock-template
node .\bin\reaper-manager.js chat "baja guitarras 1 dB"
```

## Sibilant separation

`separate-sibilants` detects short high-frequency consonant regions in selected
items, snaps the cut points to nearby zero crossings, and moves the separated
pieces to a destination track.

```powershell
node .\bin\reaper-manager.js separate-sibilants --selected-items --preview
node .\bin\reaper-manager.js separate-sibilants --selected-items --destination-track "VOX SIBILANTS"
```

The command requires selected items, defaults to zero-crossing cuts with no fades,
and looks for isolated high-band energy relative to the rest of that same voice.
Detection options include `--consonants`, `--band-low-hz`, `--band-high-hz`,
`--padding-ms`, `--merge-gap-ms`, and `--zero-crossing-search-ms`.

## Proximity detect (syllables that sound far)

`proximity-detect` finds syllables whose low harmonics (H1+H2 vs 1-4 kHz) drop
against the singer's own per-pitch model and against their neighbours, then
tells two causes apart by the level of the affected window:

- `LEJOS`: quieter than the neighbours. The singer pulled back or turned away.
  The level gap gives the distance ratio (6 dB = twice as far) and the cardioid
  proximity effect at both distances gives the bass to give back: a physically
  shaped low shelf, no fixed dB limit. Gain then completes the level match.
- `FUERTE`: louder than the neighbours. Shouted / pressed phonation also thins
  the voice; it only gets its level brought down, no EQ.
- thinner at the same level is most likely the vowel itself and is left alone.

The correction window starts after glottal hits (a sharp rise is a new
syllable; the hit and its decay are never processed), and markers sit on it.

```powershell
node .in
eaper-manager.js proximity-detect --preview     # list only
node .in
eaper-manager.js proximity-detect              # PROX markers
node .in
eaper-manager.js proximity-detect --fix        # + corrected render as a new take (A/B with T)
```

Levels are compared in perceived loudness (K-weighting): a thinner syllable
loses mostly body energy, not loudness. `LEJOS` lifts `--level-amount` (0.45)
of its loudness dip (part of a dip is phrasing), `FUERTE` pulls down
`--loud-amount` (0.8) of its excess, and a glottal hit right before a `FUERTE`
vowel comes down by `--hit-share` (0.75) of the vowel's gain so it does not
stick out. These defaults come from hand corrections of real takes.

Tuning: `--amount` (1, share of the proximity bass restored), `--mic-cm` (10, normal mic
distance: closer = more bass at stake), `--h12-drop-db` (6), `--min-z` (1),
`--level-drop-db` (1.5), `--loud-db` (1.5), `--min-level-db` (20), `--max` (30),
`--selection`, `--fade-ms` (20), `--replace-envelope`. Run it on the original
take, not on a `prox-fix` render.

`--fix` writes everything on the original take, nothing rendered and nothing
cut: the take volume envelope gets a plateau per correction window with linear
ramps of `--fade-ms` outside it, and a ReaEQ take FX renamed "Proximity EQ"
(band 1, low shelf at c / 4 pi r: ~273 Hz for 10 cm) gets its gain automated the
same way (0 dB outside the windows). A/B by bypassing the FX and the envelope.
An existing take volume envelope is only overwritten with `--replace-envelope`.

## Declip (clipped peak reconstruction)

`declip` rebuilds the flat-topped peaks of a clipped recording as per-take
sample edits (REAPER 7.70+), so the WAV is never modified and the whole repair is
one undo step.

```powershell
node .\bin\reaper-manager.js declip --preview   # analysis only
node .\bin\reaper-manager.js declip             # time selection of the selected item
node .\bin\reaper-manager.js declip --item      # whole item
```

Default method: A-SPADE (sparse spectral declipping). In 2048-sample frames
around the clipped runs it finds the signal that is sparsest in frequency and
consistent with what survived, without assuming any peak shape (voice, drums or
bass alike). Clips are often filtered afterwards (converter, resampling), so the
plateaus ripple and ring: the plateau level is taken from the most crowded
magnitude near the top (not the max, which is an overshoot), same-sign dips of up
to `--bridge` (3) samples inside a plateau are bridged, and `--guard` (3) samples
each side are rebuilt freely. Peaks that need more than the take's headroom bend
towards the ceiling in the last 0.5 dB; render the take lower if many do.
`--method lsar` (autoregressive fill) and `--method curve` (the first peak-shape
model, which added a dull "clac" on dense transients) remain available.

Before running it:

1. The clipped take needs headroom: if it clips at 0 dBFS, lower the take gain
   (e.g. -6 dB) and render it as a new take, then work on that take.
2. Enable sample edits on the take (right click > Take settings).
3. Python with `numpy` and `scipy` (`REAPER_MANAGER_PYTHON` or `--python` to choose
   the interpreter).

How it works (`scripts/declip.py`): plateaus at >= 97% of the clip level are
detected (rippled plateaus included); each peak's target height averages the
trend of the nearest intact peaks on each side, the continuation of the entry and
exit slopes, and the opposite-polarity peak of the same period; the new crest is a
minimum-jerk curve that joins the intact samples smoothly, is limited to the jerk
seen in the intact audio, and is soft-compressed if it overshoots the envelope.
Tuning: `--threshold`, `--edge`, `--anchor-ms`, `--slew-db`, `--knee-db`,
`--max-db`, `--keep`.

If REAPER is open while installing, restart REAPER once so it reloads the action list
and toolbar configuration.

## New Codex chat quickstart

Open new Codex chats from this workspace:

```text
A:\PROYECTOS\OPENCODE\Reaper Manager
```

Codex will read `AGENTS.md` for project-specific instructions. Before asking it to
change REAPER, make sure REAPER is open and the `Reaper Manager` toolbar button has
been pressed. If `node .\bin\reaper-manager.js status` shows no heartbeat, the bridge
is not running yet.

## REAPER chat

Run `npm run install:reaper` after updates to register the bridge action:

- `Reaper Manager`: starts/stops the bridge.
- `Gain Stage`: queues `gain_stage_items` for selected items using the standard defaults.
- `Select Items`: selects every item in the project.

The chat handles simple local commands first through the same parser and command
builders as the CLI. If the local parser does not understand the request and
`OPENAI_API_KEY` is available, it uses `gpt-5.5` with low reasoning effort as a
fallback planner. If no clear safe command comes out, it answers
`No entiendo lo que quieres.` Clear commands are applied immediately and each
command stays in its own REAPER undo block.

## Safety

The bridge only implements additive/reversible setup commands in v1. Each command is
wrapped in one REAPER undo block.
