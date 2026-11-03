---
id: orchestration.wind-band
title: Concert band and wind ensemble (line-up, score order, march texture, band tutti)
aliases: [banda, banda de música, banda sinfónica, banda de concierto, banda de calle, banda de desfile, banda militar, conjunto de viento, conjunto de vientos, wind ensemble, wind symphony, orquesta de viento, bandestación, bandstration, cañas, maderas altas, maderas graves, marcha, pasodoble, trío de marcha, oom-pah, contratiempos, Blasorchester, Harmoniemusik, harmonie, fanfare]
domain: orchestration
tags: [band, wind-ensemble, line-up, score-order, march, doubling, balance, template]
style_scope: band and wind-ensemble music (20th-c. American concert band and wind ensemble; marches)
use_when: Writing or arranging for concert band, street/marching band or wind ensemble, building a band template in REAPER, or writing a march.
summary: A band doubles each part with an unknown number of players (ten clarinets on a line), so parts must work at any size; a wind ensemble (Fennell, 1952) has one player per part, like an orchestra without strings. Cornets, saxophones and euphonium carry real melodies. The clarinet choir does the strings' job (general knowledge). March = melody in high reeds/trumpets, afterbeats in horns/alto saxes, bass on 1 and 3, cymbals + bass drum with the bass. Build tuttis by adding families one by one.
sources: ["adler-orq-es p.772-784", "adler-orq-es p.715-726"]
related: ["[[wind-band-transcription]]", "[[saxophones]]", "[[clarinets-auxiliary]]", "[[trumpet-family-auxiliary]]", "[[tuba-family-and-relatives]]", "[[score-and-parts-layout]]", "[[percussion-section-writing]]", "[[woodwind-section-writing]]", "[[brass-section-writing]]", "[[building-and-releasing-climaxes]]"]
---

# Concert band and wind ensemble

## Core idea
The **band** began outdoors, so several players double each part for power. Its signature is mass
(a whole clarinet section on one line), and a slight section out-of-tuneness is part of the sound.
The **wind ensemble** (Frederick Fennell, Eastman 1952) has one player per part and no duplicated parts,
"the orchestra without strings". Techniques, registers and foreground / middle ground / background
balance work as in the orchestra; what changes is the line-up and the doubling.

## Line-ups
| Ensemble | Instruments |
|---|---|
| Street band (2–20 players per line) | piccolo in C, flutes, Bb clarinets (2 parts), alto / tenor / baritone saxes, cornets (2), trumpets (2), horns in Eb or F, baritones/euphoniums, tubas or sousaphones |
| Standard concert band | piccolo, flutes (2), oboes (2, may include Eng hn), Eb clarinet, Bb clarinets (3), alto clarinet, bass clarinet, (bassoons), (soprano sax), alto / tenor / baritone saxes, cornets (2–3), trumpets (2–3), F horns (4), trombones, baritone/euphonium, tuba, timpani, percussion (about 4 players) |
| Expanded band | adds solo-cl line, alto saxes 1–2, trumpets = cornets 1–3, baritone in treble and bass clef, string bass; Perc 1 = mallets, Perc 2 = blocks, cymbals, triangle, snare, tenor drum, tam-tam, bass drum |
| American Wind Symphony | 4.4.4.4 / 4.4.4.1 + percussion, no saxes, euphoniums or cornets unless needed |

## Score and track order (concert band)
Flutes, piccolo, oboes, English horn, Eb clarinet, Bb clarinets 1–3, alto clarinet, bass clarinet,
contrabass clarinet, bassoons, saxophones (alto 1 or soprano, alto 2, tenor, baritone), cornets 1–3,
trumpets, horns 1–2 / 3–4, trombones 1–3, euphoniums, tuba(s), string bass, timpani, percussion. Unlike
the orchestra, flutes sit above the piccolo and bassoons below the clarinets. Piano, celesta and harp
sit next to the percussion; double basses (even cellos) go below the tuba.

## Rules
- R1 `MUST` Write parts that sound right whether one or many players read them. A band composer never
  knows the count; first flute and second clarinet are often heavily doubled.
- R2 `PREFER` For clarity inside a band, mark "solo" (one player) and "tutti" (section back in).
- R3 `PREFER` Give real melodic roles to cornets, saxophones and euphonium; the orchestra uses them
  rarely.
- R4 `PREFER` (general knowledge) Treat the clarinet choir (Eb, Bb 1–3, alto, bass) as the band's string section: melody
  mass, sustained harmony, running figures.
- R5 `PREFER` March layering: melody in high reeds and/or trumpets/cornets; afterbeat chords in horns or
  alto saxes; oom-pah bass on beats 1 and 3 (tuba, trombones, low reeds); cymbals + bass drum with the
  bass; snare with rolls and flams. Trio: soft chords in high reeds, a trombone or euphonium melody mf,
  an oboe or flute countermelody.
- R6 `PREFER` Build a band climax by adding families one at a time (oboes, then piccolo/flutes/Eb cl,
  then bassoons/bass cl, horns, euphonium + string bass + tuba, harp, timpani). End on a fermata chord
  with a cymbal/triangle roll and SD/BD.
- R7 `PREFER` Percussion is integrated as in the 20th-c. orchestra, with many pitched instruments
  (timpani, mallets, crotales, rototoms). Only the glockenspiel can march. In a street band the
  percussion leads.
- R8 `MUST` Prepare scores and parts exactly as for orchestra ([[score-and-parts-layout]]).
- R9 `PREFER` A condensed score names the instruments on each line, detailed enough to rebuild the full
  score. A march condensed score uses two lines (high group; low group) with detailed percussion.

## Period practice
- `[era: before c.1950]` Db piccolo in bands, now obsolete; horns in Eb (alto horns) common.
- `[era: post-1952 American]` The wind ensemble (one per part) and the band's solo/tutti hybrid.
- `[era: Sousa, Holst, Vaughan Williams, Grainger]` Classic band marches and suites: heavy doubling and
  one dominant colour per strain.

## Apply in MIDI / REAPER
- Band = ensemble patches (clarinet section, sax section, trumpet section) balanced as sections. Wind
  ensemble = solo patches balanced like an orchestra. Switch solo/tutti by changing patch or track,
  not by CC alone (inferred).
- No library has "ten clarinets": layer a clarinet-ensemble patch with a solo clarinet, or add a flute an
  octave up, for the band mass (inferred).
- MIDI stays concert pitch. Ranges: saxes ([[saxophones]]), cornet/flugelhorn ([[trumpet-family-auxiliary]]),
  euphonium/baritone ([[tuba-family-and-relatives]]), alto/contrabass clarinet ([[clarinets-auxiliary]]).
- March (2/4 or 6/8): tuba on beat 1 at velocity ~100, low reeds and trombones on 1 and 3; horns or alto
  saxes on the offbeats ~15 velocity lower; melody CC1/velocity highest; BD + cymbals with the bass
  (inferred levels).
- Folders: `WOODS`, `SAXES`, `BRASS`, `PERC`, with the band order above.

## Checklist
- Do all parts work at any player count (no divisi that needs a known number)?
- Are solo passages marked solo and set on a solo patch?
- Do saxes, cornets or euphonium carry melodic material somewhere?
- In a march, are the bass on 1 and 3 and the afterbeats in different families?
- Does the climax add families one by one?

## Examples
- *National Emblem* (Bagley): opening f < ff call in octaves; the trio has soft high-reed chords, an oboe
  countermelody mf and a trombone melody mf over a bass on beats 1 and 3.
- *America the Beautiful* (arr. Dragon): a timp roll sffp, then a sweeping run in all reeds + harp; Eng hn
  + alto clarinet melody; the climax adds families bar by bar to fff triplet chords.
