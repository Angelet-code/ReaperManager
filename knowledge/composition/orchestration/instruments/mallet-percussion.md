---
id: orchestration.mallet-percussion
title: Mallet percussion and bells
aliases: [láminas, percusión de láminas, instrumentos de láminas, idiófonos de láminas, carrillón, glockenspiel, lira, campanólogo, xilófono, marimba, vibráfono, campanas, campanas tubulares, campanófono, crótalos, platillos antiguos, mazas, baquetas de láminas, motor del vibráfono, Glockenspiel, Xylophon, Marimbaphon, Vibraphon, Röhrenglocken, antike Zimbeln, crotales, chimes]
domain: orchestration
tags: [percussion, instrument, ranges, pitched-percussion, transposition, doubling]
style_scope: universal
use_when: Writing or checking glockenspiel, xylophone, marimba, vibraphone, tubular bells or crotales parts, or adding sparkle or a dry edge to a melody.
summary: Glock sounds two octaves above written (79–108), xylophone one octave (65–108; the common model starts at 72), crotales two octaves (84–108; common set 96–108); marimba (45–96, 5-octave to 36), vibraphone (53–89) and tubular bells (60–77, to 79) sound as written. Glock = sparkle doubling, xylophone = dry fast figuration, marimba = warm rolled chords, vibes = sustained halo with motor and pedal, bells = tolling.
sources: ["unir-orq-tema7 p.4-5, 12-16", "adler-orq-es p.434-442", "piston-orch p.314-318"]
related: ["[[mallet-percussion-extended-and-rare]]", "[[percussion-unpitched]]", "[[timpani]]", "[[percussion-section-writing]]", "[[piano-celesta-keyboards]]", "[[harp]]", "[[transposing-instruments]]", "[[doubling-colour-and-decay]]", "[[_instruments]]"]
---

# Mallet percussion and bells

## Core idea
Pitched idiophones laid out like a keyboard, usually one mallet per hand (2 per hand on marimba and
vibes). Several are written one or two octaves low **to save ledger lines**; MIDI holds the sounding
pitch. Dead strokes, bowing, cimbalom, steel drums, saw and period use: [[mallet-percussion-extended-and-rare]].

| Instrument | Written → sounding | Vault default (sounding) | Variants by author / model | Character |
|---|---|---|---|---|
| Glockenspiel (carrillón) | +24 | 79–108 (practical 79–105) | Adler, Piston agree (written G3–C6, 30 bars) | steel bars: bright, long ring, cuts through a tutti |
| Xylophone | +12 | 65–108 (practical 65–103) | Adler: common model 72–108, others 65–108 and 60–108. Piston: small 65–96, medium 65–101, large 65–108 | wood: dry, crisp, no sustain |
| Marimba | 0 | 36–96 (practical 45–96) | Adler: text C3–C7 (48–96), figure A2–C7 (45–96), some to F2 (41); Piston: large 48–96 | rosewood: warm, deep, sweet |
| Vibraphone | 0 | 53–89 | Adler: F3–F6 (53–89); C4–F6 (60–89); a rare F3–C7 [?] model (avoid). Piston's 48–96 is not used (reading doubtful) | metal: sustaining, motor vibrato, damper pedal |
| Tubular bells (campanas) | 0 | 60–77 (78–79 on 20-tube sets) | Adler, Piston agree | church bell, long complex ring |
| Crotales | +24 | 84–108 | Adler: common set 96–108 (written C5–C6); lower set 84–95, rare | pure, piercing, long ring |

## Rules
- R1 `MUST` Write sounding pitch in MIDI and check whether the patch already transposes (+24 / +12).
- R2 `MUST` Name the size when a note lies outside the common model (xylophone < 72, marimba < 48,
  vibes < 60); without the large model the player takes missing notes up an octave (Adler).
- R3 `PREFER` Glockenspiel for single melodic lines doubling a melody 1–2 octaves up. Metal mallets are
  the loudest (Adler keeps them for glock and crotales); rubber, plastic or yarn are softer (Adler). Fast
  figures blur in the ring: a feature, not a defect. The octave of high notes is hard to perceive (Piston).
- R4 `PREFER` Xylophone for rapid scales, arpeggios, repeated notes, trills and glissandi; doubling winds or
  strings it adds a dry, hard edge like a hard pizzicato. Brightest at the top (Adler). `AVOID` treating
  it as a cantabile voice (Piston); a soft, light pp solo still works (Debussy *Gigues*).
- R5 `MUST` Xylophone and marimba cannot sustain: a long note is a roll (Adler).
- R6 `PREFER` Marimba for warm melody, ostinato and **rolled 4-note chords** (two mallets per hand). Its low
  register is unique and beautiful but soft: keep the texture light around it; the top sounds like a
  xylophone. Yarn or soft rubber mallets.
- R7 `PREFER` Vibraphone: sustained, unrolled notes and chords (4, even 6 notes) are its idiom. `MUST` state
  the motor (off / on / slow–fast) and the pedal or *l.v.* ring (Adler). Motor off = pure tuning-fork tone.
- R8 `ALLOWED` Tubular bells for tolling, church, clock or alarm effects, soft or loud, often in octaves
  (Berlioz *Fantastique* V, "Great Gate of Kiev"). `PREFER` ≤ 2 notes at once per player. `AVOID` fast
  melodic runs; `ALLOWED` a fast pedalled figure for many bells pealing together (Adler).
- R9 `NEVER` expect a real bell below C4: it is impossible in a hall. Imitate a deep bell orchestrally (low
  piano/harp + tam-tam + low brass) (Piston).
- R10 `PREFER` Crotales: sparse single notes for shimmer at cadences or magical moments, let ring.
- R11 `MUST` Leave time for mallet changes (hard → soft) and mark ring length (*l.v.*) (Adler).
- R12 `AVOID` Mallet doubling of every note of a long melody: highlight phrases (general knowledge).

## Apply in MIDI / REAPER
- Tracks `GLOCK`, `XYLO`, `MARIMBA`, `VIBES`, `BELLS`, `CROTALES`, sounding pitch; rear, beside the timpani.
- Velocity = dynamics and mallet hardness (p 40–60, f 90–115); a hard/soft mallet change = another patch.
- Glock doubling of a violin line in 67–81: the same line +24 if it stays ≤ 108, else +12.
- Xylophone doubling fast woodwind 16ths: same notes +12, velocity a little above the woodwinds' level.
- Rolls (xylo, marimba): roll articulation, or 32nd repeats alternating two voices, velocity ±6 (inferred).
- Vibes: CC64 down for ring, lifted at harmony changes; motor = patch setting or an LFO.
- Bells: 2–4 s between strokes unless a peal; crotales and glock notes ≥ 1 beat long so the ring sounds.

## Checklist
- [ ] Glock 79–108, xylophone 65–108 (65–71 only if the patch/model has them), marimba 45–96 (36+ only on a 5-octave
      patch), vibes 53–89, bells 60–79, crotales 84–108 (96+ on a common set).
- [ ] ≤ 2 notes at once on glock, xylo and bells; ≤ 4 on marimba and vibes (6 only on vibes).
- [ ] Long xylophone/marimba notes are rolls; vibes have pedal and motor decided.
- [ ] Patch transposition checked before doubling.

## Examples
- Sparkle: Vln I E5–G5–A5 (76 79 81) doubled by glock E7–G7–A7 (100 103 105).
- Bells in octaves: C4 + C5 (60 + 72), f, let ring.
- Marimba bed: rolled Am chord A2–E3–C4–E4 (45 52 60 64), pp < mp.
