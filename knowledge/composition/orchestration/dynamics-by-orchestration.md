---
id: orchestration.dynamics-by-orchestration
title: Dynamics by orchestration (crescendo by adding instruments, arrival checks)
aliases: [crescendo orquestal, diminuendo orquestal, dinámica por orquestación, llegada en forte, llegada en piano, matices, CC1, CC11, expresión, dinámica compartida, reservar el tutti, delgado no es suave]
domain: orchestration
tags: [dynamics, crescendo, cc1, cc11, velocity, balance]
style_scope: universal
use_when: Writing any crescendo or diminuendo, setting CC1/CC11/velocity for a dynamic level, or checking that a forte or piano arrival is supported by the scoring.
summary: The orchestra gets louder by adding instruments and octaves and softer by removing them; CC ramps inside each track only finish the shape. A forte arrival normally needs many instruments and a piano arrival few, but density and loudness are separate parameters (a ppp tutti and a thin ff line are both legal). Reserve the full tutti and each family's strongest register for structural peaks. The table below is the vault's default dynamic-to-CC1/velocity map.
sources: ["unir-orq-tema2 p.4-10", "unir-orq-tema3 p.11", "httyd-test-drive p.1-3, p.15", "adler-orq-es p.357, 363", "adler-orq-es p.547-556", "adler-orq-es p.563-569", "piston-orch p.426-430", "piston-orch p.449-450", "piston-orch p.461-462"]
related: ["[[dynamics-by-orchestration-crescendo-and-fade]]", "[[building-and-releasing-climaxes]]", "[[chord-voicing-family-stacking-tutti]]", "[[orchestration-errors-checklist]]", "[[orchestra-sizes-and-section-balance]]", "[[tutti-balance-by-role]]", "[[cc-expression-phrase-shapes]]", "[[user-taste]]"]
---

# Dynamics by orchestration

## Core idea
A real crescendo is a change in **instrumentation**: more players, more octaves, brighter registers. CC
ramps alone only make the same players play harder. Piston: the forces expand and contract for dynamic
purposes. The density at an arrival should match its dynamic, but thin is not the same as soft, nor
thick as loud. Step-by-step builds and fades: [[dynamics-by-orchestration-crescendo-and-fade]].

## Rules
- R1 `MUST` Make a crescendo by adding instruments progressively, and a diminuendo by removing them (UNIR;
  Piston: doublings accumulate as it grows).
- R2 `MUST` Support a forte arrival (cadence, downbeat, climax) with many instruments, and a piano arrival
  with few, by default (UNIR).
- R3 `ALLOWED` Density and dynamic are independent parameters (Piston): a full tutti at ppp is rich and
  sumptuous, a single line can be ff. Use these on purpose; R2 stays the default for climactic writing.
- R4 `PREFER` In a long crescendo, keep all three layers (melody, countermelody, accompaniment) and add
  doublings to **each** layer, not only to the melody (Beethoven 7/II).
- R5 `PREFER` Add octave layers rather than raising every dynamic (HTTYD intro).
- R6 `PREFER` Give each line its own dynamic: melody about one level above the accompaniment. `NEVER` let
  the accompaniment overwhelm the melody (Piston).
- R7 `MUST` Give every note to an instrument that can play it at that dynamic (Adler). `AVOID` low flute
  at f (59–63), the top of horn or trumpet at pp, oboe or bassoon bottom notes at pp.
- R8 `AVOID` Endless tutti and brass played loud all through: listeners tire and real climaxes lose power
  (Adler). `PREFER` reserve a family's strongest register for the key gesture (Barber keeps the horns' top
  for one glissando).
- R9 `PREFER` Withhold a colour (trombones and timpani, or the horns) from a phrase so the next one weighs
  more or sounds fresh (Adler).
- R10 `ALLOWED` A **subito** change (subito p after ff, subito f restart) for contrast. Make it with
  instrumentation too: drop the tracks, don't only ramp them down.
- R11 `PREFER` In the score, one shared dynamic marking per passage; do not routinely mark brass softer
  than woods to fix their inequality, or split markings lose their meaning as an effect (Piston). In
  MIDI there are no players to adapt, so the balance goes into CC1/velocity: brass under the marking,
  trombones in a unison tutti much softer than the rest (Adler, Piston; [[user-taste]] R15).

## Apply in MIDI / REAPER
**Vault default dynamic map** (general knowledge; fits Spitfire/Albion-type libraries: CC1 = dynamic
layer crossfade on long notes, velocity = dynamic on short notes, CC11 = expression trim):

| Dynamic | CC1 (longs) | Velocity (shorts) | CC11 |
|---|---|---|---|
| pp | 15–25 | 25–35 | 90–100 |
| p | 30–40 | 40–50 | 100 |
| mp | 45–55 | 55–65 | 100–110 |
| mf | 60–70 | 70–80 | 110 |
| f | 80–90 | 90–100 | 115 |
| ff | 100–112 | 105–115 | 120 |
| fff / sfz | 115–127 | 118–127 | 127 |

- **Balance offsets** inside one marking (inferred): trumpets and trombones 10–20 CC1 under the woods and
  strings in ff; trombones in a unison tutti 20–30 under; Albion layer tweaks in [[user-taste]] R17.
- **CC1 vs CC11:** CC1 changes timbre and loudness together (the real dynamic). Use CC11 for fades to
  niente, phrase-end tapers and section trims; keep it ≥ 90 except in fades.
- **Shapes** (the builder ramps CC points linearly):
  - Swell `<>`: CC1 starts 15 under the target, peaks at 60–70 % of the note, ends 10 under the start.
  - Crescendo over n bars: one CC1 point per beat; end the ramp **on the downbeat**.
  - fp: CC1 ≈100 for the first 1/16, down to ≈35 within about 1/8, then the hairpin if marked.
  - Sustained notes drift 3–5 CC1 points per bar so the sound is never static.
- **Arrival lint:** for each marker or cadence bar, count tracks sounding on the downbeat. Rough target:
  pp–p = 1–5 tracks, mf = 5–10, f = 10–15, ff = everything that fits the texture. Flag exceptions
  for review instead of failing them (R3).
- **Register lint:** flute ≤ 63 with CC1 > 80; horn ≥ 74, trumpet ≥ 79 or oboe ≤ 60 with CC1 < 40;
  undoubled flute ≥ 89 in a p chord.
- **Reserve lint:** the number of bars with all families sounding should be small (a few per minute)
  and sit on structural points.

## Checklist
- Does every crescendo add at least one track or octave layer before its peak?
- Do CC1 ramps end on the arrival downbeat?
- Does every ff arrival have more active tracks than the bars before it, unless a thin ff is intended?
- Do p arrivals and endings have few tracks, with brass and percussion soft if present?
- Is the melody one level above the accompaniment and never covered?
- Are there no extreme-register notes at an impossible dynamic?
- Is the full tutti (and full brass) kept for structural peaks?
