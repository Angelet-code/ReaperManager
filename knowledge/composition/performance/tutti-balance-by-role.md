---
id: performance.tutti-balance-by-role
title: Tutti balance by role (measured in full mock-ups)
aliases: [balance de tutti, balance por papel, melodía y acompañamiento, voces internas, solista sobre lecho, CC11 como trim, nivel por familia]
domain: performance
tags: [balance, tutti, roles, cc1, cc11, measured]
style_scope: orchestral mock-ups (film and concert)
use_when: Setting the relative dynamics of all parts in a tutti, or of a soloist over a bed, through CC1, CC11 and velocity instead of faders.
summary: "In professional mock-ups the faders stay at 0 dB and the balance lives in the MIDI. The melody moves most and sits a little higher; pads and inner voices sit lower and flatter. A soloist over a soft bed plays far higher on its dynamics layer. CC11 is often a static per-track trim around 90, while CC1 performs. Loud melody instruments (trumpets) play lower CC1 than the horns under them; weak doublings (flutes) are pushed up."
sources: ["reference-midi-batch2", "reference-midi-batch1"]
related: ["[[_performance]]", "[[user-taste]]", "[[library-translation-table]]", "[[cc-expression-phrase-shapes]]", "[[dynamics-by-orchestration]]"]
---

# Tutti balance by role

## Core idea
Balance is decided per **role**, not per fader:
- the melody needs to be heard;
- countermelodies sit just under it;
- pads, inner voices and bass support.

Professionals set this in the MIDI. Where we could see a full REAPER project (Duc), every instrument fader
was at 0 dB and only the family buses were trimmed, by −2 to −6.6 dB. That matches [[user-taste]] R15.

## Measured
CC1 at the notes, median (p10–p90). Batch 2 holds the full mock-ups; MID-FiLD gives phrases tagged with
their role.

| Evidence | Melody / soloist | Supporting voices | Bass |
|---|---|---|---|
| MID-FiLD, 4422 phrases (CC1 midpoint; range within the phrase) | main melody 74 (39–99), range 36 | sub-melody 68, range 27; pad 67, range 17 | 58, range 30 |
| MID-FiLD by family | brass melody 90, strings 73, woods 67 | brass pad 66, sub-melody 81; woods pad 36 | strings 53, brass 70 |
| Mahler Adagietto (Duc, CSS + solo violin) | solo violin CC1 110 | section strings CC1 20–56 (CC11 116–127) | basses 40 |
| LOTR "White Tree" (Duc, SSB/CSS/VSL) | violins 1 96, trumpets 110 | violas 64 (inner), clarinets 66–69 | cellos 101, basses 109, tuba 120 |
| Star Wars Main Title (CSS/CSB/CSW) | trumpet 1 84 | horns 114–124; flutes 107–114 (doubling); CC11 ≈ 90 on almost every track | basses 114 |
| "Time" (Zimmer, mixed libraries) | string melody 88 | high strings 80, French horns 37–55 (bed) | low strings 92 |

Further measurements:
- **Phrase motion by role** (MID-FiLD): the melody moves the most and the pad the least. Read the range
  column as how far CC1 travels within one phrase.
- **Mood → CC1 midpoint** (MID-FiLD):
  - calm and peaceful 25–43;
  - relaxing 50;
  - sad 58;
  - romantic and dreamy 73;
  - hopeful 80;
  - tense 88.

## Layers
- **Player / arranger** (transferable):
  - which role moves more, and which sits under which;
  - inner voices lower than outer voices;
  - a soloist far above a soft bed;
  - mood → dynamic level.
- **Library** (not transferable): absolute CC values and the role of CC11. CC11 is a trim in the
  CSS-family mock-ups, but the phrase carrier in SWAM. Translate with [[library-translation-table]].

## Rules
- R1 `MUST` Balance with CC1, CC11 and velocity. Keep the instrument faders at unity, with at most a
  family-bus trim ([[user-taste]] R15) `(measured: Duc .RPP)`.
- R2 `PREFER` The **melody moves most** (CC1 range of about 35 within a phrase) and sits slightly higher
  than the sub-melody, about 5 points. **Pads are flat** (about 17-point range) `(measured: MID-FiLD)`.
- R3 `PREFER` **Inner voices sit below outer voices.** Violas and second parts are often 20–40 CC1 points
  under the violins and cellos in the same passage `(measured: Duc)`.
- R4 `PREFER` A **soloist over a soft section bed** lives much higher on its own dynamics layer. Example:
  solo violin CC1 ≈ 110 against a bed at 20–56 with full CC11. Check the result as about +5 dB in the
  render ([[user-taste]] R15) `(measured: Duc Mahler)`.
- R5 `PREFER` **Strong instruments carry a melody with less CC1** than the supporting brass: trumpet
  melody at about 84 while the horns sit at 114–124. **Weak doublings get more**: flutes at about 110 in
  a tutti `(measured: Star Wars)`.
- R6 `ALLOWED` **CC11 as a static per-track trim** (about 90, raised to 110–127 for a line that must come
  through, lowered to 50–70 for support), with CC1 doing the performance. This applies to sample
  libraries with a CC11 volume. On SWAM, CC11 is the phrase itself `(measured: Star Wars, Mahler)`.
- R7 `PREFER` Choose the base dynamic level from the mood (see the mood list above), then shape each role
  around it.
- R8 `AVOID` Maxing percussion velocities in epic tutti. Duc's snare and timpani sit at velocity 66–68
  in a climactic cue; let the orchestra carry the climax `(measured: Duc LOTR)`.

## Checklist
- Are all the instrument faders at 0 dB?
- Does the melody have the widest CC1 motion, with pads flatter?
- Are the inner voices below the outer voices?
- Does the soloist come out about 5 dB over its bed in the render?
