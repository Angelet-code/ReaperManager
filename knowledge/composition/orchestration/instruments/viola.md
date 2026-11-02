---
id: orchestration.viola
title: Viola
aliases: [viola, violas, viola solista, viola sola, violas divididas, violas como bajo, relleno armónico, pasajes de relleno, cuerda do, Bratsche, alto, viola da braccio]
domain: orchestration
tags: [strings, instrument, ranges, registers, roles, doubling, divisi, solo]
style_scope: universal
use_when: Writing, checking or voicing a viola part (inner voice, filler, light bass, doubling or melody) in MIDI.
summary: Viola sounds as written (alto clef), C3 up to E6 (48–88), practical 48–81 and most comfortable ≤ G5 (79). Too small for its pitch, it sounds dark and veiled. The C string (48–55) is menacing or delicate, G/D (55–69) are the gentle accompaniment strings, and the A string (69+) is nasal and penetrating. It is the busiest inner voice: filler, doubling of violins or cellos, a light bass, singing melody. Write double notes as divisi. Technique limits: [[viola-technique-limits]].
sources: ["unir-orq-tema4 p.5-7, 21-26", "apuntes-orq-sesion1 scan p.5-6", "unir-orq-tema1 p.8-11", "adler-orq-es p.65-72", "piston-orch p.65-79"]
related: ["[[viola-technique-limits]]", "[[viola-damore]]", "[[string-techniques]]", "[[string-techniques-stops-and-divisi]]", "[[string-section-writing]]", "[[orchestra-sizes-and-section-balance]]", "[[violin]]", "[[cello]]", "[[_instruments]]"]
---

# Viola

## Core idea
Tuned a P5 below the violin: **C3 G3 D4 A4 (48 55 62 69)**. Its body is too small for a true fifth
below; that mismatch makes its dark, veiled, less powerful tone. Sizes vary. The bow is heavier and the
thick strings speak reluctantly, so the tone needs a firm stroke. Alto clef (treble when high),
non-transposing.

| Zone | MIDI | Colour |
|---|---|---|
| C string | 48–55 | the viola's signature: sombre, menacing in loud détaché; also delicate at pp |
| G string | 55–62 | subdued, but richer and warmer than the violin G |
| D string | 62–69 | gentle, unobtrusive, weightier than violin D; accompaniment and gentle melody |
| A string | 69–81 | nasal, penetrating, stands out; blends with woodwinds; the usual solo string |
| Extension | 82–88 | rare, strained; violins cover it |
| Solo only | 89–98 | stopped notes to ≈ D7, harmonics higher (approx.) |

**Range default:** full 48–88, practical 48–81. Variants: Piston puts the orchestral ceiling at E6 (88),
reached as a harmonic. He calls positions above the 3rd awkward (top ≈ G5, 79) and says notes above
≈ 81 are nearly always doubled by violins. Adler's chart reaches about G6–A6 (91–93) [?, unreadable].

## Rules
- R1 `MUST` notes ≥ 48. `ALLOWED` B2 (47) only as a marked scordatura effect (Strauss *Don Quixote*).
- R2 `AVOID` orchestral notes above 81, and fast or long passages above G5 (79).
- R3 `PREFER` singing melody over agile figuration; airy spiccato is less natural than on violin (Piston).
  Give feather-light fast figures to violins.
- R4 `PREFER` roles: alto voice and harmonic filler (repeated notes, arpeggios, tremolo, triplet chord
  pulses: *Lohengrin* III), counterpoint, and melody. From the early 19th c., melodies as a darker
  alternative to the violin (Mendelssohn *Scottish*).
- R5 `ALLOWED` violas as a light bass in 48–59, arco or pizz, with cellos/basses tacet or reduced (Mendelssohn
  *Midsummer Night's Dream*, Mahler 7).
- R6 `PREFER` double notes as **divisi**: cleaner and more in tune (Adler, Piston). `MUST` divide when both
  notes are below 55 (both on the C string). `MUST` mark *div.* / *non div.*
- R7 `ALLOWED` divided violas alone carrying the accompaniment (Mozart 40/I), or doubling an oboe pair in
  thirds (Mozart K.200).
- R8 `ALLOWED` 3–4-note tremolo chords for a vibrant tutti (Beethoven Violin Concerto); `AVOID` viola
  double notes when the texture must stay light and fleet (*Magic Flute* overture).
- R9 `PREFER` doublings:
  - Va + Vc in unison, p dolce, for a warm dark tune (Beethoven 5/II);
  - Va 8vb under Vln I for a ff tune (Berlioz *Fantastique*);
  - Va + oboe at the octave or unison (Brahms 3), viola pizz + oboe unison for crisp staccato;
  - A string + soft trumpets/trombones (Adler);
  - Va + clarinet/bassoon or horn on inner lines (general knowledge).
- R10 `AVOID` an exposed viola melody against heavy brass. A solo viola is easily covered: keep the
  accompaniment very light (Piston). A solo can also be a lively staccato dance (Enescu *Romanian
  Rhapsody* 2).
- R11 `ALLOWED` a viola choir: six solo violas in close parallel harmony, p–mf cantabile (*Rite*), or
  12-part muted divisi of tremolos and trills (*Don Quixote*).
- R12 `PREFER` sul ponticello tremolo on violas: it suits their tone. `AVOID` it combined with a mute.

## Period practice
- `[era: 18th c., Adler]` rarely independent: violas doubled the bass an octave up or filled harmony.
  Pastiche: do the same (inferred).
- `[era: Haydn–Beethoven, Piston]` at most 5 violas against 6–10 per violin section. Divided violas
  were thought to balance both violin sections. Parts full of unmarked double notes, playable as stops.
- `[era: Berlioz onward]` an independent voice. `[era: c. 1760–1880, Adler]` solo viola rare; near
  equality in the 20th c. (Bartók, Walton, Hindemith concertos).

## Apply in MIDI / REAPER
- Tracks `Va`, `Va div a/b` for any dyad; `Va solo` separate.
- Colour by register: menace 48–55 at f (détaché, CC1 85–110); soft filler 55–69 at p–mf; cutting solo or
  wind doubling 69–79.
- Short articulation: weightier staccato/détaché patches rather than the lightest spiccato (inferred).
- Level: an exposed viola line needs ≈ +1 dynamic step (CC1 +10–15) to match a violin line (inferred);
  lower the bed first ([[user-taste]] R15).
- Pan from [[stage-seating-pan-depth]]: modern R15, antiphonal L20; leave hall-recorded libraries near centre.
- SATB strings: Vln I = S, Vln II = A, Va = A/T, Vc/Cb = T/B.

## Checklist
- [ ] Notes 48–88, mostly 48–79; anything above 81 rare or doubled by violins.
- [ ] No two simultaneous notes both below 55 on one track; dyads on divisi tracks.
- [ ] A viola melody against brass/tutti is doubled (Vc, Cl, Hn or Vln II) or the bed thinned.
- [ ] Not above Vln II for long unless intended; Classical pastiche keeps violas modest.

## Examples
- Ominous pedal: Va div. C3 (48) + G3 (55), tremolo pp, CC1 25–35.
- Filler: Va div. a/b repeating E4/G4 (64/67) 8ths under a Vln I melody (Mozart 40/I model).
- Warm duet: Va + Vc unison A♭3–C4–E♭4 (56 60 63), p dolce (Beethoven 5/II model).
