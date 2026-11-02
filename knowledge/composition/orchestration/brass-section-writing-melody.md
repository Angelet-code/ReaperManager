---
id: orchestration.brass-section-writing-melody
title: Melody in the brass (alone and doubled with strings and woodwinds)
aliases: [melodía en los metales, presentación de la melodía, tema en los metales, metales al unísono, unísono de metales, cuatro trompas al unísono, duplicación de los graves, trombones con cuerda grave, trompeta y oboe, trompa y violonchelo, tuba y contrabajo, coral de metales, himno en los metales, Blechbläserunisono]
domain: orchestration
tags: [brass, melody, unison, octaves, doubling, tutti, low-unison]
style_scope: universal (symphonic, Romantic to 20th c.; modern film default)
use_when: Giving a theme to the brass, alone in unison/octaves or doubled with strings and woodwinds (heroic low theme, hymn under busy figuration, horn + cello tune, trumpet punching through a tutti).
summary: A brass theme in unison and octaves is strong and penetrating; register sets the colour (trumpets and horns below their top + trombones high = dark and noble; transpose up a 3rd–4th for brilliance). Trombones + tuba + bassoons + low strings on one line is one of the strongest orchestral sounds. Keep loud high horn unisons to 2 horns (or 2 horns + 1 trumpet), and re-colour repeats by changing the doubling family.
sources: ["adler-orq-es p.375-392"]
related: ["[[brass-section-writing]]", "[[brass-section-writing-counterpoint]]", "[[heroic-theme-orchestration]]", "[[horn]]", "[[trumpet]]", "[[trombone]]", "[[tuba]]", "[[texture-unison-and-tutti]]", "[[bass-line-doubling]]", "[[doubling-colour-and-decay]]", "[[user-taste]]"]
---

# Melody in the brass

## Core idea
Brass presents melody in three ways (Adler): as a section soloist (unison/octaves), doubled with other
families, or as an independent contrapuntal voice ([[brass-section-writing-counterpoint]]). Plan the
melody's register first: it decides between dark nobility and brilliance.

## Rules
**Brass alone**
- R1 `PREFER` a theme in brass unison + octaves for a strong, penetrating sound: 4 horns and 2 trumpets in
  octaves, 3 trombones doubling the horns at the unison (Hindemith, *Nobilissima Visione*).
- R2 `PREFER` dark and noble: trumpets and horns below their top registers, only the trombones high.
  `ALLOWED` for brilliance, move the same passage up a 3rd or 4th so trumpets and horns reach their top.
- R3 `PREFER` save the tuba for a later statement (Hindemith brings it in at variation 2, two octaves below).
- R4 `AVOID` loud, high unisons for all 4 horns: small pitch differences beat and notes crack (Adler,
  after Schuller). `PREFER` horns 1 + 3 only, or 2 horns + 1 trumpet. In the middle register a full
  horn unison stays the heroic default ([[horn]] R4).

**Brass with other families**
- R5 `PREFER` horn + cello for long sustained melodies. `ALLOWED` staggered horn entries (1–2, then 3–4) on
  a cello line, to articulate it in segments (Strauss, *Don Quixote*).
- R6 `ALLOWED` trumpet + oboe in unison so a tutti melody stays audible: both are incisive (Weinberger,
  *Schwanda*). Piston's rule against open-trumpet unisons with woodwinds ([[trumpet]] R8) still holds
  when the woodwind colour itself must be heard.
- R7 `ALLOWED` tuba doubling a soft double-bass line: heavier and darker (Prokofiev 5, III).
- R8 `ALLOWED` one line in two articulations: detached brass + legato woodwinds give attack plus a
  connected body (Wagner, *Siegfried* III prelude: tuba + bass clarinet + bassoons).
- R9 `PREFER` **low power unison:** trombones (+ tuba) with bassoons, violas, cellos and basses on one
  line. Adler ranks it among the strongest orchestral combinations (Schubert, *Rosamunde*; Liszt,
  *Les Préludes*).
- R10 `PREFER` against such a low theme, keep three layers apart: low theme, mid sustained or rhythmic
  chords (upper winds, horns), high fast figuration (upper strings).
- R11 `ALLOWED` a slow low hymn (trombones, tuba, horns, bassoons, low strings) under dense fast upper
  counterpoint. Split the brass: horns join the hymn, trumpets and cornets join the figuration
  (Tchaikovsky, *1812*).
- R12 `PREFER` re-colour a repeated brass chorale by changing its doubling family: strings first, then
  woodwinds, with the brass as the constant core (Wagner, *Lohengrin* I prelude).

## Apply in MIDI / REAPER
- **Unison/octave theme:** `HN LEGATO` and `LOW BRASS LONG` on the same notes (e.g. melody in 55–67),
  `TPT LEGATO` an octave up (67–79). Brilliant version: transpose all +4 or +5 semitones.
- **High heroic horn line** (≥ 67, ff): an a2 horn patch, or a horn track + `TPT LEGATO` at the unison
  at CC1 about 10 lower, rather than an a4/a6 patch (inferred; samples do not crack, but a4 sounds forced).
- **Horn + cello:** copy the cello notes to `HN LEGATO`, same pitch, horn CC1 5–10 under the cello at p–mf.
- **Trumpet + oboe:** same MIDI notes on `TPT LEGATO` and the oboe track, only in tutti f–ff.
- **Low power unison:** copy the theme to `LOW BRASS LONG`/`SHORT`, bassoons, violas (+12 if below 48),
  cellos and basses (octave-adjust to each range, [[double-bass]]). Upper strings: 16th scales, staccato; woods + horns:
  chords on the beat.
- **Two articulations:** brass notes `len` = 85 % of the value with accented velocity; the woodwinds play
  the same notes with 30–50 ms overlaps ([[legato-overlap-and-attack-offsets]]).
- Balance per [[user-taste]] R15: a section melody in a tutti sits about 4 dB under the bed, so set the
  bed first.

## Checklist
- [ ] Does the register match the colour asked for (dark: brass below its top; bright: trumpets and horns high)?
- [ ] Are no loud high melodies on a 4-horn unison without a lighter alternative?
- [ ] In a low unison theme, is the upper texture in a different register and rhythm?
- [ ] Does a repeated chorale get a new doubling family?

## Examples
- Liszt, *Les Préludes*: dotted theme in trombones, tuba, bassoons, cellos and basses, with horns and
  winds on chords and violins on staccato scales.
- Lohengrin I prelude: trumpets + trombones + tuba chorale, doubled first by strings, then by woodwinds.
