---
id: orchestration.percussion-section-writing
title: Writing for the percussion section (players, order, jobs, colour)
aliases: [sección de percusión, escritura para percusión, percusionistas, asignación de ejecutantes, orden de la percusión, distribución de la percusión en la partitura, usos de la percusión, coloración, refuerzo rítmico, percusión con teclado, percusión de láminas, cambio de baquetas, Schlagwerk, Schlagzeuger]
domain: orchestration
tags: [percussion, section, balance, doubling, colour, keyboards, track-layout]
style_scope: universal (Adler 2002 / Piston 1955 orchestral practice; period colour kits era-tagged)
use_when: Deciding whether, where and how percussion enters a cue, how many players it needs, how to order its tracks, and how to combine it with piano, celesta, harp or mallets.
summary: Every percussion entry needs a job (march/folk colour, accent reinforcement, climax, dramatic opening, colouring notes) or it goes; fewer is better, and ff timpani + bass drum masks everything. Plan 3–4 players plus timpanist and keyboard player, ≤ 2 instruments per player at once, rolls need both hands, switches need time. To reinforce, double only the accents of another section on the same rhythm with one dry colour.
sources: ["adler-orq-es p.486-497, 506-513, 536-544", "piston-orch p.343-348"]
related: ["[[percussion-section-writing-climax-and-openings]]", "[[percussion-unpitched]]", "[[timpani]]", "[[mallet-percussion]]", "[[piano-celesta-keyboards]]", "[[harp]]", "[[film-percussion-phrase-marking]]", "[[score-and-parts-layout]]", "[[library-translation-table]]", "[[user-taste]]"]
---

# Writing for the percussion section

## Core idea
Percussion is the easiest section to overuse. Adler's test: each instrument must be organic, as if
nothing else could replace it. Keyboards, mallets and harp sit and are scored with it. Instruments:
[[percussion-unpitched]], [[timpani]], [[mallet-percussion]]. Climaxes, openings, march colour:
[[percussion-section-writing-climax-and-openings]].

## Rules
**Restraint and balance**
- R1 `MUST` give each entry one job: (1) march or folk colour, (2) reinforcing accents and rhythmic
  activity, (3) building or crowning a climax, (4) a dramatic opening, (5) colouring notes or passages
  by doubling. Modern scores also use pitched percussion as an independent section that alternates
  with others. An entry with no job is deleted (Adler).
- R2 `AVOID` percussion to hide weak passages; "the fewer, the better" (Rogers, quoted by Adler).
- R3 `AVOID` ff timpani doubled by bass drum when anything else must be heard: nothing else will be
  (Piston, quoted by Adler). `AVOID` loud bass-drum strokes or cymbal rolls under a passage that must
  stay transparent; with full brass either covers the whole orchestra.
**Players**
- R4 `PREFER` a symphony section of 3–4 percussionists plus the timpanist and the keyboard player.
  Ask for one more player rather than overloading a few (Respighi's *Feste romane* needs ~10 at once).
- R5 `MUST` per player at most two instruments at once, with one beater per hand (or the same beater
  type on both). `NEVER` a roll unless the player holds suitable sticks in both hands then.
- R6 `MUST` leave time to change beaters. Triangle ↔ bass drum is quick (one beater per hand);
  triangle → snare and blocks ↔ xylophone need time (unless both take xylophone mallets).
- R7 `PREFER` grouping per player so pairs can sound together. Adler's 3-player model: P1 triangle,
  suspended cymbal (stick), snare; P2 tam-tam, tenor drum, bass drum; P3 sleigh bells, Chinese and
  temple blocks, tambourine.
**Order** (score and track list)
- R8 `PREFER` brass → timpani → unpitched (high to low, or metal → wood → skin) → harp → mallets →
  keyboards → strings. Unpitched reference order: triangle, sleigh bells, cymbals, tam-tam, Chinese
  blocks, temple blocks, tambourine, snare, tenor drum, bass drum. Mallets/keyboards: glockenspiel,
  crotales, xylophone, vibraphone, marimba, chimes, celesta, piano, harpsichord, organ. Scores vary
  (Shostakovich 6: harp below xylophone; *Les Noces*: solo pianos above timpani).
- R9 `MUST` distinguish ringing (l.v., tie to nothing) from choked strokes (staccato dot) on cymbals
  (Adler).
**Reinforcing rhythm and accents**
- R10 `PREFER` double only the accented notes of a line (xylophone on a violin line's accents) and
  put one drum stroke under a brass *sf*, not a pattern of its own (Copland).
- R11 `PREFER` one dry colour on the identical rhythm: wood block on violin offbeats, claves on tutti
  accents in changing metres, snare brush or rim at p for a soft backbeat, a triangle swell into the
  accent ending a rising scale, one p triangle stroke when the texture changes.
**Colouring**
- R12 `ALLOWED` timpani (hard sticks, staccato eighths) + bass drum + tam-tam on a low wind ostinato
  = heavy procession; BD and tam-tam strokes irregular, off the barline (*Rite*; inferred).
- R13 `PREFER` a soft pitched metal on a sustained pedal makes an ending ethereal: crotales ppp with a
  muted horn's pedal note (Debussy *Faune*).
- R14 `ALLOWED` a percussion figure tied to a theme returns with it and can grow into a solo at the
  section end, closed by a tutti chord + timpani *sfz* (Bernstein).
**With keyboards and harp**
- R15 `ALLOWED` piano low tremolo + timpani roll + BD roll as one dark rumble (Prokofiev 5);
  2 harps + piano unison low accents + bass pizz + timpani (Britten); celesta, harp or piano marking
  each chord change of high strings (Bassett); celesta + glock + harps + flutes + muted solo violins as
  glitter (Strauss); `[era: 20th c.]` pianos + percussion as a percussive orchestra (*Les Noces*,
  Orff).

## Apply in MIDI / REAPER
- Folder `PERCUSSION` (empty bus) with children in R8 order: `TIMP`, `TRI`, `SLEIGH`, `CYM`, `SUS CYM`,
  `TAM-TAM`, `BLOCKS`, `TAMB`, `SNARE`, `BD`, then `HARP`, `GLOCK`, `XYL`, `VIB`, `CELESTA`, `PIANO`.
  One track per instrument (vault convention).
- Plausibility per bar (inferred): simultaneous unpitched notes ≤ 2 × players (default 3); a roll
  blocks its player; a beater change leaves ≥ 1 beat.
- Masking guard: under material that must read, `TIMP` + `BD` ≤ vel ~100 (inferred).
- Accent copy: notes of the source line with vel ≥ 100 → `XYL` or `BLOCKS`, `len` 0.25, same vel.
- l.v. → long note or ring articulation; choke → short note on a choke key (Symphony Series Cymbal 1:
  48/50 long, 52/53 choke — [[library-translation-table]]).
- Velocities follow [[dynamics-by-orchestration]]; ±5 on repeats ([[velocity-and-timing-humanization]]).
- User taste: R15 lower percussion before raising melodies; R3 no snare rolls into sections outside
  rock/march contexts; R16 timpani ≤ 4 drums per passage.

## Checklist
- [ ] Each percussion entry names its job; no filler.
- [ ] No ff timp + BD under material that must be heard.
- [ ] ≤ 2 simultaneous instruments per player, rolls two-handed, switch time respected.
- [ ] Tracks ordered timp → unpitched → harp → mallets → keyboards.
- [ ] Cymbal strokes marked ring or choke.

## Examples
- Americana offbeats: violins f on the "and"s; `BLOCKS` same 8th offbeats, vel 75, `len` 0.2.
- Chord-change sparkle: high strings pp; `CELESTA` one note per new chord, vel ~70.
