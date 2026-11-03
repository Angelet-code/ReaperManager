---
id: meta.conventions
title: Vault conventions
summary: Pitch numbering, rule-strength keywords, note schema and linking rules every note in this vault follows.
---

# Vault conventions

## Pitch and time
- **C4 = middle C = MIDI 60.** A4 = 69 = 440 Hz. Octave numbers change at C (B3 = 59, C4 = 60).
  REAPER can display middle C as C3 or C5 depending on preferences; always reason in MIDI numbers.
- Intervals are given as name + semitones: m3 (3), M3 (4), P4 (5), tritone (6), P5 (7), m6 (8), P8 (12).
- Ranges are **sounding (concert) pitch** unless marked `written`. MIDI is always written at concert
  pitch; transposition only matters when reading or producing parts.
- Time in the project's MIDI builder (`reaper/rm_beat_builder.lua`): `beat` = quarter notes from the item
  start (0-based), `len` in quarter notes, positions of items in 1-based bars. Velocity 1–127.
  CC1 (modwheel, usually dynamics/xfade in sample libraries), CC11 (expression), CC64 (sustain).

## Rule strength
Rules are bulleted with an ID and one keyword:
- `MUST` / `NEVER`: breaking it produces a recognised error in the style the note covers.
- `PREFER` / `AVOID`: default choice; break it on purpose, for an effect.
- `ALLOWED`: a licence that relaxes another rule (always links to it).
Every rule states the **style scope** through the note's `style_scope` (common-practice harmony rules
are not laws for film, pop or metal; see [[START-HERE]] for precedence).

## Note schema
Every topic note has YAML frontmatter:

```yaml
id: harmony.voice-leading-parallels   # domain.slug, unique
title: Parallel fifths and octaves
aliases: [quintas paralelas, octavas paralelas, Quintenparallelen]   # Spanish/German terms for lookup
domain: harmony | form | orchestration | film-scoring | performance | workflow | meta
tags: [voice-leading, four-part]
style_scope: common-practice | romantic | film | universal | ...
use_when: one sentence: the task situation in which an agent should load this note
summary: one or two sentences with the core takeaway (an agent may stop reading here)
sources: ["hindemith-1 p.12-14"]   # source_id + printed pages; see sources/
related: ["[[voice-leading-basics]]"]
```

Body sections, in this order (omit empty ones):
1. `## Core idea` – 2–5 lines.
2. `## Rules` – IDs `R1…` with strength keywords.
3. `## Exceptions`
   `## Period practice` (optional) – how earlier periods/authors did it differently, era-tagged, for
   writing in the manner of a period; the Rules above stay the modern default.
4. `## Apply in MIDI / REAPER` – concrete: MIDI numbers, velocities, CCs, track/voice layout.
5. `## Checklist` – yes/no checks to verify generated material.
6. `## Examples` – short, in Roman numerals / chord symbols / note names with octave.

Size: 250–900 words. Split a note before it grows past that.

## Links
- Obsidian wikilinks by filename without extension: `[[voice-leading-parallels]]`. File names are
  unique across the vault, kebab-case, English.
- Each folder has a map-of-content note named `_<folder>.md` (e.g. `_harmony.md`, `_instruments.md`) listing its notes with their `use_when` line; the leading underscore keeps it unique and sorted first.
- Content is paraphrased from the sources; no long quotations.
