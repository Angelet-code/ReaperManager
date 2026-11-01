---
id: orchestration.double-bass
title: Double bass (contrabass)
aliases: [contrabajo, contrabajos, Kontrabass, contrabbasso, contrebasse, bajo]
domain: orchestration
tags: [strings, instrument, ranges, bass-line, transposition]
style_scope: universal
use_when: Writing, checking or doubling a double-bass part, or deciding how low a bass line may go.
summary: Double bass is written an octave above sounding; sounding E1 (28) is the bottom of a 4-string bass, C1 (24) with 5th string or C extension; practical top ≈ G3 (55). Slow to speak: default role is the bass line an octave below the cellos, often in pizzicato; never use exactly two basses.
sources: ["unir-orq-tema4 p.5-7, 32-40", "apuntes-orq-sesion1 scan p.1-2", "unir-orq-tema1 p.8-11"]
related: ["[[cello]]", "[[bass-line-doubling]]", "[[string-techniques]]", "[[orchestra-sizes-and-section-balance]]", "[[tuba]]", "[[bassoons]]", "[[transposing-instruments]]", "[[_instruments]]"]
---

# Double bass (contrabass)

## Core idea
Tuned in **fourths**: sounding **E1 A1 D2 G2 (28 33 38 43)**. Written like the cello (bass, tenor, treble
clefs) but **sounds an octave lower** (written→sounding −12). MIDI is concert pitch: write the sounding
note. Hand spans only a whole tone, so shifts are frequent; all bow strokes work but the response is slow.

| Zone | MIDI (sounding) | Colour / behaviour |
|---|---|---|
| Extension | 24–27 | C1–Eb1, only 5-string or C-extension basses (from late 19th c.; not universal) |
| Low | 28–40 | foundation; slow speech, heavy; best sustained or in pizz |
| Middle | 41–55 | clearer, more defined bass lines; the figure's top stopped note is sounding G3 (55) |
| High | 56–67 | thin, soloistic (Mahler 1/III solo territory) (general knowledge) |
| Harmonics | up to ≈ 79 | written ≈ G6 [approx.]; effect only |

Full range **24–67** (24–27 extension only), practical **28–55**.

## Rules
- R1 `MUST` treat notes 24–27 as available only with a 5-string/extension patch; otherwise lowest is 28.
- R2 `PREFER` default role: bass line an octave below the cellos (until the 19th c. both read one staff).
  Independent bass lines grow from the 19th c.; occasional melodies (Beethoven 9/IV recitative).
- R3 `ALLOWED` pizzicato doubling of the cellos' arco line; pizz is used more habitually than in other strings.
- R4 `ALLOWED` long pedal notes: players stagger bow changes so there is no gap.
- R5 `AVOID` fast figuration in 28–40: the low strings speak slowly and blur; give fast bass motion to the
  cellos and let basses take the downbeats (inferred from slow response).
- R6 `ALLOWED` double stops (3rds, 4ths, 5ths, or any interval with an open string), rarely used orchestrally.
- R7 `NEVER` use exactly 2 basses: hard to tune, sounds like two soloists; use 1 (solo/reinforcement) or ≥ 3.
  One solo bass can reinforce the cello line at unison or an octave below.
- R8 `PREFER` doublings: Cb + Vc (octave), Cb + tuba or bass trombone in brass tuttis, Cb + contrabassoon
  (sub-octave colour), Cb pizz + harp or timpani for bass accents (general knowledge for the last two).
- R9 `AVOID` close-position harmony in 28–47 between basses and other low instruments: intervals smaller
  than a 5th sound muddy that low (general knowledge).

## Apply in MIDI / REAPER
- Track `Cb` (sounding pitch). Doubling the cellos: copy the cello line and transpose −12; if that drops a
  note below 28 (or 24 with extension), fold just that note up an octave.
- Articulations: long/sustain for pedals (no retriggers), pizz for light doubling, spiccato/staccato for
  short bass hits (slow attack: may need notes nudged 10–20 ms earlier, inferred), tremolo for tension.
- Dynamics: low basses build weight more than loudness; reach f with CC1 80–100 and let cellos/tuba add bite.
- Pan: right-rear (≈ R30), reverb-heavy room position.

## Checklist
- [ ] All notes within 28–67 (24–27 only if the patch is 5-string/extension).
- [ ] Most notes within 28–55.
- [ ] Fast passages (8ths above ~140 bpm or any 16ths) in 28–40 are avoided or simplified.
- [ ] Bass never above the cello line when they share material.
- [ ] Section size is 1 or ≥ 3 players (patch choice), not 2.
- [ ] Pizz ↔ arco changes have a rest (see [[string-techniques]]).

## Examples
- Cello bass G2–C3–D3–G2 (43 48 50 43) → bass G1–C2–D2–G1 (31 36 38 31).
- Tonic pedal under a tutti: Cb C2 (36) held, sustain patch, CC1 ramp 60→100 over 4 bars.
