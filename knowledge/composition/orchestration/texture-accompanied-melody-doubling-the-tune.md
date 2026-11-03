---
id: orchestration.texture-accompanied-melody-doubling-the-tune
title: Choosing and doubling the melody instrument
aliases: [orquestación de la melodía, elegir el solista, doblaje al unísono, doblaje a la octava, duplicación al unísono, duplicación a la octava, colores puros, empalme de timbres, timbres mixtos, peso sonoro, sul D, sul G]
domain: orchestration
tags: [melody, doubling, unison, octaves, balance, strings, woodwinds, brass]
style_scope: universal (Piston 1955, Adler 2002; tonal orchestral and film)
use_when: Choosing which instrument plays a melody, deciding whether and how to double it (unison, octave, partial), or handing a wide line between instruments.
summary: "Pick the instrument whose comfortable register holds the tune and whose character fits; leave expressive solos undoubled (pure colour). To raise a melody, octave doubling adds brightness with little colour change, unison doubling changes the colour and adds weight (keep it for tutti and special effects), and partial doubling marks key notes. Keep weight in the upper octave, balance octaves by register, and hand wide lines over with a one-note overlap."
sources: ["adler-orq-es p.570-571, 595-601", "piston-orch p.413-430, 369-370, 431-435"]
related: ["[[texture-accompanied-melody]]", "[[texture-unison-and-tutti-layouts]]", "[[doubling-colour-and-decay]]", "[[line-separation-and-fusion]]", "[[woodwind-basics]]", "[[brass-basics]]", "[[string-section-writing]]", "[[library-translation-table]]"]
---

# Choosing and doubling the melody instrument

## Core idea
First the soloist, then the doubling. Piston prefers **pure colours** (little unison doubling) as
clearer and more transparent; doublings are for weight, brightness, a new mixed colour or an accent.
Find several solutions and compare them; the first obvious one is not always best (Piston).

## Rules
- R1 `MUST` Choose an instrument whose comfortable register contains the whole tune and whose character
  fits; the same tune an octave higher or lower may need another instrument (Adler). `AVOID` candidates
  for which the line sits in their top 4–5 semitones (inferred from Adler's bassoon/trombone verdicts).
- R2 `AVOID` Unison doubling of the most expressive solo lines: two players cancel each other's nuances
  (Piston). One instrument alone is as loud, only purer (Adler).
- R3 `PREFER` To raise a melody's level or importance, in this order of colour change:
  - **octave doubling** (organ-stop logic, 8va/15ma or 8vb): brighter and louder, colour mostly kept;
  - **partial doubling**: only the key notes, the head of each entry, or an elaboration of the tune;
  - **unison doubling**: a new mixed colour and more weight; keep it for tutti and specific effects.
- R4 `PREFER` Unison partners that blend (Adler, Piston):
  - EH + oboe, bassoon, muted trumpet, viola, cello; oboe + flute, horn, violin, viola;
  - flute + violin or clarinet; clarinet + flute, violin, viola, cello, horn;
  - bassoon + any string, soft trombone or tuba; horn + clarinet or bassoon; tuba + bass clarinet or
    contrabassoon;
  - string + wind: violin + flute, viola + EH, cello + bass clarinet, bass + contrabassoon.
  `AVOID` woodwind + trombone unisons; clarinet/oboe on a trumpet tune dulls its brilliance.
- R5 `ALLOWED` Two players of the same kind give less than twice the weight; three or four in unison
  sound warm and smeared, not louder (Mahler 4, flutes a4).
- R6 `PREFER` Put most of a doubled melody's weight in the **upper** octave; first players and the top
  voice lead (Piston).
- R7 `PREFER` **Strings** (Piston): Vln I + II unison (± violas) for power over a full background; Va +
  Vc an octave lower is the warm ideal pair; two octaves apart (Vln I + Vc) sounds aloof; Vln I div. in
  octaves + a solo cello is intimate. `AVOID` cellos in unison with violins/violas around C4–E5 (their
  A-string intensity sticks out). Mark a viola line that reaches its A string *sul D*. Keep the natural
  order (Vln I > Vln II > Va > Vc) unless you want an odd effect.
- R8 `PREFER` **Woodwinds** (Piston): octaves balance by register, not by instrument: two flutes at 60/72
  are uneven (weak low), at 71/83 even; two oboes at 60/72 uneven (strong low) — put EH on the lower
  note. Good octave pairs: ob/bsn, cl/bass cl, fl/cl. A rhythmic staccato tune: ob + cl at pitch, cl +
  bsn below, fl + picc above. `AVOID` contrabassoon on a fast staccato tune.
- R9 `PREFER` **Brass** (Piston): 2–3 trumpets in unison beat trumpet octaves; trombones or horns +
  trombones in unison an octave below. `AVOID` octaves of different brass on a rhythmic tune (attacks and
  weight differ); cover each octave with a mixed unison instead (Tpt I–II; Tpt III + Trb I 8vb).
- R10 `MUST` One wind on a string line strengthens it at p; at f the wind doubling needs two players or it
  won't balance (Piston). Two winds on a string line start to tint it audibly.
- R11 `MUST` Hand a line wider than one instrument from colour to colour, where the registers don't
  contrast sharply, overlapping by at least one note (Piston). Add doublers discreetly as a wide line
  climbs or falls (Adler on Schoenberg).
- R12 `PREFER` In a gradual crescendo let doublings accumulate (Piston).

## Apply in MIDI / REAPER
- Candidate check: line span vs each instrument's comfortable range in `data/instruments.json`.
- Doubling copies: same notes ±12/24 on separate tracks, humanized separately (±5–10 ms).
- Doubler level (inferred): an octave doubler sits 10–15 CC1 under the main line; a piccolo two octaves up
  a full level softer (Milhaud: EH pp, piccolo ppp).
- Weak member of an octave pair: raise its CC1 or add a unison partner; don't lower the strong one.
- Relay: track B's first note = track A's last note, overlapping 0.5–1 beat; this also hides attack
  differences between sample patches.
- Library (inferred): Albion ONE woods/brass are ensemble patches, i.e. already unison-doubled; for a pure
  expressive solo use a SWAM soloist (see [[modeled-instruments-swam]]).

## Checklist
- Does the tune sit in the chosen instrument's comfortable register throughout?
- Is an expressive solo left undoubled?
- Is the weight on the upper octave, and is each octave pair balanced for its register?
- At f, are wind doublings of strings at least a2?
- Do wide lines change instrument with a one-note overlap?

## Examples
- Berlioz, *Roman Carnival*, EH solo from C4 (60): best on EH, alto flute or saxophone; poor on solo
  bassoon (forced), trombone (tense top) or double bass (clumsy) (Adler).
- Piston Fig. 137: a chromatic run bass cl → bsn → cl II → cl I → ob → fl, each overlapping the last.
