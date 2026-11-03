---
id: film-scoring.action-ostinato-pedal-gallop
title: Action cue engine (ostinato, pedal, gallop, hocket)
aliases: [ostinato, motor rítmico, galope, nota pedal, pedal de tónica, hocket, hoquetus, chug, música de acción, persecución, vuelo]
domain: film-scoring
tags: [ostinato, pedal, gallop, hocket, action, motor-rhythm]
style_scope: film (adventure/action scoring, John Powell-style; transferable to epic and trailer)
use_when: Writing the rhythmic engine of an action, flight or chase cue, or keeping energy while the harmony moves.
summary: Run the action engine on a fixed foundation. Hold a tonic pedal in the low instruments, re-attacked with an accent every 2–4 bars, and run a fixed-pitch ostinato or gallop on top while the harmony changes only in the upper brass and strings. Split fast woodwind figures in hocket, interlock violas and celli on one rising cell, and grow by adding octave layers, not by raising dynamics.
sources: ["httyd-test-drive p.1-3, p.9-12"]
related: ["[[httyd-test-drive-case-study]]", "[[five-elements-arrangement-checklist]]", "[[bass-line-doubling]]", "[[texture-complex-mosaic]]", "[[harmony-emotion-mapping]]"]
---

# Action cue engine (ostinato, pedal, gallop, hocket)

## Core idea
HTTYD's "Test Drive" builds a flight sequence from a **fixed foundation** (a tonic pedal) under a
**fixed motor** (an ostinato or gallop), while colour and harmony change **above** it. The engine never
stops. Intensity comes from adding layers and octaves, and from chord colour over the pedal.

## Rules
- R1 `PREFER` Open with a 2-bar neighbour-note 8th ostinato in celesta + harp RH + Vln I, a repeated tonic
  in harp LH, and violas chugging repeated 16ths. As it repeats, add only octave layers.
- R2 `PREFER` Hold a low tonic pedal (open fifth or root) and re-attack it with an accent and a cymbal
  every 2 or 4 bars, instead of tying it for many bars.
- R3 `PREFER` Gallop: basses + bassoons + contrabassoon + timpani + snare all on the same "8th + two
  16ths" rhythm, with bass drum on beats 1 and 3. Change chords only in the brass above the fixed pedal.
- R4 `PREFER` Over the pedal, move triads by chromatic mediant (Ab/D – C/D – Ab/D – F/D – B/D) for
  grandeur, or diatonically (D – G/D – Em/D) for warmth.
- R5 `PREFER` Split fast woodwind 16ths between two sections in **hocket**: each plays a slurred pair
  and rests. It reads cleaner, and with samples it avoids machine-gun repetition.
- R6 `PREFER` Interlock violas and celli on the same rising 16th cell, offset by an 8th or a beat, for drive
  without thickening one line.
- R7 `PREFER` Woodwinds fill one beat-group each (flute, then oboes, then clarinets), never all at once.
- R8 `ALLOWED` Repeated-note 16ths (each pitch twice) in violins for brilliance without new pitches.

## Apply in MIDI / REAPER
Example in D, q = 111, 4/4 (builder beats 0-based, `len` in quarters):
- **Pedal** (`CB`, `VC 2`, `CBSN`, `LOW BRASS LONG`):
  - D1 26 + D2 38 (Cb), D2 38 (Vc, bsn), D2 + A2 45 (trombones) as a 4-bar whole-note tie, re-attacked
    at bars 1, 5, 9.
  - Velocity 112 on each re-attack.
  - CC1 110 → 85 over each 4 bars (ff → f decay). A `CYMBALS` hit (vel 110) on each re-attack.
- **Ostinato** (`CELESTA`, `HARP`, `VLN I` short):
  - A 2-bar cell in 8ths, e.g. D5 74, A4 69, D5 74, E5 76 | C#5 73, A4 69, C#5 73, D5 74 | B4 71, A4 69,
    A4 69, G4 67 | G4 67, F#4 66, E4 64, D4 62.
  - Celesta +12 as well. Harp LH repeats D3 50 in 8ths.
  - Velocity 75–90 with +10 on beat 0 of each bar.
- **Viola chug** (`VLA` short): D4 62 repeated 16ths (`len` 0.25), velocity alternating 95 / 70, then 8th
  double stops (D4 + A4).
- **Octave growth:**
  - Bar 9: Vln I moves +12 in 16ths, Vln II takes the old Vln I line, `GLOCK` joins (+24).
  - Bars 9–11: horns a6 + bassoons answer on the descending half of the cell.
- **Gallop cell** (per beat): notes at beat offsets 0 (`len` 0.5), 0.5 (`len` 0.25), 0.75 (`len`
  0.25). Velocities 110 / 85 / 90. Basses add a low octave on every beat 0. `BD` on builder beats 0 and 2.
  `SNARE` plays the same cell at velocity 90 / 60 / 70.
- **Hocket** (`OB`, `CL`, shorts):
  - OB plays the 16ths at beat offsets 0 and 0.25, then rests.
  - CL plays offsets 0.5 and 0.75, then rests.
  - Each pair is slurred (legato or a short-overlap patch).
- **Interlock** (`VLA`, `VC`): the same rising cell D–F–G#–A–B (e.g. VC 50, 53, 56, 57, 59). VC starts on
  beats 0 and 2, VLA on beats 0.5 and 2.5 (+12). Velocity 105 marcato.
- **Rhythmic acceleration into the next section:** gallop → 8th-triplets (3 notes per beat, `len` 0.333)
  2 bars before the boundary, then a rising quarter-note-triplet bass scale (`len` 0.667) in the last bar.

## Checklist
- Is the pedal re-attacked with an accent every 2–4 bars?
- Does the ostinato keep fixed pitches while the chords change above it?
- Does the gallop rhythm appear identically in basses, low winds, timpani and snare?
- Are woodwind 16ths split into hocket or beat-groups, never continuous in one section?
- Does energy grow by octave layers, with dynamics steady or decaying?
- Does the engine accelerate rhythmically before section changes?
