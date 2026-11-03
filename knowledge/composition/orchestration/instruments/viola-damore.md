---
id: orchestration.viola-damore
title: Viola d'amore (period practice)
aliases: [viola de amor, viola d'amore, viole d'amour, Liebesgeige, cuerdas simpáticas, sympathetic strings, Resonanzsaiten]
domain: orchestration
tags: [strings, instrument, period-practice, baroque, colour, solo]
style_scope: baroque and romantic-opera colour
use_when: A request names the viola d'amore, or asks for a Baroque/operatic obbligato with a ringing, sympathetic-string halo.
summary: Never a regular orchestral member; a solo/obbligato colour. Seven bowed strings tuned to D major (A2 D3 A3 D4 F#4 A4 D5 = 45 50 57 62 66 69 74; lowest uncertain) over seven sympathetic strings tuned in unison. Range ≈ A2–A6 (45–93). Chords, arpeggios and natural harmonics in D major/minor are easy, and that ringing is the point. Without a dedicated library, fake it with a solo viola plus a resonance layer (inferred).
sources: ["adler-orq-es p.73-75"]
related: ["[[viola]]", "[[viola-technique-limits]]", "[[string-techniques]]", "[[_instruments]]"]
---

# Viola d'amore (period practice)

## Core idea
`[era: Baroque; Romantic and early-20th-c. opera colour]` A bowed instrument slightly larger than a
violin. Seven playing strings run over seven steel **sympathetic strings**, normally tuned in unison
with them. The sympathetic strings ring whenever the music sits in the tuning's key, which gives the
characteristic halo. Adler (2002) treats it as a solo/chamber colour, never a section instrument.

| Item | Value |
|---|---|
| Usual tuning (D major) | A2 D3 A3 D4 F#4 A4 D5 (45 50 57 62 66 69 74); lowest note [?] |
| D-minor variant | F#4 → F4 (65) |
| Range | ≈ A2–A6 (45–93); top note [?] |
| Clefs | alto and treble; old parts may write low strings in bass clef sounding an octave higher |

## Rules
- R1 `PREFER` keys related to the tuning (D major / D minor). Chords and arpeggios across the strings are
  easy there, and the sympathetic strings ring most (Adler).
- R2 `ALLOWED` retuning for other keys (scordatura), as Vivaldi (six-string concertos) and Hindemith
  (Sonata Op. 25/4, *Kammermusik* No. 6) did. Their exact tunings are not recoverable from the scan [?]:
  if asked, state the tuning you assume.
- R3 `ALLOWED` natural harmonics, which are easy up to the 5th partial. Artificial ones are possible, and
  touch-a-4th works best. All violin bowings and colour effects are available (Adler).
- R4 `PREFER` obbligato roles: a solo line over thin accompaniment, or an introduction to a vocal number.
  Models: Bach *St John Passion* "Erwäge"; Meyerbeer *Les Huguenots* I (Raoul's recitative: chords,
  arpeggios, harmonics in sextuplets); Puccini *Madama Butterfly* II (with offstage women's chorus);
  Massenet, Pfitzner, Loeffler (Adler).
- R5 `ALLOWED` slow, chromatic lyrical lines across the whole range in a 20th-c. idiom (Hindemith *Kleine
  Sonate*).
- R6 `AVOID` using it as a section or tutti filler: there is no orchestral tradition for that.
- R7 `MUST` when reading old parts, check whether bass-clef notes sound an octave higher.

## Apply in MIDI / REAPER
- One track `V d'amore`, solo patch, concert pitch 45–93; keep the core in 57–86.
- No dedicated library (inferred): use a solo viola patch, or a solo violin when the line stays ≥ 62, and
  add a resonance layer. That layer can be a quiet send to a short, bright reverb, or a second track that
  holds the open-string pitches of the tuning (D, A, F#) as pp harmonics. Only D-major chord tones should
  ring.
- Chords: roll 3–4 notes upward 30–60 ms (inferred), with arpeggios on tuning notes (45 50 57 62 66 69 74).
- Dynamics p–mf; it is an intimate colour. Place it ≈ +5 dB over a thin bed ([[user-taste]] R15).

## Checklist
- [ ] Key is D major/minor, or the assumed retuning is stated.
- [ ] Notes 45–93; chords use tuning notes.
- [ ] Accompaniment thin; no section or tutti use.

## Examples
- D-major obbligato opening: arpeggio A3–D4–F#4–A4–D5 (57 62 66 69 74), slurred, p, then a sustained A5
  (81) harmonic.
