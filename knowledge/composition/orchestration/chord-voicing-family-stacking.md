---
id: orchestration.chord-voicing-family-stacking
title: Chordal texture and the four ways of stacking families
aliases: [textura en acordes, superposición, concatenación, engranaje, inclusión, yuxtaposición, voicing orquestal, disposición de acordes, entrelazado]
domain: orchestration
tags: [texture, chords, voicing, blend, family-stacking]
style_scope: universal
use_when: Voicing a sustained chord, stab or pad across two or more instrument families or pairs, or choosing between maximum blend and distinct family colours.
summary: To orchestrate a chord, decide its colour, the vertical order of the instruments and the balance. Two families or pairs combine in four ways. Superposition keeps them apart (distinct colours); concatenation makes them touch on one shared pitch; interlocking alternates their notes for maximum blend; enclosure puts one pair inside the other. Watch extreme registers and special timbres (double reeds, mutes).
sources: ["unir-orq-tema3 p.14-17", "unir-orq-tema5 p.12-17", "unir-orq-tema6 p.19-24"]
related: ["[[texture-types]]", "[[texture-part-writing-chorale]]", "[[doubling-colour-and-decay]]", "[[line-separation-and-fusion]]", "[[orchestration-errors-checklist]]"]
---

# Chordal texture and family stacking

## Core idea
A chord is orchestrated in three decisions: (1) **colour** (which families), (2) **vertical order** of
the instruments, and (3) **balance** (each note equally present unless one is meant to stand out).
Two families or pairs can be combined in four ways (Piston, after Adler).

## The four stacking types (pair X above pair Y)
| Type | Spanish | Definition | Effect |
|---|---|---|---|
| Superposition | superposición | X entirely above Y, no shared pitch | families heard as separate colours |
| Concatenation | concatenación / yuxtaposición | lowest X note = highest Y note | joined, slight blend |
| Interlocking | engranaje / entrelazado | notes alternate X1 > Y1 > X2 > Y2 | **maximum blend** |
| Enclosure | inclusión | both X notes lie inside Y's interval | X coloured by Y, X softer |

## Rules
- R1 `MUST` Decide colour, vertical order and balance before writing the chord.
- R2 `PREFER` Interlocking for maximum blend inside a family or between two similar colours (Schumann
  1/I: Vln I and Vln II interlocked; also interlocked flutes and clarinets).
- R3 `PREFER` Superposition when the families must read as distinct colours (Schumann 1/I woodwinds:
  2 fl over 2 ob over 2 cl).
- R4 `ALLOWED` Concatenation and enclosure as intermediate blends. Enclosure tends to cover the inner pair,
  so give the inner pair the stronger instrument.
- R5 `MUST` Take special care with extreme registers and special timbres (double reeds, mutes). The
  oboe or a muted trumpet sticks out of any stack.
- R6 `PREFER` Spacing like the harmonic series: wide intervals at the bottom (octave, fifth below about
  MIDI 48), closer intervals higher up (general knowledge, consistent with the Schumann example).
- R7 `AVOID` Thirds or close clusters below about MIDI 45 (A2) in sustained chords: they sound muddy
  (general knowledge).
- R8 `PREFER` Double the bass at the lower octave in the basses (Schumann 1/I).

## Apply in MIDI / REAPER
- **Classifier for two families** with notes `X` (upper family) and `Y` (lower family):
  - `min(X) > max(Y)` → superposition.
  - `min(X) == max(Y)` → concatenation.
  - `min(X) < max(Y)` and the sorted notes alternate families → interlocking.
  - `min(Y) < min(X)` and `max(X) < max(Y)` → enclosure (X inside Y).
- **Blended woodwind pad** (C major, interlocked):
  - `FL 1` G5 79, `CL 1` E5 76, `FL 2` C5 72, `CL 2` G4 67.
  - `BSN 1` C4 60, `BSN 2` C3 48.
  - CC1 50–60 on all.
- **Separate-colour brass + strings stab** (superposition):
  - Strings `VLN` E5 76 and C6 84, `VLA` G4 67.
  - Brass below: `HN` C4 60, E4 64; `TBN` G3 55, C3 48.
  - Basses C2 36. Shorts velocity 100–110.
- **Balance:**
  - With more than one instrument per pitch in one family, keep the totals per pitch roughly equal
    (e.g. 2 horns on a note ≈ 1 trumpet note).
  - Give the outer voices (top and bass) +5 CC1 over the inner voices.
- **Albion-type ensemble patches** (Strings Hi/Lo, Brass Low/Mid/High) are polyphonic: send the
  whole chord to one track per register band rather than per player. Check that the combined voicing
  matches the stacking you intended.

## Checklist
- Is the stacking type of each family pair chosen on purpose (interlocking for blend, superposition for
  contrast)?
- Are intervals below MIDI 48 an octave or a fifth only?
- Is no oboe or muted brass note unintentionally exposed inside a blended chord?
- Is the bass doubled an octave lower in the basses (or contrabassoon/tuba) when the chord is forte?
- Do the outer voices have a slightly higher CC1 than the inner ones?
