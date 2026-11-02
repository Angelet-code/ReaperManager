---
id: orchestration.viola-technique-limits
title: Viola positions, chords, harmonics and pizzicato (playability checks)
aliases: [posiciones de la viola, media posición, extensión, dobles cuerdas de viola, acordes de viola, armónicos de viola, glissando de armónicos, pizzicato de viola, pizzicato de mano izquierda, clave de do en tercera, clave de contralto, Altschlüssel, Bratsche Lagen]
domain: orchestration
tags: [strings, viola, playability, fingering, double-stops, harmonics, pizzicato, validator]
style_scope: universal
use_when: Checking whether a generated viola line, chord, harmonic, pizz or high passage is playable before writing it to MIDI or exporting parts.
summary: Viola fingering equals the violin's a fifth lower but with wider spacing. Keep fast or long passages at or below 3rd position (top ≈ G5, 79) and allow no stretch beyond a P4 inside one hand position. Prefer 3-note, open-spaced chords on open strings. Harmonics speak easily: stopped notes ≤ D5 give touch-4th harmonics ≤ D7 (98). Pizz is rounder than the violin's but hard and wooden above ≈ E5 (76).
sources: ["adler-orq-es p.65-69", "piston-orch p.31, 65-79"]
related: ["[[viola]]", "[[violin-technique-limits]]", "[[string-techniques-stops-and-divisi]]", "[[string-techniques]]", "[[_instruments]]"]
---

# Viola positions, chords, harmonics and pizzicato

## Core idea
Same system as the violin ([[violin-technique-limits]]), but the string is about 2.5 in (≈ 6 cm) longer:
semitones lie farther apart, the hand stretches more and must get round the viola's shoulder to go high.
Large hands and strong fingers are needed, the 4th finger above all.

| String (open) | 1st pos | 3rd pos | 7th pos |
|---|---|---|---|
| C (48) | 48–55 | 53–58 | 60–67 |
| G (55) | 55–62 | 60–65 | 67–74 |
| D (62) | 62–69 | 67–72 | 74–81 |
| A (69) | 69–76 | 74–79 | 81–88 (88 = extended-4th-finger harmonic) |

From Piston Fig. 28 (7th row partly computed). First-position compass 48–76.

## Rules
- R1 `PREFER` fast or long passages at or below 3rd position (≤ 79). `AVOID` higher positions except
  briefly: awkward around the shoulder (Piston).
- R2 `AVOID` long stretches in first position with the arm fully extended: tiring (Piston).
- R3 `MUST` within one position, at most a P4 (5 st) from 1st to 4th finger on a string for stops and
  chords (Piston). No violin-style extensions.
- R4 `ALLOWED` half position, more used than on the violin (wider spacing).
- R5 `ALLOWED` the violin's stop and chord patterns a fifth lower (Adler). All of Adler's charted triple
  stops are first-position.
- R6 `PREFER` 3-note chords over 4-note ones unless a heavy effect is wanted. Open spacing sounds better
  than close position (Piston).
- R7 `PREFER` in tutti, stops and chords built on open strings (48/55/62/69), accented and marcato (d'Indy
  *French Mountain Air*).
- R8 `ALLOWED` harmonics: they speak more easily and reliably than on violin (Adler). Touch-4th
  harmonics are seldom stopped above D5 (74), so they sound at most D7 (98). Leave higher ones to violins.
- R9 `ALLOWED` harmonic glissando on the C string up to the 9th partial, including the flat 7th:
  48 60 67 72 76 79 (≈ 82, flat) 84 86 (Piston; *Rite*).
- R10 `ALLOWED` pizz: rounder and less dry than violin pizz. Above ≈ E5–F5 (76–77) it turns hard and
  wooden, a usable colour. Very high pizz can double winds and harp (Berg *Violin Concerto*).
- R11 `ALLOWED` left-hand pizz (+) on open strings between bowed notes on another string (Berg).
- R12 `AVOID` a trill on open C3 (48) (Piston's open-string rule).
- R13 `MUST` (parts) alto clef by default; treble only for sustained passages above ≈ F5 (77). Players
  read 2–3 ledger lines (to ≈ D5–F5) rather than switching clef often (Piston).
- R14 `PREFER` heavier strokes: détaché and staccato in the lower half of the bow suit the viola better
  than flying spiccato (Piston).

## Apply in MIDI / REAPER
- **String map:** note n on string s if open_s ≤ n ≤ open_s + 19 (A string to 88); strings C G D A. The
  slurred-leap test from [[violin-technique-limits]] applies unchanged: a legato pair must sit on the same
  or adjacent strings.
- **Comfort flag:** notes > open_s + 10 on their highest possible string mean a position above the 3rd.
  Allow them in slow lines; flag them in fast runs.
- **Chord check on one track:** ≤ 3 notes preferred (4 for ff hits). Consecutive strings, lowest ≥ 48,
  neighbours ≤ 12 st apart unless the lower is open. Never two notes both < 55. Otherwise use divisi tracks.
- **Harmonics patch:** write the sounding pitch; it must be ≤ 98, and sounding − 24 must be ≤ 74.
- **Pizz:** velocity carries dynamics. Above 76 expect a dry, wooden sample layer; keep warm pizz in 48–72.

## Checklist
- [ ] Fast passages ≤ 79; nothing above 88 on a section track.
- [ ] Chords: 3 notes, open-spaced, with open strings; P4 maximum hand span.
- [ ] Harmonics ≤ 98; harmonic gliss only on the C-string series.
- [ ] No trill starting from open C3.

## Examples
- Tutti chord: C3–G3–E4 (48 55 64) or G3–D4–B4 (55 62 71), ff marcato, all with open strings.
- High pizz colour: F5 (77) staccato 8ths doubling oboe 1 at the unison, p.
