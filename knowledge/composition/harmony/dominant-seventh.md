---
id: harmony.dominant-seventh
title: Dominant seventh chord, inversions and resolutions
aliases: [séptima de dominante, V7, acorde de quinta y sexta, acorde de sexta sensible, acorde de tercera y cuarta, acorde de segunda, tritono, sensible, Dominantseptakkord, Quintsextakkord, Terzquartakkord, Sekundakkord, Leitton, Tritonus]
domain: harmony
tags: [dominant, seventh-chords, resolution, inversions]
style_scope: common-practice (leading tone up / seventh down = the classical sound; jazz, blues and pop leave sevenths unresolved)
use_when: Placing a V7 or one of its inversions (V6/5, V4/3, V2) and resolving it, or checking that the leading tone and seventh move correctly.
summary: V7 = dominant triad + minor seventh (in C: G–B–D–F). The leading tone rises a semitone to the tonic and the seventh falls a step; the tritone contracts (d5→3rd) or expands (A4→6th). Complete V7 goes to an incomplete I and vice versa; V6/5→I, V4/3→I or I6, V2→I6.
sources: ["hindemith-1 p.18-24", "hindemith-1 p.25-33"]
related: ["[[doubling-rules]]", "[[voice-leading-parallels]]", "[[dominant-ninth-and-thirteenth]]", "[[cadences]]", "[[secondary-dominants]]", "[[_harmony]]"]
---

# Dominant seventh chord, inversions and resolutions

## Core idea
The V7 contains a tritone between the leading tone (3rd of V) and the seventh. That tritone is what demands
resolution: diminished fifth inward, augmented fourth outward. Everything else moves the shortest way. The
same chord in minor uses the raised leading tone (C minor: G–B–D–F).

## Rules
- R1 `MUST` Resolve the tritone: the leading tone rises a semitone to the tonic; the seventh falls a step
  (to the third of I). Dim 5th (B below F) contracts to a third; aug 4th (F below B) expands to a sixth.
- R2 `MUST` Procedure: bass → complete V7 → resolve the tritone → move the other voices the shortest way.
- R3 `MUST` Complete V7 (with fifth) → I without fifth (tripled root or doubled third). V7 without fifth
  (root doubled) → complete I.
- R4 `ALLOWED` Omit the fifth of V7 (and of V6/5, V2); then octave position (root on top) becomes possible.
- R5 `NEVER` Double the seventh. `AVOID` doubling the leading tone (parallel-octave risk).
- R6 `MUST` Normal resolutions of inversions: V6/5 (leading tone in bass) → I in root position; V4/3 (fifth in
  bass) → I or I6; V2 (seventh in bass) → I6, the bass falling a step.
- R7 V7 (or inversions) → IV: the tritone cannot resolve normally; hold the common tone and connect as
  directly as possible. This is acceptable.
- R8 `ALLOWED` "V 8–7": V with the octave on one beat falling to the seventh on the next.
- R9 `ALLOWED` In a close-position V7 the bass may lie above the tenor when unavoidable (it still sounds as
  root-position V7). Otherwise no crossing.
- R10 `ALLOWED` IV–V7 connections that are only smooth with an augmented/diminished step; approaching the
  leading tone by such a step in any voice.
- R11 `NEVER` Put a bare open fifth or bare unison chord directly after any chord containing the tritone.
- R12 `NEVER` End on a seventh chord; the final chord is root-position tonic.
  - *Outside this style:* blues and rock use I7/IV7 as stable colours; jazz and pop let sevenths hang or
    move up. In film, an unresolved V7 or V7→IV is a valid "open" gesture; when you want the classical pull,
    resolve exactly as R1.

## Apply in MIDI / REAPER
- Build: root = tonic + 7; pitches root, +4, +7, +10 (pc). Tag the voice holding pc (tonic+11) as `LT` and the
  one holding pc (tonic+5) as `SEVENTH`.
- Resolution constraint for the next chord: `LT` → +1 semitone (exception allowed only for inner-voice LT
  dropping to the fifth, general knowledge); `SEVENTH` → −1 or −2 semitones. Then fill the rest per
  [[voice-leading-basics]] and check R3 completeness.
- Bass-line templates: I–V4/3–I6 (C3–D3–E3), V6/5–I (B2–C3), IV–V2–I6 (F2–F2–E2).
- On legato strings/brass, give the LT and seventh resolutions a slightly longer overlap (5–20 ms) so the
  resolution is heard as connected.

## Checklist
- Leading tone up a semitone, seventh down a step?
- Inversion resolves to the expected bass (V6/5→I root, V2→I6)?
- Completeness rule R3 respected; no doubled seventh?
- No bare fifth/unison right after the V7; piece ends on root-position I?

## Examples (C major)
- Complete V7 → incomplete I: G2, D4, F4, B4 → C3, C4, E4, C5.
- Incomplete V7 → complete I: G2, B3, F4, G4 → C3, C4, E4, G4.
- Doubled-third resolution: G3, B3, F4, D5 → C3, C4, E4, E5.
