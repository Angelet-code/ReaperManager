---
id: orchestration.texture-secondary-melody-countermelody
title: Secondary melody and countermelody
aliases: [melodía secundaria, contramelodía, contracanto, segunda voz melódica, respuesta, pregunta y respuesta, obbligato, obligado, voz principal, voz secundaria, Hauptstimme, Nebenstimme, Gegenstimme, contramelodía canónica, planos sonoros]
domain: orchestration
tags: [texture, countermelody, secondary-melody, call-and-response, sound-planes]
style_scope: universal (Mozart to film)
use_when: Adding a countermelody under or around a main tune, writing a horn/cello answer in the gaps of a melody, or balancing a three-element texture (melody, secondary melody, accompaniment).
summary: "Piston's type III has three elements: main melody, secondary melody (obbligato or an equal theme) and accompaniment. Make the two melodic lines differ in colour, contour and rhythm (move when the tune holds) and give the three elements different rhythms and dynamics. The secondary line sits about one level below the main one and never above it in level; the main tune can win while outnumbered thanks to a high register and having been heard first."
sources: ["unir-orq-tema3 p.11", "film-4day-challenge slide 5", "httyd-test-drive p.2, p.6-8, p.14", "piston-orch p.374-381", "adler-orq-es p.586-590, 595-596"]
related: ["[[texture-types]]", "[[line-separation-and-fusion]]", "[[texture-accompanied-melody]]", "[[texture-counterpoint]]", "[[dynamics-by-orchestration]]", "[[tutti-balance-by-role]]", "[[texture-unison-and-tutti-layouts]]"]
---

# Secondary melody and countermelody

## Core idea
A secondary melody is a second melodic line, below the main tune in importance but above the
accompaniment. It may be a subordinate **obbligato** (countermelody) or a line of equal thematic weight;
which is primary can be a matter of taste (Piston). It works only if the ear can tell it from the tune
(see [[line-separation-and-fusion]]).

## Rules
- R1 `MUST` Make the countermelody differ from the main melody in at least one main parameter (rhythm,
  register, colour), preferably two; Piston adds melodic outline.
- R2 `PREFER` **Complementary rhythm:** the countermelody moves when the tune holds or rests, and holds
  when the tune moves. Give the accompaniment a third rhythm: three rhythms let a sustained secondary line
  stand out even with the tune sounding above and below it (Beethoven 7/II, Piston).
- R3 `PREFER` Register: an octave or more from the tune, usually below it, in the tenor register
  (52–67) under a soprano tune.
- R4 `PREFER` Dynamic: one level below the main tune (Schoenberg marks the Hauptstimme a level above the
  Nebenstimmen), or equal if the colours contrast strongly. `AVOID` raising a background line above the
  main one (Piston criticises conductors who "bring out" inner voices).
- R5 `ALLOWED` The main melody can dominate while outnumbered: a high register, energetic bowing and
  having been heard first let Vln I beat five doubled woodwinds (Mozart K. 543).
- R6 `ALLOWED` Hold the obbligato back: let it enter only after some bars of the accompaniment (Mozart:
  after 7 bars of held wind chords).
- R7 `ALLOWED` The secondary melody may be the tune itself in canon (octave canon one beat later,
  Berlioz); the first entry keeps slight precedence. It may also be a stream of parallel chords
  (Milhaud: parallel 6/4 chords in strings).
- R8 `PREFER` In long crescendos keep all three elements present and add doublings to each (Beethoven
  7/II).
- R9 `ALLOWED` (film) **Answers in the gaps:** horns play a 1–2 bar phrase only where the tune rests or
  holds (HTTYD b.9–11, 27, 36–39, 63–65).
- R10 `AVOID` Parallel motion with the tune for more than 2–3 notes: thirds or sixths fuse into
  harmonisation of one element (Piston), not a countermelody.
- R11 `MUST` In a dense texture give each line to an instrument or group that can be heard there; double a
  line that sits in a weak register among many voices (Adler, Piston).

## Apply in MIDI / REAPER
- Create a separate track `CM <instrument>`, e.g. `CM HN` or `CM VC+BSN`.
- **Gap finder:** mark each melody note with `len` ≥ 2 beats and each rest ≥ 1 beat as a window; write the
  countermelody mainly inside them. Under 8th/16th runs of the tune, the countermelody holds (len ≥ 2).
- **Register by melody position:**
  - melody in 72–88 (violins or flutes): countermelody in `VC` + `BSN` at 50–67 or `HN` at 55–72;
  - melody in 60–72 (horns, cellos high): countermelody in `VLN I` at 76–88 or `VC` at 43–55.
- **Dynamics:** countermelody CC1 = melody CC1 − 15 (about one level); measured target about 3 dB under
  the melody (user-taste R15). Horn answers swell CC1 55 → 80 → back down over the phrase.
- **Three planes** (Rimsky, *Scheherazade* IV, Adler): foreground = Vc high + 2 Hn unison + 2 Cl 8va;
  middleground = picc/fl a2 + violins on fast repeated-note spiccato, p; background = sustained Ob, Bsn,
  Hn 3–4, Va, Cb with a light arpeggio; harp only at phrase seams.
- **HTTYD tenor countermelody:** high violins on repeated-note 16ths (79–91), `BSN a2` + `VC` lyrical
  half/quarter notes at 50–67, violas a slower line between.
- **Voice-leading lint:** < 30 % parallel 3rds/6ths with the melody, no parallel octaves or unisons, no
  crossing above the melody except brief deliberate ones.

## Checklist
- Does the countermelody differ from the tune in rhythm, register or colour (at least one)?
- Do melody, countermelody and accompaniment have three different rhythms?
- Is the countermelody's CC1 below the melody's, unless the colours contrast strongly?
- Does it move mostly when the melody holds?
- No parallel octaves or unisons with the melody?

## Examples
- Melody A4–B4–C#5–D5 in half notes (`VLN I`); `CM HN` answers in 8ths F#3–G3–A3–B3 during each half
  note, then holds A3 while the violins move.
- Mozart K. 543/II: Vln I melody in dotted rhythms; legato Fl + Cl + Bsn obbligato in octaves; Vln II div
  + Va repeated-note harmony; Vc + Cb bass.
- Beethoven 7/II: winds and horns on the theme in four octaves, Vln I sustained legato countermelody,
  lower strings on the triplet-pickup accompaniment.
