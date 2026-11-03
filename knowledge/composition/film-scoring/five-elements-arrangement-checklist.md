---
id: film-scoring.five-elements-arrangement-checklist
title: The five elements (direction, movement, background, enhancer, bass)
aliases: [cinco elementos, dirección, movimiento, fondo, pegamento, glue, potenciador, enhancer, bajo, momentum, impulso, arreglo estático]
domain: film-scoring
tags: [arrangement, checklist, momentum, roles]
style_scope: film (modern orchestral / media scoring)
use_when: Planning the layers of a cue section, or diagnosing a passage that feels static, empty or unfinished.
summary: "A passage can contain up to five components: direction (goes from A to B), movement (flow, ostinato, call and response), background (glue that fills gaps), enhancer (runs, trills, swells and ear candy at transitions) and bass (a controlled low end). When a passage feels static, find which component is missing (usually movement or direction) and add it."
sources: ["film-4day-challenge slide 10", "httyd-test-drive p.1-15"]
related: ["[[orchestral-mockup-template]]", "[[action-ostinato-pedal-gallop]]", "[[bass-line-doubling]]", "[[building-and-releasing-climaxes]]", "[[texture-types]]"]
---

# The five elements

## Core idea
Five **components** (not fixed layers: one track can carry two, and some can be absent) give music
momentum.
- **Direction:** the sense of going from A to B. It can be a melody, a progression building tension, or
  rising or falling density.
- **Movement:** flow and action. Rhythmic patterns, ostinati, repeating or modulating progressions, call
  and response between families. It also helps direction.
- **Background (glue):** sits behind in the mix. You don't notice it until it is gone. It fills gaps and
  joins ideas.
- **Enhancer:** intensifies, develops or connects sections; sparkle and ear candy. Runs, scales, trills,
  woodwind flutters behind a soaring melody, cymbal or timpani swells.
- **Bass:** the extra low end. Modern orchestral sound needs a solid, compact, controlled bottom.

## Rules
- R1 `PREFER` When a passage feels static, check which elements are missing and add one, usually
  movement or direction.
- R2 `MUST` (modern film/epic) Provide a dedicated, controlled bass element.
- R3 `PREFER` Put enhancers at transitions and behind long melody notes, not continuously.
- R4 `PREFER` Keep background soft and wide (pads, sustains, soft tremolo), with CC1 15–25 below the
  direction element.
- R5 `ALLOWED` One instrument can cover two elements (a string ostinato that also outlines the
  progression = movement + direction).
- R6 `AVOID` Five busy elements at once at full level. Something must be in the background.

## Apply in MIDI / REAPER
**Tag every track with its element** in the name suffix or the item name: `[DIR]`, `[MOV]`, `[BG]`,
`[ENH]`, `[BASS]`. Example names: `HN a6 [DIR]`, `VLA 16ths [MOV]`, `STR PAD [BG]`, `FL RUNS [ENH]`,
`CB+SUB [BASS]`.

**Default element → instrument / register / CC:**
| Element | Typical tracks | Register (MIDI) | Dynamics |
|---|---|---|---|
| Direction | melody (horns, Vln I, woodwind solo), or a rising progression | 60–88 | CC1 70–110, phrase swells |
| Movement | string ostinato (spiccato/staccato), harp or piano pattern, gallop | 48–84 | shorts vel 70–110 with an accent every beat 1 (+15) |
| Background | strings sustain or con sordino, choir pad, soft synth | 48–79, wide voicing | CC1 30–60, slow drift |
| Enhancer | flute/piccolo runs, harp gliss, celesta, cymbal swells, timpani rolls | 72–100 (high), or perc | at transitions only; ramps that end on downbeats |
| Bass | Vc + Cb, low brass at f, sub boom, low synth | 24–50 | steady; dry |

**Section audit** (per marker section), a yes/no per element:
- Missing direction → add a melody, a rising line in Vln I (+1 step per bar), or a density ramp.
- Missing movement → add an 8th/16th ostinato on the chord tones in violas or Vln II, or a harp pattern.
- Missing background → add a string pad on the chord's 3rd and 5th in 55–72 at CC1 35–45.
- Missing enhancer at a section boundary → add a one-beat run or a cymbal swell into the downbeat.
- Missing bass → add `CB` roots (−12 from `VC`) and, for epic style, a sub hit on section downbeats.

**Density guard:**
- At most 2 elements in the foreground at once (CC1 ≥ 80 or vel ≥ 100).
- Background is ≥ 15 CC1 below direction.

## Checklist
- Does every section have direction and bass (in film/epic style)?
- Is there movement in every section longer than 8 bars?
- Do enhancers appear at transitions and not continuously?
- Is the background soft (≥ 15 CC1 below direction) and never the loudest element?
- Is every track tagged with one or two element roles?

## Examples (HTTYD "Test Drive")
- b.21–24: direction = horns a12 tune; movement = harp 16th broken chords + woodwind runs; background =
  violas and trombone triads; enhancer = suspended cymbal on b.21 + woodwind sextuplets; bass = tuba,
  bassoons and basses in half notes.
- b.40–44: direction = rising string glissandi + crescendo (no melody); movement = tremolos and rolls;
  bass = Bb pedal.
