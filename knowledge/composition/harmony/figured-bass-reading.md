---
id: harmony.figured-bass-reading
title: Harmonizing a bass and reading figured bass
aliases: [bajo cifrado, cifrado, bajete, bajo sin cifrar, realizar un bajo, armonizar un bajo, Generalbass, bezifferter Bass, Bezifferung, basso continuo]
domain: harmony
tags: [figured-bass, bass-line, procedure, notation]
style_scope: common-practice (figures = baroque/classical notation; the bass-first realization method is general)
use_when: A request gives a bass line (with or without figures) and asks for the chords above it, or a source/score uses figured-bass numbers that must be turned into MIDI pitches.
summary: Figures give intervals above the bass, counted diatonically in the key: no figure = 5/3, 6 = first inversion, 6/4 = second inversion, 7 / 6/5 / 4/3 / 2 = seventh chord in root position and inversions. A lone accidental alters the third; an accidental beside a figure alters that interval. Realize by writing a fluent top melody first, then inner voices.
sources: ["hindemith-1 p.4-11", "hindemith-1 p.12-17", "hindemith-1 p.18-38", "hindemith-1 p.48-52", "hindemith-1 p.60-81", "hindemith-1 p.88-98"]
related: ["[[triads-and-inversions]]", "[[dominant-seventh]]", "[[dominant-ninth-and-thirteenth]]", "[[harmonizing-a-melody]]", "[[voice-leading-basics]]", "[[_harmony]]"]
---

# Harmonizing a bass and reading figured bass

## Core idea
In a figured bass (bajo cifrado) each bass note carries numbers = intervals above it, reduced to the
octave and counted on the scale of the key. An unfigured bass (bajete) must receive a chord on every note,
chosen by the realizer. Hindemith moves from Roman numerals to figures when chords become altered, because
figures describe them without ambiguity.

### Figure table
| Figure | Meaning (above bass) | Chord |
|---|---|---|
| none (5/3) | 3, 5 | root position triad |
| 6 (6/3) | 3, 6 | sixth chord (1st inversion) |
| 6/4 | 4, 6 | 6/4 chord (2nd inversion) |
| 7 (7/5/3) | 3, 5, 7 | seventh chord root position |
| 6/5 | 3, 5, 6 | 7th chord, 1st inversion |
| 4/3 (6/4/3) | 3, 4, 6 | 7th chord, 2nd inversion |
| 2 (4/2, 6/4/2) | 2, 4, 6 | 7th chord, 3rd inversion |
| 9 | 3, 7, 9 (5 omitted) | V9 |
| 7/6/5 · 10/4/2 | — | V9 inversions (3rd / 7th in bass) |
| 13/7 · 11/6/5 · 7/4/2 | — | V13/7 and inversions |

## Rules
- R1 `MUST` A lone accidental under a bass note alters its **third** (in A minor, # under E = G#, the
  leading tone).
- R2 `MUST` An accidental beside a figure alters that interval (#6, #4/2, b7). Read #, b, natural, bb
  literally (this book does not use slashed figures).
- R3 `MUST` A horizontal line under several bass notes = keep the first chord to the end of the line; the bass
  moves meanwhile through passing notes or arpeggio.
- R4 `MUST` Two successive figures over one bass note (8–7, 4–3, 6–5) describe one voice moving, not two chords.
- R5 `MUST` Unfigured bass: build a chord on every bass note.
- R6 `MUST` Realization: write the whole top melody first as a fluent line (not crawling note to note), then
  inner voices.
- R7 `PREFER` Recognise implied functions from chromatic bass/figures: a raised note (#, #6/5, #4/2) usually
  marks a temporary leading tone → secondary dominant of the next chord; b6 bass → V suggests Phrygian or
  augmented sixth; figures like #6/5 on b6 = German sixth.
- R8 Figures get awkward when they must name three altered notes and useless with four; then write notes.
  - *Outside this style:* pop "slash chords" (C/E, G/B) are the modern equivalent of figures: chord / bass
    note (general knowledge).

## Apply in MIDI / REAPER
- Parser: for bass pitch b in key k, each figure n → the scale degree n−1 steps above b's degree (diatonic),
  then apply accidental (+1/−1/natural relative to the key signature). Lone accidental → apply to the 3rd.
- Then build pitch classes, pass them to the voicing search ([[four-part-voices-and-spacing]]) with the bass
  fixed to the given MIDI note.
- Bass in REAPER: if a MIDI bass item exists, read its notes as the fixed bass track; write realised upper
  voices to new tracks, never modify the given bass.

## Checklist
- Every bass note has a chord (unless under a continuation line)?
- Accidentals applied to the right interval (lone = third)?
- Top line written as a melody before the inner voices?

## Examples
- C major: bass C3 (–) D3 (4/3) E3 (6) = I – V4/3 – I6.
- A minor: bass E2 with # = E–G#–B (V); F2 with 6 → E2 with # = Phrygian half cadence.
- C major: bass F#2 with 6/5 = D7 in first inversion (V6/5 of V) → G2.
