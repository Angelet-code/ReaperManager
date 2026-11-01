---
id: orchestration.texture-types
title: Orchestral texture types (classifier)
aliases: [tipos de textura, textura orquestal, análisis de orquestación, texturas de Piston, homofonía, polifonía]
domain: orchestration
tags: [texture, analysis, classifier]
style_scope: universal (Piston's typology, applies to tonal orchestral and film music)
use_when: Before orchestrating a section, to decide which texture recipe to apply; or when analysing a reference to say what each instrument is doing.
summary: "Classify every section into one of Piston's seven textures: unison, accompanied melody, secondary melody, part writing, counterpoint, chords, or complex/mosaic. Then load the recipe note for that type. A cue changes texture by section, and the texture links the global analysis to the bar-by-bar orchestration."
sources: ["unir-orq-tema3 p.5-19", "unir-orq-tema2 p.4-6"]
related: ["[[texture-unison-and-tutti]]", "[[texture-accompanied-melody]]", "[[texture-secondary-melody-countermelody]]", "[[texture-part-writing-chorale]]", "[[texture-counterpoint]]", "[[chord-voicing-family-stacking]]", "[[texture-complex-mosaic]]", "[[orchestrate-from-piano-sketch]]"]
---

# Orchestral texture types (classifier)

## Core idea
Orchestration shows the musical thought, so first say **what kind of thought** it is. Piston (via UNIR)
gives seven texture types. Analyse globally and section by section; recognise simple textures before
complex ones.

## Rules
- R1 `MUST` Before writing parts for a section, tag it with one texture type and list its layers
  (melody / bass / filler, plus countermelody or independent lines if present).
- R2 `MUST` Load the matching recipe note and follow its track layout.
- R3 `PREFER` Change texture at form boundaries (every 4/8/16 bars) to give variety. Keep the texture
  within a phrase unless it builds.
- R4 `AVOID` Treating counterpoint as accompanied melody (and the reverse). A contrapuntal section
  needs independent lines with their own colours, not a melody over pads.

## The seven types (decision table)
| Ask | If yes → type | Recipe note |
|---|---|---|
| Is one line played by several different instruments, with nothing else (or almost nothing)? | Orchestral unison | [[texture-unison-and-tutti]] |
| Does everyone play, each in its best register, with different material? | Tutti | [[texture-unison-and-tutti]] |
| Is there one melody plus a subordinate accompaniment? | Accompanied melody | [[texture-accompanied-melody]] |
| Is there melody + a second melodic line + accompaniment? | Secondary melody | [[texture-secondary-melody-countermelody]] |
| Are there 3–4 voices moving mostly together in harmony (chorale)? | Part writing | [[texture-part-writing-chorale]] |
| Are there 2+ independent lines (rhythm and contour) of similar weight? | Counterpoint | [[texture-counterpoint]] |
| Are there block chords, stabs or sustained harmony with no real melody? | Chordal texture | [[chord-voicing-family-stacking]] |
| Are there several simple textures layered, or many elements with none primary? | Complex / mosaic | [[texture-complex-mosaic]] |

## Apply in MIDI / REAPER
- Work out the texture from the MIDI sketch by measuring, not by guessing:
  - Count the distinct rhythmic streams. Notes that start together are one stream.
  - Unison = 1 stream at the same or octave-related pitches.
  - Accompanied melody = 1 melodic stream (stepwise, longest phrases, highest or most salient) +
    repeated or sustained harmony.
  - Counterpoint = 2+ streams whose onsets coincide less than about 50 % of the time and whose contours
    differ.
  - Part writing = 3–4 streams whose onsets coincide 80 % or more.
- Write the tag into a REAPER project marker at the section start, e.g. `B1 | accompanied melody | mel=HN
  bass=VC+CB fill=VLA`. Builder specs take `markers: [{bar, name}]`.
- Name tracks or items by layer role (`MEL`, `CM`, `BASS`, `FILL`, `PAD`, `MOTOR`) so later lint passes
  can check the balance between roles.

## Checklist
- Does each section have exactly one texture tag and a layer list?
- Does the orchestration follow that tag's recipe (e.g. counterpoint lines in different colours)?
- Does the texture change at least once per 16–32 bars, or at each new form section?
- Are melody, bass and filler each assigned before notes are written?

## Examples
- HTTYD "Test Drive": the intro is complex (ostinato + pedal + motor), b.13 is an accompanied melody
  (the whistle), b.21 is a heroic unison tune with chords, b.32 is a tutti, b.40 is chordal clusters
  with no melody (see [[httyd-test-drive-case-study]]).
