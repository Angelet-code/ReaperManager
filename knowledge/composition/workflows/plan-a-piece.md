---
id: workflow.plan-a-piece
title: Plan a piece in a given form (before writing notes)
aliases: [planificar una obra, estructura, forma musical, plan tonal, componer un minueto, componer una sonata, tema con variaciones, rondó, fuga]
domain: workflow
tags: [workflow, form, planning, key-plan]
style_scope: common-practice (adaptable)
use_when: The user names a form (minuet, sonata, rondo, variations, fugue, waltz, march, chorale…) or asks for a piece whose structure must be decided before writing.
summary: "Choose the form note, fill its planning template (sections, bars, keys, material, cadence), check the phrase grammar, then turn the plan into REAPER regions and a per-bar harmony plan before writing any melody."
sources: ["zamacois-formas", "hindemith-2", "sonata-outline"]
related: ["[[compose-film-cue]]", "[[harmonize-and-voice]]", "[[_form]]"]
---

# Plan a piece in a given form

## 1. Pick the form note
Open [[_form]] and load the one form note that matches the request:
- small forms: [[binary-form]], [[ternary-form]];
- larger forms: [[rondo-form]], [[sonata-form]] (plus [[sonata-development-and-recap]]);
- dance and variation forms: [[minuet-scherzo-trio]], [[theme-and-variations]],
  [[ostinato-chaconne-passacaglia]], [[dance-types]], [[baroque-suite]];
- contrapuntal and multi-movement forms: [[fugue]] (+ [[school-fugue-plan]]), [[imitation-and-canon]],
  [[multi-movement-cycle]], [[concerto-form]];
- other genres: [[character-pieces]], [[overture-prelude-symphonic-poem]], [[song-aria-recitative]],
  [[sacred-vocal-forms]];
- for pop, rock or film songs: [[form-for-modern-songs]].

## 2. Fill the planning template
Every form note ends with a template `| section | bars | key | material | ends with |`. Fill it
completely. Then load [[key-plans-small-forms]] to confirm the key plan, and [[section-functions]] to
check what each section must do (stable, modulating, transition, retransition, coda).

## 3. Check the phrase grammar
Load [[phrase-structure]] and [[suspensive-conclusive-endings]]:
- each phrase has a suspensive then a conclusive ending where required;
- bar counts are square (4/8) unless an asymmetry from [[phrase-asymmetry]] is chosen on purpose;
- the pickup is not counted.

## 4. Harmonic plan per bar
Load [[cadences]] and [[harmonic-planning-seven-factors]]. Output one row per bar or per 2 bars:
`| bar | key | function/chord | tension 0–3 | density | voices |`. Load [[modulation]] for each key change
and [[secondary-dominants]] if you use them, sparingly.

## 5. Into REAPER
- Set tempo and meter, and create one region per section named after the template (e.g. `A (I)`,
  `B (V)`, `A'`).
- At the tempo, `seconds = bars × beats_per_bar × 60 / bpm`. Tell the user the total duration.

## 6. Write
Melody first, shaped by [[thematic-development]]. Then bass and harmony
([[harmonize-and-voice]]), then orchestrate ([[orchestrate-existing-material]]). Validate
([[validate-generated-midi]]).

## Checklist
- [ ] Every section has a key, a bar count and a closing cadence type.
- [ ] Home key at the start and the end; returns sound like returns (same material, home key).
- [ ] Contrast between sections comes from key, mode, texture or character, not only from new notes.
