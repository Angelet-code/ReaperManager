---
id: orchestration.dynamics-by-orchestration
title: Dynamics by orchestration (crescendo by adding instruments, arrival checks)
aliases: [crescendo orquestal, diminuendo orquestal, dinámica por orquestación, llegada en forte, llegada en piano, matices, CC1, CC11, expresión]
domain: orchestration
tags: [dynamics, crescendo, cc1, cc11, velocity, balance]
style_scope: universal
use_when: Writing any crescendo or diminuendo, setting CC1/CC11/velocity for a dynamic level, or checking that a forte or piano arrival is supported by the scoring.
summary: The orchestra gets louder by adding instruments (and octaves) and softer by removing them, with the CC ramps inside each track only finishing the shape. A forte arrival needs many instruments and a piano arrival needs few; count the active tracks at every arrival. The table below is the vault's default dynamic-to-CC1/velocity map.
sources: ["unir-orq-tema2 p.4-10", "unir-orq-tema3 p.11", "httyd-test-drive p.1-3, p.15"]
related: ["[[building-and-releasing-climaxes]]", "[[orchestration-errors-checklist]]", "[[orchestra-sizes-and-section-balance]]", "[[texture-secondary-melody-countermelody]]"]
---

# Dynamics by orchestration

## Core idea
A real crescendo is a change in **instrumentation**: more players, more octaves, brighter registers. CC
ramps alone only make the same players play harder. The density at an arrival must match its marked
dynamic. Forte arrivals with few instruments and piano arrivals with many are discursive errors.

## Rules
- R1 `MUST` Make a crescendo by adding instruments progressively, and a diminuendo by removing them.
- R2 `MUST` Support a forte arrival (cadence, downbeat, climax) with many instruments, and a piano arrival
  with few.
- R3 `PREFER` In a long crescendo, keep all three layers (melody, countermelody, accompaniment) going and
  add doublings to **each** layer, not only to the melody (Beethoven 7/II).
- R4 `PREFER` Add octave layers rather than raising every dynamic. In HTTYD the intro grows by octave
  layers while the pedal itself decays from ff to f.
- R5 `PREFER` Put every line's own dynamic on it: melody about one level above accompaniment (mf over mp).
- R6 `AVOID` Extreme notes at a dynamic they cannot produce: low flute at forte (MIDI 60–63), the top of
  the horn or trumpet at pp. Extreme notes speak well only at forte.
- R7 `ALLOWED` A **subito** change (subito p after ff, subito f restart) as a deliberate contrast. Make
  it with instrumentation too: drop the tracks, don't only ramp them down.

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

- **CC1 vs CC11:** CC1 changes timbre and loudness together (the real dynamic). Use CC11 only for
  fades to niente, phrase-end tapers and section-level trims. Keep CC11 ≥ 90 except in fades.
- **Shapes** (the builder ramps CC points linearly):
  - Swell `<>` on a long note: CC1 starts 15 under the target, peaks at 60–70 % of the note, and ends
    10 under the start.
  - Crescendo over n bars: one CC1 point per beat is enough. End the ramp **on the downbeat**, not
    before it.
  - fp: CC1 high (≈100) for the first 1/16, then a ramp in about 1/8 down to ≈35, then the hairpin
    if marked.
  - Sustained notes: CC1 has a gentle 3–5 point drift per bar so the sound is never static.
- **Crescendo by orchestration, 4-bar example** in D (velocities apply to shorts tracks):
  - Bar 1: `VLN II` tremolo D5 74 and `VC` D3 50 (CC1 35).
  - Bar 2: add `VLA` A4 69 and `CB` D2 38 (CC1 45).
  - Bar 3: add `HN` D4 62 and A4 69 and `BSN` (CC1 60), and `VLN I` enters at D6 86.
  - Bar 4: add `TPT` and `TBN`, a timpani roll from vel 40 to 100, and a suspended cymbal swell. All
    CC1 ramps reach 100 at the next downbeat.
  - Active track count by bar: 2, 4, 7, 10 or more.
- **Diminuendo:** first drop the brass and percussion, then the doublings at the octave, then the
  inner strings. The last track's CC11 fades to 0 over the last 1–2 beats.
- **Arrival lint:** for each marker or cadence bar, count the tracks with notes sounding on the downbeat.
  Rough target: pp to p = 1–5 tracks, mf = 5–10, f = 10–15, ff = everything that fits the texture.
- **Register lint:** flag flute notes ≤ 63 with CC1 > 80, horn notes ≥ 74 with CC1 < 40, and trumpet
  notes ≥ 79 with CC1 < 40.

## Checklist
- Does every crescendo add at least one track or octave layer before its peak?
- Do the CC1 ramps end on the arrival downbeat?
- Does every ff arrival have more active tracks than the bars before it?
- Do p arrivals and endings have few tracks, with no brass or percussion unless soft?
- Is the melody one dynamic level above the accompaniment?
- Are there no extreme-register notes at an impossible dynamic?
