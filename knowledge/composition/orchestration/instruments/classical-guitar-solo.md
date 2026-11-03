---
id: orchestration.classical-guitar-solo
title: Classical guitar — writing a playable solo part
aliases: [guitarra clásica, guitarra sola, obra para guitarra, digitación, digitación de guitarra, campanella, trémolo de guitarra, rasgueado, rasgueo, picado, ligados, hammer-on, pull-off, cejilla, armónicos naturales, armónicos octavados, posición, tablatura]
domain: orchestration
tags: [guitar, plucked, solo, fingering, instrument, idiom]
style_scope: classical and Spanish guitar repertoire
use_when: Writing, arranging or checking a solo classical-guitar part (or any guitar part whose fingering must be really playable), before generating MIDI for it.
summary: Write from the fretboard, not from the keyboard. Every note needs a string and fret; the left hand holds one shape per chord with at most four fingers (a barre counts as one), the melody owns the first string, accompaniment voices never take turns on one string, and notes are only released when the hand truly has to move. Give each movement a home theme that returns, a contrast and a prepared climax. Learned on "Fantasía de San Juan" (Nov 2026) with a guitarist's feedback.
sources: ["user and guitarist feedback, Fantasía de San Juan, 2026-11-02", "general knowledge"]
related: ["[[plucked-strings]]", "[[guitar-ample-performance]]", "[[user-taste]]", "[[phrase-structure]]", "[[thematic-development]]", "[[character-pieces]]", "[[_instruments]]"]
---

# Classical guitar — writing a playable solo part

## Core idea
Standard tuning E2 A2 D3 G3 B3 E4 (40 45 50 55 59 64), sounding an octave below the written part. A note
is only real once it has a **string and a fret**. Compose the pitches, then solve the fingering, then fix
the music wherever the fingering forces something ugly (a note released after 100 ms, a hand jump, a
voice crossing). The reference solver is `generator/lib/fretboard.mjs` in
`A:\CERBATANA\Ableton\2026-11-02 Fantasia San Juan` (beam search over string/fret choices).

## Rules
- R1 `MUST` Left hand: at most 4 fingers; a barre (index across strings at one fret) counts as one and
  stops every string under it, so no open string may ring inside a barre. Span 3 frets is comfortable, 4
  is a stretch, 5 only above fret 9. The 19th fret exists only under strings 1–2; keep basses ≤ fret 15.
- R2 `MUST` Right hand: at most 4 plucked strings at once (p i m a); more is a rasgueado or a rolled chord.
  Artificial harmonics take one finger pair, so at most one other note with them.
- R3 `MUST` **One shape per chord.** In arpeggios the hand holds the chord and only the melody moves on
  top; recomputing the inner voices under every melody note makes the hand jump every beat.
- R4 `MUST` The melody owns its string: no campanella or inner note on the melody's string, and no lower
  voice placed on a higher string than the melody.
- R5 `AVOID` Two accompaniment voices alternating on one string (a hand jump per eighth). Spread them over
  adjacent strings.
- R6 `NEVER` Release an accompaniment note right after its attack (it sounds as a ~100 ms click). A real
  player keeps the shape down; if the hand must leave, choose another note (an open string, the octave).
- R7 `PREFER` Idioms that make hard things possible: open strings to shift position (campanella scales),
  basses an octave up when the hand is high, the thumb on strings 2–6 in tremolo.
- R8 `MUST` A sustained non-chord tone needs a chord under it. In tremolo every melody note lasts a whole
  beat, so a passing tone over a held bass becomes a clash: change the harmony for that beat.
- R9 `MUST` Ornaments use chord tones or resolve by step against what sounds under them (C5 over E7 with
  G#4 sounding was heard as "fuera de tono"). Slurred turns on one string (7–p4–h7) are idiomatic.
- R10 `MUST` Structure: each movement needs a home theme that returns, a contrast (key, register, texture)
  and a climax prepared by what comes before. A chain of nice ideas "no sabe hacia dónde va".

## Apply in MIDI / REAPER
- Choose the Ample Guitar L settings for the piece from the [[guitar-ample-performance]] R7 table (vibrato,
  legato, attack, release, sample cycling; per section if the texture changes) and leave one empty bar
  before the first note.
- Write in **sounding** pitch: the melody's home is E4–E5 (strings 1–2, frets 0–12). A theme written around
  F#5 landed at frets 14–17 (*Remanso*).
- Under a melody, pick the arpeggio's inner tones under the melody note sounding at that eighth, not under
  the bar's lowest note (or the arpeggio collapses to one repeated note), and drop tones a semitone from it.
  Reference: `flow()` in `A:\CERBATANA\Ableton\2026-11-02 Remanso\generator\sections\remanso.mjs`.
- One MIDI channel per string (channel 1 = 1st string); the Tab Viewer then shows the real fingering.
- Arpeggio figures (one beat): bass → middle → top note (the peak) → open string under it → middle →
  low; dynamics rise to the peak and recede (see [[guitar-ample-performance]]).
- Tremolo (p a m i): thumb on each eighth, the trill as 32nds on the melody string; give non-chord tones
  their own beat of harmony; the thumb's note stops when the chord changes.
- Rasgueado: four-finger roll (e a m i) as strokes 1/32 apart landing on the beat, then down/up strokes;
  up strokes take strings 1–4.
- Pickups at the end of a phrase belong to the next phrase: no fading, no tempo stall.

## Checklist
- Fingering solver: 0 impossible slices, 0 dropped notes, no shift ≥ 4 frets in < 90 ms.
- `short.mjs`: no accompaniment note released < 0.2 s after its attack (except eighth-note basses in fast
  dances).
- `clash.mjs`: every minor 2nd/9th against a sounding note is a chord colour, a resolving appoggiatura or a
  short passing tone.
- Each movement: where is the theme, where does it return, where is the climax?

## Examples
- Preludio A: Em campanella at position VII, motif B4–C5–B4 as the top note of each beat, open B under it.
- Canción B: contrast in C major, a sixth-up motif in sequences, an E7 pedal where the theme's motif climbs
  B–C–B, D–E–D, F–E–D before the theme returns.
