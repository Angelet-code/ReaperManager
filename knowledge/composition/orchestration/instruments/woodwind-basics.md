---
id: orchestration.woodwind-basics
title: Woodwind basics
aliases: [maderas, sección de maderas, instrumentos de madera, aerófonos, Holzbläser, bois, legni, caña simple, caña doble, sobresoplado, registros de las maderas, respiración, vibrato, senza vibrato, sonido blanco, madera a dos, madera a tres, madera a cuatro, a 2, a 3, instrumentos auxiliares, embocadura]
domain: orchestration
tags: [woodwinds, families, transposition, registers, dynamics, breathing, vibrato, section-size, notation]
style_scope: universal
use_when: Before writing for any woodwind, to pick the instrument and register, check transposition and dynamics by register, plan breaths and choose the section size for an era.
summary: Four families (flutes, oboes, clarinets, bassoons; saxes apart) differ by reed, bore and overblowing (octave, clarinet a 12th). Pick a woodwind's register for colour and carrying power: flutes are weak low and grow upward, oboe and bassoon never pp in their lowest fifth, only the clarinet has full dynamics everywhere; extremes are hard, the top more than the bottom. Every line must breathe; modern default section = by threes.
sources: ["adler-orq-es p.164-171", "adler-orq-es p.177-180", "piston-orch p.114-127"]
related: ["[[woodwind-basics-articulation-and-effects]]", "[[flute-piccolo]]", "[[oboe-english-horn]]", "[[clarinets]]", "[[bassoons]]", "[[saxophones]]", "[[transposing-instruments]]", "[[woodwind-section-writing]]", "[[orchestra-sizes-and-section-balance]]", "[[score-and-parts-layout]]", "[[_instruments]]"]
---

# Woodwind basics

## Core idea
"Woodwind" = every orchestral wind that is not brass (lips in a cup); material is irrelevant (metal flutes,
metal saxes). The most heterogeneous family: each instrument, and each register of one instrument, has its
own colour, weight and carrying power — far more than across the strings.

| Family | Standard + auxiliaries | Reed | Bore | Overblows at |
|---|---|---|---|---|
| Flutes | flute; piccolo, alto, bass flute | none (edge) | cylindrical, open | octave (12) |
| Oboes | oboe; EH, oboe d'amore, heckelphone | double | conical | octave |
| Clarinets | Bb/A; Eb, bass, (alto, basset horn, contrabass) | single | cylindrical, stopped | **12th (19)** |
| Bassoons | bassoon; contrabassoon | double | conical | octave |
| Saxophones | soprano–baritone ([[saxophones]]) | single | conical, metal | octave |

Adler puts bassoons in the oboe family; Piston keeps four families. Auxiliaries extend a family's range and
favour the end they extend: a higher one is weak at its bottom, a lower one at its top.

## Transposition (written → sounding, semitones)
0: flute, oboe, bassoon, C clarinet · +12 piccolo · +3 Eb clarinet, sopranino sax · +2 D clarinet ·
+8 Ab clarinet (rare) · −2 Bb clarinet, soprano sax, bass clarinet in bass clef (German) · −3 A clarinet,
oboe d'amore · −5 alto flute · −7 English horn, oboe da caccia, basset horn · −9 alto clarinet, alto sax ·
−12 bass flute, heckelphone, contrabassoon · −14 bass clarinet (treble/French), tenor sax · −15 bass
clarinet in A (treble) · −21 baritone sax, Eb contrabass clarinet · −26 Bb contrabass clarinet, bass sax.
Adler's table says the Eb clarinet sounds "below": his staff shows +3. Full table: [[transposing-instruments]].

## Rules
- R1 `MUST` choose a woodwind register for its colour and carrying power, not only its pitch (Piston).
  Overblowing repeats the fingering at the octave, at the twelfth on the clarinet: register breaks follow.
- R2 `AVOID` relying on control of pitch, dynamics, trills or speed at the extremes; the top is harder than
  the bottom. `AVOID` very high notes where a soft dynamic is needed: shrill, often loud-only.
- R3 `MUST` dynamics by register:
  - flute, piccolo: little volume in the lowest octave, power grows upward;
  - oboe, bassoon: `NEVER` pp in the lowest fifth (7 st), they grow louder downward;
  - clarinet: full pp–ff in every register (the only one), best niente;
  - English horn: low fifth softer and less coarse than the oboe's.
- R4 `MUST` read a "weak" register as "do not bury it", not "do not use it": fine in solos and light
  textures.
- R5 `MUST` let every line breathe at natural places (breath marks are not written); in fast passages leave
  notes out for a breath. Phrase like a singer; a fresh breath can sharpen a motive.
- R6 `MUST` air demand: flutes (alto and bass more) use the most air; the oboe the least, but it still needs
  frequent rests (reed, lips, stale air).
- R7 `ALLOWED` leave vibrato unmarked (players add it; width is taste). `MUST` mark "senza vibrato" / "non
  vib." / "white tone" to remove it and "con vibrato" / "normale" to restore.
- R8 `PREFER` the section size of the target era (below); modern default = by threes.
- R9 `MUST` score and track order: piccolo, flutes, oboes, English horn, clarinets, bass clarinet,
  (saxophones), bassoons, contrabassoon.
- R10 `MUST` wind notation: 1st and 2nd on one staff (stems up/down), "a 2" / "a 3" for unison, "1." / "2."
  (or rests) for one player. `NEVER` "divisi" or "unis." in wind parts. Details: [[score-and-parts-layout]].

## Period practice (section sizes)
- `[era: Classical, to early Beethoven]` by twos: 2 fl, 2 ob, 2 cl (pitch set by key), 2 bn; Haydn and
  Mozart sometimes 1 flute; English horn rare (Haydn 22).
- `[era: 19th c. after Beethoven]` picc, 2 fl, 2 ob, EH, 2 cl, bcl, 2 bn, cbn.
- `[era: 20th c., Piston]` by threes (normal): 2 fl + picc, 2 ob + EH, 2 cl + bcl, 2 bn + cbn = 12 parts.
  By fours: 3 + auxiliary in each family. 3 flutes may replace 2 fl + picc.
- `[era: late 19th–20th c., Adler]` large: picc (or 2), 3 fl, 3 ob, EH, Eb/D clarinet, 2–3 cl, bcl, 3 bn, cbn.

## Apply in MIDI / REAPER
- One track per player, concert pitch, score order; "a 2" = same notes on two tracks or a section patch,
  never one solo patch at double velocity (inferred).
- Before writing, look up the line's register in the instrument note and set the CC1 floor/ceiling from R3.
- Breaths: Albion woods legato every ~8 s with a 220 ms gap ([[user-taste]] R17); solo lines a real gap
  (≥ 1/8 beat) every 2–4 bars. SWAM: continuous CC11, dip only at breaths ([[modeled-instruments-swam]]).
- Vibrato: default moderate (CC1 on SWAM); "white tone" = CC1 ≈ 0, or a non-vibrato patch (inferred).
- Template: by threes, 12 tracks; by twos for Classical pastiche.

## Checklist
- [ ] Notes in range; register chosen for colour and weight.
- [ ] No pp in oboe/bassoon lowest fifth; no loud low flute; no soft extreme highs.
- [ ] Every wind line has breaths; oboe has rests.
- [ ] Section size and track order fit the era.
