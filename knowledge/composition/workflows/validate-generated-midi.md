---
id: workflow.validate-generated-midi
title: Validate generated MIDI before handing it to the user
aliases: [validar, revisar midi, comprobar rangos, checklist final]
domain: workflow
tags: [workflow, validation, ranges, voice-leading, qa]
style_scope: universal
use_when: After writing or editing any MIDI part, before telling the user it is ready.
summary: "Check ranges against data/instruments.json (full = error, practical = warning), then idiom limits, voice leading in chorale-like textures, balance and dynamics at arrivals, CC smoothness, and the build response."
sources: ["unir-orquestacion", "hindemith-1"]
related: ["[[orchestration-errors-checklist]]", "[[voice-leading-parallels]]", "[[user-taste]]"]
---

# Validate generated MIDI

Run these checks on the build spec (the `notes` lists) or on a `dump_midi` of the result.

1. **Ranges.**
   - Map each track to an instrument `id` in `knowledge/composition/data/instruments.json`.
   - A pitch outside `range_full` is an **error**.
   - A pitch outside `range_practical`, or a sustained or soft note inside a `weak_dynamics` zone, is a
     **warning**: fix it or justify it.
   - Unpitched percussion has `null` ranges; skip those.
   - Library quirks override the table: EZbass is written an octave up, and Ample Bass keyswitches sit at
     24–33 ([[user-taste]] R13). Check the playable range of each patch.
2. **Idiom limits.** Read the checklist section of each instrument's note ([[_instruments]]):
   - rests after high horn and trumpet passages;
   - breaths in winds;
   - harp pedal changes;
   - timpani pitches no more than the number of drums;
   - violin double stops are playable.
3. **Voice leading.** Applies to chorale, pad, brass-chorale and four-part textures. Run the parallel
   and hidden 5ths/8ves check from [[voice-leading-parallels]] on the outer voices first. Check spacing
   ([[four-part-voices-and-spacing]]) and the resolution of tendency tones.
4. **Orchestration errors.** Go through the codes in [[orchestration-errors-checklist]]:
   - forte arrivals have enough instruments;
   - piano arrivals are thinned;
   - no line is cut mid-motif;
   - no mud: [[bass-line-doubling]]'s low-chord check.
5. **Dynamics and CC.** CC1/CC11 curves must be smooth ramps, not steps. Entrances must sit below the
   section's climax. Velocity must vary per voice: no flat 100s ([[user-taste]] R2).
6. **Form.** The bar count per section matches the plan. Cadences fall where the plan says.
7. **Build response.** Every command reported success. No half-built tracks.

Report to the user only what matters: what was checked, anything you left on purpose, and the patches
to load.
