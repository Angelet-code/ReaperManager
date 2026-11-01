---
id: harmony.triads-and-inversions
title: Triads, sixth chords and 6/4 chords
aliases: [tríada, acorde perfecto, acorde de sexta, primera inversión, segunda inversión, acorde de cuarta y sexta, seis cuatro cadencial, 6/4 de paso, 6/4 de bordadura, Dreiklang, Sextakkord, Quartsextakkord]
domain: harmony
tags: [triads, inversions, six-four, scale-degrees]
style_scope: common-practice (6/4 restrictions are a style law; pop uses slash chords freely)
use_when: Choosing chord quality per scale degree and deciding whether a triad may stand in root position, first inversion (6) or second inversion (6/4) at a given beat.
summary: Major key I, IV, V major; II, III, VI minor; VII diminished — minor key uses harmonic minor (V major, III augmented). Sixth chords are free and smooth; 6/4 chords only as cadential I6/4 before V (strong beat), passing or neighbour/pedal chords.
sources: ["hindemith-1 p.1-3", "hindemith-1 p.12-17", "hindemith-1 p.48-52", "hindemith-1 p.53-59"]
related: ["[[doubling-rules]]", "[[cadences]]", "[[diatonic-secondary-triads]]", "[[figured-bass-reading]]", "[[_harmony]]"]
---

# Triads, sixth chords and 6/4 chords

## Core idea
A triad has root, third and fifth. Its bass decides the inversion: root position (5/3), sixth chord (6, third
in bass) or 6/4 (fifth in bass). Sixth chords are the everyday way to make a smooth bass; 6/4 chords are
unstable and appear only in a few fixed roles.

## Rules
- R1 `MUST` Diatonic triad qualities. Major: I, IV, V major; II, III, VI minor; VII diminished. Minor
  (harmonic minor): I, IV minor; V, VI major; II, VII diminished; III augmented. V is major in both modes.
- R2 `MUST` In minor, raise the 7th degree in V and VII (harmonic minor).
- R3 `ALLOWED` Omit the fifth of a major/minor triad (root tripled or third doubled).
- R4 `MUST` In sixth chords double root or fifth; doubling the third is `ALLOWED` later (see
  [[doubling-rules]]). Do not put the third on top as well (soprano in octave or fifth position).
- R5 `MUST` Connect sixth chords like root-position chords: hold common tones, move by the smallest interval.
- R6 `ALLOWED` Bass leaps of a sixth or octave; bass may leap by an augmented/diminished interval *to* the
  leading tone.
- R7 `PREFER` Double the bass note of a 6/4 chord.
- R8 `PREFER` Use I6/4 (a) before V in a cadence — it is V with two appoggiaturas (6→5, 4→3), placed on the
  stronger beat; or (b) as passing / double-neighbour chord.
- R9 `PREFER` IV6/4 and V6/4 only as products of neighbour, passing or anticipation motion (e.g. over a
  held tonic bass).
- R10 `AVOID` A 6/4 on a strong beat except the cadential I6/4.
- R11 `PREFER` Diminished triads in first inversion, doubling the bass (their third).
- R12 `NEVER` Double the leading tone of the augmented triad (III of minor).
  - *Outside this style:* pop/rock use second-inversion slash chords (C/G) on strong beats and bass-walk
    inversions freely (general knowledge). In orchestral film writing the cadential 6/4 still signals a
    "classical" close; avoid it if the cue must not sound old-fashioned.

## Apply in MIDI / REAPER
- Degree → semitones above tonic: major {0,2,4,5,7,9,11}; harmonic minor {0,2,3,5,7,8,11}. Build triads by
  stacking scale degrees i, i+2, i+4.
- Inversion = which chord member goes to the bass voice; upper voices are then chosen by
  [[voice-leading-basics]].
- 6/4 gate in the generator: allow a 6/4 only if (cadential: chord = I, next = V same bass, onset on a
  stronger beat than V) or (passing: bass moves by step in and out in the same direction) or (pedal: bass
  equals previous and next bass, upper voices neighbour motion).

## Checklist
- Chord qualities match the mode (harmonic minor raised 7th in V/VII)?
- Every 6/4 is cadential, passing or pedal?
- Cadential I6/4 on the stronger beat, bass doubled, resolving 6→5 and 4→3 over the same bass?

## Examples (C major)
- Cadential: I6/4 (G2, G3, C4, E4) → V (G2, G3, B3, D4) → I.
- Passing: I (C3) – V6/4 (D3) – I6 (E3).
- Pedal / neighbour: I (C3; G3–C4–E4) – IV6/4 (C3; A3–C4–F4) – I.
- Templates from the 6/4 chapter: I6/4–V7–I · IV–I6/4–V–I · IV–V6/4–I · I–IV6/4–I.
