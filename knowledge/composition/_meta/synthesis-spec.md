---
title: Topic note synthesis spec (stage 2)
purpose: Instructions for agents that turn source digests into atomic topic notes.
---

# Topic note synthesis spec

You turn stage-1 digests (`knowledge/composition/sources/digests/*.md`) into **atomic topic notes**:
one note = one concept an agent can load on its own to do one kind of task.
Read `_meta/conventions.md` first and follow its schema exactly.

## Principles
1. **Organise by task/topic, not by book.** Merge what several digests say about the same topic into
   one note. Cite every source in `sources`.
2. **Actionable over descriptive.** An agent reads a note right before writing MIDI. Every note must let
   it decide something or check something. Theory without a use goes away.
3. **Progressive disclosure.** `summary` answers 80 % of the need in two sentences; `Rules` give the
   rest; `Examples` only when they clarify. Agents load 3–6 notes per task, so each note must be small
   and self-sufficient, linking to prerequisites instead of repeating them.
4. **Precise and testable.** Semitones, MIDI numbers, bar counts, proportions, velocity ranges.
5. **Bridge to production.** In `Apply in MIDI / REAPER`, translate the rule into what a MIDI generator
   does: which pitches, which voices on which tracks, articulation choice, CC1/CC11 shapes, velocity.
   The project writes MIDI as `{pitch, beat, len, vel}` lists plus linear CC ramps (see
   `reaper/rm_beat_builder.lua` header comments if you need detail). Sample libraries are used
   (e.g. Spitfire Albion ONE: strings, brass low/mid/high, woods; percussion libraries).
6. **Mark scope honestly.** Hindemith = common-practice tonal harmony; Zamacois = classical/romantic
   forms; UNIR + class notes = orchestration; film deck + HTTYD = modern film scoring. When a rule is
   style-bound, say so in `style_scope` and, if useful, add a one-line "Outside this style" remark.
7. **Paraphrase.** No passages copied from the books; your own words and your own short examples.
8. **No invention dressed as source.** You may add widely accepted knowledge to fill an obvious gap,
   but mark such rules `(general knowledge)` so they are not attributed to the books. Keep it modest.
9. **Conflicts:** if two sources disagree, keep both, attribute each, and state which applies when.

## Deliverables (in the folder you are given)
- The topic notes (`<kebab-name>.md`), unique file names across the vault.
- The folder map-of-content `_<folder>.md` (see conventions): a table `| note | use_when | summary |` grouped by sub-topic, plus a short
  "reading order for beginners" list (which 3–5 notes give the backbone of the domain).
- `knowledge/composition/_meta/glossary-<domain>.md`: table `| Spanish | English | German/other | note |`
  with every term an agent might see in a Spanish request (e.g. "acorde de sexta napolitana",
  "nota de paso", "puente", "reexposición", "divisi", "con sordina").
- `knowledge/composition/sources/<source_id>.md` for the sources you own: a short card with
  bibliographic info, scope, reliability, the chapter → note map, and the digest file names.

## Final reply
List the notes you created with one line each, anything from the digests you deliberately dropped and
why, and any gaps you noticed (topics the books cover poorly that an agent will likely need).
