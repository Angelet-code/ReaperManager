---
id: orchestration.chord-voicing-family-stacking-tutti
title: Loud and tutti chords (brass first, woods on top, gaps filled)
aliases: [acorde de tutti, acorde tutti, acorde fuerte, tutti en acordes, acorde brillante, acorde final, acorde abierto, acorde lleno, policordio, policorde, acorde de novena de dominante, dos trompas igual a una trompeta]
domain: orchestration
tags: [chords, tutti, voicing, balance, brass, spacing, polychord]
style_scope: universal (modern symphonic default; natural-brass practice era-tagged)
use_when: Voicing a forte or fortissimo chord for full orchestra or for brass plus others (climax, button, final chord, stab, polychord), or balancing a held tutti chord through a crescendo.
summary: Build the tutti chord brass first so the brass alone sounds right (trumpets on top, horns in pairs or as a 4-part chord between trumpets and trombones, tuba under the lowest trombone). Put high woodwinds above the brass to reinforce upper partials, low reeds with the bass, strings divided where they sound best. Loud chords are close, with every gap filled and upper roots doubled; trumpets and trombones play under the marking.
sources: ["adler-orq-es p.363-364", "adler-orq-es p.547", "adler-orq-es p.562-569", "piston-orch p.396-403", "piston-orch p.426-430", "piston-orch p.444-451"]
related: ["[[chord-voicing-family-stacking]]", "[[chord-voicing-family-stacking-soft]]", "[[brass-section-writing]]", "[[texture-unison-and-tutti-layouts]]", "[[building-and-releasing-climaxes]]", "[[dynamics-by-orchestration]]", "[[tutti-balance-by-role]]", "[[natural-horn-period-practice]]"]
---

# Loud and tutti chords

## Core idea
In a loud tutti the brass dominates, above all trumpets and trombones. Middle-register woodwinds vanish
under it, so they go high and brighten the brass's upper partials. Loud chords want close spacing: open
gaps leave the bass notes' strong overtones uncovered. Piston calls this recipe a starting point, not a
formula.

## Rules
- R1 `MUST` Build brass first; the brass alone must sound well as a unit (Piston).
  - Method (a): 4 horns in pairs on two notes, each pair equal to one trumpet or trombone (Piston, Adler).
  - Method (b): trumpets on a close triad, trombones on the same triad an octave lower, tuba on the bass,
    then the 4 horns as a 4-part chord placed between them (Piston).
- R2 `MUST` Above mf, two horns per note against single trumpets or trombones; at mf or softer each brass
  player gets its own note (Adler). A low-register trumpet is weaker and needs fewer horns.
- R3 `AVOID` A self-contained woodwind chord in the middle of a loud tutti. `PREFER` piccolo, flutes, oboes
  and clarinets above the brass on chord tones, with as many unison doublings as available (Piston).
- R4 `PREFER` Bassoons, bass clarinet and contrabassoon on the bass with tuba, trombone III and horn IV
  (Piston). Give the English horn a middle chord tone with trumpets or horns rather than omitting it.
- R5 `ALLOWED` Strings wherever they sound best as sections, divided for richness; high string tremolo
  evens out a loud chord (Piston, Weber).
- R6 `PREFER` Close position with chord tones in every gap (Piston). `AVOID` open gaps and narrow low
  intervals in loud chords (a low third in trombone II was the weakest note of Weber's chord).
- R7 `PREFER` In a medium-low loud chord, double or triple the upper roots to mask the low notes' strong
  major-third overtone (Piston).
- R8 `ALLOWED` Undoubled chord tones when the root and its octaves below reinforce them (Piston, Weber:
  ob I, hn I, hn IV, trb II, bsn II single).
- R9 `MUST` When brass dominates a ff/fff chord, trumpets and trombones play below the marking (Piston).
- R10 `MUST` On a held tutti crescendo, trombones and timpani outgrow the woodwinds and most strings; horns
  crescendo better than woods. Cap the brass or accept the imbalance for drama (Piston).
- R11 `PREFER` Pick the chord type by intent (Adler ch. 15):
  - **open, resonant:** root on almost everything (strings, trumpets, horns, timpani, flutes an octave up),
    other tones on a few winds;
  - **full:** every section plays every chord tone;
  - **middle-weighted:** many instruments in the lower-middle octave (≈ 50–62), the upper octave
    (≈ 74–86) on woodwinds only;
  - **very brilliant final:** all chord tones in every upper octave, only the tonic in the lowest octave
    (Vc, Cb, tuba, trb III, timpani); high brass doubled one and two octaves up by violins, flutes and
    piccolo; tremolos, rolls and a cymbal crash (Mahler 1).
- R12 `PREFER` Polychords: each triad in its own register band, no shared or bridging tone between them,
  open rather than close intervals, close dissonance in one spot only. A brilliant upper layer = woodwinds
  massed in superposition over high trumpets (Piston).
- R13 `AVOID` Endless tutti; `PREFER` withhold trombones and timpani from one phrase so the next weighs more
  (Adler).

## Period practice
- `[era: Classical–Beethoven, natural brass]` Horns and trumpets take only open notes (tonic/dominant,
  horn fifths); give harmonic and chromatic filling to trombones or woods (Adler). See
  [[natural-horn-period-practice]].
- `[era: early Romantic, Weber]` Brilliant ff chord: strings stacked from C3 to G6 (48–91), brass
  stacked, only oboes and clarinets interlocked, several notes undoubled. Weber pairs 2nd oboe with
  1st trumpet as closer kin than clarinet with trumpet.

## Apply in MIDI / REAPER
**ff C major template** (method b; illustration):
- Bass: `TUBA` C2 36; `CB` C2 36; `VC` C2 36 + C3 48; `BSN`/`BCL` C3 48; `TIMP` C3 48 (roll).
- `TBN` E4 64, C4 60, G3 55; `HN` 1 G4 67, 3 E4 64, 2 C4 60, 4 G3 55; `TPT` E5 76, C5 72, G4 67.
- `EH` C5 72 (with Tpt 2).
- Above: `OB` C6 84, G5 79; `CL` E6 88, C6 84; `FL` G6 91, E6 88; `PICC` C7 96.
- `VLN I` div C6 84 + G5 79 tremolo; `VLN II` E5 76 + C5 72; `VLA` G4 67 + C4 60.
- Lint: below 48 only the 36→48 octave; C and G carry the most instruments.

**Levels** (inferred, Albion-type): woods and strings CC1 ~110, horns ~105, trumpets and trombones
~90–95, timpani velocity ~100. Then render and check that woods and strings are audible; lower the heavy
bed before raising anything ([[user-taste]] R15).

On a held crescendo, end the brass CC1 ramp 10–15 points below the woods' ramp unless brass dominance is
the point (R10).

## Checklist
- Does the brass chord alone sound complete and balanced (2 horns per trumpet note at f)?
- Are high woods above the brass and low reeds on the bass, not a separate middle chord?
- Are gaps filled and upper roots doubled, with no third below 48?
- Are trumpet and trombone CC1 under the marked level?
- Is the tutti chord saved for a structural point?
