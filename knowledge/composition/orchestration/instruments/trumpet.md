---
id: orchestration.trumpet
title: Trumpet (modern C and Bb)
aliases: [trompeta, trompetas, trompeta en do, trompeta en si bemol, Trompete, tromba, trompette, trompeta con sordina, mit Dämpfer, picado doble, picado triple, trino de trompeta, fanfarria, caída, fall, rip de trompeta]
domain: orchestration
tags: [brass, instrument, ranges, registers, transposition, articulation, doubling]
style_scope: universal
use_when: Writing, checking or voicing modern trumpet parts (melody, fanfare, tutti punctuation, fast tonguing, muted colour).
summary: C trumpet 54–84, Bb 52–84 (sounds a M2 below written; Piston tops it at 82); melodies in ≈ 58–79, top register loud only. The most incisive, fastest-tonguing brass, best at fanfares, accents, repeated notes and parallel triads in a section; never double an open trumpet in unison with non-brass, and give it rests. Other trumpets in trumpet-family-auxiliary, period style in trumpet-period-practice.
sources: ["unir-orq-tema6 p.13-19", "unir-orq-tema1 p.11-15", "adler-orq-es p.325-326", "adler-orq-es p.330-336", "piston-orch p.253-262"]
related: ["[[brass-basics]]", "[[brass-basics-mutes]]", "[[trumpet-family-auxiliary]]", "[[trumpet-period-practice]]", "[[horn]]", "[[trombone]]", "[[timpani]]", "[[brass-section-writing]]", "[[transposing-instruments]]", "[[tutti-balance-by-role]]", "[[_instruments]]"]
---

# Trumpet (modern C and Bb)

## Core idea
Orchestral standard since c.1900: the short (4-ft) **C** trumpet (non-transposing; concentrated, intense,
delicate, easier highs) or **Bb** (sounds M2 = 2 st lower; thicker, fuller, excellent low register; the
band and jazz standard). Treble clef, piston valves. Whatever the score names, the player picks the
instrument (Adler). Mechanics: [[brass-basics]]; mutes: [[brass-basics-mutes]].

| Instrument | Written → sounding | Full (vault default) | Practical | Melodic comfort (Piston) |
|---|---|---|---|---|
| C | as written | 54–84 | 57–81 (general knowledge) | 60–79 |
| Bb | −2 (written F#3–D6) | 52–84 | 55–79 | 58–77 |

Variants: Adler gives both tops as written C6/D6 = 84 (C and Bb); Piston puts the normal Bb top at
written C6 = **82** and calls written D6 extreme. Written D6 on the C trumpet (86): avoid.

Registers (Bb sounding; C trumpet +2): **52–59** low, dull and muffled (UNIR, Adler), yet full and
solemn at mf–f (Piston, Shostakovich 5) · **60–77** middle, clear, brilliant, most articulate; every
dynamic for professionals · **78–84** high, brilliant, strident, the most penetrating; beautiful at p but
hard to play softly. Adler's "clear" band may reach written A5 [?].

## Rules
- R1 `PREFER` melodies in the comfort band; peaks beyond it on purpose (Hindemith *Concerto for Orchestra*).
- R2 `AVOID` soft dynamics in the high register and long exposed pp there; pp in the low register is also
  hard. Adler: it is safer to write loud than soft.
- R3 `PREFER` the trumpet for incisive separate tonguing, accents, sfz/fp and fast repeated notes: the
  fastest-phrasing brass (Adler); its double and triple tonguing is the lightest of all winds (Piston).
  Works even muted at pp (Debussy *La Mer*).
- R4 `AVOID` long bursts of double/triple tonguing without rests (Verdi *Aida* fanfares).
- R5 `PREFER` fanfare and "pronouncement" material; Adler: the colour of anticipation or agitation.
- R6 `ALLOWED` fast scale runs, though not the trumpet's best style; dazzling in a loud tutti that thins
  at once to pizzicato and timpani (Ravel *Daphnis*).
- R7 `PREFER` 3–4 trumpets in close-position parallel triads, melody on top (Casella, Ravel).
- R8 `AVOID` open trumpet in **unison** with woodwinds or strings: it covers them (Piston). `ALLOWED`
  octave doublings, and muted trumpet + English horn in unison (blends; *La Mer*).
- R9 `PREFER` doublings: trumpets + timpani at cadences; trumpet an octave above horns in fanfares;
  trumpets + trombones in chorales (general knowledge for the last two).
- R10 `MUST` rest the lips: one slur = one breath, shorter phrases when loud and slow, ≥ 1 bar rest every
  ≈ 8 bars in loud cues (general knowledge), more after high passages ([[user-taste]] R16).
- R11 `ALLOWED` valve trills (one valve: best); lip trills only high. `AVOID` trills that move two or three
  valves, worst low: written Ab3–Bb3, C4–Db4, B3–C#4 (Adler, Piston).
- R12 `AVOID` (live parts) long, soft, exposed notes on the 1+3 / 1+2+3 fingerings: written F#3, G3, C#4,
  D4 = Bb concert 52, 53, 59, 60 (Piston). Irrelevant for samples.
- R13 `ALLOWED` upward lip glissando/rip, only in the high register; `[era: 20th c., jazz]` falls
  (bend down ¼–½ tone) and rips in both directions.
- R14 `ALLOWED` mutes (straight by default): fff piercing (Stravinsky *Petrushka*) or p echo and distance
  (Berg Violin Concerto, Debussy *Fêtes*). `NEVER` hand-stopping.
- R15 `AVOID` leaning on the extreme top; a part that lives there goes to the D trumpet. `NEVER` the
  fundamental (written C3) `[era: Piston 1955]`; `ALLOWED` pedal notes `[era: late 20th c., jazz-derived, Adler]`.

## Apply in MIDI / REAPER
- Tracks `TPT 1`, `TPT 2`, `TPT 3` after the horns in the BRASS folder; concert pitch (written Bb = +2).
- Patches: Albion ONE `Trumpets XL - Long/Short` (captured); a SWAM trumpet follows [[user-taste]] R17
  and [[modeled-instruments-swam]].
- Shorts: velocity follows the phrase, 70–120; fast repeats at 50–70 % of the grid, group starts +10–15
  (inferred).
- Longs: CC1 performs. In a tutti a trumpet melody sits near CC1 84 while horns play 110+
  ([[tutti-balance-by-role]] R5). Notes ≥ 78 need CC1 ≥ 75.
- sfz-p-cresc: velocity 115+, CC1 down to ≈ 40 within ½ beat, swell over 1–2 bars.
- Muted: a muted patch or articulation, never an open patch at low CC1 (Adler).
- Rip: library rip, or 3–4 fast series notes into the target in the last ½ beat (e.g. 67 72 76 → 79).
- Pan centre-right, rear.

## Checklist
- [ ] Bb notes 52–84 (C 54–84); most melodic notes in the comfort band.
- [ ] No p/pp (CC1 < 50, vel < 50) at ≥ 78.
- [ ] Repeated-16th bursts ≤ ≈ 2 bars, then rest; ≥ 1 bar rest per ≈ 8 loud bars.
- [ ] No open-trumpet unison with woodwinds or strings.
- [ ] Glissandi only upward into high notes; muted passages use a muted patch.

## Examples
- Cadential fanfare in D: D4–A4–D5 (62 69 74) with timpani A2/D3 (45/50).
- Section planing, TPT 1/2/3 top-down: 67 64 60 → 69 65 62 → 71 67 64 (C, Dm, Em close triads), f, staccato.
- Muted echo: B4–G4 (71 67), p, straight mute, answering the same figure played open.
