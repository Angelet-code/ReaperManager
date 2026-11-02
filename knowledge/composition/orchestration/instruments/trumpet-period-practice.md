---
id: orchestration.trumpet-period-practice
title: Natural and valved-F trumpet — writing trumpets in period style
aliases: [trompeta natural, clarín, clarino, arte del clarino, trompeta barroca, trompeta clásica, trompeta de válvulas en fa, trompeta en fa, tonos, varas de entonación, cuerpos de recambio, Naturtrompete, tromba naturale, trompette naturelle, crook]
domain: orchestration
tags: [brass, trumpet, period-practice, harmonic-series, crooks, transposition]
style_scope: baroque / classical / romantic (natural trumpet c.1700–1850; valved F trumpet c.1850–1900)
use_when: Writing trumpets in the manner of Bach/Handel, Haydn–Beethoven or Wagner/Bruckner/Mahler, or reading an old part written in a crook key.
summary: A natural trumpet plays only its crook's harmonic series. Baroque clarino runs diatonic 16ths on partials 8–16; Classical parts use partials 3–12 only (the 7th and 11th are doubtful) as tonic/dominant pedals, fanfares and tutti accents locked to the timpani, taking any chord tone available. Crook offsets F +5, E +4, Eb +3, D +2, C 0, Bb −2, A −3. The 19th-c. valved F trumpet (concert 54–84) gives the big, noble late-Romantic sound.
sources: ["adler-orq-es p.298-303", "adler-orq-es p.326-330", "piston-orch p.209-214", "piston-orch p.246-253"]
related: ["[[trumpet]]", "[[trumpet-family-auxiliary]]", "[[brass-basics]]", "[[natural-horn-period-practice]]", "[[timpani]]", "[[transposing-instruments]]", "[[_instruments]]"]
---

# Natural and valved-F trumpet: writing trumpets in period style

## Core idea
Use this note only when a period is named; otherwise follow [[trumpet]]. Before valves the trumpet was
one long tube (the Classical C trumpet was 8 ft, twice the modern one) whose **crook** set the key. It
sounds only its series; unlike the horn, no hand in the bell can correct it.

**Written series, partials 3–12** (any crook): G3 55, C4 60, E4 64, G4 67, (Bb4 70, flat 7th), C5 72,
D5 74, E5 76, (F/F#5 ≈ 77–78, 11th), G5 79. **Concert = written + crook offset:**

| Crook | Offset | Concert notes, partials 3–12 (doubtful in brackets) |
|---|---|---|
| F | +5 | 60 65 69 72 (75) 77 79 81 (83) 84 |
| E | +4 | 59 64 68 71 (74) 76 78 80 (82) 83 |
| Eb | +3 | 58 63 67 70 (73) 75 77 79 (81) 82 |
| D | +2 | 57 62 66 69 (72) 74 76 78 (80) 81 |
| C | 0 | 55 60 64 67 (70) 72 74 76 (78) 79 |
| Bb | −2 | 53 58 62 65 (68) 70 72 74 (76) 77 |
| A | −3 | 52 57 61 64 (67) 69 71 73 (75) 76 |

B (−1) existed; G or Ab were rare and played on common crooks (Adler, Piston).

## Rules
- R1 `ALLOWED` `[era: Baroque clarino, c.1700–1750]` fast diatonic 16th runs and trills on partials 8–16
  (written C5–C6), where the series is a scale. Players lipped the 11th and 13th/14th into tune (Bach
  *Brandenburg 2*, Cantata 51, *Christmas Oratorio*). Specialists reached the 21st (Piston). Today these
  parts are played on D/Eb or piccolo trumpets.
- R2 `MUST` `[era: Classical, c.1750–1820]` partials 3–12 only; `NEVER` above the 12th (written G5).
  `NEVER` the pedal; `AVOID` the 2nd partial (unreliable; Mozart notated it in bass clef, an octave low by
  horn convention) and the 3rd on low crooks (Piston).
- R3 `AVOID` the flat 7th and the 11th (between F and F#, lipped). `ALLOWED` rarely: Beethoven 9 repeats
  the 7th.
- R4 `PREFER` the crook in the movement's key; crooks above F are rare. G major: C trumpets or none;
  A major: D trumpets (Beethoven 7).
- R5 `PREFER` Classical material: long tonic/dominant notes in octaves, rhythmic punctuation, one- or
  two-note patterns, the tutti flourish with timpani and horns, and themes built on the series so the
  trumpets can join (Beethoven 5/ii).
- R6 `PREFER` in loud tutti chords, give both trumpets whatever chord tone exists, even a unison, and accept
  odd voice-leading (Beethoven 6/v: both on D for D minor; a major-9th leap). Otherwise rest them;
  `NEVER` give them non-series notes.
- R7 `ALLOWED` soft trumpets with timpani, a delicate colour (Beethoven 1/ii, pp octave G).
- R8 `PREFER` `[era: Classical]` sparing trumpets: orchestras used the natural horn more because it is
  less piercing. Concertos (Haydn, Hummel) still exploited the trumpet fully (Adler).
- R9 `[era: c.1850–1900]` the valved F trumpet is chromatic from partials 3–12: written C#3–G5, concert
  54–84 (+5). `PREFER` it for broad, noble melodies and marcato chorales (Bruckner 7, Mahler 2);
  `AVOID` its lowest fifth for melody (poor quality, Piston). It swamped the other brass and gave way to
  the small C/Bb trumpets around 1900 (Adler).
- R10 `[era: late 19th c.]` parts kept being written "in E, Eb, D…" and players transposed. Strauss's
  advice: write in C (Adler's account) or in whichever key makes the part look closest to C major
  (Piston's account).

## Apply in MIDI / REAPER
- Pick the crook, filter every trumpet note to its concert list; skip the bracketed notes on long or
  exposed values.
- Classical flourish: TPT 1–2 on tonic/dominant fanfare rhythms, horns an octave below or in unison,
  timpani on the same tonic/dominant ([[timpani]]); see [[natural-horn-period-practice]].
- Level: the long Classical trumpet was less piercing, so play its unison doublings a step below modern ff
  (CC1/velocity ≈ 10–15 lower; Piston, inferred).
- Baroque clarino in D: concert partials 8–16 = 74 76 78 79* 81 83* 84 85 86 (* lipped), bright patch,
  detached 16ths, trills on long notes.
- Late Romantic: chromatic writing allowed, broad marcato at f–fff, low notes for weight only.

## Checklist
- [ ] Every trumpet note is in the crook's list (Classical) or partials 8–16 (Baroque clarino).
- [ ] No note above the 12th partial in a Classical part; no pedals.
- [ ] Trumpets double timpani/horns on tonic and dominant, rest in remote harmony.

## Examples
- Haydn-style tutti in D, D trumpets: I = 74/62, V = 69/57, I = 74/62 (TPT 1/2) in quarter-note
  flourishes with timpani D3/A2 (50/45); on a ii chord (Em) both take 76 or rest.
- Beethoven-style pp: C trumpets hold G3/G4 (55/67) under a dotted timpani rhythm.
