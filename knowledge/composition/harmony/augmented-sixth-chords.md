---
id: harmony.augmented-sixth-chords
title: Augmented sixth chords and altered dominants (German, French, Italian, augmented fifth)
aliases: [sexta aumentada, sexta alemana, sexta francesa, sexta italiana, séptima de dominante alterada, quinta aumentada, alteración cromática, alteración ampliada, übermäßiger Quintsextakkord, übermäßiger Terzquartakkord, übermäßiger Sextakkord, alterierte Dominante]
domain: harmony
tags: [chromaticism, augmented-sixth, altered-dominant, resolution]
style_scope: common-practice / romantic (in film the German sixth = dramatic pre-dominant; avoid continuous chains)
use_when: Writing a strong chromatic approach to V (or to a new key), or checking that a chromatic chord is a legitimate traditional chord and resolves correctly.
summary: Hindemith derives these from V7 by respelling or shifting its fifth/seventh. German sixth = dominant-seventh sound on b6 (C minor: Ab–C–Eb–F#), French = Ab–C–D–F#, Italian = Ab–C–F#; the augmented sixth (Ab–F#) expands outward to the octave on V. Augmented-fifth dominant G–B–D#–F puts D# on top rising to E. Fifths German→V are tolerated; never double a leading-tone note.
sources: ["hindemith-1 p.88-98", "hindemith-1 p.109-116", "hindemith-2 p.34-41"]
related: ["[[dominant-seventh]]", "[[diminished-seventh-pivot]]", "[[modulation]]", "[[voice-leading-parallels]]", "[[harmonic-planning-seven-factors]]", "[[_harmony]]"]
---

# Augmented sixth chords and altered dominants

## Core idea
Every chord with a tritone (d5/A4) behaves like a dominant. Change the V7 by (a) respelling its seventh,
(b) respelling its fifth, or (c) moving the fifth a semitone up or down, and you get the altered dominants.
Their resolution follows from the tritone: the voice that rises a semitone names the root of the target.

| Form (built on C) | Notes | Name | Normal target |
|---|---|---|---|
| original | C E G Bb | V7 | F |
| 7th respelled | C E G A# | German sixth (6/5 aug.) | B (V of E) |
| 5th lowered + 7th respelled | C E F# A# | French sixth (4/3 aug.) | B |
| 3-voice German | C E A# | Italian sixth | B |
| 5th raised | C E G# Bb | augmented-fifth dominant | F |
| 5th lowered | C E Gb Bb | V7 b5 (two tritones) | F; other targets possible |

In a key (tonic t), the German sixth stands on b6 (t+8) and resolves to V: C minor/major → Ab–C–Eb–F# → G.

## Rules
- R1 `MUST` Resolve to a major or minor chord (or its 6 chord) in plain form, without chromatic or
  enharmonic connection: (a) d5 inward / A4 outward; the note reached by the semitone rise is the new root;
  complete the chord with the two other voices.
- R2 `ALLOWED` (b) Deceptive variant: replace the expected root by a note a major/minor third lower.
- R3 `MUST` Any other resolution needs more than two chords to make its tonal meaning clear.
- R4 `ALLOWED` Parallel fifths in progressions with these chords (German → V): the ear is busy elsewhere.
  Avoid them by German → I6/4 → V if a clean texture is wanted (general knowledge).
- R5 `PREFER` German and French are the most used; then the augmented-fifth dominant, almost always with the
  raised fifth in the top voice rising a semitone.
- R6 `ALLOWED` Three-voice forms (Italian) resolve like their four-voice parents.
- R7 `NEVER` Double a note acting as leading tone (in any voice count).
- R8 `MUST` A chromatic chord is traditional only if it reduces to stacked thirds (triad, 7th, 9th type),
  possibly with one neighbour-tone substitution. Otherwise it is outside this style.
- R9 `AVOID` Excess alteration and continuous chains of altered dominant chords: it yields the post-Tristan
  idiom, of limited effect once familiar. Reduce complex spellings to leading-tone logic.
- R10 `ALLOWED` Remote modulation: make the last chord of the old key an altered dominant of the new key
  (see [[modulation]]).
  - *Outside this style:* film uses the German sixth and the augmented dominant as big dramatic
    pre-cadence gestures (general knowledge). In MIDI enharmonic spelling is invisible — only the
    resolution decides what the chord "is".

## Apply in MIDI / REAPER
- German sixth to V in key t: pitches {t+8, t, t+3, t+6}; bass t+8 falls 1 semitone to t+7; the voice with
  t+6 rises to t+7 (octave expansion); t moves to t−1 (leading tone) and t+3 to t+2.
- French: {t+8, t, t+2, t+6}; Italian: {t+8, t, t+6} with t doubled.
- Augmented dominant: {t+7, t+11, t+3 (=#5), t+5}; #5 in the top voice → t+4.
- In an orchestral build, give the augmented-sixth outer voices (bass b6, top #4) to low brass/cello and
  Vln I respectively so the outward expansion is audible; crescendo CC1 into V.

## Checklist
- Bass b6 → 5 and #4 → 5 (octave expansion) for augmented sixths?
- #5 of an augmented dominant on top and rising?
- No doubled leading-tone notes; chord reducible to stacked thirds?

## Examples (C minor, B/T/A/S)
- German: Ab2, C4, Eb4, F#4 → G2, B3, D4, G4 (licensed fifths Ab/Eb → G/D).
- French: Ab2, C4, D4, F#4 → G2, B3, D4, G4.
- Augmented dominant in C major: G2, B3, F4, D#5 → C3, C4, E4, E5.
