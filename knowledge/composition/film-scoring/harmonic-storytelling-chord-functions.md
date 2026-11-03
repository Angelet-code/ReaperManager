---
id: film-scoring.harmonic-storytelling-chord-functions
title: Telling a story with chord functions
aliases: [contar una historia con la armonía, funciones armónicas en cine, narrativa armónica, quinta vacía, acorde sin tercera, final de escena, esqueleto de cue]
domain: film-scoring
tags: [harmony, storytelling, functions, cue-design]
style_scope: film (major-key cue writing; common-practice function names used descriptively)
use_when: Planning the chord skeleton of a scene cue, deciding which chord opens, develops or ends a scene, or changing the mood without changing the melody.
summary: "I introduces the character or place (an open fifth keeps it neutral). IV starts the story positively, while vi, iii and ii tell the same story sadder. V makes a strong statement and ends a scene best without its third, and vii° is dark. Harmony doesn't always have to change: texture, timbre, rhythm and tempo can tell the story over a static chord."
sources: ["film-4day-challenge slide 3", "httyd-test-drive p.1-5, p.15"]
related: ["[[harmony-emotion-mapping]]", "[[harmonic-rhythm-scene-dialogue]]", "[[five-elements-arrangement-checklist]]", "[[httyd-test-drive-case-study]]"]
---

# Telling a story with chord functions

## Core idea
Each diatonic function has a dramatic role in a scene. A cue's chord skeleton can follow the scene's
beats: **establish → tell → (darken or brighten) → state / cut**. The same skeleton can be coloured
positive (IV) or sad (vi, iii, ii) without changing anything else.

## Function roles (major key)
| Function | Role | Notes |
|---|---|---|
| I | introduces character, place or situation | full triad sets the mood; **open fifth = neutral** |
| IV | positive; starts the story, enhances emotion | best when the melody hasn't started yet |
| vi, iii, (ii) | same job as IV but negative, sad, emotional | vi strongest, iii more bittersweet |
| V | strong statement | ends a scene well, **especially without the third** |
| vii° | dark | use sparingly, as a shadow |

## Rules
- R1 `PREFER` Open a cue or scene on I. Use an open fifth (no third) if the mood must stay undecided.
- R2 `PREFER` Go to IV to start the story positively, or to vi/iii/ii for the sad version.
- R3 `ALLOWED` End a scene on V, ideally as an open fifth, for a strong unresolved statement at the cut.
- R4 `ALLOWED` Keep one chord and tell the story with texture, timbre, rhythm or tempo instead (see
  [[harmonic-rhythm-scene-dialogue]]).
- R5 `PREFER` (from HTTYD) A loop like vi–IV–V–I can carry a whole theme. Repeat it, and lift it a whole
  step for the final statement.
- R6 `AVOID` Resolving V → I at a scene cut unless the scene really closes. An open V keeps the story
  going into the next scene.

## Apply in MIDI / REAPER
**Cue skeleton generator** (bars per chord set by the scene timing, see
[[harmonic-rhythm-scene-dialogue]]):
1. Establish: I (or I5 = root + fifth only; e.g. D: D2 38, A2 45, D3 50 in `VC`/`CB`/`HN`) for 2–4 bars.
2. Tell: IV (positive) or vi (sad) for 2–4 bars. The melody enters here or just before.
3. Develop: alternate IV/vi/ii/iii as the scene turns. Use vii° or iii for a shadow beat.
4. Statement / cut: V5 (root + fifth, no third: A: A1 33, E2 40, A2 45) held through the cut, with CC1
   swelling to the cut point and CC11 tapering after it.

**Writing open fifths:**
- Remove the third from every track.
- Double the root and fifth in octaves (roots in `CB`/`VC`, fifths in `VLA`/`HN`).
- Keep the third out of the melody on the downbeats too, or the mood resolves.

**Mood switch without changing the melody:** re-harmonise the same melody note with IV (positive) or vi
(sad), choosing a note that belongs to both chords. In C, the melody note C (or A) fits both F (IV) and
Am (vi). Swap the chord in the pad and bass tracks only (bass F2 41 vs A2 45).

**Static-harmony storytelling:** hold I and vary over time:
- Bars 1–4: strings sustain, CC1 40.
- Bars 5–8: add a harp ostinato.
- Bars 9–12: the melody moves to horns, and percussion enters.
- Bars 13–16: tempo +2 BPM, with strings switched to a 16th motor.

## Checklist
- Does the cue open on I (or I5 when neutral)?
- Does the second chord match the scene's polarity (IV positive, vi/iii/ii sad)?
- Does a scene cut land on V, or on a deliberate resolution?
- Is the third really absent from every track wherever an open fifth is intended?
- When harmony is static, does something else (texture, timbre, rhythm, tempo) change every 4–8 bars?

## Examples
- HTTYD: b.2–12 sit on D5 (an open-fifth pedal = neutral, ready). The theme loop is Bm–G–A–D
  (vi–IV–V–I). The cue moves on through E5 and D5 power chords rather than full cadences.
