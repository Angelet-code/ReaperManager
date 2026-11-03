---
id: orchestration.texture-unison-and-tutti-layouts
title: Tutti and octave-unison layouts (weighting by octave)
aliases: [disposición del tutti, tutti concentrado, tutti brillante, peso sonoro, reparto por octavas, tutti majestuoso, tutti clásico]
domain: orchestration
tags: [texture, tutti, unison, octaves, balance, period-practice]
style_scope: universal; era-tagged Classical/Romantic layouts
use_when: Laying out a tutti or multi-octave unison octave by octave, choosing between a massive and a brilliant tutti, or checking which octave dominates.
summary: "Weight a multi-octave line in the middle octaves (about five players each) with one flute on top and basses below. Unison doublings add tone-weight, octave doublings add brightness but little weight, and horns or trumpets at f outweigh several woodwinds. A massive tutti packs everyone into two adjacent octaves; a brilliant one covers four or five octaves with every family in every octave."
sources: ["adler-orq-es p.548-556, 570-578", "piston-orch p.358-363, 378-380, 426-430"]
related: ["[[texture-unison-and-tutti]]", "[[texture-accompanied-melody-doubling-the-tune]]", "[[chord-voicing-family-stacking]]", "[[bass-line-doubling]]", "[[natural-horn-period-practice]]", "[[trumpet-period-practice]]", "[[tutti-balance-by-role]]"]
---

# Tutti and octave-unison layouts

## Core idea
A tutti statement of one line is an octave unison spread over several octaves. Its sound depends on
**how many players sit on each octave** and which families they are. This note gives proven layouts;
the general rules are in [[texture-unison-and-tutti]].

## Rules
- R1 `PREFER` Load the middle octaves; one flute on the top octave only reinforces the upper partials of
  the notes below (Piston, Beethoven 9).
- R2 `MUST` When balancing, count **unison** doublings as weight. Octave doublings add brightness and
  clarity but little weight (Piston); they also erase each instrument's own colour (Adler).
- R3 `PREFER` Weight brass heavily: in a ff wind tutti over four octaves the octave holding two horns can
  outweigh one holding four woodwinds (Piston, Beethoven 7/II).
- R4 `PREFER` Woodwinds an octave **above** a violin melody rather than at unison: more brilliance, better
  coverage, and flute and oboe avoid the line's low end (Adler, Mozart 40).
- R5 `PREFER` Vary density per octave on purpose (Mozart 40/IV): dense top (violins + flute + oboes), thin
  middle (violas + clarinets), dense lower (cellos + bassoons), basses an octave under the cellos.
- R6 `ALLOWED` A doubler may leap (e.g. 2nd clarinet up a 10th) to reinforce the leading register instead
  of staying in its own octave (Adler).
- R7 `PREFER` Choose the layout by intent (Piston, Fig. 136):
  - **massive / thick:** nearly everyone in unison on two adjacent octaves; omit basses, contrabassoon,
    tuba, piccolo, and trumpets II–III so it doesn't sound like brass alone;
  - **brilliant:** four or five octaves, each family covering every octave of its share.
- R8 `PREFER` Same-instrument unison (flutes a4) sounds warm, slightly smeared and no louder than one
  player; cross-section octave doubling sounds bright and loud (Adler, Mahler 4 vs. Tchaikovsky).
- R9 `MUST` In brass forte, put flutes, oboes and clarinets on top as upper-partial reinforcement (as many
  as available) and send bassoons and bass clarinet to the bass with tuba, Trb 3, Hn 4 (Piston).

## Layouts
**Beethoven 9/I, the A of bar 1 (Piston Fig. 111):**
| Pitch (MIDI) | Instruments | Players |
|---|---|---|
| A6 (93) | Fl I | 1 |
| A5 (81) | Vln I+II, Fl II, Ob I, Cl I | 5 |
| A4 (69) | Va, Ob II, Cl II, Hn I, Tpt I | 5 |
| A3 (57) | Vc, Bsn I+II, Hn II, Tpt II | 5 |
| A1 (33) | basses (written A2), timpani | 2 |

**Brilliant tutti, C2–C6 (36–84) (Piston Fig. 136b):** top octave picc + 2 fl + Vln I; next ob I + 2 cl +
2 tpt + Vln II; next EH + ob II + bsn I + tpt III + hn I/III + violas; next bass cl + bsn II + hn II/IV +
3 trb + cellos; bottom cbsn + tuba + basses.

**Massive tutti (Fig. 136a):** upper octave 2 ob + EH + 2 cl + tpt I + hn I/III + trb I + Vln I/II + Va;
octave below 2 bsn + bass cl + trb II/III + hn II/IV + Vc.

**Majestic tutti (Wagner, *Meistersinger* Prelude, Adler):** melody Vln I+II + ob + cl; inner harmony
2 bsn + 4 hn + trb 1–2 + Va; bass Trb 3 + tuba + Vc + Cb in octaves; keep picc/fl top and high violins
for the later crescendo; trumpets on harmonic support at first, theme later.

**Power hit (Tchaikovsky, *Romeo and Juliet*, Adler):** melody in 2 trumpets a2 (long notes); every other
section plays off-beat chord stabs doubled in octaves. Different colour + different rhythm keep the two
ideas apart.

## Period practice
- `[era: Classical, natural brass]` horns and trumpets play only the notes they have; they leave out or
  swap notes of a scale-wise line and stay out of chromatic unisons (Mozart 40); timpani tonic and
  dominant only; the violins' top register barely used (Beethoven 9). Use for pastiche; the modern default lets brass
  and up to five timpani follow the line (Adler: "not necessarily better").
- `[era: taste, Adler]` Rimsky-Korsakov: large mixed unisons; Beethoven: octave doubling for dynamics;
  Mozart, Mendelssohn, Debussy, Ravel: pure, undoubled solo colours. The modern default for MIDI is the
  pure-colour approach except at peaks (inferred from Piston's preference for pure colours).

## Apply in MIDI / REAPER
- Build the octave table first (pitch → tracks), then copy the line to each track at ±12/24.
- Weight check (inferred): sum per octave, each string section or wind = 1, each horn/trumpet/trombone
  at f = 2. The melody's intended octave should carry the largest sum.
- Albion ONE woods and brass are ensemble patches (inferred): one track already sounds like a unison
  a2–a3; don't stack two ensemble tracks on the same octave unless you want the massive layout.

## Checklist
- Is the largest weight on the octave where the tune should be heard?
- Is the top octave a reinforcement (1–2 players), not an exposed lone flute?
- Massive layout: no extreme-low or piccolo tracks? Brilliant layout: every family in every octave?
