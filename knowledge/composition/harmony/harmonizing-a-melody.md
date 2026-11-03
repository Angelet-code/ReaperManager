---
id: harmony.harmonizing-a-melody
title: Harmonizing a melody (procedure)
aliases: [armonizar una melodía, armonización, armonizar un tiple, rearmonizar, Melodieharmonisierung, Harmonisierung]
domain: harmony
tags: [melody, harmonization, procedure, bass-line]
style_scope: common-practice (procedure — bass first, main chords on accented bars, few chromatic chords — works for any tonal style)
use_when: Given a melody (lead, vocal, theme) and asked to add chords, a bass line and inner voices or a pad underneath.
summary: Decide the harmonic rhythm and which melody notes are non-chord tones, put the main chords of the key on the accented bars and the cadences at phrase ends, write the whole bass line first as a good line, then add secondary chords and only a few secondary dominants, then inner voices. Vary repeated bar groups and avoid main chords during a long crescendo.
sources: ["hindemith-1 p.39-47", "hindemith-1 p.48-52", "hindemith-2 p.11-18", "hindemith-2 p.22-29", "hindemith-2 p.29-33", "hindemith-2 p.41-56"]
related: ["[[non-chord-tones]]", "[[cadences]]", "[[secondary-dominants]]", "[[voice-leading-basics]]", "[[harmonic-planning-seven-factors]]", "[[accompaniment-for-solo-line]]", "[[_form]]", "[[_harmony]]"]
---

# Harmonizing a melody

## Core idea
Hindemith's order of work is always: melody → bass → other voices. The bass is the foundation of the
harmonic and tonal development, so it must be a good line in its own right before any chord is filled in.
Melody notes on weak positions are often non-chord tones and should not each get their own chord.

## Rules
- R1 `MUST` Order of work: melody (complete and final) → bass → remaining voices.
- R2 `PREFER` Give priority to a perfect bass line: write it whole, thinking of the chords the melody implies.
- R3 `MUST` Fix the harmonic rhythm first (one chord per beat, half bar or bar); notes faster than it are
  candidates for non-chord tones ([[non-chord-tones]]). Defaults (general knowledge): chorale/hymn = one
  chord per beat; classical melody-and-accompaniment = one per bar or half bar; faster toward cadences.
- R4 `MUST` Clarify the metric grouping (bars in units of 2 or 3, one accented); put the main chords of the
  key (I, IV, V) on the accented bars, secondary chords on the weak ones.
- R5 `MUST` Cadences at phrase ends, strength chosen by form ([[cadences]]).
- R6 `MUST` Secondary dominants: mark all possible spots, fix the main harmonies, keep only a few
  ([[secondary-dominants]]).
- R7 `PREFER` Harmonize corresponding bar groups differently.
- R8 `MUST` During a long crescendo do not accent: avoid the main chords of the key and avoid repeating
  harmonies heard shortly before, until the arrival.
- R9 `PREFER` Use the added voices' rhythm and voice-leading to intensify the expression even when "only
  harmonizing" a given melody.
- R10 `MUST` If the bass is the melodically active line, keep the upper voice simpler (halves/quarters) — one
  leading line at a time.
- R11 `AVOID` Bass-type 4th/5th cadential leaps when the bass sits in tenor register.
- R12 `MUST` Altered/borrowed chords: bring back the tonic often so the key stays clear.
- R13 `PREFER` Match means to the expressive arc: jubilant = strong harmonic and rhythmic impulse; decline =
  reduce *all* means together; resigned = stepwise motion and calm repeated motives.
- R14 `MUST` (general knowledge) Minor mode: take V and vii° from harmonic minor (raised leading tone).
  `AVOID` the augmented second b6→#7 within one voice; in lines use melodic minor ascending (#6–#7) and
  natural minor descending. III+ is rare.
- R15 `ALLOWED` (general knowledge) After V7, an incomplete final tonic (root tripled + third, no fifth) is
  normal: it comes from resolving the leading tone and the seventh correctly.
  - *Outside this style:* in pop the harmonic rhythm is usually one chord per bar or half bar with loops;
    in film, a sustained pedal under a moving melody is often better than chord-per-note (general knowledge).

## Apply in MIDI / REAPER
Algorithm for an agent:
1. Read the melody track; quantize-analyse onsets; choose harmonic rhythm `hr` (beats per chord).
2. For each `hr` window, the structural melody note = the note on the strongest position (longest if tied);
   other notes are NCT candidates.
3. Candidate chords = diatonic chords containing the structural pitch class (plus V7, II6/5).
4. Score paths (dynamic programming / Viterbi): + main chord on accented bar; + root motion by 4th/5th or
   step (general knowledge); + cadence pattern at phrase ends; − same chord repeated across a bar line;
   − root position 6/4 off the cadence; − more than 1 secondary dominant per phrase.
5. Derive the bass: choose inversions so the bass moves mostly by step with occasional leaps, contrary to the
   melody at cadences; check bass–melody pair with [[voice-leading-parallels]].
6. Fill inner voices with [[voice-leading-basics]] and [[doubling-rules]].
7. Re-run checks; vary the second statement of repeated phrases (R7).

"Cuerdas a 4 voces" (general knowledge) = string quartet: S → Vln I, A → Vln II, T → Va, B → Vc, one track
each at sounding pitch. For string orchestra add Cb doubling the cello an octave below.

## Checklist
- Bass a good line on its own (sing/play it alone)?
- Main chords on accented bars, cadences at phrase ends?
- Weak-position melody notes treated as NCTs, not each re-harmonized?
- Few secondary dominants; repeated phrases re-harmonized; no main chords in the crescendo?

## Examples
- C major melody E5 D5 | C5 B4 | C5: structural notes E, C, C → I | IV (C under F) – V (B over G) | I;
  bass C3 – F2 – G2 – C3, D5 treated as passing tone.
- Phrase repeat: bars 1–3 I–V–I, bars 5–7 I6–II6/5–V–VI (deceptive, then extended).
