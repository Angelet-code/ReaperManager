---
id: orchestration.orchestration-errors-checklist
title: Common orchestration errors (final checklist)
aliases: [errores de orquestación, errores instrumentales, errores discursivos, comprobaciones de conjunto, revisión de orquestación, lista de comprobación]
domain: orchestration
tags: [checklist, errors, lint, validation]
style_scope: universal
use_when: Validating any generated orchestral MIDI before handing it to the user, or diagnosing why a mock-up sounds unclear, thin or unbalanced.
summary: "Check two classes of error. Instrumental errors belong to one track: out of range, unplayable leaps or tremolos, extreme notes at the wrong dynamic, no breaths, octave doublings past a range. Discursive errors belong to the ensemble: cut lines, colour changes mid-phrase, a covered melody, forte arrivals with few instruments, unison doublings that cancel, repeats never recoloured, sections that never rest. Run every check vertically and horizontally; transcriptions and band work add the checks in the transcription note."
sources: ["unir-orq-tema2 p.7-10", "unir-orq-tema3 p.5-8, p.14-17", "film-4day-challenge slides 5-6", "apuntes-orq-sesion1 scan p.3-4", "adler-orq-es p.668-689", "adler-orq-es p.713-726", "adler-orq-es p.276-282"]
related: ["[[orchestration-errors-checklist-transcription]]", "[[orchestrate-from-piano-sketch]]", "[[dynamics-by-orchestration]]", "[[line-separation-and-fusion]]", "[[doubling-colour-and-decay]]", "[[validate-generated-midi]]", "[[_instruments]]"]
---

# Common orchestration errors (final checklist)

## Core idea
UNIR separates **instrumental errors** (an instrument asked to do something it can't, or does badly) from
**discursive errors** (lines and balance broken at ensemble level). Most "sounds like MIDI" or "muddy"
complaints come from the discursive ones. Transcriptions, band work and template layout add their own
checks: [[orchestration-errors-checklist-transcription]].

## Rules
- R1 `MUST` Run the instrumental checks on every track and the discursive checks on every section
  before delivering.
- R2 `MUST` Check vertically (each chord's sonority and spacing) and horizontally (each line).
- R3 `MUST` Compare the global sonority with the source sketch or brief.

## Instrumental errors (per track)
| # | Error | Automatic check |
|---|---|---|
| I1 | Note out of range | pitch outside the instrument note ([[_instruments]]) or `data/instruments.json` |
| I2 | Extreme note at the wrong dynamic | top 4 st of a wind/brass range with CC1 < 50; flute 60–63 with CC1 > 80; piccolo ≥ 96 in a p passage (write it 8vb) |
| I3 | Impossible leap or speed | leap > 12 st in < 1/8 beat for winds and brass; 16th runs on tuba, contrabassoon or low horn |
| I4 | No breathing | wind/brass phrase > 8 bars at q = 100 with no rest ≥ 1/2 beat |
| I5 | Bad tremolo or stops | woodwind tremolo wider than a P4 (5 st); unplayable string double stops ([[string-techniques]]) |
| I6 | Endurance | horn above 72 or trumpet above 79 for more than 4 bars without a rest |
| I7 | Wrong transposition | MIDI must be concert pitch; transposition only on exported parts ([[transposing-instruments]]) |
| I8 | Section size | stacked solo patches faking a section; exactly 2 double basses |
| I9 | Octave doubling out of range | a doubling track copied ±12 from a line with notes outside its own range; let the other instrument finish alone |

## Discursive errors (per section)
| # | Error | Automatic check |
|---|---|---|
| D1 | Cut or incomplete line | a phrase stops mid-motif with no other track continuing it within 1/2 beat |
| D2 | Colour change mid-phrase | melody or fugue subject changes track away from a phrase or fragment boundary (allowed only for a deliberate timbre melody) |
| D3 | Truncated phrase ending | last note of a phrase shortened or missing in the melody track |
| D4 | Forte arrival with few instruments | arrival marked f/ff with fewer tracks than the previous bar |
| D5 | Piano arrival with many instruments | arrival marked p/pp with more than about 5 tracks or brass at CC1 > 60 |
| D6 | Melody covered | filler/bass doubled across ≥ 3 octaves in the melody's band, or filler CC1 ≥ melody CC1 in the same register |
| D7 | Dynamics missing | a track with constant CC1 for more than 8 bars, or constant velocity in shorts |
| D8 | Crescendo by CC only | a crescendo or diminuendo span with no track entering or leaving |
| D9 | Horror vacui | every track active in every bar of a section |
| D10 | Over-doubling | more than 2 layers with more than 2 doublers each |
| D11 | Lines not separated | countermelody shares rhythm, register and colour with the melody ([[line-separation-and-fusion]]) |
| D12 | Muddy low end | intervals < 7 st or 3+ pitch classes below MIDI 45 in sustained chords |
| D13 | Sparkle buried | celesta or glockenspiel in ff tutti |
| D14 | Cancelling unison | a melody doubled at the same pitch by two strings of similar colour (Vln I + Vc); move one an octave |
| D15 | Repeat not recoloured | a theme's third statement has the same tracks as its earlier ones |
| D16 | No rest for a family | a family sounds in every bar for more than ~32 bars (inferred threshold) |
| D17 | Brass covers a rising crescendo | brass CC1 above the strings/woods melody in a dark-to-bright build, or piccolo entering before the peak |

## Apply in MIDI / REAPER
- Run `dump_midi` over the arrangement and evaluate the tables track by track and bar by bar. Report
  every hit as `bar.beat | track | code | fix`.
- **Fix order:** I1 → I9 (wrong notes first), then D1–D3 (line integrity), then D4–D8 and D17 (dynamics
  and density), then D9–D16 (colour and clarity), then the transcription checks.
- Put markers on every cadence, climax and theme statement so D4/D5/D15 can be checked.
- After fixes, render the cue and listen against the sketch (R3). The user judges by ear.

## Checklist
- Every note is in range and at a feasible dynamic, doublings included (I1, I2, I9).
- Every wind and brass line breathes (I4, I6).
- No line is cut, and every hand-off happens at a phrase boundary (D1–D3).
- The track count rises into forte arrivals and falls into piano ones (D4, D5, D8).
- The melody stands above its doublings and filler; no unison cancels it (D6, D14).
- Every track has dynamic shape (D7).
- Colour changes between statements; every family rests (D9, D10, D15, D16).
- The low end is clear (D12).
