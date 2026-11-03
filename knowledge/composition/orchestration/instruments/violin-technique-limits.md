---
id: orchestration.violin-technique-limits
title: Violin positions, leaps, chords and harmonics (playability checks)
aliases: [posiciones del violín, primera posición, tercera posición, media posición, cambio de posición, digitación, extensión del cuarto dedo, saltos, saltos amplios, pasajes cromáticos, dobles cuerdas, acordes del violín, arpegios, armónico de cuarta, armónicos naturales, armónicos artificiales, nota rozada, glissando, Lage, Lagenwechsel, Doppelgriffe, Flageolett]
domain: orchestration
tags: [strings, violin, playability, fingering, leaps, double-stops, harmonics, validator]
style_scope: universal
use_when: Checking whether a generated violin line, leap, chord, arpeggio, glissando or harmonic is playable (section or solo) before writing it to MIDI.
summary: Judge difficulty by strings and shifts, not interval size; first position (55–83) is the safest zone. A slurred leap needs its two notes on the same or adjacent strings. Chords use adjacent strings, ≤ P8 between neighbours in one position, open strings help, and 3–4-note chords roll bottom-up with only the top 1–2 held. Touch-a-4th harmonics sound +24; natural harmonics stop at the 5th partial.
sources: ["adler-orq-es p.52-65", "piston-orch p.31, 37-60"]
related: ["[[violin]]", "[[string-techniques-stops-and-divisi]]", "[[string-techniques]]", "[[viola-technique-limits]]", "[[_instruments]]"]
---

# Violin positions, leaps, chords and harmonics

## Core idea
Each string covers about a 12th in the normal positions; the left hand shifts along it, the bow crosses
strings. A note is easy when it fits the current hand position and string, hard when it forces a big
shift, a skipped string or an extreme position. Leave fingering to the player; this note only rejects
what cannot work.

| String (open) | 1st pos | 3rd pos | 7th pos (computed) |
|---|---|---|---|
| G (55) | 55–62 | 60–65 | 67–72 (74 ext.) |
| D (62) | 62–69 | 67–72 | 74–79 (81) |
| A (69) | 69–76 | 74–79 | 81–86 (88) |
| E (76) | 76–83 | 81–86 | 88–93 (95); fingerboard end ≈ 100 |

Positions from Piston (Fig. 16, 20); the 7th-position row is computed (1st finger an octave above the
open string). Positions above the 7th exist mainly on the E string.

## Rules
- R1 `PREFER` first position (55–83) for fast or exposed passagework: most secure (Piston).
- R2 `AVOID` very high notes on the lower strings: harder to produce (Piston).
- R3 `ALLOWED` shifts; the commonest is a third (1st→3rd, 3rd→5th position). The slide may be heard and
  is idiomatic in expressive playing (Piston).
- R4 `PREFER` for fast chromatic runs a separate finger per semitone: clean (Adler, Piston). Slow slurred
  chromatic lines reuse a finger and carry a slight portamento; détaché removes it.
- R5 `MUST` judge a leap by the strings and the shift, not the interval: a 10th on one string can need
  1st→7th position, while two octaves across strings may need almost none (Piston).
- R6 `MUST` a slurred leap lies on the same or adjacent strings; the bow cannot skip a string legato
  (Piston). A soloist can fake it with a lighter bow; listeners still notice.
- R7 `AVOID` for sections: wide leaps on one string, in extreme registers, or legato (Adler). Leaps
  low → high sound exciting.
- R8 `MUST` a double stop = two adjacent strings; one finger can stop a P5 across two strings, never three
  or four (Piston).
- R9 `MUST` 3–4-note chords break: the lower notes are grace notes just before the beat, the top 1–2 are
  held (Adler, Piston). Three notes sound together only short and loud.
- R10 `PREFER` simple finger patterns, higher fingers on higher strings, and open strings in chords; a
  stopped note in unison with an open string is very resonant, above all in tremolo (Piston).
- R11 `PREFER` arpeggios across strings built from one chord shape (one position), slurred or bounced
  (Piston: *Walküre*, *Capriccio espagnol*).
- R12 `ALLOWED` 4th-finger extension: in 1st position up to an aug. 4th–P5 (6–7 st) above the 1st finger;
  half position for awkward low chromatic groups (Piston).
- R13 `MUST` a true glissando stays on one string (≈ open + 19 st). Wider sweeps become a fast chromatic
  run or partial slides; no portamento down from a note too high for the string (Piston).
- R14 `PREFER` artificial harmonics touching a P4 above the stopped note: sounds +24. `AVOID` in
  orchestra the touch-P5 (+19), M3 (+28) and m3 (+31) types: weak, solo only (Adler).
- R15 `PREFER` natural harmonics up to the 5th partial: B5 (83) on G, F#6 (90) on D, C#7 (97) on A, G#7
  (104) on E (Piston). The octave harmonic works as a plain melodic note.
- R16 `AVOID` fast harmonic melodies: each note needs a shift (Piston). Slow lines, held pedals and soft
  muted divisi chords are the idiom.

## Apply in MIDI / REAPER
- **String map** (inferred from the table): note n can sit on string s if open_s ≤ n ≤ open_s + 19 (E
  string up to 100). Strings in order G D A E.
- **Legato-leap check:** for consecutive slurred (overlapping) notes, require some pair of candidate
  strings at most one apart. 55 → 88 fails (G only vs A/E): end the overlap (gap ≥ 30 ms, a new bow) or
  move a note an octave. Section leaps > 19 st: flag (Adler, inferred threshold).
- **Chord check on one track:** ≤ 4 notes on consecutive strings, lowest ≥ 55; neighbours ≤ 12 st apart
  unless the lower one is open (55/62/69/76); no three stopped notes stacked in P5s. Otherwise use divisi
  tracks ([[string-techniques-stops-and-divisi]]).
- **Roll:** chords of 3–4 notes: lower note-ons 20–40 ms early, bottom first, short; top 1–2 notes held.
  For a tutti staccato hit matching the winds, keep them nearly simultaneous (Beethoven *Eroica*).
- **Harmonics patch:** write the sounding pitch; check that sounding − 24 is a playable stopped note.
- **Gliss:** a gliss articulation or pitch bend only within one string's span.

## Checklist
- [ ] Fast exposed passages mostly in 55–83.
- [ ] Every slurred leap passes the string map; section leaps > 19 st flagged.
- [ ] Chords: adjacent strings, ≤ 4 notes, rolled when 3–4 unless a short tutti hit.
- [ ] Harmonics: touch-4th only in sections; natural ones ≤ 5th partial; slow.
- [ ] Glissandi within one string.

## Examples
- Playable quadruple stop: G3–D4–B4–G5 (55 62 71 79), two open strings.
- Leap to rewrite: slurred C4 → A6 (60 → 93) needs G → E string; bow it separately. Brahms 3 uses this
  leap at f (1st → 7th position, Piston).
