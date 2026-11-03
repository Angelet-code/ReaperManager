---
id: orchestration.trombone
title: Trombone (tenor, bass, alto)
aliases: [trombón, trombones, trombón tenor, trombón bajo, trombón alto, Posaune, Bassposaune, Altposaune, trombone basso, trombone contralto, vara, posiciones, transpositor en fa, gatillo]
domain: orchestration
tags: [brass, instrument, ranges, registers, bass-line, section-layout]
style_scope: universal
use_when: Writing, checking or voicing tenor, bass or alto trombone parts (chorales, harmony beds, bass lines, unison themes, climaxes).
summary: Non-transposing. Tenor E2–Bb4 (40–70) practical, C5–F5 (72–77) risky, pedals Bb1–Ab1 (34–32) only prepared; bass trombone (F/E attachments) Bb1–Bb4 (34–70) with pedals down to C1 (24); very strong across A2–F4 (45–65). Default section 2 tenors + bass, in three-part harmony or unison; pp chords are velvety, ff unison dominates everything.
sources: ["unir-orq-tema6 p.19-24", "unir-orq-tema1 p.8-11", "adler-orq-es p.296-307", "adler-orq-es p.340-349", "adler-orq-en2 p.311-319", "piston-orch p.206-222", "piston-orch p.267-281"]
related: ["[[trombone-slide-techniques]]", "[[trombone-period-practice]]", "[[tuba]]", "[[horn]]", "[[trumpet]]", "[[brass-basics]]", "[[brass-section-writing]]", "[[orchestra-sizes-and-section-balance]]", "[[_instruments]]"]
---

# Trombone (tenor, bass, alto)

## Core idea
A slide brass: seven positions, each a semitone lower (I = Bb … VII = E). All trombones are
**non-transposing**; bass clef, tenor clef above ≈ G4, alto clef for the alto. Homogeneous tone that gains
brilliance upward. Standard section: **2 tenors + 1 bass** (a score's "3 trombones" = third is bass).
Slide technique, pedals, F attachment and glissando: [[trombone-slide-techniques]]. Alto, French/Russian
habits, contrabass and valve trombones: [[trombone-period-practice]].

| Instrument | Full (vault default) | Practical | Author variants |
|---|---|---|---|
| Tenor (Bb, often with F trigger) | 34–77 | 40–70 | Adler-en2: 40–70 + 72–77 "difficult and risky"; pedals 34–32 good, 31–28 hard. Piston: chromatic 40–74; 77 not orchestral. UNIR: 40–70, ext. to 77 |
| Bass (Bb/F, usually + E or D) | 24–70 | 31–65 | Adler-en2: 34–70; B1 (35) needs the E slide/trigger; pedals to E1 (28), to C1 (24) with the F trigger. Piston: chromatic to 35 + pedal 34 |
| Alto (Eb) | 45–77 | 52–75 (inferred) | Adler-en2: 45–75, F5 (77) extreme; ≤ ≈ 51 weak and poor [?] |

Tenor registers (UNIR = Adler-en2 chart): **40–44** dark, rather nondescript (E2 the poorest note,
Piston) · **45–66** very strong (horn-like in the middle, harder) · **67–70** very intense ·
**71–77** strained extension.
Bass trombone registers (Adler-en2 chart): **24–33** pedal/trigger zone · **34–42** heavy, quite strong ·
**43–56** deep and solid · **57–70** very powerful.

## Rules
- R1 `PREFER` trombones as a group: three-part harmony (open or close position) as a background, like
  horns (Piston); Adler adds solos and counterpoint as normal uses.
- R2 `PREFER` with tuba: four-part writing with tuba as bass, or three-part trombones with the bass
  doubled by tuba at the unison/octave; all three may join the tuba on the bass (Piston).
- R3 `PREFER` in big tutti give the harmony to the trombones (horns are too light) and free the horns for
  melody, or combine both (Piston).
- R4 `PREFER` trombone melodies = dignity/chorale: 2–3 in unison, or octaves with two on top (Piston;
  Hindemith *Mathis*, Berlioz *Rákóczy*). A single solo trombone is a special, intimate colour (Mahler 3).
- R5 `ALLOWED` low-register pp chords: velvety, very effective for three trombones (Schubert, Debussy
  *La Mer*); pp unison in the middle = full round tone without loudness.
- R6 `AVOID` ff unison of three trombones unless they must dominate: it covers the orchestra, more so
  higher up (Rimsky *Scheherazade*).
- R7 `ALLOWED` low ff: crashing, huge crescendo power. `AVOID` by default the uncontrolled rattling
  *cuivré* that results (Piston).
- R8 `AVOID` the high register (≥ ≈ 65) softer than mf: it sounds tense, not soft (Piston).
- R9 `MUST` breathing: trombones need more air than trumpet or horn; frequent breaths, rests every 2–4
  bars in loud low writing (Adler, Piston).
- R10 `AVOID` fast passages that alternate distant positions (VII↔I, e.g. E2/B2 against Bb2): see
  [[trombone-slide-techniques]].
- R11 `PREFER` doublings: bass trombone + tuba (unison/octave); trombones + horns (chorale); trombone +
  cellos/bassoons (firm bass/tenor line); muted trombones + low strings col legno (dry menace, Berg).
- R12 `MUST` score layout: two tenors on one staff, bass trombone on its own staff, never on the tuba's
  staff (Adler).
- R13 `NEVER` treat the bass trombone as transposing in MIDI (tema 1's "octave lower" is doubtful).

## Apply in MIDI / REAPER
- Tracks `TBN 1`, `TBN 2`, `BTBN` at concert pitch, in the BRASS folder between trumpets and tuba.
- Chord layout: TBN 1/2/BTBN on the three upper voices of the low-brass chord, tuba on the root an octave
  below BTBN (or unison). Adjacent tenor voices 3–7 st apart; below ≈ 48 prefer 5ths/octaves.
- Dynamics: low pp chords CC1 20–40; climaxes CC1 100–127 on 45–62; notes ≥ 65 CC1 ≥ 70.
- Lengths: low notes (≤ 45) a quarter or longer at fast tempi; fast tonguing there sounds heavy.
- Breath gap ≥ 1/8 beat every 2–4 bars of sustained playing.
- Muted = a muted patch, not lower CC1. Pan centre/right, rear.

## Checklist
- [ ] Tenor notes 40–70 (72–77 or 32–34 only as rare, prepared exceptions); bass 34–70 (pedals ≤ 33 long only).
- [ ] No fast VII↔I alternation (E2/B2 against Bb2/A2).
- [ ] Three-trombone ff unisons only where brass should dominate.
- [ ] No soft notes ≥ 65; breath gaps every few bars.
- [ ] Tuba at or below the bass trombone at each moment.

## Examples
- Soft chord (Schubert-like): BTBN E2 (40), TBN 2 B2 (47), TBN 1 G#3 (56), pp.
- Climax unison: A2–D3–F3 (45 50 53) ff, tuba an octave below.
- Brahms 1/IV chorale model: p dolce, close position, bass trombone on the root.
