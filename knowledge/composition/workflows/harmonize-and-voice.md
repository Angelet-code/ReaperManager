---
id: workflow.harmonize-and-voice
title: Harmonize a melody or turn a progression into voiced parts
aliases: [armonizar, armonizar una melodía, voicings, voces, coral a cuatro voces, progresión de acordes, acordes para cuerdas, pad]
domain: workflow
tags: [workflow, harmony, voicing, voice-leading]
style_scope: common-practice core, adaptable to film/pop
use_when: The user gives a melody to harmonize, a chord progression to voice for instruments, a bass to realise, or asks for a chorale/pad/brass chord part.
summary: "Choose the harmony (melody → chords via cadence points first), then voice it in four real parts with correct spacing and voice leading, then adapt the voicing to the target instruments and check parallels and ranges."
sources: ["hindemith-1", "hindemith-2"]
related: ["[[plan-a-piece]]", "[[validate-generated-midi]]", "[[_harmony]]"]
---

# Harmonize and voice

## 1. Decide the chords
- **From a melody:** follow [[harmonizing-a-melody]]. Fix the cadence points first ([[cadences]]), then
  the main harmonies, then the passing ones. Non-harmonic melody notes: [[non-chord-tones]].
- **From a bass:** [[figured-bass-reading]].
- **For an accompaniment under a solo line:** [[accompaniment-for-solo-line]].
- **Colour:** add [[secondary-dominants]], [[mode-mixture-and-neapolitan]],
  [[augmented-sixth-chords]] or [[diminished-seventh-pivot]] only where tension is planned. Ration
  them; Hindemith warns that overuse sounds cheap.

## 2. Voice in four real parts (the "chorale core")
Load [[four-part-voices-and-spacing]], [[doubling-rules]], [[voice-leading-basics]]. For sevenths,
also [[dominant-seventh]] and [[diatonic-seventh-chords]]. Produce SATB as MIDI numbers per chord.

## 3. Check the voice leading
Run the algorithm in [[voice-leading-parallels]] for parallel and hidden 5ths/8ves, outer voices first.
Pick the mode by request:
- **strict:** a school chorale or exercise;
- **relaxed:** "estilo clásico", string quartet or orchestral writing;
- **planing:** pop, rock or film colour layers. Also check that no voices cross and that tendency tones resolve: the leading tone rises
and the 7th falls.

## 4. Adapt to instruments
Load [[harmony-voicing-for-instruments]] and, for mixed families, [[chord-voicing-family-stacking]]:
- spread wider at the bottom, and no close thirds below about MIDI 48;
- strings: divisi as needed ([[string-techniques]]);
- brass: horns in 53–72 ([[horn]]), low brass on roots/fifths ([[trombone]], [[tuba]]);
- piano/keys: idiomatic, with rolls, pedal and a singing top voice ([[user-taste]]).

## 5. Style scope
Common-practice rules are laws for chorale, classical and orchestral-pad textures. In rock or metal,
parallel fifths (power chords) and planing are idiomatic. In film writing, keep the outer voices clean
but allow parallel motion in inner and colour layers. Each harmony note says how strict it is under
"Outside this style".

## 6. Validate
[[validate-generated-midi]].
