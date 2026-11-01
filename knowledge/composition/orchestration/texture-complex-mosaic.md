---
id: orchestration.texture-complex-mosaic
title: Complex texture, mosaic and micropolyphony
aliases: [textura compleja, forma de mosaico, mosaico, micropolifonía, capas, superposición de texturas, cluster textural, nube sonora]
domain: orchestration
tags: [texture, complex, layering, micropolyphony, ostinato]
style_scope: universal (Stravinsky, Ligeti, film action and suspense)
use_when: Building a busy layered texture (magic shimmer, action bed, suspense cloud), or a section where no single element is primary.
summary: A complex texture is either several simple textures stacked or a mosaic of many elements with none primary. Build it from independent layers, each with its own register band, timbre and rhythmic grid, so the layers stay readable. For a micropolyphonic cloud, copy one line across many divisi tracks with small onset offsets so it fuses into a texture.
sources: ["unir-orq-tema3 p.17-19", "httyd-test-drive p.1-3, p.9"]
related: ["[[texture-types]]", "[[line-separation-and-fusion]]", "[[five-elements-arrangement-checklist]]", "[[action-ostinato-pedal-gallop]]"]
---

# Complex texture, mosaic and micropolyphony

## Core idea
There are two kinds of complex texture. (a) **Superimposed simple textures**: arpeggios + tremolos +
scales at once (Stravinsky, *Firebird*, "Magic Carillon"). (b) **Mosaic**: an amalgam of many elements,
none clearly primary. An extreme case is **micropolyphony** (Ligeti, *Lontano*): many equal voices in a
dense canon, so individual lines are lost and only the cloud is heard.

## Rules
- R1 `MUST` Give every layer its own register band **and** its own rhythmic grid (e.g. 16th arpeggios,
  8th-note trem pulse, quarter-note scale). Two layers sharing both band and grid turn into mud.
- R2 `PREFER` 3–5 layers. More than 5 independent layers stop being heard as layers (general knowledge).
- R3 `PREFER` Contrast decay types across layers: plucked/struck (harp, celesta, pizz), sustained
  (tremolo strings, woodwind trills), moving (scales) (see [[doubling-colour-and-decay]]).
- R4 `ALLOWED` Micropolyphony: one line duplicated over many divisi parts, entering in canon at a short
  delay, so it fuses into a moving cluster.
- R5 `PREFER` In film action, give the woodwinds **one beat-group each, not all at once**: flute,
  oboes and clarinets take turns filling (HTTYD intro). That is a mosaic distributed in time.
- R6 `AVOID` Putting a prominent melody on top of a dense mosaic without thinning the layers in its
  register.

## Apply in MIDI / REAPER
**Magic shimmer** (Firebird model, 3–4 layers, p–mf):
| Layer | Track | Band (MIDI) | Grid | Notes |
|---|---|---|---|---|
| Arpeggio | HARP | 55–91 | 16ths, up and down through the chord | vel 50–70 |
| Tremolo / trill | CL + BSN (trill or measured tremolo) | 50–72 | 32nds or trill patch | CC1 35–45 |
| Scales | VLN I (descending) | 72–96 | 8ths or 16ths, one scale per bar | CC1 45, legato/runs patch |
| Sparkle | CELESTA | 72–96 | off-beat 8ths | vel 50–65 |

**Micropolyphonic cloud** (suspense):
- Write one slow chromatic line, e.g. 60–61–63–62–64 with 2-beat notes.
- Copy it to 6–12 tracks (`VLN I a`…`VLN II d`, `VLA a`…), shifted by 1/8 beat per track (canon at a short
  delay). Transpose half the copies ±12 if needed to stay in range.
- Use a sustain patch, CC1 20–35, and very slow CC1 swells (±10 over 4 bars) staggered per track.
- Optional: ±10–20 cent detune per copy via pitch bend (`{beat, pb}` in the builder; ±8192 = the
  patch's bend range).

**Action mosaic** (HTTYD intro model, see [[action-ostinato-pedal-gallop]]):
- A fixed 2-bar ostinato in celesta + harp + Vln I.
- Repeated-note 16ths in violas.
- A pedal in the basses.
- Woodwinds take one beat-group each per bar: `FL` beats 1–2, `OB` beats 3–4, `CL` the next bar.

**Readability lint:**
- For each pair of layers, compute register overlap and shared grid.
- If the bands overlap by more than 50 % **and** the grids are equal, move one layer an octave or
  change its grid.

## Checklist
- Does each layer have a distinct register band and rhythmic grid?
- Are there 5 or fewer clearly separate layers?
- Do the decay types differ across layers?
- When a melody enters, is its register band cleared of other layers?
- In a micropolyphonic cloud, are the onsets offset per track so no single line is heard?
