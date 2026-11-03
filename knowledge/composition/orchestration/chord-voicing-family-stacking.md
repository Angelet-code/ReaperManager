---
id: orchestration.chord-voicing-family-stacking
title: Chordal texture and the four ways of stacking families
aliases: [textura en acordes, acorde aislado, superposición, yuxtaposición, yuxtapuestos, concatenación, solapamiento, superpuestos parcialmente, engranaje, entrelazado, intercalado, inclusión, encierro, incluidos, voicing orquestal, disposición de acordes, equilibrio, equilibrio numérico, equilibrio de registros, color puro, timbre mixto, grados tonales, serie armónica]
domain: orchestration
tags: [texture, chords, voicing, blend, family-stacking, balance, spacing]
style_scope: universal (tonal doubling rules = tonal music)
use_when: Voicing any sustained chord, stab or pad across two or more instruments, families or pairs; choosing blend versus distinct colours; checking spacing and balance of a chord.
summary: Decide colour, vertical order, spacing and balance. Pairs stack four ways (superposition = separate colours, overlap on a shared unison, interlocking = most blend, enclosure). Space like the harmonic series (nothing closer than a 4th–5th below C3 = 48), double root and fifth more than the third, and judge balance by players per note times each instrument's strength in that register, never by one-instrument-per-note. Loud chords: [[chord-voicing-family-stacking-tutti]]; soft and fading: [[chord-voicing-family-stacking-soft]].
sources: ["unir-orq-tema3 p.14-17", "unir-orq-tema5 p.12-17", "unir-orq-tema6 p.19-24", "adler-orq-es p.143-144", "adler-orq-es p.252-255", "adler-orq-es p.363-364", "adler-orq-es p.562-563", "piston-orch p.396-403", "piston-orch p.444-454"]
related: ["[[chord-voicing-family-stacking-tutti]]", "[[chord-voicing-family-stacking-soft]]", "[[texture-types]]", "[[texture-part-writing-chorale]]", "[[woodwind-section-writing-chords]]", "[[brass-section-writing]]", "[[string-section-writing-homophony]]", "[[doubling-colour-and-decay]]", "[[four-part-voices-and-spacing]]", "[[orchestration-errors-checklist]]"]
---

# Chordal texture and family stacking

## Core idea
A chord that is not driven by voice leading is judged by **colour** (families, pure colour or mixed
timbre, register, double-reed or muted emphasis), **vertical order**, **spacing** and **balance**,
always against its dynamic and intent (Piston). The usual aim is a flat vertical plane: no note sticks
out and no seam is heard where one colour meets the next.

## The four pair relationships (pair X above pair Y)
| Type | Piston 1955 | Adler (es) | UNIR | Definition | Effect |
|---|---|---|---|---|---|
| Superposition | superposition | yuxtapuestos / superpuestos | superposición | X wholly above Y | separate colours |
| Overlap | overlapping | superpuestos parcialmente | concatenación | lowest X = highest Y (one unison) | joined; stresses the shared note |
| Interlocking | interlocking | intercalados | engranaje / entrelazado | X1 > Y1 > X2 > Y2 | most blend |
| Enclosure | enclosing | incluidos / encerrados | inclusión | X inside Y's interval | X tinted by Y |

Terminology trap: Adler's Spanish *yuxtapuestos* means superposition (stacked blocks), not overlap.

## Rules
- R1 `MUST` Choose colour, vertical order, spacing and balance before writing notes; the interval
  structure itself also colours the chord (Piston).
- R2 `PREFER` Interlocking for blend, superposition for distinct layers (UNIR, Adler). Check the weaker
  partner: low flutes interlocked with oboes vanish at pp; flute with clarinet is safer (Adler).
  Piston declines to rank the layouts for blend: try them all.
- R3 `AVOID` Overlap (a unison shared by two pairs) in exposed chords: it blurs both colours and weights a
  note that needs none (Adler). `ALLOWED` in tutti.
- R4 `ALLOWED` Enclosure; give the inner pair the stronger instrument. Adler's best enclosed wind chord:
  flutes on top, oboes in the middle, clarinets below.
- R5 `MUST` Judge balance by (a) players per note and (b) each instrument's power in that register.
  `AVOID` assuming one instrument per note is balanced ("numerical balance", Piston Fig. 153a).
- R6 `AVOID` Pairing a weak and a strong register in one chord (two flutes, one low and one high; low
  flute over low oboe). `MUST` Re-check balance after any transposition, even a semitone (Piston).
  Fix the weak note with a unison double.
- R7 `PREFER` Spacing like the harmonic series: octave and fifth at the bottom, closer intervals higher
  (Adler, Piston, UNIR). `AVOID` intervals smaller than a P4 (5), better a P5 (7), below C3 (48) when
  clarity matters; a close low chord is a percussive effect only (Piston).
- R8 `ALLOWED` Gaps up to a fifth in the upper voices when they come from not doubling the bass of a first
  inversion (Piston). Harmonic-series spacing fits root-position major chords best.
- R9 `PREFER` (tonal music) Double the tonal degrees (root, fifth; the key's I, IV, V) more than the third
  and sixth. One instrument on the third is enough to make a chord major. Extra weight on one chord
  member suggests a key (E minor weighted on G sounds like ii of D). For atonal or ambiguous chords,
  give every pitch about the same count (Piston).
- R10 `PREFER` In a 6 chord, double the bass note low (bass octave), never in the top voices (Adler).
- R11 `MUST` Melodic progression overrides vertical rules: a chord produced by good voice leading may
  keep imperfect spacing (Piston). Write the real parts first, then add doublings.
- R12 `MUST` Watch special timbres: the oboe and a muted trumpet stick out of any stack (UNIR).
- R13 `ALLOWED` Deliberately overweight the low, middle or high zone of a wide chord to place it there
  (Piston).

## Apply in MIDI / REAPER
- **Classifier** for two families, notes `X` (upper) and `Y` (lower): `min(X) > max(Y)` superposition;
  `min(X) == max(Y)` overlap; alternating when sorted, interlocking; `min(Y) < min(X)` and
  `max(X) < max(Y)`, enclosure.
- **Balance weight per pitch** (inferred): sum over instruments of `weight × register factor`. Weights at
  f: trumpet = trombone = 2 horns (Adler) ≈ 4 woodwinds (general knowledge); at p all winds about equal.
  Piston counts a string section as one instrument and a divisi half as 0.5, with a wide margin. Register
  factor 0.5 inside an entry's `weak_dynamics` zone (`data/instruments.json`), else 1. Expect root and
  fifth highest, third lowest.
- **Spacing lint:** for adjacent sounding pitches below 48, require a gap ≥ 5 (prefer 7).
- **Blended woodwind pad**, C major, interlocked: `FL 1` G5 79, `CL 1` E5 76, `FL 2` C5 72, `CL 2` G4 67;
  `BSN 1` C4 60, `BSN 2` C3 48; CC1 50–60.
- **Separate colours** (superposition): `VLN` C6 84, E5 76, `VLA` G4 67 above `HN` E4 64, C4 60,
  `TBN` G3 55, C3 48; `CB` C2 36. Shorts velocity 100–110.
- Outer voices about +5 CC1 over inner voices; Albion ensemble patches are polyphonic, so one track per
  register band, then check the combined stacking.

## Checklist
- Is each pair relationship chosen on purpose, with no unintended exposed overlap?
- Is every interval below MIDI 48 at least a P4 (better P5)?
- Are root and fifth more doubled than the third (tonal music)?
- Is no note in a weak register next to a strong-register neighbour, re-checked after transposition?
- Is no oboe or muted brass note unintentionally exposed in a blended chord?
