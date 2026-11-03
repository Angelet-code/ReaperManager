---
id: harmony.harmonic-planning-seven-factors
title: Harmonic planning with Hindemith's seven factors (per-bar plan)
aliases: [plan armónico, ritmo armónico, densidad armónica, declive armónico, amplitud de oscilación tonal, estratificación, plan tonal, tensión armónica, harmonischer Rhythmus, harmonisches Gefälle, Tonalitätsplan]
domain: harmony
tags: [planning, tension, harmonic-rhythm, tonal-plan, texture, form]
style_scope: universal (method); the tension scale is common-practice
use_when: Before generating any multi-bar piece or cue: lay out form, keys, tension, harmonic rhythm, texture style and voice count bar by bar so that build-ups and releases are designed, not accidental.
summary: Plan seven factors per bar before writing: form section, tonality (key or indeterminate), tonal oscillation (how far chords stray from the tonic), harmonic gradient (chord tension), harmonic density (harmonic rhythm), style (homophonic↔contrapuntal) and stratification (number of voices). If one factor peaks, reduce the others; tension must be planned, not produced by accident.
sources: ["hindemith-2 p.11-18", "hindemith-2 p.34-41", "hindemith-2 p.41-71"]
related: ["[[harmonic-texture-and-voice-count]]", "[[modulation]]", "[[cadences]]", "[[non-chord-tones]]", "[[harmonizing-a-melody]]", "[[harmonic-rhythm-scene-dialogue]]", "[[_form]]", "[[_film-scoring]]", "[[_orchestration]]", "[[_harmony]]"]
---

# Harmonic planning with the seven factors

## Core idea
Hindemith requires a complete plan before a note is written (shown on a 77-bar string-orchestra Presto).
Each factor is a separate curve over the bars; together they make the piece's shape. Technique made
unconscious by practice does not harm inspiration, it removes errors.

### The seven factors
| # | Factor | Values to plan per bar |
|---|---|---|
| 1 | Form (forma) | section letter + role: theme, second theme, climax, filler, transition, rest |
| 2 | Tonality (tonalidad) | key, or `indet` (tonics change too fast to relate) |
| 3 | Oscillation (amplitud de oscilación) | 0–3: how far chords stray from the tonic inside one key |
| 4 | Gradient (declive armónico) | 0–3: tension of each chord |
| 5 | Density (densidad armónica) | harmonic rhythm: beats per chord |
| 6 | Style (estilo) | H (homophonic) – h – c – C (contrapuntal) |
| 7 | Stratification (estratificación) | number of real voices / tones per chord, and its growth |

Scales (numeric values inferred from the source's rankings): **gradient** 0 = major triad; 1 = minor/
diminished triads, diatonic sevenths; 2 = V7; 3 = V9 (esp. minor), V13/7, altered dominants.
**Oscillation** 0 = I–V–I; 1 = diatonic (I–VI–IV–I); 2 = secondary dominants, borrowed chords; 3 = secondary
dominants before altered chords. The two are independent: a complex tonic chord = low oscillation, high
gradient; a simple triad from a remote key = high oscillation, low gradient.

## Rules
- R1 `MUST` Plan all seven factors for the whole piece, bar by bar, before writing.
- R2 `MUST` Main key = most bars + first and last place; the second key also well confirmed.
- R3 `ALLOWED` Indeterminate stretches (no key) — `AVOID` a piece made only of them; drop home-tonic chords
  into them to keep the main key's pre-eminence. No oscillation is planned in indeterminate bars.
- R4 `MUST` Long stretches in one key get variety through changing oscillation.
- R5 `MUST` If one element must predominate, reduce the others.
- R6 `MUST` Ignore non-chord tones when measuring gradient and density.
- R7 `AVOID` Tense chords that only appear because the voice-leading produced them; `AVOID` sudden relaxation
  after a run of high-tension chords unless the shock is intended.
- R8 `PREFER` Tonic and subdominant on tension-free chords; dominant and leading-tone chords carry the high
  gradient.
- R9 `PREFER` Main themes: long harmonies (whole/half notes); transitions and climaxes: faster (quarter-note)
  harmonic rhythm; in transitions give an inner voice a syncopation against the half-note harmony.
- R10 `AVOID` Both style extremes in a fast complex piece; choose a middle style, leaning homophonic or
  contrapuntal per section; make the least important section the most contrapuntal for contrast before the
  return of the main theme.
- R11 `PREFER` Stratification: thin at section starts (themes may re-enter thin), grow toward climaxes; the
  final return of the main theme is the thickest.
- R12 `MUST` For a build-up, avoid accent points: no main chords and no recent repetitions until the arrival.

## Apply in MIDI / REAPER
- Produce this table (JSON or markdown) before generating notes, then make generators read it:
  `bar | section | role | key | osc | grad | beats_per_chord | style | voices`.
- Map to MIDI: `grad` selects chord vocabulary; `beats_per_chord` sets chord change times; `voices` sets
  how many tracks/notes play (see [[harmonic-texture-and-voice-count]]); `style` chooses block chords vs
  independent lines; CC1/velocity curves follow `voices` and `grad` (general knowledge).
- Validate R5: flag bars where ≥ 3 of {osc, grad, density speed, voices} are at their maximum together,
  except at the planned climax.
- Mark sections as REAPER regions with the section letter and key.

## Checklist
- Plan table exists for every bar before generation?
- Home key first, last and largest; second key confirmed?
- High-gradient chords sit on dominant functions and are planned, not accidental?
- Only the climax has several factors at maximum; thin section starts, thickest final return?

## Examples
Hindemith's Presto plan, condensed:
Form A 1–5 | D 5–16 | B 17–25 | E 25–33 | C 33–40 | F 41–47 | A 48–52 | B 52–68 | E 68–70 | A 71–77.
Keys: C# | E/G# oscillating | indet | F | indet | C, A, F# (climax, fast) | indet | C# 48–67 | indet |
F# as IV of C# | C#. Density: A whole/half, D half, B mixed, E half, C quarter, F quarter, closing A half →
whole. Voices: b1 5, b5 3, b9 4, b16 1, b17 2, b22 4, b31 5, b40 3, b48 2, b52 4, b71–77 5.
