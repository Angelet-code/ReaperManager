---
id: orchestration.woodwind-basics-articulation-and-effects
title: Woodwind articulation, tonguing and extended techniques
aliases: [picado, picado suave, doble picado, triple picado, ligadura, staccato, frullato, Flatterzunge, flutter tongue, frulato, multifónicos, microtonos, chasquidos de llaves, key clicks, slap, pitidos, whistle tones, sonido de aire, glissando de clarinete, envolvente dinámica, fp, sordina de madera]
domain: orchestration
tags: [woodwinds, articulation, tonguing, slurs, extended-techniques, trills, tremolo]
style_scope: universal (extended techniques: late 20th c.)
use_when: Deciding how woodwind notes are attacked and connected (slurs, staccato, double/triple tonguing, fp envelopes) or writing flutter-tongue, glissando, key clicks, multiphonics and other effects.
summary: Unslurred wind notes are each tongued (separate attacks); a slur is one breath with only its first note tongued. Double/triple tonguing is idiomatic on flute and an emergency on reeds; fp and sf>p<f envelopes suit wind chords. Flutter-tongue is easy on flutes, clarinets and saxes, poor on oboe and bassoon; glissando only upward on clarinet and sax; other effects are soft, rare and must be described in words.
sources: ["adler-orq-es p.171-177", "piston-orch p.120-126"]
related: ["[[woodwind-basics]]", "[[flute-piccolo]]", "[[oboe-english-horn]]", "[[clarinets]]", "[[bassoons]]", "[[saxophones]]", "[[legato-overlap-and-attack-offsets]]", "[[_instruments]]"]
---

# Woodwind articulation, tonguing and extended techniques

## Core idea
The tongue starts a wind note ("tu"; softer "du") and can end it; the air carries the phrase. A wind attack is
never as imperceptible as a bow engaging a string (the clarinet comes closest). Slur marks define the
tonguing: what is not slurred is tongued.

| Marking | Meaning | MIDI rendering |
|---|---|---|
| none | each note tongued, detached, not short | small gap (≈ 5–10 % of the value), fresh attack |
| slur | one breath, first note tongued | overlap (legato patch) |
| dots | staccato, as short as possible | short notes, sharper velocity |
| slur + dots / lines | soft tonguing (≈ string louré), one breath | separate notes, soft attacks, no gap in CC11 |
| sfp, sf > p < f | hard attack, instant drop, optional re-swell | high velocity, CC1/CC11 drop within ~1/8 beat, ramp up |

## Rules
- R1 `MUST` render unmarked wind notes with their own attack and no overlap; slurred notes overlap (Piston).
- R2 `PREFER` more slurs for a smooth, soft character, more tonguing for a lively one.
- R3 `PREFER` tongue wide downward leaps rather than slurring them: a wide slur upward is easier than the same
  slur downward.
- R4 `ALLOWED` fast repeated single-tongued notes, but not for long stretches without a rest for the tongue.
- R5 `ALLOWED` double tonguing ("tu-ku") for fast duple repeated notes, triple tonguing ("tu-tu-ku") for
  fast triplets. `PREFER` flutes for long fast repeated-note staccato: on reeds the "k" is uneven (emergency
  only on oboe and clarinet). Wind chords pulsing in triplets are idiomatic (Mendelssohn 4, Wagner
  *Lohengrin* III).
- R6 `ALLOWED` fp and sf > p < f envelopes on sustained wind chords (Beethoven 1 opening).
- R7 `AVOID` wind tremolos of a 6th (8–9 st) or more: the lower note may not speak. Per-instrument limits are
  narrower: see each instrument note.
- R8 `ALLOWED` flutter-tongue (frullato, Flatterzunge): easy on flutes, clarinets, saxes; harder and less
  effective on oboe and bassoon. Long notes or whole passages; with a fast chromatic scale it whirrs (Ravel
  *La Valse*); in mass it hisses (Strauss *Salome*, Stravinsky *Rite*). Notate like unmeasured tremolo
  (three slashes) plus "frull." / "Flzg.".
- R9 `ALLOWED` glissando on clarinet and sax, upward only (Gershwin *Rhapsody*); other woodwinds bend at
  most a 2nd by embouchure. `AVOID` descending glissandi except between adjacent notes.
- R10 `ALLOWED` muffled sound by a cloth in the bell or a hand over it (oboe "con sordina", *Petrushka*);
  `NEVER` on the flute (no bell). Bells up (Mahler) makes oboes and clarinets strident.
- R11 `ALLOWED` slap tongue (clarinet, sax; possible on flute), key clicks (very soft, close-mic only),
  air sound, whistle tones (flute), multiphonics, microtones `[era: late 20th c.]`. `MUST` describe the
  effect in words in the score and print the fingering for multiphonics; `PREFER` them sparingly in
  orchestra.

## Period practice
- `[era: post-Boehm, mid-19th c. on]` any leap, trill or tremolo is possible in principle; earlier keywork
  limited chromatic trills.
- `[era: 20th c.]` flutter-tongue enters orchestral writing; `[era: late 20th c.]` multiphonics,
  microtones, key clicks, whistle tones (Berio *Sequenza*, Crumb).

## Apply in MIDI / REAPER
- Articulation map per wind track: legato (slurs), sustain/detached (unmarked), staccato (dots), flutter,
  trills. Without a detached patch, use sustain notes shortened to ~85–90 % of their value.
- Staccato length (inferred): oboe ≈ 35–45 %, clarinet ≈ 50–60 %, flute ≈ 40–55 % of the grid value.
- Repeated triplets/16ths at fast tempo: short articulation, velocity alternating ±8 to imitate t-k
  unevenness on reeds (inferred).
- Clarinet rise: fast run into the target, or a gliss/rip articulation if the library has one; no downward
  gliss.
- Effects without patches: flutter → flute flutter or tremolo patch if available, otherwise drop it; key
  clicks, air sound → a percussion/FX sample, very low level (inferred).
- Overlaps and slur velocities: [[legato-overlap-and-attack-offsets]].

## Checklist
- [ ] Unslurred notes have gaps and their own attacks; slurs overlap.
- [ ] No long fast repeated-note runs on oboe or bassoon; flutes take them.
- [ ] No wind tremolo ≥ 8 st; no descending gliss.
- [ ] Flutter-tongue not on oboe/bassoon unless intended; no flute "mute".
