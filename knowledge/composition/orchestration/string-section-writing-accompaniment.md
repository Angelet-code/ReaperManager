---
id: orchestration.string-section-writing-accompaniment
title: Strings accompanying a soloist, and piano-to-strings transcription
aliases: [cuerda como acompañamiento de un solista, acompañamiento de cuerda, acompañar a un solista, acompañar la voz, transcripción de piano a cuerda, elemento, subelemento, peso sonoro, Streicherbegleitung]
domain: orchestration
tags: [strings, accompaniment, soloist, voice, transcription, piano-to-strings, texture]
style_scope: universal
use_when: Writing a string accompaniment under a vocal or instrumental soloist (aria, song, concerto slow movement, film solo), or turning a piano accompaniment into string parts.
summary: Pick one of five accompaniment templates (bass on the beat + off-beat chords; sustained harmony + violin ostinato; sustained harmony + legato violin arpeggios; cello rhythm + soft pizz.; tremolo chords over a low melody), keep it one or two dynamic steps under the soloist and out of the soloist's register, and build it from subelements with different rhythms. Piano chords become repeated or sustained string notes, broken figures become pizz. (light) or arco (sustained), and the bass goes to Vc with Cb pizz. for punctuation.
sources: ["adler-orq-es p.152-157", "adler-orq-es p.160", "adler-orq-es p.162", "piston-orch p.366-373", "piston-orch p.374-381"]
related: ["[[string-section-writing]]", "[[accompaniment-for-solo-line]]", "[[texture-accompanied-melody]]", "[[orchestrate-from-piano-sketch]]", "[[string-techniques-pizzicato-harmonics]]", "[[string-techniques-colour-effects]]", "[[tutti-balance-by-role]]", "[[song-aria-recitative]]"]
---

# Strings accompanying a soloist

## Core idea
Homogeneous colour, wide technique and a wide dynamic range make strings the default accompaniment for a
voice, an instrumental soloist, a choir or a wind group. The accompaniment is one **element** made of
**subelements** that differ in rhythm, register or articulation (Piston). Harmony of the accompaniment:
[[accompaniment-for-solo-line]]. Hub: [[string-section-writing]].

## Rules
- R1 `ALLOWED` Five templates (Adler):
  1. bass on the beat, upper strings on the off-beats, a cello obbligato above (Mendelssohn *Elijah*);
  2. long notes in Vla and Vc/Cb under a busy violin figure of repeated short notes, p → pp;
  3. sustained harmony (Vla double stops) + slurred violin triplet arpeggios (Vln I and II in parallel)
     + a simple bass on beats 1 and 3;
  4. cellos carry the dance rhythm, the other strings pizz. pp with the voice, basses tacet (Bizet,
     Habanera);
  5. ff tremolo chords in the upper strings over a low cello melody (doubled by winds/trumpet) and Cb
     pizz. on the downbeats: ominous, now a cliché (Bizet, *Carmen* Prelude).
- R2 `PREFER` Leave the voice unobstructed: soft, short or pizz. support, the rhythm in the low strings
  (Adler).
- R3 `PREFER` Keep the accompaniment one or two dynamic steps below the soloist and out of its register
  band (Adler, inferred).
- R4 `ALLOWED` Busy imitative staccato counterpoint pp under rapid declamation to depict frantic action
  (Adler, Mozart *Figaro*).
- R5 `ALLOWED` For a sombre background accompany with the low strings only (violas in unison with the first
  cellos); strings may double an organ (Adler, Fauré *Requiem*; the example is on missing pages).
- R6 `ALLOWED` Build the accompaniment from three subelements: sustained tones (winds or Vla), animated
  repeated-note harmony (Vla), and a lightly pulsed bass (Vc) (Piston, Schumann 1/II).
- R7 `MUST` When violins decorate the same melody a soloist plays plainly, keep them softer (pp against
  the solo p) and put rests in their figuration (Piston).
- R8 `PREFER` For a very light accompaniment: very little bow (*très léger*), basses out except for one
  note, overlapping figures that each taper (Piston, Debussy *La Mer*). A soft solo is heard over a big
  accompaniment if every accompanying part sits where it can play softly (Piston).
- R9 `PREFER` Light staccato strings under legato winds, and a tenuto bass line under a dry detached
  accompaniment to bind it (Piston).
- R10 `ALLOWED` An accompaniment on one pitch still drives the music when each group has its own rhythmic
  pattern (Piston, Mozart *Figaro* overture).
- R11 `ALLOWED` Solo/tutti contrast: an austere f *sempre staccato* string unison in octaves against a pp
  legato, harmonically rich soloist (Adler, Beethoven Piano Concerto 4/II).

## Piano to strings
The section opening on Adler's printed p.158–159 and 161 is missing from the scan; only these points
survive. For the full method see [[orchestrate-from-piano-sketch]].
- R12 `ALLOWED` Repeated piano chords become repeated string notes or chords with the same effect; at a
  fast tempo they sound consistent (Adler, Schubert *Rückblick*).
- R13 `PREFER` Accompaniments of repeated notes suit strings better than piano (Adler).
- R14 `ALLOWED` Two scorings of the same off-beat piano chords (Adler): (a) violins pizz., then arco fp;
  viola repeated eighths; cello slurred bass; Cb pizz. doubling; (b) all arco, repeated eighths in the inner
  parts, cello p < f, Cb only a pizz. sf downbeat.
- R15 `PREFER` Study a string passage by reducing it to four-part piano and comparing, to see where the
  doublings were added (Adler).

## Apply in MIDI / REAPER
- Soloist track (voice, SWAM or solo patch) at the marked dynamic; strings two steps lower: if the solo is
  mf (CC1 60–70), BG at p (CC1 30–40), shorts at velocity 45–60. User taste R15: an exposed solo sits about
  5 dB over its bed.
- Template 1: `Cb`/`Vc` short notes on beats (velocity 60–70), `Vln I/II`+`Vla` short chords on the
  off-beats (velocity 45–55), each chord tone on its own track or divisi track.
- Template 3: violin arpeggios on a legato patch, CC1 one step under the soloist, a breath gap at each
  harmony change; `Vla` long double stops on two divisi tracks; `Vc`/`Cb` quarters.
- Template 5: `Vln`/`Vla` tremolo patch ff (CC1 100+), melody on `Vc` 48–64, `Cb` pizz. downbeats.
- Keep the accompaniment's top note at least a 3rd below the soloist's current note, or above it only in a
  dull register (inferred from R2–R3).
- Piano transcription: right-hand chord → 2–4 string tracks (repeated or held), left-hand bass → `Vc` (+ `Cb`
  pizz. on structural downbeats), broken figures → pizz. for light, legato arco for sustained.

## Checklist
- [ ] The soloist's register band is free of accompaniment notes, or they sit in a dull register.
- [ ] Accompaniment 1–2 dynamic steps under the soloist.
- [ ] Subelements differ in rhythm (sustained, repeated, pulsed bass).
- [ ] Decorating violins are softer than the solo and have rests.
- [ ] Basses thinned or pizz. under a soft solo.
