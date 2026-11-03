---
id: orchestration.string-section-writing-counterpoint
title: Counterpoint and fugato in the string section
aliases: [orquestación contrapuntística para la cuerda, contrapunto en la cuerda, fugato de cuerda, fuga para cuerda, entradas del sujeto, contrasujeto, Fugato der Streicher]
domain: orchestration
tags: [strings, counterpoint, fugue, fugato, texture, balance]
style_scope: universal
use_when: Writing two or more independent lines for strings alone (fugato, canon, a theme against a countermelody, Baroque concerto-grosso style), or checking why a string-only polyphonic passage sounds muddy.
summary: In strings-only counterpoint colour cannot separate the lines, so rank them (primary, secondary, tertiary) and separate them by register band and by rhythm, thinning the counterpoint around the main theme; dynamics help least. Fugal entries traditionally climb from the basses to Vln I, each entering with a rhythmically distinct, pickup-driven subject.
sources: ["adler-orq-es p.133-142", "piston-orch p.374-381"]
related: ["[[string-section-writing]]", "[[texture-counterpoint]]", "[[texture-secondary-melody-countermelody]]", "[[line-separation-and-fusion]]", "[[fugue]]", "[[imitation-and-canon]]", "[[string-techniques-colour-effects]]", "[[dynamics-by-orchestration]]"]
---

# Counterpoint and fugato in the strings

## Core idea
Strings play similar gestures equally well in every voice, so they suit fugue, canon and imitation; they
often state a fugato subject before the winds take it over. The cost: one colour. [[texture-counterpoint]]
separates lines by timbre group; inside a string-only texture, use **register and rhythm** instead
(see [[line-separation-and-fusion]]). Hub: [[string-section-writing]].

## Rules
- R1 `MUST` Rank the lines: primary (FG), secondary (MG), tertiary (BG), so each communicates its rank
  (Adler).
- R2 `MUST` For clarity and balance (Adler):
  1. give the most important line the best register of its instrument;
  2. thin the counterpoint so the main theme emerges;
  3. separate the registers of theme and counterpoints (one high, one low);
  4. make each counterpoint's rhythm clearly different from the theme's.
- R3 `ALLOWED` Different dynamics (FG f, BG p) help, but less than R2's register and rhythm (Adler).
- R4 `PREFER` Give every contrapuntal element its own rhythmic figure (running 16ths against accented
  quarters against held notes): in one colour, rhythm is the main separator (Adler, Vivaldi, Bach, Weber,
  Bartók).
- R5 `ALLOWED` Three layers in similar registers work when each has its own rhythm and articulation and
  the FG and MG were heard earlier without the BG (Adler, Beethoven 7/II: Vln I simple melody, Vln II legato
  long-note countermelody, Vla/Vc short off-beat figures, Cb on the beat).
- R6 `PREFER` A fugue subject stands out when it is heard alone first, has an easily recognised rhythm,
  contrasts rhythmically with the counterpoint and continuo, and opens with an **anacrusis** that gives it
  thrust (Adler).
- R7 `PREFER` Limit the colour options, especially when a repeat is planned with a different scoring
  (Adler).
- R8 `ALLOWED` Alternate counterpoint and homophony; a homophonic climax after a contrapuntal stretch is a
  strong contrast (Adler, Bach *Brandenburg* 3, Weber *Euryanthe*).
- R9 `ALLOWED` Mutes on for a soft fugal opening, taken off as each section enters toward the climax
  (Adler, Weber, Bartók). Allow time for the mute change ([[string-techniques-colour-effects]]).
- R10 `ALLOWED` Very similar, stepwise, legato lines in constant eighths make a calm, contemplative haze in
  which the entries are still heard: tension without rhythmic profile (Adler, Bartók *Music for Strings*:
  every entry con sord. pp, divided sections, shifting meters).
- R11 `AVOID` Raising a countermelody above the main melody's level (Piston). `PREFER` contrast the two
  melodic elements in outline and rhythm: a sustained legato secondary line stands out even when the main
  melody sounds above and below it (Piston, Beethoven 7/II).
- R12 `ALLOWED` The secondary melody can be the same tune in canon (Piston: octave canon one beat behind;
  the first entry keeps slight precedence) or a stream of parallel chords (Piston: parallel 6/4 chords in the
  strings).

## Period practice
- `[era: Baroque concerto grosso]` Entry order low to high: Cb + solo cello (continuo) → Vla → Vln II →
  Vln I (Vivaldi op.3/11). Other orders: Vln I → Vln II → Vla → basses; from Vln II: Vln I, Vla, Cb or Vla,
  Vln I, Cb; from the viola: Vla, Vln II, Vln I, Cb or Vla, Cb, Vln II, Vln I (Adler). Each new entry is f
  over running counterpoint; the figured continuo is the harmony layer, so a sustained chord bed under the
  counterpoint is idiomatic here, unlike [[texture-counterpoint]] R7.
- `[era: Baroque]` Writers used a much narrower register than today, so emphasis came from rhythm and
  texture, not register spread (Adler). In a Baroque pastiche keep Vln I mostly ≤ D6 (86) (general
  knowledge) and separate the lines by rhythm.
- `[era: Romantic, Weber]` Subject in Vc + Cb unison with accents; upper entries pp senza sord., Vln I mf;
  ends ff in triplets (Adler).
- `[era: 20th c., Bartók]` Divided pairs (Vla 1/2, Vc 1/2…), free and canonic imitation, constant eighths,
  tension held until a new colour enters (Adler).

## Apply in MIDI / REAPER
- Fugato: one track per entry (`Cb`/`Vc` → `Vla` → `Vln II` → `Vln I`), the subject alone or over sparse
  counterpoint; countersubject in a different note value (subject in 8ths → countersubject in quarters or
  16ths) and a different register band.
- Subject entries one dynamic step above the running counterpoint: CC1/velocity +10–15 on the entering
  track for its first statement (inferred).
- Rhythm check per bar: does the FG have its own register band **or** a rhythm no other part shares? If
  neither, thin or move a line.
- Articulation as separator: legato patch for the long countermelody, spiccato/staccato patch for the
  off-beat BG figures, pizz. or short for the bass.
- Muted opening: con sordino patch on the early entries, normal patch from a bar boundary when a section
  enters toward the climax.

## Checklist
- [ ] Each line ranked FG/MG/BG.
- [ ] No two lines share both register band and rhythm.
- [ ] The countermelody never above the main melody's level.
- [ ] Subject entries are audible (alone first, pickup, distinct rhythm).
- [ ] Homophonic arrival after the contrapuntal stretch, if a climax is wanted.

## Examples
- D minor fugato (illustration): Vc + Cb subject D3–A3 (50–57) in 8ths with a pickup; Vla answer A3–E4
  (57–64) while Vc runs a 16th countersubject; Vln II, then Vln I enter a 4th/5th higher; homophonic
  ff chords on the arrival.
