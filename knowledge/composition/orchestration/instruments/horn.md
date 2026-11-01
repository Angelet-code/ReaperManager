---
id: orchestration.horn
title: Horn (French horn)
aliases: [trompa, trompas, corno, corno francés, Horn, Waldhorn, cor, notas tapadas, bouché, cuivré, schmetternd, gestopft]
domain: orchestration
tags: [brass, instrument, ranges, registers, transposition]
style_scope: universal
use_when: Writing, checking or voicing horn parts (sustained harmony, heroic melodies, stopped effects).
summary: Horn in F sounds a 5th below written, B1–F5 (35–77); its home is concert F3–C5 (53–72), bright and heroic, with dark low notes and a brilliant, tiring top (72–77). It is the glue between woodwinds and strings: four horns in close mid-register harmony, unison horns for heroic tunes, rests after high passages.
sources: ["unir-orq-tema6 p.4-12", "unir-orq-tema1 p.11-15"]
related: ["[[trumpet]]", "[[trombone]]", "[[bassoons]]", "[[transposing-instruments]]", "[[_instruments]]"]
---

# Horn (French horn)

## Core idea
Descends from the natural horn with crooks (Classical works use two pairs crooked in different keys);
valves since ~1840. Standard today: **double horn F/Bb**, written in F, treble clef (bass clef sometimes),
**sounds a P5 (7 st) below written**. Long, narrow tube → round, blending tone, softer attacks than trumpet.

| Zone | Sounding MIDI | Written | Colour |
|---|---|---|---|
| Pedal (Bb side) | 31–34 | D2–F2 | insecure, hard to tune; rare |
| Very low | 35–40 | F#2–B2 | weak, foggy (general knowledge) |
| Low | 41–49 | C3–G#3 | dark, a bit unfocused |
| Low-middle | 50–52 | A3–B3 | deep and solid |
| Middle–high | 53–71 | C4–F#5 | bright and heroic: the home register |
| Top | 72–77 | G5–C6 | brilliant and loud, tiring |

Full range **35–77** (31–34 pedals), practical **41–74**.

## Rules
- R1 `PREFER` writing mainly in the central register (53–72).
- R2 `AVOID` frequent pedal/very low notes (31–40): hard to tune, use sparingly.
- R3 `MUST` give rests after passages in the top register (72–77), even short or fast ones.
- R4 `PREFER` four horns as **harmonic filler**: close-position chords in the middle register, soft
  (Humperdinck *Hänsel und Gretel* overture chorale with 2 bassoons).
- R5 `ALLOWED` heroic melody with horns in unison, concert ≈ C4–F5 (60–77); keep the climax notes (72–77) short-lived.
- R6 `ALLOWED` stopped notes (+, bouché, gestopft): muted, nasal, metallic; "o" = open. Cuivré/schmetternd:
  brassy, blaring forte.
- R7 `ALLOWED` double/triple tonguing exist, but horn attacks are less penetrating than trumpet's;
  `AVOID` long fast articulated passages; rest the tongue after them.
- R8 `ALLOWED` soft tonguing, lyrical solos in the warm middle register (Tchaikovsky 5/II, Ravel *Pavane*).
- R9 `PREFER` breathing (general knowledge): loud sustained notes ≈ ≤ 6–8 s; give a breath every 2–4 bars in f.
- R10 `PREFER` doublings: horn + bassoon (blend; chorales), horn + cello or viola (warm melody), horns +
  clarinets on sustained harmony, horn an octave below trumpet in fanfares (general knowledge), horns +
  trombones in a brass chorale (horns on top-middle voices).
- Style: Classical = 2 horns (glue between woodwinds and strings, held harmony); Romantic = 4; late
  Romantic 6–8 (Mahler 1, Strauss *Don Juan*).

## Apply in MIDI / REAPER
- Tracks `Hn 1-2`, `Hn 3-4` (or a 4-horn ensemble patch + solo horn). Concert pitch in MIDI;
  written = +7 when producing parts.
- Articulations: sustain/legato, marcato/short (velocity), sfz, stopped/muted, cuivré/rips, flutter, trills.
- Dynamics: middle register CC1 40–100 usable; top 72–77 only f (CC1 ≥ 80); low 41–49 read soft even at
  high CC1 — double with trombone or bassoon if it must be heard.
- 4-horn pad: voice within 53–72, adjacent notes 3–7 st apart (close position), CC1 30–55 for "sehr weich".
- Pan: centre-left rear (horns face backward; plenty of reverb).

## Checklist
- [ ] All notes 35–77 (31–34 only as rare pedals); mostly 41–74.
- [ ] Sustained harmony sits in 53–72.
- [ ] After any bar with notes ≥ 72, at least ≈ 1–2 bars of rest within the next few bars.
- [ ] No long runs of fast repeated 16ths (> 2 bars) without rests.
- [ ] Soft (CC1 < 40) notes avoided at ≥ 72.

## Examples
- Chorale pad (concert): Hn1 C5 (72), Hn2 G4 (67), Hn3 E4 (64), Hn4 C4 (60), pp–p.
- Heroic unison: G4–C5–D5–E5 (67 72 74 76), f, then 2 bars rest.
