---
id: source.reference-midi-batch2
title: "Reference MIDI, batch 2 (full mock-ups and MID-FiLD)"
source_ids: [reference-midi-batch2]
domain: meta
tags: [source, midi, tutti, balance, measured]
summary: "Full orchestral mock-ups downloaded on 2026-11-02 for study only: Bernard Duc (Mahler Adagietto, LOTR \"White Tree\" + its REAPER project), Ilya Zhuravlev (Star Wars Main Title, CSS family), Ashton Gleckman (The Village), Tuomo Tanila (Zimmer \"Time\"), plus the MID-FiLD dataset (MIT). Analysed per track with --tracks; the vault keeps only aggregates."
---

# Reference MIDI, batch 2

## What it is
| file | author | libraries | size |
|---|---|---|---|
| Mahler 5, Adagietto `.MID` | Bernard Duc | CSS strings, solo violin, VSL harp | 373 KB |
| LOTR "The White Tree" `.MID` + `.RPP` | Bernard Duc | VSL woods, Spitfire Symphonic Brass, CSS + SSS strings, Spitfire percussion | 370 KB + 4.6 MB |
| Star Wars Main Title `.mid` | Ilya Zhuravlev | CSS, CSSS, CSB, CSW, HZ and Spitfire percussion | 204 KB |
| The Village `.mid` | Ashton Gleckman | Spitfire (HZ Strings, Albion ONE, Iceni), solo violin; many tracks keep a default name | 182 KB |
| Time `.mid` | Tuomo Tanila | mixed: VSL, other strings, synths | 299 KB |
| Reo SWAM performances (violin, cello, flute; 4 MIDI, piano excluded) | Reo (@ReoMusicCH), downloaded by the swam-performance session | SWAM played live (Osmose, Nektar) | 176 KB |
| MID-FiLD dataset (4422 phrases + metadata) | POZAlabs (AAAI 2024) | not stated; CC1 = dynamics | 5.4 MB |

## Licence and use
- The community mock-ups state no licence. They are shared for study.
- MID-FiLD is MIT.
- Reo states "free to arrange or use as material".
- **Rule:** use them only to measure. They stay in `reference-midi/` (git-ignored). Never copy their notes
  or curves into our music.
- The `.RPP` is read **as text** with a script. It is never opened in REAPER.

## Reliability
- Track names map to libraries reliably in Star Wars (prefixed `[css]`, `[csb]`…) and Duc (`VSL`,
  `SSB`, `CSS`). The Village has generic names.
- CC1 is the dynamics layer in the Spitfire and CSS families. The VSL tracks in Duc also use CC1 (his
  Reaticulate set-up). Read absolute values per library.
- MID-FiLD's role tags come with the dataset. Its CC values are per phrase (`min_cc`, `max_cc`), with no
  library given.

## Notes that use it
[[tutti-balance-by-role]], [[library-translation-table]].
