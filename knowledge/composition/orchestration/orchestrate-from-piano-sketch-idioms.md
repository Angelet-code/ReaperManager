---
id: orchestration.orchestrate-from-piano-sketch-idioms
title: Translating piano idioms into the orchestra (pedal, decay, figures, recolouring)
aliases: [idiomas pianísticos, pedal de resonancia, pedal derecho, una corda, acordes arpegiados, acordes repetidos, bajo Alberti, octavas del piano, secondo, primo, piano a cuatro manos, unidad motora, ostinato, calderón, imitar el pedal, recolorear, reorquestar la repetición]
domain: orchestration
tags: [transcription, piano-reduction, pedal, decay, ostinato, doubling, recolouring, endings]
style_scope: universal (devices from Adler's piano-to-orchestra models — Ravel, Bizet, Brahms, Dvořák, Mussorgsky/Ravel, Schumann, Mozart)
use_when: Converting a specific piano figure (sustain pedal, fermata, arpeggiated or repeated chords, octaves, ostinato, runs, tremolo, ornaments) into orchestral parts, or recolouring the repeats of a piano piece.
summary: Each piano device has an orchestral equivalent. Pedal resonance becomes written held notes (horns, low clarinet + Cb pizz.), a decaying fermata a measured hold, hand-span arpeggios block chords, repeated chords string repeated notes, octaves a clarinet choir or Vln I + Vc in octaves. Ostinati go to one mid-string section, runs relay low to high. Soft passages sit in controllable registers, and every repeat changes at least one layer's family.
sources: ["adler-orq-es p.668-675", "adler-orq-es p.676-699", "adler-orq-es p.699-708", "adler-orq-es p.713-715", "adler-orq-es p.160-162", "adler-orq-es p.291-293"]
related: ["[[orchestrate-from-piano-sketch]]", "[[orchestrate-from-piano-sketch-other-transcriptions]]", "[[piano-celesta-keyboards]]", "[[string-section-writing-accompaniment]]", "[[woodwind-section-writing-with-strings]]", "[[doubling-colour-and-decay]]", "[[building-and-releasing-climaxes]]", "[[string-techniques-colour-effects]]"]
---

# Translating piano idioms into the orchestra

## Core idea
The orchestra has no decay to fight and no hand-span limit, but it is many players. Ask why each figure
exists: keep what serves the music in an orchestral form; replace what only works around the piano's
limits (decay, ten fingers) with what the composer meant.
Four-hands originals: the *secondo* holds bass + accompaniment, the *primo* melody + chords.

## Rules: device → orchestral solution
| Piano device | Orchestral solution | Source |
|---|---|---|
| Damper-pedal resonance | Written held values; a held low Cl or Hn note with a Cb pizz. onset; horns hold the pedal under the string figure | Adler; Ravel; Bizet |
| Fermata on a decaying chord | A measured hold of about the decay time (Ravel: 4 half-note beats) | Adler R19 |
| Long fading chord (ppp, tied) | ppp sustained winds + brass + arco strings with a timp roll, plus one quiet moving line | Bizet |
| Chord re-struck in another octave to keep it sounding | One powerful sustained chord in winds + strings | Adler R23 |
| Chord arpeggiated only for hand span | Block chord (keep the roll only if it is thematic) | Adler R18 |
| Closing tremolo or final fermata | Don't imitate: hold the penultimate chord with timp + cymbal rolls, end on a short accented tutti | Ravel *Kiev* |
| Repeated chords | String repeated notes or chords (best fast), divisi violas, or wind repeated notes | Adler ch.5, ch.8 |
| Octaves | A clarinet choir in octaves, or Vln I + Vc an octave apart. `AVOID` two similar strings in unison on a melody: they cancel out | Schoenberg |
| Alberti or broken-chord LH | Violas, Vln II, clarinets or bassoons in 8ths | Schumann, Mozart |
| Continuous 16th ostinato | One mid-register string section (violas), with cellos joining in loud passages | Bizet |
| Run or arpeggio over the range | A relay Vc → Va → Vln II → Vln I, each starting before the last ends | Bizet |
| Harmonic pedal implied by the pedal | A sustained wind pedal: double reeds (Turkish), clarinets pp, horns | Adler ch.8 |
| *una corda* | Mutes (con sord.) for that passage | Adler R16 |
| Spread harmony | Fill with extra 3rds and chord tones, octave doublings on the repeat | Adler ch.8, R8 |
| LH secondary melody | Need not be literal; contrast can come from colour | Adler R9 |
| Ornament or grace note | Reinterpret it (mordent → double grace; grace → harmonic glissando) | Stravinsky, Ravel |
| Melody and accompaniment in the same note value | Separate them by colour: muted strings behind, a solo oboe in front | Ravel |

## Rules: dynamics and recolouring
- R1 `PREFER` Crescendo by staggered entries plus rhythmic activation (repeated-note triplets in horns,
  winds joining one by one, tutti at ff). Diminuendo by subtraction: string sections drop out one by one
  (Bizet).
- R2 `ALLOWED` Written-out ritardando and diminuendo: 16ths → triplet 8ths → 8ths over 2–4 bars (Mahler).
- R3 `PREFER` For a soft passage, place instruments where p is controllable: piccolo an octave lower,
  winds and brass in the middle register (Dvořák).
- R4 `MUST` Check every octave doubling against each range. The lower instrument finishes the line
  alone where the upper one runs out (Brahms: the bassoon completes a descent to Bb that the flute
  drops, since its octave would fall below the flute's C4 = 60; floor inferred).
- R5 `PREFER` Under a long held chord, add a quiet inner motion (Vc tritone, timp roll) and lower the
  marking one step (Bizet pp → ppp).
- R6 `PREFER` On each repeat change at least one layer's family: string relay → Cl + Bsn; flute melody
  doubled by pizz. violins; Bsn 8vb under a clarinet line; trumpets take the horn rhythm (Bizet).
- R7 `ALLOWED` Refresh a repeated phrase by opening the spacing (horns, middle strings) with the same
  instruments (Dvořák).
- R8 `ALLOWED` A climax of few chord tones but many octave doublings sounds full if every instrument is
  in an intense register (Ravel).
- R9 `PREFER` Hold back a colour so its later entry tells (Schoenberg gives the viola's entry to the horn).

## Apply in MIDI / REAPER
- CC64 regions: extend the held notes to the pedal-up time on sustaining tracks, then delete CC64 from
  every orchestral track.
- Strum offsets (notes of one chord within about 60 ms, inferred): quantize them to one onset unless the
  arpeggio is thematic.
- Fermata: replace it with a held length in beats (≈ 2–4 s of decay at the project tempo, inferred).
- Pedal halo: a low Cl (e.g. Eb3 = 51) or Hn note with CC1 fading, plus a Cb pizz. on the same onset.
- Relay runs: overlap each section's entry by about 1 beat. Ostinato on Va with CC1 following the hairpin.
- *una corda*: switch to a con sord. patch or articulation.
- Dance (Brahms): Vln I + II melody with Bsn 8vb, Vc/Cb pizz. dance rhythm, Va off-beats.

## Checklist
- Is there no CC64, strummed onset, imitated tremolo or unmeasured fermata left?
- Is every octave-doubled note inside both ranges?
- Are soft passages free of top-register piccolo, flute or brass?
- Does each repeat differ from the last statement in at least one layer's family?
