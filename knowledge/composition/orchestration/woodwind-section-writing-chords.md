---
id: orchestration.woodwind-section-writing-chords
title: Woodwind chords, chorales, pedals and sustained harmony
aliases: [acordes de maderas, escritura homófona para la madera, acordes para maderas a dos, yuxtapuestos, superpuestos, intercalados, incluidos, encerrados, superpuestos parcialmente, disposición, matiz claro, matiz oscuro, acorde brillante, acorde oscuro, coral de maderas, acompañamiento pedal, acompañamiento tenido, tenidos, pedal de maderas, equilibrio numérico, acorde equilibrado]
domain: orchestration
tags: [woodwinds, chords, voicing, spacing, chorale, pedal, sustained-harmony, balance]
style_scope: universal (Classical–Romantic pedal and sustained-harmony layouts era-tagged)
use_when: Voicing a woodwind chord, chorale or pad (pairs, threes or single winds), choosing a bright or dark woodwind voicing, writing wind pedals and held harmony under active strings, or balancing woodwind chords against brass.
summary: Lay pair chords out stacked (default; check the top note's register), interlocked (blend; check the weaker partner) or enclosed; share a unison between pairs only in tutti. Avoid close one-timbre-per-note chords; put the widest gap at the bottom and keep the upper winds close. Bright = flutes high on top, dark = a low top voice. Winds hold pedals and slow sustained lines under busy strings, broken at phrase seams; against forte brass, double the woodwinds and put them on top.
sources: ["adler-orq-es p.243-254", "adler-orq-es p.255-260", "piston-orch p.444-445"]
related: ["[[woodwind-section-writing]]", "[[woodwind-section-writing-with-strings]]", "[[chord-voicing-family-stacking]]", "[[texture-part-writing-chorale]]", "[[woodwind-basics]]", "[[brass-section-writing]]", "[[horn]]", "[[orchestra-sizes-and-section-balance]]"]
---

# Woodwind chords, chorales, pedals and sustained harmony

## Core idea
Homophonic wind writing = the section (often with horns) in rhythmic unison. Adler's four layouts for
**pairs** (Fl 1-2, Ob 1-2…): **stacked** (each pair its own block), **interlocked** (Fl–Cl–Fl–Cl),
**enclosed** (one pair inside another's outer notes), **partial overlap** (two pairs share one note in
unison). Same geometry as [[chord-voicing-family-stacking]], which adds concatenation.

## Rules
**Layouts**
- R1 `MUST` stacked (the commonest layout): put the top, melodic note in a good register of its
  instrument; it is heard as the tune.
- R2 `PREFER` interlocking for blend, checking that one partner does not cover the other (Adler Ex. 8-19/20):
  - good: Ob/Cl interlocked; Fl/Cl at p–pp; Fl enclosing Cl;
  - best enclosure: Fl on top, Ob pair in the middle, Cl at the bottom;
  - weak: Cl above Fl; bad: low Fl/Ob interlocked, worst at ppp;
  - a chord tone around D5–G5 (74–79) under a flute pair goes to clarinet, not Fl 2.
- R3 `AVOID` partial overlap in exposed wind chords (blurs both colours, stresses a note that needs no
  stress); `ALLOWED` in tutti. `[era: commoner before the 19th c.]`
- R4 `PREFER` with threes or fours per instrument, the same layouts, each player in a good register.
- R5 `AVOID` a close chord with a different wind on each note (Fl, Ob, Cl, Bsn): hard to balance and tune.
  `ALLOWED` with single winds widely spaced: Fl/Ob/Cl close and high, Bsn far below.

**Spacing and colour**
- R6 `PREFER` the widest interval between the bass and the next voice; upper winds in close position.
- R7 `PREFER` bright = Fl (Picc at ff) high on top, Ob next, Cl spread below, Bcl/Bsn (Cbsn at ff) in the
  bass, the chord spanning the whole range.
- R8 `PREFER` dark = low top voice: Ob interlocked with Cl around the lower treble staff, Bcl below, Bsn
  low (f); at p, low flutes on top, Cl/Bcl in the middle, Bsn enclosing the Bcl. Brightness is a register
  choice, not a dynamic.
- R9 `PREFER` in a first-inversion chord, double the bass note in a low voice, never in the top.
- R10 `PREFER` organ-like hymn: Fl doubling Ob, legato mf dolce, all parts breathe together; a solo Bcl
  entry gives welcome change when the mass thins.

**Pedals and sustained harmony** `[era: Classical–Romantic, still valid]`
- R11 `PREFER` wind pedals (woods + horns) under a tutti; removing them costs stability and splendour.
  `[era: early Classical]` 2 Ob + 2 Hn on the same tonic pedal in octaves; the horns leap octaves at the
  cadence (Mozart 29).
- R12 `PREFER` held wind harmony under active strings, or a **slow counterpoint** (long Fl/Ob notes high
  above a fast string theme): the gap gives weight without distraction (*Figaro* overture).
- R13 `ALLOWED` tied p–pp Bsn/Cl dyads under a light dance tune with off-beat string chords; they unify
  without weighing it down (J. Strauss).
- R14 `PREFER` break a long wind pedal at the seam between two statements (the pick-up is heard, winds
  breathe); stop breaking it later to raise tension.

**Against brass (Piston)**
- R15 `AVOID` assuming one instrument per note balances (numerical balance); score from the remembered
  sound of each instrument at that pitch and dynamic.
- R16 `AVOID` at f, brass on the top notes over low flutes. `PREFER` flutes on top, brass lower, and double
  the woods (2 per note) to approach brass weight; even then they stay weaker. One horn < one trumpet at f.
- R17 `ALLOWED` `[era: 20th c., Stravinsky]` extreme spacing with registral holes (close high Fl/Ob, Cbsn far
  below, nothing between) as a dry colour.

## Apply in MIDI / REAPER
C major, concert pitch, one track per player, CC1 45–60 (p–mp):
- **Stacked:** `FL 1` G5 79, `FL 2` E5 76, `OB 1` C5 72, `OB 2` G4 67, `CL 1` E4 64, `CL 2` C4 60, `BSN 1` G3
  55, `BSN 2` C3 48 (gaps 3-4-5-3-4-5-7: widest at the bottom).
- **Enclosed:** `FL 1` 79, `OB 1` 76, `OB 2` 72, `CL 1` 67; bassoons as above.
- **Bright ff:** add `PICC` C7 96 and `FL` 84; `CBSN` C2 36. **Dark (mf–f):** top ≤ 72: `OB 1` 72, `CL 1` 67, `OB 2`
  64, `CL 2` 60, `BCL` 48, `BSN` 43.
- **Pedal (A major):** `OB 1` A5 81, `OB 2` A4 69, `HN 1` A4 69, `HN 2` A3 57; tie 4–6 bars, CC1 ~60; cadence:
  horns alternate 57/69. Release 1–2 beats before the next statement's pick-up.
- **Chorale breath:** end every track ~220 ms early together at each phrase end ([[user-taste]] R17).
- **Forte with brass:** woods on top, two tracks or an a2 patch per note, CC1 ≥ 90; brass CC1 ~10 lower.

## Checklist
- [ ] Layout chosen on purpose; top note in a good register.
- [ ] No low Fl under Ob in an interlock at pp; no exposed shared unison between pairs.
- [ ] No close Fl/Ob/Cl/Bsn one-per-note cluster.
- [ ] Widest interval at the bottom; upper winds close.
- [ ] First-inversion bass not doubled on top.
- [ ] Long pedals break at phrase seams; chorale breaths aligned.
- [ ] At f with brass, woodwinds on top and doubled.
