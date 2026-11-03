---
id: source.reference-midi-batch1
title: "Reference performance MIDI, batch 1 (Cinematic Studio, Sample Modeling)"
source_ids: [reference-midi-batch1]
domain: meta
tags: [source, midi, performance, measured]
summary: Professional performance MIDI downloaded on 2026-11-02 for study only. It covers CSS/CSSS/CSW walkthroughs and Sample Modeling trumpet, trombone, strings and the REVEAL quartet. The files were measured with scripts/analyze-reference-midi.mjs; the vault keeps only aggregated numbers.
---

# Reference performance MIDI, batch 1

## What it is
24 MIDI files in 5 groups. Details are in `reference-midi/catalog.json`, which is git-ignored; the search
and the plan are in `docs/reference-midi-sources.md`.

| group | content | expression CC | phrases measured |
|---|---|---|---|
| `css-strings` | CSS legato intro, articulation walkthrough, CSSS intro (Alex Wallbank) | CC1 (dynamics) | 221 |
| `csw-woods` | CSW intro piece, legato walkthrough | CC1 | 199 |
| `sm-brass` | SM trumpet (8 files), trombone (2), French horn (Roemer) | CC11 (CC2 on the horn) | 88 |
| `sm-strings` | SM string demos by users: Vicentini, Mulawa, Kamps, Roemer's solo violin | CC11 | 23 |
| `sm-reveal` | SM Challenge 2022 quartet, MIDI paired with a real recording | CC2 (assumed) | 46 |

## Licence and use
- The CSS readmes say "educational purposes" and forbid rendering, selling or any commercial use without
  permission.
- The Sample Modeling files state no licence.
- **Rule:** use the files only to measure. Never commit the `.mid` files, never copy their notes or curves
  into our music, and keep only aggregated statistics in the vault.

## Reliability
- The numbers are medians with p10–p90 over a few hundred notes per group. Phrase counts are small for
  `sm-strings` (23) and `sm-reveal` (46).
- Each library has its own CC response. Transfer shapes and proportions; check levels on renders.
- The CC map of REVEAL is undocumented. CC2 was taken as expression because it is the densest lane.
- The analyzer splits phrases at silences of 0.3 s or more, and uses a grid of 16ths or 8th-note
  triplets for timing offsets.

## Notes that use it
[[_performance]], [[cc-expression-phrase-shapes]], [[legato-overlap-and-attack-offsets]],
[[velocity-and-timing-humanization]], [[modeled-instruments-swam]].
