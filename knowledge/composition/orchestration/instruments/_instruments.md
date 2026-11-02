---
id: orchestration.instruments-moc
title: Instruments — map of content
aliases: [instrumentos, instrumentación, fichas de instrumentos, Instrumentenkunde]
domain: orchestration
tags: [moc, instruments, ranges]
style_scope: universal
use_when: Before writing or validating any orchestral MIDI part, to find the note for each instrument and the shared conventions (dynamics mapping, range data file).
summary: One note per instrument (or tight family) with sounding ranges in MIDI, registers, dynamics per register, agility, sample-articulation mapping, roles, doublings and a validation checklist; machine-readable ranges live in data/instruments.json.
sources: ["unir-orq-tema1", "unir-orq-tema4", "unir-orq-tema5", "unir-orq-tema6", "unir-orq-tema7", "unir-orq-tema8", "apuntes-orq-sesion1"]
related: ["[[_orchestration]]", "[[glossary-instruments]]", "[[unir-orquestacion]]"]
---

# Instruments — map of content

All ranges are **sounding (concert) MIDI numbers, C4 = 60**. Orchestration technique (texture, doubling
strategy, balance between families) lives one folder up in [[_orchestration]].

## Strings
| note | use_when | summary |
|---|---|---|
| [[violin]] | Writing/checking Vln I or Vln II | 55–100 (practical 55–88); E string brightest, D weakest, sul G dark; détaché for speed, divisi over chords |
| [[viola]] | Writing/checking violas | 48–88 (practical ≤ 81); dark, less powerful; C string ominous; dyads as divisi |
| [[cello]] | Writing/checking cellos | 36–81; A string (57–69+) is the melody string; resonant pizz 36–69 |
| [[double-bass]] | Writing/doubling basses | sounds 8vb; 28–67 (24 with extension); slow speech; never 2 basses |
| [[string-techniques]] | Choosing string articulations/patches | legato / détaché / spiccato, pizz, mute, tremolo, harmonics, double stops, divisi → patch table |
| [[orchestra-sizes-and-section-balance]] (parent folder) | Choosing player counts or solo/chamber/section patches | 1–3 = soloists, 4–8 thin/chamber, ≥ 9 section; counts decrease Vln I → Cb; never 2 basses |

## Woodwinds
| note | use_when | summary |
|---|---|---|
| [[flute-piccolo]] | Flute, piccolo, alto flute parts | flute 59/60–96, weak low, agile; piccolo +12 (74–108); alto flute −5 (55–91) |
| [[oboe-english-horn]] | Oboe or English horn parts, exposed solos | oboe 58–93, louder low, no soft low Bb, solo colour; E.H. −7 (52–84) |
| [[clarinets]] | Bb/A/Eb/bass clarinet parts, soft entries | Bb 50–89: chalumeau/throat/clarino/top; best pp & niente; bass cl −14 (34–82) |
| [[bassoons]] | Bassoon/contrabassoon parts, woodwind bass | bassoon 34–75, no low pp, soft middle, staccato; contrabassoon −12 (21–60), needs rests |

## Brass
| note | use_when | summary |
|---|---|---|
| [[horn]] | Horn parts: pads, heroic tunes, stopped notes | F horn −7, 35–77; home 53–72; rests after top notes; glue of the orchestra |
| [[trumpet]] | Trumpet parts: melody, fanfare, muted | C 54–84, Bb −2 52–84; middle 60–77 best; no soft highs; tonguing bursts need rests |
| [[trombone]] | Tenor/bass trombone parts, chorales | tenor 40–70 (+ext); strong 45–66; avoid VII↔I slide jumps; 3 in unison dominate |
| [[tuba]] | Tuba bass, sub-octave reinforcement | ≈ 26–67; strong 38–51; low notes slow only; frequent breaths |

## Percussion
| note | use_when | summary |
|---|---|---|
| [[timpani]] | Timpani pitches, rolls, retuning | 36–60 across 5 drums; ≤ 4 pitches; Classical = tonic + dominant with trumpets |
| [[percussion-unpitched]] | Snare, bass drum, cymbals, tam-tam, triangle, small percussion | key-map instruments; cymbal-roll crescendo, l.v. tails, sparing triangle |
| [[mallet-percussion]] | Glock, xylophone, marimba, vibes, bells, crotales | glock +24 (79–108), xylo +12, crotales +24; marimba/vibes/bells as written |

## Harp and keyboards
| note | use_when | summary |
|---|---|---|
| [[harp]] | Harp parts, pedal settings, glissandi | 23–103; 7 pedals → one spelling per note name; no continuous chromaticism |
| [[classical-guitar-solo]] | Solo classical guitar or any guitar part that must be really playable | write from string/fret; one shape per chord; melody owns its string; never release right after the attack; home theme, contrast, prepared climax |
| [[piano-celesta-keyboards]] | Piano, celesta, harpsichord, organ in orchestra | piano 21–108 as percussive doubler; celesta +12 soft sparkle; harpsichord quiet; organ pedal bass |

## Cross-cutting
| note | use_when | summary |
|---|---|---|
| [[transposing-instruments]] | Reading parts into MIDI or producing parts | MIDI = concert pitch; written→sounding table; key-signature rule; clefs |

## Shared conventions used by these notes
- **Dynamics → MIDI (project convention, inferred):** pp ≈ CC1/velocity 15–35, p 35–50, mp 50–64,
  mf 64–80, f 80–100, ff 100–127. Longs use CC1 (dynamic crossfade) + CC11 (expression); shorts use velocity.
- **Ensemble patches** (e.g. Albion ONE strings/brass/woods high–low) still represent real instruments:
  validate each line against the instrument it stands for.
- **`data/instruments.json`** (one object per instrument, concert-pitch MIDI):
  - `transposition_semitones`: written→sounding (sounding = written + value).
  - `range_full`: hard limit — notes outside are errors. `range_practical`: outside = warning.
  - `registers[]`: colour zones; `weak_dynamics[]`: zones where a given dynamic/use is weak or risky → warning.
  - Unpitched percussion has `range_full: null` and `range_practical: null` (MIDI note = library key map);
    validators must skip range checks for them. Organ ranges are key numbers at 8' pitch.
  - Values marked "general knowledge" or "[?]" in `notes` are not from the course material.

## Reading order for beginners
1. [[transposing-instruments]] — concert pitch vs written, so no part is mis-transposed.
2. [[string-techniques]] and [[violin]] — the backbone section and the articulation→patch logic.
3. [[horn]] — the blending brass and the mid-register home of orchestral harmony.
4. [[clarinets]] and [[flute-piccolo]] — the two most flexible woodwinds.
5. [[orchestra-sizes-and-section-balance]] — choosing solo/chamber/section patches.
