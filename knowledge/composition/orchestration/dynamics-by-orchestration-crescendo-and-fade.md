---
id: orchestration.dynamics-by-orchestration-crescendo-and-fade
title: Crescendo and diminuendo written into the orchestration
aliases: [crescendo por orquestación, diminuendo escrito en la orquestación, final que se apaga, final en diminuendo, crescendo al unísono, crescendo sobre acorde tenido, desvanecer, morendo, perdendosi, acumulación de doblajes]
domain: orchestration
tags: [dynamics, crescendo, diminuendo, ending, fade, build]
style_scope: universal (Classical/Romantic examples; period differences tagged)
use_when: Writing a bar-by-bar crescendo or diminuendo, a fading ending, a crescendo on one held note or chord, or a phrase that dies away after its peak.
summary: Build by adding tracks, octaves and doublings bar by bar so CC ramps only finish the shape; a unison crescendo adds brass and timpani to the note the orchestra already holds. Fade by removing brass and percussion first, then octave doublings, then inner parts, and by moving the remaining voices into easy, soft registers. A fading ending repeats its cadence and drops the bass on each tonic. On a held tutti crescendo, cap trombones and timpani.
sources: ["unir-orq-tema2 p.4-10", "httyd-test-drive p.1-3", "adler-orq-es p.145-147", "adler-orq-es p.548-556", "adler-orq-es p.569", "piston-orch p.388-395", "piston-orch p.396-403", "piston-orch p.426-430"]
related: ["[[dynamics-by-orchestration]]", "[[building-and-releasing-climaxes]]", "[[chord-voicing-family-stacking-tutti]]", "[[chord-voicing-family-stacking-soft]]", "[[doubling-colour-and-decay]]", "[[texture-unison-and-tutti]]"]
---

# Crescendo and diminuendo written into the orchestration

## Core idea
The dynamic shape lives in the scoring first: instruments, octaves and registers enter or leave, and the
CC ramps inside each track only smooth the joins. Rules and the CC map: [[dynamics-by-orchestration]].

## Rules
- R1 `PREFER` Let doublings accumulate through a crescendo: add instruments progressively (Piston), at
  least one new track or octave per bar or phrase step.
- R2 `PREFER` Unison crescendo: add brass and timpani to the note the orchestra already sustains, then
  release into the main idea spread over several octaves (Adler on Barber 1).
- R3 `MUST` On a held tutti chord in crescendo, trombones and timpani outgrow the other winds and most
  strings; horns crescendo better than woods in weak registers. Cap the brass and timpani curve or accept
  the imbalance for drama (Piston).
- R4 `PREFER` Diminuendo order: brass and percussion out first, then octave doublings, then inner strings;
  the last voice fades by CC11.
- R5 `PREFER` Write the diminuendo into the voicing as well: thin the texture and lower and close the
  spacing until the strings sound like one singing instrument (Adler on Tchaikovsky's *Serenade*).
- R6 `PREFER` Fading ending: put every instrument in a register easy to play softly, repeat a cadential
  formula (three times in Tchaikovsky) and drop the bass on each tonic arrival (Adler).
- R7 `ALLOWED` Let the strings stop at a phrase climax and finish the phrase on winds alone in diminuendo,
  the winds continuing the lines the strings dropped (Piston on *Tristan*).
- R8 `ALLOWED` A held bass re-bowed (bow change, no slur) lasts a little longer than the other strings,
  which makes its final disappearance noticeable (Adler).
- R9 `MUST` A ff → pp chord gives each note to instruments that can manage both ends; double only bass,
  melody note and top ([[chord-voicing-family-stacking-soft]] R5).
- R10 `PREFER` A big full chord right after pale, restrained harmony sounds clamorous: contrast of density
  is the effect (Adler on Tchaikovsky).

## Period practice
- `[era: Beethoven]` Octave doublings used freely to raise the dynamic level; `[era: Mozart, Mendelssohn,
  Debussy, Ravel]` preference for pure, unmixed colours, doubling only at times (Adler). For a Classical
  or Impressionist pastiche, grow dynamics with fewer doublings and more register.
- `[era: Classical, natural brass]` A tutti crescendo is limited: horns and trumpets on open notes,
  timpani on tonic and dominant only (Adler).

## Apply in MIDI / REAPER
**Crescendo by orchestration, 4 bars in D** (velocities apply to shorts tracks):
- Bar 1: `VLN II` tremolo D5 74 and `VC` D3 50 (CC1 35).
- Bar 2: add `VLA` A4 69 and `CB` D2 38 (CC1 45).
- Bar 3: add `HN` D4 62 + A4 69 and `BSN` (CC1 60); `VLN I` enters on D6 86.
- Bar 4: add `TPT` and `TBN`, a timpani roll from velocity 40 to 100, and a suspended-cymbal swell. All
  CC1 ramps reach 100 at the next downbeat; brass ramps stop 10–15 points lower (R3).
- Active tracks by bar: 2, 4, 7, 10+.

**Fading ending, 6 bars** (illustration): bars 1–2 cadence V–I tutti mf, brass out at the end of bar 2;
bars 3–4 the same cadence on strings + clarinets, Cb and Vc drop the bass on the I; bars 5–6 the cadence
again in violins, violas and one flute in their middle registers, CC1 ramp from 40 to 15, CC11 from 100
to 0 over the last 2 beats.

**Climax-phrase fade** (R7): strings' CC1 to 0 at the peak bar's end; woods take the lines with CC1 from
f down to p over the next 2 bars.

## Checklist
- Does each crescendo bar add a track or an octave, not only CC?
- Are trombone and timpani ramps capped on a held tutti crescendo?
- Does each diminuendo remove brass and percussion first?
- Do fading endings move the last voices into easy soft registers and drop the bass on the tonic?
