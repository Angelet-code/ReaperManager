---
id: form.ostinato-chaconne-passacaglia
title: Ostinato forms — ground bass, chaconne, passacaglia
aliases: [ostinato, basso ostinato, bajo obstinado, chacona, pasacalle, passacaglia, ground bass, follia, Chaconne, Passacaglia]
domain: form
tags: [ostinato, chaconne, passacaglia, ground-bass, variation]
style_scope: baroque
use_when: When building a piece or cue on a repeated bass line or harmonic loop with variations on top.
summary: A short, severe, strongly tonal ostinato (often a descending tetrachord or cadential formula, 4–8 bars, usually slow 3/4 or 3/2) repeats unchanged while upper voices vary decoratively with growing density; passacaglia keeps the theme mostly in the bass, chaconne tends to vary over a harmonic frame or top-voice melody (sources disagree); key/mode changes and transfers to upper voices are licences.
sources: ["zamacois-formas p.143-148 (§113-115)", "zamacois-formas p.155-165 (§136)"]
related: ["[[theme-and-variations]]", "[[dance-types]]", "[[baroque-suite]]", "[[form-for-modern-songs]]"]
---

# Ostinato forms — ground bass, chaconne, passacaglia

## Core idea
An **ostinato** (basso ostinato) is a theme, usually in the bass, repeated constantly; the piece becomes a
series of **decorative variations** above it (§113). Chaconne and passacaglia are the classic examples.
This is also the logic of loop-based modern music (a fixed chord loop with evolving layers; general knowledge).

## Rules
- R1 `PREFER` Ostinato: short, severe, very tonal, sometimes only a cadential formula (§114).
- R2 `PREFER` Meter/tempo: usually 3/4 or 3/2, slow and measured (pausado) (§114); exceptions exist
  (Handel Passacaglia in 4/4 Allegro moderato; Britten *Peter Grimes*: 11-beat theme in 4/4 so the accent
  shifts every repeat).
- R3 `ALLOWED` Two definitions coexist (§114): **d'Indy** — passacaglia = theme identical in all variations,
  usually bass, contrapuntal; chaconne = theme usually in the top voice, increasingly ornamented.
  **Riemann** — chaconne built like the passacaglia on a basso ostinato; old distinctions contradict each
  other. Practical choice: passacaglia = literal bass ostinato; chaconne = repeating harmonic frame whose bass
  may be ornamented.
- R4 `ALLOWED` Licences seen in the repertoire (§114): ostinato moved to the top voice or split between voices
  (Purcell; Bach Chaconne); ostinato ornamented (Handel); transposed with key changes (Vitali); mode change
  for a block of variations and back (Bach Chaconne: d → D at var. 32 → d at var. 52; Handel: change at var. 9,
  back at var. 16).
- R5 `PREFER` Variation plan: rising rhythmic density, texture growing from 2 to many voices, a contrasting
  mode block in the middle, climax and return to the opening texture or a grand tutti at the end
  (inferred from Bach's Chaconne and Passacaglia).
- R6 `ALLOWED` As a suite dance, a chaconne/passacaglia may be in rondo form (Couperin) (§136).

## Planning template
| section | bars | key | material | ends with |
|---|---|---|---|---|
| Theme | 4–8 (1 statement) | i | ostinato alone (passacaglia) or with chords | HC/V or i |
| Vars 1–4 | 4×(4–8) | i | 1–2 upper voices, quarters → 8ths | each ends on ostinato's last chord |
| Vars 5–8 | 4×(4–8) | i | 16ths, imitation, ostinato in top voice once | same |
| Vars 9–12 | 4×(4–8) | I (mode change) | lyrical, thinner texture | same (major) |
| Vars 13–16 | 4×(4–8) | i | densest, full texture, climax | same |
| Final | 4–8 (+2–4) | i (Picardy I optional) | tutti, augmented ostinato | PAC, maybe I |

## Apply in MIDI / REAPER
- Ostinato in one MIDI item looped (REAPER item loop) on a bass track: e.g. D minor descending tetrachord
  D3–C3–Bb2–A2 (50–48–46–45), one bar each in 3/4; or Vitali's G–F–Eb–D.
- Upper-voice variations in separate items per 2 variations, so density can be audited; velocity and CC1
  rise across the set (+30 to +50 from start to climax).
- Group variations into regions of 4 (`Vars 1-4 i`, `Vars 9-12 I`).
- Accent displacement trick (Britten): ostinato length not a multiple of the bar (e.g. 11 beats in 4/4)
  — place it by beats, not bars.

## Checklist
- Is the ostinato short, tonal and identical (or recognisably ornamented) in every statement?
- Does density/texture grow, with a contrasting block (mode change or top-voice ostinato) in the middle?
- Does every variation end on the ostinato's final harmony, so joins are seamless?

## Examples
- Bach Chaconne (violin, d, 3/4): ostinato D–C–Bb–A, not always in the bass; major block var. 32–51 (§114).
- Bach Passacaglia (organ, c, 3/4): theme alone first, almost always in the bass, unchanged (§114).
- Vitali Chaconne (g): G–F–Eb–D, one bar per note, transposed with each key change (§114).
