---
id: meta.glossary
title: Glossary hub (ES / EN / DE)
aliases: [glosario, vocabulario, términos]
summary: Hub for the five domain glossaries that map Spanish/German/Italian terms to English concepts and to the note that covers them. Grep them rather than reading them whole.
---

# Glossary hub

The glossaries are long tables, so search them instead of loading them:

```bash
grep -i "napolitana" knowledge/composition/_meta/glossary-*.md
```

Each row is `| Spanish | English | German/other | note |`, and the last column is the note to load.
Searching `aliases:` across the vault also works (`grep -ril "con sordina" knowledge/composition`).

- [[glossary-harmony]]: degrees, figured bass, chord names, non-chord tones, cadences, Hindemith's
  planning terms.
- [[glossary-form]]: phrase, period, sections, forms, dances, fugue, vocal genres. Starts with the
  false friends: *puente* (sonata transition vs pop bridge), *período*, *cadencia* vs *cadenza*.
- [[glossary-orchestration]]: line-ups, textures, doubling, balance, seating, score markings.
- [[glossary-instruments]]: instrument names, string, wind, percussion, harp and keyboard techniques,
  transposition.
- [[glossary-film-scoring]]: cue design, mock-up production, brief adjectives → harmony.
