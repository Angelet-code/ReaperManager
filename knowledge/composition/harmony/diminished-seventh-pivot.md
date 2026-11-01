---
id: harmony.diminished-seventh-pivot
title: Diminished seventh as a multi-target pivot
aliases: [séptima disminuida, acorde de séptima disminuida, séptima de sensible, VII7, acorde pivote, enarmonía, verminderter Septakkord, enharmonische Umdeutung]
domain: harmony
tags: [diminished-seventh, pivot, enharmonic, modulation, leading-tone-chords]
style_scope: common-practice / romantic (film: suspense colour; overuse = melodrama cliché)
use_when: Moving quickly to a distant or ambiguous key, intensifying arrival on any chord with a leading-tone chord, or resolving a diminished seventh correctly.
summary: The diminished seventh (stacked minor thirds, e.g. G#–B–D–F) can resolve directly to four different roots: treat any of its tones as leading tone and resolve it up a semitone to the new root (A, C, Eb, F#), major or minor. There are only three distinct dim7 sonorities; never double the note acting as leading tone.
sources: ["hindemith-1 p.60-72", "hindemith-1 p.73-81", "hindemith-1 p.82-87", "hindemith-1 p.88-98", "hindemith-2 p.29-33"]
related: ["[[modulation]]", "[[secondary-dominants]]", "[[augmented-sixth-chords]]", "[[mode-mixture-and-neapolitan]]", "[[_harmony]]"]
---

# Diminished seventh as a multi-target pivot

## Core idea
VII7 of harmonic minor (in A minor G#–B–D–F; in C major borrowed: B–D–F–Ab) is built of three minor thirds,
so every inversion has the same interval structure. Any of its four tones can be heard as the leading tone,
which makes it the most flexible pivot in traditional harmony. In MIDI the spellings G#/Ab, B/Cb, D, F/E#
are the same keys: only the resolution defines the chord.

## Rules
- R1 `ALLOWED` Resolve a diminished seventh directly to four different major or minor chords (or their
  inversions): choose one tone as leading tone; it rises a semitone to the new root. A minor's G#–B–D–F →
  A (G#→A), C (B→C), Eb (D→Eb), F#/Gb (F→F#).
- R2 `PREFER` Resolve the two tritones as in V7 (dim 5th inward, aug 4th outward) for the normal resolution.
- R3 `NEVER` Double the note acting as leading tone (also in thinner or thicker textures).
- R4 `ALLOWED` Replace the third above the leading tone by a diminished fourth (B–F–Ab–Eb instead of
  B–D–F–Ab): a dominant with b13, resolving to C minor; the new note `MUST` be in the top voice.
- R5 `ALLOWED` As secondary leading-tone chord: a dim7 (or half-diminished, or VII/VII6) whose root is a
  semitone below the root of any chord gives the same push as a secondary dominant (see
  [[secondary-dominants]]).
- R6 `MUST` In a modulation, confirm the new key afterwards with a cadence (see [[modulation]]); the dim7
  alone is ambiguous by nature.
  - *Outside this style:* a tremolo dim7 is the classic silent-film / melodrama suspense chord; in modern
    film use it briefly or voice it as part of a cluster (general knowledge).

## Apply in MIDI / REAPER
- Pitch classes: dim7 = {r, r+3, r+6, r+9}. Possible target roots = {r+1, r+4, r+7, r+10}, each major or
  minor → 8 target triads (or use them as V of a key).
- Only three dim7 sets exist: {0,3,6,9}, {1,4,7,10}, {2,5,8,11}. To reach target root x, use the set
  containing x−1.
- Resolution voice-leading: the chosen leading tone +1; the other three voices move to the nearest tones of
  the target (mostly by semitone/step); check no doubled leading tone.
- Pivot modulation algorithm: in old key, use vii°7 (or vii°7/V); reinterpret one tone as leading tone of the
  new tonic or of the new V; follow with new V7–I.
- Strings: dim7 tremolo (ponticello optional) with CC1 crescendo reads as tension; resolve on a sustain patch.

## Checklist
- Exactly one tone treated as leading tone and resolved up a semitone?
- Leading tone not doubled; dim-4th variant has the new note on top?
- Target key confirmed by a cadence afterwards?

## Examples
- C major → A minor: B–D–F–Ab (vii°7 of C, borrowed) → G#=Ab as leading tone → A minor.
- A minor → Eb major: G#–B–D–F, D→Eb as leading tone → Eb (then Bb7–Eb to confirm).
- dim-4th form: B3, F4, Ab4, Eb5 → C minor (C–Eb–G–C): leading tone B3→C4, F4→Eb4, Ab4→G4, Eb5→C5.
