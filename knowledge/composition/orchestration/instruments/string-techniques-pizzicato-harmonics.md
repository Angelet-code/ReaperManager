---
id: orchestration.string-techniques-pizzicato-harmonics
title: String pizzicato variants and harmonics
aliases: [pizzicato, pizz., arco, pizzicato con la mano izquierda, pizzicato de mano izquierda, pizzicato Bartók, pizzicato de uña, quasi chitarra, a la chitarra, non arpegg., dejar vibrar, l.v., gezupft, armónicos, armónicos naturales, armónicos artificiales, flageolet, Flageolett, Flageolettöne, sons harmoniques, armonici, nodo, sul G, sul Sol]
domain: orchestration
tags: [strings, pizzicato, harmonics, sample-library]
style_scope: universal
use_when: Writing pizzicato (switch timing, chords, snap or left-hand pizz, long pizz passages) or string harmonics (choosing natural or artificial, computing the sounding pitch).
summary: Pizz decays like staccato, rings longer on basses and open strings, needs time to switch (more for pizz→arco), strums chords bottom-up unless marked non arpegg., and tires players in long fast passages (about 6 notes/s, share the line). Natural harmonic = open string + 12/19/24/28 st (partials 2–5, safest orchestrally); artificial = stopped note + 24 (touch a 4th above), never on double bass; both are soft, pure colour.
sources: ["unir-orq-tema4 p.5-14", "adler-orq-es p.33-39, 41-47", "piston-orch p.23-31"]
related: ["[[string-techniques]]", "[[string-techniques-stops-and-divisi]]", "[[string-techniques-colour-effects]]", "[[plucked-strings]]", "[[harp]]", "[[violin]]", "[[cello]]", "[[double-bass]]"]
---

# String pizzicato variants and harmonics

## Core idea
**Pizzicato** turns a bowed section into a plucked one: short, percussive, warm on low strings, brittle
up high. **Harmonics** touch the string lightly at a node: the fundamental drops out and a pure,
flute-like partial sounds. Both are colours, not a main line at full power.

## Rules
**Pizzicato**
- R1 `MUST` mark *pizz.* at the start and *arco* at the return.
- R2 `MUST` leave time to switch. Pizz→arco needs more than arco→pizz (the hand regrips the frog); after
  a down-bow that ends at the tip, allow the most. An up-bow before the pizz brings the hand near the frog.
  Per-bar alternation is common (Berlioz *Harold*, Debussy *Pelléas*).
- R3 `MUST` treat pizz as short: it decays fast. Ring is longest on basses, then cellos, and on open
  strings; *l.v.* (let vibrate) asks for full ring; vibrato lengthens a stopped pizz slightly.
- R4 `ALLOWED` high-position pizz is hard and dry, a brittle colour (Ravel *Daphnis*).
- R5 `MUST` 3–4-note pizz chords roll **bottom-up** unless marked *non arpegg.*; two notes can be plucked
  together with two fingers. Repeated strummed chords alternate direction (*quasi chitarra*, arrows).
- R6 `AVOID` long, fast pizz without rests, above all loud, on big instruments or with many string
  crossings: one finger plucks. Share the line between Vln I/II or Va/Vc and add rests (Tchaikovsky 4/III).
  A practical top is about 6 notes/s in the middle register (Dukas *Apprenti sorcier*).
- R7 `ALLOWED` left-hand pizz (`+`): single notes or a descending run on one string, mostly on open
  strings; more solo than orchestral.
- R8 `ALLOWED` Bartók (snap) pizz: the string slaps the fingerboard. Nail pizz is rarer. Their signs imply
  pizz.

**Natural harmonics**
- R9 `MUST` sounding pitch = open string + interval of the partial: 2nd +12, 3rd +19, 4th +24, 5th +28,
  6th +31 (touch at 1/2, 1/3, 1/4, 1/5 of the string).
- R10 `PREFER` partials 2–5 on violin and viola (violin up to 6); cello and bass reach 7–8 more easily
  (Adler's bass chart goes to 10). Orchestrally, `AVOID` the 5th-partial node at 2/5 from the nut.
- R11 `MUST` name the string (*sul G*, or Roman numeral, I = highest) when a pitch exists on two strings.

**Artificial harmonics**
- R12 `PREFER` the only orchestral method: stop a note and touch a P4 (5 st) above, which sounds **+24**
  over the stopped note. Violin/viola fingers 1+4, cello thumb + 3 or 4.
- R13 `NEVER` artificial harmonics on the orchestral double bass (stretch too wide). `AVOID` very high
  ones: insecure and they do not carry (Adler).
- R14 `PREFER` notate the stopped note with a diamond a 4th above; a circle over the sounding pitch alone
  leaves the method to the player (Piston allows it, Adler warns against it).

## Period practice
- `[era: before the 19th c.]` orchestral pizz is rare. `[era: 20th c.]` Bartók snap, nail, pizz harmonics
  and sul pont. pizz are newer colours.
- `[era: Romantic chamber/solo]` whole melodies in harmonics (Borodin Quartet 1 trio cello; Saint-Saëns
  Violin Concerto 3 close).

## Apply in MIDI / REAPER
- **Pizz patch:** Albion "Strings - Short Pizzicato" (profile `maxRate` 6 notes/s). Velocity = dynamic,
  `len` short; the sample carries the decay. *l.v.*: longer note-off only where the patch rings (low).
- **Switch gap** on one track (inferred): ≥ 1 beat at moderate tempo for arco→pizz, ≥ 2 beats for
  pizz→arco. Prefer a separate pizz track.
- **Pizz chords:** stagger bottom-up 10–30 ms; align for *non arpegg.*; alternate the roll for quasi
  chitarra (inferred).
- **Warm pizz:** cellos/basses and low-middle violins; very high violin pizz only for a dry effect.
- **Harmonics:** write the **sounding** pitch on a harmonics patch, pp–mp, light accompaniment (muted or
  pp strings, as in the Borodin trio). Albion ONE has no captured harmonics patch: fake with a high
  flautando or soft long, CC1 ≤ 40, or flute doubling (inferred).
- **Natural harmonic pitches** (lowest string, partials 2/3/4/5): violin 67 74 79 83; viola 60 67 72 76;
  cello 48 55 60 64; bass 40 47 52 56.

## Checklist
- [ ] *pizz.*/*arco* changes have a rest; long pizz passages share the line and breathe.
- [ ] Pizz chords rolled bottom-up unless *non arpegg.*
- [ ] Every harmonic = open + 12/19/24/28(/31), or stopped + 24, with the stopped note in range.
- [ ] No double-bass artificial harmonics; harmonics never asked to carry a tutti.

## Examples
- Ringing pizz: Diamond Sym. 4/II, all strings *pizz. vib.* ff.
- Artificial harmonic: stopped Bb4 (70), touch Eb5 → sounds Bb6 (94).
