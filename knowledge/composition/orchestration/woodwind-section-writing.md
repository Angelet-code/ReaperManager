---
id: orchestration.woodwind-section-writing
title: Woodwind section writing (functions, melody, counterpoint, articulation)
aliases: [escritura para maderas, escritura para la sección de madera, funciones de la madera, sección de madera, unísono de maderas, duplicación al unísono, duplicación a la octava, a 2, a2, solo de madera, pares de octava, expansión de registros, color característico, color como personaje, contrapunto en las maderas, escritura contrapuntística para la madera, unísono pulsante, combinación de articulaciones, Holzbläsersatz]
domain: orchestration
tags: [woodwinds, section-writing, melody, doubling, counterpoint, articulation, colour]
style_scope: universal (Classical to 20th c.; period-bound rules are era-tagged)
use_when: Deciding what the woodwind section does in a passage, or scoring a woodwind melody or woodwind counterpoint (solo vs a2, octave pairs, colour pairs, leitmotif colour, pulsing or mixed articulation).
summary: Strings are the continuous, homogeneous base; woodwinds are heterogeneous and get one function at a time (solo, harmonic background, colour contrast, doubling). Keep solos single (same-instrument unison only in tutti or fugal entries), reinforce by octave pairs of changing colour rather than unison, choose unison pairs by blend (Fl+Ob round, Ob+Cl mysterious, Fl+Cl ≈ clarinet alone at 70–78, bassoon an octave below anything), and keep each motive's colour fixed.
sources: ["adler-orq-es p.229-243", "adler-orq-es p.261-270", "adler-orq-es p.283-290", "piston-orch p.426-430", "piston-orch p.436-437"]
related: ["[[woodwind-section-writing-chords]]", "[[woodwind-section-writing-with-strings]]", "[[woodwind-basics]]", "[[woodwind-basics-articulation-and-effects]]", "[[doubling-colour-and-decay]]", "[[doubling-colour-and-decay-section-pairings]]", "[[texture-counterpoint]]", "[[line-separation-and-fusion]]", "[[string-section-writing]]", "[[brass-section-writing]]", "[[flute-piccolo]]", "[[oboe-english-horn]]", "[[clarinets]]", "[[bassoons]]"]
---

# Woodwind section writing

## Core idea
Strings are homogeneous and play almost all the time; woodwinds are four colours that enter for a
reason. Adler's **four functions**: **solo** (melody, fragment, figure), **harmonic background**, **colour
contrast** (echo, answer, split passage), **doubling**. Chords and pedals:
[[woodwind-section-writing-chords]]; with strings: [[woodwind-section-writing-with-strings]].

## Rules
**Function and solo**
- R1 `PREFER` name one function for every woodwind passage; if none fits, rest the winds.
- R2 `AVOID` doubling a solo with a second player of the same instrument (2 Fl, 2 Ob…): imperfect
  tuning, thicker tone, changed colour, lost rubato (Adler; [[user-taste]] R15).
- R3 `ALLOWED` a2 unison in tutti, where volume matters more than solo colour, and on fugal entries that
  want a fuller line (Britten).

**Melody: unison pairs and octave pairs**
- R4 `PREFER` reinforce a wind line at the octave (organ 8' + 4') rather than in unison; unison mostly
  changes colour, like a mute.
- R5 Unison colour pairs on a treble tune:

| Pair | Result | Strength |
|---|---|---|
| Fl + Ob | oboe leads, flute rounds its nasal edge: round, rich | `PREFER` |
| Ob + Cl, pp, middle register | mysterious, slightly unstable (Schubert 8/I) | `ALLOWED` on purpose |
| Fl + Cl around 70–78 | clarinet almost alone, flute adds little body | `AVOID` if both must be heard |
| Bsn 8vb under Fl, Ob or Cl | every octave pairing sonorous | `PREFER` |
| Fl + Cl + Bsn over three octaves | Mozart's favourite wind colour | `PREFER` |

- R6 `PREFER` relay a long tune through **octave pairs of changing colour** every 2–4 bars over an unchanged
  accompaniment (Rossini: Cl+Bsn → Cl+Hn → Fl+Ob → Picc+Ob).
- R7 `AVOID` spreading a theme's first statement over octaves when the build relies on **register
  expansion**: start in unison, widen at the build and the climax (Schubert 8/I).
- R8 `PREFER` bring a doubler in "under cover": it joins in unison during a crescendo and is only heard
  when it takes the top notes of the cadence. `ALLOWED` a partial doubling (Fl 8va for a few bars) for
  variety (Piston).

**Colour as character and form**
- R9 `PREFER` give each main theme its own colour, and tie a recurring motive or leitmotif to **one fixed
  instrument or group** for every return (Debussy, Berlioz).
- R10 `PREFER` keep a signature colour out of the contrasting middle section so its return marks the
  reprise (English horn in *Nuages*, A–B–A).

**Counterpoint**
- R11 `PREFER` woodwinds for independent lines, especially rhythmic ones: their distinct colours keep lines
  apart. Write each gesture in the best register of its instrument (Stravinsky).
- R12 `PREFER` fugal exposition high to low, a2 per entry, rising dynamic: Picc p → Fl → Ob → Cl → Bsn ff
  (Britten, *Young Person's Guide*).
- R13 `PREFER` split a repeated ornament (grace notes) between two players of one instrument, alternating:
  no one tires, and slightly different attacks keep it fresh (Stravinsky).
- R14 `ALLOWED` `[era: 20th c.]` "night sounds": each wind its own ostinato with a different tuplet (3, 5,
  6, 10), exactly notated; the overlaps sound free (*Rite*, Part I intro).

**Articulation and effects**
- R15 `ALLOWED` **pulsating unison**: one wind holds, a second repeats the same pitches in 2s or 3s
  (portato). `PREFER` contrasting colours (Fl held + Ob pulsing): low down, the oboe stands out (Debussy,
  *La Mer* III).
- R16 `ALLOWED` **mixed articulation**: one wind slurs a gesture while another tongues it, like Vln I arco +
  Vln II pizz. `PREFER` keeping fully slurred only the cantabile melody and one characteristic figure
  (Stravinsky, *Psalms*).
- R17 `PREFER` extended effects (multiphonics, quarter tones, reed only, top note + trill) in solo or
  chamber writing, explained at the start of the score. `[era: late-20th-c. avant-garde]` multiphonic
  catalogues depend on the instrument's make. See [[woodwind-basics-articulation-and-effects]].

## Period practice
- `[era: textbook tradition]` Ob + Cl unison banned (oboe masks clarinet, balance, tuning). Adler breaks
  it with Schubert; today's default is R5.
- `[era: Classical–early Romantic]` octave-pair relays (R6) are the light-allegro tune colour.
- `[era: 19th c.]` character instruments in symphonic poems (Berlioz's clarinet, Strauss's horn).

## Apply in MIDI / REAPER
- One track per player (`FL 1`, `OB 1`…); an exposed solo is one solo/SWAM track. An ensemble woods patch
  is an a2 or a colour mix (check its contents, inferred): tutti or R3 entries only.
- **Octave pair:** copy the whole phrase ±12 to the partner track (never fold single notes); partner CC11
  5–10 below the lead. Relays: switch pairs at phrase ends, overlap one note.
- **Unison pair:** same notes on two tracks, humanized separately (±5–10 ms).
- **Pulsating unison:** `FL` long legato notes; `OB` same pitch as 2–3 notes per flute note, each ~85 % of
  its slot, velocity ±4, both CC11 about 30–50 (pp–p).
- **Mixed articulation:** duplicate the figure; one track legato (30–50 ms overlaps or a legato patch), one
  staccato (len 0.25–0.4 of the slot).
- **Fugal entries:** CC1/velocity +10–15 per entry, from ~40 to ~100.
- **Breaths:** legato wind phrases break about every 8 s with a 220 ms gap ([[user-taste]] R17).

## Checklist
- [ ] Every woodwind passage has one named function.
- [ ] No same-instrument unison on a solo line outside tutti or fugal entries.
- [ ] Reinforcement by octave unless a unison colour was chosen on purpose.
- [ ] No Fl + Cl unison at 70–78 that relies on hearing the flute.
- [ ] Motive colour constant across returns and absent from the contrast section.
- [ ] Registral widening saved for the build/climax.
- [ ] Each contrapuntal line in its instrument's best register.
