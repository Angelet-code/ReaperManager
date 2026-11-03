---
id: orchestration.texture-complex-mosaic
title: Complex texture, mosaic, tapestry and micropolyphony
aliases: [textura compleja, forma de mosaico, mosaico, tapiz sonoro, tapiz de sonido, micropolifonía, capas, superposición de texturas, cluster textural, nube sonora, Klangteppich, Klangfläche]
domain: orchestration
tags: [texture, complex, layering, tapestry, micropolyphony, ostinato]
style_scope: universal (Stravinsky, Ligeti, film action and suspense)
use_when: Building a busy layered texture (magic shimmer, action bed, suspense cloud, primeval or machine atmosphere), or a section where no single element is primary.
summary: "A complex texture is either several simple textures stacked (see the combined-textures note) or a tapestry/mosaic of many elements with none primary. Build it from a few elements, each with its own register band, colour or technique and rhythmic grid, introduce each motive alone before stacking, and contrast decay types. For a micropolyphonic cloud, copy one line across many divisi tracks with small onset offsets so it fuses."
sources: ["unir-orq-tema3 p.17-19", "httyd-test-drive p.1-3, p.9", "piston-orch p.404-411", "adler-orq-es p.261-270"]
related: ["[[texture-complex-mosaic-combined-textures]]", "[[texture-types]]", "[[line-separation-and-fusion]]", "[[texture-counterpoint-entries-and-canon]]", "[[five-elements-arrangement-checklist]]", "[[action-ostinato-pedal-gallop]]", "[[doubling-colour-and-decay]]"]
---

# Complex texture, mosaic, tapestry and micropolyphony

## Core idea
Piston's Type VII has two kinds:
- (a) **Combined textures**: two or more of the simple types at once (chorale + countermelody + scale + pedal;
  arpeggios + tremolos + scales in Stravinsky's *Firebird*, "Magic Carillon"). See
  [[texture-complex-mosaic-combined-textures]].
- (b) **Tapestry / mosaic**: many elements, none primary; the ear wanders from detail to detail (Stravinsky,
  *Rite of Spring* introduction; Honegger, *Pacific 231*). Its extreme is **micropolyphony** (Ligeti,
  *Lontano*): many equal voices in dense canon, so only the cloud is heard.

## Rules
- R1 `MUST` Give every layer its own register band **and** its own rhythmic grid (16th arpeggio, 8th trem
  pulse, quarter-note scale). Two layers sharing both turn into mud.
- R2 `PREFER` Group many parts into few elements. The *Rite* introduction has 31 parts in 11 elements
  (Piston); each element gets a distinct colour or technique (flutter-tongue, harmonics, pizz., mute, trill).
  For clearly heard layers, keep 3–5 (general knowledge); beyond that the result is a tapestry, not layers.
- R3 `PREFER` Introduce the motives of a tapestry one by one before stacking them. Familiar figures keep a
  dense web from turning into noise (Piston).
- R4 `PREFER` Give each woodwind its own cell in its best register, exactly notated but with different
  tuplets (3, 5, 6, 10) so the overlapping 3:2 and 4:6 rhythms sound free (Adler on the *Rite*).
- R5 `PREFER` Split a repeated grace-note or ornament figure between two players of the same instrument,
  note by note: neither tires, and the slight differences keep it fresh (Stravinsky; Adler).
- R6 `PREFER` Contrast decay types across layers: plucked/struck (harp, celesta, pizz.), sustained (tremolo
  strings, trills), moving (scales) ([[doubling-colour-and-decay]]).
- R7 `ALLOWED` Use a tapestry for atmosphere or extramusical images, or as a background for one or more
  melodies laid over it.
- R8 `ALLOWED` Micropolyphony: one line on many divisi parts, entering in canon at a short delay, so it fuses
  into a moving cluster.
- R9 `PREFER` In film action, give the woodwinds **one beat-group each, not all at once**: flute, oboes and
  clarinets take turns filling (HTTYD intro), a mosaic spread in time.
- R10 `AVOID` A prominent melody over a dense mosaic without clearing the layers in its register.

## Apply in MIDI / REAPER
**Magic shimmer** (Firebird model, 3–4 layers, p–mf):

| Layer | Track | Band (MIDI) | Grid | Level |
|---|---|---|---|---|
| Arpeggio | HARP | 55–91 | 16ths up and down the chord | vel 50–70 |
| Trill / tremolo | CL + BSN (trill or measured) | 50–72 | 32nds or trill patch | CC1 35–45 |
| Scales | VLN I (descending) | 72–96 | 8ths or 16ths, one scale per bar | CC1 45, runs patch |
| Sparkle | CELESTA | 72–96 | off-beat 8ths | vel 50–65 |

**Tapestry** (*Rite* model, 8–12 cells): one short ostinato cell per solo woodwind and solo string track,
each in its best register, with its own tuplet and technique (flutter, trill, pizz., harmonics, muted).
Stagger entries 1–2 bars apart so each cell is heard alone first. CC1/velocity between 40 and 70 with no
track more than 10 above the rest, unless one is marked "très en dehors". Hold a soft muted chord in solo
basses underneath.

**Micropolyphonic cloud** (suspense):
- One slow chromatic line, e.g. 60–61–63–62–64 in 2-beat notes.
- Copy it to 6–12 divisi tracks, each shifted by 1/8 beat; transpose half the copies ±12 to stay in range.
- Sustain patch, CC1 20–35, slow swells (±10 over 4 bars) staggered per track; optional ±10–20 cent detune
  per copy via pitch bend (`{beat, pb}`; ±8192 = the patch's bend range).

**Action mosaic** (HTTYD, [[action-ostinato-pedal-gallop]]): 2-bar ostinato in celesta + harp + Vln I,
repeated 16ths in violas, a bass pedal; woodwinds one beat-group each (`FL` beats 1–2, `OB` 3–4, `CL` the
next bar).

**Readability lint:** for each pair of layers, if the bands overlap by more than 50 % **and** the grids are
equal, move one layer an octave or change its grid.

## Checklist
- Does each layer have its own register band and rhythmic grid?
- Are many parts grouped into a few elements with distinct colours or techniques?
- Was each tapestry motive heard alone before the stack?
- Do decay types differ across layers?
- When a melody enters, is its band cleared?
- In a micropolyphonic cloud, are onsets offset per track so no single line is heard?
