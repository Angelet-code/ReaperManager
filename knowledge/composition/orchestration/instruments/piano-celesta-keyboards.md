---
id: orchestration.piano-celesta-keyboards
title: Keyboards in the orchestra — piano and celesta (hub)
aliases: [piano, pianoforte, celesta, célesta, teclados, instrumentos de teclado, tecla, pedal de resonancia, pedal tonal, sostenuto, una corda, pedal de sordina, piano preparado, piano vertical, piano de juguete, Klavier, Celesta, percusión con teclado]
domain: orchestration
tags: [keyboards, instrument, ranges, doubling, piano, celesta, percussive]
style_scope: universal (orchestral piano = late-19th/20th-c. and film practice; see Period practice)
use_when: Adding or checking a piano or celesta part inside an orchestral texture, or looking up any keyboard range (harpsichord, organ, harmonium, ondes in the split note).
summary: Piano 21–108 is an orchestral doubler first — short, incisive notes in extreme registers on pizz, staccato winds, xylophone or accents, never on legato pads; low register becomes percussion (tremolo with timpani and bass-drum rolls, dissonant chord ostinati). Celesta sounds an octave above written (60–108, sweet spot 72–96): a soft glitter doubling of harp, flutes, pizz or muted strings that vanishes in loud textures.
sources: ["unir-orq-tema8 p.9-16", "unir-orq-tema1 p.8-11", "adler-orq-es p.468-477", "adler-orq-es p.507-513, 536-544", "piston-orch p.340-350"]
related: ["[[piano-celesta-keyboards-organ-harpsichord]]", "[[percussion-section-writing]]", "[[harp]]", "[[mallet-percussion]]", "[[doubling-colour-and-decay]]", "[[stage-seating-pan-depth]]", "[[user-taste]]", "[[_instruments]]"]
---

# Keyboards in the orchestra — piano and celesta

## Core idea
Since the late 19th c. piano and celesta are real orchestral parts, not chord-filling continuo
(Adler). One keyboard player covers piano, celesta and harpsichord, one at a time. Harpsichord, organ,
harmonium, ondes: [[piano-celesta-keyboards-organ-harpsichord]].

| Instrument | Written → sounding | Full (sounding MIDI) | Practical / sweet | Dynamics |
|---|---|---|---|---|
| Piano | as written | 21–108 | 28–103 (general knowledge) | touch; pedals |
| Celesta | +12 | 60–108 (written C3–C7) | 72–96 (Adler, inferred); vault 72–103 | soft only |
| Harpsichord | as written | 29–89 | 29–89 | stops, no touch |
| Organ manual / pedal | key at 8'; 16' −12, 32' −24, 4' +12, 2' +24 | keys 36–96 / 36–67 | 36–96 / 36–55 | registration, swell |
| Harmonium | as written; stops ±12 | 29–89 (top uncertain) | — | bellows, stops |

## Rules
**Piano** — five roles (Adler, Piston): concerto soloist, obbligato, anonymous orchestral member,
percussion instrument, filler for missing parts.
- R1 `PREFER` doubling as its main job: the hammer attack makes any line incisive. Prefer extreme
  registers to the middle (Adler); the top octave brightens piccolos up to 108; RH an octave above LH
  adds upper partials (Piston).
- R2 `AVOID` doubling sustained legato parts or pads: the tone decays. Keep the part in fairly short
  values (Piston).
- R3 `PREFER` doubling pizz strings, woodwind staccato, xylophone, col legno violins. An accented
  octave on a string *sfp* sharpens the attack and dies with the *p* (Copland).
- R4 `AVOID` loud low staccato when pitch must read: it turns metallic (Piston). `ALLOWED` the low
  register as percussion: reinforcing timpani or bass drum (Adler), dissonant low chord ostinati
  (Bartók), a low tremolo with timpani and BD rolls as one mass (Prokofiev 5).
- R5 `ALLOWED` ff arpeggios on piano instead of harp, which would be covered (Adler); piano + harps
  + celesta in harp-like figuration; 2 harps + piano unison low accents + bass pizz + timpani (Britten).
- R6 `ALLOWED` solos and the theme over a sustained or repeated background. `AVOID` expecting a
  concerto effect: the orchestral piano sits at the back (Adler).
- R7 `ALLOWED` accompanist (Bernstein): RH staccato chords on each quarter, LH bass on 1 and 3, soft
  bass pizz on the bass notes, brushes on the rhythm.
- R8 `ALLOWED` small orchestra: piano covers missing harp and percussion and fills the horn register
  (Piston).
- R9 `MUST` name pedals correctly: right = damper, left = *una corda*, middle = *sostenuto* (holds
  only keys down when pressed, below middle C; missing on many uprights) (Adler).
- R10 `ALLOWED` hand limits (general knowledge): ≤ 5 notes and ≤ 16 st per hand.

**Celesta**
- R11 `PREFER` soft, decorative colour. `AVOID` exposing it against loud textures: it is covered
  (Piston).
- R12 `PREFER` doubling soft strings, harp, piano, flutes/piccolo or muted solo violins on the same
  chord tones: a silvery glitter (Adler, Piston; Strauss's silver rose).
- R13 `ALLOWED` melodies, chords, measured tremolos, runs with harp and piano, a short figure at a
  final cadence, one accent per chord change of high sustained strings (Bassett).
- R14 `AVOID` relying on true staccato or long sustain: resonators ring on (Adler), yet the tone is
  short-lived (Piston). Treat it as medium decay.

## Period practice
- `[era: Baroque–c.1770]` keyboard continuo: [[piano-celesta-keyboards-organ-harpsichord]].
- `[era: 19th c.]` the piano became an orchestral member only late in the century, first in France
  (Saint-Saëns, d'Indy, Debussy) (Adler); Piston dates the anonymous orchestral piano to the 20th c.
  Leave it out of Classical/Romantic pastiche except as a soloist.
- `[era: 20th c.]` piano replacing harp to avoid Romantic colour; upright piano for bar/Western
  colour; prepared, plucked or struck strings; toy piano; 4 pianos + percussion (*Les Noces*).

## Apply in MIDI / REAPER
- Doubling: copy the line to `PIANO`, `len` ≤ half the value, no CC64, vel one step above the line
  ([[dynamics-by-orchestration]]; f → 95–105). Prefer ≤ 40 or ≥ 84, not 60–72 (inferred); RH +12.
- Accent doubling: copy only notes with vel ≥ 100 to piano/xylophone.
- *sfp*: piano octave at the onset (vel ~100), strings' CC11 dropping right after it.
- Low rumble: alternating octaves 21–48 in 32nds, aligned with the timpani and BD rolls.
- Pedal (accompaniment only): CC64 127 just after each chord onset, 0 just before the next.
  CC66/CC67 only if the library maps them (inferred).
- User taste R1: real voicings with rolls and pedal; R15: lower the piano bed before raising melodies.
- Celesta: concert pitch, mostly 72–96, vel 40–80, `len` ≥ 0.5; same pitches as its harp/flute.
- Pan: rear, centre-left near the harp; when doubling woodwinds keep it near centre (Piston).

## Checklist
- [ ] Piano 21–108, ≤ 5 notes and ≤ 16 st per hand.
- [ ] Orchestral piano doubles short, accented or pizz material, not pads.
- [ ] No loud low staccato where pitch matters (unless intended as percussion).
- [ ] Celesta 60–108, only in soft, thin passages, doubled by harp/flute/strings.
- [ ] Piano and celesta not simultaneous unless two players are planned.

## Examples
- Brilliance: piccolo C7–E7 (96 98 100) + piano octaves 84/96, f, `len` 0.25.
- Celesta: E6–D6–C6–B5 (88 86 84 83) over pizz strings, pp, harp on the same notes.
