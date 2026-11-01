---
id: orchestration.viola
title: Viola
aliases: [viola, violas, Bratsche, alto, viola da braccio]
domain: orchestration
tags: [strings, instrument, ranges, registers, divisi]
style_scope: universal
use_when: Writing, checking or voicing a viola part (inner voice, filler, or melody) in MIDI.
summary: Viola sounds as written (alto clef), C3–A5 (48–81) orchestrally, rarely higher; dark, warm, less powerful than the violin. Its C string (48–55) is unique and ominous, its A string (69–81) nasal and penetrating. Classic role is the alto voice and accompaniment; write double notes as divisi.
sources: ["unir-orq-tema4 p.5-7, 21-26", "apuntes-orq-sesion1 scan p.5-6", "unir-orq-tema1 p.8-11"]
related: ["[[string-techniques]]", "[[orchestra-sizes-and-section-balance]]", "[[violin]]", "[[cello]]", "[[_instruments]]"]
---

# Viola

## Core idea
Tuned a P5 below the violin: **C3 G3 D4 A4 (48 55 62 69)**. Acoustically too small for its pitch, so it is
less powerful and more "monochrome": dark, warm, soft, a little melancholy. Alto clef (treble when high),
non-transposing. Fingering like the violin; large violas are harder in high positions.

| Zone | MIDI | Colour / behaviour |
|---|---|---|
| C string | 48–55 | the only notes below the violin; dark, "full of omens and threats" |
| G string | 55–62 | richer and warmer than the violin G, but secondary in weight |
| D string | 62–69 | discreet, gentle; more powerful than the violin D; accompaniment or melody |
| A string | 69–81 | contrasting: nasal, penetrating, a bit unstable as it rises |
| Extension | 82–88 | rare; strained and nasal, violins already own this register |
| Solo only | 89–98 | figure shows stopped notes to ≈ D7, harmonics to ≈ G7 [approx.] |

Full orchestral range **48–88**, practical **48–81**.

## Rules
- R1 `MUST` keep notes ≥ 48 (open C3).
- R2 `AVOID` notes above A5 (81) in orchestral writing (apuntes R8): size makes high positions hard, the
  A string goes nasal, and the violins cover the register better.
- R3 `ALLOWED` C-string (48–55) lines for dark, ominous colour.
- R4 `PREFER` double notes in accompaniment written as **divisi** (two lines), not as double stops: cleaner
  and more concise; mark "div." and return with "unis." (19th c. onward).
- R5 `AVOID` triple/quadruple stops orchestrally; double stops only occasionally and with an open string.
- R6 `ALLOWED` divisi to lighten the viola's heavier sound.
- R7 `PREFER` roles: alto voice of the string choir, harmonic accompaniment (repeated 8ths, arpeggios,
  tremolo filler), counterpoint, and since the early 19th c. melodies as a darker alternative to the
  violin (Mendelssohn *Scottish*/I).
- R8 `ALLOWED` agility close to the violin's in the low and middle register; slightly slower response
  (general knowledge). Use détaché/spiccato for fast figures.
- R9 `PREFER` doublings: violas + cellos in unison or octaves for a warm tenor melody (general knowledge);
  viola + clarinet or bassoon on inner lines; viola + Vln II for accompaniment patterns; viola + horn on
  mid-register sustained harmony (general knowledge).
- R10 `AVOID` exposing a solo viola section melody against heavy brass: it is the least powerful string
  group per player; double it or thin the accompaniment.

## Apply in MIDI / REAPER
- Track `Va`; for dyads add `Va div a` / `Va div b` tracks (e.g. repeated 8th-note thirds in Mozart-style
  accompaniment = two monophonic tracks).
- Articulations as for violin ([[string-techniques]]): legato for slurs, sustain/détaché, spiccato, pizz,
  tremolo, con sordino.
- Dynamics: a viola line needs ≈ +1 dynamic step (CC1 +10–15) to match a violin line at the same marking
  when exposed (inferred from its lower power).
- Pan: centre-left (≈ L20) in the standard seating (Vln I | Va | Vc | Vln II).
- SATB string voicing: Vln I = S, Vln II = S2/A, Va = A or T, Vc/Cb = T/B.

## Checklist
- [ ] All notes within 48–88; notes 82–88 rare, short or doubled.
- [ ] Most notes in 48–81.
- [ ] No chords of 3+ notes on a viola track; dyads only on divisi tracks or with an open string (48/55/62/69).
- [ ] A viola melody against brass/tutti is doubled (Vc, Cl, Hn or Vln II).
- [ ] Viola part not constantly above Vln II (voice crossing only when intended).

## Examples
- Ominous pedal: Va div. on C3 (48) + G3 (55), tremolo pp, CC1 25–35.
- Filler: Va div. a/b repeating E4/G4 (64/67) 8ths under a Vln I melody (Mozart 40/I style).
