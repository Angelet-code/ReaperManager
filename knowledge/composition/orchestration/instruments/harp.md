---
id: orchestration.harp
title: Harp (pedal harp)
aliases: [arpa, arpa de pedales, Harfe, arpa, harpe, glissando, pedales del arpa, étouffé, armónicos de arpa]
domain: orchestration
tags: [harp, instrument, ranges, pedals, glissando]
style_scope: universal
use_when: Writing or checking a harp part: pedal settings, chromaticism, glissandi, arpeggios, harp doublings.
summary: Pedal harp sounds as written, Cb1–G7 (23–103; top string Gb7 = 102, G7 with the G pedal natural), 47 strings tuned in Cb major; seven pedals (one per note name, flat/natural/sharp) mean each pitch class has one setting at a time. Avoid continuous chromaticism, plan pedal changes in rests and alternate feet, write glissandi through a pedal set, and use arpeggios and étouffés.
sources: ["unir-orq-tema8 p.4-8"]
related: ["[[piano-celesta-keyboards]]", "[[mallet-percussion]]", "[[string-techniques]]", "[[_instruments]]"]
---

# Harp (pedal harp)

## Core idea
47 strings tuned in **Cb major** (all pedals up = all flats). **Seven pedals**, one per note name, each with
three positions: **up = flat, middle = natural, down = sharp** (each affects that note in every octave).
Pedal order: **left foot D C B | right foot E F G A**. Grand staff, non-transposing. C strings red, F blue.
The lowest Cb string has no pedal; retune by hand.

| Zone | MIDI | Colour (general knowledge except range) |
|---|---|---|
| Lowest | 23–35 | deep, resonant, long ring; muddy in close chords |
| Low-middle | 36–59 | full, warm; best for bass notes and open arpeggios |
| Middle | 60–83 | richest, most resonant zone; melodies and chords |
| High | 84–95 | bright, clear, shorter ring |
| Top | 96–103 | dry, short, little sustain |

Full range **23–103** (top string Gb7/F#7 = 102, G7 = 103 with the G pedal natural), practical **24–96**.

## Rules
- R1 `MUST` choose a pedal setting (one spelling for each of the 7 note names) per passage; every note
  must belong to it. Enharmonics help (e.g. B# = C, Fb = E).
- R2 `AVOID` continuous chromaticism: it needs constant pedal changes.
- R3 `AVOID` two pedal changes with the same foot at once; `PREFER` changes that alternate feet and fall in
  rests or under long notes (≥ 1 beat per change at moderate tempo, inferred).
- R4 `PREFER` writing the pedal changes into the part.
- R5 `ALLOWED` glissando: very effective, even in tutti; one or two hands, also in double strings or chords
  (Debussy *Faune*). Notate one octave of the set, a line, and the arrival note. `AVOID` trivial cliché glissandi.
- R6 `ALLOWED` arpeggios with one or two hands (each hand ≤ 4 fingers, span ≈ a 10th; general knowledge).
- R7 `ALLOWED` étouffé: each note damped by the playing finger → very dry staccato.
- R8 `ALLOWED` harmonics (octave above the string, soft, bell-like) (general knowledge).
- R9 `PREFER` doublings (general knowledge): harp + pizz strings (attack + resonance), harp + celesta or
  glock (sparkle), harp + flute/clarinet on arpeggiated accompaniment, harp bass + cello/bass pizz.
- R10 `AVOID` relying on harp volume against brass or full tutti except for glissandi and fortissimo
  chords in the middle register (general knowledge).

## Apply in MIDI / REAPER
- Track `Harp` (one track; optionally `Harp LH`/`RH`). Before generating, store the pedal set, e.g.
  `D C B | E F G A = D, C, Bb | Eb, F, G, A` (Bb major), and reject notes outside it.
- Glissando in MIDI: fast run of all 7 strings per octave in the pedal set, 15–30 notes per second,
  velocity rising/falling with the gesture; never a chromatic run. Enharmonic sets give chord glissandi,
  e.g. pedals D# C B# | Eb F# Gb A sound only C, Eb, F#, A (dim7; repeated pitches) (general knowledge).
- Arpeggios: notes spaced 30–80 ms or rhythmic; let ring (long note lengths) unless étouffé.
- Chords: up to 4 notes per hand; roll chords slightly (10–30 ms) unless marked non arpeggiato.
- Pan: left, behind the first violins.

## Checklist
- [ ] All notes 23–103; mostly 24–96.
- [ ] Each passage fits one pedal set (≤ 7 pitch classes, one spelling per note name).
- [ ] Pedal changes have time and do not need two same-foot changes simultaneously.
- [ ] Glissandi use only pitch classes of the set.
- [ ] Simultaneous notes ≤ 8 (4 per hand), each hand spanning ≤ ≈ 16 st.

## Examples
- Pedal set for C major glissando: D C B | E F G A all natural.
- Debussy-like: Eb major arpeggio Eb3–G3–Bb3–Eb4–G4 (51 55 58 63 67) rolled up, pp.
