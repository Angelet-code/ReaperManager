---
id: orchestration.natural-horn-period-practice
title: Natural horn — writing horns in period style
aliases: [trompa natural, trompa de mano, tonillos, tonillo, cilindros, bombas, cor simple, corno naturale, Waldhorn, hand horn, crooks, quintas de trompa, horn fifths, cor alto, cor basse, sons factices, Bogen]
domain: orchestration
tags: [brass, horn, period-practice, harmonic-series, crooks, transposition]
style_scope: classical / early-romantic (natural horn c.1750–1850; hand-horn idiom in Brahms and Wagner)
use_when: Writing or checking horn parts "in the manner of" Haydn, Mozart, Beethoven, Schubert, Weber, Brahms or early Wagner, or reading an old part with horn crooks.
summary: A natural horn plays only the harmonic series of its crook, so a period horn line uses written harmonics 2–12 (to 16 from Beethoven on) shifted by the crook's transposition, crooked in the key of the movement; 7, 11, 13 and 14 are out of tune and appear only as soft stopped colour. Horn 1 plays high harmonics, horn 2 low ones, mostly in thirds, sixths and horn fifths.
sources: ["adler-orq-es p.312-317", "piston-orch p.225-232", "piston-orch p.235-237"]
related: ["[[horn]]", "[[transposing-instruments]]", "[[_instruments]]"]
---

# Natural horn: writing horns in period style

## Core idea
Before valves (c.1840, coexisting until about 1900) a horn was one tube whose **crook** fixed the key.
It sounded only its harmonic series; the hand in the bell corrected harmonics and lowered them into dull,
subdued **stopped** notes. Use this note when a period is named; otherwise follow [[horn]].

Written series (any crook, C): harmonic 2 C3 48, 3 G3 55, 4 C4 60, 5 E4 64, 6 G4 67, 7 Bb4 70 (flat),
8 C5 72, 9 D5 74, 10 E5 76, 11 between F5 and F#5 (out), 12 G5 79, 13 A5 81 (flat), 14 Bb5 82 (out of
tune for Adler), 15 B5 83, 16 C6 84. **Good open notes: 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16.**

Crook → sounding offset (sounding = written + offset): C alto 0, Bb alto −2, A −3, Ab −4, G −5, F −7,
E −8, Eb −9, D −10, C basso −12, Bb basso −14, A basso −15. Rare: B alto −1 (Haydn), F# −6 (Haydn
"Farewell"), B basso −13 (Brahms 1), G basso −17 (offsets inferred). "Horn in C" in a
Classical score means C basso (Piston); Adler adds that an unmarked crook is read as alto.

## Rules
- R1 `MUST` crook = key of the movement (most scale notes). Exceptions: a planned modulation where the
  horns are prominent, or a lower crook in a high key (horns in E for A major).
- R2 `MUST` one crook per pair per movement; four horns = two pairs in two keys (Weber *Freischütz*: F + C).
  Berlioz crooked four horns in four keys and passed one line between them to get a near-chromatic line.
- R3 `NEVER` the fundamental (harmonic 1).
- R4 `AVOID` `[era: Classical]` harmonics above 12; on F and higher crooks the 12th is the practical top.
  `ALLOWED` `[era: Beethoven on]` up to 16, easier on low crooks; Brahms and Wagner kept using the top.
- R5 `PREFER` **horn 1 (cor alto)**: written C4–C6, harmonics 4–16. **Horn 2 (cor basso)**: low harmonics,
  typically C3–G4 (2–6), plus the middle of the series.
- R6 `AVOID` harmonics 7, 11, 13, 14 as open notes. `ALLOWED` stopped notes (+) for colour or passing steps:
  half to three-quarters closing lowers a harmonic a semitone, full closing a tone (Piston). Mixed
  open/stopped melodies only convince at **p** (Schubert 9 opening); composers were sparing.
- R7 `PREFER` pairs in thirds, sixths and **horn fifths** (upper 10-9-8 over lower 8-6-5: M3 → P5 → m6);
  this call idiom shaped melody for every instrument.
- R8 `ALLOWED` `[era: natural horn]` low players bent the 2nd harmonic down up to a tritone (factitious
  tones, written B2–Gb2) and played written G2/C2 pedals; modern players avoid them.
- R9 `PREFER` F for a bright period horn, E/Eb/D for a darker one. E/Eb/D were favoured for a time
  (Piston); then players preferred the brighter F, the valve horn's key (Adler, Piston).

## Period practice
- `[era: Haydn/Mozart]` 2 horns, mostly harmonics 3–12, tonic/dominant pedals (with trumpets and timpani:
  general knowledge); topics: the hunt (cor de chasse), comic cuckold jokes in Mozart opera (Adler).
- `[era: Beethoven]` harmonics to 16, bolder stopped notes (Symphony 9 Adagio, 4th horn). Eroica I: the
  written Ab5 topping a rising arpeggio was then probably a partly stopped 13th harmonic; modern players
  stop it fully, getting the sudden piano and the semitone at once (Piston).
- `[era: Schubert, Weber]` hand-stopped melodies at p; four-horn chorales on two crooks.
- `[era: Wagner 1840s]` 2 valve + 2 natural horns (*Rienzi*, *Dutchman*, *Tannhäuser*); in *Lohengrin*
  only, mid-passage "in E / in D" markings meant changing key by valves on an F horn.
- `[era: Brahms, Bruckner]` valve horns playing parts shaped like hand-horn writing (Brahms 3/III);
  they sound better on valve horns. The horn now stands for heroism (Adler).

## Apply in MIDI / REAPER
- Use the normal horn library (open patch). Build each horn's pitch set as written harmonics
  {48, 55, 60, 64, 67, 72, 74, 76, 79, 83, 84} + crook offset; drop 83–84 (harmonics 15–16) for Classical style.
  - F crook (−7): 41 48 53 57 60 65 67 69 72 (76 77).
  - Eb crook (−9): 39 46 51 55 58 63 65 67 70 (74 75).
  - D crook (−10): 38 45 50 54 57 62 64 66 69 (73 74).
- Horn 1 draws from harmonics 4–12, horn 2 from 2–8 (inferred); keep horn 1 above horn 2.
- Stopped notes (outside the set): p, short, stepwise, CC1 about 15 lower or a stopped patch (inferred).
- "Brahms/Wagner manner": write freely with valves, but shape melodies on one crook's series.

## Checklist
- [ ] Every pitch is in its crook's open set, or a stopped note at p.
- [ ] One crook per pair per movement, matching the key (or a stated exception).
- [ ] No fundamental; Classical lines stay at or below harmonic 12.
- [ ] Horn 1 above horn 2; chromatic lines only by passing between differently crooked horns.

## Examples
- Horn fifths, horns in D (sounding): Hn1 F#4 E4 D4 (66 64 62) over Hn2 D4 A3 F#3 (62 57 54).
- Tonic pedal for a D-major Classical tutti: horns in D, written C4 + C5 → sounding D3 + D4 (50, 62).
