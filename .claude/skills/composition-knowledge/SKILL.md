---
name: composition-knowledge
description: Load the distilled harmony, form, orchestration and film-scoring knowledge (Hindemith, Zamacois, UNIR orchestration course, film-scoring deck, HTTYD score) before composing, arranging, harmonizing, voicing or orchestrating music in REAPER. Use for any request to write or fix musical content (cue, song, beat, chords, melody, strings/brass parts, form, modulation, instrument ranges), e.g. "componme un tema épico", "armoniza esta melodía", "orquesta esto", "haz un minueto", "¿qué rango tiene la trompa?".
---

# Composition knowledge

The vault is in `knowledge/composition/` (Obsidian markdown written for agents).

1. Read `knowledge/composition/START-HERE.md`. It gives the task router, the precedence rules and the
   reading budget.
2. Open the workflow the router names (`knowledge/composition/workflows/`) and follow it stage by stage.
   Load only the notes each stage lists, usually 3–6 in total. Read a note's frontmatter `summary`
   first and the body only if needed.
3. Always apply `workflows/user-taste.md`: the user's ear-validated preferences beat book rules. The
   latest detail lives in project memory (`music-arrangement-principles`, `beat-making-preferences`).
4. Wikilinks `[[name]]` resolve to `name.md` anywhere under `knowledge/composition/`:
   `Glob knowledge/composition/**/name.md`.
5. For unknown Spanish terms, grep `knowledge/composition/_meta/glossary-*.md` or `aliases:` lines.
   Never read `index.json` whole; grep it.
6. Pitch convention: C4 = MIDI 60, concert pitch. Ranges per instrument are in
   `knowledge/composition/data/instruments.json` (full range = error, practical range = warning).
7. Before handing music to the user, run `workflows/validate-generated-midi.md`.

REAPER mechanics (status, build_beat specs, Kontakt loading, session safety) still follow the project's
`AGENTS.md`.
