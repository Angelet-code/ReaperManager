---
id: orchestration.double-bass
title: Double bass (contrabass)
aliases: [contrabajo, contrabajos, Kontrabass, contrabbasso, contrebasse, bajo, bajo de cuerda, string bass, bass viol, contrabajo solo, bajo armónico, simplificar el bajo]
domain: orchestration
tags: [strings, instrument, ranges, bass-line, transposition, doubling]
style_scope: universal
use_when: Writing, checking or doubling a double-bass part, simplifying a fast cello line for the basses, or deciding how low or high a bass line may go.
summary: Double bass is written an octave above sounding; 4-string bottom E1 (28), C1 (24) only with 5-string or C extension; practical top G3 (55) by default (Adler B3 = 59, Piston D4 = 62; pizz ≤ 59). Slow to speak: default role is the harmonic bass an octave below the cellos, often pizz; give basses a simplified copy of fast cello figures and keep the lowest notes sparing. Techniques and extensions in [[double-bass-techniques]].
sources: ["unir-orq-tema4 p.5-7, 32-40", "apuntes-orq-sesion1 scan p.1-2", "unir-orq-tema1 p.8-11", "adler-orq-es p.9, 11, 83-85, 88", "piston-orch p.98-113"]
related: ["[[double-bass-techniques]]", "[[cello]]", "[[bass-line-doubling]]", "[[string-techniques]]", "[[string-section-writing]]", "[[orchestra-sizes-and-section-balance]]", "[[tuba]]", "[[bassoons]]", "[[transposing-instruments]]", "[[_instruments]]"]
---

# Double bass (contrabass)

## Core idea
Tuned in **fourths**: sounding **E1 A1 D2 G2 (28 33 38 43)**; the only transposing string: written
(bass/tenor/treble clef) an **octave above sounding**. MIDI is concert pitch: write the sounding note.
The hand spans only a whole tone, the strings are thick and long, so it **speaks slower** than any other
string. A section is powerful (Beethoven 5/III trio); a single bass is weak and distant (Mahler 1/III).

| Zone | MIDI (sounding) | Colour / behaviour |
|---|---|---|
| Extension | 24–27 | C1–Eb1: 5-string, C extension or scordatura only ([[double-bass-techniques]]) |
| Low | 28–40 | foundation; slow, heavy; pedals and pizz |
| Middle | 41–55 | clearer, defined lines; best for bass chords and divisi |
| High | 56–62 | effective, intonation-sensitive; approach by step |
| Solo / harmonics | 63–79 | solo lines (≈ 67), natural harmonics to G5 (79) |

**Ranges.** Vault default: full **24–67** (24–27 extension only), practical **28–55**. Variants: Adler
practical orchestral range 28–59, chart filled notes to ≈ 65 [?]; Piston practical bowed top D4 (62),
pizz rarely above B3 (59).

## Rules
- R1 `MUST` design parts for the 4-string bass (lowest 28); 24–27 only with an extension patch and marked
  (see [[double-bass-techniques]] R1–R4).
- R2 `PREFER` default role: the **harmonic bass in octaves with the cellos** (Cb sounding −12 under Vc),
  > 90 % of orchestral music (Piston). If the cellos are busy, bassoons, horns or violas take the upper octave.
- R3 `ALLOWED` independent or melodic bass lines (Beethoven 9/IV, Franck), high undoubled melodies, or
  basses doubling a solo violin an octave below (Prokofiev).
- R4 `PREFER` fast figures shared with the cellos: cellos keep the full figure, basses play a **simplified
  copy**: beat notes or the first note of each group, with rests (Adler, Beethoven 4/IV). The user's ear
  rule agrees: no fast low figures in the basses ([[user-taste]] R16).
- R5 `AVOID` fast figuration in 28–40: slow speech blurs it.
- R6 `PREFER` approach the high register (≥ ≈ 55) by step or small intervals, not big leaps (Adler, Piston).
- R7 `AVOID` long stretches parked on E1–A1 (28–33): the orchestra turns heavy and over-ponderous.
- R8 `MUST` in soft **minor** chords, keep the basses lighter and the minor third (often Vn2) stronger: the
  bass's 5th partial (2 octaves + M3 above it) otherwise suggests a major third (Piston).
- R9 `PREFER` pizzicato often: it lightens and clarifies; pizz basses under arco cellos is a stock device.
- R10 `ALLOWED` long pedals: the section staggers bow changes, so the tone never breaks.
- R11 `PREFER` divide basses in octaves, 5ths or 4ths; `AVOID` smaller intervals low, except for an ominous
  effect (Debussy). Bass chords: open position or upper range (≈ 40–55).
- R12 `NEVER` exactly 2 basses on a section line (UNIR: hard to tune, two soloists): use 1 or ≥ 3.
  Piston still lists "1 desk only" (2 players), "la metà", "4 bassi" to thin the bass for balance.
- R13 `MUST` accompany a solo bass very lightly.
- R14 `PREFER` doublings: Cb + Vc (octave), + tuba/bass trombone in brass tuttis (Wagner), +
  contrabassoon, Cb pizz + harp or timpani on accents (general knowledge).

## Period practice
- `[era: before c.1850]` basses read the cello part an octave lower; Beethoven wrote full doublings of fast
  cello figures for small period orchestras, modern conductors thin them (Adler).
- `[era: Beethoven]` the common 3-string bass bottomed at A1 (33) or G1 (31), yet parts went lower; players
  folded notes up an octave.
- `[era: 1950s]` few 5-string basses, extensions spreading (Piston); today common but not universal.

## Apply in MIDI / REAPER
- Track `Cb` (sounding pitch). Doubling: copy the cello line −12; a note below 28 (24 with extension) folds
  up an octave, but keep the contour if the line is melodic (re-voice the phrase instead).
- Simplify fast copies: keep notes on beats (or the first of each 4-group), lengthen them to the next kept
  note, delete the rest; above ≈ 140 bpm 8ths or any 16ths in 28–40, always simplify.
- Articulation: sustain for pedals (no retriggers); pizz for lightness; spiccato hits nudged 10–20 ms early
  (inferred).
- Dynamics: weight more than loudness; f at CC1 80–100; soft minor chords ≈ 10 CC1 points under Vc/Va.
- Pan: right-rear (≈ R30), reverb-heavy room position.

## Checklist
- [ ] Notes 28–55 normally; 56–62 approached by step; 24–27 only with extension patch.
- [ ] Bass never above the cellos when they share a line; Cb = Vc −12 by default.
- [ ] Fast cello figures copied to Cb are simplified.
- [ ] No long stretches on 28–33; minor soft chords have light basses.
- [ ] Divisi intervals ≥ 4th low; section size 1 or ≥ 3 (or thinned on purpose).
- [ ] Pizz ↔ arco changes have a rest (see [[string-techniques]]).

## Examples
- Cello bass G2–C3–D3–G2 (43 48 50 43) → Cb G1–C2–D2–G1 (31 36 38 31).
- Cello 16ths C3 D3 E3 F3 | G3 F3 E3 D3 (48 50 52 53 | 55 53 52 50) (beats 1–2) → Cb C2 on
  beat 1 and G2 on beat 2 (36, 43), eighths followed by rests.
- Tonic pedal under a tutti: Cb C2 (36) held, sustain patch, CC1 ramp 60→100 over 4 bars.
