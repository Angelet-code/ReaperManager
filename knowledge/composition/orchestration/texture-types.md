---
id: orchestration.texture-types
title: Orchestral texture types (classifier)
aliases: [tipos de textura, textura orquestal, análisis de orquestación, texturas de Piston, homofonía, polifonía, elemento textural, subelemento, planos sonoros, primer plano, plano medio, plano de fondo, Hauptstimme, Nebenstimme, voz principal, voz subsidiaria]
domain: orchestration
tags: [texture, analysis, classifier, sound-planes]
style_scope: universal (Piston's typology, applies to tonal orchestral and film music)
use_when: Before orchestrating a section, to decide which texture recipe to apply; or when analysing a reference to say what each instrument is doing.
summary: "Classify every section into one of Piston's seven textures (unison, melody and accompaniment, secondary melody, part writing, counterpoint, chords, complex), list its few elements (A melody, B accompaniment…) and their plane (foreground, middleground, background), then load the recipe note. Octave doublings and parallel 3rds/6ths are one element, not new voices. Change the layout every few bars and the texture at form boundaries."
sources: ["unir-orq-tema3 p.5-19", "unir-orq-tema2 p.4-6", "piston-orch p.355-357, 364, 406-411", "adler-orq-es p.547, 558-559, 578, 595-596"]
related: ["[[texture-unison-and-tutti]]", "[[texture-accompanied-melody]]", "[[texture-secondary-melody-countermelody]]", "[[texture-part-writing-chorale]]", "[[texture-counterpoint]]", "[[chord-voicing-family-stacking]]", "[[texture-complex-mosaic]]", "[[orchestrate-from-piano-sketch]]", "[[line-separation-and-fusion]]", "[[tutti-balance-by-role]]"]
---

# Orchestral texture types (classifier)

## Core idea
Orchestration shows the musical thought, so first say **what kind of thought** it is. Piston gives seven
texture types (I–VII). Most music has only a few **elements** (Piston's letters: A melody, B accompaniment
or secondary melody, C…), each played by one or many instruments; a compound element splits into
**subelements** (e.g. sustained winds + repeated-note strings + bass pulse). Adler describes the same
layering as **planes**: foreground (primer plano), middleground (plano medio), background (plano de fondo).
Orchestration must make the elements, and the form, easy to hear.

## Rules
- R1 `MUST` Before writing parts for a section, tag it with one texture type and list its elements, each
  with its plane and its instruments.
- R2 `MUST` Work in Piston's order (p.355–356):
  1. identify the elements apart from instrumentation;
  2. assign instruments/sections to each element;
  3. compare the elements for balance and contrast (each must be audible, the melody never covered);
  4. refine each element: colour, doubling, spacing, accent reinforcement, subelements.
- R3 `PREFER` Count **elements, not instruments**. Octave doubling (Vc + Cb, a tune in three octaves),
  consistent parallel 3rds/6ths and planing triads are harmonic thickening of one element (Piston).
- R4 `PREFER` Separate the elements by at least one of register, colour, rhythm, articulation (see
  [[line-separation-and-fusion]]), and give each element its own dynamic; the foreground sits about one
  level above the rest (Adler, after Schoenberg's Hauptstimme/Nebenstimme marks).
- R5 `PREFER` Re-plan every few bars: good orchestration keeps changing its layout and often its type
  (Piston). Change the type at form boundaries (every 4/8/16 bars); keep it within a phrase unless it
  builds. Use the orchestration to clarify sections, returns and structural gestures (Adler).
- R6 `AVOID` A constant stream of new colours and effects, and endless tutti: both blur the structure and
  tire the ear (Adler p.547). Reserve the grand tutti for structural peaks.
- R7 `AVOID` Treating counterpoint as accompanied melody (and the reverse). A contrapuntal section needs
  independent lines with their own colours, not a melody over pads.

## The seven types (decision table)
| Ask | If yes → type | Recipe note |
|---|---|---|
| One line on several instruments (unison or octaves), nothing else? | I Orchestral unison | [[texture-unison-and-tutti]] |
| Everyone plays, each in its best register, with different material? | Tutti (any type, full forces) | [[texture-unison-and-tutti]] |
| One melody + a subordinate accompaniment? | II Melody and accompaniment | [[texture-accompanied-melody]] |
| Melody + a second melodic line + accompaniment? | III Secondary melody | [[texture-secondary-melody-countermelody]] |
| 3–4 voices of about equal standing moving together (chorale)? | IV Part writing | [[texture-part-writing-chorale]] |
| 2+ independent lines (rhythm and contour) of similar weight? | V Counterpoint | [[texture-counterpoint]] |
| Block chords, stabs or sustained harmony with no real melody? | VI Chords | [[chord-voicing-family-stacking]] |
| Several simple textures stacked, or many elements with none primary? | VII Complex / mosaic | [[texture-complex-mosaic]] |

A solo instrument with orchestra (concerto, singer, choir) is type II or III with special balance rules:
[[texture-accompanied-melody-concerto-soloist]], [[texture-accompanied-melody-voice-and-choir]].

## Period practice
- `[era: 19th-c. Romantic]` each element coloured by a mix of families (at least one string, one wood,
  one brass) for the big blended sound (Adler).
- `[era: 20th-c., esp. American: Holst, Bloch]` section-block scoring: each element in one family
  (strings / woods / brass) so it reads as a separate entity. Clear; suits film writing.
- `[era: Second Viennese School]` Klangfarben / pointillism: nearly every note on another instrument;
  see [[texture-complex-mosaic]].

## Apply in MIDI / REAPER
- Work out the texture from a MIDI sketch by measuring:
  - Count the distinct rhythmic streams. Notes that start together are one stream.
  - Unison = 1 stream at the same or octave-related pitches.
  - Accompanied melody = 1 melodic stream (stepwise, longest phrases, highest or most salient) +
    repeated or sustained harmony.
  - Counterpoint = 2+ streams whose onsets coincide less than about 50 % of the time and whose contours
    differ.
  - Part writing = 3–4 streams whose onsets coincide 80 % or more.
- Write the tag and the element list into a project marker at the section start, e.g.
  `B1 | II | A=HN (fg) B=VLA+VC pulse (bg) C=CB` (builder specs take `markers: [{bar, name}]`).
- Name tracks or items by role (`MEL`, `CM`, `BASS`, `FILL`, `PAD`, `MOTOR`) so lint passes can check
  balance between roles. Set each element's CC1/velocity level as a block: foreground about one dynamic
  step (≈ 10–15 CC1, see [[dynamics-by-orchestration]]) above the others (inferred), then check the
  measured targets in [[tutti-balance-by-role]].

## Checklist
- Does each section have exactly one texture tag and an element list with planes?
- Is each element set apart from the others by register, colour or rhythm?
- Does the orchestration follow the tag's recipe (e.g. counterpoint lines in different colours)?
- Does the texture change at least once per 16–32 bars, or at each new form section?
- Are melody, bass and filler assigned before notes are written?

## Examples
- HTTYD "Test Drive": the intro is complex (ostinato + pedal + motor), b.13 is an accompanied melody
  (the whistle), b.21 is a heroic unison tune with chords, b.32 is a tutti, b.40 is chordal clusters
  with no melody (see [[httyd-test-drive-case-study]]).
- Debussy, *Prélude à l'après-midi d'un faune* (Piston Ex. 380): A = Fl I, Ob I, EH, Cl I–II (melody in
  near-parallel harmony, one element); B = divided strings, Bsn, Hn III–IV (accompaniment).
