---
id: orchestration.texture-secondary-melody-countermelody
title: Secondary melody and countermelody
aliases: [melodía secundaria, contramelodía, contracanto, segunda voz melódica, respuesta, pregunta y respuesta]
domain: orchestration
tags: [texture, countermelody, secondary-melody, call-and-response]
style_scope: universal (examples from Beethoven and film)
use_when: Adding a countermelody under or around a main tune, or writing a horn/cello answer in the gaps of a melody.
summary: "The texture has three elements: main melody, secondary melody and accompaniment. A countermelody must differ from the main tune in register and rhythm (ideally in colour too) and moves mostly when the tune holds. In film writing the classic places are horns answering in the tune's gaps and a tenor-register bassoon/cello line under high violins."
sources: ["unir-orq-tema3 p.11", "film-4day-challenge slide 5", "httyd-test-drive p.2, p.6-8, p.14"]
related: ["[[texture-types]]", "[[line-separation-and-fusion]]", "[[texture-accompanied-melody]]", "[[texture-counterpoint]]", "[[dynamics-by-orchestration]]"]
---

# Secondary melody and countermelody

## Core idea
A secondary melody (countermelody) is a second melodic line, below the main tune in importance but above
the accompaniment. Its weight can vary, and the line between main and secondary may blur. It works only
if the ear can tell it apart from the tune (see [[line-separation-and-fusion]]).

## Rules
- R1 `MUST` Make the countermelody differ from the main melody in at least one main parameter
  (rhythm, register, colour), and preferably two.
- R2 `PREFER` **Complementary rhythm:** the countermelody moves when the tune holds a long note or rests,
  and holds when the tune moves.
- R3 `PREFER` Register: an octave or more away from the tune, usually below it, in the tenor register
  (MIDI 52–67) under a soprano tune.
- R4 `PREFER` Dynamic: one level below the main tune, or equal if the colours contrast strongly.
- R5 `PREFER` In long crescendos keep main melody, secondary melody and accompaniment all present, and
  add doublings to each (Beethoven 7/II).
- R6 `ALLOWED` (film) **Answers in the gaps:** horns play a short 1–2 bar phrase only where the main
  tune rests or holds (HTTYD b.9–11, b.27, b.36–39, b.63–65).
- R7 `AVOID` Parallel motion with the tune for more than 2–3 notes. It fuses into a harmony line (thirds
  or sixths) instead of a countermelody. That is allowed, but call it harmonisation.

## Apply in MIDI / REAPER
- Create a separate track named `CM <instrument>`, e.g. `CM HN` or `CM VC+BSN`.
- **Gap finder:** for each melody note with `len` ≥ 2 beats, and each rest of 1 beat or more, mark the
  window as available. Write the countermelody notes mainly inside these windows. Inside melody runs of
  8ths or 16ths, the countermelody holds a note (len ≥ 2 beats).
- **Register by melody position:**
  - Melody in 72–88 (violins or flutes): countermelody in `VC` + `BSN` at 50–67 or in `HN` at 55–72.
  - Melody in 60–72 (horns, cellos high): countermelody in `VLN I` at 76–88 (above) or `VC` at 43–55
    (below).
- **Dynamics:** countermelody CC1 = melody CC1 − 15. Horn answers use a swell: CC1 from 55 to 80 over
  the phrase and back down at its end.
- **Voice-leading checks:** fewer than 30 % parallel 3rds or 6ths with the melody, no parallel octaves
  or unisons with the melody, and no crossing above the melody (except brief, deliberate crossings).
- **HTTYD tenor-countermelody recipe:** high violins play repeated-note 16ths (79–91), `BSN a2` + `VC`
  play a lyrical line at 50–67 in half and quarter notes, and violas play a slower line between them.

## Checklist
- Does the countermelody differ from the melody in rhythm, register or colour (at least one)?
- Does it move mostly when the melody holds?
- Is it at least an octave away from the melody's register centre, or in a clearly different family?
- Is its CC1 below the melody's, unless the colours contrast strongly?
- Are there no parallel octaves or unisons with the melody?

## Examples
- Melody A4–B4–C#5–D5 in half notes (`VLN I`). The `CM HN` line answers with 8th-note movement
  F#3–G3–A3–B3 during each half note, then holds A3 while the violins move.
- HTTYD b.27: when the tune holds a G chord, the horns take over with a descending countermelody, and a
  harp glissando fills the space.
