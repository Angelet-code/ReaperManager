---
id: orchestration.flute-piccolo
title: Flute, piccolo and alto flute
aliases: [flauta, flautas, flautín, piccolo, ottavino, flauta en sol, flauta alto, Flöte, Querflöte, kleine Flöte, Pikkolo, Altflöte, flûte]
domain: orchestration
tags: [woodwinds, instrument, ranges, registers, transposition]
style_scope: universal
use_when: Writing, checking or doubling a flute, piccolo or alto-flute part in MIDI.
summary: Flute B3/C4–C7 (59/60–96), weak and unable to play loud at 60–63, clear and melodic at 72–84, brilliant up to ≈ 94; the most agile wind. Piccolo sounds an octave above written (74–108), cuts through any tutti; alto flute in G sounds a 4th below written (55–91), best in its soft low octave.
sources: ["unir-orq-tema5 p.4-11", "unir-orq-tema1 p.8-15"]
related: ["[[oboe-english-horn]]", "[[clarinets]]", "[[violin]]", "[[transposing-instruments]]", "[[_instruments]]"]
---

# Flute, piccolo and alto flute

## Core idea
Metal but a woodwind (pre-Böhm flutes were wooden). Unlike the oboe, **flute power grows as it rises**.
Most agile wind instrument (only the piccolo is more agile). Treble clef. Breath is the limit, not fingers.

| Instrument | Written → sounding | Full (sounding) | Practical |
|---|---|---|---|
| Flute (C) | as written | 59 (B foot, optional) / 60 – 96 | 60–93 |
| Piccolo | +12 (sounds 8va) | 74–108 (written D4–C7; written C4 optional on some) | 74–103 |
| Alto flute in G | −5 (P4 lower) | 55–91 (written C4–C7) | 55–86 |

Flute registers: **60–71** low (velvety, soft, easily covered; 60–63 cannot play loud) · **72–83** middle
(much clearer, the default melodic zone) · **84–94** high (brilliant without shrillness up to ≈ A6/Bb6
93–94) · **95–96** extreme (loud only). An extra top note ≈ F7 (101) is printed but unreadable [?].

## Rules
- R1 `AVOID` forte on 60–63 (C4–D#4): weak upper partials; covered by almost anything.
- R2 `PREFER` flute melodies in 72–93 (C5–A6).
- R3 `ALLOWED` scales, arpeggios, register leaps and repeated tonguing at speed (idiomatic).
- R4 `PREFER` long fast or loud high passages split between Fl 1 and Fl 2, overlapping the last note of one
  with the first of the next (Stravinsky *Firebird*): high forte uses a lot of air.
- R5 `AVOID` trills C4–Db4, Db4–Eb4, C#4–D#4, B3–C#4 (foot-joint notes).
- R6 `AVOID` fingered tremolos below G4 (67); `MUST` keep tremolo width ≤ P5 (7 st) in the low octave and
  ≤ M3 (4 st) high.
- R7 `ALLOWED` flutter-tongue (Flatterzunge, frullato): the wind equivalent of string tremolo.
- R8 `PREFER` mainly melodic; for accompaniment chords combine flutes with clarinets and bassoons (blend),
  rarely with oboes.
- R9 `PREFER` doublings: flute + Vln I (unison, or flute 8va for sparkle); flute + clarinet in octaves or
  unison; flute 8va over oboe melody (general knowledge); piccolo + Vln I or flute an octave up.
- R10 `ALLOWED` piccolo middle register for delicate blends; its top cuts through the whole orchestra.
- R11 `PREFER` alto flute in its lowest octave (55–67) where it is most characteristic; keep the texture
  very light — it is as soft as the low flute.
- R12 `ALLOWED` breathing (general knowledge): give a breath (≥ an 8th rest) at least every ≈ 4 bars at
  moderate tempo, more often in high f passages; low-register long notes need more air than they seem.
- Style fact: Baroque flute often just doubles the violins; from the Classical "a 2" orchestra it is
  independent and virtuosic.

## Apply in MIDI / REAPER
- Tracks `Fl 1`, `Fl 2`, `Picc`, `Alto Fl` (all at concert pitch; piccolo patches play sounding pitch).
- Articulations: legato (slurs), sustain, staccato/short (velocity), flutter, trills; runs on a legato patch
  are fine (flute legato is fast), unlike strings.
- Dynamics: low register (60–71) CC1 ≤ 65 and expect it to sound p; high register (84–94) reads f even at
  moderate CC1; do not program ppp sustained notes above 93 (general knowledge).
- Pan: centre-left in the woodwind row.

## Checklist
- [ ] Flute notes 59–96 (59 only with a B-foot patch); mostly 60–93.
- [ ] No sustained f/ff (CC1 > 80) on 60–63; low flute lines have a thin (pp) accompaniment.
- [ ] Piccolo notes 74–108; mostly ≤ 103.
- [ ] Alto flute notes 55–91; not doubled against loud brass.
- [ ] Each wind line has breath gaps (≥ 1 every ~4 bars at moderate tempo).
- [ ] No trills on the foot notes (59–63 pairs listed in R5).

## Examples
- Smetana *Moldau*: running flute 16ths over harp/violin punctuation.
- Ravel *Ma mère l'oye*: low vs middle flute colour; Debussy *Syrinx*: tour of all registers.
