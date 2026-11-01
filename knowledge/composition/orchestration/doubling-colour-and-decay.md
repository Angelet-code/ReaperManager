---
id: orchestration.doubling-colour-and-decay
title: Doubling by colour, construction and decay
aliases: [doblajes, doblaje, octavación, doblar por color, doblar por envolvente, unísono de timbres, refuerzo, brillo]
domain: orchestration
tags: [doubling, colour, decay, timbre, sparkle]
style_scope: universal (method from film scoring; examples classical and film)
use_when: Deciding which instrument should double a line (melody, pizzicato, bell figure, ostinato), or checking whether a passage is over-doubled.
summary: Double a layer only when it needs more definition, weight, colour or a specific emotion. Choose the doubler by colour (similar timbre), construction (brass-built, wood-built) or decay type (pizz with harp or piano, mid-decay bells with celesta or vibes), not by range. Over-doubling removes the colour changes that make an orchestration live.
sources: ["film-4day-challenge slide 6", "unir-orq-tema2 p.7-10", "unir-orq-tema7 p.13-16", "unir-orq-tema8 p.9-11, p.16", "httyd-test-drive p.3-8"]
related: ["[[bass-line-doubling]]", "[[line-separation-and-fusion]]", "[[texture-unison-and-tutti]]", "[[chord-voicing-family-stacking]]", "[[_instruments]]"]
---

# Doubling by colour, construction and decay

## Core idea
Doubling widens the palette, letting a line take on a new mixed colour. Too much doubling does the
opposite: with everything doubled all the time, nothing can change colour. Group doublers **by colour,
not by range**.

## Method (four steps)
1. Pick the instrument for the layer (e.g. the melody instrument).
2. Decide what the layer needs: **definition**, **weight**, **expanded colour**, or a specific
   **emotion**.
3. Choose the doubling criterion: colour, construction, decay type, or emotion.
4. Choose the doubling instrument(s) and the octave.

## Rules
- R1 `PREFER` Doublers of similar colour: cello + bassoon; double reeds + muted trumpet; string pizz +
  harp.
- R2 `PREFER` Doublers of similar decay envelope:
  - **Fast fixed decay:** pizz strings, piano, harp.
  - **Medium fixed decay:** tubular bells, celesta, crotales, vibraphone.
  - **Variable (sustaining):** bowed strings, winds, brass.
- R3 `ALLOWED` Doublers of similar construction: brass-built (brass section, tubular bells, cymbal,
  tam-tam) or wood idiophones (wood blocks, marimba).
- R4 `AVOID` Doubling everything all the time. Keep at least one layer undoubled in each section, and
  change doublings at section boundaries.
- R5 `MUST` The melody must not be buried by octave doublings of bass or filler.
- R6 `ALLOWED` Doubling a melody at a lower octave with a contrasting wind (oboe + bassoon an octave
  below, UNIR Adagio).
- R7 `PREFER` (film) Cellos in their high register (treble clef) double a mid-register tune **at the same
  pitch**. This adds body without lowering the line (HTTYD).
- R8 `PREFER` Ornaments only in the solo colour instrument; the doublers play the plain skeleton.
- R9 `ALLOWED` Sparkle doubling: glockenspiel two octaves up, xylophone for dry rhythmic doubling, vibes
  for a soft halo, celesta for magic.
- R10 `AVOID` Glockenspiel or celesta doubling in ff tutti passages: they are inaudible there. Use them
  in f-or-softer sections.

## Apply in MIDI / REAPER
- Create doublers as **separate tracks** with copied notes, never as extra notes inside the lead track.
  Each doubler gets its own CC1 lane, set 5–15 below the lead so the lead colour wins.
- **Doubling lookup:**
| Lead layer | Need | Doubler track | Transposition |
|---|---|---|---|
| String pizz bass or ostinato | definition | HARP (+ PIANO) | same pitch; piano can add −12 |
| Flute or woodwind melody | colour, support | HARP arpeggio accompaniment | — |
| Bell-like melody | sparkle | CELESTA / VIBES / CROTALES | celesta same or +12; crotales +24 |
| Melody in 62–74 | body | VC (treble register) | same pitch |
| Oboe melody | weight | BSN | −12 |
| Cello melody | warmth | BSN or HN | same pitch |
| Horn melody | definition | VLN II | same pitch (HTTYD) |
| Trumpet stab | weight | HN pair + TBN | chord tones, same rhythm |
| Melody in a quiet section | sparkle | GLOCK | +24 (check whether the patch already transposes) |

- **Copy rule:** copy pitch, beat and len exactly. Keep velocities, then subtract 10 for doublers. Humanize
  each copy separately (±5–10 ms) so they don't phase.
- **Range clamp:** after transposing a copy, reject notes outside the doubler's range rather than
  folding single notes by octave. Folding breaks the line (UNIR's "cut lines" error). Move the whole
  phrase instead.
- **Doubling budget:** in a 4-layer texture, at most 2 layers with more than 2 doublers each.

## Checklist
- Does each doubling serve a stated need (definition, weight, colour, emotion)?
- Do the doublers share colour, construction or decay type with the lead?
- Is at least one layer per section left undoubled, and do doublings change between sections?
- Is there no celesta or glockenspiel in ff tutti?
- Is no doubled phrase folded by octave mid-phrase?
- Is the lead track's CC1 above its doublers'?
