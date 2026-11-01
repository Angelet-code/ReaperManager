---
id: film-scoring.harmonic-rhythm-scene-dialogue
title: Harmonic rhythm vs scene and dialogue
aliases: [ritmo armónico, música bajo diálogo, música de fondo bajo diálogo, cambios de acorde, sincronía con la imagen, pedal armónico]
domain: film-scoring
tags: [harmonic-rhythm, dialogue, scene, cue-design, pedal]
style_scope: film
use_when: Deciding how often chords change in a cue, especially under dialogue, or how to raise emotion at a peak without dialogue.
summary: Fast chord changes heighten emotion and draw attention, so use them at emotional peaks without dialogue. Slow changes support the scene without getting in its way, so use them under dialogue, changing orchestration instead of harmony. Under dialogue, keep the speech band clear and place harmonic changes in the pauses.
sources: ["film-4day-challenge slides 2-3", "httyd-test-drive p.1-15"]
related: ["[[harmonic-storytelling-chord-functions]]", "[[harmony-emotion-mapping]]", "[[five-elements-arrangement-checklist]]", "[[reverb-strategy-orchestral]]"]
---

# Harmonic rhythm vs scene and dialogue

## Core idea
Harmonic rhythm (how often the chord changes) is an intensity control. **Fast changes enhance the
emotion. Slow changes support** it (and can still enhance it) without competing with the scene or
the voices. Under dialogue the music should be felt, not followed.

## Rules
- R1 `PREFER` Under dialogue: slow harmonic rhythm, about 1 chord per 2–4 bars or a held chord or pedal.
- R2 `PREFER` At an emotional peak without dialogue: faster harmonic rhythm, 1–2 chords per bar.
- R3 `PREFER` Under dialogue, change texture, timbre or register instead of harmony to follow the
  scene's turns.
- R4 `PREFER` (film practice) Keep pedals in the bass while the upper harmony moves. That gives motion
  with a stable floor (HTTYD: tonic pedal under moving triads).
- R5 `AVOID` (general knowledge) Under dialogue, avoid melodic activity and bright, dense writing in the
  speech band (about MIDI 50–76, roughly 150 Hz–700 Hz fundamentals, plus presence 2–4 kHz). Favour
  low pads, high thin strings, or sparse figures.
- R6 `PREFER` (general knowledge) Place chord changes and new entrances in pauses between lines, or on
  picture cuts, not under the middle of a spoken sentence.

## Apply in MIDI / REAPER
**Harmonic-rhythm presets** (4/4):
| Scene state | Chords per bar | Typical tempo | Texture |
|---|---|---|---|
| Dialogue, intimate | 1 per 4 bars, or a pedal | 60–80 | strings con sordino pad CC1 25–40, maybe a solo instrument in a gap |
| Dialogue, tense | 1 per 2–4 bars over a pedal | 80–100 | low pulse (pizz or soft timpani), high harmonics |
| Transition / montage | 1 per bar | 90–120 | ostinato + melody |
| Emotional peak, no dialogue | 1–2 per bar | any | full melody, countermelody, crescendo layers |
| Action | pedal + 1 chord per bar or per 2 bars above it | 110–150 | motor rhythm, brass chords (see [[action-ostinato-pedal-gallop]]) |

- **Dialogue map:** if the user gives dialogue timings (seconds or bars), create markers `DLG start` and
  `DLG end`. Inside DLG spans:
  - No new melodic entrances.
  - Keep CC1 ≤ 45 on everything in 50–76.
  - Allow chord changes only at gaps of ≥ 1 beat between lines.
- **Ducking by orchestration first:** move pads out of 50–76 (violins up to 76–88 as harmonics or
  sul tasto, low strings down to 36–50). Use mix ducking (−3 to −6 dB) only after that.
- **Peak acceleration:** to intensify a peak, double the harmonic rhythm for the last 2–4 bars before the
  arrival (1 chord per bar → 2 per bar), then land on the arrival chord at the downbeat
  (see [[building-and-releasing-climaxes]]).
- **Static harmony, moving story:** when one chord is held for 8+ bars, schedule one orchestration change
  every 2–4 bars (new layer, register shift, articulation change).

## Checklist
- Do the DLG spans have slow harmonic rhythm (≤ 1 change per 2 bars) and no melodic entrances?
- Is the speech band (50–76) kept quiet (CC1 ≤ 45) under dialogue?
- Do chord changes under dialogue fall in pauses or on cuts?
- Does harmonic rhythm speed up toward emotional peaks without dialogue?
- When harmony is static, does the orchestration change every 2–4 bars?

## Examples
- HTTYD (no dialogue, flight action): 10-bar D5 pedal intro, then a 1-chord-per-2-beats loop
  (Bm–G | A–D) in the theme. At the climax the triads move over a fixed pedal, which gives speed without
  losing the floor.
