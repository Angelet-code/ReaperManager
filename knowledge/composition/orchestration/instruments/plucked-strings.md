---
id: orchestration.plucked-strings
title: Guitar, mandolin and banjo in the orchestra
aliases: [cuerdas punteadas, instrumentos de cuerda punteados, guitarra, guitarra clásica, guitarra española, chitarra, Gitarre, mandolina, mandolino, mandoline, banjo, banjo tenor, banjo de cinco cuerdas, cuerda del pulgar, bordón, púa, plectro, trémolo de mandolina, armónicos de guitarra]
domain: orchestration
tags: [plucked, guitar, mandolin, banjo, instrument, ranges, balance, colour]
style_scope: universal
use_when: Adding a classical guitar, mandolin or banjo to an orchestral or chamber texture (ranges, tunings, sustain, balance, idiom); for zither and cimbalom open [[plucked-strings-zither-cimbalom]], for band guitar parts [[arrange-modern-song]].
summary: Only the harp is a regular orchestral plucked string; guitar (40–83, written 8va), mandolin (55–93, violin tuning in pairs, sustain only by tremolo) and banjo (open strings ~48–67 plus a G4 drone, each string a 9th up) are quiet colour instruments. Use them solo or in very small combinations, thin and soften the orchestra around them, and write them as a player plays: open-string voicings and arpeggio patterns for guitar, tremolo for mandolin, rhythmic chords for banjo.
sources: ["adler-orq-es p.89", "adler-orq-es p.101-108", "adler-orq-es p.110"]
related: ["[[classical-guitar-solo]]", "[[guitar-ample-performance]]", "[[plucked-strings-zither-cimbalom]]", "[[harp]]", "[[arrange-modern-song]]", "[[transposing-instruments]]", "[[user-taste]]", "[[_instruments]]"]
---

# Guitar, mandolin and banjo in the orchestra

## Core idea
Of the plucked strings only the harp ([[harp]]) belongs to the symphony orchestra; the others appear as
colour, more and more in smaller ensembles. For each, know the strings and tuning, range, how it is played
and how it is notated (Adler). All three are **quiet**: the orchestra must make room, not the fader
(matches [[user-taste]] R15).

| Instrument | Open strings (sounding MIDI) | Range, sounding | Notation | Sustain |
|---|---|---|---|---|
| Classical guitar | 40 45 50 55 59 64 | 40–83 (practical 40–76) | treble clef, sounds 8vb (−12) | decaying ring |
| Mandolin | 55 62 69 76 (4 pairs) | 55–93 | treble, as written | none: tremolo |
| 5-string banjo | 48/50 55 59 62 + drone 67 | ≈ 48–76 | treble, 8vb (general knowledge) | short, bright |

## Rules: guitar
- R1 `MUST` assume the **classical (nylon) guitar** when a score asks for "guitar" without detail (Adler).
- R2 Range: default 40–83 (19-fret classical guitar, general knowledge); Adler's chart stops at about 76
  (written E6 [?]): use 40–76 for orchestral parts, 77–83 for solo moments.
- R3 `ALLOWED` single lines, chords, and melody with accompaniment are all idiomatic; natural harmonics
  are very effective.
- R4 `MUST` unamplified, it has little volume and its harmonics can vanish: use it solo, with voice, or
  with a few soft strings and winds. Surrounding parts play sparse, short chords (Stravinsky *Tango*: four
  clarinets, bass clarinet and brass keep to dry rhythmic chords while the guitar plays p).
- R5 `PREFER` voicings a hand can hold: one note per string (≤ 6), open strings where possible, span about
  4–5 frets (general knowledge). In band styles guitars play riffs and patterns, not block chords
  ([[user-taste]] R1).

## Rules: mandolin
- R6 `MUST` render held notes as **tremolo** (fast plectrum strokes on the pair, or across two
  neighbouring strings): there is no real sustain.
- R7 `PREFER` solo or light accompaniment: pizzicato or muted strings, soft winds. Serenade model:
  16th-note arpeggio and scale figures over all-pizz strings (Mozart, *Don Giovanni*, "Deh vieni").
- R8 `ALLOWED` double stops; offstage ppp tremolo for "distant music" (Crumb).

## Rules: banjo
- R9 Tuning (Adler's chart): C3 G3 B3 (or C4) D4 plus the short **thumb string** G4 (67), used as a drone;
  bluegrass open G is D3 G3 B3 D4 + G4 (50 55 59 62 67, general knowledge). Each fretted string reaches a
  M9 (14 st) above its open note. Tenor banjo sounds an octave below written.
- R10 `AVOID` the banjo as a regular orchestral member; it belongs to theatre orchestras, jazz-age scores
  and bluegrass imitation.
- R11 `MUST` check balance: in Gershwin's *Rhapsody in Blue* a p banjo chord rhythm is barely heard against
  two horns. Keep horns and saxes out of its register or quieter.

## Period practice
- `[era: early 19th-c. opera]` guitar for serenades: Rossini *Barbiere* (Act I cavatina), Weber *Oberon*.
- `[era: Classical, Grétry/Mozart]` mandolin as serenade obbligato.
- `[era: late 19th–20th c.]` revival as colour: Verdi *Otello*, Mahler Symphony 7, Schoenberg *Serenade*
  op. 24, Webern op. 10, Respighi *Feste romane*, Stravinsky *Agon*; Berg *Wozzeck* (guitar).
- `[era: 1920s–30s theatre and jazz bands]` one player doubled guitar, mandolin and banjo, so their tunings
  were kept close.

## Apply in MIDI / REAPER
- Guitar strings: `chan` 0–5 = string 1–6 (high E = 0); a fingering solver lives in
  `A:/CERBATANA/Ableton6-11-02 Fantasia San Juan/generator/libretboard.mjs` (project AGENTS.md).
- Ample Guitar L (classical) per the project profile `src/music/profiles/ample.json`: playable 40–84;
  string-force keyswitch 31–36 (6th → 1st string) before every note; latch keyswitches 24 sustain,
  25 harmonic, 26 palm mute; velocity pp 26, p 38, mp 46, mf 54–62, f > 70; play 45 ms early.
- Strummed or rolled chords: 8–20 ms between strings, low to high, downstrokes louder (inferred). Let each
  string ring until it is played again.
- Guitar natural harmonics: 12th fret = open + 12, 7th = + 19, 5th = + 24 (general knowledge), low
  velocity, harmonic keyswitch.
- Mandolin tremolo: repeated notes ~12–16 per second with alternating ±5 velocity (inferred), or a tremolo
  patch; clamp 55–93.
- Banjo: rhythmic 3–4-note chords on the beat pattern, thumb drone 67 on off-beats; clamp 48–76.
- Orchestra around them: p–mp, few parts, no brass in the same register.

## Checklist
- [ ] Guitar notes 40–83 (mostly ≤ 76), one note per string, chord span fits one hand.
- [ ] Mandolin 55–93; no held note without tremolo.
- [ ] Banjo comping chordal and rhythmic; nothing loud in its register.
- [ ] Orchestra thinned and soft wherever a plucked solo must be heard.

## Examples
- Guitar E minor open voicing: 40 47 52 55 59 64; arpeggio p-i-m-a on 40 55 59 64.
- Mandolin serenade in D: 16ths D5–F#5–A5–D6 (74 78 81 86) over pizz D3/A3 strings.
