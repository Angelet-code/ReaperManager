---
id: harmony.harmony-voicing-for-instruments
title: From four-part progression to idiomatic voicings (strings, brass, piano, pads, choir)
aliases: [voicing, disposición de acordes, distribución de voces, voicing orquestal, voicing de cuerdas, voicing de metales, voicing de piano, pad, colchón armónico, límite grave de intervalos, Lage, Akkordlage, Instrumentierung des Satzes]
domain: harmony
tags: [voicing, orchestration, strings, brass, piano, pads, spacing]
style_scope: universal (spacing and low-interval limits); doubling details lean common-practice and orchestral film
use_when: A chord progression (four-part or symbols) must become MIDI notes for a string section, brass, piano, synth/choir pad, with good spacing and doubling.
summary: Keep the four-part skeleton (good bass, smooth inner voices, melody on top) and then respace it for the instrument: wide intervals (octave/fifth) at the bottom, thirds and colour tones only above about C3 (MIDI 48), the melody alone on top. Double root and fifth for weight, never a leading tone or chordal seventh in exposed octaves; octave doublings of a line are not parallel errors.
sources: ["hindemith-1 p.1-3", "hindemith-1 p.53-59", "hindemith-1 p.117-125", "hindemith-2 p.18-22", "hindemith-2 p.34-41"]
related: ["[[four-part-voices-and-spacing]]", "[[doubling-rules]]", "[[voice-leading-basics]]", "[[voice-leading-parallels]]", "[[harmonic-texture-and-voice-count]]", "[[accompaniment-for-solo-line]]", "[[orchestra-sizes-and-section-balance]]", "[[_orchestration]]", "[[_film-scoring]]", "[[_harmony]]"]
---

# From four-part progression to idiomatic voicings

## Core idea
Hindemith's four-part logic (bass first, smooth inner voices, controlled doubling) is the skeleton; real
instruments need it respaced. Most of this note is **(general knowledge)** of orchestration practice; the
Hindemith-derived points are marked (H).

## Rules
- R1 `MUST` (H) Keep the skeleton: one bass line, smooth upper voices, melody on top; check the outer pair
  for parallels ([[voice-leading-parallels]]).
- R2 `MUST` (general knowledge) Spacing follows the harmonic series: octaves/fifths at the bottom, thirds
  and colour tones higher. Approximate lowest bottom note for a clear interval:

  | Interval | Lowest bottom note |
  |---|---|
  | m2 / M2 | ~E3 / Eb3 (52 / 51) |
  | m3 / M3 | ~C3 / Bb2 (48 / 46) |
  | P4 / tritone | ~A2 / B2 (45 / 47) |
  | P5 | ~Bb1 (34) |
  | 6ths, 7ths | ~F2 (41) |

- R3 `AVOID` (general knowledge) Close thirds below ~C3 (48) in any sustained part — mud.
- R4 `MUST` (H) Never double a leading tone or chordal seventh in exposed octaves; (general knowledge)
  `AVOID` doubling the major third in loud brass.
- R5 `ALLOWED` (H) Fill out or thin harmonies freely; octave doublings of the bass and melody add weight and
  are orchestration, not voice-leading parallels.
- R6 `MUST` (H) Accompanying voices stay below the melody and never double its chord seventh in the same
  octave; avoid unplanned 2nds/9ths against it.
- R7 `PREFER` (H) Crescendo by adding chord tones/doublings; thin texture at section starts.
- R8 `PREFER` (general knowledge) Hold common tones as tied notes on legato patches; re-attack only for
  rhythmic reasons.
  - *Outside this style:* rock/metal power chords (root–5th–8ve) and synth stabs move in parallel blocks;
    apply R2–R3 anyway (low thirds are mud in any genre).

## Apply in MIDI / REAPER
**String section (5 parts, sounding pitch; ranges = practical ranges in `data/instruments.json`):** Vln I =
soprano/melody (`violin` 55–88; sweet zone D4–E6, 62–88), Vln II = alto (`violin`), Va = tenor (`viola` 48–81),
Vc = bass (`cello` 36–76), Cb = bass an octave lower (`double_bass` 28–55). Pad spacing: Cb+Vc
octave or Vc root–fifth below C3; Va/Vln II with 3rd and 7th in C4–C5; Vln I top. More than 5 notes →
divisi (Vln I/II div., Va div.). CC1 = dynamics, CC11 = phrase shaping.

**Brass:** tuba/bass trombone root (`tuba` 31–60, `trombone_bass` 31–65; open, ≥ fifth apart); tenor
trombones (`trombone_tenor` 40–70) fifth/octave/third above ~Bb2; four horns (`horn` 41–74) close position
around F3–F4 (53–65), the warm pad zone; trumpets (`trumpet_bb` 55–79) close position on top (C4–C5+). Horns
blend, trumpets cut ([[orchestra-sizes-and-section-balance]]). Velocity = attack; CC1 crossfade for swells.

**Piano (`piano` practical 28–103):** LH root + octave or root + fifth/tenth from ~C2–C3, no LH thirds below C3; RH close triad or 7th
in C4–C5, melody on top. Broken-chord patterns instead of chorale blocks (H). Sustain CC64: release just after
each chord change and re-press (legato pedalling).

**Synth/choir pads:** root (C2–C3), fifth or octave above, then 3rd/7th/9th in C4–C5; total spread ~2–3
octaves; drop-2 (lower the second-highest note of a close voicing by an octave) gives a string-like open
voicing. Constant velocity; accents by more notes (H). Choir pads use SATB ranges from
[[four-part-voices-and-spacing]].

**Procedure:** (1) write the four-part progression; (2) assign S/A/T/B to instruments; (3) respace each chord
with R2 (move low thirds up an octave, widen the bass); (4) add octave doublings (bass 8vb, melody 8va) per
section fullness; (5) re-check outer-voice parallels, melody clashes, ranges per patch.

## Checklist
- No interval below its low limit; no close thirds under C3?
- Melody alone on top; pad below it?
- No doubled leading tone / seventh in exposed octaves?
- Every note inside the patch's playable range?

## Examples (C major I–vi–IV–V, strings)
- Cb C2–A1–F1–G1 (octave doubling of Vc); Vc C3–A2–F2–G2; Va C4–C4–C4–B3 (common tone held);
  Vln II G4–A4–A4–G4; Vln I E5–E5–F5–D5. Only roots/octaves below C3; all thirds above it.
