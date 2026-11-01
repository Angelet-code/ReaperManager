---
id: orchestration.orchestration-errors-checklist
title: Common orchestration errors (final checklist)
aliases: [errores de orquestación, errores instrumentales, errores discursivos, comprobaciones de conjunto, revisión de orquestación, lista de comprobación]
domain: orchestration
tags: [checklist, errors, lint, validation]
style_scope: universal
use_when: Validating any generated orchestral MIDI before handing it to the user, or diagnosing why a mock-up sounds unclear, thin or unbalanced.
summary: "Check two classes of error. Instrumental errors belong to one track: out of range, unplayable leaps or tremolos, extreme notes at the wrong dynamic, no breaths. Discursive errors belong to the ensemble: cut lines, phrases split badly, a melody covered by doublings, forte arrivals with few instruments, piano arrivals with many. Run every check vertically (chords) and horizontally (lines)."
sources: ["unir-orq-tema2 p.7-10", "unir-orq-tema3 p.5-8, p.14-17", "film-4day-challenge slides 5-6", "apuntes-orq-sesion1 scan p.3-4"]
related: ["[[orchestrate-from-piano-sketch]]", "[[dynamics-by-orchestration]]", "[[line-separation-and-fusion]]", "[[doubling-colour-and-decay]]", "[[_instruments]]"]
---

# Common orchestration errors (final checklist)

## Core idea
UNIR separates **instrumental errors** (an instrument asked to do something it can't, or does badly) from
**discursive errors** (the music's lines and balance broken at ensemble level). Most "sounds like MIDI"
or "muddy" complaints come from the discursive ones.

## Rules
- R1 `MUST` Run the instrumental checks on every track and the discursive checks on every section
  before delivering.
- R2 `MUST` Check vertically (each chord's sonority and spacing) and horizontally (each instrument's line).
- R3 `MUST` Compare the global sonority with the source sketch or brief.

## Instrumental errors (per track)
| # | Error | Automatic check |
|---|---|---|
| I1 | Note out of range | pitch outside the range in the instrument note ([[_instruments]]) or `data/instruments.json` |
| I2 | Extreme note at the wrong dynamic | top 4 semitones of a wind/brass range with CC1 < 50; flute 60–63 with CC1 > 80 |
| I3 | Impossible leap or speed | leap > 12 semitones in < 1/8 beat for winds and brass; 16th runs on tuba, contrabassoon or low horn |
| I4 | No breathing | wind/brass phrase > 8 bars at q = 100 with no rest ≥ 1/2 beat |
| I5 | Bad tremolo or stops | woodwind tremolo wider than a P4 (5 st); string double stops that aren't playable (see [[string-techniques]]) |
| I6 | Endurance | horn above 72 or trumpet above 79 for more than 4 bars without a rest |
| I7 | Wrong transposition | MIDI must be concert pitch; written transposition only on exported parts ([[transposing-instruments]]) |
| I8 | Section size | stacked solo patches faking a section; exactly 2 double basses |

## Discursive errors (per section)
| # | Error | Automatic check |
|---|---|---|
| D1 | Cut or incomplete line | a phrase stops mid-motif with no other track continuing it within 1/2 beat |
| D2 | Badly split phrase | melody changes track at a point that is not a phrase or motif boundary |
| D3 | Truncated phrase ending | last note of a phrase shortened or missing in the melody track |
| D4 | Forte arrival with few instruments | arrival marked f/ff with fewer tracks than the previous bar |
| D5 | Piano arrival with many instruments | arrival marked p/pp with more than about 5 tracks or brass at CC1 > 60 |
| D6 | Melody covered | filler/bass doubled across ≥ 3 octaves in the melody's band, or filler CC1 ≥ melody CC1 in the same register |
| D7 | Dynamics missing | a track with constant CC1 for more than 8 bars, or constant velocity in shorts |
| D8 | Crescendo by CC only | a crescendo span with no new track entering |
| D9 | Horror vacui | every track active in every bar of a section |
| D10 | Over-doubling | more than 2 layers with more than 2 doublers each; no colour change across sections |
| D11 | Lines not separated | countermelody shares rhythm, register and colour with the melody ([[line-separation-and-fusion]]) |
| D12 | Muddy low end | intervals < 7 semitones or 3+ pitch classes below MIDI 45 in sustained chords |
| D13 | Sparkle buried | celesta or glockenspiel in ff tutti |

## Apply in MIDI / REAPER
- Run `dump_midi` for the arrangement's range and evaluate the tables track by track and bar by bar. Report
  every hit as `bar.beat | track | code | fix`.
- **Fix order:** I1 → I7 (wrong notes first), then D1–D3 (line integrity), then D4–D8 (dynamics and
  density), then D9–D13 (colour and clarity).
- Count dynamics per arrival from markers: put markers on every cadence and climax so D4/D5 can be checked.
- After fixes, render the cue and listen against the sketch (R3). The user judges by ear.

## Checklist
- Every note is in range and at a feasible dynamic (I1, I2).
- Every wind and brass line breathes (I4, I6).
- No line is cut, and every handoff happens at a phrase boundary (D1–D3).
- The track count rises into forte arrivals and falls into piano ones (D4, D5, D8).
- The melody is audible above its doublings and filler (D6).
- Every track has dynamic shape (D7).
- The colour changes between sections, and not everything plays all the time (D9, D10).
- The low end is clear (D12).
