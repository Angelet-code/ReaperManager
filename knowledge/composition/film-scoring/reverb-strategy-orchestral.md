---
id: film-scoring.reverb-strategy-orchestral
title: Reverb strategy for orchestral mock-ups (panoramic vs impact)
aliases: [reverb, reverberación, reverb panorámica, reverb de impacto, envíos de reverb, profundidad, sala, returns]
domain: film-scoring
tags: [reverb, mix, template, depth, routing]
style_scope: film (sample-library mock-ups)
use_when: Setting up reverb returns and send levels for an orchestral or hybrid cue, or fixing a mock-up that is washy, dry or has a muddy low end.
summary: Use two main reverb returns. "Panoramic" (long, wide, wet) takes sustained strings, sustained brass and choir; "Impact" (shorter, big-room, quick decay) takes spiccato, brass stabs and woodwinds. Group sends along two axes, high vs low and long vs short. Keep basses and the low end almost dry, and give low percussion, other percussion, synths and FX their own reverbs if needed.
sources: ["film-4day-challenge slide 9", "film-4day-challenge slide 5"]
related: ["[[orchestral-mockup-template]]", "[[stage-seating-pan-depth]]", "[[bass-line-doubling]]", "[[line-separation-and-fusion]]"]
---

# Reverb strategy (panoramic vs impact)

## Core idea
Long and short material need different tails. A long tail on spiccato smears the rhythm, and a short tail
on sustains sounds small. Split reverb by **length** (long vs short) and by **register** (high vs low).
Low material gets little or none.

## Rules
- R1 `PREFER` Long, sustained material (strings sustain, brass long, choir) → **Panoramic** reverb:
  long, wide, wet.
- R2 `PREFER` Short, articulated material (spiccato, brass stabs, woodwinds) → **Impact** reverb: a
  shorter big-room sound with quicker decay.
- R3 `AVOID` Reverb on bass instruments (the deck's author almost never uses it). Keep Cb, tuba, sub,
  low synth and bass drum dry or nearly dry.
- R4 `ALLOWED` Separate reverbs for low percussion, other percussion, synths and special FX when they
  must sit in their own space.
- R5 `PREFER` Group sends by the two axes: high vs low and long vs short.
- R6 `PREFER` (general knowledge) For hall-recorded libraries (Spitfire/Albion), use lower sends: the
  room is already in the samples. Add reverb mainly to dry libraries and to glue them to the wet ones.

## Apply in MIDI / REAPER
**Create the returns:**
- CLI: `node .\bin\reaper-manager.js returns --count 2 --fx RVerb --from none`, then
  `rename` them to `REV PANORAMIC` and `REV IMPACT`.
- Or define them in the builder spec as tracks with `fx: [{ "name": "RVerb" }]` (the project resolves
  `RVerb` to Waves RVerb Stereo).
- Set the returns 100 % wet.

**Starting settings** (general knowledge; adjust by ear):
| Return | Decay | Pre-delay | Width | EQ on return |
|---|---|---|---|---|
| REV PANORAMIC | 2.8–4.0 s | 20–40 ms | full | HP 200–250 Hz, gentle LP 8–10 kHz |
| REV IMPACT | 1.2–1.8 s | 5–15 ms | wide | HP 250–300 Hz, LP 9–11 kHz |
| REV PERC (optional) | 1.5–2.5 s | 0–10 ms | wide | HP 150 Hz |

**Send levels** (dry libraries; for hall-recorded ones use about 6 dB less):
| Track type | Panoramic | Impact |
|---|---|---|
| Strings long, choir, pads | −10 to −14 dB | — |
| Brass long, horns legato | −12 dB | — |
| Woodwinds (long and short) | −18 dB | −14 dB |
| Strings short (spiccato/staccato) | — | −14 dB |
| Brass shorts, stabs | — | −12 dB |
| High enhancers (celesta, harp, crotales) | −14 dB | −16 dB |
| Snares, cymbals, toms | — | −12 dB (or REV PERC) |
| Timpani | −20 dB | −14 dB |
| CB, tuba, bass drum, sub boom, low synth | none (or −24 dB) | none |

- CLI to adjust later: `node .\bin\reaper-manager.js send-volume --contains STAC --dest "REV IMPACT" --db 2`.
- **Depth:** sections that are further back (brass, percussion) get +2 to +3 dB more send than front
  strings (see [[stage-seating-pan-depth]]).
- **Low-end guard:** a high-pass on both returns (≥ 200 Hz) keeps reverb out of the bass even if a low
  track leaks into a send.

## Checklist
- Do all long-articulation tracks send to Panoramic and all short ones to Impact?
- Are the bass instruments and low end without reverb sends (or at −24 dB or lower)?
- Do both returns high-pass at 200 Hz or more?
- Are the sends of hall-recorded libraries lower than those of dry libraries?
- Do spiccato and stab passages stay rhythmically clear (no smear between 16ths)?
