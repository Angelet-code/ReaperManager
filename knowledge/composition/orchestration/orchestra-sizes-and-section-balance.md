---
id: orchestration.orchestra-sizes-and-section-balance
title: Orchestra sizes, section balance and sample patch size
aliases: [plantilla orquestal, orquesta a dos, orquesta a tres, orquesta a cuatro, tamaño de sección, balance de cuerdas, número de músicos, plantilla de cuerda]
domain: orchestration
tags: [line-up, section-size, balance, patch-choice, template]
style_scope: universal (line-ups = classical to 20th c.; section table = modern recording practice)
use_when: Choosing the line-up of a piece or cue, deciding how many players a string part stands for, or picking solo / chamber / full-section sample patches.
summary: Line-ups are named by woodwinds per family (a2 classical, a3 romantic, a4 20th c. and film); string sections are sized for loudness AND type of sound and decrease from Vln I to Cb (e.g. 14/12/10/9/6). Solo patch = 1–3 players, chamber = about 4–8, full section = 9+; never fake a section with stacked solo patches and never use exactly 2 basses.
sources: ["unir-orq-tema1 p.4-6", "unir-orq-tema4 p.5-7", "unir-orq-tema5 p.12-17", "unir-orq-tema6 p.19-27", "apuntes-orq-sesion1 scan p.1-2 + PDF1"]
related: ["[[stage-seating-pan-depth]]", "[[orchestral-mockup-template]]", "[[dynamics-by-orchestration]]", "[[_instruments]]"]
---

# Orchestra sizes, section balance and sample patch size

## Core idea
Two things set a section's size: **volume** and **type of sound**. One violin and six violins in unison
are different sounds, not just louder ones. Bigger instruments sound louder, so string sections shrink
from the top part to the bottom one. Line-ups are named after the number of each woodwind.

## Rules
- R1 `MUST` Pick the line-up for the style and period (table below). A Classical-style piece with 6 horns
  and a tuba is a style error.
- R2 `MUST` Size each section for loudness and for the timbre you want: a solo line or a section line.
- R3 `AVOID` 2–3 players per string part when you want a section sound. It sounds thin, like separate
  soloists, and out of tune.
- R4 `NEVER` Use exactly 2 double basses. Use 1 (a soloist that reinforces the cellos) or 3 or more.
- R5 `PREFER` Proportions Vln I ≥ Vln II > Va > Vc > Cb, one or two players fewer per part
  (symphonic example: 14/12/10/9/6).
- R6 `AVOID` 3 trombones in unison on a melody that the rest of the orchestra must not cover. They
  dominate the whole mass.
- R7 `PREFER` Attack penetration in brass is trumpet > trombone > horn. The horn is the brass member that
  blends best. In woodwinds, the oboe sticks out of chords; flute, clarinet and bassoon blend.
- R8 `PREFER` Forte equivalence (general knowledge, Rimsky-Korsakov's rule of thumb): 1 trumpet ≈
  1 trombone ≈ 2 horns, and 1 horn ≈ 2 woodwinds. At piano all wind players are roughly equal.

## Line-ups
| Line-up | Period | Woodwinds | Brass | Other | Strings (I/II/Va/Vc/Cb) |
|---|---|---|---|---|---|
| a2 | c.1750–1830 | 2 fl, 2 ob, 2 cl, 2 bsn | 2 hn (+2 tpt) | timpani (tonic + dominant only) | 6–8/4–6/4/4/1–2 |
| a3 | c.1830–1890 | 2 + picc, 2 + E.H., 2 + bass cl, 2 + cbsn (or 3 of each) | 4 hn, 2 tpt, 2 tbn + bass tbn | timpani | about 12/10/8/8/6 (general knowledge) |
| a4 | c.1900–today | 3 + picc, 3 + E.H., 3 + bass cl, 3 + cbsn | 6–8 hn, 4 tpt, 3 tbn + bass tbn, tuba | timpani, percussion, keyboards, mallets | 16/14/12/10/8 |
| Film "big" (HTTYD) | modern | a3 + whistle, contrabass cl | **12 hn**, 4 tpt, 4 tbn + 2 bass tbn, tuba | 7 percussion staves, celesta, 2 harps | full |

## String section sizes (players per part)
| Sound type | Vln I | Vln II | Va | Vc | Cb |
|---|---|---|---|---|---|
| Soloists | 1 | 1 | 1 | 1 | 0–1 |
| Thin | 5–6 | 4–5 | 3–4 | 2–4 | 1 |
| Mid-thin | 7–8 | 6–7 | 5–6 | 4–5 | 3 |
| Mid | 9–12 | 8–10 | 7–8 | 6–7 | 4 |
| Symphonic | 13–16 | 11–14 | 9–12 | 8–10 | 5–7 |
| Full | 17–20 | 15–18 | 13–16 | 11–14 | 8–10 |

The minimum that reads as a section: violins 5, violas 4, cellos 4, basses 3.

## Apply in MIDI / REAPER
- **Patch size from player count:** 1–3 players → solo patch (one track per player); about 4–8 →
  chamber or small-section patch; 9 or more → full-section patch. Sample libraries such as Albion ONE
  record large ensembles, so they are always "symphonic" or "full".
- **Intimate passage inside a big template:** switch to a solo or chamber patch on a separate track
  (e.g. `VLN SOLO`); lowering CC1 changes the dynamic, not the size.
- **Never stack two solo patches in unison** to fake a section: they read as two soloists. A single
  solo bass patch can reinforce the cello line at the same pitch or 12 semitones below.
- **Classical (a2) track set:** `FL 1-2`, `OB 1-2`, `CL 1-2`, `BSN 1-2`, `HN 1-2`, (`TPT 1-2`), `TIMP`,
  `VLN I`, `VLN II`, `VLA`, `VC`, `CB`. Timpani notes only on tonic and dominant, e.g. in D: D2 38 and
  A2 45.
- **Balance from orchestration, not faders:** to equal one forte trumpet, stack two horn lines (or one
  horns-a4 patch). To equal one horn, double a woodwind line in two woodwind tracks (R8). When the mix
  needs more than about ±4 dB on a section fader to balance, the orchestration is wrong; re-voice it.
- **Track volume defaults** for a sampled orchestra recorded in one hall: leave the faders at 0 dB and
  balance with CC1 and CC11 (see [[dynamics-by-orchestration]]).

## Checklist
- Does the line-up match the declared style (no tuba or 6 horns in Classical, no exactly-2 basses)?
- Is every string part either a solo patch (1–3) or a section patch (4+), never two stacked solos?
- Does a melody given to 3 trombones in unison actually need to dominate?
- Is the oboe used as a solo colour, not as filler inside a soft woodwind chord?
- Can every section be balanced with faders within ±4 dB?

