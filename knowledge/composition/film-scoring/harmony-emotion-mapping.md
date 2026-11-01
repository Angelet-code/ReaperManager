---
id: film-scoring.harmony-emotion-mapping
title: Harmony to emotion mapping (film)
aliases: [armonía y emoción, emoción armónica, acordes y emociones, mediantes cromáticas, épico, mágico, oscuro, tensión, terror, clusters, acordes paralelos]
domain: film-scoring
tags: [harmony, emotion, chromatic-mediants, clusters, cue-design]
style_scope: film (media/trailer scoring with sample libraries; not common-practice rules)
use_when: Choosing chord qualities and progressions for an emotional brief ("épico", "mágico", "triste", "oscuro", "tensión", "terror") in a cue.
summary: Diatonic major = love and warmth; diatonic minor = sadness. Non-diatonic motion (parallel chords, mediants a third apart, tritone pairs) gives magic, fantasy and grandeur in major, and menace and darkness in minor. Extensions colour major chords and add tension to minor ones (action, thriller); clusters mean horror.
sources: ["film-4day-challenge slide 2", "httyd-test-drive p.1-15"]
related: ["[[harmonic-storytelling-chord-functions]]", "[[harmonic-rhythm-scene-dialogue]]", "[[httyd-test-drive-case-study]]", "[[five-elements-arrangement-checklist]]", "[[chord-voicing-family-stacking]]"]
---

# Harmony to emotion mapping (film)

## Core idea
In film scoring, harmony is chosen first for its **emotional colour**. The rough polarity is major =
positive and minor = negative. The *type* of progression decides which emotion: diatonic (familiar,
human) or non-diatonic (other-worldly, epic, threatening). Extensions and clusters set the intensity.

## Rules
- R1 `PREFER` Warmth, love, home: diatonic major progressions (I–IV–vi–V in any order).
- R2 `PREFER` Sadness, loss: diatonic minor progressions (i–iv–VI–v, i–VI–III–VII).
- R3 `PREFER` Magic, fantasy, supernatural, grandeur: non-diatonic **major** chords. Use parallel
  majors, mediants a M3 or m3 away (C–E, C–Ab, C–A, C–Eb) and tritone pairs (C–F#).
- R4 `PREFER` Menace, darkness: the same non-diatonic motion with **minor** chords (Cm–Abm, Cm–Ebm,
  Cm–F#m).
- R5 `PREFER` Character or intensified joy: extensions on major chords (add9, maj7, 6/9, sus2).
- R6 `PREFER` Tension, action, suspense, thriller: dissonance on minor chords (m(add9), m(maj7), added
  2nds and 4ths, b9 colour).
- R7 `ALLOWED` Horror and darkness: clusters (3+ adjacent semitones or whole tones voiced closely).
- R8 `ALLOWED` Neutral or undefined mood: open fifths (no third), as in the HTTYD power-chord pedal (D5).
- R9 `PREFER` Mediant triads over a fixed tonic pedal for adventure and wonder that stays anchored
  (HTTYD gallop: Ab/D – C/D – Ab/D – F/D – B/D).

## Apply in MIDI / REAPER
**Brief → progression lookup** (4 chords, 1 chord per bar at moderate tempo; voicings in
[[chord-voicing-family-stacking]]):
| Brief (ES) | Progression (in C / Cm) | Bass (MIDI) | Orchestral colour |
|---|---|---|---|
| amor, cálido, hogar | C – Am – F – G | 36, 45, 41, 43 | strings legato, horns pad, CC1 50–70 |
| triste, pérdida | Cm – Ab – Fm – G(sus4→G) | 36, 44, 41, 43 | strings con sordino, solo woodwind, CC1 30–50 |
| mágico, maravilla | C – E – Ab – C | 36, 40, 44, 36 | celesta, harp, high strings, choir "ah" |
| épico, grandeza | C – Ab – Bb – C (or C – Eb – F – C) | 36, 44, 46, 36 | horns a6, brass low, timpani, CC1 90–110 |
| oscuro, amenaza | Cm – Abm – Cm – F#m | 36, 44, 36, 42 | low strings, low brass, contrabassoon, CC1 40–70 |
| tensión, acción | Cm(add9) – Cm(maj7) ostinato over a C pedal | 36 pedal | string ostinato, brass stabs, percussion |
| terror | cluster C4–Db4–D4–Eb4 (60–63) + tritone bass F#1/C2 | 30, 36 | divisi tremolo strings, sul ponticello, low-brass rips |
| neutral, misterio | C5 (C–G) open fifth, no third | 36 | sustained strings, flute or low clarinet |

- **Third-relation voice-leading:** keep the common tone in the same track (C → E major: E stays; C → Ab:
  C stays). That keeps chromatic moves smooth on sustained patches, using legato transitions where possible.
- **Pedal + mediants:** bass tracks hold the tonic (e.g. D2 38 + D1 26) and re-attack it every 2 bars,
  while brass and strings change triads above (see [[action-ostinato-pedal-gallop]]).
- **Extensions:** put the added note (9th, maj7) in an inner voice (violas, clarinet, horn 2), not in the
  bass and not on top, unless the colour is the point.
- **Clusters:** spread the cluster across 3–4 string tracks (divisi). Each holds one pitch with a
  staggered CC1 swell (offset 1/2 beat), so the cluster breathes.

## Checklist
- Does the progression type (diatonic or non-diatonic) match the brief's world (human or
  other-worldly)?
- Does the chord quality (major or minor) match the polarity?
- Is the amount of dissonance (extensions, clusters) matched to the intensity?
- Do mediant moves keep the common tone in the same track?
- Do the bass notes stay roots or pedals (no muddy extensions below MIDI 45)?

## Examples
- HTTYD flying theme: diatonic vi–IV–V–I (Bm–G–A–D) = positive and human. Its gallop uses non-diatonic
  mediant triads over a D pedal = grandeur and adventure. Its stall uses chromatic brass clusters over a
  bVI pedal = suspense.
