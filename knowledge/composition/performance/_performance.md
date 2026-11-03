---
id: performance._performance
title: Performance programming (map of content)
aliases: [interpretación MIDI, programación MIDI, suena a MIDI, más realista, curvas de expresión, humanizar, maqueta realista]
domain: performance
tags: [moc, midi-expression, mock-up]
style_scope: sample-library and modelled-instrument mock-ups
use_when: Turning notes into a believable performance (CC1/CC11/vibrato curves, legato overlaps, slur velocity, attack offsets, timing and velocity humanization), or when the user says it "suena a MIDI".
summary: Numbers measured from professional performance MIDI (Cinematic Studio, Sample Modeling) plus what the user validated by ear. Measured values are sourced defaults; anything in user-taste R17 overrides them. Measure, don't guess, and A/B by ear before changing a generator default.
sources: ["reference-midi-batch1", "reference-midi-batch2"]
related: ["[[user-taste]]", "[[validate-generated-midi]]", "[[dynamics-by-orchestration]]", "[[orchestral-mockup-template]]"]
---

# Performance programming

These notes answer **how** a note is played in MIDI, not which note to write. The numbers come from
professional performance MIDI. They were measured with `scripts/analyze-reference-midi.mjs` and are
reported as median (p10–p90). Source card: [[reference-midi-batch1]].

## Precedence
1. The user's request in the chat.
2. [[user-taste]] **R17**: the values validated by ear on 2026-11-02 for SWAM soloists and Albion
   sections.
3. The `(measured: …)` defaults in these notes. They are library-specific, so transfer shapes and
   proportions, and only transfer absolute values between instruments of the same family.
4. General knowledge.

## Player vs library
Every number below belongs to one of two layers:
- **Player**, which transfers between libraries: phrase shape as a share of its peak, timing, breaths,
  relative vibrato delay.
- **Library**, which does not transfer: the carrier CC, absolute CC level, what velocity means, and the
  legato delay.

Translate with [[library-translation-table]] before using a number on another library.

## Notes
| note | use_when | summary |
|---|---|---|
| [[tutti-balance-by-role]] | Setting relative dynamics of all parts in a tutti or a soloist over a bed | faders at 0 dB; melody moves most; inner voices lower; soloist far above a soft bed; CC11 as a static trim in sample libraries |
| [[library-translation-table]] | Mapping a performance idea onto Albion, SWAM, Symphony Series or Darwin | which CC carries the phrase, what velocity means, legato and attack delays, level notes; measured / documented / assumed |
| [[cc-expression-phrase-shapes]] | Drawing CC11/CC1 over a phrase | start high, lead the note-on, reach the target fast, peak early, fall short; typical levels per family |
| [[legato-overlap-and-attack-offsets]] | Overlaps, slur velocity, early starts for slow attacks | overlap ~35 ms median (10–150); slur velocity by note length; CSS-type delays are library-specific |
| [[velocity-and-timing-humanization]] | Humanizing timing and velocity of any part | played-in spread is ±25–45 ms (p10–p90), velocity sd ~20–26 |
| [[modeled-instruments-swam]] | Programming SWAM or Sample Modeling soloists | CC11 = breath/bow, CC1 = vibrato, velocity on overlap = portamento; the manual's numbers and our validated set |
| [[guitar-ample-performance]] | MIDI for an Ample Sound guitar (classical L), or a guitar/tremolo that sounds mechanical or too strong | String Force before every note; legato = keyswitch + overlap on one string; soft velocity layer (<64); dynamics inside figures, per phrase and per pickup; tremolo open work |

## Code
The music engine `src/music` applies these notes (design `docs/music-engine.md`). Per-library numbers live in
`src/music/profiles/*.json`, marked M/D/A/R17 as in [[library-translation-table]]. A new library = a profile
plus `scripts/calibrate-instrument.mjs`; a new piece = `scripts/new-piece.mjs`.

## Workflow
1. Write the notes. Pick the articulation and patch: [[orchestral-mockup-template]].
2. Shape them with these notes: phrases, then transitions, then timing.
3. Check them:
   - run `node scripts/analyze-reference-midi.mjs --generator <out dir> --compare <refGroup>:<ourGroup>`;
   - look at metrics whose median falls outside the reference p10–p90.
4. Before changing a generator default, render A and B at matched loudness and let the user choose.
5. Record what the user chose in [[user-taste]].

## Gaps
- **Guitar tremolo** is still not realistic enough (user, 2026-11-02): see the Open work list in
  [[guitar-ample-performance]].
- No reference MIDI exists for Albion ONE. Its legato delay and CC1/CC11 response were measured from
  renders on 2026-11-02 ([[library-translation-table]]). The Albion low strings and brass longs are
  still unmeasured.
- Reference MIDI for brass sections, percussion and choir is still missing.
