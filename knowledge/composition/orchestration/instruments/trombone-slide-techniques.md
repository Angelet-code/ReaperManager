---
id: orchestration.trombone-slide-techniques
title: Trombone slide technique (positions, pedals, F attachment, glissando, mutes)
aliases: [posiciones de vara, siete posiciones, notas pedal, pedales del trombón, transpositor en fa, gatillo de fa, F trigger, F attachment, Quartventil, glissando de vara, glissando de labio, trino de labio, trombón con sordina, sordina straight, Zug, Zugposition]
domain: orchestration
tags: [brass, trombone, techniques, glissando, mutes, playability]
style_scope: universal
use_when: Checking whether a trombone line, pedal note, glissando, trill or mute is playable, or rendering a slide/harmonic glissando in MIDI.
summary: Each slide position (I = Bb … VII = E) is one harmonic series; low notes have one position only, so fast VII↔I alternations (E2/B2 against Bb2) are awkward. A slide glissando spans at most a tritone and must stay on one partial; wider sweeps are lip glissandi in one position. The F attachment fills 35–39 and adds alternate positions; pedals Bb1–Ab1 are good, lower ones risky.
sources: ["adler-orq-es p.301-311", "adler-orq-es p.347-348", "adler-orq-en2 p.313-318", "piston-orch p.211-220", "piston-orch p.267-277"]
related: ["[[trombone]]", "[[trombone-period-practice]]", "[[brass-basics]]", "[[horn]]", "[[tuba]]"]
---

# Trombone slide technique

## Core idea
Pulling the slide out lowers the whole harmonic series a semitone per position. The 2nd partial is the
first practical note of each series; the fundamental is the **pedal**. Concert pitch, tenor in Bb:

| Position | I | II | III | IV | V | VI | VII |
|---|---|---|---|---|---|---|---|
| 2nd partial | Bb2 46 | A2 45 | Ab2 44 | G2 43 | Gb2 42 | F2 41 | E2 40 |
| Pedal | Bb1 34 | 33 | 32 | 31 | 30 | 29 | E1 28 |

Series above each pedal (semitone offsets): 0, 12, 19, 24, 28, 31, 34 (flat 7th), 36, 38, 40 — position I
= 34 46 53 58 62 65 68 70 72 74. Partial bands on the tenor: 2nd 40–46, 3rd 47–53, 4th 52–58,
5th 56–62, 6th 59–65, 8th 64–70. Notes 40–51 have **one position each**; higher notes have alternates
(D4 = 62 in I, IV or VII).

## Rules
- R1 `AVOID` fast passages alternating distant positions, above all VII↔I: E2/B2 (VII) against
  Bb2/A#2 (I) (Adler's drill; Bartók *Dance Suite*, Piston). Not impossible, hard for non-professionals.
- R2 `ALLOWED` pedals of positions I–III (34–32): good quality if the player has time to set the
  embouchure; approach after a rest or slow lead-in. `AVOID` IV–VII pedals (31–28): possible, hard to
  control (Adler, Piston). Rare in symphonic music, common in solo literature (Berlioz *Requiem* "Hostias").
- R3 `ALLOWED` **F attachment** (left-thumb rotary valve, "trigger"): the F series has six, longer
  positions with 2nd partials F2 41, E2 40, Eb2 39, D2 38, Db2 37, C2 36; an E slide/trigger (or pulled F
  tuning slide) adds B1 35. It fills 35–39 and gives alternate positions and extra glissandi. Bass
  trombones always have it; newest add a D attachment (Adler-en2). Piston (1955): plain tenors lack
  35–39. Default: write 35–39 for the bass trombone, not the tenor.
- R4 `MUST` a perfect slur exists only between adjacent partials of one position. Other "legato" is a soft
  tongue coordinated with the slide, near-seamless with good players (Adler, Piston).
- R5 `PREFER` cantabile = soft tongue on every note, joined like a smooth bow change, broken only at
  breaths (Piston). Audible portamento only when marked (Mahler 3 solo).
- R6 `NEVER` a slide glissando wider than a tritone (6 st, I↔VII), `NEVER` one that changes partial:
  G2→C3 (43→48) is impossible on the Bb tenor, fine on the F side (Piston). Ideal: VII→I (Bartók
  *Concerto for Orchestra* IV, Adler).
- R7 `ALLOWED` wider sweeps as **lip (harmonic) glissandi** up/down one position's series, like a horn rip
  (Bartók Violin Concerto 2: positions I, III–VI, f→ff). Rarely used, very effective.
- R8 `AVOID` overusing the slide glissando: easy both ways, now a comic/brash cliché (Adler-en2;
  Khachaturian "Sabre Dance"; Piston "easily abused"). Save it for a special moment.
- R9 `MUST` trills are lip trills between adjacent partials: in practice a whole step, upper register only
  (Piston; Stravinsky *Firebird*). `AVOID` low or half-step trills.
- R10 `ALLOWED` single, double and triple tonguing; long fast tonguing tires (big mouthpiece) and the low
  register is sluggish. Flutter-tongue: easy on all brass (Adler), less easy than on horn/trumpet (Piston).
- R11 `MUST` "con sord." = straight mute, the trombonist's usual (often only) mute. Muted low = sinister;
  muted f is less piercing than muted trumpet. Harmon is dull on trombone; `AVOID` cup in symphonic
  writing; solotone = nasal "old radio" (Grofé). Give time to insert/remove (general knowledge).
- R12 `ALLOWED` pure intonation: the slide tunes freely, ideal for sustained just-sounding chords.

## Apply in MIDI / REAPER
- Position check: position = 1 + k, where k (0–6) puts n + k in {46, 53, 58, 62, 65, 68, 70, 72, 74};
  flag fast steps between k = 6 and k = 0 (inferred).
- Slide gliss: pitch-bend ramp (set bend range ≥ the interval) or a legato/portamento articulation;
  span ≤ 6 st and both notes inside one partial band above.
- Harmonic gliss: fast legato run on one series, e.g. position IV = 43 50 55 59 62 65, or a rip patch.
- Pedals: half notes or longer after ≥ 1 beat of rest.
- Muted passages on a muted patch/articulation, with ≥ 2 bars to insert the mute.

## Checklist
- [ ] No fast VII↔I alternation; low notes (40–51) move slowly or stepwise.
- [ ] Every slide gliss ≤ 6 st on one partial; wider ones are lip glissandi.
- [ ] Trills whole-step, upper register.
- [ ] 35–39 only for bass trombone (or tenor with F trigger assumed).
