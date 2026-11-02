---
id: orchestration.cello
title: Cello (violoncello)
aliases: [violonchelo, violonchelos, violoncelo, chelo, chelos, violoncello, Violoncello, Violoncell, Cello, violoncelle, violonchelo solo, violonchelos divisi, cuerda de La, sul A, sul D, sul G, sul C]
domain: orchestration
tags: [strings, instrument, ranges, registers, bass-line, melody, divisi, doubling]
style_scope: universal
use_when: Writing, checking or voicing a cello part (bass line, tenor melody, filler, divided cellos, solo) in MIDI.
summary: Cello sounds as written, C2–A5 (36–81) for a section (practical 36–76, solo to E6 = 88); A string (57+) gives intense, powerful melody, D string (50–57) the smooth, warm dolce colour, C/G (36–49) a full bass that covers easily. Default bass = cellos with basses an octave below; divide cellos (half melody, half bass) for rich textures. Techniques in [[cello-techniques]].
sources: ["unir-orq-tema4 p.5-7, 26-32", "apuntes-orq-sesion1 scan p.3-4", "unir-orq-tema1 p.8-11", "adler-orq-es p.9, 17-20, 75-83", "piston-orch p.80-97"]
related: ["[[cello-techniques]]", "[[double-bass]]", "[[bass-line-doubling]]", "[[string-techniques]]", "[[string-techniques-stops-and-divisi]]", "[[string-section-writing]]", "[[viola]]", "[[bassoons]]", "[[horn]]", "[[orchestra-sizes-and-section-balance]]", "[[_instruments]]"]
---

# Cello (violoncello)

## Core idea
An octave below the viola: **C2 G2 D3 A3 (36 43 50 57)**, tuned in fifths, **sounds as written** (bass
clef; tenor clef for high passages; treble only when tenor clef would need many ledger lines). Both the
**tenor and the bass** of the strings (Adler). The left hand is free, so the thumb can stop notes high up;
it can do almost anything a violin can (fingering, thumb, chords, harmonics, pizz: [[cello-techniques]]).

| Zone | MIDI | Colour |
|---|---|---|
| C and G strings | 36–49 | full, rich; C slightly ponderous at f. Adler: G string has the least volume |
| D string | 50–56 (up to ≈ 62) | smooth, unobtrusive, less nasal than A (Piston); most lyrical and warm (Adler) |
| A string | 57–69 | expressive, intense, powerful (UNIR, Piston); most brilliant and penetrating (Adler) |
| High (thumb position) | 70–81 | intense singing tenor/alto; section top A5 (81) |
| Solo only | 82–88 | solo literature (Piston D6–E6); harmonics above |

**Ranges.** Vault default: full **36–81**, practical **36–76**. Variants: Piston section top A5 (81),
whole section above it "exceptional", solo to 86–88; Adler chromatic to ≈ G5 (79), extreme ≈ E6 (88) [?].

## Rules
- R1 `MUST` keep notes ≥ 36 (open C2).
- R2 `PREFER` choose the melody string by character: **intense/powerful → A string** (57–76; Brahms 3/III,
  Charpentier); **dolce, warm, intimate → D string** (≈ 50–62; Wagner *Siegfried Idyll*, *Tristan* Prelude).
  UNIR/Piston call the A string the classic melody string, Adler the D string; both agree the A projects
  more, so a section melody in a full texture defaults to the A string.
- R3 `MUST` accompany a soft melody on the C/G strings (≈ 36–50) very lightly (pp, thin, nothing sustained in
  that register) or it is covered (Piston).
- R4 `ALLOWED` high cello (70–81) for intense section climaxes; above 81 for the solo cello only.
- R5 `PREFER` default bass: cellos and basses on the same written notes, so the **bass sounds in octaves**
  (Cb −12). `ALLOWED` cellos in unison with the sounding basses for a dark, concentrated bass (Piston).
- R6 `PREFER` when a fast cello figure is doubled by the basses, keep the full figure in the cellos and give
  the basses a **simplified copy** (beat notes, group heads, rests): see [[double-bass]] R4.
- R7 `PREFER` **divided cellos** for richness: half on a melody (usually A string), half on the bass or a held
  part (Mahler 4/III); halves may divide again (Strauss: 8 parts). A 4–5-part cello choir in close
  voicing, p, is a complete texture (Rossini *William Tell*).
- R8 `ALLOWED` half the cellos doubling the violas or 1st violins at the unison while the rest keep the bass
  (Barber *Essay No. 1*).
- R9 `MUST` mark principal-cello solos "solo" → solo patch; several solo cellos are possible (Rossini: 5).
- R10 `PREFER` doublings (Adler): Vc + Cb (octave), + bassoon, + clarinet/bass clarinet, + horn, Vc pizz +
  timpani; Vc + Va unison for a warm, dark tune (Beethoven 5/II).
- R11 `AVOID` rapid staccato/détaché figures on the C/G strings: inertia makes them scratchy (Piston).
- R12 `ALLOWED` agile animating figuration (scales, arpeggios, broken chords) is idiomatic (Dukas *La Péri*).
- R13 `AVOID` overloading one bow in slow passages (shorter bow than violin, Adler).

## Period practice
- `[era: Baroque]` cellos on the continuo with the keyboard, reading one bass part with the basses;
  separated from the bass line during the 19th c. (UNIR).
- `[era: 19th-c. editions]` treble-clef cello passages were often written **an octave above sounding**
  (except right after a tenor clef). When transcribing old parts to MIDI, check and lower −12; new parts
  write treble clef at pitch (Adler, Piston).
- `[era: until c.1950]` gut A and D strings (Piston); today steel/synthetic, brighter and more even.
- `[era: late Romantic]` audible section portamento on expressive leaps (Tchaikovsky 6); modern default is
  inaudible shifts.

## Apply in MIDI / REAPER
- Tracks: `Vc` (section), `Vc div a`/`Vc div b` for melody + bass from one section, `Vc solo`.
- Melody: A-string tune CC1 65–90; D-string dolce CC1 45–65 with the accompaniment ≥ 6 CC points lower;
  C/G-string tune: everything else pp, no pads in 36–55 (inferred).
- Bass: copy to `Cb` at −12; for a concentrated bass put Vc at the bass's sounding pitch (Vc = Cb pitch).
- Divisi halves: each half ≈ 3 dB under tutti (lower CC1 ≈ 8–10) (inferred).
- Fast notes: spiccato/staccato patch above ≈ 43; below, longer notes or higher octave (inferred).
- Pan: centre-right (≈ R25) in standard seating.

## Checklist
- [ ] All notes within 36–81; > 76 only for exposed climaxes or doubled; 82–88 solo only.
- [ ] Melody string matches the character (A = intense, D = dolce).
- [ ] Low (≤ 50) melodies have pp, thin accompaniment.
- [ ] Shared bass line: Cb at −12 (or unison), never above the cello; fast figures simplified for Cb.
- [ ] No fast staccato runs on C/G strings.
- [ ] Chords on one track follow [[cello-techniques]]; otherwise divisi tracks.

## Examples
- Intense tune on A: A3–C#4–E4–A4–C#5 (57 61 64 69 73), legato, CC1 75–95.
- Divided: `Vc div a` melody 57–72, `Vc div b` held roots 36–48, `Cb` pizz on beats an octave below.
