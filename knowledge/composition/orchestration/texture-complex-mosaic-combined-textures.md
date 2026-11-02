---
id: orchestration.texture-complex-mosaic-combined-textures
title: Combined textures (layered complex tutti)
aliases: [textura compleja, superposición de texturas, texturas combinadas, elementos, subelementos, capas, plano sonoro, tutti en capas, Schichtung]
domain: orchestration
tags: [texture, complex, layering, tutti, elements]
style_scope: universal (Romantic to film climaxes)
use_when: Writing a climactic or busy tutti in which several distinct things happen at once (a theme, a countermelody, running figuration, a pedal), or running two whole textures against each other.
summary: "Plan 3–4 elements before writing notes, e.g. a brass chorale melody, a woodwind countermelody in faster values, a string scale or figuration line and a held pedal bass. Give each its own family, register band, rhythmic level and dynamic, and make the primary element a theme the listener already knows. Two whole textures can run at once when colour, pitch level and rhythm (even meter) differ; one is foreground, the other lighter background."
sources: ["piston-orch p.404-408", "piston-orch p.396-403", "adler-orq-es p.382-391"]
related: ["[[texture-complex-mosaic]]", "[[texture-types]]", "[[texture-unison-and-tutti]]", "[[line-separation-and-fusion]]", "[[texture-secondary-melody-countermelody]]", "[[tutti-balance-by-role]]", "[[building-and-releasing-climaxes]]"]
---

# Combined textures

## Core idea
The first kind of complex texture superimposes simple textures, each a separate **element** with its own
texture type and instrument group. The parent note on tapestries and clouds is [[texture-complex-mosaic]].
Plan the elements first, then the notes.

## Rules
- R1 `PREFER` Plan a climactic tutti as 3–4 elements (Hindemith, *Mathis der Maler*):
  - A, chorale melody in part writing: Tpt 1 + Cl 1–2 on the tune, Hn 1 + Trb 1 an octave lower, Hn 2–4,
    Tpt 2, Trb 2 on the harmony;
  - B, secondary melody in contrasting rhythm with trills: Picc + Fl, Ob 1–2 an octave lower;
  - C, descending scale in four octaves: Vln I / Vln II / Va / Vc, the violins varying it in running 8ths;
  - D, tenuto pedal bass: Bsn + Trb 3, Tuba + ½ Cb an octave lower, the other ½ Cb another octave lower,
    timpani roll.
- R2 `PREFER` Make the primary element a theme already established in the piece, and give the secondary
  elements contrasting rhythms.
- R3 `PREFER` Give each element its own dynamic rather than one dynamic for all (Piston). In MIDI this is
  per-element CC1/velocity ([[user-taste]] R15).
- R4 `ALLOWED` Free part writing inside an element: its octave doubling may drop out for part of the phrase
  and inner parts may merge for a few notes.
- R5 `PREFER` Three layers for a heroic low theme (Liszt, *Les Préludes*): theme low (Trb 1–2, bass Trb +
  Tuba, Bsn, Vc, Cb), harmony in the middle (upper winds and horns holding or repeating chords), motion high
  (violins and violas in staccato 16th scales).
- R6 `ALLOWED` Reverse it: a slow hymn in long notes low (Trb, Tuba, Hn, Bsn, Va, Vc, Cb) under dense fast
  counterpoint high (Picc, Fl, Ob, Cl, trumpets/cornets, violins; Tchaikovsky, *1812*). A family can be
  split between layers: horns join the hymn, trumpets join the figuration.
- R7 `PREFER` To run two whole textures at once, separate them by colour (warm double reeds + horns +
  strings against bright high woodwinds), pitch level and rhythm, even meter (4/4 legato against 6/8
  staccato; Strauss, *Symphonia Domestica*).
- R8 `PREFER` One texture is the foreground (more players, louder, legato); the other is a lighter background
  (staccato, *leggiero*, fewer players).
- R9 `PREFER` Leave close-lying melodies of the two textures undoubled at the octave; add an octave only
  where they lie far apart.
- R10 `MUST` Expect brass and timpani to outgrow the other elements in a crescendo. Cap them or accept the
  loss of balance on purpose ([[texture-unison-and-tutti]]).

## Apply in MIDI / REAPER
**Element table** (write it before any notes):

| Element | Role | Tracks | Band (MIDI) | Grid | CC1 / vel |
|---|---|---|---|---|---|
| A | theme (part writing) | TPT 1, CL 1-2; HN 1 + TRB 1 −12; HN 2-4, TPT 2, TRB 2 harmony | 55–79 | quarters/halves | 90–105 |
| B | countermelody | PICC, FL; OB 1-2 −12 | 76–96 | 8ths + trills | 75–85 |
| C | scale figuration | VLN I, VLN II, VLA, VC in octaves | 48–91 | running 8ths | 70–80 |
| D | pedal | BSN, TRB 3, TUBA, CB (split octaves), TIMP roll | 28–50 | tenuto | 70–85 |

- Only the theme gets the top level. Lower the heavy bed (D, low brass) before raising A
  ([[user-taste]] R15; [[tutti-balance-by-role]]).
- The CC1/velocity column is a starting point (inferred), not a source value.
- **Two textures:** name each group's tracks with a prefix (`T1 …`, `T2 …`). A compound-meter layer inside
  4/4 can be written as triplet 8ths on the shared tempo map (inferred).
- **Lint:** each element has its own grid and band, and no two elements share both.

## Checklist
- Were the elements listed (role, tracks, band, grid, level) before writing notes?
- Is the primary element a known theme, and does it alone carry the top level?
- Does every element differ from the others in rhythm level and register band?
- In two combined textures, is one clearly background (fewer players, staccato, softer)?
- Are brass and timpani capped in the crescendo?
