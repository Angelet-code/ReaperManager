---
title: Source digest spec (stage 1)
purpose: Instructions for agents that read a source (book scan, course PDF) and write a faithful structured digest.
---

# Source digest spec

A digest is the stage-1 output: a faithful, structured, paraphrased extraction of one page range of one source.
Stage 2 turns digests into atomic topic notes. Digests are kept as provenance and for deep lookup,
so they must be accurate, compact and well located (page refs).

## Audience

AI agents that compose and arrange music by writing MIDI into REAPER. They need rules they can act on
and check, not prose. Humans are secondary.

## Output file

`knowledge/composition/sources/digests/<source-id>--<range>.md` (path given in your task).
Language: **English**, with the source's original Spanish/German term in parentheses the first time a
term appears, e.g. "passing tone (nota de paso)". Keep Spanish terms because user requests arrive in Spanish.

## File layout

```markdown
---
source_id: <given>
source_title: <given>
scan_pages: <first>-<last>          # page numbers of the PNG files you read
printed_pages: <first>-<last>       # page numbers printed on the book pages, if visible
chapters: [<chapter numbers/titles covered>]
continues_from: <chapter title if your range starts mid-chapter, else null>
continues_into: <chapter title if your range ends mid-chapter, else null>
---

# <source title> — scans <range>

## <Chapter/section number and title> (scan p.X–Y, printed p.A–B)

**Concepts**
- <term (término)>: <definition in your own words>

**Rules**
- R1 [MUST|PREFER|AVOID|NEVER|ALLOWED] <precise, testable statement>. *Why:* <reason if given>.
- R2 ...

**Exceptions / conditions**
- <when a rule relaxes, context>

**Examples** (transcribed, short)
- <e.g. "C major: I–IV–V–I, soprano E5–F5–D5–E5 … ; figured bass 6/4 on G">

**Agent applicability**
- <one-liners: how an agent generating MIDI would use this, e.g. "when voicing 4-part strings, keep
  tenor–alto ≤ octave (12 semitones)">

**Tags:** #harmony/voice-leading #form/sonata ... (free topical tags, lower-case, slash hierarchy)
```

## Fidelity rules

1. Do not invent. If you can't read something, mark `[?]`. If a rule is your inference, mark `(inferred)`.
2. Paraphrase. Never copy more than one short sentence verbatim; never reproduce whole exercises or long
   lists of exercises. Capture **what the exercise teaches**, not the exercise.
3. Skip prefaces, pedagogy talk, historical anecdotes and exercise lists **unless** they carry a usable
   rule or a style fact (e.g. "in Baroque suites the gigue is in compound meter").
4. Be precise and quantitative whenever the source is: intervals (name + semitones), voice ranges
   (note names with octave, **C4 = middle C = MIDI 60**), counts, proportions, metric positions, tempos.
5. Spanish solfège → letter names: Do=C, Re=D, Mi=E, Fa=F, Sol=G, La=A, Si=B; sostenido=#, bemol=b.
   German H = B, B = Bb.
6. Musical examples: transcribe only what is needed to illustrate the rule, in text: Roman numerals,
   chord symbols, note names with octave, figured bass. Name the key. If an example can't be read
   reliably, describe what it demonstrates instead.
7. Prefer more, smaller rules over long paragraphs. One rule = one checkable statement.
8. If the source gives a rule and later an exception, keep both and link them.

## Size

Aim for roughly 1,500–4,000 words per 40 book pages. Dense, no filler. Completeness of rules matters
more than brevity; prose fluff matters less than nothing.

## When finished

Reply with: the output path, the chapters covered, a 5-line summary of the most important content,
and any pages you could not read.
