---
id: orchestration.mallet-percussion
title: Mallet percussion and bells
aliases: [láminas, percusión de láminas, carrillón, glockenspiel, lira, xilófono, marimba, vibráfono, campanas, campanas tubulares, crótalos, Glockenspiel, Xylophon, Vibraphon, Röhrenglocken, crotales]
domain: orchestration
tags: [percussion, instrument, ranges, pitched-percussion, transposition]
style_scope: universal
use_when: Writing or checking glockenspiel, xylophone, marimba, vibraphone, tubular bells or crotales parts, or adding sparkle/dry doublings to a melody.
summary: Glockenspiel sounds two octaves above written (79–108), xylophone an octave above (≈ 65–108), crotales two octaves above (≈ 84–108); marimba (≈ 45–96, 5-octave 36–96) and vibraphone (standard 3-octave F3–F6, 53–89; some 4-octave models to C7 = 96) and tubular bells (60–77, to 79) sound as written. Glock = sparkle doubling, xylophone = dry rhythmic doubling, vibes = soft sustained halo.
sources: ["unir-orq-tema7 p.4-5, 12-16"]
related: ["[[percussion-unpitched]]", "[[timpani]]", "[[piano-celesta-keyboards]]", "[[harp]]", "[[transposing-instruments]]", "[[_instruments]]"]
---

# Mallet percussion and bells

## Core idea
Pitched idiophones laid out like a keyboard, played with mallets (one per hand usually; 2–4 on marimba and
vibes). Several transpose by octaves **to save ledger lines**; MIDI must hold the sounding pitch.

| Instrument | Written → sounding | Full (sounding) | Practical | Character |
|---|---|---|---|---|
| Glockenspiel (carrillón) | +24 | 79–108 (written G3–C6) | 79–105 | bright, bell-like sparkle; long ring |
| Xylophone | +12 | ≈ 65–108 (model-dependent; general knowledge) | 65–103 | dry, cutting, little resonance |
| Marimba | as written | 36–96 (typical 45–96 per source; 5-oct to 36) | 45–96 | warm, round, expressive; low notes soft |
| Vibraphone | as written | 53–89 (standard 3-octave F3–F6; 60–89 models; 4-octave models to 96) | 53–89 | metallic, sustaining; motor vibrato, damper pedal |
| Tubular bells (campanas) | as written | 60–79 (78–79 extension) | 60–77 | church-bell; long, complex ring |
| Crotales | +24 | ≈ 84–108 (general knowledge) | 84–108 | pure, piercing antique cymbals |

## Rules
- R1 `MUST` place notes at sounding pitch: glock 79–108 even though the part reads G3–C6; check whether the
  sample patch already transposes (+24 / +12) before shifting notes.
- R2 `PREFER` glockenspiel for single melodic lines doubling a melody 1–2 octaves up (sparkle).
- R3 `PREFER` xylophone for dry, rhythmic doubling and solo passages (Saint-Saëns "Fossils").
- R4 `ALLOWED` marimba for warm melodic or accompaniment figures; its low register is soft, keep the texture light (general knowledge).
- R5 `ALLOWED` vibraphone for sustained soft halos; set motor vibrato speed and use the damper pedal (CC64).
- R6 `ALLOWED` tubular bells for tolling/church effects, often in octaves (Berlioz *Fantastique* V);
  `AVOID` fast passages and dense chords: the long, complex ring blurs (general knowledge).
- R7 `ALLOWED` agility (general knowledge): xylophone/glock/marimba handle fast scales and repeated notes;
  chords limited to ≈ 2 notes (two mallets) on glock/xylophone, up to 4 on marimba/vibes, all within
  ≈ an octave per hand.
- R8 `AVOID` mallet doubling on every note of a melody for long stretches: it tires the ear; use it to
  highlight phrases (general knowledge).

## Apply in MIDI / REAPER
- Tracks `Glock`, `Xylo`, `Marimba`, `Vibes`, `Bells`, `Crotales` at sounding pitch.
- Velocity = dynamics (p 40–60, f 90–115); no CC1 needed except for vibes/bowed patches.
- Glock doubling of a violin melody in 67–81: add the same line +24 if it stays ≤ 108, else +12.
- Vibes: CC64 down for legato ring, lift on harmony changes; tubular bells: allow 2–4 s ring between hits.
- Pan: rear, left or right of centre (percussion row).

## Checklist
- [ ] Glock notes 79–108, xylophone 65–108, crotales 84–108, marimba 36–96 (45+ unless a 5-octave patch),
      vibes 53–89 (90–96 only on a 4-octave model), tubular bells 60–79.
- [ ] Simultaneous notes ≤ 2 on glock/xylo, ≤ 4 on marimba/vibes.
- [ ] Tubular bells not in fast runs.
- [ ] Doublings checked against the patch's own transposition.

## Examples
- Sparkle: Vln I melody E5–G5–A5 (76 79 81) doubled by glock E7–G7–A7 (100 103 105).
- Bells in octaves: C4 + C5 (60 + 72), f, let ring.
