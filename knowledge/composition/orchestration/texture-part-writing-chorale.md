---
id: orchestration.texture-part-writing-chorale
title: Part writing and chorale textures
aliases: [escritura en partes, coral, textura coral, coral de metales, coral de maderas, cuatro voces, SATB orquestal]
domain: orchestration
tags: [texture, part-writing, chorale, blend, brass-chorale]
style_scope: universal (tonal harmonic writing)
use_when: Scoring 3–4 voice harmonic writing (a chorale, a hymn-like passage, a brass or woodwind choir) for orchestra.
summary: Part writing is harmonic writing in 3–4 voices that move mostly together. Give each voice a mixed-timbre group rather than one instrument per voice; the bass voice can be a single dark instrument. Keep the spacing close in the upper voices and open at the bottom, and keep each group within its family's blending register.
sources: ["unir-orq-tema3 p.12", "unir-orq-tema6 p.19-24", "unir-orq-tema5 p.12-17", "unir-orq-tema4 p.21-26"]
related: ["[[texture-types]]", "[[chord-voicing-family-stacking]]", "[[doubling-colour-and-decay]]", "[[orchestra-sizes-and-section-balance]]"]
---

# Part writing and chorale textures

## Core idea
Essentially four-part (or three-part) harmonic writing, often chorale-like. In orchestration each
voice can be one instrument (a pure-colour choir: brass chorale, string chorale) or a **mixed-timbre
group** (Franck: every voice doubled by several woodwind and brass colours, with the bass alone).

## Rules
- R1 `PREFER` For a blended wind chorale, give each voice a mixed group:
  S = fl1 + ob1 + cl1 (+ horn 1); A = fl2 + E.H. + cl2; T = bsn + horns; B = bass clarinet
  (Franck, Symphony in D minor/II).
- R2 `PREFER` For a pure-colour chorale, keep one family:
  - Brass chorale: 2 tpt / 2 hn on S and A, trombones on T, bass trombone or tuba on B. Trombones sit
    about A2–F4 (45–65).
  - String chorale: Vln I = S, Vln II = A, Va = T, Vc (+ Cb an octave lower) = B.
- R3 `MUST` Respect common-practice voice-leading in a chorale (no parallel fifths or octaves between
  real voices; doublings at the octave are not voices). See the harmony notes.
- R4 `PREFER` Close spacing between S, A and T (adjacent voices within an octave), and a wider gap to
  the bass.
- R5 `AVOID` The oboe as an inner voice in a soft woodwind chorale: it sticks out. Use it on top, or in a
  full tutti only.
- R6 `PREFER` Violas, horns and clarinets for inner voices: they blend.
- R7 `AVOID` Trombones in unison on one voice of a soft chorale. Give one trombone per voice.

## Apply in MIDI / REAPER
- Start from a 4-voice MIDI chorale (one track per voice, or one track to split). Split it by voice into
  `S`, `A`, `T`, `B` lists before orchestrating.
- **Brass chorale, p–mf, in C:**

| Voice | Track | Range (MIDI) | Patch | CC1 |
|---|---|---|---|---|
| S | TPT 1 (con sordino for p) or HN 1 | 60–76 | long | 45–65 |
| A | HN 2-3 | 57–69 | long | 45–65 |
| T | TBN 1-2 | 48–62 | long | 45–60 |
| B | BASS TBN / TUBA | 33–50 | long | 50–65 |

- **Woodwind chorale (Franck model):** create tracks `FL 1`, `FL 2`, `OB 1`, `E.H.`, `CL 1`, `CL 2`,
  `BSN 1`, `BSN 2`, `HN`, `BASS CL`. Copy S to FL 1 + OB 1 + CL 1, A to FL 2 + E.H. + CL 2, T to
  BSN 1 + HN, and B to BASS CL. Each doubler track gets CC1 5–10 lower than its voice's leading
  instrument, so one colour leads.
- **Library sections:** an ensemble patch (e.g. Albion-type Brass Mid, Woods) can take two voices if it
  is polyphonic. Use one track per voice anyway, so CC1 can be shaped per voice.
- **Breathing:** wind chorales need a breath gap. Shorten the last note of each phrase by 1/8 beat in
  winds; strings can sustain through.
- **Swell per phrase:** CC1 rises +10 to the middle of each phrase and returns at the cadence.
  The cadence chord is held with CC11 tapering by −15 over its length.

## Checklist
- Does each of S, A, T, B have its own track(s)?
- Are there no parallel fifths or octaves between real voices?
- Are S–A and A–T within an octave, with only T–B allowed to be wider?
- Does no oboe sit on an inner voice of a soft chorale?
- Does every wind phrase end with a breath gap?

## Examples
- Hymn in C, p: S E4–D4–C4 on `TPT 1 sord.` (64–62–60), A C4–B3–A3 on `HN`, T G3–G3–E3 on `TBN 1`, B C3–G2–A2 on
  `TUBA` (48–43–45).
