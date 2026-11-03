---
id: orchestration.string-techniques-stops-and-divisi
title: String double stops, chords, divisi, vibrato, glissando and scordatura
aliases: [dobles cuerdas, doble cuerda, triples cuerdas, cuádruples cuerdas, cuerdas múltiples, acordes de cuerda, divisi, div., divisés, geteilt, unísono, unis., non div., por atriles, da leggii, par pupitres, pultweise, la mitad, la metà, die Hälfte, tutti, vibrato, senza vibrato, sin vibrato, glissando, gliss., portamento, port., scordatura, accordatura, cuerda al aire, Doppelgriff, Doppelgriffe, Flageolett]
domain: orchestration
tags: [strings, double-stops, divisi, vibrato, glissando, scordatura]
style_scope: universal
use_when: A string track must play two or more notes at once (double stops, chords or divisi), or you need vibrato, glissando/portamento or a retuned string.
summary: A double stop needs two adjacent strings; 3–4-note chords are rolled, sustain only the top two, sound best with open strings and want mf or louder. In sections, simultaneous notes mean divisi (outer player takes the upper note) unless marked non div. Vibrato is the default on stopped notes; gliss. is a full, audible slide on one string, port. a discreet one; scordatura stays within a semitone except as a colour effect.
sources: ["unir-orq-tema4 p.5-14, 15-21", "adler-orq-es p.9-16, 40-41", "piston-orch p.4-7, 35-36"]
related: ["[[string-techniques]]", "[[string-techniques-pizzicato-harmonics]]", "[[string-techniques-colour-effects]]", "[[violin]]", "[[viola]]", "[[cello]]", "[[double-bass]]", "[[string-section-writing]]", "[[orchestra-sizes-and-section-balance]]"]
---

# String double stops, chords, divisi, vibrato, glissando and scordatura

## Core idea
Open strings (concert): violin 55 62 69 76, viola 48 55 62 69, cello 36 43 50 57, bass 28 33 38 43.
Each simultaneous note needs its own string, and the bow holds at most two strings at once. In a section
the usual answer to chords is **divisi**: split the players instead of asking each for a chord.

## Rules
**Multiple stops**
- R1 `MUST` every note of a stop lies on a different, **adjacent** string; two notes that would need the
  same string are impossible.
- R2 `MUST` sustain at most two notes. Triple stops sound together only at mf or louder (bow pressure),
  rolled at p; quadruple stops are always rolled (lower pair, then upper pair).
- R3 `PREFER` stops with one or two open strings: more resonance, easier (keys D, G, A, E, C).
- R4 `MUST` double bass: only stops that include an open string. Cello: no seconds. Viola stops are rare
  in sections; violin is the most flexible.
- R5 `PREFER` **non div.** (every player takes the stop) only for a heavier, biting attack: Sacre, repeated
  down-bow chords.

**Divisi**
- R6 `MUST` write *div.* to split and *unis.* to rejoin; without it, players read two notes as a double stop.
- R7 `MUST` inside a desk, the outer player takes the upper note. *div. a 3/a 4*: mark which notes group.
- R8 `PREFER` complex or 3+-part splits by desks (*da leggii / par pupitres / pultweise*), on separate staves.
- R9 `ALLOWED` *half* (*la metà*): only the outer players play, until *tutti*. The line gets thinner and
  clearer without changing register.
- R10 `PREFER` divisi over stops in sections, but count the players. A 16-player Vln I a 2 gives two lines
  of 8; a 6 leaves about 3 per line (Debussy "Nuages", a soft chord pad). Cellos tolerate small numbers best,
  violins worst ([[orchestra-sizes-and-section-balance]]).

**Vibrato**
- R11 `MUST` vibrato is the default on stopped notes except short ones; no marking needed.
- R12 `ALLOWED` *senza vibrato* for a white, cold colour (must be marked).
- R13 `MUST` open strings cannot vibrate. `AVOID` an exposed, held open string in an expressive line; play
  it stopped on the next lower string.

**Glissando and portamento**
- R14 `MUST` *gliss.* = a deliberate, audible slide; *port.* = a discreet expressive slide between melody
  notes, rarely written.
- R15 `PREFER` one bow and one string per glissando; across strings the slide breaks at each string.
- R16 `ALLOWED` fingered (written) glissando: every chromatic note played. A whole section playing it sounds
  like an indefinite slide.

**Scordatura**
- R17 `MUST` print the tuning of all four strings and leave time to retune back (*accordatura*).
- R18 `AVOID` retuning by more than a semitone (tone suffers) or just to extend the low range (Piston).
  Rare cases: Strauss *Don Quixote* solo viola C→B2 (47); *Sacre* final chord, cello A→G#.
- R19 `ALLOWED` scordatura for colour: Saint-Saëns *Danse macabre* solo violin E→Eb (A4+Eb5 tritone);
  Mahler 4/II solo violin a whole tone up, a "cheap fiddle".

## Period practice
- `[era: late Romantic, Viennese]` expressive portamento on wide melodic leaps (Mahler, Ravel *La Valse*
  sur Sol). Modern default: little or none unless the style asks for it.
- `[era: 18th c.]` scordatura eased hard keys (Mozart K.364 solo viola tuned up, a semitone (inferred)); today it is
  mostly colour.

## Apply in MIDI / REAPER
- **Chord check for one string track:** ≤ 4 notes, each on a distinct adjacent string, lowest ≥ the lowest
  open string, at most two held. Otherwise split into divisi tracks (`Vln I div a`, `div b`).
- **Stops:** roll 3–4-note chords low→high by about 20–40 ms; sustain only the top two notes; velocity or
  CC1 at mf or above (inferred).
- **Divisi:** one monophonic track per line on the same patch. Lower each line's CC1/CC11 a little against
  a unison line, or use a smaller-section patch (inferred). Albion "Strings - Long" is an ensemble patch:
  real divisi needs separate tracks.
- **Vibrato:** Albion CC21 high on long expressive notes, at minimum for *senza vibrato*. SWAM: CC1 is
  vibrato depth, delayed on long notes ([[modeled-instruments-swam]]).
- **Gliss./port.:** on legato patches the slide comes from the transition; on SWAM, from velocity on an
  overlapping note ([[user-taste]] R17). Pitch bend works for one-string slides; keep ±2 st bend unless the
  patch range is set wider (inferred).
- **Scordatura:** only matters for range and open-string chords. Otherwise keep normal lowest notes.

## Checklist
- [ ] No held chord of more than two notes on one string track.
- [ ] Bass stops include 28, 33, 38 or 43; cello stops are not seconds.
- [ ] Each divisi line has its own track and a sensible player count.
- [ ] No exposed, long open string in an expressive line.
- [ ] Gliss. stays on one string or is written as a fingered run.

## Examples
- Violin chords with open strings (sounding): G3–D4–B4–G5, A3–E4–C#5–A5, D4–A4–F#5.
- Debussy "Nuages" pad: Vln I div. a 6 pp, Vln II a 3, Va a 2, Vc pp, Cb pizz pp.
