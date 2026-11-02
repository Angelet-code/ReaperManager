---
id: orchestration.timpani-effects-and-period-practice
title: Timpani effects, roto-toms and period practice
aliases: [glissando de timbal, glissando de pedal, timbales cubiertos, coperti, con due bacchette, timbal piccolo, timpano piccolo, roto-toms, rototom, timbales clásicos, timbales en tónica y dominante, Pauken mit Schwammschlägeln, gedämpfte Pauken, timbales de Beethoven, varios timbaleros]
domain: orchestration
tags: [percussion, timpani, effects, period-practice, roto-toms]
style_scope: universal (effects); classical / romantic (period practice)
use_when: Writing timpani glissandi, muffled or special-stick effects, extra drums or several timpanists, roto-toms, or timpani in Classical, Beethoven or Berlioz style.
summary: Pedal timpani can glide (stroke then pedal, or a roll through a pedal change) and play chromatic lines; coperti mutes, centre strokes darken, near-rim strokes give a fine pp, two sticks or two drums on one note strengthen accents. Roto-toms extend the timpani sound upward and drier. Classical style uses two drums (≈ 41–53) on tonic and dominant, fixed per movement, with the trumpets.
sources: ["adler-orq-es p.431, 435-436, 445-449", "piston-orch p.297-303"]
related: ["[[timpani]]", "[[trumpet-period-practice]]", "[[natural-horn-period-practice]]", "[[percussion-unpitched]]", "[[_instruments]]"]
---

# Timpani effects, roto-toms and period practice

## Core idea
Basics, drum ranges and roll notation: [[timpani]]. This note holds the special colours and the older
styles. The modern default is four pedal drums; use the period rules only when a period is named.

## Rules (effects)
- R1 `ALLOWED` Pedal glissando, two kinds (Piston, Bartók *Music for Strings*): one stroke, then the pedal
  moves while the drum still rings; or a roll held through a pedal change (e.g. G#2 → C#3).
- R2 `ALLOWED` Chromatic lines with a pedal change per semitone, not a glide (d'Indy). Pedal drums only.
- R3 `ALLOWED` *Coperti*: a cloth on the head mutes the drum. A tremolo can be shared between two drums
  (Debussy *Nuages*).
- R4 `ALLOWED` Stronger accents: two drums tuned to one note struck together, or one drum with both sticks
  (*con due bacchette*, Mahler 4).
- R5 `ALLOWED` Beating spot (Adler): the normal spot is about 15 cm from the rim; nearer the rim gives a
  beautiful pp; the centre gives a dense, dull, dark sound.
- R6 `ALLOWED` Other sticks: wood, snare sticks, the handles, two different sticks at once.
- R7 `ALLOWED` [era: 20th c.] A cymbal, tambourine or maracas laid on the head buzzes sympathetically; the
  shell or rim played with wood sticks as unpitched percussion.
- R8 `ALLOWED` Several timpanists as one instrument (Adler, Piston). Examples: Berlioz *Fantastique* "Scène
  aux champs" (4 players, chords), Berlioz *Requiem* (10 players, 16 drums), Stravinsky *Sacre* (2
  players, 5 drums), Holst "Saturn" (two sets).
- R9 `AVOID` Extension drums except when needed: they lack true timpani resonance (Piston). Stravinsky's
  *timpano piccolo* reaches B3 (59); Ravel asks for D4 (62) [?]. Adler: if no piccolo drum exists, use a
  tuned tom-tom or a roto-tom.

## Roto-toms
- Single-head drums tuned by rotating the frame (Remo); modern sets have timpani-like resonators, blend
  with timpani and sound cleaner and more articulate. Older sets are much drier, with almost no ring.
- Seven sizes, each about an octave, together ≈ E2–C5/D5 (40–74). Adler's per-size readings are
  uncertain [?]; treat the span as approximate.
- R10 `ALLOWED` Same sticks and techniques as timpani; repeat a timpani passage an octave or more higher on
  roto-toms for contrast. One player with both: timpani normal heads, roto-toms x heads (Adler).

## Period practice
- `[era: Classical, c.1750–1825]` Two drums, usually the 28" and 25" (whole range then F2–F3, 41–53, G3
  55 rare), tuned to tonic and dominant of the key and left there for the movement (hand screws were slow).
  Role: forte tutti, climaxes and cadences, locked to the trumpets ([[trumpet-period-practice]]).
  A quiet roll for atmosphere is a special case (Haydn 103).
- `[era: Classical–early Romantic, Beethoven, Verdi]` When there was no time to retune, a timpani note a
  2nd away from the harmony was accepted; the noise of the drum absorbs it. `NEVER` in modern pedal
  writing; `ALLOWED` in a deliberate pastiche (Adler).
- `[era: Beethoven]` The drums become soloistic. Symphonies 8 and 9 tune them in octave F (F2–F3, 41 + 53);
  the scherzo of the Ninth has a timpani solo.
- `[era: Berlioz onward]` Two or more timpanists, chords on timpani; three drums, then four.
- `[era: 1955, Piston]` Three or four drums retuned within a movement are normal; at least two pedal drums.

## Apply in MIDI / REAPER
- Glissando: if the patch supports pitch bend, a held roll with a linear PB ramp; otherwise the library's
  gliss sample, or one stroke plus a slide of short low-velocity notes (inferred).
- Coperti / near-rim pp: a muted or short patch if present; else lower velocity (30–50) and short notes
  (inferred).
- Double-stick accent: two notes on the same pitch 5–10 ms apart, both at 110–127 (inferred).
- Classical pastiche, pitch pairs: C major G2 + C3 (43 + 48); D major A2 + D3 (45 + 50); Eb major Bb2 +
  Eb3 (46 + 51); F major F2 + C3 (41 + 48). Only on forte tutti and cadences, with the trumpets, no other
  pitch in the movement.
- Roto-toms: a separate track, short notes, no long rings; pitches 40–74.

## Checklist
- [ ] Glissandi and chromatic lines only on pedal drums, with time to prepare.
- [ ] Classical pastiche: exactly two pitches inside 41–53, with trumpets, at cadences and tutti.
- [ ] Off-harmony timpani notes appear only in a period pastiche.
- [ ] Extension drums (58–62) rare and exposed only on purpose.
