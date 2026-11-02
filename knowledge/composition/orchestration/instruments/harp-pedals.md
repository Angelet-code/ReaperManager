---
id: orchestration.harp-pedals
title: Harp pedals, enharmonics and pedal-change planning
aliases: [pedales del arpa, colocación de los pedales, diagrama de pedales, afinación de pedales, afinación enarmónica, homófonos, unísono enarmónico, cambio de pedal, Harfenpedal, Pedalwechsel, pédales de harpe, enharmonic harp]
domain: orchestration
tags: [harp, pedals, enharmonics, chromaticism, validation, notation]
style_scope: universal
use_when: Checking whether a harp passage is playable (chromatic notes, pedal changes, enharmonic respelling, two-harp split) or writing the pedal setting into a part.
summary: Each of the 7 letter names has one setting (flat, natural or sharp) in every octave at once, so a passage is playable only if its pitch classes can be assigned to the 7 strings; the D, G and A strings alone sound C#–D–D#, F#–G–G# and G#–A–A#. Respell enharmonically to dodge conflicts, change pedals while that letter is silent and never two on one foot at once, prefer flat settings, and split chromatic music between two harps.
sources: ["unir-orq-tema8 p.4-8", "adler-orq-es p.89-91", "piston-orch p.324-328", "piston-orch p.338"]
related: ["[[harp]]", "[[harp-techniques]]", "[[diminished-seventh-pivot]]", "[[_instruments]]"]
---

# Harp pedals, enharmonics and pedal-change planning

## Core idea
Each pedal has three notches: **up = flat** (open string, longest), **middle = natural** (+1 st),
**down = sharp** (+2 st); one pedal moves **all** strings of its letter. Order: left foot **D C B**, right
foot **E F G A**. What each string can sound (pitch class = MIDI mod 12):

| String | flat | natural | sharp | pitch classes |
|---|---|---|---|---|
| C | Cb | C | C# | 11 0 1 |
| D | Db | D | D# | 1 2 3 |
| E | Eb | E | E# | 3 4 5 |
| F | Fb | F | F# | 4 5 6 |
| G | Gb | G | G# | 6 7 8 |
| A | Ab | A | A# | 8 9 10 |
| B | Bb | B | B# | 10 11 0 |

Derived from the table: pitch classes 2 (D), 7 (G) and 9 (A) exist on one string only; the other nine have
a **homophone** (same pitch on a neighbouring string, e.g. F# = Gb).

## Rules
- R1 `NEVER` two spellings of one letter at the same moment, even in different octaves (C and Cb, F and
  F#): a frequent orchestrator error. Solve it enharmonically: Cb on the B string, C# as Db (Adler, Piston).
- R2 `MUST` one pedal set per passage: ≤ 7 pitch classes, each assigned to its own string. Example: the
  cluster C–C#–D works only as B#, C#, D.
- R3 `AVOID` continuous chromaticism: every chromatic note costs a pedal move. Hardest case: rapid
  successive changes on the same foot (Piston). Flag more than 1–2 changes per bar (inferred).
- R4 `NEVER` two simultaneous changes on the same foot; two on different feet are fine (Adler). Piston
  `[era: 1955]` notes rare exceptions (a foot crossing over, one foot moving two pedals): not for
  generated parts.
- R5 `MUST` move a pedal only while its letter is silent or damped; changes are quick and silent, but give
  each ≥ 1 beat at moderate tempo (inferred) in a rest or under notes of other letters. Moving it while the
  string rings bends the pitch (an effect: [[harp-techniques]]).
- R6 `PREFER` flat settings: strings sound best at full length, so many-sharp passages are played in
  flats (Piston). Harp-friendly keys: Db, Ab, Eb, Bb, F, C (inferred from the same reason).
- R7 `ALLOWED` the harpist takes any note on its homophone to avoid a change. `PREFER` spelling chromatic
  notes by harmonic meaning (double sharps included) and leave string choices to the harpist (Piston).
- R8 `PREFER` fast repeated notes on two homophone strings, alternating (Debussy, *Saint Sébastien*); the
  same trick gives the best trills. Impossible on D, G and A (derived).
- R9 `ALLOWED` enharmonic unison (one pitch on two strings at once) for a fuller low note (Casella).
- R10 `MUST` write the full setting just before each passage and announce each change ahead of the note
  that needs it ("F#, A♮"): seven letters (Cb D E# F G# Ab Bb), letters grouped by foot, or the pedal
  diagram (a line split between the feet; mark above = flat, on = natural, below = sharp).
- R11 `PREFER` with two harps, give each passage to the harp whose pedal set already holds its notes;
  chromatic harmony becomes easy (Piston; assignment inferred).

## Apply in MIDI / REAPER
MIDI carries no spelling; this check decides whether a harpist could play the part.
1. Cut the harp track into passages (rests ≥ 1 beat or chord changes).
2. Collect the pitch classes of each passage. Assign 2→D, 7→G, 9→A first, then give every other pitch
   class a free string (prefer the flat spelling). More than 7 pitch classes, or no free string → move
   notes to `HARP 2`, respell, or rewrite.
3. Between passages, list the letters whose setting changes. For each: its letter silent ≥ 1 beat before
   the note that needs it; no two changes on the same foot at the same instant.
4. Store the set in the item name or a text event, e.g. `PEDALS D C Bb | Eb F G A` (Bb major).

## Checklist
- [ ] No letter needs two settings at once (pitch classes assignable to 7 strings).
- [ ] Pedal changes fall where the letter is silent, with time, never two on one foot together.
- [ ] Fewer than ~2 changes per bar; chromatic stretches split between two harps.
- [ ] Fast repeated notes and trills avoid D, G and A pitch classes (or are slow).

## Examples
- Bb major: D C Bb | Eb F G A. D major: D C# B | E F# G A.
- Line E–F–F#–G: F# must be Gb (the F string is busy), then G needs the G pedal moved Gb→G (right foot)
  between the two notes; fine slowly, awkward fast.
- Ab major (Db C Bb | Eb F G Ab) with a passing B♮: B♮ can only be Cb (C string) or B♮ (B string), and
  both strings are busy with C and Bb → one pedal change in a rest, or give that bar to `HARP 2`.
- Debussy *Faune* gliss set Db C# Bb | E Fb G# A# sounds only Bb, Db, E(Fb), Ab: a Bb half-diminished
  seventh ([[harp-techniques]]).
