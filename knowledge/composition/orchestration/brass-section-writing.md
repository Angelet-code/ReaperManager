---
id: orchestration.brass-section-writing
title: Brass section writing (chords, doubling, balance)
aliases: [sección de metal, metales, escritura para metales, escritura homófona de metales, coral de metales, acorde de metales, duplicación de las trompas, dos trompas igual a una trompeta, acorde oscuro, metales con cuerda y madera, Blechbläsersatz, Blechbläser, cuivres, brass choir, brass chorale, a2, a4]
domain: orchestration
tags: [brass, section, voicing, doubling, balance, chorale, homophony, tutti]
style_scope: universal (modern symphonic default; period variants in brass-section-writing-period-practice)
use_when: Voicing a chord or chorale for the whole brass section, balancing horns against trumpets and trombones, or doubling a brass chord with strings and woodwinds.
summary: The brass has four jobs (homophonic block, melody, climax builder, special colour) and over-use flattens every climax. At mf or softer give each player its own note; above mf two horns equal one trumpet or trombone, so pair the horns. Default voicing top-down is trumpets, horns below or interlocked, trombones in the tenor, tuba an octave under the lowest trombone.
sources: ["adler-orq-es p.357-375", "adler-orq-es p.403-406", "piston-orch p.206-208", "piston-orch p.216-222", "piston-orch p.244-245"]
related: ["[[brass-section-writing-melody]]", "[[brass-section-writing-counterpoint]]", "[[brass-section-writing-effects]]", "[[brass-section-writing-period-practice]]", "[[brass-basics]]", "[[horn]]", "[[trumpet]]", "[[trombone]]", "[[tuba]]", "[[chord-voicing-family-stacking]]", "[[texture-part-writing-chorale]]", "[[building-and-releasing-climaxes]]", "[[tutti-balance-by-role]]", "[[orchestral-mockup-template]]", "[[user-taste]]"]
---

# Brass section writing

## Core idea
Modern standard section (Piston, Adler): **4 horns, 3 (or 2) trumpets, 3 trombones (2 tenor + bass),
1 tuba**, up to 11 voices, so a four-part chord carries many doublings. Adler gives the section four
jobs: a homophonic block, a melody carrier (see [[brass-section-writing-melody]], [[brass-section-writing-counterpoint]]),
a climax builder ([[building-and-releasing-climaxes-symphonic]]) and a source of special colours
([[brass-section-writing-effects]]). Full brass can drown the whole orchestra.

## Rules
- R1 `AVOID` loud brass all through a piece: it eclipses the orchestra, turns grandiloquent and tedious,
  and leaves the real climax nothing new (Adler).
- R2 `PREFER` at **mf or softer, one note per player**. Balance then follows each instrument's place in
  its own register (a note in a strong register sounds louder).
- R3 `MUST` above mf, **2 horns ≈ 1 trumpet ≈ 1 trombone** (Adler; Piston: one horn is covered by a
  trumpet or trombone). Give each chord tone that a single trumpet or trombone carries two horns. With
  4 horns and 2 trumpets, the horns cover 2 notes a2.
- R4 `ALLOWED` a trumpet in its low register is weaker, so it needs fewer horns per note (Adler; link R3).
- R5 `PREFER` the standard layout (Adler):
  - trumpets on the top chord tones;
  - horns directly below the trumpets or interlocked with them, voiced Hn1 > Hn3 > Hn2 > Hn4 ([[horn]]);
  - trombones in close or open position in the tenor–bass register;
  - tuba alone at the bottom, usually an octave below the lowest trombone, often on the root.
- R6 `ALLOWED` the woodwind layouts also work for brass: juxtaposition, interlocking, enclosure and
  partial overlap ([[chord-voicing-family-stacking]]).
- R7 `ALLOWED` **dark chord** at p: trumpets low and close, horns inside the chord, Hn4 down next to the
  trombones, the whole chord low and closed (Adler).
- R8 `PREFER` let 2 bassoons + contrabassoon complete and double the bass, so trombones 1–2 can sit in
  their brilliant register instead of holding low chord tones (Ravel, *Great Gate of Kiev*).
- R9 `PREFER` for a rich tutti, double the brass chord at the octave and double octave in woodwinds and
  strings (Elgar, *Enigma* "W.M.B."). `ALLOWED` doubling only selected notes gives a flickering colour;
  switch to strict octave doubling of every part to crown the climax (Bruckner 7, finale).
- R10 `AVOID` close six-voice brass low in the trombones at a phrase end: it muddies (inferred from Adler on
  Stravinsky's *Vom Himmel hoch*).
- R11 `NEVER` make strings and woodwinds compete with full brass. In a climax, size the brass to what the
  strings and woodwinds can reach, and fix balance by scoring (doubling, register) before you mark the
  brass softer (Piston).
- R12 `ALLOWED` soft brass: ppp chorales (Dvořák 9, Largo) and p trombone chords with < > swells under a
  string line (Schubert, *Rosamunde*). Brass need not be loud.
- R13 `MUST` plan breaths in homorhythmic progressions: a breath gap sounds different from a tongued
  re-attack (Piston). Give regular rests ([[brass-basics]], [[user-taste]] R16).

## Apply in MIDI / REAPER
- Tracks (from [[orchestral-mockup-template]]): `HN LEGATO/LONG/SHORT`, `TPT LEGATO/SHORT`,
  `LOW BRASS LONG/SHORT` (trombones + tuba). An "a4" horn patch is already a doubled section, so one
  note on it weighs roughly one trumpet note (inferred).
- **ff C major, 3 tpt + 4 hn + 3 tbn + tuba:** Tpt G5 79, E5 76, C5 72; Hn1+3 G4 67, Hn2+4 E4 64;
  Tbn C4 60, G3 55, B.Tbn C3 48; Tuba C2 36.
- **mf, horns on independent notes:** Tpt E5 76, C5 72; Hn1 G4 67, Hn3 E4 64, Hn2 C4 60, Hn4 G3 55;
  Tbn E3 52, C3 48, B.Tbn G2 43; Tuba C2 36.
- **Dark chord, p, C minor:** Tpt G4 67, Eb4 63; Hn1 C4 60, Hn3 G3 55, Hn2 Eb3 51, Hn4 C3 48;
  Tbn G2 43; B.Tbn + Tuba C2 36. CC1 30–40.
- Dynamics follow [[dynamics-by-orchestration]]: ff = CC1 100–112, mf = 60–70. Per
  [[tutti-balance-by-role]], trumpets sit a few CC1 points below the horns under them.
- Chorale breaths: a 1/8–1/4-beat gap at phrase ends; inside a phrase, re-attack with no gap. Albion
  horn legato breathes every ~8 s with a 220 ms gap ([[user-taste]] R17).
- In a climax, render brass, string and woodwind stems and check that strings and woods stay audible
  (Piston). If they do not, lower the brass bed first ([[user-taste]] R15).

## Checklist
- [ ] Is full brass kept for the climax and not used for long stretches?
- [ ] Above mf, are there two horns (or an a4 patch line) for each single trumpet or trombone note?
- [ ] Are trumpets on top, horns 1 > 3 > 2 > 4 below, and the tuba alone at the bottom (an octave under the lowest trombone, or on the root)?
- [ ] Is the bass carried by bassoons or tuba so that the trombones are not stuck low?
- [ ] Are there no close low trombone clusters at phrase ends?
- [ ] Do chorales have planned breath gaps and regular rests?
- [ ] Do strings and woods stay audible in the climax render?

## Examples
- Musorgsky–Ravel, *Great Gate of Kiev*: a brass chorale over bassoons and contrabassoon; the woodwind
  choir answers, then the brass returns at p under it.
- Bruckner 7, finale: intermittent string and woodwind doubling of a brass chorale, then strict octave
  unison at fff.
