---
id: orchestration.cello
title: Cello (violoncello)
aliases: [violonchelo, violoncelo, chelo, violoncello, Violoncello, Cello, violoncelle]
domain: orchestration
tags: [strings, instrument, ranges, registers, bass-line]
style_scope: universal
use_when: Writing, checking or voicing a cello part (bass, tenor melody, filler, pizz) in MIDI.
summary: Cello sounds as written, C2–A5 (36–81); the A string (57–69 and up) is the expressive, powerful melody string, D (50–57) soft, G/C (36–50) full bass. Very versatile (bass, filler, melody); pizz is especially resonant within an octave above each open string.
sources: ["unir-orq-tema4 p.5-7, 26-32", "apuntes-orq-sesion1 scan p.3-4", "unir-orq-tema1 p.8-11"]
related: ["[[string-techniques]]", "[[orchestra-sizes-and-section-balance]]", "[[viola]]", "[[double-bass]]", "[[bassoons]]", "[[_instruments]]"]
---

# Cello (violoncello)

## Core idea
An octave below the viola: **C2 G2 D3 A3 (36 43 50 57)**. Bass clef, tenor clef for high passages, treble
only when very high; non-transposing. Chromatic fingering (hand spans about a 3rd), so it shifts more often
than violin/viola; from 7th position the thumb can stop notes (thumb position). Left hand is free, so it is
agile and lyrical.

| Zone | MIDI | Colour / behaviour |
|---|---|---|
| C and G strings | 36–49 | full, deep; little timbral difference between C and G; bass lines |
| D string | 50–56 | soft, discreet, less nasal than A; inner voices |
| A string | 57–69 | expressive and powerful: most cello melodies live here |
| High (thumb position) | 70–81 | intense, singing tenor/alto colour; good above the staff |
| Solo only | 82–93 | solo literature; figure shows harmonics up to ≈ A7 [?] |

Full orchestral range **36–81** (figure's top stopped note A5), practical **36–76** (general knowledge).

## Rules
- R1 `MUST` keep notes ≥ 36 (open C2).
- R2 `PREFER` expressive melodies on the A string, ≈ A3–A4 (57–69) and up to ≈ E5 (76) (Brahms 3/III).
- R3 `ALLOWED` high cello (70–81): the class notes count the high cello register as good above the staff;
  very effective doubled by violas or horns an octave below/at unison (general knowledge).
- R4 `ALLOWED` double stops: most intervals within the octave except seconds; open string + stopped note
  is safest. Rare in orchestral sections; `PREFER` divisi.
- R5 `PREFER` pizzicato within an octave above each open string (C2–C3, G2–G3, D3–D4, A3–A4 → 36–69):
  especially sonorous; pizz chords are rolled low→high unless marked otherwise.
- R6 `MUST` mark principal-cello solos "solo" → solo-cello patch.
- R7 `PREFER` roles: bass (with or without basses), harmonic filler, main or secondary melody. Baroque: continuo
  with keyboard; separated from the bass part in the 19th c.
- R8 `ALLOWED` agile figuration (arpeggios, scales) in 36–69 with détaché/spiccato; fast passages high on the
  A string are harder (frequent shifts) (general knowledge).
- R9 `PREFER` doublings: Vc + Cb at the octave (default bass); Vc + bassoon on bass or tenor lines; Vc + Va
  (unison or octave) for a warm melody; Vc + horn for a noble mid melody (general knowledge).
- R10 `AVOID` cello melodies in 36–49 under dense mid-range scoring: low register muddies and is covered;
  move the tune to the A string or thin the accompaniment (general knowledge).

## Apply in MIDI / REAPER
- Track `Vc`; `Vc div a/b` for dyads or a split bass/melody.
- Articulations: legato (slurs), sustain, spiccato, pizz, tremolo, con sordino ([[string-techniques]]).
- Pizz chords: offset chord notes 10–25 ms bottom→top (strum) unless "non arpeggiato" (inferred).
- Bass doubling: copy the Vc bass line −12 to the double-bass track (see [[double-bass]]).
- Dynamics: A-string melodies carry well at mf (CC1 65–80); a low C/G-string melody needs CC1 +10 or a
  thinner texture.
- Pan: centre-right (≈ R25) in standard seating.

## Checklist
- [ ] All notes within 36–81; > 76 only for exposed solo moments or doubled.
- [ ] Pizz notes mostly within 36–69.
- [ ] No 3+ note chords on a section track (dyads with open string 36/43/50/57 at most).
- [ ] When cello and bass share a line, bass is at −12 (or unison) and never above the cello.
- [ ] Fast runs use short/détaché patches, not legato.

## Examples
- Tenor melody: A3–C#4–E4–A4 (57–61–64–69) on the A string, legato, CC1 70–90.
- Pizz bass: C2 (36) / G2 (43) alternating, velocity 70–90, with Cb pizz an octave below.
