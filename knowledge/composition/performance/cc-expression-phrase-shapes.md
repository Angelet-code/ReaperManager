---
id: performance.cc-expression-phrase-shapes
title: Expression and dynamics curves over a phrase (measured)
aliases: [curva de expresión, CC11 por frase, forma de frase, reguladores, CC1 dinámica, swell, respiración de frase]
domain: performance
tags: [midi-expression, cc1, cc11, phrasing, measured]
style_scope: sample-library and modelled-instrument mock-ups
use_when: Drawing the CC11 (expression) or CC1 (dynamics layer) curve of a melodic phrase, a sustained line or a section legato.
summary: "Professionals start the phrase already high (60–75 % of its peak), move the curve 100–200 ms before the note-on, reach the target in 100–250 ms, peak in the first half, and fall only 5–25 points at the end. Section dynamics (CSS/CSW CC1) sit around 60–65, rarely above 95."
sources: ["reference-midi-batch1"]
related: ["[[_performance]]", "[[user-taste]]", "[[modeled-instruments-swam]]", "[[dynamics-by-orchestration]]"]
---

# Expression curves over a phrase

## Core idea
A phrase is a breath or a bow. It **starts alive**: the curve is already moving before the attack. It
**peaks early**, holds with small motion, and **releases briefly**. A slow swell from the floor with a
late peak and a deep fade sounds programmed.

## Measured (phrase = notes separated by less than 0.3 s; 20-point normalized shape)
| | start / peak / end | peak position | rise to target | lead before note-on | final fall |
|---|---|---|---|---|---|
| SM brass, CC11 | 86 / 113 / 57 | 0.27 | 215 ms (87–1510) | 110 ms (0–570) | 19 points |
| SM strings demos, CC11 | 23 / 60 / 6 | 0.51 | 975 ms | 0 (0–300) | 24 points |
| SM REVEAL quartet, CC2 | 48 / 76 / 29 | 0.39 | 125 ms | 200 ms | 5 points |
| CSS strings, CC1 | 42 / 66 / 47 | 0.48 | 895 ms | 35 ms | 11 points |
| CSW woods, CC1 | 51 / 79 / 53 | 0.42 | 260 ms | 180 ms | 9 points |

Normalized brass shape (share of the peak): 0.75 → 0.80 flat → 0.69 → 0.52 over the last 15 %. The SM
strings demos (slow solo pieces) arch from 0.36 up to 0.79 and back to 0.31.

## Layers
- **Player** (transferable): R1–R6, which give the start, the peak position and the fall as shares of the peak, plus lead and rise in ms. Use the "normalized shape" row.
- **Library** (not transferable): the absolute levels in the table and R7. Look up the carrier CC and level scale in [[library-translation-table]].

## Rules
- R1 `PREFER` Start a phrase at **60–75 % of its peak** in winds and brass `(measured: sm-brass,
  csw-woods)`. Slow solo strings may start lower (≈ 35 %) `(measured: sm-strings)`.
- R2 `PREFER` **Lead the note-on by 100–200 ms**: put the first CC point before the note
  `(measured: sm-brass, sm-reveal, csw-woods)`.
- R3 `PREFER` Reach the note's target in about **100–250 ms** in winds and brass `(measured)`. Longer
  rises (≈ 0.9 s) are a deliberate swell, typical of slow strings.
- R4 `PREFER` **Peak in the first half** of the phrase (0.25–0.5) `(measured)`.
- R5 `AVOID` deep final fades. Release about **5–25 points** in the last 150–300 ms and let the note-off
  finish the job `(measured)`.
- R6 `PREFER` Small valleys at transitions:
  - about 2–7 points between slurred notes;
  - about 5–12 points at rearticulations `(measured)`.
  Larger dips belong to breaths and bow changes.
- R7 `PREFER` Keep a **section's dynamics layer around 55–70**. Reach 95+ only at real climaxes: under
  10–25 % of the notes in the CSS/CSW demos `(measured)`. CC1 crossfades timbre, so a section that lives
  at 100+ sounds permanently forte.
- R8 `MUST` CC data must be smooth.
  - The references run at **10–100 events per second**, in steps of 1–3. Our builder writes linear ramps
    between a few points, which is equivalent.
  - Never step more than about 4 points without a ramp ([[user-taste]] R2).

## Apply in MIDI / REAPER
- The validated generator values for SWAM soloists and Albion sections are in [[user-taste]] R17:
  - SWAM: 60 % start, 120–150 ms lead, 90–110 ms rise, peak at about 0.37, about 22-point fall;
  - Albion: CC1 = 0.78·v + 6, CC11 + 8.
- **Level scale differs by library.** SM brass demos sit at a CC11 median of 90; SM strings sit at
  48–59. Transfer the shape. Set the level by measuring the render ([[user-taste]] R15).

## Checklist
- Is the first CC point before the first note-on?
- Does the phrase peak before its midpoint, unless it is a deliberate crescendo?
- Is the final fall under about 25 points?
- Do fewer than about a quarter of the section notes sit above CC 95?
