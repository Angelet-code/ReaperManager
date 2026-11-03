---
id: orchestration.texture-part-writing-chorale
title: Part writing and chorale textures
aliases: [escritura en partes, escritura a partes, partes reales, voces reales, coral, textura coral, coral de metales, coral de maderas, cuatro voces, SATB orquestal, reduplicación, engrosamiento armónico, Realstimmen, Choralsatz]
domain: orchestration
tags: [texture, part-writing, chorale, real-parts, doubling, blend, brass-chorale]
style_scope: universal (tonal harmonic writing; period variants tagged)
use_when: Scoring 3–5 voice harmonic writing (a chorale, a hymn-like passage, a brass or woodwind choir, a cadence) for orchestra.
summary: "Part writing is a few real parts (usually 3–4) of about equal standing; every other staff is a unison or octave doubling of one of them. Write the real parts with clean voice leading first, then give each a mixed-timbre group or a pure-colour choir; unison doublings add weight, octave doublings add colour but little weight. Keep the upper voices close and the bass gap wide, and let parts change number and instruments at cadences."
sources: ["unir-orq-tema3 p.12", "unir-orq-tema6 p.19-24", "unir-orq-tema5 p.12-17", "unir-orq-tema4 p.21-26", "piston-orch p.382-387", "adler-orq-es p.252-260", "adler-orq-es p.382-391"]
related: ["[[texture-part-writing-chorale-doubling]]", "[[texture-types]]", "[[texture-accompanied-melody]]", "[[chord-voicing-family-stacking]]", "[[woodwind-section-writing-chords]]", "[[brass-section-writing]]", "[[string-section-writing]]", "[[doubling-colour-and-decay]]", "[[voice-leading-parallels]]", "[[natural-horn-period-practice]]"]
---

# Part writing and chorale textures

## Core idea
Piston's Type IV: a few voices of about equal standing, the melody only one of them (unlike
[[texture-accompanied-melody]]). **Count real parts, not staves**: Franck spreads 4 real parts over 13 winds;
Holst's 7 staves of parallel triads are 2 thickened lines. A voice is one instrument (pure-colour choir) or
a mixed-timbre group. Doubling without spoiling the voice leading: [[texture-part-writing-chorale-doubling]].

## Rules
- R1 `MUST` Write the real parts (S, A, T, B; sometimes 3 or 5) with correct voice leading before assigning
  instruments. A unison/octave doubling is not a voice, so it never makes "parallel octaves" with its part
  (Piston). Check the real parts with [[voice-leading-parallels]].
- R2 `PREFER` 3–4 real parts. Two can sound full if each is doubled in octaves (Mozart K.200 minuet:
  A = Vln I + 2 Ob with Vln II 8vb; B = Va + Vc with Cb 8vb).
- R3 `MUST` Balance by **unison** doublings (players on the same pitch); octave doublings add colour and
  range but little tone-weight (Piston). A heavily doubled tune over a lone bass can sound organ-like.
- R4 `PREFER` Blended wind chorale: a mixed group per voice (Franck, Symphony in D minor/II, Piston's table):
  - S = Fl 1; Ob 1 + Cl 1 an octave lower; Bsn 1 + Hn 1 another octave lower;
  - A = Fl 2; E.H. + Cl 2 an octave lower;
  - T = Bsn 2 + Hn 2;  B = bass clarinet alone.
- R5 `PREFER` Pure-colour chorale, one family:
  - brass: 2 Tpt / 2 Hn on S and A, trombones on T, bass trombone or tuba on B (trombones about 45–65);
  - strings: Vln I = S, Vln II = A, Va = T, Vc (+ Cb 8vb) = B;
  - woodwind "organ" hymn: Ob doubled by Fl (softens the nasal edge), legato *mf dolce*, all parts
    breathing together (W. Schuman, *Chester*; Adler).
- R6 `PREFER` Close spacing between S, A and T (adjacent voices within an octave), the widest gap T–B.
- R7 `AVOID` The oboe as an inner voice of a soft woodwind chorale (it sticks out); violas, horns and
  clarinets blend best inside.
- R8 `AVOID` Trombones in unison on one voice of a *soft* chorale; one per voice. (At *f*, three trombones in
  unison on a melody are normal: Piston.)
- R9 `ALLOWED` Change the number of real parts within a phrase (3 → 4, 5 at the cadence) and move
  instruments between parts mid-phrase, so those that taper best carry the diminuendo (Franck).
- R10 `PREFER` Vary a line's distribution bar by bar for expression: Vln I + ½ Va + Bsn → three octaves
  (Fl / Vln I + Cl / Bsn) → Vln I alone (Beethoven 5/II). Cadences inside thin textures: 4 real parts.
- R11 `PREFER` On a repeat, swap the doubling family and keep the core: brass chorale doubled by strings,
  then by woodwinds (*Lohengrin*).
- R12 `PREFER` Save a family's colour: no cellos/basses in a woodwind chorale that strings follow. From winds
  to strings, let solo strings double wind lines first (solo Va with Ob, solo Vc with Bsn; Schumann 2/IV).
- R13 `PREFER` Orchestrated diminuendo: withdraw doublings one at a time (Trb 1–2 out, Trb 3 stays on the
  bass), then lower the dynamic (Schubert, *Rosamunde*).

## Period practice
- `[era: Classical natural brass]` Horns and trumpets play only the real-part notes they have, plus open
  tonic–dominant fifths ([[natural-horn-period-practice]]).
- `[era: Beethoven]` Ob 1 plays the second voice under Fl 1 instead of Fl 2.
- `[era: Classical–Romantic]` Held harmony and pedals in woodwinds (+ horns), melody and repeated-note
  accompaniment in strings (Adler).
- `[era: Beethoven 5/II]` Violas play a double appoggiatura against bassoons already on its resolution.
  Default: **avoid**; [[user-taste]] R21 hears such clashes as wrong notes.

## Apply in MIDI / REAPER
- Split the chorale into `S`, `A`, `T`, `B` lists; one track per instrument, named by part (`S OB 1`).
- **Brass chorale, p–mf, in C:**

| Voice | Track | Range (MIDI) | Patch | CC1 |
|---|---|---|---|---|
| S | TPT 1 (con sordino for p) or HN 1 | 60–76 | long | 45–65 |
| A | HN 2-3 | 57–69 | long | 45–65 |
| T | TBN 1-2 | 48–62 | long | 45–60 |
| B | BASS TBN / TUBA | 33–50 | long | 50–65 |

- **Franck model:** S to `FL 1`, `OB 1` + `CL 1` (−12), `BSN 1` + `HN 1` (−24); A to `FL 2`, `E.H.` +
  `CL 2` (−12); T to `BSN 2` + `HN 2`; B to `BASS CL`. Doublers CC1 5–10 below the part's lead track;
  `BASS CL` higher so the lone bass holds.
- **Weight check:** per chord, count tracks on each exact pitch; the melody pitch has the most unisons.
- **Library ensembles:** even with a polyphonic patch, one track per voice so CC1 is shaped per voice.
- **Breathing** ([[user-taste]] R16–R17): wind phrases end together, last note shortened about 1/8 beat.
- **Swell:** CC1 +10 to mid-phrase and back at the cadence; final chord CC11 −15 over its length.

## Checklist
- Are the real parts voice-led, with doublings excluded from the parallel check?
- Is weight set by unison counts, and do S–A and A–T stay within an octave?
- Is no oboe on an inner voice of a soft chorale?
- Does every wind phrase end with a shared breath gap? On a repeat, did the doubling family change?

## Examples
- Hymn in C, p: S E4–D4–C4 on `TPT 1 sord.` (64–62–60), A C4–B3–A3 `HN`, T G3–G3–E3 `TBN 1`, B C3–G2–A2
  `TUBA` (48–43–45).
