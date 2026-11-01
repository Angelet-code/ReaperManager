---
id: orchestration.texture-unison-and-tutti
title: Orchestral unison and tutti
aliases: [unísono orquestal, tutti orquestal, tutti, todos, a2, a3, unísono de colores, octavas]
domain: orchestration
tags: [texture, unison, tutti, brass-support, register]
style_scope: universal (Beethoven to film)
use_when: A request says "unison", "all together", "tutti", "full orchestra", "épico todos juntos", or a climax needs the whole orchestra.
summary: A unison gives one line to several timbres to blend colours, at moderate dynamics. A tutti gives everyone different material, each instrument in its best register, spread over about four octaves. Strings and woodwinds carry the line in octaves while brass and timpani play broken harmonic punctuation instead of the tune.
sources: ["unir-orq-tema3 p.5-8", "httyd-test-drive p.5-8"]
related: ["[[texture-types]]", "[[doubling-colour-and-decay]]", "[[building-and-releasing-climaxes]]", "[[heroic-theme-orchestration]]", "[[dynamics-by-orchestration]]"]
---

# Orchestral unison and tutti

## Core idea
**Unison:** the same material on several different instruments. The aim is a mixed colour, not a
statement of power. **Tutti:** all instruments play, each in its best register, usually with
**different** material, to get the most sound from the whole ensemble.

## Rules
- R1 `PREFER` For a colour unison, use 2–4 timbres at unison or octave (e.g. flute + oboe + violins,
  clarinet + viola) at p–mf.
- R2 `PREFER` For a tutti, spread the orchestra over about **four octaves**, from the bass around D2
  (38) to the top around D6 (86), with each instrument in its best octave (Beethoven 9/I).
- R3 `PREFER` In a tutti the brass do **not** need the melody. Give them fragmented harmonic support:
  sustained chord tones or rhythmic punctuation on strong beats, with timpani.
- R4 `ALLOWED` A high flute or piccolo doubling the top line an octave up as an upper harmonic.
- R5 `ALLOWED` A woodwind changes the line it doubles when its range forces it (e.g. oboe drops from
  the melody to an inner voice above A6).
- R6 `ALLOWED` (film) A brass section in unison carrying the melody (12 horns a12 in HTTYD) is a power
  statement, not a colour unison. Then the strings take the motor or harmony, and trombones play close
  triads (see [[heroic-theme-orchestration]]).
- R7 `AVOID` Doubling every line in a tutti. One melody in octaves + one bass in octaves + harmony in
  the middle is enough. More layers blur the result.

## Apply in MIDI / REAPER
**Colour unison** (one line, 3 tracks, p–mf):
- `FL` takes the line at written pitch if it lies in 72–93, otherwise 12 semitones up.
- `OB` takes the same pitches when they lie in 62–86.
- `VLN I` takes the same pitches. Use a legato patch, CC1 45–65.
- Copy the **same notes** to all tracks (lengths identical), then humanize each track separately by
  ±5–10 ms so they don't phase.

**Tutti** (melody in D, four layers):
| Layer | Tracks | Register (MIDI) | Material | CC1 / vel |
|---|---|---|---|---|
| Melody, top octave | PICC/FL, VLN I | 74–93 | tune 8va | CC1 95–110 |
| Melody, main octave | OB, CL, VLN II, (HN a4) | 62–81 | tune | CC1 95–110 |
| Harmony / punctuation | TPT, HN, TBN, TIMP | 50–74 (brass), 38–55 (timp) | chord tones on beats 1 and 3, held or accented | shorts vel 100–115, longs CC1 90–105 |
| Bass in octaves | VC, CB, BSN, CBSN, TUBA | 26–50 | roots | CC1 100–110 |

- Check the spread: the top melody note minus the lowest bass note should be about 42–50 semitones
  (3½–4 octaves).
- Brass punctuation: short repeated chords or two-beat holds, never the whole tune unless R6 applies.
- Percussion: cymbal and timpani on the arrival downbeat only (see [[film-percussion-phrase-marking]]).

## Checklist
- Unison: are all tracks playing identical rhythm, with a dynamic of mf or less?
- Tutti: is the span from the lowest to the highest note at least about 40 semitones?
- Is every instrument within its best register (see [[_instruments]])?
- Do the brass support the harmony rather than double the strings' melody (unless R6 is intended)?
- Are there at most four simultaneous layers?

## Examples
- Beethoven 9/I tutti: strings and woodwinds play the line in octaves; horns, trumpets and timpani play
  detached harmonic hits.
- HTTYD b.32: theme in flutes + horns 1–6 + Vln I/II (octaves) + both cello sections in treble clef,
  over a D pedal in the basses and low winds. Violas play 16th motor, clarinets play a gallop figure.
