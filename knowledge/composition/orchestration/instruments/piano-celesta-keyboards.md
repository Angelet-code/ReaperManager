---
id: orchestration.piano-celesta-keyboards
title: Piano, celesta, harpsichord and organ in the orchestra
aliases: [piano, celesta, clave, clavecín, clavicémbalo, órgano, teclados, tecla, pedal de resonancia, una corda, Klavier, Cembalo, Orgel, Celesta, pianoforte]
domain: orchestration
tags: [keyboards, instrument, ranges, doubling, continuo]
style_scope: universal
use_when: Adding or checking a piano, celesta, harpsichord or organ part inside an orchestral texture.
summary: Piano A0–C8 (21–108) is used in modern orchestras mainly as a percussive doubler (octaves, ostinati), filler or accompaniment, with CC64 sustain. Celesta sounds an octave above written (60–108): soft magical sparkle with pizz or harp. Harpsichord F1–F6 (29–89) has no touch dynamics and little volume; organ manuals C2–C7 (36–96, stop footage shifts octaves) reinforces the bass with pedal notes.
sources: ["unir-orq-tema8 p.9-16", "unir-orq-tema1 p.8-11"]
related: ["[[harp]]", "[[mallet-percussion]]", "[[double-bass]]", "[[_instruments]]"]
---

# Piano, celesta, harpsichord and organ in the orchestra

## Core idea
Keyboards read the grand staff. In the orchestra they are colour and reinforcement rather than the main
harmonic carrier (except concertos and continuo).

| Instrument | Written → sounding | Full (sounding) | Practical | Dynamics |
|---|---|---|---|---|
| Piano | as written | 21–108 | 28–103 (general knowledge) | touch-sensitive; sustain pedal |
| Celesta | +12 | 60–108 (written C3–C7) | 72–103 | soft only |
| Harpsichord | as written | 29–89 | 29–89 | no touch dynamics; registers (stops) only |
| Organ (manuals) | depends on stop: 8' as written, 16' −12, 4' +12 | keys 36–96 (8' sounding) | 36–96 | no touch dynamics; registration, swell |
| Organ (pedalboard) | 16' −12, 32' −24 (inferred) | keys 36–67 | 36–55 | as above |

## Rules
**Piano**
- R1 `PREFER` in 20th/21st-c. orchestral writing: a percussive, versatile member using its huge range —
  doubling other instruments (Stravinsky *Petrushka*), octave basses, ostinati.
- R2 `ALLOWED` piano as orchestral filler or accompaniment (Saint-Saëns *Carnival*, "Tortoises").
- R3 `ALLOWED` pedals: right = sustain (CC64); left = una corda (softer, veiled); middle = sostenuto (holds
  only the notes down when pressed).
- R4 `ALLOWED` agility (general knowledge): anything a pianist can play — fast runs, repeated chords, wide
  leaps — but each hand spans ≤ a 9th/10th (14–16 st) and ≤ 5 notes.
**Celesta**
- R5 `PREFER` soft, magical sparkle; pair with pizz strings, harp, flutes (Tchaikovsky *Sugar Plum Fairy*:
  celesta melody over pizz, pp). Register mostly 72–96 sounding.
- R6 `AVOID` celesta against loud textures: it disappears (general knowledge).
**Harpsichord**
- R7 `MUST` thin the orchestration around it: very limited volume; plucked, no touch dynamics.
- R8 `PREFER` Baroque continuo role (with cello/bassoon bass); modern use as colour (Falla concerto).
**Organ**
- R9 `ALLOWED` organ pedal as a bass reinforcement under a tutti (Strauss *Zarathustra*: low C pedal).
- R10 `ALLOWED` registration sets loudness and colour; changes need time or an assistant.

## Apply in MIDI / REAPER
- Piano: velocity = dynamics (p 35–55, f 85–110); CC64 down on harmony, lift-and-repress at each chord
  change; for percussive doubling use octaves (e.g. bass line + bass line −12) with short notes.
- Celesta: velocity 40–80; note lengths matter little (decay); keep at sounding pitch (patch usually
  plays sounding pitch; check).
- Harpsichord: velocity ignored by most patches; change dynamics by adding/removing doublings and stops.
- Organ: sustained notes only; dynamics via swell CC (often CC11/CC7) or stop changes; a 16' pedal patch
  on C2 key sounds C1 (inferred).
- Pan: piano/celesta left-rear near the harp; organ centre, large reverb.

## Checklist
- [ ] Piano notes 21–108; per hand ≤ 5 notes and ≤ 16 st span.
- [ ] Piano in an orchestral cue is doubling/percussive, not duplicating all string harmony.
- [ ] Celesta notes 60–108, soft context only.
- [ ] Harpsichord notes 29–89, with thin accompaniment.
- [ ] Organ key numbers 36–96 manual / 36–67 pedal; footage of the patch known.
- [ ] CC64 lifts at chord changes (no harmonic smear).

## Examples
- Percussive doubling: piano octaves C2+C3 (36+48) on the bass of a tutti ostinato, vel 100.
- Celesta: E6–D6–C6–B5 (88 86 84 83) over pizz strings, pp.
