---
id: orchestration.orchestrate-from-piano-sketch
title: Orchestrating from a piano sketch or MIDI reduction (step by step)
aliases: [cómo orquestar una obra, orquestar una obra de piano, orquestar desde reducción, reducción de piano, boceto, elaboración sonora, plantilla, líneas discursivas, factura]
domain: orchestration
tags: [method, workflow, piano-reduction, melody-bass-filler, spacing]
style_scope: universal (UNIR method for orchestrating an existing piano piece; also fits original sketches)
use_when: Turning a piano piece, a piano-roll sketch or a one-track MIDI reduction into an orchestral MIDI arrangement in REAPER.
summary: Analyse from the top down (form, then phrases, then motives), tag every voice as melody, bass or filler, measure the original's spacing, then pick the line-up and assign each line by range, agility and colour. Write dynamics per line, build crescendi with instrumentation, and finish with ensemble checks. For an existing piece, never invent notes, sections or dynamics.
sources: ["unir-orq-tema2 p.4-10", "unir-orq-tema3 p.5", "unir-orq-tema1 p.4-15"]
related: ["[[texture-types]]", "[[texture-accompanied-melody]]", "[[orchestra-sizes-and-section-balance]]", "[[orchestration-errors-checklist]]", "[[dynamics-by-orchestration]]", "[[transposing-instruments]]", "[[_instruments]]"]
---

# Orchestrating from a piano sketch or MIDI reduction

## Core idea
Orchestration = sound imagination + technique, aiming at **instrumental clarity** (each part playable
and well placed) and **discursive clarity** (lines whole, balance right). The piano original already
contains three discursive lines: **melody, bass and filler**. The job is to find them and give each to
instruments.

## Rules
- R1 `MUST` Analyse before writing, from the top down: form → phrases → their blocks → motivic cells.
- R2 `MUST` Reproduce the piano's register layout (each voice's register and the overall spacing:
  *factura ancha* = wide, *estrecha* = narrow) unless you widen it on purpose.
- R3 `NEVER` (arranging an existing piece) Invent notes, articulations, dynamics, sections or phrases.
  For an original sketch, the composer may add lines; tag them as new.
- R4 `MUST` Assign each line by range, agility and sound possibilities of the instrument.
- R5 `ALLOWED` Octave doubling and sharing a line between instruments, but `AVOID` fragmenting motives
  or leaving lines cut.
- R6 `MUST` Each line carries its own dynamics and articulations.
- R7 `MUST` Make crescendi and diminuendi by adding or removing instruments.
- R8 `AVOID` Horror vacui: not every instrument plays all the time.

## Apply in MIDI / REAPER (procedure)
1. **Read the sketch** (`dump_midi` on the piano track). Mark phrase boundaries as project markers
   (`A1`, `A2`, `B1`…).
2. **Tag voices:**
   - Split notes into streams (melody = top salient line, bass = lowest line, filler = everything else).
   - Store the stream per note (a name prefix or a separate scratch track: `SK MEL`, `SK BASS`,
     `SK FILL`).
3. **Measure spacing:** per phrase, record `lowest bass`, `highest melody`, span in semitones, and the
   filler's band. Narrow = span < 24; wide = > 36.
4. **Classify texture** per phrase (see [[texture-types]]) and write it into the marker name.
5. **Choose the line-up** (see [[orchestra-sizes-and-section-balance]]) and create tracks in score
   order: woodwinds, brass, percussion, keys/harp, strings. Folder per family; colour per family.
6. **Assign lines** (first pass, accompanied melody):
   - Melody → one colour that fits its range (vln 55–88, fl 72–93, ob 62–86, cl 50–84, hn 53–72,
     vc 48–69).
   - Bass → `VC` + `CB` (−12) (+ `BSN`).
   - Filler → violas and Vln II, or woodwind pairs, or horns for sustained filler.
   - Keep each voice's octave from the sketch (R2). Move it only when the instrument's range forces it,
     and then move the whole phrase.
7. **Translate piano idioms:**
   - Sustain-pedal arpeggios → string sustains + harp arpeggio.
   - Repeated chords → short string chords (spiccato) or woodwind repeated notes.
   - Octave bass → Vc + Cb.
   - Alberti bass → violas or Vln II broken-chord 8ths.
   - Wide LH leaps → split between Vc (top) and Cb (bottom).
8. **Dynamics:** write CC1 per track from the sketch's dynamics (map in
   [[dynamics-by-orchestration]]). The melody is one level above the filler. Add crescendo layers.
9. **Second pass, colour:** change the melody's instrument at phrase repeats, add doublings with a
   reason (see [[doubling-colour-and-decay]]), and give tutti only to the climax.
10. **Ensemble checks:** run [[orchestration-errors-checklist]]. Compare the global sonority with the
    sketch (render both and listen to the A/B).

## Checklist
- Is every note of the sketch present in some track (unless it was deliberately dropped filler)?
- Does every phrase keep the sketch's register layout (span within ±12 semitones of the original)?
- Is every track inside its range and assigned by agility (no fast runs on tuba, contrabassoon or
  low horn)?
- Does every track have CC1/velocity dynamics?
- Are crescendi built by entries, not only by CC?
- Is there no instrument playing all the time without a reason?

## Examples
- Adagio in F (UNIR): narrow spacing, melody upper staff, filler repeated 8th chords, half-note bass →
  melody Vln I (later Oboe I + Bassoon I an octave below), filler Vln I/II/Va staccato 8ths at mp, bass
  Vc + Cb at mp; flute, clarinet, horn and timpani rest.
