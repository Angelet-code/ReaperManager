---
id: orchestration.string-section-writing-homophony
title: String section chords, spacing and divisi (homophonic writing)
aliases: [escritura homófona para cuerda, distribución, disposición de acordes en la cuerda, serie armónica, divisi, non divisi, acordes de cuerda, coral de cuerda, partes reales, homophoner Streichersatz]
domain: orchestration
tags: [strings, homophony, chord-spacing, divisi, doubling, voicing]
style_scope: universal
use_when: Voicing chords, a chorale, a hymn-like progression or a pad for strings, choosing which section takes which chord tone, or deciding when to divide sections.
summary: Space string chords like the harmonic series (wide at the bottom, close at the top) in the order Cb–Vc–Vla–Vln II–Vln I; pick the colour by distribution (violas/cellos divisi = dark, everything an octave or two up without basses = luminous, cellos + basses on the bass = intense). Divide Vln II, Vla and Vc for rich chords but keep Vln I undivided and reinforced; give the basses one well-placed note.
sources: ["adler-orq-es p.143-152", "piston-orch p.374-385"]
related: ["[[string-section-writing]]", "[[texture-part-writing-chorale]]", "[[four-part-voices-and-spacing]]", "[[doubling-rules]]", "[[chord-voicing-family-stacking]]", "[[string-techniques-stops-and-divisi]]", "[[dynamics-by-orchestration]]", "[[cello]]", "[[double-bass]]"]
---

# String chords, spacing and divisi

## Core idea
With one colour, **spacing, register and line shape** decide who plays which chord tone; close 4-part
writing can be distributed in many ways, each with its own colour. Hub: [[string-section-writing]];
voice-leading basics: [[four-part-voices-and-spacing]].

## Rules
- R1 `PREFER` Space a full chord like the harmonic series: octave or fifth between the lowest voices,
  3rds and 4ths at the top. Traditional order, low to high: Cb – Vc – Vla – Vln II – Vln I (Adler).
- R2 `ALLOWED` Basses an octave lower and a wider top: slightly darker; fine at p or f (Adler).
- R3 `PREFER` Choose the distribution of a close 4-part progression by colour (Adler):

| Distribution | Colour |
|---|---|
| Vln I = S, Vln II = A, Vla = T, Vc = B, Cb = Vc − 12 | neutral, fine p–mf; heavy at f (low strings in a stronger register than the violins) |
| Vla div. a2 on S/A, Vc div. a2 on T/B | dark, "old" |
| the same + Cb on the bass an octave lower | darker still |
| Vln I on S, Vln II (or Vla div.) on A/T | slightly brighter, still subdued |
| all on cellos div., Cb doubling the bass an octave lower | very intense |
| whole progression one or two octaves up, no Cb | luminous |

- R4 `PREFER` In rich chordal writing divide Vln II, Vla and Vc but keep **Vln I non divisi**, and
  reinforce its melody notes with double stops or with another section in unison (Adler, Tchaikovsky
  *Serenade*).
- R5 `PREFER` The same melody pitch is stronger in Vln I than in Vln II; crossing Vln II and Vla around
  it emphasises it further (Adler).
- R6 `ALLOWED` To bring the harmony forward, cross Vln II inside the Vln I notes and reinforce it with Vla
  and Vc (Adler).
- R7 `PREFER` Give the basses **one** note (usually the root or tonic): a chord on the basses needs divisi.
  Low C2 (36) on the cellos is sonorous enough to be the bass of a big chord (Adler).
- R8 `PREFER` No awkward fingering in any section (Adler); see [[string-techniques-stops-and-divisi]].
- R9 `AVOID` In 4-voice first-inversion chords, doubling the bass (the third), except when its root is
  degree 1, 2, 4 or 5 (VI6, VII6, II6, III6). `MUST` with more voices, put the doubled third near the bass
  (bass in octaves) and keep the upper voices on root and fifth (Adler). See [[doubling-rules]].
- R10 `ALLOWED` Melody restated ff by Vc + Cb in octaves (Cb fairly high: very intense) if the upper strings
  hold thin middle-register chords that cannot cover it (Adler, Tchaikovsky).
- R11 `PREFER` A full chord right after pale, thin harmony sounds clamorous (Adler).
- R12 `ALLOWED` Write a diminuendo into the scoring: close, high spacing (tense) relaxing into a singing,
  homogeneous one. Fading end: every part in an easy soft register, the cadence repeated, the bass dropped
  on the tonic arrivals (Adler).
- R13 `ALLOWED` Two real parts sound full when each is doubled in octaves: Vln I with Vln II 8vb; Vla + Vc
  with Cb 8vb (Piston, Mozart K.200). Three or four real parts are the norm (Piston).
- R14 `ALLOWED` Divide the cellos so some double the bass and some double the violas (Piston).
- R15 `ALLOWED` Double every note at the octave (organ 8' + 4'); change the doubling between antecedent and
  consequent (Vln II doubling Vln I instead of adding harmony) to articulate them (Adler, Grieg).
- R16 `ALLOWED` At a cadence Vln I may leave the melody to join the chords (Piston).

## Period practice
- `[era: 1960s Polish sonorism, Penderecki *Threnody*]` Divide every section down to single players, each
  on one pitch of a chromatic or quarter-tone cluster, shaped by dynamics (ff → sub. pp; fff → pppp over
  30"), vibrato and bow position instead of harmony (Adler). MIDI: one note per semitone on separate divisi
  tracks, quarter tones by ±50-cent pitch bend; libraries rarely have the extended bow effects.

## Apply in MIDI / REAPER
- Tracks: `Vln I`, `Vln II a/b`, `Vla a/b`, `Vc a/b`, `Cb`. A divided section has about half weight per
  part: raise divisi CC1 slightly or accept a softer chord (inferred).
- Spacing check (inferred from R1): lowest two voices ≥ 7 st apart, adjacent upper voices ≤ 5 st, no gap
  > 12 st between upper voices.
- Sixth chords: count voices on the third; more than one outside the bass octave → re-voice.
- Fading ending: thin the voicing and lower the top note besides lowering CC1.
- (inferred) Ensemble patches (Albion `Strings - Long`) play every chord note at full section weight, so
  keep chords there to 3–5 notes with a single bass note.

## Checklist
- [ ] Wide at the bottom, close at the top; order Cb–Vc–Vla–Vln II–Vln I unless crossing on purpose.
- [ ] Vln I not divided; its melody notes reinforced.
- [ ] Cb plays one note.
- [ ] No doubled thirds in upper voices of 6-chords.
- [ ] Distribution matches the intended colour (dark, neutral, intense, luminous).

## Examples
- E major tutti chord (illustration of R1): Cb E2 (40), Vc E3 B3 (52 59), Vla E4 (64), Vln II G#4 (68),
  Vln I B4 E5 (71 76).
- Luminous hymn (illustration of R3): I–IV–V7–I with S/A on Vln I div., T/B on Vln II div., about 72–88,
  no Cb, pp.
