---
id: performance.velocity-and-timing-humanization
title: Timing and velocity humanization (measured)
aliases: [humanizar, humanización, timing humano, velocidad humana, desfase, suena a MIDI, cuantizado]
domain: performance
tags: [midi-expression, timing, velocity, humanize, measured]
style_scope: orchestral mock-ups (for pop/rock groove see user-taste R6 and R14)
use_when: Deciding how much timing and velocity variation an orchestral part needs, or checking whether a part sounds quantized.
summary: "Played-in professional parts sit around the grid with a median offset of about 0, but a p10–p90 spread of ±25–45 ms, and only 6–14 % of the notes land within 3 ms of the grid. Short-note velocity has a standard deviation of about 20–26, with a small strong-beat accent. Our earlier ±4–6 ms was far too tight."
sources: ["reference-midi-batch1"]
related: ["[[_performance]]", "[[user-taste]]", "[[legato-overlap-and-attack-offsets]]"]
---

# Timing and velocity humanization

## Core idea
Real players are not random: they sit around the beat, push and pull with the phrase, and accent with
the metre. The measurable signature is a **wide but centred timing spread** and a **velocity spread of
about ±20**. A part within ±5 ms of the grid and ±4 velocity is what "suena a MIDI" means
([[user-taste]] R1).

## Measured
| | notes within 3 ms of grid | attacked offset (ms) | short-note velocity strong / weak beat | velocity sd |
|---|---|---|---|---|
| CSS strings | 6 % | 2 (−42…49) | 82 / 69 | 26 |
| CSW woods | 7 % | 2 (−33…32) | 67 / 67 | 20 |
| SM brass | 14 % | 1 (−28…31) | 91 / 85 | 25 |
| SM REVEAL quartet | 11 % | −1 (−25…23) | 86 / 87 | 25 |
| SM strings demos | 52 % (some files quantized) | 0 (−23…23) | 80 / 90 | 24 |

Note length relative to the time to the next note-on (duration / IOI) has a median of about 1.0 in
legato-heavy woods and brass, and about 0.5 on short string figures.

## Layers
- **Player** (transferable): timing spread, chord grouping and the share of notes on the grid.
- **Library** (not transferable): which velocity range gives which dynamic layer. A velocity sd of about 20 means different dB in different libraries, so see [[library-translation-table]].

## Rules
- R1 `PREFER` Humanize timing to a **p10–p90 spread of about ±15–30 ms** around the grid, with a median
  near 0. Use a triangular or Gaussian distribution, never uniform jitter at the extremes `(measured)`.
- R2 `PREFER` Move **chords together**: notes within about 15 ms are one event, as `humanize_midi` does.
  Let a phrase drift slowly rather than every note jumping independently.
- R3 `PREFER` Give short notes a **velocity standard deviation of about 15–25**, led by the musical line
  and the metre, not by noise. The strong-beat accent is small, about 0–13 points `(measured)`.
- R4 `AVOID` a fixed global offset per articulation that is not measured for the library (see
  [[legato-overlap-and-attack-offsets]]).
- R5 `ALLOWED` Tight timing for deliberately mechanical styles (ostinato engines, hybrid percussion,
  pop/rock grids). See [[user-taste]] R6 and R14 for groove.

## Apply in MIDI / REAPER
- Generators: SWAM soloists use `rr(14) + rr(10)` ms, a triangular ±24 ms. This was validated in
  [[user-taste]] R17.
- Existing tracks: `humanize_midi` with `timing_ms` 12–20 (random ±), `drift_ms` 8–15 and `velocity`
  6–10. It keeps chords together.
- To check a part, run `scripts/analyze-reference-midi.mjs`. The "cuantizado" share should stay under
  about 20 % for played orchestral lines.

## Checklist
- Are fewer than about 20 % of the notes exactly on the grid in an expressive part?
- Is the timing spread about ±15–30 ms and centred?
- Does short-note velocity vary meaningfully (sd ≥ 15) and follow the line?
