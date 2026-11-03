---
id: orchestration.double-bass-techniques
title: Double-bass techniques (low extension, 5-string, scordatura, fingering, harmonics, bowing, pizzicato)
aliases: [contrabajo de cinco cuerdas, extensión de Do, extensión de Mi, máquina de Do, scordatura, contrabajo de tres cuerdas, armónicos de contrabajo, pizzicato de contrabajo, arco alemán, arco francés, sordina de contrabajo, 5-string bass, C extension, Kontrabass fünfsaitig]
domain: orchestration
tags: [strings, double-bass, technique, extension, scordatura, harmonics, pizzicato, bowing]
style_scope: universal
use_when: A bass part goes below E1 (28), needs harmonics, double stops, special bowings, tremolo or pizzicato, or you must check whether a bass figure is playable.
summary: Below E1 a bass needs a 5-string, a C extension (both to C1 = 24) or scordatura (Eb1/D1 practical); write such passages in octaves and mark "only basses with low C". Hand spans a whole tone (fingers 1-2-4), so keys around the open strings are easiest. Natural harmonics are excellent (partials of 28/33/38/43); artificial ones are impractical. Bowing is heavy: slurs ≈ 1 bar at f; tremolo, col legno and trills are idiomatic; pizz to ≈ B3 (59).
sources: ["unir-orq-tema4 p.32-40", "adler-orq-es p.9, 11, 83-85, 88", "piston-orch p.98-108"]
related: ["[[double-bass]]", "[[cello-techniques]]", "[[string-techniques]]", "[[string-techniques-stops-and-divisi]]", "[[transposing-instruments]]"]
---

# Double-bass techniques

## Core idea
Back to [[double-bass]] for ranges, roles and balance. This note answers "can the basses play this?".
Open strings sound **28 33 38 43**; written an octave higher (harmonics in treble clef are an exception:
written at pitch, Piston).

## Rules
**Below E1: extension, 5-string, scordatura**
- R1 `MUST` treat the 4-string bass (bottom 28) as the normal instrument (Piston). Ways down: a **5th
  string** tuned to C1 (24), a **mechanical C extension** of the E string (keys stop C#–E, down to 24), or
  **scordatura** of the E string. Adler blends the first two as one option.
- R2 `ALLOWED` scordatura E→Eb1 (27) or D1 (26): practical, easier with machine heads. `AVOID` it as a
  general solution: it upsets the instrument and a slack string sounds poor.
- R3 `PREFER` when notes 24–27 are needed, write the passage **in octaves** (div.): the 24–27 line for basses
  with low C, the same line +12 for the others; mark "only 5-string / low-C basses" or "not 8va", so
  players do not fold notes up (Piston: Strauss *Zarathustra* shows folding breaks the contour).
- R4 `AVOID` relying on 24–27 as the only bass: assume only one or two players (or none) have them.

**Fingering**
- R5 `MUST` budget for many shifts: 1st→4th finger spans a **major 2nd**; positions 1–5 use fingers
  1-2-4 (3 goes with 4); 3 independent from about 6th position; thumb from 7th (Adler, Piston).
- R6 `PREFER` keys around the open strings (E, A, D, G, C): G major needs far fewer shifts than B major.
  Fast lines in remote keys: slow or simplify.
- R7 `PREFER` stepwise approach to high notes; large leaps upward force repositioning on long strings.

**Double stops and chords**
- R8 `ALLOWED` double stops: Adler, only those with an open string are practical; Piston adds stopped
  3rds, 4ths and 5ths. Either way they are rare orchestrally (Kodály *Galánta*: parallel 5ths, ff).
- R9 `PREFER` dividing chord notes between players; small intervals low sound poor (see [[double-bass]] R11).

**Harmonics**
- R10 `PREFER` natural harmonics: easy, excellent quality, mid register. On the G string (43): 55 62 67 71
  74 79; other strings a 4th / 7th / 10th lower (D: 50 57 62 66 69 74). The minor-3rd node (6th partial,
  +31) speaks better on the bass than on any other string.
- R11 `AVOID` artificial harmonics: high positions only, impractical in the orchestra.
- R12 `ALLOWED` harmonic melodies and chords at pp (Ravel *Tombeau*; Stravinsky *Concerto in D*: 4 solo
  basses + 1 cello).

**Bowing**
- R13 `ALLOWED` every stroke of the other strings, with more inertia (short heavy bow, thick strings).
  German (underhand) or French bow: the player's choice, no effect on the part.
- R14 `AVOID` over-long slurs: ≈ 1 bar at f; a full section at p tolerates longer ones than a solo bass.
- R15 `PREFER` staccato on the string; controlled spiccato is feasible and common; light, delicate passages
  are possible for a modern section (Strauss *Don Juan*).
- R16 `ALLOWED` sul tasto, sul ponticello, bowed tremolo (very common, often sul tasto/pont.), col legno
  (more musical on bass, more resonance), all major/minor trills. `AVOID` fingered tremolo in low
  positions; a minor 3rd works above 2nd position.

**Pizzicato and mutes**
- R17 `PREFER` pizz much more often than other strings; top rarely above sounding B3 (59). `AVOID` careless
  low pizz at loud dynamics: booming thud.
- R18 `ALLOWED` mutes (heavy) for a veiled bass or to match muted strings (Ravel *La Valse* opening: muted
  basses div. a 3, tremolo + pizz).

## Period practice
- `[era: Classical]` 3-string basses (bottom A1/G1); low notes were folded up an octave: for period sound,
  keep the written line in the cellos and let basses fold (Piston).
- `[era: 19th c.]` long pedals over many bars with staggered free bow changes.
- `[era: 1950s]` gut G/D strings, metal sets new (Piston): today metal is the norm, faster response.

## Apply in MIDI / REAPER
- Below 28: two tracks or two voices: `Cb low` (24–27, only if the patch has them) + `Cb` at +12.
- Harmonics: harmonics articulation, pp–p, only the R10 pitch sets; slow notes (inferred).
- Tremolo pedal: tremolo patch, CC1 20–60 swell, 28–43 for suspense (inferred).
- Pizz: velocity 60–95; ≥ 100 low only for a deliberate thud (inferred).
- Legato phrases: break into ≤ 1-bar slurs at f (release/re-attack), longer at p.

## Checklist
- [ ] No note < 28 without an octave-doubled alternative and an extension patch.
- [ ] Double stops include an open string (or a 3rd/4th/5th), otherwise divisi.
- [ ] Harmonic pitches are open-string partials; no artificial harmonics.
- [ ] Pizz ≤ 59; legato slurs ≤ 1 bar at f.

## Examples
- Low C cadence: `Cb low` C1 (24) whole note + `Cb` C2 (36), marked "low C only".
- Harmonic pp: G string partials D4 (62) → G4 (67) → B4 (71), slow, with cello harmonics above.
