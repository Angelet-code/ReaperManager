---
id: harmony.four-part-voices-and-spacing
title: Four-part voices, ranges and spacing
aliases: [cuatro voces, SATB, tesituras, extensión de las voces, posición cerrada, posición abierta, posición de octava, posición de quinta, posición de tercera, cruce de voces, Stimmumfang, enge Lage, weite Lage, Stimmkreuzung]
domain: harmony
tags: [four-part, voicing, ranges, spacing]
style_scope: common-practice (the "wide at the bottom, limited gaps above" spacing principle is universal)
use_when: Laying out a chord progression as four concrete MIDI voices (choir, string quartet, chorale pad) before checking voice-leading.
summary: Soprano 60–79, alto 55–74, tenor 48–67, bass 40–60 (MIDI); keep S>A>T>B, S–A and A–T no wider than 12 semitones, T–B free. A voicing is named by its top chord member (octave/fifth/third position) and by close or open spacing.
sources: ["hindemith-1 p.1-3", "hindemith-1 p.4-11", "hindemith-1 p.12-17", "hindemith-1 p.25-38", "hindemith-1 p.53-59"]
related: ["[[doubling-rules]]", "[[voice-leading-basics]]", "[[voice-leading-parallels]]", "[[harmony-voicing-for-instruments]]", "[[harmonic-texture-and-voice-count]]", "[[_harmony]]"]
---

# Four-part voices, ranges and spacing

## Core idea
Hindemith's whole course is written for four voices: soprano, alto, tenor, bass (S+A on the treble staff,
T+B on the bass staff). Each voice has a singable range, the upper three stay close together, and the bass
may be far below. Later chapters loosen ranges and voice count, but this is the default skeleton from which
every instrumental voicing is derived (see [[harmony-voicing-for-instruments]]).

## Rules
- R1 `MUST` Keep each voice in its range (normal / rare extreme):

  | Voice | Normal (MIDI) | Extreme peaks |
  |---|---|---|
  | Soprano | C4–G5 (60–79) | down to ~A3 (57), up to A5 (81) |
  | Alto | G3–D5 (55–74) | down to ~F3 (53), up to E5 (76) |
  | Tenor | C3–G4 (48–67) | up to A4 (69) |
  | Bass | E2–C4 (40–60) | down to ~D2 (38), up to D4 (62) |

- R2 `NEVER` Cross voices: pitches must satisfy S ≥ A ≥ T ≥ B at every chord. Unisons are allowed
  (bass and tenor in unison on a chord is explicitly fine). One exception: bass above tenor in a close V7, see [[dominant-seventh]].
- R3 `MUST` Spacing: S–A ≤ 12 semitones, A–T ≤ 12 semitones; T–B may be any distance.
- R4 `ALLOWED` In the inversions of V9 and V13/7 the S–A gap may be a ninth (14 semitones); see
  [[dominant-ninth-and-thirteenth]].
- R5 `MUST` When the same harmony is repeated, change its position (re-voice it) instead of repeating the
  identical four notes.
- R6 `PREFER` Choose positions so that the next connections need no unnecessary leaps (look one or two
  chords ahead before fixing a voicing).
- R7 `ALLOWED` From the chapter on secondary triads onward, ranges are relaxed; at the keyboard fuller chords
  (more doublings) or thinner three-part harmony are fine. See [[harmonic-texture-and-voice-count]].
  - *Outside this style:* with instruments, ranges come from the instrument, not from SATB; the spacing
    principle (wide gaps only between bass and tenor) stays valid everywhere.

### Definitions
- **Close position** (posición cerrada): no chord tone could be inserted between S–A or between A–T.
- **Open position** (posición abierta): a chord tone fits between S–A or A–T.
- **Position by soprano**: octave position (root on top), fifth position, third position. Any of them can be
  close or open.

## Apply in MIDI / REAPER
- Data model: one chord = `{B, T, A, S}` MIDI integers. Write each voice to its own track (choir or string
  quartet) or to channels 1–4 of one item, so voice-leading can be read back per voice.
- Voicing search for chord *n*: bass is fixed by the bass line; enumerate pitch-class assignments for T/A/S
  allowed by [[doubling-rules]]; enumerate octaves inside R1 ranges; reject crossings (R2) and gaps > 12
  (R3); score the survivors by total semitone motion from chord *n−1* (held common tone = 0) plus penalties
  from [[voice-leading-parallels]]; keep the cheapest.
- Velocity (general knowledge): soprano 5–10 above the inner voices so the top line leads; bass equal to or
  slightly above the inner voices.

## Checklist
- Every pitch inside its normal range (extremes only as isolated peaks)?
- S ≥ A ≥ T ≥ B on every chord?
- S–A ≤ 12 and A–T ≤ 12 (14 only in V9/V13 inversions)?
- Repeated harmony re-voiced?

## Examples
C major tonic, bass C3 (48):
- Close, octave position: T E4 (64), A G4 (67), S C5 (72).
- Open, octave position: T G3 (55), A E4 (64), S C5 (72) — a G fits between A and S.
- Close, third position: T G3 (55), A C4 (60), S E4 (64).
