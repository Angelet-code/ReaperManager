---
id: workflow.orchestrate-existing-material
title: Orchestrate existing material (piano sketch, MIDI, song)
aliases: [orquestar, orquestar una pieza, arreglo orquestal, pasar a orquesta, orquestación de un boceto]
domain: workflow
tags: [workflow, orchestration, arrangement]
style_scope: universal
use_when: The user has a piano sketch, a MIDI reduction, a lead sheet or an existing song section and wants it played by orchestra or by a larger ensemble.
summary: "Dump the source MIDI, analyse it into melody / bass / harmonic filler per section, choose a texture per section, assign families and doublings, write idiomatic parts per instrument, then check balance and ranges."
sources: ["unir-orquestacion", "film-4day-challenge"]
related: ["[[compose-film-cue]]", "[[validate-generated-midi]]", "[[_orchestration]]"]
---

# Orchestrate existing material

1. **Read the source.** Dump the existing MIDI from REAPER (bridge `dump_midi`) or ask for the chart.
   Never guess the harmony from colour voicings ([[user-taste]] R8).
2. **Analyse.** Follow [[orchestrate-from-piano-sketch]] steps 1–3. Split into melody, bass and
   filler, mark sections and dynamics, and note the climax.
3. **Texture per section.** [[texture-types]] classifies the section. Then load only the matching
   texture note:
   - [[texture-accompanied-melody]];
   - [[texture-secondary-melody-countermelody]];
   - [[texture-part-writing-chorale]];
   - [[texture-counterpoint]];
   - [[texture-unison-and-tutti]];
   - [[texture-complex-mosaic]].
4. **Assign families.** Use [[orchestra-sizes-and-section-balance]] to size the ensemble and pick patch
   sizes, and [[chord-voicing-family-stacking]] for chords shared between families.
5. **Doublings.** Apply [[doubling-colour-and-decay]] and [[bass-line-doubling]]. Use
   [[line-separation-and-fusion]] when two lines must stay distinct.
6. **Write idiomatic parts.** Check each instrument note before writing for it ([[_instruments]]).
   Respect breathing, rests after high brass, string crossings and harp pedals.
7. **Dynamics.** Use [[dynamics-by-orchestration]]: crescendo by adding instruments, and CC1/velocity
   maps. Shape climaxes with [[building-and-releasing-climaxes]].
8. **Template and space.** Use [[orchestral-mockup-template]], [[stage-seating-pan-depth]] and
   [[reverb-strategy-orchestral]].
9. **Validate.** Run [[validate-generated-midi]] and the [[orchestration-errors-checklist]].
