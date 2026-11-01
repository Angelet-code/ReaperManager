---
id: orchestration.percussion-unpitched
title: Unpitched orchestral percussion
aliases: [percusión, percusión de altura indeterminada, tambor, caja, caja clara, bombo, gran cassa, platillos, plato suspendido, tam-tam, gong, triángulo, pandereta, caja china, castañuelas, pequeña percusión, Schlagzeug, kleine Trommel, große Trommel, Becken, Triangel]
domain: orchestration
tags: [percussion, instrument, unpitched, crescendo]
style_scope: universal
use_when: Adding or checking snare, bass drum, cymbals, suspended cymbal, tam-tam, triangle, tambourine, wood block, castanets or sound effects in an orchestral cue.
summary: Unpitched percussion has no range: MIDI notes are library key maps. Bass drum is the most powerful instrument (slow speech; notated lengths matter via damping); cymbals ring unless damped and can play pp; the suspended-cymbal roll is the classic crescendo booster (don't overuse); triangle cuts through any tutti (use sparingly); tam-tam is dark and shuddering.
sources: ["unir-orq-tema7 p.4-5, 8-12", "unir-orq-tema1 p.4-6"]
related: ["[[timpani]]", "[[mallet-percussion]]", "[[_instruments]]"]
---

# Unpitched orchestral percussion

## Core idea
Percussion = one object striking another. Unpitched instruments (altura indeterminada) are written on a
single line (neutral clef). Groups: **standard section** (timpani, snare, bass drum, cymbals, triangle,
tambourine, glockenspiel, wood block, tam-tam); **auxiliary** (castanets, xylophone, marimba, vibraphone,
tubular bells, crotales); **effects** (sleigh bells, wind machine, ratchet, whip, cowbell, anvil, siren);
**Latin/"exotic"** (maracas, claves, güiro, bongos, tom-toms, temple blocks).

| Instrument | Character | Notes for writing |
|---|---|---|
| Snare drum (caja) | dry, crisp; snares under the lower head | ostinati, rolls, military rhythm (Ravel *Boléro* 2-bar ostinato) |
| Bass drum (bombo) | most powerful instrument; felt beater | speaks slightly late; damping makes durations meaningful; rolls with two sticks |
| Clash cymbals (platillos) | metallic, brilliant; ring long | "let ring" (l.v.) or damp; pp possible |
| Suspended cymbal | huge colour range (stick, mallet, fingers, triangle beater) | two-mallet roll = crescendo from murmur to blazing ff |
| Tam-tam | dark, shuddering, heavy; violent when struck hard | soft beater = cloud of overtones; long decay |
| Triangle | high, clear, luminous | audible over the full tutti |
| Tambourine | jingles + head | shakes, rolls, hits |
| Wood block (caja china) | high, hard, dry | usually 3 sizes; 20th-c. American colour |
| Castanets | dry clicks (machine castanets) | not only for Spanish dances |

## Rules
- R1 `ALLOWED` the bass drum is the loudest instrument; a single ff stroke is a structural event.
- R2 `MUST` account for the bass drum's slow speech: players anticipate the beat.
- R3 `MUST` mark cymbal and tam-tam durations: "l.v." (tie to nothing) or a damped length.
- R4 `ALLOWED` suspended-cymbal roll crescendo into a downbeat; `AVOID` overusing it (the source calls it
  probably overused).
- R5 `AVOID` overusing the triangle: it cuts through everything and tires quickly.
- R6 `PREFER` specifying sizes (large/small tam-tam, small/large snare) when the colour matters.
- R7 `PREFER` doublings (general knowledge): bass drum + timpani + low brass on accents; cymbal crash with
  the tutti downbeat after a roll; triangle/tambourine with high woodwind or violin rhythms.

## Apply in MIDI / REAPER
- One track per instrument (`Perc - Snare`, `Perc - BD`, `Perc - Cym`, …); MIDI notes follow the library's
  key map, so no range validation applies. GM fallback (general knowledge): bass drum 35/36, snare 38,
  crash 49/57, ride 51, tambourine 54, cowbell 56, claves 75, wood block 76/77, triangle 80 (muted) / 81 (open).
- Bass drum: if the sample has a slow attack, nudge notes 5–20 ms early (inferred from R2).
- Suspended-cymbal roll: roll patch + CC1/CC11 ramp from ≈ 15 to 120 over 1–4 bars, ending on a crash
  (separate note) exactly on the downbeat.
- Velocity = dynamics; add ±5–10 velocity variation on repeated hits.
- Choke/damp: shorten notes only if the patch has note-off damping.

## Checklist
- [ ] Each unpitched instrument has its own track and the correct key-map note.
- [ ] No more than ≈ 1 cymbal-roll crescendo per minute of music (inferred from R4).
- [ ] Triangle used sparingly (not a constant pulse unless that is the style).
- [ ] Bass drum hits align with structural accents and brass/timpani.
- [ ] Tam-tam/cymbal tails are allowed to ring (no hard cut) unless damped deliberately.

## Examples
- Boléro: snare ostinato p, unchanged, while the orchestra grows.
- Rise: sus. cymbal roll CC1 20→120 over 2 bars → crash + bass drum + timpani on bar 3 beat 1.
