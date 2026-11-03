---
id: harmony.dominant-ninth-and-thirteenth
title: Dominant ninth (V9) and dominant seventh with thirteenth (V13/7)
aliases: [novena de dominante, V9, acorde de novena, séptima de dominante con sexta, V13, trecena, Dominantnonakkord, Dominantseptakkord mit Sexte]
domain: harmony
tags: [dominant, extended-chords, colour]
style_scope: common-practice (in jazz/film these are colour tones placed anywhere)
use_when: Colouring a dominant with a 9th or 13th in a four-part or pad texture and resolving it like a V7.
summary: V9 = V7 + 9th (major key: scale degree 6; minor: b6); in four parts drop the fifth, put the 9th on top, and do not let S–A form a second. V13/7 replaces the fifth with the 13th (scale degree 3), usually on top. Both resolve exactly like V7 and its inversions; check V13/7→I for parallel octaves.
sources: ["hindemith-1 p.34-38", "hindemith-2 p.11-18"]
related: ["[[dominant-seventh]]", "[[voice-leading-parallels]]", "[[harmonic-planning-seven-factors]]", "[[diminished-seventh-pivot]]", "[[_harmony]]"]
---

# Dominant ninth and thirteenth

## Core idea
Two ways to intensify V7 without changing its function: add the ninth (G–B–D–F–A in C, Ab in minor), or
replace the fifth with the sixth/13th (G–B–F–E, Eb in minor). They are among the highest-tension chords of
traditional harmony (see [[harmonic-planning-seven-factors]], gradient), especially V9 in minor.

## Rules
- R1 `MUST` V9 in four parts: omit the fifth; 9th in the top voice; soprano and alto must not form a
  second (in C: never G4 directly under A4).
- R2 `PREFER` V13/7: the 13th almost always in the top voice.
- R3 `MUST` Connect V9, V13/7 and their inversions exactly like V7 and the corresponding inversion. Third
  in the bass (V7/6/5 for V9, V11/6/5 for V13) → I; seventh in the bass (V10/4/2, V7/4/2) → I6.
- R4 `ALLOWED` Approach the characteristic tone (9th, 13th) by an augmented or diminished step.
- R5 `ALLOWED` In the inversions V7/6/5 and V10/4/2, S–A may be a ninth (14 semitones) apart.
- R6 `MUST` Choose positions that avoid unnecessary leaps in all voices.
- R7 `AVOID` V13/7 → I without an explicit parallel-octave check (the 13th and 7th land on tones other voices
  may also reach).
- R8 Resolution of the colour tone (general knowledge): the 9th falls a step to the fifth of I; the 13th either
  stays as a common tone (third of I) or falls a third to the tonic.
- R9 `ALLOWED` Read V9 (even V7) as a simpler chord plus non-chord tones when that explains the music better.
  - *Outside this style:* in jazz, pop and film the 9th/13th are colour tones in any voice and need no
    resolution; V7b9 is a staple of dramatic film harmony (general knowledge). Keeping the 9th on top is what
    gives the classical, "yearning" effect.

## Apply in MIDI / REAPER
- Pitch sets (relative to tonic t): V9 major {t+7, t+11, t+5, t+9}; V9 minor {t+7, t+11, t+5, t+8};
  V13/7 {t+7, t+11, t+5, t+4} (minor t+3). Assign the colour tone to the top voice.
- Spacing check: top voice − next voice ≥ 3 semitones (no second), ≤ 12 (≤ 14 in inversions).
- In a string pad, give the 9th to Vln I with a CC1 swell into the resolution; the resolution note can be
  slightly softer (−5 to −10 velocity / CC1) than the dissonance.
- A V9 without root equals vii°7 (minor) or viiø7 (major); the bass-less form is a [[diminished-seventh-pivot]]
  (general knowledge).

## Checklist
- Fifth omitted in V9, 9th on top, no second between S and A?
- 13th on top in V13/7, fifth absent?
- Resolved like the corresponding V7 inversion; octave check done after V13/7?

## Examples (C major)
- V9: G2, F3, B3, A4 → I: C3, E3, C4, G4.
- V9 first inversion (V7/6/5): B2, G3, F4, A4 → C3.
- V9 third inversion (V10/4/2): F3, G3, B3, A4 → I6 (E3 bass).
- V13/7: G3, F4, B4, E5 → C: C3, E4, C5, E5 (13th held as the third of I).
