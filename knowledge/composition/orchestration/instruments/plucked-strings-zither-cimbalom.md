---
id: orchestration.plucked-strings-zither-cimbalom
title: Zither and cimbalom
aliases: [cítara, cítara de concierto, Zither, cythare, cuerdas melódicas, cuerdas de acompañamiento, cimbalón, címbalo húngaro, cimbalo ongarese, cymbalum, Zimbal, salterio, dulcémele, hammered dulcimer, pedal de sordina, baquetas de cimbalón]
domain: orchestration
tags: [plucked, struck-strings, zither, cimbalom, instrument, ranges, local-colour]
style_scope: universal
use_when: Writing local colour with a zither (Austrian/Bavarian, Viennese waltz, The Third Man) or a cimbalom (Hungarian, Kodály/Bartók/Stravinsky colour, fast florid figuration) in an orchestral or chamber texture.
summary: The zither has 5 fretted melody strings (≈ 48–69 open) plus 24 open accompaniment and bass strings tuned in fifths; it plays melody in 3rds/6ths over an oom-pah-pah and needs very light, muted accompaniment. The cimbalom (struck metal strings, 40–88, damper pedal) suits fast florid 16ths that cut through a tutti and turns every long note into a roll.
sources: ["adler-orq-es p.108-110", "adler-orq-es p.449-451", "piston-orch p.338-339"]
related: ["[[plucked-strings]]", "[[harp]]", "[[mallet-percussion]]", "[[percussion-section-writing]]", "[[user-taste]]", "[[_instruments]]"]
---

# Zither and cimbalom

## Core idea
Two folk string instruments used for **local colour**. The zither is plucked (melody with the right thumb
and a plectrum on fretted strings, accompaniment with the other fingers on open strings); the cimbalom is
**struck** with hammers, a concert form of the dulcimer, so Adler files it under percussion
(chordophones) and Piston beside the harp. Both are rare guests: use them for a scene, not as a section.

## Rules: zither
- R1 Strings (Adler, exact pitches partly uncertain [?]): 5 fretted **melody strings**, usual tuning A4 A4
  D4 G3 C3 (69 69 62 55 48); 13 open **accompaniment strings** and 11 open **bass strings**, each set a
  cycle of fifths, all sounding an octave below written (accompaniment ≈ 54–68, bass ≈ 42–55 sounding,
  inferred from the written ranges).
- R2 `ALLOWED` any string may be retuned at the composer's request; the tunings above are the usual ones.
- R3 `PREFER` `[era: 19th-c. Viennese]` evoking Austrian/Bavarian colour (Johann Strauss II, *Tales from
  the Vienna Woods*); modern film shorthand: *The Third Man*.
- R4 `PREFER` accompany it very lightly: p, muted strings, no winds. Strauss model: zither solo in 3/4 with
  melody in 3rds/6ths over bass note + two off-beat chords, then only Vln 2, violas and cellos *con sord.
  div.* add held notes and off-beat chords (no Vln 1).

## Rules: cimbalom
- R5 `MUST` range E2–E6 (40–88), four chromatic octaves (Adler). Several strings per note; hammers tipped
  with leather or wood; often a foot damper pedal.
- R6 `PREFER` florid, fast passages (Bartók, Kodály, Stravinsky): continuous 16th figuration doubling or
  decorating a melody cuts through even a ff tutti (Kodály, *Háry János*).
- R7 `MUST` play sustained notes as rolls, even when the part does not mark them; soft passages switch to
  rolled dyads under a solo (Háry János: under the oboe).
- R8 `ALLOWED` Hungarian/gypsy connotation by default (Piston: native to Hungarian gypsy bands, played
  virtuosically and improvised); `[era: post-1980]` also neutral art-music colour (Dutilleux, *L'Arbre des
  songes*). Repertoire: Bartók Rhapsody No. 1, Kodály *Háry János*, Stravinsky *Renard* and *Ragtime*.
- R9 `ALLOWED` its folk cousin, the hammered dulcimer, for Appalachian colour (Adler).

## Period practice
- `[era: early 20th c.]` Hungarian composers brought the cimbalom into the symphony orchestra.
- `[era: 19th c.]` the zither reached its modern concert form only at the end of the century.

## Apply in MIDI / REAPER
- Zither: RH melody in parallel 3rds/6ths around 67–79, LH Ländler pattern (bass 42–55 on beat 1, two
  chords 54–68 on beats 2–3); velocity p 40–60 (inferred). Strings around it: muted patch, CC1 25–45.
- Cimbalom: track `CIMBALOM`; 16ths velocity-driven (vary 60–100 for accents, inferred), clamp 40–88.
  Long notes = re-triggered 32nds (or tremolo patch), never a single note held > ~1 beat (inferred). Use
  CC64 for the damper only if the patch responds (inferred).
- Neither instrument needs a fader push: make room with the orchestra ([[user-taste]] R15).

## Checklist
- [ ] Zither: melody + oom-pah-pah texture, strings muted and p, no winds.
- [ ] Cimbalom notes 40–88; long notes rolled; figuration fast and clear.
- [ ] The colour fits the scene (Austrian/Viennese or Hungarian/folk) or is used on purpose as abstract
      colour.

## Examples
- Zither in G, 3/4: melody B4/G4 → D5/B4 (71/67 → 74/71); bass G2 (43) then chords D4-G4 (62 67) twice.
- Cimbalom over a tutti melody in D: 16ths D5 A4 F#4 A4 (74 69 66 69) repeated under the tune.
