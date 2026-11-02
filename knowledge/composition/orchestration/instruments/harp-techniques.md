---
id: orchestration.harp-techniques
title: Harp glissandi, harmonics and effects
aliases: [glissando de arpa, glissando de acordes, armónicos de arpa, sons étouffés, sonidos apagados, étouffez, apagar, abdämpfen, près de la table, cerca de la tabla, bisbigliando, susurrando, trino de arpa, trémolo de arpa, golpe en la caja, Harfenglissando, Flageolett]
domain: orchestration
tags: [harp, glissando, harmonics, extended-techniques, tremolo, articulation]
style_scope: universal
use_when: Writing a harp glissando (scale or chord), harp harmonics, damped or dry notes, near-soundboard colour, trills, bisbigliando or 20th-century harp effects.
summary: A glissando sounds every string, so it always plays the full 7-string pedal set; chord glissandi need enharmonic settings and a chord of ≥ 4 pitch classes that touches every string's window (dim7, dominant 9th, pentatonic, whole-tone, some half-dim7s; never a plain triad). Harmonics sound an octave up, are very soft (RH one at a time, LH 2–3), best from strings 45–77; étouffé gives a dry staccato, près de la table a metallic tone, bisbigliando a whispered tremolo.
sources: ["unir-orq-tema8 p.4-8", "adler-orq-es p.91", "adler-orq-es p.98-101", "piston-orch p.328-330", "piston-orch p.333-338"]
related: ["[[harp]]", "[[harp-pedals]]", "[[string-techniques-pizzicato-harmonics]]", "[[flute-piccolo]]", "[[_instruments]]"]
---

# Harp glissandi, harmonics and effects

## Core idea
The glissando is the harp's best-known sound: the hand sweeps near the middle of the strings (thumb going
down, 3rd finger going up), so **every string sounds** and the result is the whole pedal set. Harmonics,
damping and special plucking places give the rest of the colour palette.

## Rules: glissando
- R1 `MUST` account for all 7 strings. A scale gliss plays the pedal set's mode; a chord gliss retunes the
  other strings enharmonically onto chord tones (the repeated pitches are not heard as such).
- R2 `MUST` chord gliss test (derived from the string windows in [[harp-pedals]]): the chord must contain a
  pitch class in each window C{11,0,1} D{1,2,3} E{3,4,5} F{4,5,6} G{6,7,8} A{8,9,10} B{10,11,0}. So it needs
  ≥ 4 pitch classes. Always works when no 3 adjacent semitones are all missing: every dim7, dominant 9th,
  major 6/9 (pentatonic), whole-tone. Otherwise test it (half-dim7: Bbø7 works, Eø7 fails). Plain triads
  and most seventh chords fail → use a mode instead.
- R3 `MUST` notate the pedal setting plus start and end notes, or one written octave of the strings, a line
  and the arrival note; rhythm inside does not matter if start and end are clear (32nds + "gliss.").
  A second gliss lists only the strings that change.
- R4 `ALLOWED` one or two hands, the whole range, double notes and chord shapes (Debussy *La Mer*: Harp I
  up, Harp II down), contrary motion between two harps (Roussel), descending gliss then *étouffez*
  (Debussy *Printemps*), and colours: près de la table, flat hands, nails.
- R5 `AVOID` the routine up-beat gliss into a tutti and gliss for show (Adler, Piston; Piston calls it one
  of music's worst clichés `[era: c.1900–1950 habit]`). `PREFER` soft gliss colour, a gliss alone, chord
  glissandi.

## Rules: harmonics
- R6 `MUST` octave harmonic only (sounds 12 st above the string); notate the string with a small circle,
  or say in the score if you write sounding pitch. Other partials are a 20th-c. extra (Adler).
- R7 `MUST` RH one harmonic at a time; LH 2–3 at once, within a 5th (Piston) and of the same pedal kind
  (Adler, reason not given).
- R8 `PREFER` strings A2–F5 (45–77) → sounding 57–89 (Adler, default). Piston: strings up to A5 (81) and
  above the wound bass (~F2), sounding ≈ 53–93 (inferred).
- R9 `MUST` accompany very lightly or not at all: soft, distant, easily covered. `PREFER` doubling a soft
  flute or muted violas; mixing harmonics with plain notes (Salzedo); a plain note in unison with a
  harmonic from the string an octave below.

## Rules: damping, colour, tremolo
- R10 `ALLOWED` *étouffez* (damp all, cut) and *sons étouffés* (each note damped as the next is played): a
  dry staccato like pizz secco, best low-middle (Stravinsky *Perséphone*). `MUST` keep it slow enough to
  damp; mark short chords *secco*. Fingernail = more metallic (Adler).
- R11 `ALLOWED` *près de la table* (near the soundboard): hard, tense, metallic, guitar-like (Britten
  *Storm*: ppp repeated chords).
- R12 `ALLOWED` trills and tremolos are slow; `PREFER` alternating hands, best on two homophone strings
  ([[harp-pedals]] R8). One-hand two-finger trills cannot be fast.
- R13 `PREFER` bisbigliando: 2–4 notes per hand within reach, fingers in no fixed order, ppp–p, may swell
  (Strauss *Zarathustra*). The most common orchestral harp tremolo.
- R14 `ALLOWED` `[era: 20th c.]` soundboard knocks (Varèse *Amériques*), nails pulling strings, plectrum,
  pedal slide after plucking (pitch bend, buzz), paper woven through the strings (harpsichord-like),
  Salzedo's effects (thunder, falling hail, xylophone-like sounds). `MUST` notate clearly and check with a
  harpist.

## Apply in MIDI / REAPER
- Gliss: on `HARP GLISS`, step through the 7-string set one string per step from start to end note,
  ~20–40 notes/s (inferred: a ~40-string sweep takes 1–2 s), landing the target exactly on the beat;
  velocity rising toward the target (or falling with a diminuendo); notes long. Chord gliss: map each
  string to its enharmonic chord tone, so pitches repeat. Never a chromatic run.
- Harmonics: sounding pitch (string + 12), velocity 25–45 (inferred), harmonics patch if the library has
  one; RH part 1 note, LH ≤ 3 notes within 7 st. Thin everything else.
- *Sons étouffés*: lengths 0.1–0.25 beat plus a muted/staccato patch; *étouffez*: cut every note at once.
- Bisbigliando: irregular 32nds or sextuplets over 2–4 chord tones per hand, velocity 20–50, random order,
  ±10 ms jitter (inferred). Trill: alternate two pitches in 16ths, uneven timing.
- Près de la table without an articulation: brighter EQ on the harp, or a soft nylon-guitar doubling
  (inferred).

## Checklist
- [ ] Gliss pitch set = current pedal set; chord gliss passes the window test.
- [ ] Gliss start and end land on clear beats; not used as a default up-beat into tutti.
- [ ] Harmonics: sounding ≈ 57–89, RH 1 / LH ≤ 3 notes, light accompaniment.
- [ ] Damped notes slow enough; bisbigliando soft.

## Examples
- C major scale gliss: D C B | E F G A all natural.
- G9 gliss: D Cb B | E# F G A (sounds G B D F A).
- C dim7 gliss: D# C B# | Eb F# Gb A (sounds C Eb F# A).
- Whole-tone gliss: D C B# | E F# G# A# (sounds C D E F# G# A#).
- Ravel *Daphnis* model: Harp 1 melody in harmonics, Harp 2 pp bass ostinato.
