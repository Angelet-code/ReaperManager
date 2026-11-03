---
id: harmony.non-chord-tones
title: Non-chord tones (passing, neighbour, suspension, appoggiatura, anticipation, escape)
aliases: [notas extrañas, notas extrañas al acorde, nota de paso, bordadura, floreo, retardo, apoyatura, anticipación, escapatoria, notas libres, akkordfremde Töne, Durchgangston, Wechselnote, Nebennote, Vorhalt, Antizipation, Échappée]
domain: harmony
tags: [non-chord-tones, melody, suspension, metre]
style_scope: common-practice (metric placement logic is universal for melodic writing over chords)
use_when: Writing a melody or inner line faster than the harmonic rhythm, adding suspensions to a pad or string line, or deciding whether a dissonant note is legitimate.
summary: Passing and neighbour tones move by step and sit on weaker positions than the chord tones they connect; suspensions are held over from the previous chord into a stronger beat and resolve down a step; appoggiaturas are unprepared suspensions; anticipations sound the next chord tone early on a weak position. Fifths NCT-to-chord-tone are fine, octaves are not.
sources: ["hindemith-1 p.39-47", "hindemith-1 p.48-52", "hindemith-1 p.60-72", "hindemith-2 p.41-56"]
related: ["[[voice-leading-parallels]]", "[[harmonizing-a-melody]]", "[[doubling-rules]]", "[[harmonic-planning-seven-factors]]", "[[_harmony]]"]
---

# Non-chord tones

## Core idea
A non-chord tone (NCT, marked "+" in Hindemith) is any note not in the current chord. Each type is defined by
**how it is approached and left** and by **its metric weight relative to the chord tones around it**. The
metric rule is what makes a dissonance sound intentional.

## Rules
| Type | Approach | Leave | Metric rule |
|---|---|---|---|
| Passing tone (nota de paso) | step | step, same direction, between two *different* chord tones | weaker than both chord tones |
| Neighbour (bordadura) | step from a chord tone | step back to the *same* tone | weaker than the chord tone |
| Suspension (retardo) | held (tied) from previous chord, where it was a chord tone | step to the chord tone (usually down) | stronger than preparation and resolution |
| Appoggiatura (apoyatura) | leap or step, no preparation | step to the chord tone | as suspension (strong) |
| Anticipation (anticipación) | any (usually step) | repeated as chord tone of next chord | weak, just before the change |
| Escape tone (escapatoria) | step from a chord tone | leap to a chord tone of next chord | weaker than its resolution |
| Leaped-to escape | leap from a chord tone | step to a chord tone | weak |
| Free note (nota libre) | exceptional, fits no class | — | use rarely |

- R1 `MUST` Passing and neighbour tones on weaker metric positions than the chord tones they connect.
- R2 `MUST` Suspension = prepared in the same voice, held into the stronger beat, resolved by step.
- R3 `PREFER` Downward resolution; upward suspensions are rarer.
- R4 `ALLOWED` Ornamented resolution: other notes between the suspension and its resolution.
- R5 Doubling at the resolution: may double the third of a minor chord; `AVOID` for a major chord; `NEVER`
  when that third is the leading tone (don't resolve onto a leading tone already sounding in another voice).
- R6 `ALLOWED` NCTs may create doublings normally forbidden (leading tone, 7ths, 9ths) — they are transitory.
- R7 Parallels: NCT–chord-tone fifths `ALLOWED`; NCT–chord-tone octaves `NEVER`; fifths between two NCTs of
  the same kind `NEVER`; a suspension must not hide parallels except in slow tempo (detail in
  [[voice-leading-parallels]]).
- R8 `ALLOWED` Read complex chords (V9, even V7) as simpler chords plus NCTs.
- R9 `MUST` Ignore NCTs when measuring harmonic tension and harmonic rhythm (planning).
- R10 `PREFER` In a fast theme with a slow harmonic plan, make every value shorter than the harmonic rhythm an
  NCT; in a climax with much motion, keep the fast notes on chord tones.
  - *Outside this style:* pop/film melodies freely land unresolved 9ths, 11ths and 6ths on strong beats as
    colour (general knowledge). The metric logic still applies when you want the "classical" sense of
    tension and release.

## Apply in MIDI / REAPER
- Tag each melody note `{ct, pt, nt, sus, app, ant, esc}`. Metric weight per position in 4/4 (general
  knowledge): beat 1 = 4, beat 3 = 3, beats 2/4 = 2, eighth offbeats = 1, sixteenths = 0. Validate R1/R2
  with these weights.
- Suspension generator: extend a note of chord n across the next chord's onset (tie, one note event), then
  add the step-down resolution at the next beat or half-beat. Typical figures over the bass: 4–3, 7–6, 9–8
  (general knowledge). Velocity of the resolution 5–15 lower than the suspension (it is the release).
- Legato string patches: write passing tones overlapping 10–30 ms with the next note for true legato
  transitions.
- Run the parallel checker on the chord-tone skeleton (suspensions replaced by resolutions) and on the surface.

## Checklist
- Every NCT classified; passing/neighbour on weak positions?
- Suspensions prepared, on strong beats, resolving by step?
- No octaves between an NCT and a chord tone?
- Suspension not resolving onto a leading tone that is already doubled?

## Examples (C major)
- Passing: E5–D5–C5 over I (D5 on the weak beat). Neighbour: C5–D5–C5 or C5–B4–C5.
- Suspension: C5 held from I into V on the downbeat → B4 on beat 2.
- Anticipation: over V, soprano B4 then C5 on the last offbeat eighth, then I with C5.
