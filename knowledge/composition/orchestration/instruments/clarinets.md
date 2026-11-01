---
id: orchestration.clarinets
title: Clarinets (Bb, A, Eb, bass)
aliases: [clarinete, clarinetes, clarinete en si bemol, clarinete en la, requinto, clarinete bajo, Klarinette, Bassklarinette, clarinetto, clarinette, chalumeau, clarín, sonidos de garganta]
domain: orchestration
tags: [woodwinds, instrument, ranges, registers, transposition, single-reed]
style_scope: universal
use_when: Writing, checking or doubling a clarinet or bass clarinet part, or choosing a woodwind for soft entries and low dark melodies.
summary: Bb clarinet sounds D3–F6 (50–89): dark chalumeau 50–64, pale throat tones 65–68, bright clarino 69–82, shrill top 83–89. Most versatile woodwind, best at pp and niente entries. A clarinet sounds a m3 lower, Eb (requinto) a m3 higher and shrill, bass clarinet a 9th lower (34–77) and soft in its low register.
sources: ["unir-orq-tema5 p.18-23", "unir-orq-tema1 p.11-15"]
related: ["[[flute-piccolo]]", "[[oboe-english-horn]]", "[[bassoons]]", "[[transposing-instruments]]", "[[_instruments]]"]
---

# Clarinets (Bb, A, Eb, bass)

## Core idea
Cylindrical tube, **single reed**. Even, controllable tone in every register, the widest attack palette of
the reeds (from explosive sfz to fading in from silence). Late arrival (Mannheim); standard "a 2" from the
early 19th c. All clarinets transpose; MIDI stays at concert pitch.

| Instrument | Written → sounding | Full (sounding) | Practical |
|---|---|---|---|
| Bb clarinet | −2 | 50–89 (written E3–G6) | 50–84 |
| A clarinet | −3 | 49–88 | 49–83 |
| Eb clarinet (requinto) | **+3** | 55–94 (general knowledge) | 55–91 |
| Bass clarinet (Bb, treble/French notation) | −14 (bass-clef/German notation: −2) | 34–82 (34 only on low-C models; 37/38 on others; 78–82 extreme) | 38–72 |

Bb clarinet registers (sounding): **50–64 chalumeau** (dark, deep, rich, dramatic; unlike anything else) ·
**65–68 throat tones** (pale, dull) · **69–82 clarino** (bright, incisive, warm, expressive) · **83–89 top**
(piercing, shrill). A clarinet: same zones −1; Eb clarinet: +5 (inferred from transposition).

## Rules
- R1 `AVOID` exposed melodies that sit on the throat tones (Bb: 65–68); pass through them freely.
- R2 `PREFER` the clarinet for soft entries, pp chords and niente swells: it can start from silence.
- R3 `ALLOWED` low dark melodies in the chalumeau (Tchaikovsky 5 opening: two clarinets low).
- R4 `ALLOWED` clarino melody over chalumeau accompaniment inside the clarinet section (Mozart 39, Trio).
- R5 `ALLOWED` fast scales, arpeggios and wide leaps across registers: nearly as agile as the flute
  (Borodin *Prince Igor* overture accompaniment figures).
- R6 `ALLOWED` all major and minor trills. Tremolo widths: up to M6 (9 st) in chalumeau, P4 (5) in clarino,
  M3 (4) above the staff.
- R7 `PREFER` the clarinet as the most versatile woodwind: melody or accompaniment in any register; blends
  with flutes, bassoons, horns and strings.
- R8 `ALLOWED` Eb clarinet for shrill, grotesque or piercing high colour (general knowledge).
- R9 `PREFER` bass clarinet on bass lines with bassoon or double bass; it plays soft and pp low notes
  that the bassoon cannot.
- R10 `PREFER` doublings: clarinet + flute (octave/unison) for a round melody; clarinet + oboe unison
  (rounds the oboe); clarinet + violas/cellos for warm inner lines; bass clarinet + cellos/basses.
- R11 `ALLOWED` breathing (general knowledge): moderate air use; rests every ≈ 4–8 bars.

## Apply in MIDI / REAPER
- Tracks `Cl 1`, `Cl 2` (Bb or A), `Eb Cl`, `B.Cl` at concert pitch. Converting parts to/from written:
  see [[transposing-instruments]] (Bb +2, A +3, Eb −3, bass cl +14 when writing).
- Articulations: legato, sustain, staccato, sfz/marcato, trills, sometimes "swell"/niente patches.
- Niente: start CC1 at 0–10 and ramp; the clarinet is the right instrument for it.
- Pan: centre-left, second woodwind row.

## Checklist
- [ ] Bb clarinet notes 50–89; mostly 50–84. A clarinet 49–88. Eb clarinet 55–94. Bass clarinet 34–82 (34–37 only with a low-C patch).
- [ ] No exposed sustained melody notes on 65–68 (Bb) / 64–67 (A).
- [ ] Notes ≥ 83 (Bb) used for climaxes or doubling, not soft sustained lines.
- [ ] Bass-clarinet pp low entries are fine; bassoon pp low entries are moved to bass clarinet.
- [ ] Breath gaps exist in long lines.

## Examples
- Chalumeau melody: E3–G3–B3–E4 (52 55 59 64), p, CC1 40–55.
- Niente entry on a sustained C5 (72) with a 2-bar CC1 ramp 0→70.
