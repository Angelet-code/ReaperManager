---
id: form.multi-movement-cycle
title: Multi-movement plans — sonata, quartet, symphony, cyclic works
aliases: [sonata clásica, ciclo de sonata, movimientos, tiempo vivo inicial, tiempo lento, tiempo vivo final, sinfonía, cuarteto, trío, sonata cíclica, forma cíclica, Satzfolge, symphony plan]
domain: form
tags: [multi-movement, sonata-cycle, symphony, quartet, cyclic]
style_scope: classical
use_when: When planning a work of several movements (sonata, symphony, quartet, suite-like EP of cues) — movement order, forms, keys, tempos and thematic unity.
summary: Classical cycle = fast sonata-form first movement (I) – slow movement (Lied, variations or sonata; IV, vi or relative) – minuet/scherzo + trio (I) – brilliant finale (rondo or sonata, I); 3-movement works usually drop the minuet or the slow movement; first and last movements share the home key; cyclic works recall one cell or theme across movements.
sources: ["zamacois-formas p.167-169 (§141-143)", "zamacois-formas p.183-205 (§154-165)", "zamacois-formas p.204-207 (§166-168)"]
related: ["[[sonata-form]]", "[[ternary-form]]", "[[theme-and-variations]]", "[[minuet-scherzo-trio]]", "[[rondo-form]]", "[[concerto-form]]", "[[baroque-suite]]", "[[thematic-development]]"]
---

# Multi-movement plans

## Core idea
The classical sonata grew out of the suite: at most 4 movements, galant accompanied-melody style, ternary
(sonata) form instead of binary, and the single-key rule kept only for **first and last** movements
(§142). Quartet, trio and symphony are the same plan for other forces (§166–167).

## Rules
- R1 `PREFER` Four-movement order (§143): (a) **fast first movement** — weightiest, sonata form (role of
  the allemande); (b) **slow movement** — repose, melodic expansion (role of the sarabande); (c) **minuet
  or scherzo** — lighter intermezzo; (d) **fast finale** — different character, usually more brilliant
  than (a) (role of gigue/rondo). (b) and (c) may swap.
- R2 `PREFER` Three movements: drop (b) or (c), most often (c) (§143). Concertos are always fast–slow–fast
  (see [[concerto-form]]).
- R3 `MUST` First and last movements in the home key (finale may switch to the tonic major) (§142).
- R4 `PREFER` Keep inner keys cautious: only one movement in another key, usually the **slow** one (§142;
  15 of Beethoven's 32 sonatas keep one key throughout). Typical slow-movement keys (general knowledge):
  IV, vi, relative, tonic minor/major; romantics use bVI, III.
- R5 `ALLOWED` Slow-movement forms: ternary Lied, five-section Lied, sonata with or without development,
  variations; early classics also binary suite type (§154–157).
- R6 `ALLOWED` Finale forms: rondo (most common), rondo-sonata, sonata, variations, fugue (§162).
- R7 `PREFER` Symphony: normally 4 movements, orchestral; voices exceptional (Beethoven 9) (§167).
  Quartet (2 vn, va, vc): the purest, most contrapuntal writing (§166).
- R8 `ALLOWED` Post-classical: scherzo instead of minuet, weightier finale, freer keys, scherzo with two
  trios, cyclic themes (§163).
- R9 `PREFER` Cyclic unity: derive themes of all movements from one 3–5-note cell, and/or bring the first
  movement's theme back transformed in later movements (§165: op.13, op.57, Franck Violin Sonata).

## Planning template (fill in)
| mvt | form | key (major home / minor home) | tempo / meter | length (bars) | ends with |
|---|---|---|---|---|---|
| I | sonata (opt. slow intro) | I / i | Allegro 4/4 or 2/2 | 150–300 | PAC I |
| II | ternary Lied / variations / sonata w/o dev | IV, vi / VI, III | Adagio–Andante 2/4, 3/4, 6/8 | 60–120 | PAC (or HC attacca) |
| III | minuet or scherzo + trio | I / i (trio IV, parallel, relative) | Allegretto–Presto 3/4 | 80–200 | PAC I |
| IV | rondo / rondo-sonata / sonata | I / i or I | Allegro–Presto 2/4, 6/8 | 150–350 | PAC I, brilliant coda |

## Apply in MIDI / REAPER
- One REAPER project per movement (or one project with a tempo/time-signature marker and a region per
  movement plus 2–4 empty bars between them).
- Lengths in time: Allegro ♩=132, 200 bars of 4/4 ≈ 6 min; Adagio ♩=60, 80 bars of 2/4 ≈ 2 min 40 s;
  Scherzo dotted-half=80 (one beat per bar), 160 bars ≈ 2 min.
- Cyclic cell: keep it in a muted "motif library" item; derive each movement's head from it
  (augmented in the slow movement, dotted/compressed in the scherzo).
- Orchestration contrast across movements: slow movement reduced forces or solo wind; scherzo light
  staccato strings; finale tutti.

## Checklist
- Are first and last movements in the home key, with at most one inner movement elsewhere?
- Do tempos alternate (fast–slow–moderate/fast–fast) and does the finale outshine the first movement in brilliance?
- Does each movement use a form fitting its role (sonata first, lyrical second, dance third, rondo last)?
- Is there a recurring cell or theme if the work is meant to feel unified?

## Examples
- Beethoven op.13 (c): I Grave + Allegro (sonata, c) – II Adagio (five-section Lied, Ab) – III Rondo (c); a
  rising stepwise cell from the intro recurs in all three (§165).
- Haydn mostly 3 movements; Mozart's piano sonatas all 3; Beethoven's 32: ten in 4, fifteen in 3, seven in 2 (§143).
