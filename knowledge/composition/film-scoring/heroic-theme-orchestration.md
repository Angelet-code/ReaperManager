---
id: film-scoring.heroic-theme-orchestration
title: Orchestrating a film theme across its statements
aliases: [tema heroico, tema principal, leitmotiv, melodía de trompas, trompas al unísono, tema folk, reexposición del tema, variación orquestal del tema]
domain: film-scoring
tags: [theme, melody, horns, doubling, re-orchestration, folk]
style_scope: film (adventure/heroic scoring, John Powell-style)
use_when: Giving a main theme its first statement, a heroic or folk colour, or a new orchestration each time it returns.
summary: "State a heroic tune in all the horns in unison, doubled by Vln II, with trombones on close triads and tuba/basses on half-note roots. A folk tune goes to a solo colour instrument (whistle, flute) doubled plainly by oboes and high celli at the same pitch. Every return gets a new scoring: solo → tutti in octaves over a pedal; horns → oboes and trumpet triads with the violins turned into a 16th motor."
sources: ["httyd-test-drive p.3-8, p.12-15"]
related: ["[[httyd-test-drive-case-study]]", "[[texture-unison-and-tutti]]", "[[doubling-colour-and-decay]]", "[[texture-accompanied-melody]]", "[[building-and-releasing-climaxes]]"]
---

# Orchestrating a film theme across its statements

## Core idea
In HTTYD each theme is always stated as a **multi-family unison**, and it never returns in the same
clothes. The first statement is clear and narrow (one colour, mid register). Later statements spread it
over octaves and families, while the old melody instruments become the motor or the harmony.

## Rules
- R1 `PREFER` Heroic or flying tune: all horns in unison (or in two octaves), doubled at unison by
  Vln II; trombones in close-position triads (tenor register); tuba, bassoons, Vc 2 and basses on
  half-note roots; harp 16th broken chords underneath; no drums. The tune carries itself.
- R2 `PREFER` Folk tune in the mid register (about F#4–B4, 66–71): the solo colour instrument plays the
  ornaments; oboes a3, bassoons (high tenor) and celli (treble register) double at the **same pitch**
  without ornaments.
- R3 `PREFER` Climax restatement: move the earlier solo theme to flutes + horns + violins (octaves) +
  high celli, over a tonic pedal in the basses and low winds.
- R4 `PREFER` When the melody moves to the brass, turn the violins into a unison 16th broken-chord motor
  (a 2-beat cell) instead of doubling the tune.
- R5 `ALLOWED` Harmonise a brass tune in trumpet triads (close position) once its unison statement has
  been heard.
- R6 `PREFER` For the final statement, reuse the same chord loop (vi–IV–V–I) up a whole step, only
  when the user has not fixed the key.
- R7 `PREFER` During the solo folk statement, remove the sparkle layer (celesta, harp ostinato) so the
  colour reads.
- R8 `PREFER` Put woodwind fill runs on beats 3–4 when the tune holds a long note on beats 1–2.

## Apply in MIDI / REAPER
**Statement 1, heroic** (D major, q ≈ 111, loop Bm–G | A–D):
- `HN LEGATO` (a6–a12 patch): tune around 57–69 (A3–A4). CC1 85–95 (f), a swell of +10 into each
  phrase peak.
- `VLN II LEGATO`: the same notes, CC1 75.
- `LOW BRASS LONG` (trombones): close triads in 50–62, half notes, CC1 75.
- `TUBA`, `BSN`, `VC 2`, `CB`: half-note roots (B1 35 / G1 31 / A1 33 / D2 38 for tuba and Cb; +12 for
  Vc and bassoon).
- `HARP`: continuous 16th broken chords in 50–79, velocity 60–75.
- `FL`/`CL` 16th-sextuplet runs on beats 3–4 (builder beats 2–3) of bars where the tune holds.
- Percussion: a suspended cymbal on bar 1 only.

**Statement 2, folk colour** (HTTYD b.13):
- `WHISTLE`/`FL SOLO`: the tune with grace notes (`len` 0.08 grace notes just before the beat), CC1 85.
- `OB a3`, `BSN a2`, `VC` (treble register): the plain tune, same pitches, CC1 75.
- `VLN I/II`: high tremolo whole notes (A5 81, D5 74), CC1 50. `CB` D pedal re-attacked every 2 bars.
- Mute `CELESTA` and `HARP` ostinato tracks for this span.

**Statement 3, tutti climax** (HTTYD b.32):
- Tune on `FL` (+12), `HN 1-6` (same pitch), `VLN I` (+12), `VLN II` (same pitch) and `VC` treble (same pitch).
- `HN 7-12` play a lower harmony or the octave below.
- Tonic pedal in `CB`, `CBSN`, `BSN`, re-attacked.
- `VLA`: continuous 16th broken-chord figure. `CL`: a dotted gallop figure.
- Cymbals and timpani: ff on the downbeat. CC1 105–115.

**Statement 4, brass + motor, key lift** (HTTYD b.59, up a tone to E):
- Transpose the loop +2 (C#m–Amaj7–B–E).
- Tune on `OB a3` + `HN 1-6` + `TPT` triads (close, tune on top, 67–79) + `TBN`.
- `VLN I+II` in unison on a 16th turn figure: down a third, back up through the chord, a 2-beat cell at
  velocity 85–100.
- Tempo step to 117 (`tempo_changes`).

## Checklist
- Is every theme statement a multi-family unison with one leading colour?
- Do only the solo colour instruments carry ornaments?
- Does each return change the leading family and the register spread?
- When brass carry the tune, do the violins provide motor rather than doubling?
- Are the sparkle layers muted under the solo folk statement?
- Is the final statement transposed up (and the tempo stepped up) rather than literally repeated?
