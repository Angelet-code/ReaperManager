---
id: orchestration.stage-seating-pan-depth
title: Stage seating to pan and depth map
aliases: [disposición de la orquesta, colocación en el escenario, panorama orquestal, paneo de orquesta, profundidad, violines antifonales]
domain: orchestration
tags: [seating, pan, depth, mix, template]
style_scope: universal (seating = orchestral practice; pan values = mock-up practice)
use_when: Setting pan and depth for orchestral tracks in REAPER, or deciding whether a library's baked-in hall position should be kept.
summary: Pan follows the audience's view of the stage. Strings sit in front from left to right, woodwinds in the centre, horns and brass behind, and percussion at the back. Libraries recorded in place (Spitfire/Albion) already contain that position, so leave them near centre. Dry libraries get the pan values and depth sends from the table. Choose one seating (modern or antiphonal) for the whole cue.
sources: ["unir-orq-tema1 p.4-6", "unir-orq-tema4 p.15-21", "film-4day-challenge slide 5"]
related: ["[[reverb-strategy-orchestral]]", "[[orchestral-mockup-template]]", "[[line-separation-and-fusion]]", "[[orchestra-sizes-and-section-balance]]"]
---

# Stage seating to pan and depth map

## Core idea
The listener should "see" the orchestra. Distance from the front of the stage is **depth**: more reverb,
less high end and slightly later reflections. Left–right position is **pan**. Pan and depth are also the
mix's extra tools for separating lines (see [[line-separation-and-fusion]]).

## Rules
- R1 `MUST` Choose one seating per cue and keep it: **modern** (Vln I, Vln II, Va, Vc from left to right)
  or **antiphonal** (Vln I left, Vln II far right, as in the UNIR stage figure).
- R2 `PREFER` Antiphonal seating when the violins answer each other (call and response, hocket between
  I and II). Modern seating when Vln I and II play in thirds or unison as one block.
- R3 `MUST` Keep libraries recorded in place (Spitfire, Albion ONE, most hall-recorded libraries) panned
  at or near centre. Their position is already in the samples, and panning again pushes them to the
  edges (general knowledge).
- R4 `PREFER` Keep bass instruments (Cb, tuba, contrabassoon, bass drum, sub booms) near centre:
  low frequencies anchor the stereo image (general knowledge).
- R5 `AVOID` Hard-panning (±100 %) any orchestral section. Real players spread from about 60 % left to
  60 % right (general knowledge).

## Seating (audience view)
- Front arc: 1st violins, then violas, cellos, and 2nd violins at the far right (UNIR figure). In the
  common modern variant, Vln II sits next to Vln I and the cellos are at the right.
- Double basses: behind the cellos, on the right.
- Harp and piano/celesta: left, behind the 1st violins.
- Woodwinds: row 1 (centre) has the piccolo, flutes, oboes and English horn. Row 2 has the clarinets and
  bassoons, with the horns beside them.
- Back row: trumpets, trombones, tuba, timpani and percussion. Organ at the far right.

## Apply in MIDI / REAPER
REAPER `D_PAN` is −1 (left) to +1 (right). The CLI's `pan` command takes `L50` / `R30` style values.

| Track | Modern pan | Antiphonal pan | Depth (send to hall reverb, dry libraries) |
|---|---|---|---|
| VLN I | −0.55 (L55) | −0.60 | front: −18 dB |
| VLN II | −0.30 | +0.60 | front: −18 dB |
| VLA | +0.15 | −0.20 | front: −17 dB |
| VC | +0.40 | +0.25 | front: −17 dB |
| CB | +0.50 | +0.45 | front/right: −24 dB or none |
| HARP / CELESTA / PIANO | −0.45 | −0.45 | mid: −15 dB |
| FL / PICC | −0.15 | −0.15 | mid: −14 dB |
| OB / E.H. | +0.10 | +0.10 | mid: −14 dB |
| CL / BASS CL | −0.20 | −0.20 | mid: −14 dB |
| BSN / CBSN | +0.15 | +0.15 | mid: −14 dB |
| HORNS | −0.35 | −0.35 | rear: −11 dB |
| TRUMPETS | +0.15 | +0.15 | rear: −12 dB |
| TROMBONES | +0.35 | +0.35 | rear: −12 dB |
| TUBA | +0.45 | +0.45 | rear: −16 dB |
| TIMPANI | −0.15 | −0.15 | rear: −12 dB |
| PERC (snare, cymbals) | +0.20 | +0.20 | rear: −12 dB |
| BASS DRUM / SUB | 0 | 0 | −20 dB or none |
| CHOIR | 0 (wide stereo) | 0 | rear: −10 dB |

These values are a starting map (general knowledge, derived from the UNIR stage figure).

- **Dry libraries:** apply the pan column. Fake depth with a larger reverb send for rear rows, a gentle
  high shelf on rear rows (−2 to −3 dB above 8 kHz), and 0–10 ms less pre-delay on rear rows than on
  front rows (the reflections arrive closer to the direct sound).
- **Hall-recorded libraries:** pan 0, or a small trim of ±0.1. Use less reverb send (about 6 dB less than
  the table), because the room is already in the samples.
- **Mixing both kinds:** match the dry ones to the wet ones. Pan the dry ones by the table and push their
  sends 3–6 dB higher.
- CLI: `node .\bin\reaper-manager.js pan --contains "VLN I" --pan L55`. Build specs set `pan` per track.

## Checklist
- Is one seating (modern or antiphonal) used for every string track?
- Are hall-recorded libraries left at or near centre?
- Are the sub-bass sources (bass drum, sub boom, synth bass) at centre, with the basses and tuba no
  further than +0.5?
- Do rear sections (brass, percussion) sound further away than strings and woodwinds?
- Does no orchestral track pan beyond ±0.65?
