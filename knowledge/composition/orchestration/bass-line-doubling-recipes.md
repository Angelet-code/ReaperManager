---
id: orchestration.bass-line-doubling-recipes
title: Bass doubling recipes (solid, brass-forte, light, pedal, independent)
aliases: [recetas de bajo, bajo sólido, bajo en octavas, pedal de contrabajo, bajo independiente, contrabajos divididos, bajo con fagot]
domain: orchestration
tags: [doubling, bass, low-end, pedal, period-practice]
style_scope: universal; era-tagged Classical/Romantic recipes
use_when: Choosing which instruments double a bass line for a given colour or dynamic (majestic, brass forte, light, pedal, low punch), or writing a double-bass part that is not just the cellos down an octave.
summary: "Very solid bass = Trb 3 + tuba + Vc + Cb in octaves; in brass forte the bassoons and bass clarinet go to the bass with tuba, Trb 3 and Hn 4; a double-bass pedal pairs with Hn 4 and contrabassoon. For a light bass drop the basses or double them with bassoons. Basses may be split into two octaves, and since Mozart may be an independent contrapuntal part."
sources: ["adler-orq-es p.548-556, 570-584", "piston-orch p.346-347, 357-363, 374-381, 406, 416-419, 426-443"]
related: ["[[bass-line-doubling]]", "[[double-bass]]", "[[tuba]]", "[[bassoons]]", "[[texture-unison-and-tutti-layouts]]", "[[texture-accompanied-melody]]"]
---

# Bass doubling recipes

## Core idea
The bass is one element whatever its doubling; the choice of doublers sets its colour and weight.
These recipes come from Adler's and Piston's score analyses; the general rules and the modern film
low-end layer are in [[bass-line-doubling]].

## Rules
- R1 `PREFER` **Very solid, majestic bass:** Trb 3 + tuba + Vc + Cb in octaves (Wagner, *Meistersinger*,
  Adler).
- R2 `PREFER` **Brass forte:** put bassoons and bass clarinet on the bass line with tuba, Trb 3 and Hn 4;
  they are too low to reinforce the brass's upper partials (Piston). Tuba + bass clarinet or
  contrabassoon in unison blend well.
- R3 `PREFER` **Pedal:** a double-bass pedal with Hn 4 and contrabassoon at the octave (Piston, Brahms 2
  rescoring); in a dense texture brass and timpani hold tonic-dominant pedals (Adler).
- R4 `ALLOWED` **Bass in two octaves:** split the basses, half with the tuba, half an octave lower
  (Piston); or Vc an octave under the line and Cb two octaves under (sounding from C2).
- R5 `PREFER` **Bass as a melody's lower octave:** Cb written an octave below the given pitch (sounding
  33–52) is a good bass range, better with cellos an octave above. `AVOID` basses on a melody at its own
  written pitch, or Va + Cb octaves where the bass part lies too high (Piston).
- R6 `ALLOWED` **Weight at a cadence:** a fresh low entry (Trb 3, tuba, timpani on the root) marks an
  arrival (Adler, Barber); withhold trombones and timpani from one phrase so the next sounds heavier.
- R7 `ALLOWED` **Low punch:** two harps + piano in unison on low octaves, doubled by pizz basses and
  timpani over held bassoons, contrabassoon, bass trombone and tuba (Britten, Piston).
- R8 `ALLOWED` **Independent bass:** the double bass as its own contrapuntal part, not the cello line
  down an octave; in big polyphony pair it with Bsn 2 at the octave (Mozart *Jupiter*, Adler).
- R9 `ALLOWED` Drop the double basses from a unison tutti whose high notes would be weak and hard to
  tune for them (d'Indy, Adler).
- R10 `ALLOWED` Divide the cellos: some on the bass, some doubling the violas (Piston, Beethoven 7).
- R11 `ALLOWED` One instrument alone may hold the lowest note of a chord (Weber: 2nd bassoon on C2, 36)
  [?: as stated by Adler].
- R12 `PREFER` **Light, transparent:** cellos sustain or pulse lightly; basses pizz on some downbeats,
  one note, or tacet (Piston). A low pp horn pedal doubled (Hn 2 + 4) steadies the tone rather than adds
  volume (*La Mer*).

## Period practice
- `[era: Baroque/Classical]` one bass part shared by Vc and Cb (Cb sounding an octave lower), usually
  with bassoon (general knowledge); Mozart's independent bass was unusual then (Adler).
- `[era: Classical scores today]` notes below E1 (28) in old parts are played an octave higher on
  4-string basses (Piston, Mozart K. 543).
- `[era: Romantic]` Trb 3 + tuba under the strings for heavy tutti (Wagner); modern film adds the
  low-end layer (see [[bass-line-doubling]] R4).

## Apply in MIDI / REAPER
- Pick a recipe per section and write it in the section marker, e.g. `bass=TRB3+TUBA+VC+CB 8ves`.
- Brass forte: copy the bass to `BSN`, `BCL`, `TUBA`, `TBN 3`, `HN 4`; CC1 90–110; at p remove the brass
  and keep `BSN` + `VC` + `CB`.
- Pedal: `CB` + `HN 4` + `CBSN` on the same pitch class, CB lowest, re-attacked every 2–4 bars.
- Split basses: two `CB` tracks (or one patch + one octave-down copy) at roughly half the CC1 each
  (inferred).
- Light texture lint: if `CB` sits more than an octave and a 5th below the next-lowest active part, add
  `BSN` at its pitch or move it up an octave.

## Checklist
- Does the bass recipe match the dynamic (brass only at f, basses thinned at p)?
- Are all `CB` notes ≥ 28 unless an extension patch is set?
- Is there a gap of more than 19 semitones between the basses and the rest in a light passage?
