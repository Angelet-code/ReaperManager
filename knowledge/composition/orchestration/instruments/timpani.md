---
id: orchestration.timpani
title: Timpani
aliases: [timbales, timbal, Pauken, timpani, timbales de pedal, redoble, baquetas, timbales sinfónicos]
domain: orchestration
tags: [percussion, instrument, ranges, pitched-percussion]
style_scope: universal
use_when: Writing or checking a timpani part: choosing pitches/drums, rolls, retuning time, Classical vs modern use.
summary: Timpani sound as written, ≈ C2–C4 (36–60) across five drum sizes (30" 38–45, 28" 41–48, 25" 46–53, 23" 50–57, 21" 53–59); tune each drum mid-range. Classical style uses two drums on tonic and dominant tied to the trumpets; modern pedal timpani can change pitch but need time, and you can never have more simultaneous pitches than drums.
sources: ["unir-orq-tema7 p.5-8", "unir-orq-tema1 p.6-8"]
related: ["[[trumpet]]", "[[percussion-unpitched]]", "[[mallet-percussion]]", "[[_instruments]]"]
---

# Timpani

## Core idea
Copper bowls with a head, tuned by pedal (modern) or by hand (historic). Non-transposing, bass clef. The only
percussion present in orchestral scores of almost every period. Classical: **two drums, tonic + dominant**,
unchanged through the work; 19th c.: three; today 4 (up to 5), retuned within a movement.

| Drum | Range (MIDI) | Best (mid-range, inferred) |
|---|---|---|
| 30" | 38–45 (D2–A2) | 40–43 |
| 28" | 41–48 | 43–46 |
| 25" | 46–53 | 48–51 |
| 23" | 50–57 | 52–55 |
| 21" | 53–59 (60 optional) [top approx.] | 55–57 |

Full range **36–60**, practical **38–57**. C2–C#2 (36–37) lie below the 30" drum and need a 32" or larger drum
(not in every section; see `instruments.json` `timpani`).

## Rules
- R1 `PREFER` tuning each drum in the middle of its range (head neither slack nor over-tight) for the best tone.
- R2 `MUST` (Classical style) use only two pitches, tonic and dominant (e.g. D major: A2 45 + D3 50), fixed
  for the movement.
- R3 `MUST` (modern) have no more distinct pitches sounding in a passage than drums available (4 default),
  and leave time to re-pedal: ≈ 1–2 beats per retuning at moderate tempo, more for large intervals (general knowledge).
- R4 `PREFER` role since Classicism: reinforce the tutti, usually with the brass (trumpets + timpani on
  cadences).
- R5 `ALLOWED` exposed timpani alternating with the orchestra for big impact (Strauss *Zarathustra* C–G).
- R6 `ALLOWED` hard sticks = louder, clearer attacks; soft sticks = warmer, more resonant.
- R7 `MUST` write rolls as trill/tremolo and state measured vs unmeasured; a roll is the timpani's sustain.
- R8 `ALLOWED` damping: notated durations can be honoured by damping with the fingers; otherwise the drum rings.
- R9 `ALLOWED` agility (general knowledge): fast single strokes and rolls on one drum are easy; fast
  patterns across 2–3 adjacent drums fine; melodies need pre-tuned drums.

## Apply in MIDI / REAPER
- Track `Timp` at concert pitch. Choose the pitch set first (≤ 4), map each to a drum, check each sits in a
  drum's range (preferably its middle).
- Hits: velocity = dynamics (p ≈ 40–60, f ≈ 90–110, ff accent 115–127); hard/soft stick = different patches.
- Rolls: use the library roll patch with CC1 swells (cresc. roll into a tutti hit), or alternate notes at
  32nds with velocity jitter ±8 (inferred).
- Note length: if the library responds to note-off (choke), use length for damping; otherwise let ring.
- Pan: centre rear.

## Checklist
- [ ] All notes 36–60; mostly 38–57.
- [ ] ≤ 4 distinct pitches in any passage without a pause; retunings have ≥ 1–2 beats.
- [ ] Classical-style piece: only tonic and dominant pitches.
- [ ] Rolls are marked as rolls (roll patch or tremolo), not sustained single notes.
- [ ] Timpani mostly coincide with brass/tutti accents and cadences.

## Examples
- D major Classical: A2 (45) + D3 (50), with trumpets at cadences.
- Film ostinato: E2 (40), B2 (47), E3 (52) on 30"/25"/23" drums, f, hard sticks.
