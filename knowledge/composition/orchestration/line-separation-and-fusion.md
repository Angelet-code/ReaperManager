---
id: orchestration.line-separation-and-fusion
title: Separation vs fusion of lines
aliases: [separación de líneas, fusión, asociación, independencia de voces, claridad, enmascaramiento, contrapunto separación asociación]
domain: orchestration
tags: [separation, fusion, counterpoint, clarity, mix]
style_scope: universal (method from film scoring)
use_when: Two or more simultaneous lines must be heard as different things (melody vs countermelody, theme vs ostinato), or several instruments must fuse into one gesture.
summary: Lines separate when they differ in the main parameters (rhythm/articulation, register, timbre) and fuse when they share them. Dynamics, contour and articulation are secondary, and pan and depth are a mix-stage extra. The fewer parameters two lines share, the more independent they sound; to make lines independent, change at least one main parameter, ideally two.
sources: ["film-4day-challenge slide 5", "unir-orq-tema3 p.13-14", "unir-orq-tema2 p.7-10"]
related: ["[[texture-counterpoint]]", "[[texture-secondary-melody-countermelody]]", "[[doubling-colour-and-decay]]", "[[stage-seating-pan-depth]]", "[[texture-complex-mosaic]]"]
---

# Separation vs fusion of lines

## Core idea
The ear groups sounds that share rhythm, register and colour into one stream. That **fusion**
(association) is what you want for doublings and unisons. **Separation** is what you want for
counterpoint, countermelodies, and theme vs ostinato. You control it with a small set of parameters.

## Parameters
| Rank | Parameter | Separate by… | Fuse by… |
|---|---|---|---|
| Main | Rhythm / articulation | different onsets, long vs short | identical rhythm |
| Main | Register | ≥ an octave apart, no crossing | same octave |
| Main | Timbre / colour | different families (brass vs strings) | same family or blending pair |
| Secondary | Dynamics | one level apart | equal |
| Secondary | Direction / contour | contrary or oblique motion | parallel motion |
| Secondary | Articulation detail | legato vs marcato | same |
| Mix | Pan and depth | different pan, front vs back | same position |

## Rules
- R1 `MUST` To make two simultaneous lines independent, give them a difference in at least one main
  parameter, and preferably two.
- R2 `PREFER` To fuse lines into one gesture, give them the same rhythm, register zone and colour
  (or a blending colour pair).
- R3 `ALLOWED` Pan and depth as extra separation once the arrangement already separates. Mix-stage
  separation alone is weak.
- R4 `AVOID` Two melodic lines in the same family, register and rhythm. That is a unison or a harmony
  line, not two lines.
- R5 `PREFER` For contrapuntal lines, break routine pairings and assign colour groups per line
  (see [[texture-counterpoint]]).

## Apply in MIDI / REAPER
**Separation score** for lines A and B, computed per section:
- `rhythm` = 1 if fewer than 50 % of onsets are shared.
- `register` = 1 if the median pitches differ by ≥ 12 semitones and there is no crossing for more than
  1 beat.
- `timbre` = 1 if the tracks belong to different families (strings / woodwinds / brass / percussion /
  keys).
- `secondary` = +0.5 each for ≥ 15 CC1 difference, contrary/oblique motion more than 50 % of the time,
  and different articulation patch (legato vs shorts).
- Target: **≥ 2** for independent lines; **≤ 1** for a fused doubling. An octave doubling scores 1, on
  register only.

**Fixes, in order** (cheapest first):
1. Change B's rhythm (longer notes under a busy line, or vice versa).
2. Move B an octave.
3. Move B to another family.
4. Change articulation (shorts vs legato).
5. Lower CC1 by 15.
6. Pan B 0.3–0.5 away and add depth (more reverb send).

**Fusion recipe:** copy the notes exactly; use the same articulation patch type; pan the tracks within
0.2 of each other; give them similar reverb sends; humanize each by ±5 ms, no more.

## Checklist
- Does every countermelody score at least 2 against the melody?
- Does every intended doubling score 1 or less (same rhythm, same colour or a blending pair)?
- Are pan and depth used only after the arrangement already separates?
- Is there no unintended crossing of the two lines for more than a beat?
