---
id: orchestration.chord-voicing-family-stacking-soft
title: Soft, luminous and fading chords (open gaps, safe registers)
aliases: [acorde suave, acorde piano, acorde pianissimo, acorde final suave, acorde luminoso, acorde oscuro, acorde que se apaga, espacios abiertos, huecos en el acorde, tutti pianissimo, ff-pp, metales con sordina en acordes]
domain: orchestration
tags: [chords, soft, voicing, spacing, ending, balance]
style_scope: universal (Romantic and Impressionist examples)
use_when: Voicing a p/pp chord, a soft final chord, a ppp tutti, or a chord that starts loud and fades (ff → pp).
summary: Soft chords may leave open gaps so the low instruments' overtones sound and two colour layers separate; loud ones may not. Put every note on an instrument that can play it at that dynamic, keep very high notes on violins rather than undoubled flutes, and in a fading chord double only the essential notes (bass, melody, top) so the rest stays soft. Muted brass and stopped horns blend with woods; a full ppp tutti is a legitimate, rich sound.
sources: ["adler-orq-es p.252-255", "adler-orq-es p.152-157", "adler-orq-es p.363-364", "adler-orq-es p.566-569", "piston-orch p.396-403", "piston-orch p.447-450"]
related: ["[[chord-voicing-family-stacking]]", "[[chord-voicing-family-stacking-tutti]]", "[[dynamics-by-orchestration-crescendo-and-fade]]", "[[woodwind-section-writing-chords]]", "[[brass-basics-mutes]]", "[[string-section-writing-homophony]]", "[[harp]]"]
---

# Soft, luminous and fading chords

## Core idea
At low dynamics the overtones of the bass instruments become audible colour, so open spaces in the
middle of a chord are an asset; at loud dynamics they leave holes (Piston). The other soft-chord risk
is register: many winds cannot play softly at their extremes, and a single high flute reads louder than
the rest of the chord.

## Rules
- R1 `ALLOWED` Open spaces in soft chords, letting overtones colour the sound and helping the ear separate
  two colour layers (Piston, Brahms 3 closing chord). The result is hard to predict: render and check.
  `AVOID` the same gaps in loud chords ([[chord-voicing-family-stacking-tutti]] R6).
- R2 `MUST` Give each note to instruments that can play it at that dynamic, and for a ff → pp chord at
  both ends of the fade (Adler). Typical failures: low flute and top horn/trumpet at pp, oboe and
  bassoon bottoms (no soft attack); see `weak_dynamics` in `data/instruments.json`.
- R3 `AVOID` Very high, undoubled flute notes in a soft final chord (around F6 = 89 and above): hard to
  start softly, the chord sounds louder than marked, and nothing tempers the piercing tone (Adler).
  `PREFER` violins on the top note (they play any pitch softly), with piccolo only in an easy register;
  or strings on the top octave and woodwinds an octave below.
- R4 `PREFER` A luminous, warm chord: a clear high/low separation, only flutes (with high violins) on top,
  everything else middle or low (Adler, Piston on Brahms 3). Romantic endings often give the top notes to
  the flutes.
- R5 `PREFER` Fading chord: double at the unison only the essential notes (bass, the melody note, the top);
  leave every other note single so it stays soft and keeps its colour (Adler on Debussy, *La Mer*).
  `ALLOWED` a wide gap between a low bass and the rest; a harp "ping" on the top note.
- R6 `ALLOWED` A full-orchestra ppp tutti ("as soft as possible" for those forces) gives a sumptuous sound
  no small group can make; accept that some instruments sit outside their soft registers (Piston, Strauss
  *Don Juan*).
- R7 `PREFER` Dominant 9th on the harmonic series: root alone in the lowest octave, every space above the
  bass filled with chord tones, the 9th never doubled (Piston). `ALLOWED` a very soft high timpani roll on
  the root, soft sticks, above the bass.
- R8 `ALLOWED` Muted trumpets, trombones and tuba with stopped horns blend with woodwinds on fairly equal
  terms (Piston, Stravinsky). Brass can also play softly open: do not remove it just to be soft.
- R9 `PREFER` Double basses in unison with the cellos' open C2 (36) for a bass rich in upper partials
  (Piston).
- R10 `PREFER` Dark soft colour = low and close: trumpets low, horns inside, the whole chord lowered (Adler);
  woods with a low top voice ([[woodwind-section-writing-chords]]).
- R11 `ALLOWED` Low strings can carry a sombre, organ-like background alone, violas in unison with the
  first cellos (Adler on Fauré, *Requiem*).

## Apply in MIDI / REAPER
- **Luminous p chord, F major** (illustration): `CB` + `VC` F2 41; `VC` div C3 48; `VLA` div A3 57 + C4 60;
  gap; `HN` F4 65 (CC1 35); `FL 1` A5 81, `FL 2` F5 77; `VLN I` div C6 84 + F6 89 (the top note on
  violins, R3). Strings CC1 30–35, flutes CC1 40.
- **Fading chord** (after *La Mer*, illustration): `CB` C#2 37 alone low; gap; middle chord tones one
  instrument each; melody E#5 77 on `TPT` + `OB 2` unison and `EH` an octave below; top A#6 94 on
  `VLN I` + `PICC` + `HARP` (one hit). CC1 ramps from ~105 to ~20 over the fade on sustaining tracks; the
  doubled notes end 5–10 points higher than the singles; the harp plays once, then rings.
- **ppp tutti:** all tracks CC1 10–20, CC11 ~90; timpani roll velocity 20–30 on soft sticks.
- **Muted brass in a woodwind chord:** use mute or stopped patches; velocity/CC1 like the woods at the same
  marking.

## Checklist
- Are the open gaps only in soft chords, and was the soft chord rendered and checked?
- Is every note playable at its dynamic, including both ends of a fade?
- Is no undoubled flute on a soft top note around 89 or higher?
- In a fading chord, are only bass, melody and top doubled?
