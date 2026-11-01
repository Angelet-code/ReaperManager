---
id: form.thematic-development
title: Building and developing themes
aliases: [tema, motivo, diseño, desarrollo temático, desenvolvimiento melódico, transformación temática, reexposición variada, motivic development, Motiv, thematische Arbeit, Fortspinnung]
domain: form
tags: [theme, motif, development, variation, sequence, repetition]
style_scope: common-practice
use_when: When inventing a theme, deriving secondary material from it, varying a return, or writing a development/episode/bridge from existing material.
summary: A theme is a short, characterful idea that gets repeated and developed; its head (motif) is the generating cell. Repeat to make it stick, vary returns in ornament/key/mode/ending while keeping rhythm and contour, and develop by fragmentation, sequence, inversion, augmentation/diminution, re-harmonisation, imitation and superposition.
sources: ["zamacois-formas p.6-12 (§9-13)", "zamacois-formas p.17-19 (§21)", "zamacois-formas p.42-48 (§42)", "zamacois-formas p.53-57 (§50-51)", "zamacois-formas p.169-183 (§148-150)", "zamacois-formas p.200-205 (§165)"]
related: ["[[phrase-structure]]", "[[section-functions]]", "[[imitation-and-canon]]", "[[theme-and-variations]]", "[[sonata-development-and-recap]]", "[[_harmony]]"]
---

# Building and developing themes

## Core idea
- **Theme (tema)**: brief, complete in sense, strong personality, no internal cadence; what makes it a
  theme is that it is **repeated and developed** later (§10).
- **Motif (motivo)**: the theme's head, its first beat-group — the cell where its profile is most salient.
- **Design (diseño)**: a uniform-rhythm figure (arpeggio, Alberti, running 16ths) without a theme's
  precision — accompaniment or episode filler.
- **Development (desarrollo temático)**: building new ideas from extracted theme elements, vs **melodic
  unfolding** (free continuation without theme work, typical of preludes, arias) (§12).

## Rules
- R1 `PREFER` Few, well-chosen ideas: too few and too many ideas are the composer's two enemies; drop good
  ideas that are not needed (§2).
- R2 `MUST` Give the theme a distinctive head (rhythm and/or interval) in its first beat-group; derive later
  material from it (§10, §42.6: Beethoven 5's four-note head generates the whole movement).
- R3 `PREFER` Make an idea stick by (re)exposition — immediate repetition or later return — but not so often
  it becomes monotonous (§21).
- R4 `ALLOWED` Varied returns keep the characteristic rhythm and contour and change one or more of (§21):
  ornamentation/figuration; ending type (open↔closed); key or mode (e.g. restate a step lower in the other
  mode); amplified tonal path; register; accompaniment figure.
- R5 `PREFER` Transformation (changing the theme's expression) is done mostly through **harmony**: a new
  harmonisation of the same line (§11; Wagner leitmotifs, Bach WTC 1 subject re-harmonised).
- R6 `PREFER` Development toolkit (§50–51, §150): fragmentation (head or tail only); sequence (progresión)
  of a fragment by step or 3rd; inversion (contrary motion); retrograde (weak, rarely audible);
  augmentation / diminution; rhythmic imitation (rhythm kept, pitches new — very fertile); change of mode;
  expansion and reduction; imitation between voices; superposition of two elements.
- R7 `PREFER` Secondary material serves the principal by **cohesion** (built from its rhythm/intervals in
  other keys) or **contrast** (sudden key or mode change, new rhythmic formula, vaguer contour) (§42.4).
- R8 `AVOID` Repeating a theme in the same key with the same harmony inside a development: change one
  of the two (§150).
- R9 `ALLOWED` Cyclic unity across movements/cues: derive each main theme from one 3–5-note cell, or quote
  the opening theme transformed later (§165: Beethoven op.13 and op.57, Franck Violin Sonata).

## Apply in MIDI / REAPER
- Store the theme as a note list `{pitch, beat, len, vel}`; derive variants by transforms:
  transpose `pitch + n`; diatonic sequence (shift scale degree, re-map); inversion around an axis pitch
  `p' = 2·axis − p` (then snap to scale); augmentation `beat×2, len×2`; diminution `/2`;
  fragmentation = slice the first k notes (head) or last k (tail); rhythmic imitation = keep beats/lens,
  substitute pitches from the current chord.
- Sequence: repeat a 1–2 bar fragment 2–3 times, each a step lower/higher; break the pattern on the 3rd/4th
  statement toward the cadence.
- Keep a "motif library" track or MIDI item (muted) holding the head, tail and their transforms for reuse.
- Leitmotif use (film/opera): same pitch head, new harmony/tempo/orchestration per scene.

## Checklist
- Can the theme's head be recognised from its first 2–4 notes alone?
- Is every later section traceable to the head, tail or rhythm of the theme (or deliberately contrasting)?
- Do returns keep rhythm + contour while changing at least one parameter?
- In developments: no fragment repeated with both the same key and the same harmonisation?

## Examples
- Head C5–E5–G5 (dotted 8th–16th–quarter): fragment = first two notes; sequence D5–F5, E5–G5;
  inversion around C5: C5–A4–F4; augmentation: dotted quarter–8th–half.
- Sonata op.2/1 I: 2-bar head repeated, then its last fragment alone twice — repetition with fragmentation (§21 fn).
