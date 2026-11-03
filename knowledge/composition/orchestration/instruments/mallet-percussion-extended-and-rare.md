---
id: orchestration.mallet-percussion-extended-and-rare
title: Mallet percussion extended techniques, rare pitched percussion and period use
aliases: [golpe sin resonancia, dead stroke, vibráfono con arco, crótalos con arco, steel drum, tambores de acero, cimbalón, címbalo húngaro, salterio, serrucho, sierra musical, flexatón, copas de cristal, armónica de cristal, silbato, flauta de hojalata, glockenspiel de teclado, Hackbrett, Zimbal, singende Säge, Glasharmonika]
domain: orchestration
tags: [percussion, pitched-percussion, extended-techniques, effects, period-practice]
style_scope: universal (techniques); 20th c. / film (rare instruments); classical–romantic (period notes)
use_when: Writing dead strokes, bowed vibes or crotales, or a cimbalom, steel drum, musical saw, flexatone, glass or tin-whistle colour, or mallet percussion in a period style.
summary: Dead strokes give a damped staccato; a bow on vibes (motor on, pedal down) or on crotales gives an eerie sustained tone. The cimbalom (40–88) plays fast florid figuration and sustains only by rolls; steel drums evoke the Caribbean; saw and flexatone (≈ 72–89) slide with heavy vibrato and only approach pitches. Before about 1880 the orchestra's mallet colour was the glockenspiel; the vibraphone and marimba became orchestral only after 1950.
sources: ["adler-orq-es p.431, 437-445, 449-452", "piston-orch p.314-318"]
related: ["[[mallet-percussion]]", "[[percussion-unpitched-latin-and-effects]]", "[[piano-celesta-keyboards]]", "[[string-techniques-colour-effects]]", "[[_instruments]]"]
---

# Mallet percussion: extended techniques, rare instruments, period use

## Core idea
Ranges and everyday idiom: [[mallet-percussion]]. This note covers special strokes, pitched percussion
outside the standard section and how the mallet family entered the orchestra.

## Rules: extended techniques
- R1 `ALLOWED` **Dead stroke** (vibes, xylophone, marimba): the mallet stays on the bar, giving a dull,
  damped staccato. Best when the instrument is soloist or lightly accompanied; written with x heads
  (Adler).
- R2 `ALLOWED` **Bowed vibraphone** (cello or bass bow on the bar end): a mysterious sustained tone,
  best with the motor on and the pedal down; slow single notes (Adler).
- R3 `ALLOWED` **Bowed crotales**: a disturbing, penetrating sustained tone (Adler).
- R4 `ALLOWED` Glock and crotales: the player can lengthen the ring and add slight vibrato by waving a
  hand over the bar or disc; brushes on vibes for glissando effects (Adler).
- R5 `ALLOWED` Glissandi on xylophone, marimba, vibes and glock; on bells possible but `AVOID` overusing.

## Rules: rare pitched percussion
- R6 `ALLOWED` **Cimbalom** (Hungarian concert dulcimer, hammered strings, damper pedal): range E2–E6
  (40–88, Adler). `PREFER` florid, fast figuration that cuts through a tutti (Kodály *Háry János*, Bartók,
  Stravinsky; Dutilleux after 1980). `MUST` sustain by rolls, even when the part does not mark them.
- R7 `ALLOWED` **Steel drums**: metallic, marimba-like, soft mallets, 2–3-note chords in calypso rhythm.
  `PREFER` only for a Caribbean atmosphere (Adler).
- R8 `ALLOWED` **Musical saw**, ≈ C5–F6 (72–89) [?]: heavy vibrato on every note, glissando over the whole
  range; singing sustained melodies, like bowed vibes with maximum vibrato but less precise in pitch.
- R9 `ALLOWED` **Flexatone**, ≈ 72–89 [?]: high, tremolo-laden sound or short isolated notes. `AVOID`
  demanding exact pitches; it only approaches them (Adler).
- R10 `ALLOWED` **Musical glasses / glass harmonica**: rubbed with wet fingers for long, pure notes; modern
  scores may ask only for low, medium and high glasses (Adler).
- R11 `ALLOWED` **Whistles**: name the type (bird, police, slide, tin, train). A tin whistle plays real
  melodies (Copland *Billy the Kid*; Celtic film colour, Williams *Far and Away*); for other whistles,
  describe exactly what they do (Adler).

## Period practice
- `[era: 18th c., Mozart]` Keyed glockenspiel played from a keyboard (*The Magic Flute*). Piston prefers the
  mallet glock: better dynamics and tone; keep the keyed one for parts mallets cannot play.
- `[era: 19th c.]` The glockenspiel is the oldest mallet instrument in the orchestra (Wagner *Meistersinger*
  waltz with flute and oboe). The xylophone joins in the late 19th c. (Saint-Saëns *Danse macabre*,
  "Fossils"); glock and xylophone become regular members with the enlarged late-Romantic orchestra.
- `[era: 19th–early 20th c. scores]` Crotale (antique cymbal) notation varies: some parts sound as written,
  others an octave higher, so older works use pitches below 84, e.g. Berlioz *Roméo* Bb5 and F6 (82, 89),
  Debussy *Faune* E6 and B6 (88, 95). In hand-held pairs one pair = one pitch, so two quick different
  notes need two players (Piston). Today's mounted sets are chromatic.
- `[era: 1955, Piston]` The vibraphone was rare in the symphony orchestra (thought too sweet); the marimba
  rare too. Adler (2002): the marimba gains an orchestral place after 1950; vibes are standard in 20th-c.,
  jazz and film colour.
- `[era: late 20th c.]` Tuned cowbells, Asian bells and gongs with exact pitch, amplified percussion.

## Apply in MIDI / REAPER
- Dead stroke: the patch's dead/muted articulation, or very short notes (≤ 0.1 beat) at mf with a damped
  sample (inferred).
- Bowed vibes or crotales: a bowed patch with a CC1/CC11 swell; without one, a soft long vibes note with
  motor on and CC64 down (inferred).
- Cimbalom: velocity-driven 16ths with no pedal; a held note becomes re-triggered 32nds; clamp 40–88.
- Saw: a long note with pitch-bend slides and strong vibrato (modwheel or LFO).
- Period pastiche: before about 1880 use only glockenspiel (plus bells for programmatic tolling); no
  vibes or marimba in a Classical or Romantic pastiche.

## Checklist
- [ ] Bowed and dead-stroke effects used as colour, not as a default articulation.
- [ ] Cimbalom held notes are rolls; notes inside 40–88.
- [ ] Saw and flexatone parts tolerate pitch approximation.
- [ ] No vibraphone or marimba in a pre-1900 pastiche.
