---
id: orchestration.texture-counterpoint
title: Contrapuntal texture in the orchestra
aliases: [textura contrapuntística, contrapunto orquestal, polifonía, fuga orquestal, líneas independientes, imitación]
domain: orchestration
tags: [texture, counterpoint, doubling, separation]
style_scope: universal (Mozart to film)
use_when: Orchestrating two or more independent lines of similar importance (fugue, canon, combined themes, a theme set against another theme).
summary: Contrapuntal lines must stay independent in rhythm and harmony, so give each line its own mixed group of instruments and a distinct colour. Octave-double each line widely to get a big sound from only two lines. Break routine pairings, such as bassoons with cellos, when that keeps lines separate.
sources: ["unir-orq-tema3 p.13-14", "film-4day-challenge slide 5"]
related: ["[[texture-types]]", "[[line-separation-and-fusion]]", "[[texture-secondary-melody-countermelody]]", "[[doubling-colour-and-decay]]"]
---

# Contrapuntal texture

## Core idea
Superimposed melodic lines break the melody + accompaniment scheme. The lines can be fugal or different
themes combined. In orchestration the main job is to keep them **audibly separate**. Timbre and register
groups do that.

## Rules
- R1 `MUST` Keep the lines independent in rhythm (different onsets) and harmony (different
  dissonance points).
- R2 `MUST` Give each line a different timbre group, so colour tells the lines apart (Mozart 40/III:
  line A = flute, oboes, cellos, basses; line B = violins I and II, bassoons).
- R3 `ALLOWED` Double each line widely at the octave. With only two lines this gives a big sound from few
  elements.
- R4 `ALLOWED` Break routine pairings when it helps separation: bassoons with the violins, not with the
  cellos.
- R5 `PREFER` Mixed groups (woodwind + string) for each line. Two lines that are both mixed groups
  stay distinct when the mixtures differ.
- R6 `PREFER` For fugal entries, give each entry a new colour, or add a family per entry, so the
  texture builds as the voices accumulate.
- R7 `AVOID` Pads or sustained chords under real counterpoint. They mask the dissonances the lines
  create. If harmony is needed, keep it soft and in a separate register.

## Apply in MIDI / REAPER
- One track **per instrument**, with each instrument assigned to a line. Name tracks with the line
  letter: `A FL`, `A OB`, `A VC`, `A CB`, `B VLN I`, `B VLN II`, `B BSN`.
- **Two-line recipe (Mozart 40/III model, in G minor):**
  - Line A (upper melody + bass octave): `FL` at the written pitch +12 if below 72; `OB` at pitch, then
    split into octaves at climaxes; `VC` at pitch −12 or −24 to land in 36–60; `CB` at `VC` −12.
  - Line B: `VLN I` at pitch in 67–88, `VLN II` −12, and `BSN` at the pitch that falls in 46–65.
- **Separation check** (per pair of lines, sampled per beat):
  - The share of shared onsets should be below 50 %.
  - The register centres (median MIDI) should differ by at least 7 semitones, or the families should
    differ.
  - There should be no unisons lasting more than 1 beat.
- **Fugue build:**
  - Entry 1 on strings only (Va), CC1 50.
  - Entry 2 on Vln II + clarinet.
  - Entry 3 on Vln I + oboe.
  - Entry 4 on Vc + Cb + bassoon.
  - Each entry raises the overall CC1 by about 8 (see [[dynamics-by-orchestration]]).
- **Articulation differences help:** legato patch on one line, staccato/spiccato patch on the other
  (rhythm/articulation is a main separation parameter).

## Checklist
- Does each line have its own colour group, with no instrument playing two lines at once?
- Are shared onsets between lines below 50 %?
- Is there no sustained pad masking the counterpoint?
- Are octave doublings of each line inside every instrument's range?
- Does each new fugal entry add a colour or family?
