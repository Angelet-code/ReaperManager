---
id: orchestration.piano-celesta-keyboards-organ-harpsichord
title: Harpsichord, organ, harmonium and ondes Martenot in the orchestra
aliases: [clave, clavecín, clavicémbalo, cembalo, continuo, bajo continuo, bajo cifrado, órgano, pedalero, manuales, registros, pies, 16 pies, armonio, órgano de lengüetas, ondas Martenot, ondes Martenot, Cembalo, Orgel, Harmonium]
domain: orchestration
tags: [keyboards, instrument, ranges, continuo, organ, harpsichord, period-practice]
style_scope: universal (continuo = Baroque–c.1770; organ, harmonium, ondes = special colours, era-tagged)
use_when: Adding a harpsichord, organ, harmonium or ondes Martenot to an orchestral cue, writing a Baroque continuo track, or evoking a church scene, a storm rumble or an organ climax.
summary: Harpsichord F1–F6 (29–89) has no touch dynamics and little power: thin everything around it or play in its rests. Organ keys 36–96 (manuals) / 36–67 (pedal) at 8', shifted by 16'/32'/4'/2' stops; it sustains at constant level, so use it for pads under strings, sacred scenes, low pedal clusters or a final climax, never as a dependable section. Harmonium holds soft chords under recitative or replaces missing wind tone.
sources: ["unir-orq-tema8 p.9-16", "adler-orq-es p.468, 478-485", "piston-orch p.340, 350-352"]
related: ["[[piano-celesta-keyboards]]", "[[figured-bass-reading]]", "[[baroque-suite]]", "[[sacred-vocal-forms]]", "[[song-aria-recitative]]", "[[double-bass]]", "[[_instruments]]"]
---

# Harpsichord, organ, harmonium and ondes Martenot

## Core idea
These keyboards are colours brought in for a reason: a period (continuo), a place (church), an effect
(storm, overwhelming climax) or a small ensemble. Ranges and the piano/celesta rules:
[[piano-celesta-keyboards]].

## Rules
**Harpsichord** (plucked by quills; stops and a coupler change colour and power in steps)
- R1 `MUST` keep it from being swamped: it sounds best alone or with instruments that can play very
  softly. Model (Powell): a few strings and winds playing short notes, mostly in its rests (Adler).
- R2 `AVOID` it against a large orchestra unless amplified or a modern high-power instrument (Adler,
  Piston). That loudness costs intimacy (Piston).
- R3 `ALLOWED` `[era: 20th-c. revival]` colour in a small orchestra (Falla *Retablo*, Martin *Petite
  symphonie concertante*, Strauss *Couperin Suite*, Poulenc).
**Organ** (stops: 8' as written, 16' −12, 32' −24, 4' +12, 2' +24)
- R4 `MUST` write "+16'"/"+32'" to extend down and "+4'"/"+2'" to extend up. `AVOID` counting on 32'
  (most organs lack it) or always on 2' (Adler).
- R5 `PREFER` what it does best: notes held at constant volume indefinitely and many timbre
  combinations. Model: Saint-Saëns 3, pp manual chords and pedal notes under a string melody, which
  gain sustain and warmth (Adler).
- R6 `ALLOWED` special purposes (Piston): choral-orchestral and sacred works, church scenes in opera,
  realistic effects (Verdi *Otello* storm: low pedal cluster C–C#–D held for pages), grandiose
  climaxes (Mahler 8, Strauss *Zarathustra*).
- R7 `AVOID` treating it as a dependable section: halls differ or lack it, colours vary, and it is too
  self-sufficient to blend (Piston). `MUST` plan for a weaker electronic or positive organ (Adler).
**Harmonium** (reed organ, bellows by two foot pedals, 1–2 manuals, up to 15 stops)
- R8 `PREFER` write it like organ manuals without pedal; use it for soft sustained chords under
  recitative, with a few strings punctuating (Strauss *Ariadne*) (Adler).
- R9 `ALLOWED` in a small orchestra it makes up missing wind volume, or stands in for an organ, though
  it never sounds like a large one (Piston).
**Ondes Martenot** (electronic, 1928; keyboard or ribbon, about the piano's range)
- R10 `ALLOWED` ribbon glides between any pitches; filters change the overtone colour. Piston calls its
  orchestral use experimental `[era: 1955]` (Messiaen *Turangalîla*, Honegger *Jeanne d'Arc*).

## Period practice
- `[era: Baroque–c.1770]` harpsichord (or organ; later fortepiano) realises the figured bass in every
  orchestral piece, early Haydn and Mozart symphonies and Mannheim included. Organ continuo in
  oratorios and cantatas. See [[figured-bass-reading]].
- `[era: 19th-c. performance habit]` piano continuo in Baroque revivals, later handed to woodwinds
  (Siloti's Vivaldi).
- `[era: Classical–mid-Romantic]` the organ leaves the symphony (homophonic texture) and returns with
  Saint-Saëns 3, Mahler and Strauss; it stays in opera for religious scenes (Gounod *Faust*, Puccini
  *Tosca*, Wagner *Lohengrin*).
- `[era: early 20th c.]` harmonium revival (Strauss, Bartók, Hindemith, Schreker, Webern Op. 10).

## Apply in MIDI / REAPER
- Harpsichord: velocity hardly matters. Change level in blocks per phrase (add or remove the octave
  doubling, thin the band), not with crescendos. Keep notes 29–89. Around it: strings p–mp, short
  notes, entries in its rests.
- Continuo: bass line on `HPSCD` left hand (doubled by cello + bassoon), right-hand three-part chords
  around 55–76, harmonic rhythm of the figured bass.
- Organ pad: manual chords held to the harmonic rhythm, pedal root an octave below. MIDI is written at
  sounding pitch: a 16' pedal key C2 sounds C1 = 24 (inferred). Dynamics via the swell CC (often
  CC11/CC7; check the patch), not velocity.
- Storm/dread: hold 24 25 26 on a 16' pedal patch for the whole scene, CC11 swells only.
- Climax organ: enter on the final arrival with full chords and pedal, then release; do not keep it
  running through the cue.
- Harmonium: p chords under a voice, long notes with fermatas, a few string stabs between.
- Ondes: monophonic synth lead, wide pitch-bend range for glides, soft vibrato-rich tone (inferred).
- Pan: harpsichord centre-front for continuo; organ centre, large reverb.

## Checklist
- [ ] Harpsichord 29–89 with a thin, soft texture around it; no tutti forte over it.
- [ ] Organ footage of the patch known; pedal written at sounding pitch.
- [ ] Organ has a purpose (sacred, effect, climax, pad) and leaves when it is done.
- [ ] Continuo only in Baroque/early-Classical pastiche.

## Examples
- Saint-Saëns-style pad: strings melody pp; organ manuals Db major chord 61 65 68 held 2 bars, pedal
  Db2 (37) at 8'.
- Continuo: harpsichord LH G2 (43) with cello, RH 59 62 67, crotchet chords.
