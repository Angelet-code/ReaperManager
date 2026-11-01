---
id: orchestration.violin
title: Violin (Vln I / Vln II)
aliases: [violín, violines, violín primero, violín segundo, Violine, Geige, violino, violon]
domain: orchestration
tags: [strings, instrument, ranges, registers]
style_scope: universal
use_when: Writing, checking or voicing a violin I / violin II part (section or solo) in MIDI.
summary: Violin sounds as written, G3–E7 (55–100) orchestrally, comfortable 55–88; the E string (76–88) is the brightest and strongest, the D string (62–74) the weakest, the G string (55–74) dark and powerful for broad melodies. Most agile string; use détaché/spiccato for fast notes and divisi rather than chords in sections.
sources: ["unir-orq-tema4 p.5-7, 15-21", "apuntes-orq-sesion1 scan p.5-6", "unir-orq-tema1 p.8-11"]
related: ["[[string-techniques]]", "[[orchestra-sizes-and-section-balance]]", "[[stage-seating-pan-depth]]", "[[viola]]", "[[cello]]", "[[flute-piccolo]]", "[[_instruments]]"]
---

# Violin (Vln I / Vln II)

## Core idea
Smallest and highest string: bright, lyrical, powerful, the default melodic voice of the orchestra until
the late 19th c. Open strings **G3 D4 A4 E5 (55 62 69 76)**, tuned in fifths, treble clef, non-transposing.
Two sections (Vln I, Vln II) each play one line unless marked divisi.

| Zone | MIDI | Colour / behaviour |
|---|---|---|
| G string | 55–67 (sul G melodies up to D5 = 74) | dark, excellent power, broad expressive melodies |
| D string | 62–74 | weakest string: gentle, grey, soft |
| A string | 69–81 | strong in 1st position, loses brilliance as it climbs |
| E string | 76–88 | most brilliant and strongest; strident if forced, ethereal and luminous when soft |
| High extension | 89–93 | 6th–7th position: intonation harder, less power; use sparingly |
| Extreme | 94–100 | orchestral ceiling ≈ E7 (100); short, exposed, tutti-supported only |
| Solo only | 101–107 | figure shows stopped notes to ≈ B7, harmonics to ≈ D8 (110) [approx.] |

Full orchestral range **55–100**, practical **55–88**.

## Rules
- R1 `MUST` keep every note ≥ 55 (open G3). Nothing below exists on the instrument.
- R2 `AVOID` section notes above 93 (A6); `NEVER` above 100 in orchestral parts (apuntes R6). Each string
  is best in its first octave (G3–G4, D4–D5, A4–A5, E5–E6); tension and intonation risk grow above it.
- R3 `ALLOWED` sul G melody up to D5 (74) for a dark, intense colour (Mahler 3/VI moves G→D string).
- R4 `AVOID` open strings (55/62/69/76 held long and exposed) in expressive melody: no vibrato, different
  timbre; fine in fast scales and ornaments.
- R5 `ALLOWED` fast scales, arpeggios, repeated notes and string crossings: most agile string. `PREFER`
  détaché/separate bows for fast runs, not legato (Flight of the Bumblebee: winds slur, strings détaché).
- R6 `MUST` give every triple/quadruple stop at least one open-string pitch; comfortable keys D, G, A, E, C.
  `AVOID` many multiple stops in sections, especially with many accidentals (dirty result); `PREFER` divisi.
- R7 `MUST` mark concertmaster solos "solo" → use a solo-violin patch, not the section.
- R8 `PREFER` roles: Vln I = soprano/melody (not always); Vln II = harmony or doubling of Vln I (octave or
  3rd/6th below), accompaniment figures, textures. Either can take counterpoint.
- R9 `ALLOWED` antiphonal seating (Vln I left, Vln II right) for call-and-response writing (Beethoven 7/I).
- R10 `PREFER` doublings: Vln I + flute (unison or flute 8va) for brilliance; Vln I + II in octaves for
  melodic weight; violins + oboe or clarinet at unison to colour a tune; piccolo + Vln I in high passages
  (Vivaldi piccolo concerto). Baroque flute parts often simply double violins (tema 5).
- R11 `AVOID` letting brass or full woodwinds cover a violin melody in 69–81 at f: violins need
  numbers (see [[orchestra-sizes-and-section-balance]]) or an octave doubling to balance a large brass section.

## Apply in MIDI / REAPER
- Separate tracks: `Vln I`, `Vln II`; add `Vln I div a/b` tracks instead of chords when a part splits.
- Articulation mapping ([[string-techniques]]): slurred phrase → legato patch; unslurred moderate notes →
  sustain/détaché; dotted notes at moderate tempo, p–mf → spiccato; fast 16ths → spiccato/staccato or
  short détaché; pizz, tremolo, con sordino, harmonics → matching patches.
- Dynamics: CC1 for longs, velocity for shorts (mapping in [[_instruments]]). E-string ff (76–93) can
  reach CC1 110–127; a D-string-only line (62–74) at f needs doubling to be heard over winds.
- Pan (stage default): Vln I left (≈ L60), Vln II right (antiphonal ≈ R60) or centre-left (modern).
- Very high soft sustains (88–100, pp, con sord or harmonics) give the "ethereal" film halo; keep CC1 ≤ 45.

## Checklist
- [ ] All notes within 55–100; notes 94–100 are few, short or doubled; nothing ≥ 101 on a section track.
- [ ] Most melodic time spent in 55–88.
- [ ] Chords on one track: each triple/quad stop includes 55, 62, 69 or 76 and adjacent notes ≤ 9 st apart
      (inferred); otherwise split into divisi tracks.
- [ ] Fast runs (16ths ≥ ~120 bpm) use a short/détaché patch, not legato.
- [ ] Pizz ↔ arco and con sord ↔ senza changes have a gap (see [[string-techniques]]).
- [ ] Vln II does not sit above Vln I for long stretches unless intended.

## Examples
- Typical open-string chords (sounding): G3–D4–B4–G5, G3–E4–C5–E5, A3–E4–C#5–A5, D4–A4–A5.
- Sul G cantabile: D4–G4–B4–D5 on the G string, f espressivo, CC1 90–105.
