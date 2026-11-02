---
id: meta.start-here
title: START HERE — composition knowledge router
summary: Entry point for any agent composing, arranging, harmonizing or orchestrating in REAPER. Maps the task to a workflow and to the few notes to load.
---

# START HERE

This vault distills harmony (Hindemith I–II), form (Zamacois), orchestration (UNIR course and class
notes) and film scoring (4-Day Challenge deck, Powell's *HTTYD* score) into small notes for agents that
write MIDI into REAPER through this repo's CLI and bridge. Conventions: [[conventions]] (C4 = MIDI 60;
rule strengths MUST/PREFER/AVOID/NEVER/ALLOWED).

## How to use it (budget)
1. Find the task below and open its **workflow**. Workflows say which notes to load at each stage.
2. Load notes **stage by stage**. A focused task (voicing, a range question, a modulation) needs 3–6
   notes. A whole cue or piece needs about 8–12, read across its stages: the **bold** note of each stage
   is required, the rest are on demand. Read the frontmatter `summary` first and the body only when the
   summary is not enough.
3. To look up an unknown term (often Spanish), grep the glossaries (see [[glossary]]) or the `aliases:` lines, or grep
   `index.json` (every note's id, aliases, use_when and summary; too big to read whole, ~40k tokens).
4. `sources/digests/` are raw page-by-page extractions. Open them only to verify a detail or when a note
   cites something you need in full.

## Precedence when rules conflict
1. The user's explicit request in the chat.
2. [[user-taste]]: validated by ear; it beats every book.
3. The style the user asked for. A rule's `style_scope` says where it is law. Common-practice voice
   leading (Hindemith) is law for chorales, classical pieces and orchestral pads. It is advice for
   film writing and does not apply to rock power chords.
4. Book rules: `MUST`/`NEVER` before `PREFER`/`AVOID`.
5. `(general knowledge)` and `(inferred)` statements: useful defaults with no source behind them.

## Task router
| The user asks… (ES) | Workflow | Core notes |
|---|---|---|
| "cue / música épica / de aventura / banda sonora" | [[compose-film-cue]] | [[harmony-emotion-mapping]], [[five-elements-arrangement-checklist]], [[orchestral-mockup-template]] |
| "canción / beat / arreglo / cover / balada / rock" | [[arrange-modern-song]] | [[user-taste]], [[form-for-modern-songs]], [[harmony-voicing-for-instruments]] |
| "un minueto / sonata / rondó / variaciones / fuga / vals / marcha" | [[plan-a-piece]] | the form note from [[_form]], [[phrase-structure]], [[cadences]] |
| "armoniza esta melodía / pon acordes / coral a 4 voces" | [[harmonize-and-voice]] | [[harmonizing-a-melody]], [[four-part-voices-and-spacing]], [[voice-leading-parallels]] |
| "voicings para cuerdas / metales / pad" | [[harmonize-and-voice]] (steps 2–4) | [[harmony-voicing-for-instruments]], [[chord-voicing-family-stacking]] |
| "orquesta esto / pásalo a orquesta / arreglo orquestal" | [[orchestrate-existing-material]] | [[orchestrate-from-piano-sketch]], [[texture-types]], [[doubling-colour-and-decay]] |
| "modula a… / cambio de tono / sube un tono el último estribillo" | — | [[modulation]], [[secondary-dominants]], [[cadences]] |
| "más tensión / clímax / build / que crezca" | — | [[building-and-releasing-climaxes]], [[dynamics-by-orchestration]], [[harmonic-planning-seven-factors]] |
| "ostinato / acción / persecución" | — | [[action-ostinato-pedal-gallop]], [[film-percussion-phrase-marking]] |
| "tema heroico / melodía principal" | — | [[heroic-theme-orchestration]], [[thematic-development]] |
| "¿qué rango tiene…? / ¿puede tocar…?" | — | the instrument note via [[_instruments]]; `data/instruments.json` |
| "reverb para orquesta / panorama / profundidad" | — | [[reverb-strategy-orchestral]], [[stage-seating-pan-depth]] |
| check or fix generated MIDI | [[validate-generated-midi]] | [[orchestration-errors-checklist]] |
| "obra para guitarra / guitarra clásica / trémolo / rasgueado / digitación" | [[plan-a-piece]] | [[classical-guitar-solo]], [[guitar-ample-performance]], [[user-taste]] (R18–R22) |

## Maps of content
- [[_workflows]]: procedures.
- [[_harmony]]: chords, voice leading, cadences, modulation, harmonic planning.
- [[_form]]: phrases, small and large forms, dances, fugue, vocal forms, modern song mapping.
- [[_orchestration]]: textures, balance, doubling, climaxes. Instrument notes are in [[_instruments]].
- [[_film-scoring]]: emotion → harmony, template, reverb, five elements, the HTTYD case study.

## Known gaps (no source in the vault)
Choir writing, guitar beyond the solo-classical notes (no book source yet: those notes come from the user's
feedback), hybrid/synth layers, jazz and modern harmony (quartal, chromatic mediants,
modal loops), species counterpoint, sync to picture and hit points, trailer structure, patch and
keyswitch maps of the user's libraries. Use general knowledge here, say so, and ask the user when it
matters. New books in these areas can be added with `_meta/digest-spec.md` → `_meta/synthesis-spec.md`.
