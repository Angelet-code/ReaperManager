---
id: orchestration.bassoons-contrabassoon
title: Contrabassoon (and sarrusophone)
aliases: [contrafagot, contrafagote, Kontrafagott, controfagotto, contrafagotto, contrebasson, double bassoon, sarrusofón, sarrusófono, sarrusophone, Sarrusophon]
domain: orchestration
tags: [woodwinds, instrument, ranges, registers, bass-line, double-reed, auxiliary]
style_scope: universal
use_when: Writing or checking a contrabassoon part, adding a woodwind sub-octave under bassoons, basses or brass, or meeting a sarrusophone part.
summary: Contrabassoon sounds an octave below written: full 21–60, practical Bb0–F3 (22–53). Best in its lowest 12th (22–41): organ-pipe buzz, a sub-octave under bassoons, basses or brass; weak and bassoon-like from 42 up. Slow response: no fast runs or fast repeated tonguing, and frequent rests. Sarrusophone parts go on the contrabassoon.
sources: ["unir-orq-tema5 p.24-28", "adler-orq-es p.225-228", "piston-orch p.201-205"]
related: ["[[bassoons]]", "[[double-bass]]", "[[tuba]]", "[[clarinets-auxiliary]]", "[[bass-line-doubling]]", "[[woodwind-section-writing]]", "[[_instruments]]"]
---

# Contrabassoon (and sarrusophone)

## Core idea
The lowest woodwind: bassoon technique and range one octave lower, **sounding an octave below written**
(like the double bass). About 18 ft of tube; rougher tone than the bassoon, with an audible buzz from the
slow vibrations in the low notes. Usually played by the last bassoonist.

| Zone (sounding) | MIDI | Colour |
|---|---|---|
| Extension | 21 | A0, Strauss only; rare instruments |
| Lowest 12th | 22–41 | most useful: solid, buzzing, organ-pipe foundation |
| Upper | 42–53 | weak from the first overblown note (F#2); a thinner bassoon |
| Top | 54–60 | poor next to the bassoon; Mahler ≈ 57, Ravel ≈ 59 [?] |

Vault range **21–60**, practical **22–53**. Variants: Adler's chart reads 22–58 (written Bb1–Bb4 [top ?])
and calls 22–41 the most effective register; Piston gives F3 (53) [?] as the wise upper limit.

## Rules
- R1 `PREFER` the sub-octave: double cellos, basses or bassoons an octave below. In octaves with the
  bassoons it gives the woodwinds a full foundation that can balance modern strings and brass, at soft or
  loud dynamics.
- R2 `PREFER` it as a deep bass under brass groups, including soft muted brass (Strauss *Elektra*: pp
  legato an octave below Wagner tubas and contrabass tuba).
- R3 `MUST` give frequent rests: low notes use much breath.
- R4 `AVOID` agile writing, fast runs and fast repeated tonguing: the large air column answers slowly and
  sounds clumsy. Its staccato is dry and heavy. A doubling by basses or bassoons masks the clumsiness.
- R5 `AVOID` the upper register (≥ 42) on its own; use the bassoon there. `ALLOWED` higher notes when it
  doubles the double basses.
- R6 `ALLOWED` solos for characterisation, comic or grotesque effects (Ravel *Mother Goose*, the Beast; the
  heavy waltz bass of *La Valse*), and occasionally for purely musical phrases. Normally it blends.
- R7 `MUST` notate it an octave above sounding in parts (MIDI stays at concert pitch).

## Period practice
- `[era: Classical–Romantic]` Beethoven (*Fidelio*, 9th "Alla marcia"), Brahms (*Haydn Variations*: the
  wind chorale with the contrabassoon under pizzicato cellos and basses).
- `[era: Wagner, Debussy]` some scores write it at sounding pitch (*Parsifal*, *Ibéria*).
- `[era: French, late 19th–early 20th c.]` some French composers used a contrabass **sarrusophone** in C
  (a brass double-reed instrument from military bands) instead. Since Piston's day these parts are played
  on the contrabassoon: write them on the `Cbsn` track.

## Apply in MIDI / REAPER
- Track `Cbsn`, concert pitch; sample patches play sounding pitch. Keep most notes in 22–46.
- Doubling: copy the cello/bass or bassoon bass line −12. If a note falls below 22, take that phrase up an
  octave (inferred).
- Values of a beat or longer; no 16th runs or fast repeated notes unless basses double them.
- Rests: at least 1–2 beats every few bars, and ≥ 1 bar every 4–6 bars of sustained low notes (inferred
  from the breath rule).
- Pan centre-right behind the bassoons.

## Checklist
- [ ] Notes 21–60, mostly 22–46; 21 only on request.
- [ ] Notes ≥ 42 only when doubling basses, otherwise given to the bassoon.
- [ ] No fast runs or fast repeated staccato.
- [ ] Regular rests in long low passages.

## Examples
- Chorale foundation: bassoons C3 and G2 (48, 43) held, contrabassoon G1 (31) an octave under Bsn 2, pp.
- Tutti bass: basses C2 (36), contrabassoon C1 (24), whole notes, f.
