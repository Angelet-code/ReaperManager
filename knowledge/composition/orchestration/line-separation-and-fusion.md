---
id: orchestration.line-separation-and-fusion
title: Separation vs fusion of lines
aliases: [separación de líneas, fusión, asociación, independencia de voces, claridad, enmascaramiento, contrapunto separación asociación, primer plano, plano medio, plano de fondo, peso sonoro, Vordergrund, Hintergrund]
domain: orchestration
tags: [separation, fusion, counterpoint, clarity, doubling, mix]
style_scope: universal (method from film scoring, backed by Adler 2002 and Piston 1955)
use_when: Two or more simultaneous lines must be heard as different things (melody vs countermelody, theme vs ostinato, canon entries), or several instruments must fuse into one gesture.
summary: "Lines separate when they differ in the main parameters (rhythm/articulation, register, timbre) and fuse when they share them. Dynamics and contour are secondary, prior exposure and best-register placement help, and pan and depth are a mix-stage extra. To make lines independent, change at least one main parameter, ideally two. To fuse, match rhythm, register and colour, and beware of accidental fusion: a new entry a step from another instrument's last note, or close lines doubled in octaves."
sources: ["film-4day-challenge slide 5", "unir-orq-tema3 p.13-14", "unir-orq-tema2 p.7-10", "adler-orq-es p.118-135", "adler-orq-es p.261-270", "piston-orch p.366-373", "piston-orch p.388-395", "piston-orch p.406-409", "piston-orch p.419-425"]
related: ["[[texture-counterpoint]]", "[[texture-counterpoint-entries-and-canon]]", "[[texture-secondary-melody-countermelody]]", "[[doubling-colour-and-decay]]", "[[stage-seating-pan-depth]]", "[[texture-complex-mosaic]]", "[[string-section-writing-counterpoint]]"]
---

# Separation vs fusion of lines

## Core idea
The ear groups sounds that share rhythm, register and colour into one stream. That **fusion** is what you
want for doublings and unisons. **Separation** is what you want for counterpoint, countermelodies and theme
vs ostinato. Adler's planes (foreground, middleground, background) tell you how much each line must stand
out; the parameters below do the work.

## Parameters
| Rank | Parameter | Separate by… | Fuse by… |
|---|---|---|---|
| Main | Rhythm / articulation | different onsets, long vs short | identical rhythm |
| Main | Register | ≥ an octave apart, no crossing | same octave |
| Main | Timbre / colour | different families (brass vs strings) | same family or blending pair |
| Helper | Best register | foreground in its instrument's best register, background in duller ones | — |
| Helper | Prior exposure | theme heard alone before it is combined | — |
| Secondary | Dynamics | one level apart | equal |
| Secondary | Direction / contour | contrary or oblique motion | parallel motion |
| Mix | Pan and depth | different pan, front vs back | same position |

## Rules
- R1 `MUST` To make two simultaneous lines independent, give them a difference in at least one main
  parameter, and preferably two.
- R2 `PREFER` Dynamics separate least. In strings-only counterpoint, separate by best register, by thinning
  the counterpoint around the theme, by register bands and by rhythm before using *f* against *p* (Adler).
- R3 `ALLOWED` Lines in similar registers and one family stay apart when each has its own rhythm and
  articulation and the main themes were heard earlier alone (Beethoven 7/II, Adler). Distinct woodwind
  colours keep woodwind counterpoint clear on their own.
- R4 `PREFER` To fuse lines into one gesture, give them the same rhythm, register zone and colour (or a
  blending pair).
- R5 `AVOID` Accidental fusion across instruments. A new entry one step from the previous instrument's last
  note is heard as that line continuing (Beethoven leaves the clarinet out of a hand-off for this reason,
  Piston).
- R6 `AVOID` Octave doublings on two lines that lie close together: they blur into each other (Strauss,
  Piston). Double in octaves only where the lines are far apart.
- R7 `MUST` Judge each line where its doublings put it: upward doublings of a bass line (flute, violas) pull it
  close to the upper line (Mozart 40/III, Piston).
- R8 `AVOID` A doubling note that another line is sounding at that moment; omit it from the doubling
  (Bartók, Piston).
- R9 `MUST` A line in a weak register among many voices needs a unison partner, or it is covered (Bartók,
  Piston).
- R10 `AVOID` Unisons on the most expressive solo lines: two players cancel each other's small expressive
  fluctuations, and two of a kind give less than twice the weight of one (Piston). Use unisons for weight
  and new colours.
- R11 `PREFER` Brass octaves on a rhythmic line: give each octave a unison of mixed brass (Tpt 1–2 on top;
  Tpt 3 + Trb 1 an octave lower) rather than one instrument per octave. Horn, trombone and trumpet attacks
  differ, and the horn speaks slower (Piston).
- R12 `ALLOWED` Pan and depth as extra separation once the arrangement already separates. Mix-stage
  separation alone is weak.
- R13 `AVOID` Two melodic lines in the same family, register and rhythm. That is a unison or a harmony line,
  not two lines.

## Apply in MIDI / REAPER
**Separation score** for lines A and B, computed per section:
- `rhythm` = 1 if fewer than 50 % of onsets are shared.
- `register` = 1 if the median pitches (including each line's doublings) differ by ≥ 12 semitones and there
  is no crossing for more than 1 beat.
- `timbre` = 1 if the tracks belong to different families (strings / woodwinds / brass / percussion / keys).
- `secondary` = +0.5 each for ≥ 15 CC1 difference, contrary/oblique motion more than 50 % of the time,
  different articulation patch (legato vs shorts), and the theme stated alone earlier.
- Target: **≥ 2** for independent lines; **≤ 1** for a fused doubling. An octave doubling scores 1, on
  register only. (Thresholds are this vault's, not the books'.)

**Fixes, cheapest first:**
1. Change B's rhythm (longer notes under a busy line, or vice versa).
2. Move B an octave, or remove octave doublings that bring it close to A.
3. Move B to another family.
4. Change articulation (shorts vs legato).
5. Lower B's CC1 by about 15 (a countermelody sits about 3 dB under the melody, [[user-taste]] R15).
6. Pan B 0.3–0.5 away and add depth (more reverb send).

**Accidental-fusion lint:** at every hand-off between tracks, if the new entry's first pitch is within 2
semitones of the last pitch of another track that just ended (gap ≤ 1 beat), flag it unless the hand-off is
meant to sound as one line.

**Fusion recipe:** copy the notes exactly; same articulation patch type; pan within 0.2; similar reverb
sends; humanize each copy by ±5 ms, no more. For brass in octaves, start horn notes about 20–30 ms early
(inferred) so they speak with the trumpets.

## Checklist
- Does every countermelody score at least 2 against the melody?
- Does every intended doubling score 1 or less?
- Are close-lying lines free of octave doublings?
- Does no hand-off sound like a continuation by accident?
- Are weak-register lines in thick textures doubled?
- Are pan and depth used only after the arrangement already separates?
