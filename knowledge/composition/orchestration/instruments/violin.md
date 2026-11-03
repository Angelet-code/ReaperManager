---
id: orchestration.violin
title: Violin (Vln I / Vln II)
aliases: [violín, violines, violín primero, violín segundo, primeros violines, segundos violines, concertino, violín solista, violín solo, cuerda sol, cuerda mi, sul G, sul E, cuerdas al aire, Violine, Geige, G-Saite, violino, violon]
domain: orchestration
tags: [strings, instrument, ranges, registers, roles, doubling, solo]
style_scope: universal
use_when: Writing, checking or voicing a violin I / violin II part (section or solo) in MIDI: range, string colour, Vln I/II roles, solos and doublings.
summary: Violin sounds as written; sections G3–E7 (55–100), most secure 55–88, Classical pastiche ≤ A6 (93), solo to ≈ B7 (107). Colour follows the string, not the octave: E (76+) brightest and strongest, G (55–72) dark and second in power, D (62–74) weakest, A (69–81) strong low and softer high. Vln I carries the themes; Vln II doubles it or accompanies. Positions, leaps, chords and harmonics are in [[violin-technique-limits]].
sources: ["unir-orq-tema4 p.5-7, 15-21", "apuntes-orq-sesion1 scan p.5-6", "unir-orq-tema1 p.8-11", "adler-orq-es p.51-65", "piston-orch p.31, 37-64"]
related: ["[[violin-technique-limits]]", "[[string-techniques]]", "[[string-techniques-stops-and-divisi]]", "[[string-section-writing]]", "[[orchestra-sizes-and-section-balance]]", "[[stage-seating-pan-depth]]", "[[viola]]", "[[cello]]", "[[flute-piccolo]]", "[[_instruments]]"]
---

# Violin (Vln I / Vln II)

## Core idea
Soprano of the strings, the most versatile string instrument. Open strings **G3 D4 A4 E5 (55 62 69 76)**,
treble clef, non-transposing. The string ranges overlap, so colour depends on **which string** plays a
note more than on its octave (Piston). Two sections, one line each unless divisi.

| Zone | MIDI | Colour |
|---|---|---|
| G string | 55–72 (sul G to 74) | dark, second in power; broad intense melodies; ferocious accents; hoarse at its top |
| D string | 62–74 | weakest: calm, subdued, warm |
| A string | 69–81 | strong in 1st position, softer higher: soft lyrical lines |
| E string | 76–88 | most carrying power; strident if forced, luminous or mysterious when soft |
| High extension | 89–93 | less power, harder intonation |
| Extreme | 94–100 | orchestral ceiling; few, short, doubled |
| Solo only | 101–107 | harmonics to ≈ 110 (approx.) |

55–61 exist only on the G string, 95+ only on the E string (Adler).
**Range default:** full 55–100, practical 55–88. Variants: Adler and Piston cap orchestral parts at E7
(100); Adler allows ≥ 107 for solo; his Classical cap is A6 (93).

## Rules
- R1 `MUST` every note ≥ 55. `AVOID` section notes > 93; `NEVER` > 100 in orchestral parts.
- R2 `ALLOWED` above 100 only with a few desks plus a woodwind unison (Strauss *Zarathustra*: G#7 ≈ 104,
  two desks + piccolo; Piston).
- R3 `ALLOWED` sul G melody for intensity: cautious top C5 (72, Piston), D5 (74) vault default; also to
  keep power in the D-string range (Bartók *Concerto for Orchestra*).
- R4 `PREFER` high brilliance → E string; a soft expressive phrase in 74–81 stays on the A string (Adler,
  Piston). Mark `sul …` only for a deliberate colour.
- R5 `AVOID` exposed held open strings (55/62/69/76) in expressive melody (no vibrato). `ALLOWED` in fast
  figures and for their ring (Brahms 4).
- R6 `PREFER` détaché for energetic runs; Vln I + II in unison add energy and volume (Mozart K.543).
- R7 `PREFER` divisi over multiple stops in sections; `AVOID` wide section leaps, above all legato
  ([[violin-technique-limits]]).
- R8 `MUST` an orchestral solo is the concertmaster; two soloists = the first desk, or concertmaster +
  principal second (Adler). Solo patch, never the section at low CC1.
- R9 `PREFER` a solo violin for its intimate, intense tone, not merely less volume. It carries well; keep
  the tutti under it thin and soft (Brahms 1/ii; Piston).
- R10 `PREFER` roles: Vln I = top voice, most themes. Vln II = mostly doubling Vln I at unison or octave;
  else a 3rd/6th below, accompaniment, a secondary melody, or the tune for variety. It is technically
  close to Vln I (Piston).
- R11 `ALLOWED` split a fast line between Vln I and II in alternating fragments that meet on a shared
  unison note (Brahms 4): simpler parts, more energy.
- R12 `ALLOWED` divided violins or 2–4 solo violins alone as a chamber texture (Liszt *Faust*).
- R13 `ALLOWED` antiphonal seating (Vln I left, II right) for call and response (Beethoven 7). Piston: the
  effect is much reduced in practice; treat it as colour.
- R14 `PREFER` doublings: + flute (unison or 8va) for brilliance; Vln I + II in octaves for weight; +
  oboe/clarinet unison for colour; + piccolo high; violas 8vb under a ff tune (Berlioz *Fantastique*).
- R15 `MUST` in loud tutti, double the violin line or thin the brass (Piston).
- R16 `AVOID` a trill on open G3 (55); a section trill is shimmer, a crisp trill belongs to a soloist
  (Piston).

## Period practice
- `[era: Classical, Adler]` top A6 (93). `[Piston]` 6–10 per violin section; Vln II doubled Vln I to
  balance horns and trumpets.
- `[era: late Romantic/Viennese c. 1890–1930, Piston]` audible portamento on wide upward slurred leaps
  (*Rosenkavalier*); Classical shifts stay clean.
- `[era: before c. 1925, Piston]` gut E string: silkier, mellower top.
- `[era: Baroque, UNIR]` flute parts often just double the violins.

## Apply in MIDI / REAPER
- Tracks `Vln I`, `Vln II`, `Vln I div a/b`, and a separate `Vln solo`.
- Articulation → patch: [[string-techniques]]. CC1 for longs, velocity for shorts.
- Register = colour: intense 55–72 mf–f; veiled 62–74 p (double it at f); glowing 76–96 pp–p (CC1 ≤ 45);
  brilliant 76–93 f–ff (CC1 100–127).
- Hocket (R11): Vln I plays bars 1–2, Vln II enters on the last note of bar 2 in unison.
- Solo ≈ +5 dB over its bed by performance, not faders; bow changes ~4 s at f, ~10 s at pp
  ([[user-taste]] R15–R16).
- Pan from [[stage-seating-pan-depth]]: Vln I L55–60; Vln II L30 (modern) or R60 (antiphonal).

## Checklist
- [ ] Section notes 55–100, mostly 55–88; 94–100 few, short or doubled; ≥ 101 only on a solo track.
- [ ] Classical pastiche ≤ 93.
- [ ] Leaps and chords pass [[violin-technique-limits]].
- [ ] Fast runs (16ths ≥ ~120 bpm) on a short/détaché patch.
- [ ] Vln II not above Vln I for long unless intended; loud tutti melody doubled or brass thinned.

## Examples
- Sul G cantabile: D4–G4–B4–D5 (62 67 71 74), f espressivo, CC1 90–105 (Tchaikovsky 5/ii model).
- Soft E-string line: E5–B5–A5–E6 (76 83 81 88), pp, CC1 30–45 (Prokofiev *Classical*/ii model).
