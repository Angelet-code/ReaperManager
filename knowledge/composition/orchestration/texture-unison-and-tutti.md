---
id: orchestration.texture-unison-and-tutti
title: Orchestral unison and tutti
aliases: [unísono orquestal, tutti orquestal, tutti, todos, a2, a3, unísono de colores, octavas, tutti parcial, gran tutti, tutti al unísono, tutti a la octava, tutti multi-octava, unísono real, duplicación a la octava]
domain: orchestration
tags: [texture, unison, tutti, brass-support, register]
style_scope: universal (Beethoven to film)
use_when: A request says "unison", "all together", "tutti", "full orchestra", "épico todos juntos", or a climax needs the whole orchestra.
summary: A unison gives one line to several timbres (actual unison or spread in octaves, which the ear hears as one line); use only instruments whose good register holds the whole line. A tutti (partial or grand) spreads the orchestra over about four octaves, weighted in the middle; strings and woodwinds carry a fast line while brass and timpani sustain or punctuate. Reserve the grand tutti and each family's strongest register for the structural peak.
sources: ["unir-orq-tema3 p.5-8", "httyd-test-drive p.5-8", "adler-orq-es p.547-556, 570-578", "piston-orch p.357-363, 426-430"]
related: ["[[texture-unison-and-tutti-layouts]]", "[[texture-types]]", "[[doubling-colour-and-decay]]", "[[building-and-releasing-climaxes]]", "[[heroic-theme-orchestration]]", "[[dynamics-by-orchestration]]", "[[tutti-balance-by-role]]", "[[texture-accompanied-melody-doubling-the-tune]]"]
---

# Orchestral unison and tutti

## Core idea
**Unison** (type I): one line, several instruments. An **actual unison** puts everyone on the same
pitch for a mixed colour; an **octave unison** spreads the line over two or more octaves, which the ear
still hears as one element because the partials agree (Piston). **Tutti:** most (partial tutti) or all
(grand tutti) instruments play (Adler), each in its best register, often with different material. Ready
octave-by-octave layouts are in [[texture-unison-and-tutti-layouts]].

## Rules
- R1 `PREFER` For a colour unison, use 2–4 timbres at unison or octave (e.g. flute + oboe + violins,
  clarinet + viola) at p–mf.
- R2 `MUST` Use only instruments whose comfortable range holds the whole line. Drop the others, or let
  them break off or jump an octave where range or a weak register forces it (Adler, Piston).
- R3 `AVOID` Doublers that reach the line only in a poor register, e.g. trumpets in a mixed unison below
  about D4 (62, inferred): their tone sticks out (Piston).
- R4 `PREFER` Trombones in a strong unison very soft (ppp against f elsewhere): body without
  domination. Violins sul G (55–67) and cellos on the A string (57+) make a low-register unison
  powerful; a viola tremolo inside it adds glow (d'Indy, *Istar*).
- R5 `PREFER` For a tutti, spread the orchestra over about **four octaves**, from the bass around D2
  (38) to the top around D6 (86), with most instruments on the middle octaves and few at the extremes
  (Beethoven 9/I; see the layouts note).
- R6 `PREFER` In a fast, energetic tutti give the agile line to woodwinds + strings and let brass and
  timpani sustain harmony or punctuate on strong beats (Smetana). `AVOID` doubling a fast 8th-note tune
  in trumpets/horns (clumsy). `AVOID` removing brass entirely (fragile).
- R7 `ALLOWED` A high flute or piccolo an octave above the top line as upper-partial reinforcement.
  `AVOID` a single flute alone in its top register carrying the tutti; double it a2 for weight (Adler).
- R8 `ALLOWED` (film) A brass section in unison carrying the melody (12 horns a12 in HTTYD) is a power
  statement, not a colour unison. Then the strings take the motor or harmony and trombones play close
  triads (see [[heroic-theme-orchestration]]).
- R9 `PREFER` **Keep something in reserve:** hold back trumpets and high woodwinds for the consequent
  phrase (Piston); keep a family's strongest register and the top octave for the key gesture (Adler).
- R10 `PREFER` Climax in unison: add brass and timpani to the note the orchestra already holds, then
  release into a multi-octave statement; mark the arrival with a fresh low entry (Trb 3, tuba, timpani)
  (Adler). A multi-octave unison also introduces or recapitulates a theme; bridge from it into a chordal
  tutti with tonic/dominant pedals in brass and timpani.
- R11 `ALLOWED` Contrast articulations inside a unison tutti: legato woods and horns against detached
  strings and a viola tremolo (Adler).
- R12 `AVOID` Doubling every line in a tutti. One melody in octaves + one bass in octaves + harmony in
  the middle is enough.

## Apply in MIDI / REAPER
**Colour unison** (one line, 3 tracks, p–mf):
- `FL` takes the line at written pitch if it lies in 72–93, otherwise 12 semitones up.
- `OB` takes the same pitches when they lie in 62–86.
- `VLN I` takes the same pitches. Use a legato patch, CC1 45–65.
- Copy the **same notes** to all tracks, then humanize each track separately by ±5–10 ms.
- Range lint: check each doubler against `data/instruments.json`; cut or octave-shift only the
  out-of-range phrase, at a phrase boundary.

**Tutti** (melody in D, four layers):
| Layer | Tracks | Register (MIDI) | Material | CC1 / vel |
|---|---|---|---|---|
| Melody, top octave | PICC/FL, VLN I | 74–93 | tune 8va | CC1 95–110 |
| Melody, main octave | OB, CL, VLN II, (HN a4) | 62–81 | tune | CC1 95–110 |
| Harmony / punctuation | TPT, HN, TBN, TIMP | 50–74 (brass), 38–55 (timp) | chord tones on beats 1 and 3, held or accented | shorts vel 100–115, longs CC1 90–105 |
| Bass in octaves | VC, CB, BSN, CBSN, TUBA | 26–50 | roots | CC1 100–110 |

- Brass inside a unison tutti: CC1/velocity 20–30 below the strings and woods so they reinforce
  without covering (Adler digest, inferred values).
- Balance with the performance, not faders (user-taste R15): in a tutti the melody stem may measure
  below the bed; register and colour carry it. Lower the heavy bed before raising the tune.
- Spread check: top melody note minus lowest bass note ≈ 42–50 semitones.
- Percussion: cymbal and timpani on the arrival downbeat only (see [[film-percussion-phrase-marking]]).

## Checklist
- Unison: identical rhythm in all tracks, dynamic mf or less (colour unison)?
- Does every doubler stay in a good register for the whole line, or break off at a phrase boundary?
- Tutti: span ≥ about 40 semitones, most instruments in the middle octaves?
- Do the brass support the harmony rather than double a fast melody (unless R8 is intended)?
- Is something held in reserve for the peak (trumpets, top octave, strongest register)?
- At most four simultaneous layers?

## Examples
- d'Indy, *Istar*: actual unison in EH, clarinets, bass clarinet, bassoons, 4 horns, trombones ppp,
  violins sul G, cellos; violas tremolo; flutes, oboes, trumpets tacet.
- HTTYD b.32: theme in flutes + horns 1–6 + Vln I/II (octaves) + cellos in treble clef over a D pedal;
  violas play a 16th motor, clarinets a gallop figure.
