---
id: performance.modeled-instruments-swam
title: Programming modelled soloists (SWAM, Sample Modeling)
aliases: [SWAM, Sample Modeling, instrumentos modelados, solista SWAM, portamento, vibrato SWAM, expresión SWAM]
domain: performance
tags: [swam, sample-modeling, midi-expression, vibrato, portamento, measured]
style_scope: physically modelled solo instruments
use_when: Writing or fixing MIDI for SWAM (Audio Modeling) or Sample Modeling solo instruments.
summary: "Modelled soloists need a continuous CC11 (breath or bow): without it there is no sound. CC1 is vibrato depth and velocity on an overlapping note sets the portamento time. Use the user-validated set in user-taste R17. Measured references put vibrato at 25–35 % into a long note, and SM strings sit at a CC11 median of 48–59."
sources: ["reference-midi-batch1", "SWAM Solo Woodwinds v3.8.0 user manual (Audio Modeling)"]
related: ["[[_performance]]", "[[user-taste]]", "[[cc-expression-phrase-shapes]]", "[[legato-overlap-and-attack-offsets]]"]
---

# Programming modelled soloists

## Core idea
A modelled instrument plays exactly what the controllers say.

- **CC11** is the air or bow pressure. It must move through every phrase, because the instrument is
  silent without it.
- **CC1** is vibrato depth; CC19 is vibrato rate in Sample Modeling.
- **Velocity** means two things. On an attacked note it sets attack hardness. On an overlapping
  (slurred) note it sets the portamento time: lower velocity gives a longer glide.

## Manual facts (SWAM Solo Woodwinds v3.8.0)
- With no Expression input the instrument doesn't sound. In the studio, draw an Expression curve. CC11 is
  the default.
- The Expression slider turns red if it stays **above 75 % (≈ CC 95)**. Most real playing lies between
  mp and mf. Monitor loud rather than overdriving the dynamics.
- Portamento by velocity reads "the note-on velocity of overlapping notes". A Portamento Max Time below
  0.15 means no portamento. Attack can follow velocity or the expression curve.
- With Note Off Velocity disabled, the note-off is fixed at 112. SWAM names MIDI 60 "C3"; the number is
  the same.
- User-measured in the project: the SWAM French Horn's maximum portamento is 2.4 s. Bassoon, cello and
  horn load with Transpose −12, so check `fx_params` ([[user-taste]] R13).

## Measured (Sample Modeling MIDI, same controller scheme)
- **CC11 level** at the note centre:
  - SM strings: 48 (25–84);
  - REVEAL quartet: 59 (33–84);
  - SM trumpets: 90 (61–119).
  - The trumpet demos ignore the 75 % warning. The strings respect it.
- **Vibrato**:
  - on notes of 0.8 s or more, it reaches half depth at 26–36 % of the note (strings about 0.5 s, brass
    about 1 s);
  - strings start with some vibrato (about 45) and brass from 0.
- **Overlap and slur velocity**: see [[legato-overlap-and-attack-offsets]].

## Measured: SWAM played live (Reo, Osmose MPE keyboard and Nektar lever)
Compared with our validated set B. Measured with the analyzer; groups `reo-swam-strings` and
`reo-swam-flute`.
- **CC11 lead:** the curve starts 150–240 ms before the note-on. This confirms R17.
- **Rise:** CC11 reaches the note's level in **195–290 ms**. Ours takes about 1 s, because of the swell
  inside the note.
- **Phrase end: the opposite of the sampled references.**
  - Live SWAM players fade the last note **almost to silence**: the end sits at 4–17 % of the peak.
  - The fall covers 78–93 % of the note's maximum.
  - Ours falls about 40 %.
  - This may be a SWAM trait: the note-off ends the tone more abruptly than a sample release. It is a
    **candidate for the next A/B**, not a rule yet; R17 was validated as a set.
- **Overlap:** shorter than ours, 17–26 ms against our 36–39 ms.
- **Slur velocity:** 63–70, against our 83–88. Reo's portamento settings are unknown, so don't copy this.
- **Timing:**
  - the flute plays slightly late, +19 ms (−31…52);
  - the strings are centred (−23…14).
- **String vibrato:** carried by **pitch bend at 4.7–6.7 Hz** with a reduced bend range, not by CC1.
  See `docs/swam-performance-research.md` §3.3.

## Layers
- **Player**: phrase shape, breath points and vibrato timing (R1, R3, R4). These are shared with all winds and strings.
- **Library** (SWAM-specific): CC11 as the only sound source, velocity as portamento time, the 75 % warning, about 6 CC11 points per dB, and the Transpose quirks (R2, R5–R7). The row in [[library-translation-table]] keeps these up to date.

## Rules
- R1 `MUST` Draw **one continuous CC11 curve per phrase**:
  - no drop to the floor between slurred notes; valleys stay under about 7 points;
  - a 9–12 point dip at rearticulations and bow changes;
  - follow the shape in [[cc-expression-phrase-shapes]].
- R2 `MUST` Vibrato points of a note must **stop at the next note's start**. Otherwise REAPER sorts them
  after it and the vibrato drops to 0 and bounces. (This bug was found and fixed in La Forja on
  2026-11-02.)
- R3 `PREFER` In a slur, the vibrato **continues at about 30 % depth** and doesn't restart from 0. Only an
  attacked wind note starts without vibrato.
- R4 `PREFER` Delay vibrato on long notes to about **25–35 % of the note** `(measured)`. Strings vibrate
  earlier and deeper than winds and brass.
- R5 `PREFER` Use the validated slur velocity, phrase shape, timing and overlap of [[user-taste]] R17. It
  beats the raw measured values: the SM slur velocities (47–75 on long notes) would give glides too slow
  for SWAM.
- R6 `PREFER` Keep CC11 mostly **below about 95**. If a line needs more level, use the plugin's Main
  Volume as gain staging, not a hotter curve.
- R7 `MUST` Load SWAM instruments one per command with their windows closed. Place them in a room
  ([[user-taste]] R10 and R15).

## Checklist
- Does every phrase have a CC11 curve that leads its first note-on?
- Is the CC1 vibrato monotonic within each note, with no 0-bounce at slurs?
- Is the slur velocity varied and within the instrument's sensible portamento range?
