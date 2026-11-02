---
id: orchestration.cello-techniques
title: Cello techniques (fingering, thumb position, chords, harmonics, pizzicato, colours)
aliases: [posición de pulgar, capotasto, pulgar, digitación del violonchelo, extensión, cambio de posición, dobles cuerdas violonchelo, acordes violonchelo, armónicos violonchelo, armónico natural, armónico artificial, pizzicato violonchelo, trémolo sul tasto, sur la touche, Daumenaufsatz, Flageolett]
domain: orchestration
tags: [strings, cello, technique, thumb-position, double-stops, harmonics, pizzicato, tremolo]
style_scope: universal
use_when: A cello part needs high notes (thumb position), double stops or chords, arpeggios across strings, harmonics, pizzicato or special colours, or you must check whether a cello figure is playable.
summary: Cello hand spans a minor 3rd (major 3rd with extension), so it shifts more than violin; keys with open strings (C, G, D, F) are easiest; thumb position (from about an octave above each open string) must be prepared, never sprung mid-run. Double stops: any interval within the octave except seconds in low positions; prefer 3-note chords with open strings, rolled low→high. Harmonics: natural partials 2–6 of open strings or 4th-node artificial (+24); pizz sings up to ≈ B4 (71).
sources: ["unir-orq-tema4 p.26-32", "adler-orq-es p.9-11, 75-83", "piston-orch p.80-97"]
related: ["[[cello]]", "[[string-techniques]]", "[[string-techniques-stops-and-divisi]]", "[[double-bass-techniques]]", "[[harp]]", "[[timpani]]"]
---

# Cello techniques

## Core idea
Back to [[cello]] for ranges, roles and doublings. This note answers "can one cellist play this, and how
does it sound?". Open strings **36 43 50 57** are the resonant anchors for chords, arpeggios and
harmonics.

## Rules
**Fingering and positions**
- R1 `MUST` budget for shifts: 1st→4th finger spans a **minor 3rd** (3 st), a major 3rd with the
  whole-tone extension between fingers 1 and 2, which does not fill the 5th between strings (Piston).
- R2 `PREFER` keys that sit in first position with open strings: C major from C2 to C4 (36–60) needs no
  shift; E major over the same span needs about five (Piston). Fast passages in remote sharp keys: simplify.
- R3 `ALLOWED` fast chromatic scales over the whole range (pattern 1-2-3 plus open strings).
- R4 `PREFER` inaudible shifts; portamento only on purpose, since a section of ≈ 10 exaggerates it.

**Thumb position**
- R5 `MUST` from 7th position (an octave above the open string; ≈ 69+ on the A string) the thumb lies across
  the string as a movable nut; the 4th finger is rarely used there.
- R6 `NEVER` spring a thumb note inside a continuous passage in normal position: give a rest, a long note or
  a stepwise approach so the thumb can be placed (Piston).
- R7 `ALLOWED` in thumb position, octaves and fifths on adjacent strings (thumb + 3rd finger) and wide
  extended patterns (thumb-to-3rd spans up to an octave high up).

**Double stops, chords, arpeggios**
- R8 `ALLOWED` double stops: every interval within the octave on two adjacent strings in low positions,
  **except seconds**; M2 only from 3rd position up, m2 from 4th up (Piston). Adler: intervals wider than a
  6th are difficult low. Open string + stopped note is safest.
- R9 `PREFER` chords with one or more open strings (most sonorous); 3-note chords; 4-note chords are usually
  too heavy. Triple stops attacked together only at mf+; 4-note chords always rolled.
- R10 `MUST` chords sound low note first (rolled upward) unless an arrow asks downward (to stress the top).
- R11 `AVOID` thumb-stopped double stops inside running passages: they need a break and are less expressive.
- R12 `PREFER` arpeggios across the strings shaped like a 4-note chord: one note per string, no shifts
  (Strauss *Symphonia domestica*).

**Harmonics**
- R13 `ALLOWED` natural harmonics, more secure on cello than violin/viola (longer strings). Partials of an
  open string: +12, +19, +24, +28, +31 (on A: 69 76 81 85 88). `AVOID` the 7th partial (flat) and
  anything above the 8th.
- R14 `PREFER` artificial harmonics with the touched 4th: stopped note + **24**, usable over the whole range
  (stopped 37 → 61). The 5th-node type (+19) is rarer and poorer.
- R15 `ALLOWED` legato glissando through one string's natural harmonics, con sord., as a shimmer (Stravinsky
  *Firebird*); divided cellos holding harmonics ppp as a pedal (Mahler 1 opening).

**Pizzicato**
- R16 `PREFER` pizz is especially sonorous: the everyday way to give the bass body and transparency;
  arpeggio pizz accompaniments are common (Brahms 2). Richest within an octave above each open string
  (36–69, UNIR); still good to ≈ B4 (71), wooden above (special effect, e.g. accented high pizz tune,
  Shostakovich 5).
- R17 `MUST` pizz chords roll upward with the thumb by default; downward needs an arrow; short abrupt
  chords on the top three strings are possible (guitar effect, Debussy *Ibéria*).
- R18 `ALLOWED` plucked natural harmonics (+12, +19 above an open string): harp/bell-like. `AVOID` plucked
  harmonics on stopped notes.

**Bow colours**
- R19 `ALLOWED` sul tasto, sul ponticello, col legno, every tremolo. `PREFER` bowed tremolo sul tasto on the
  C/G strings (≈ 36–55) for a mysterious, dark bed (Debussy *La Mer*).
- R20 `ALLOWED` fingered tremolo up to a major 3rd in normal position; wider needs thumb position.

## Apply in MIDI / REAPER
- One track = one player's possibilities: ≤ 2 sustained notes, on adjacent strings, ideally including
  36/43/50/57; otherwise split into `Vc div` tracks.
- Bowed chords: stagger 3–4 notes 15–30 ms low→high, keep only the top two sustained (inferred).
- Pizz chords: strum 10–25 ms low→high (inferred). Pizz lines above 71: dry/short pizz patch or another
  instrument.
- Harmonics: harmonics articulation, pp–ppp, pitches from R13/R14 only; slow notes (inferred).
- Thumb approach: put a rest or ≥ 1-beat note before the first note ≥ 69 in a fast figure.
- Low tremolo: tremolo + sul tasto patch (or tremolo with CC1 ≤ 50), 36–55 (inferred).

## Checklist
- [ ] Every simultaneous pair is on adjacent strings and is not a second in low positions.
- [ ] 3–4-note chords include an open string and are at mf+ (or rolled).
- [ ] Fast runs don't jump into ≥ 69 without preparation.
- [ ] Harmonic pitches are real partials (no 7th partial) or stopped + 24.
- [ ] Section pizz mostly ≤ 71.

## Examples
- Open-string chord: C2–G2–E3 (36 43 52), f, rolled; or G2–D3–B3 (43 50 59).
- Arpeggio figure in D: D2–A2–F#3–D4–F#3–A2 (38 45 54 62 54 45), détaché, one note per string (C G D A).
- Harmonic pedal: A4 (69) and E5 (76) natural harmonics on the A string, ppp, div. a 2.
