---
id: orchestration.orchestral-colour-effects-klangfarbenmelodie
title: Pointillism and Klangfarbenmelodie (tone-colour melody)
aliases: [Klangfarbenmelodie, melodía de timbres, melodía de colores, orquestación puntillista, puntillismo, puntillista, timbre melody, tone-colour melody, desplazamiento de octava, melodía escalonada, Webern, Segunda Escuela de Viena, Farben]
domain: orchestration
tags: [effects, colour, pointillism, klangfarbenmelodie, timbre, 20th-century, serialism]
style_scope: "Second Viennese School (1909–1940s) and later modernist writing; ALLOWED sparingly as a colour in tonal and film music"
use_when: Writing a line where almost every note changes instrument (pointillist, Webern-like, fragmented, glassy or modernist colour), or colouring a repeated note across several instruments.
summary: "A Klangfarbenmelodie spreads one continuous phrase over many instruments, nearly one note each; pointillism adds octave displacements and a separate dynamic per note. It only works if every duration, articulation and dynamic is exact, because the listener rebuilds the line from isolated points. Era-bound to Webern and the Second Viennese School; in tonal or film music use it briefly, with solo patches, for a fragmented or crystalline colour."
sources: ["adler-orq-es p.603-607", "adler-orq-es p.607-610"]
related: ["[[orchestral-colour-effects]]", "[[texture-types]]", "[[texture-complex-mosaic]]", "[[orchestrate-from-piano-sketch]]", "[[line-separation-and-fusion]]", "[[string-techniques-pizzicato-harmonics]]", "[[harp-techniques]]", "[[horn]]", "[[dynamics-by-orchestration]]", "[[user-taste]]"]
---

# Pointillism and Klangfarbenmelodie

## Core idea
**Klangfarbenmelodie** (melodía de timbres, tone-colour melody): a continuous phrase in which almost every
note is on a different instrument, so colour becomes a melodic parameter. Adler notes the term is also
used loosely for one repeated note passed between instruments (that case is note colouring, see
[[orchestral-colour-effects]] R5). **Pointillism** (orquestación puntillista) is the same idea with each
note isolated, like dots of pure colour in early-20th-c. French painting. Webern is its main exponent.

## Rules
- R1 `PREFER` `[era: Second Viennese School]` Give **each note its own dynamic** and add characteristic
  **octave displacements** between neighbouring notes (Ex. 15-42: trumpet *p*, flute *f* high, viola *mf*,
  muted trumpet *pp*, Vln II pizz *sf*, cello *p*).
- R2 `MUST` Notate, and render, **durations, articulations and dynamics exactly**. *Why:* the listener (and
  the player) reconstructs the line from isolated notes; any blur breaks it.
- R3 `ALLOWED` Change the **technique** of one instrument on successive notes as a colour change: violas
  pizz, pizz, arco (Webern Op. 21, b.5–7); horn stopped then open; harp harmonics; single accented or
  tenuto notes.
- R4 `PREFER` Keep the scoring **thin**. In Op. 21 (clarinet, bass clarinet, 2 horns, harp, Vln I–II, viola,
  cello; dynamics only *pp*–*mp*) the constant colour change already gives an impression of contrapuntal
  density.
- R5 `ALLOWED` Apply it to **tonal** material too, with octave transpositions that stagger the line
  ("doubly staggered" melody): Webern's *Passacaglia* Op. 1 has a tonal, Bach/Brahms-like theme that still
  sounds 20th-c.; the Bach–Webern *Ricercare* is the study model for a tonal subject in pointillist scoring.
- R6 `MUST` Each instrument plays its note in a register where it speaks easily at the marked dynamic (Adler
  on Ex. 15-40); displacement must not push a note into an instrument's weak extreme.
- R7 `AVOID` Outside a modernist style, more than a short passage of it. It cuts the line into fragments,
  which [[orchestrate-from-piano-sketch]] R11 otherwise forbids, and contradicts the user's preference for
  idiomatic, continuous parts ([[user-taste]] R1, R18) unless the fragmentation is the point.

## Period practice
- `[era: Second Viennese School, 1909–1940s]` the term is Schoenberg's (*Harmonielehre*, 1911, general
  knowledge); Webern developed the pointillist manner: canonic twelve-tone rows (Op. 21: row A F# G Ab E F |
  B Bb D C# C Eb, second hexachord the retrograde of the first a tritone higher), almost every note on a
  new instrument or technique.
- `[era: Classical–Romantic]` colour changes happen at phrase boundaries; changing colour inside a motif is
  an error there, not an effect.
- **Vault default:** continuous lines on one colour; a timbre melody only when the request asks for
  Webern, serial, pointillist or "fragmented/glassy" colour.

## Apply in MIDI / REAPER
- One note (or a 2–3-note cell) per **track**, each a solo patch; ensembles smear the points (inferred).
  Typical track set modelled on Op. 21: `CL`, `BCL`, `HN 1`, `HN 2`, `HARP`, `VLN 1`, `VLN 2`, `VLA`, `VC`,
  plus `FL` and muted `TPT` from Ex. 15-42.
- Displace neighbouring notes by ±12 or ±24, then clamp each note to its instrument's comfortable range in
  `data/instruments.json` (R6).
- Per-note dynamic from the vault map: CC1 15–55 (pp–mp) on longs, velocity 25–65 on shorts and pizz; set
  each note's CC1 before its note-on and keep it flat (no phrase arc across tracks).
- Exact timing (R2): quantize onsets and lengths; humanize by at most ±5 ms (inferred). Leave real
  silence between points; no reverb-tail filler.
- Technique changes: separate tracks (`VLA PIZZ`, `VLA ARCO`) or keyswitches; horn stopped/open per note;
  harp harmonics (sound an octave above the written pitch, see [[harp-techniques]]).
- Slow-attack sampled longs (Albion) sound late and weak on isolated short points: prefer fast-attack solo
  patches, or start the note 0.04–0.05 beat early (inferred, from the project's Albion notes).

## Checklist
- Is the passage era- or request-justified (Webern, serial, fragmented colour)?
- Does every point have its own exact length, articulation and dynamic?
- Is every displaced note inside its instrument's comfortable range?
- Is the texture thin, with silence between points?
- In tonal music, is it short and does a continuous line return after it?

## Examples
- Tonal timbre melody on D4 F4 A4 G4 F4 E4 D4 (D minor), staggered:
  `CL` 62 *p* → `FL` 77 *mp* → `VLA PIZZ` 57 *mf* → `TPT` muted 67 *pp* → `HN` 53 *p* →
  `VLN 2 PIZZ` 76 *p* → `VC` arco 50 *pp*, one quarter each with an 8th rest between points.
