---
id: performance.library-translation-table
title: Library translation table (what each controller means in our libraries)
aliases: [tabla de traducción, mapa de CC por librería, qué hace la velocity, adaptar a cada instrumento, Albion CC, SWAM CC, Symphony Series, Darwin]
domain: performance
tags: [cc-map, velocity, legato, albion, swam, percussion, calibration]
style_scope: the user's libraries (Albion ONE, SWAM, Symphony Series, Darwin Percussion Ensemble)
use_when: Before turning a performance idea (phrase shape, dynamics, slur, timing) into MIDI for one of the user's libraries, or when transferring numbers measured on another library.
summary: "Separate the player (phrase shape relative to its peak, timing, breaths: transferable) from the library (which CC, its dB response, what velocity means, legato delay: not transferable). This table gives each of our libraries' translation and marks every fact as measured, documented or assumed."
sources: ["reference-midi-batch1", "SWAM Solo Woodwinds v3.8.0 user manual", "Spitfire CC table (support.spitfireaudio.com)", "project measurements Nov 2026 (AGENTS.md, Claude memory)"]
related: ["[[_performance]]", "[[user-taste]]", "[[modeled-instruments-swam]]", "[[legato-overlap-and-attack-offsets]]", "[[cc-expression-phrase-shapes]]"]
---

# Library translation table

## Two layers
- **Player** (transferable): the phrase shape **as a share of its peak**, where the peak falls, the lead
  and rise in ms, breaths and phrase length, timing spread, and vibrato delay as a share of the note.
- **Library** (not transferable): which CC carries the phrase, the CC's response in dB and timbre, what
  velocity means, how legato is triggered and how late it sounds, and the absolute CC level.

`scripts/analyze-reference-midi.mjs` reports the two layers in separate tables.

## How to transfer a measured number
1. Take the player value from the reference: normalized shape, ms, or share of note.
2. Find the target library below.
3. Map the shape onto **that library's carrier CC**, at **that library's level scale**.
4. Check the result by measuring a render, never by reading the CC numbers.

## Our libraries

Status key: **M** = measured in this project, **D** = documented (manual or vendor), **A** = assumed;
calibrate before relying on it.

| Library / patch type | Carries the phrase | Dynamics / timbre | Vibrato | Velocity means | Legato | Attack / delay | Level notes |
|---|---|---|---|---|---|---|---|
| **Albion ONE longs** (Strings Long, Low XL 8ves Long, Brass Low Long, Trumpets XL Long, Long Tremolo) | CC1 shape + CC11 phrase breath (D) | CC1 crossfades layers, timbre and level (D) | CC21 (D) | Little effect on longs (A) | — | **Strings Long: onset 25–40 ms; −6 dB at 135–165 ms after note-on**, slightly slower at CC1 40 (M) | **CC1 response (Strings Long, CC11 127)**: 10 → −38 dB, 25 → −26, 40 → −18, 55 → −12, 70 → −9, 85 → −4, 100–127 ≈ 0 (M). **CC11 response (CC1 80)**: 10 → −22 dB, 25 → −14, 40 → −8, 70 → −4, 85–100 → −3, 115–127 ≈ 0 (M, ±1.5 dB bowing noise). From CC11 70 to 127 only about 4 dB |
| **Albion ONE legato** (Strings High Octave, Woods High, Brass Mid) | CC1 + CC11, as for longs (D) | CC1 (D) | CC21 (D) | **No effect**: from velocity 30 to 120 the transition and the level are identical (M). Our 112/96/78/58 map does nothing on Albion | Monophonic; overlap = slur (D) | **Legato transition after the new note-on, start / middle / done (M)**: Strings High Octave 160 / **225** / 595 ms; Woods High 70 / **150** / 460 ms; Brass Mid (horns) 55 / **90** / 340 ms. **First note −6 dB (M)**: strings 185–225 ms, woods 90–150, horns 105–190 (round robins) | Validated set ([[user-taste]] R17): CC1 × 0.78 + 6, CC11 + 8, phrases with breaths |
| **Albion ONE shorts** (Spiccato, Staccato Combo, Pizzicato, Woods/Trumpets/Brass Short) | Velocity per note follows the phrase curve (D) | Velocity (D); CC11 smooths hairpins between notes (project practice) | — | **Dynamics: velocity → peak (Spiccato, M)**: 20 → −41 dB, 40 → −28, 60 → −20, 80 → −11, 100 → −12, 120–127 → −2 (about 0.4 dB per velocity step). CC1 40 against 100 changes ≤ 3 dB (M) | — | Spiccato onset 5–20 ms; peak 50–195 ms after note-on (M) | Release CC17 per section (D) |
| **SWAM winds** (Flute, Oboe, English Horn, Clarinet, Bassoon, French Horn F) | **CC11**, required: no sound without it (D) | CC11 = air pressure | CC1 depth (D); delayed vibrato at 25–35 % of the note (M on SM) | Slurred (overlap) = portamento time: high = short (D). **With Flute 3 at default settings, velocity 60–120 barely changes it: the transition reaches its middle at 50–65 ms (M)**. Check `Portamento Control` and `Max Time` in each instance. Attacked = attack hardness (D) | Overlap = slur (D); 28–50 ms validated (R17) | Lead CC11 by 120–150 ms (R17). Flute 3 at CC11 80: −6 dB 60 ms after note-on (M) | **CC11 response (Flute 3, CC1 0, M)**: 20 → −18 dB, 35 → −10, 50 → −7, 65 → −4.4, 80 → −2.6, **95–127 ≈ 0**. Above 95 the level stops rising (only timbre), which matches the manual's red warning; between 50 and 95 about 7 points per dB. 10–15 dB hotter than Albion; Main Volume about −4.8 dB (M). Red warning above CC11 ≈ 95 (D). Horn portamento up to 2.4 s, so velocity ≥ 100 (M) |
| **SWAM strings** (Violin, Cello) | **CC11** = bow pressure and speed (D) | CC11 | CC1 depth; starts with some vibrato (M on SM strings) | As for winds; slurred = portamento (A for strings, consistent with the validated set) | Overlap = same bow; a 9–12 point CC11 dip marks a bow change (project) | Lead 120 ms (R17) | As for winds. Cello loads with Transpose −12 (M) |
| **Symphony Series Timpani** | Velocity per hit; CC1 on roll dynamics (M) | Velocity | — | Dynamics (A for exact layers) | — | Keyswitches: 36 hits, 38 tremolo roll (CC1), 40 crescendo, 41 flam; hit keys 48–71 sound an octave lower (M) | — |
| **Symphony Series Cymbal 1** | Velocity; CC1 on rolls (M) | Velocity layers on keys 60–65 (M) | — | Dynamics (M for 60–65) | — | Keyswitches: 36 hard / 38 soft mallets; 48/50 long hit, 52/53 short choke, 55 roll (CC1), 57 recorded crescendo (M) | — |
| **Darwin Percussion Ensemble** | Velocity (D) | Velocity | — | Dynamics (D) | — | Zones: Sub 24–36, Low 40–52, Mid 57–67, High 71–81, High sticks 84–95, Metal 96–107 (M) | No timpani in the patch (M) |

Reference libraries (batch 1), for reading their numbers:
- **CSS/CSW**:
  - CC1 = dynamics; CC58 = articulation;
  - velocity on a slur = legato speed (100/250/333 ms, D);
  - early starts are compensated with track delay.
- **Sample Modeling**: CC11 = expression, CC1 = vibrato depth, CC19 = vibrato rate. This is the same
  scheme as SWAM, but the trumpet demos sit at a CC11 median of about 90.

## Rules
- R1 `MUST` Transfer **player** numbers (normalized shape, ms, share of the note) between libraries.
  Never transfer **absolute CC levels or velocity values** between libraries.
- R2 `MUST` Treat any **A** entry as a hypothesis. Measure it with a render before building a default on
  it.
- R3 `PREFER` When a value is library-specific and unmeasured, take the documented or project value and
  A/B it by ear ([[user-taste]] R15, R17).

## Calibration (2026-11-02, measured with renders)
Set-up:
- a separate one-track project (`A:/CERBATANA/Ableton/calibracion-librerias/`), one patch at a time,
  at 120 BPM, with no reverb;
- the analysis frames are 5 ms, and the transition is measured as the energy share of the new pitch;
- results and scripts are in `resultados/`.

What it changes for generators. These are proposals; none has been A/B-tested yet:
- **Albion legato needs a much larger early start than our 50 ms**, and it depends on the patch:
  - about 200 ms for strings, 130 ms for woods, 80 ms for horns, to put the middle of the transition on
    the beat;
  - better still, a negative track delay per patch, as CSS users do.
- **Albion slur velocity is ignored.** Spend the effort on CC1 and the overlap instead.
- **Albion longs** reach −6 dB about 140 ms after the note-on, so an early start of about 80–120 ms is
  more realistic than 25 ms.
- **SWAM CC11 above 95 adds no level.** Keep phrases below that and let the curve shape carry the
  expression.
- **Our SWAM slur-velocity map (R17) may do little** unless the instances use Portamento Control =
  Velocity with a longer Max Time. Check `fx_params` before relying on it.

**In-context check (La Forja bars 52–64, ♩76 3/4, 2026-11-02).** Arrival of each Albion entry against
its beat, measured on rendered stems; median (p10–p90):
| Track | B (50/25 ms early) | B + EXPR_ALB_T |
|---|---|---|
| String legato, slurred (n = 25) | +105 ms late (−100…214) | **−55 ms early** (−248…39) |
| String legato, attacked (n = 3) | +141 ms | +1 ms |
| Woods legato, slurred / attacked (n = 9 / 2) | +117 / +246 ms | **+26 / +26 ms** |
| Horn legato, slurred / attacked (n = 5 / 2) | +165 / +39 ms | +131 / −46 ms |

What this shows:
- In context, the transition delays are **not** the isolated calibration values:
  - strings are about 155 ms, not 225;
  - horns are about 210 ms, not 90.
  - Tempo, interval and register matter.
- Values that would centre each track on the beat (hypothesis; n is small for woods and horns):

  | Track | Slurred | Attacked |
  |---|---|---|
  | String legato | ~145–155 ms | ~150 ms |
  | Woods legato | ~160 ms | ~115 ms |
  | Horn legato | ~210 ms | ~65 ms |

- **Round 2 confirms it.** `EXPR_ALB_T=2` (strings 150/150, woods 160/115, horns 210/65 ms) measured **−8 / +11**
  (strings), **+2 / +54** (woods) and **+5 / −6** (horns) ms against the beat. The string slur into the 64:1 tutti now
  lands with the timpani and cymbal (+29 ms against +31 and +42).
- The longs chords (Strings Long, Low XL) can't be measured with this pitch-band method, because the
  chord tones overlap.

Still not measured:
- Symphony Series and Darwin velocity → dB;
- the low XL strings and brass longs;
- the other SWAM instruments.
