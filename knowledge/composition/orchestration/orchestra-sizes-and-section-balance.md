---
id: orchestration.orchestra-sizes-and-section-balance
title: Orchestra sizes, section balance and sample patch size
aliases: [plantilla orquestal, orquesta a dos, orquesta a tres, orquesta a cuatro, tamaño de sección, balance de cuerdas, número de músicos, plantilla de cuerda, atril, equilibrio entre secciones, peso sonoro, dos trompas igual a una trompeta]
domain: orchestration
tags: [line-up, section-size, balance, patch-choice, template]
style_scope: universal (section table = modern recording practice; period line-ups in the -by-era note)
use_when: Choosing the line-up of a piece or cue, deciding how many players a string part stands for, weighing sections against each other, or picking solo / chamber / full-section sample patches.
summary: String sections are sized for loudness AND type of sound and shrink from Vln I to Cb (modern full section 16/14/12/10/8, Adler up to 18/16/14/12/10). Balance weights at forte: 1 trumpet ≈ 1 trombone ≈ 2 horns, woodwinds weakest; one woodwind on a string line is absorbed, two tint it. Solo patch = 1–3 players, chamber ≈ 4–8, full section = 9+; never fake a section with stacked solo patches. Period line-ups: [[orchestra-sizes-and-section-balance-by-era]].
sources: ["unir-orq-tema1 p.4-6", "unir-orq-tema4 p.5-7", "unir-orq-tema5 p.12-17", "unir-orq-tema6 p.19-27", "apuntes-orq-sesion1 scan p.1-2 + PDF1", "adler-orq-es p.3-8", "adler-orq-es p.363-364", "piston-orch p.426-430", "piston-orch p.444-446"]
related: ["[[orchestra-sizes-and-section-balance-by-era]]", "[[stage-seating-pan-depth]]", "[[orchestral-mockup-template]]", "[[dynamics-by-orchestration]]", "[[chord-voicing-family-stacking]]", "[[tutti-balance-by-role]]", "[[_instruments]]"]
---

# Orchestra sizes, section balance and sample patch size

## Core idea
Two things set a section's size: **volume** and **type of sound**. One violin and six violins in unison
are different sounds, not just louder ones. Bigger instruments sound louder, so string sections shrink
from the top part to the bottom one. Balance between sections comes from how many players sit on a line
and how strong each is in that register, not from faders.

## Rules
- R1 `MUST` Pick the line-up for the style and period ([[orchestra-sizes-and-section-balance-by-era]]). A
  Classical-style piece with 6 horns and a tuba is a style error.
- R2 `MUST` Size each section for loudness and for the timbre you want: a solo line or a section line.
- R3 `AVOID` 2–3 players per string part when you want a section sound: thin, like separate soloists, and
  out of tune (UNIR).
- R4 `NEVER` (modern section sound) exactly 2 double basses: use 1 (a soloist reinforcing the cellos) or 3+
  (UNIR). Period exception in the -by-era note.
- R5 `PREFER` Vln I ≥ Vln II > Va > Vc > Cb, one or two players fewer per part (14/12/10/9/6; Adler's full
  section counts 2 players per stand).
- R6 `MUST` Forte equivalence above mf: **2 horns ≈ 1 trumpet ≈ 1 trombone** (Adler; Piston: one horn
  cannot equal them). A low-register trumpet is weaker. 1 horn ≈ 2 woodwinds (general knowledge,
  Rimsky's rule of thumb). At mf and softer the winds are roughly equal.
- R7 `MUST` At f, woodwinds stay weaker than brass even when well placed; double them in unison to approach
  the brass, which still tends to win (Piston).
- R8 `PREFER` Count each string section as one instrument when balancing a chord, a divided section as a
  half, a solo string as one (Piston, wide margin).
- R9 `ALLOWED` One woodwind on a string line mainly strengthens the string tone, its colour absorbed at a
  fairly loud dynamic; two make the wind colour audible (Piston). `MUST` In loud passages double the
  woodwind (a2) when it doubles strings at the octave, or it will not balance (Piston).
- R10 `AVOID` 3 trombones in unison on a melody the orchestra must not cover: they dominate the mass.
- R11 `PREFER` Attack penetration in brass: trumpet > trombone > horn; the horn blends best and links
  woods and brass (Piston). Among woods the oboe sticks out of chords; flute, clarinet and bassoon blend.

## String section sizes (players per part)
| Sound type | Vln I | Vln II | Va | Vc | Cb |
|---|---|---|---|---|---|
| Soloists | 1 | 1 | 1 | 1 | 0–1 |
| Thin | 5–6 | 4–5 | 3–4 | 2–4 | 1 |
| Mid-thin | 7–8 | 6–7 | 5–6 | 4–5 | 3 |
| Mid | 9–12 | 8–10 | 7–8 | 6–7 | 4 |
| Symphonic | 13–16 | 11–14 | 9–12 | 8–10 | 5–7 |
| Full | 17–20 | 15–18 | 13–16 | 11–14 | 8–10 |

Minimum that reads as a section: violins 5, violas 4, cellos 4, basses 3 (UNIR). Adler's full symphony
section: 16–18 / 14–16 / 10–12 / 10–12 / 8–10 (8–9, 7–8, 5–6, 5–6, 4–5 stands); each stand can take one
divisi line, so div. a 2 halves the players per line.

## Apply in MIDI / REAPER
- **Patch size from player count:** 1–3 players → solo patch (one track per player); about 4–8 →
  chamber patch; 9+ → full-section patch. Albion ONE records large ensembles: always "symphonic" or "full".
- **Intimate passage in a big template:** a solo or chamber patch on its own track (`VLN SOLO`); lowering
  CC1 changes the dynamic, not the size.
- **Never stack two solo patches in unison** to fake a section. A solo bass patch can reinforce the cello
  line at pitch or 12 below.
- **Weights for a balance check** (inferred): trumpet = trombone = 2, horn = 1, woodwind = 0.5, string
  section = 1, "a4" horn patch line = 2, divided string track = 0.5. Sum per line at f and compare with
  the role: melody ≥ countermelody > pad.
- **Divisi count:** a full section supports about 4 divisi tracks per part before each line sounds like a
  chamber group; use chamber patches past that (inferred).
- **Balance from orchestration, not faders:** faders stay at 0 dB ([[user-taste]] R15). To equal one forte
  trumpet, stack two horn lines; to equal one horn, two woodwind tracks. If a section seems to need more
  than about 4 dB of help, re-voice it instead.

## Checklist
- Does the line-up match the declared style?
- Is every string part a solo patch (1–3) or a section patch (4+), never two stacked solos?
- At forte, are there 2 horns per trumpet/trombone line and doubled woods against brass?
- Does a woodwind doubling a string line at the octave in a loud passage have 2+ players?
- Does a melody on 3 unison trombones really need to dominate?
