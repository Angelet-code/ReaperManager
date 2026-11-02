---
id: performance.legato-overlap-and-attack-offsets
title: Legato overlaps, slur velocity and attack offsets (measured)
aliases: [solape de legato, ligado, velocidad de legato, retardo de legato, adelantar notas, legato delay, ataques lentos]
domain: performance
tags: [midi-expression, legato, timing, velocity, measured]
style_scope: sample-library and modelled-instrument mock-ups
use_when: Writing slurred lines (overlap length, velocity of slurred notes) or deciding how early to start notes of slow-attack patches.
summary: "Professional overlaps have a median of about 35 ms (p10–p90 about 10–150 ms) on modelled instruments and 50–170 ms on CSS/CSW. Slur velocity follows note length and drops on long, expressive notes. Early starts for slow attacks belong to the library: CSS compensates with a track delay, not per note. Measure Albion before trusting fixed offsets."
sources: ["reference-midi-batch1"]
related: ["[[_performance]]", "[[user-taste]]", "[[modeled-instruments-swam]]", "[[velocity-and-timing-humanization]]"]
---

# Legato overlaps, slur velocity and attack offsets

## Core idea
In a legato patch an **overlap** triggers the transition, and the **velocity of the overlapping note**
chooses its speed or character. These two values are where programmed MIDI most often goes mechanical:
one fixed overlap and one fixed velocity for every slur.

## Measured
| | overlap (ms) | slurred velocity, note < 0.25 s / 0.25–0.5 s / ≥ 0.5 s | slurred leap ≥ 5 st |
|---|---|---|---|
| SM brass | 34 (10–152) | 83 / 74 / 47 | 79 |
| SM strings demos | 36 (17–129) | 68 / 70 / 62 | 86 |
| SM REVEAL quartet | 28 (9–253) | 82 / 65 / 28 | 45 |
| CSW woods | 53 (12–340) | 62 / 49 / 47 | 58 |
| CSS strings | 167 (23–904) | 40 / 41 / 32 | 26 |

- Note-on offsets against the grid are **median ≈ 0 ms** in every group, for slurred notes too:
  - CSS: 2 / 9 ms;
  - CSW: 2 / 2 ms;
  - SM: about 0.
- The spread is wide, with p10–p90 of ±25–50 ms, because the parts are played in.

## Library facts
- **CSS/CSSS**: legato speed is chosen by velocity.
  - Per the manual, as quoted in forums: fast ≈ 100 ms (vel 101–127), medium ≈ 250 ms (65–100), slow
    ≈ 333 ms (0–64).
  - Officially, the transition is delayed "up to around 1/4 s".
  - Users compensate with a negative track delay. The walkthrough MIDI shows no per-note shift.
- **Sample Modeling and SWAM**: velocity on an overlapping note sets the portamento time. Lower velocity
  gives a longer glide. See [[modeled-instruments-swam]].
- **Albion ONE** (measured from renders on 2026-11-02, see [[library-translation-table]]):
  - slur velocity has **no effect**;
  - the middle of the legato transition arrives **225 ms (strings), 150 ms (woods) and 90 ms (horns)**
    after the new note-on;
  - Strings Long reaches −6 dB about 140 ms after the note-on.
  - Our generator's 25/50 ms early starts are therefore too small.

## Layers
- **Player**: whether a transition is slurred and how expressive it is (fast run or vocal leap). Timing spread around the beat.
- **Library**: how long the overlap must be, what slur velocity means (legato speed in CSS, portamento time in SWAM/SM), and the legato or attack delay. Map these per library with [[library-translation-table]]; never copy the velocity numbers across.

## Rules
- R1 `PREFER` **Vary the overlap**: median about 35 ms, range about 10–150 ms. Use longer overlaps on
  slow expressive transitions and shorter on fast runs `(measured)`.
- R2 `MUST` Choose the **slur velocity per note**, from the note's length and the intended transition.
  Never use one value for every slur `(measured: all groups)`.
- R3 `PREFER` Lower the slur velocity on long, expressive notes and on large leaps in slow music. That
  gives a slower, more vocal transition. How low depends on the library: see R17 in [[user-taste]] for
  SWAM, where the floor is 88 and the horn's is 100.
- R4 `PREFER` For slow-attack libraries, **compensate with a track delay or a library-measured shift**,
  not a guessed constant.
- R5 `MUST` A legato patch is monophonic. Overlap only the transition and keep repeated pitches apart, so
  the first note-off doesn't kill the second ([[user-taste]] R13).

## Apply in MIDI / REAPER
- SWAM validated set ([[user-taste]] R17):
  - overlap 28–50 ms;
  - slur velocity 110 / 98 / 88 by note length, ±6, 4 lower on strings, horn at least 100.
- **Measuring Albion's delay**:
  1. Render pairs of slurred notes at velocities 40, 70, 100 and 120 per legato patch with
     `render_audio`.
  2. Find where the second note's energy arrives compared with its note-on (`scripts/analyze_render.py`).
  3. Store the table per patch in [[orchestral-mockup-template]]'s patch notes.

## Checklist
- Do overlaps vary, rather than being one constant?
- Do slur velocities vary with note length?
- Are early-start offsets justified by a measurement for this library?
