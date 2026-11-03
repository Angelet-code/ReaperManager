---
id: orchestration.harp
title: Harp (pedal harp)
aliases: [arpa, arpa de pedales, arpa de doble movimiento, arpa cromática, Harfe, harpe, dos arpas, acorde arpegiado, acorde plaqué, en bloque, non arpeggiato, línea ondulada, arpegio de arpa, digitación del arpa]
domain: orchestration
tags: [harp, instrument, ranges, registers, chords, arpeggio, melody, doubling, section-size]
style_scope: universal
use_when: Writing or checking any harp part (range, registers, chords and rolls, arpeggios, melodies, doublings, one or two harps); open the split notes for pedals and for glissandi, harmonics and effects.
summary: The double-action pedal harp sounds as written, 23–103 (practical 24–96), 47 strings in Cb major; seven pedals allow one spelling per note name at a time (check every passage with [[harp-pedals]]). Its everyday role is accompaniment in broken chords shared between the hands (≤ 4 notes and ≤ a 10th per hand, rolled upward by default) with the notes left ringing; melodies are short-breathed and best in the lower-middle register; two harps are normal in a Romantic or film orchestra.
sources: ["unir-orq-tema8 p.4-8", "adler-orq-es p.89-91", "adler-orq-es p.94-97", "piston-orch p.323", "piston-orch p.330-338"]
related: ["[[harp-pedals]]", "[[harp-techniques]]", "[[plucked-strings]]", "[[piano-celesta-keyboards]]", "[[mallet-percussion]]", "[[doubling-colour-and-decay]]", "[[string-section-writing]]", "[[_instruments]]"]
---

# Harp (pedal harp)

## Core idea
The **double-action pedal harp** is non-transposing, on a grand staff. 47 strings in **Cb major**; seven
pedals (left foot **D C B**, right foot **E F G A**) set every string of a letter to flat, natural or sharp,
so **[[harp-pedals]] decides which notes exist at each moment**. Plucked with fingertips and thumb, **never
the 5th finger**. Notes ring long: ringing is the idiom, damping an effect ([[harp-techniques]]).

| Zone | MIDI | Colour |
|---|---|---|
| Lowest (wound strings) | 23–35 | deep, long ring; muddy in close chords; a single note lacks body (Piston) |
| Low-middle | 36–59 | full, warm; bass notes, open arpeggios; best melodic zone starts here |
| Middle | 60–83 | richest, most resonant; chords, arpeggios, melody up to ~72 |
| High | 84–95 | bright, clear, shorter ring; no expressive melody (Piston) |
| Top | 96–103 | dry, short, little sustain |

Range: default **23–103** (Gb7 = 102, G7 = 103 with the G pedal natural), practical **24–96**.
Variants: Adler 23–104 (Cb1–G#7: the G pedal reaches the top string on recent harps); Piston 23–102
(Cb1–Gb7, 1955).

## Rules
- R1 `MUST` keep the lowest string(s) at one pitch for the whole piece: the pedal mechanism does not reach
  them and the harpist retunes them by hand beforehand (Adler: the two lowest, C and D strings, 23–26;
  Piston: only the lowest Cb).
- R2 `MUST` chords: ≤ 4 notes per hand (no 5th finger), ≤ 8 in all, each hand ≤ a 10th (16 st). Tenths are
  easy because the harp octave is narrow. 3–4 notes per hand sound very full.
- R3 `ALLOWED` one-hand reach (Piston): 2nd–4th fingers 1–2, 5th–6th 1–3, 7th–10th 1–4; scales finger
  alike in every key.
- R4 `MUST` assume every chord is rolled **upward** unless marked: wavy line = slower, deliberate roll (an
  arrow sets the direction), bracket or *non arpeggiato* = plucked together (plaqué). Slow soft final chords
  are rolled anyway; at fast tempo each chord gets a quick roll (Adler, Piston).
- R5 `PREFER` arpeggios and fast figuration **shared between the hands** in groups of ≤ 4 notes, LH lower
  and RH higher, leapfrogging upward (Ravel, *Tombeau*); piano figuration gets re-split so.
- R6 `PREFER` accompaniment as the everyday role: endless broken chords and decorative patterns for one or
  two harps. Classic pairing: pp harp arpeggios over ~3 octaves under a p flute solo (Debussy, *Faune*).
- R7 `PREFER` let notes ring; damp only where the old harmony would blur the new one (Piston).
- R8 `AVOID` long sustained melodies: the tone is strong but has no sostenuto. `PREFER` moderately active
  rhythm (8ths/16ths), re-attacked long values, the lower-middle register (≈ 48–72, inferred), and a
  sustaining doubling when the line must sing. A few soft notes in a muted texture weigh a lot (Berg).
- R9 `AVOID` expressive melody in the top octave and a half (≈ 85–103): the strings are too short.
- R10 `ALLOWED` low notes that must carry: enharmonic unison on two strings ([[harp-pedals]]) or a doubling.
- R11 `PREFER` doublings: + pizz strings (attack + ring; Brahms *Requiem* off-beat chords), + flute
  (melody, arpeggio bed, harmonics), + celesta or glockenspiel (sparkle, general knowledge), harp bass +
  cello/bass pizz.
- R12 `AVOID` relying on harp volume against brass or a full tutti, except glissandi and middle-register
  ff chords (general knowledge).
- R13 `PREFER` **two harps** for a Romantic or film sound: most orchestras have two, the second adds
  richness and volume and splits pedal settings in chromatic music (Piston). One harp for Classical-size or
  chamber scoring.

## Period practice
- `[era: before c.1810]` single-action and pedal-less chromatic harps: superseded, nothing to imitate.
- `[era: Romantic, Berlioz 1830]` two-harp waltz: one rolls chords, the other plays 16th broken chords and
  scales, then both run in octaves (*Symphonie fantastique*).
- `[era: late Romantic / early 20th c.]` large counts: Stravinsky *Firebird* 3, Schoenberg *Gurrelieder* 4,
  Wagner *Götterdämmerung* 6; Tchaikovsky *Nutcracker* pas de deux 2.

## Apply in MIDI / REAPER
- Tracks `HARP` (or `HARP NOTES` + `HARP GLISS`); two harps = `HARP 1`, `HARP 2`, each with its own pedal
  set. Run the [[harp-pedals]] check first.
- Hand split near 60 (LH ≤ 59), moved so each hand stays ≤ 4 notes and ≤ 16 st.
- Roll offsets bottom-up 10–30 ms per note by default, 40–80 ms for a wavy-line roll, reversed for a
  downward arrow, 0 for plaqué (inferred).
- Note lengths run to the next harmony change (or CC64 if the patch has it); never short by default.
- Velocity (inferred): pp 25–40, p 40–55, mf 60–75, f 85–100, ff chords 100–115; top note of each figure a
  little louder (user taste R2). Bed under a theme: 16th broken chords in 50–79, velocity 60–75
  ([[heroic-theme-orchestration]]).
- Pan left, behind the first violins.

## Checklist
- [ ] Notes 23–103, mostly 24–96; lowest strings never change pitch.
- [ ] Every passage passes the [[harp-pedals]] check.
- [ ] ≤ 4 notes and ≤ 16 st per hand, ≤ 8 at once.
- [ ] Chords rolled upward unless deliberately plaqué; notes ring unless damped on purpose.
- [ ] No long held melody without a sustaining doubling; no expressive melody above ~85.
- [ ] Harp not asked to cut through brass or tutti except glissandi or mid-register ff chords.

## Examples
- Eb major roll, pp: Eb3 G3 Bb3 Eb4 G4 (51 55 58 63 67), LH 51 55 58, RH 63 67.
