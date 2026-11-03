---
id: harmony.accompaniment-for-solo-line
title: Writing an accompaniment for a solo line
aliases: [acompañamiento, acompañamiento pianístico, escribir un acompañamiento, figuración de acordes rotos, acorde roto, voces de relleno, canción con piano, Begleitung, Klavierbegleitung, Akkordbrechung, Füllstimmen]
domain: harmony
tags: [accompaniment, piano, texture, procedure, song]
style_scope: common-practice (procedure and "support, never dominate" apply to any song/cue accompaniment)
use_when: A solo melody (flute, violin, voice, lead synth) exists and the task is to write the piano/pad/strings accompaniment under it.
summary: Segment the solo into sections and decide each one's key (static or modulating) and style; write the bass from the main harmonic points first, then the connecting bass, then the full bass, then the harmony. Use idiomatic textures (broken chords, register contrast, thinning or filling chords), keep a top line in the accompaniment, avoid clashing with the melody, interrupt repetitive patterns, and grade chord fullness with the melody's dynamics.
sources: ["hindemith-1 p.117-125", "hindemith-2 p.11-18", "hindemith-2 p.18-22", "hindemith-2 p.29-33", "hindemith-2 p.41-71"]
related: ["[[harmonizing-a-melody]]", "[[harmonic-texture-and-voice-count]]", "[[harmonic-planning-seven-factors]]", "[[harmony-voicing-for-instruments]]", "[[diatonic-seventh-chords]]", "[[_form]]", "[[_orchestration]]", "[[_harmony]]"]
---

# Writing an accompaniment for a solo line

## Core idea
Hindemith's final exercises (sonatinas for flute/violin) leave strict four-part writing behind: the
accompaniment can fill out or thin harmonies, break them into figuration, use unison, crossing, bass
doubling and parallel motion — all derived from four-part logic. The method is top-down: sections and keys,
then bass skeleton, then texture, then harmony.

## Rules
### Procedure
1. `MUST` Determine the tonal groups: which sections stay in one key (end = start) and which modulate.
2. `MUST` Choose the style/texture of each section; sections marked as corresponding (same letter/numeral)
   get corresponding treatment.
3. `MUST` Write the bass at the main harmonic points first, then the connecting passages, adding sparse
   figures that show the harmonic plan.
4. `MUST` Elaborate the whole bass in the chosen style.
5. `MUST` Complete the harmony (texture per section).

### Further rules
- R1 `ALLOWED` Fill out harmonies (keep doublings proportionate) or reduce to 2–3 notes for better sound.
- R2 `ALLOWED` Broken-chord figuration, unison passages, voice crossing, bass doubling, parallel motion.
- R3 `MUST` Write idiomatically for the instrument; `AVOID` chorale-style four-part blocks in a piano part.
- R4 `MUST` Interrupt a constantly repeated accompaniment motive with other (preferably calmer) motives;
  endless repetition is empty activity.
- R5 `MUST` Avoid notes and figures that collide with the melody — check every register the melody may sound
  in (e.g. soprano and tenor versions an octave apart); be extra careful with non-chord tones.
- R6 `PREFER` Join the top notes of the accompaniment into a continuous line of modest melodic quality.
- R7 `MUST` Grade **chord fullness** (notes per chord, via doublings) with the melody's dynamic swell.
- R8 `PREFER` Variety by register: oppose low-register chords to high-register chords.
- R9 `MUST` If the melody has the chord seventh, do not double it in the same octave; if only the
  accompaniment has it, put it where it is heard.
- R10 `MUST` Support, never dominate: no new melodic material in the melody's register; lighter rhythm than
  the melody; precise dynamics.
- R11 `PREFER` Differentiate formal sections by texture; a return may be varied (e.g. the piano takes the
  middle section's melody transposed to the tonic).
- R12 `PREFER` On a repeated refrain, give the melody to another voice/instrument.
  - *Outside this style:* pop/film accompaniments follow the same logic (bass skeleton, groove pattern per
    section, fills between phrases) (general knowledge); the "interrupt the pattern" rule = vary the groove
    at section changes and phrase ends.

## Apply in MIDI / REAPER
- Read the solo track, mark sections (REAPER regions) and keys; write the bass track first (one note per
  harmonic point), then expand it to the section pattern.
- Clash test (per accompaniment note): if it sounds during a melody note at a distance of 1, 2, 13 or 14
  semitones (m2/M2/m9/M9) and is not a planned NCT, move or drop it; repeat at melody ±12.
- Register rule: keep accompaniment top line ≥ 3 semitones below the melody's current note, or ≥ an octave
  away; never cross above it with a sustained note.
- Fullness: e.g. pp = 2–3 notes, mf = 4, ff = 5–6 notes + bass octave; velocity follows the same curve.
- Pattern library per section (block, broken triad, Alberti-type, offbeat chords, sustained pad + moving bass);
  change pattern at section boundaries and every 4–8 bars of identical material.

## Checklist
- Sections, keys and texture chosen before notes?
- Bass skeleton written first?
- No unplanned 2nds/9ths against the melody in any octave it may appear?
- Repetitive patterns interrupted; chord fullness follows dynamics?

## Examples
- Flute sonatina, 2/2: A section broken eighths in LH + RH offbeat chords; B section sustained chords in a
  higher register; A' returns with the first texture but fuller chords at the climax.
