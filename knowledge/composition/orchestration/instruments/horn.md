---
id: orchestration.horn
title: Horn (French horn)
aliases: [trompa, trompas, trompa doble, corno, corno francés, Horn, Waldhorn, cor, notas tapadas, trompa tapada, bouché, chiuso, gestopft, al aire, ouvert, con sordina, cuivré, schmetternd, pabellones al aire, Schalltrichter auf, glissando de trompa, rip]
domain: orchestration
tags: [brass, instrument, ranges, registers, transposition, section-layout, doubling, techniques]
style_scope: universal
use_when: Writing, checking or voicing horn parts (sustained harmony, heroic or lyrical melodies, stopped/muted effects, rips).
summary: Horn in F sounds a P5 below written, B1–F5 (35–77, Bb-side pedals 31–34); home concert F3–C5 (53–72). Horns 1 and 3 play high, 2 and 4 low (voice 1 > 3 > 2 > 4); unison for heroic tunes, octaves for lyrical ones, close mid-register chords as glue; double extreme highs when loud and extreme lows even when soft; rest after the top.
sources: ["unir-orq-tema6 p.4-12", "unir-orq-tema1 p.11-15", "adler-orq-es p.312-325", "piston-orch p.225-245"]
related: ["[[natural-horn-period-practice]]", "[[trumpet]]", "[[trombone]]", "[[bassoons]]", "[[transposing-instruments]]", "[[texture-unison-and-tutti]]", "[[doubling-colour-and-decay]]", "[[_instruments]]"]
---

# Horn (French horn)

## Core idea
Standard today: **double horn F/Bb** (German rotary type: warm, dark), written in F, **sounds a P5 (7 st)
below written**; the player, not the part, picks the F or Bb side. Round, blending tone, softer attacks
than trumpet. Links woodwinds and brass (score: above the trumpets). Weaker than heavy brass, stronger
than woodwinds.

| Zone | Sounding MIDI | Written | Colour |
|---|---|---|---|
| Pedal (Bb side) | 31–34 | D2–F2 | slow, hard to tune |
| Very low | 35–40 | F#2–B2 | valved, hard to control |
| Low | 41–49 | C3–G#3 | dark, a bit unfocused |
| Low-middle | 50–52 | A3–B3 | deep and solid |
| Middle–high | 53–71 | C4–F#5 | bright and heroic: home register |
| Top | 72–77 | G5–C6 | brilliant and loud, tiring |

Full **35–77** (31–34 pedals), practical **41–74**, comfortable solo 53–72 (Piston: from 48).
Variants: Adler's pedals reach F1 (29–34), F-side pedals unused; his chart puts "deep and solid" at ≈ 52–55.

## Rules
- R1 `PREFER` the central register (53–72); a mid-register section is a velvety bed under a soloist.
- R2 `MUST` four horns: **1 and 3 high, 2 and 4 low**; chord top-down = Hn1 > Hn3 > Hn2 > Hn4. Three
  horns: 3 above 2. Low horns may reach the top in unison.
- R3 `PREFER` four horns as harmonic filler: close mid-register chords, soft (Humperdinck chorale);
  modern: inner horns move contrapuntally.
- R4 `PREFER` heroic tune = whole section in unison (4–8), middle register, f–ff; climax by adding horns.
  Lyrical tune = horns in octaves.
- R5 `MUST` double extreme highs (≥ ~72) when loud; `PREFER` doubling extreme lows (≤ ~45) even at pp:
  steadier, not louder (Piston).
- R6 `MUST` at equal dynamics one horn is covered by a trumpet or trombone: double the horns or lower the
  heavy brass (≈ 2 horns per line, inferred).
- R7 `AVOID` frequent notes 31–40; pedals only as long notes, `NEVER` in fast passages.
- R8 `MUST` rest after the top register (72–77); pass long Hn1 stretches to another horn.
- R9 `PREFER` (general knowledge) loud held notes ≤ 6–8 s; a breath every 2–4 bars in f.
- R10 `PREFER` lines a hand horn could almost play: arpeggios, harmonic-series turns, stepwise upper lines.
  `AVOID` fast wide leaps, winding fast passages, fast chromatic runs (effect only).
- R11 `ALLOWED` double/triple tonguing; fast repeated notes/chords suit a section (triplets pp, 16ths f),
  less crisp than trumpet. `MUST` rest the tongue; alternate continuous fast figures between horns.
- R12 `ALLOWED` soft legato tonguing for lyrical solos (Tchaikovsky 5/II, Ravel *Pavane*).
- R13 `ALLOWED` stopped (+, bouché, chiuso, gestopft; cancel o/ouvert/offen): veiled at p, metallic snarl
  at f/sfz (bouché-cuivré). Echo = phrase open, repeated stopped and softer; good on sf > p. `AVOID`
  stopped below concert 53: use a mute.
- R14 `MUST` keep muted (con sordino … senza sordino; no pitch change) apart from stopped. Fast
  open/stopped switching needs the hand.
- R15 `ALLOWED` trills to a m2/M2 above (half-step best; lip trills only high): heavy, rustic or sardonic,
  never brilliant. `AVOID` tremolo wider than a 2nd.
- R16 `ALLOWED` glissando = upward **rip** over one fingering's harmonics, loud, high. `AVOID` descending
  gliss (faked; only inside a full-orchestra gliss).
- R17 `ALLOWED` cuivré/schmetternd (forced, brassy) and bells up (Schalltrichter auf) in boisterous ff.
- R18 `PREFER` doublings: + bassoon (chorales), + cello or viola (warm melody), + clarinets (held
  harmony), an octave below trumpet in fanfares (general knowledge), top-middle voices of a brass chorale.

## Period practice
- `[era: Classical]` 2 horns as glue between woods and strings; Romantic 4; late Romantic 6–8. Hand-horn
  idiom: [[natural-horn-period-practice]].
- `[era: c.1850–1910, Piston]` "blanket of horns": four-part harmony held constantly under the orchestra.
- `[era: 19th-c. scores]` old bass clef sounds a P4 *above* written (+5). Produce new notation (−7 in both
  clefs) with a note in the score.
- `[era: French]` the piston-valve French horn is bright and open: regional colour only.

## Apply in MIDI / REAPER
- Tracks `Hn 1-2`, `Hn 3-4` (or section patch + solo horn); concert pitch, written = +7.
- Chord → tracks: top Hn1, 2nd Hn3, 3rd Hn2, bottom Hn4.
- CC1 40–100 in the middle; 72–77 only f (CC1 ≥ 80), doubled; 41–49 reads soft at any CC1: double it.
- Pad within 53–72, neighbours 3–7 st apart, CC1 30–55 for "sehr weich".
- Stopped: stopped/muted patch ≥ 53 (f–sfz snarl, p echo); lower, a mute patch.
- Rip: 53 57 60 65 67 69 → accented long 72, or a rip articulation.
- Pan centre-left, rear, plenty of reverb.

## Checklist
- [ ] Notes 35–77 (31–34 long pedals only); harmony in 53–72.
- [ ] Chords voiced Hn1 > Hn3 > Hn2 > Hn4.
- [ ] Loud ≥ 72 and soft ≤ 45 notes doubled.
- [ ] Rest soon after notes ≥ 72; no > 2 bars of fast 16ths without rests.
- [ ] No soft (CC1 < 40) notes ≥ 72, stopped notes < 53 or exposed descending gliss.
- [ ] Brass tutti: horns doubled or heavy brass lower.

## Examples
- Chorale pad: Hn1 C5 (72), Hn3 G4 (67), Hn2 E4 (64), Hn4 C4 (60), pp–p.
- Heroic unison: G4–C5–D5–E5 (67 72 74 76), f, all horns, then 2 bars rest.
