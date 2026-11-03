---
id: orchestration.percussion-section-writing-climax-and-openings
title: Percussion for climaxes, openings and march or folk colour
aliases: [crear un clímax, clímax de percusión, reservar la percusión, preservación hasta el clímax, principio dramático, destapa oídos, golpe de platos, instrumentos turcos, música jenízara, alla turca, a la turca, color español, percusión mediterránea, ostinato de timbal, redoble de timbal]
domain: orchestration
tags: [percussion, climax, opening, ostinato, timpani, colour, period-practice]
style_scope: universal (Adler's repertoire models; Turkish and Spanish kits era-tagged)
use_when: Using percussion to build, sustain or crown a climax, to open a piece or movement, to end with drums alone, or to evoke a march, alla turca or Spanish/Mediterranean colour.
summary: Build a climax by stages, each adding a percussion colour (timpani pp pedal ostinato → single strokes → main motif → snare → cymbals at the peak), or reserve the timpani and bring them in late (sparse hits → roll → doubling the brass rhythm on tonic/dominant → roll into the last chord). Openings can be a soft timpani motif, a cymbal crash after a quiet movement or a timpani roll into an ostinato. Turkish colour = bass drum, cymbals, triangle, no timpani.
sources: ["adler-orq-es p.497-535", "piston-orch p.346"]
related: ["[[percussion-section-writing]]", "[[building-and-releasing-climaxes]]", "[[film-percussion-phrase-marking]]", "[[timpani]]", "[[percussion-unpitched]]", "[[dynamics-by-orchestration]]", "[[user-taste]]"]
---

# Percussion for climaxes, openings and march or folk colour

## Core idea
Three ways to use percussion at a climax (Adler): **build** it with a growing ostinato, **sustain** it,
or **reserve** the percussion until the climax itself. Each new percussion colour marks a step of
intensity without needing a louder marking. General rules: [[percussion-section-writing]].

## Rules
**Building and sustaining**
- R1 `PREFER` start a percussion ostinato ppp well before the peak and change it in stages: steady
  eighths → single strokes per beat → the piece's main rhythmic figure (Debussy, "Fêtes").
- R2 `PREFER` support the soft opening ostinato with harp and string pizz on the same pulse: a pitched
  rhythmic carpet (timpani on the dominant pedal).
- R3 `PREFER` add percussion in layers: timpani alone → snare entering about 2 bars before the peak
  with the main figure, *mf molto cresc.* → cymbals at the peak, then ff crashes every 2 bars.
- R4 `PREFER` let the percussion and string pulse carry a continuous crescendo while woodwinds and
  horns enter only with fragments.
- R5 `ALLOWED` end a built climax abruptly: change of metre and pp return of earlier material.
- R6 `ALLOWED` Copland's staging: dry woods first, xylophone later, solo timpani strokes with bass pizz
  at the peak.
**Reserving**
- R7 `PREFER` in a long Romantic climax hold the timpani back (Brahms 2 finale): a few isolated
  strokes → a roll under sustained chords → doubling the trumpets'/horns' repeated-note rhythm on
  tonic and dominant → roll into the final chord. Save trombones and tuba for the last surge
  (inferred from the example).
**Percussion alone**
- R8 `ALLOWED` `[era: 20th-c. wind ensemble]` the orchestra stops and the drums continue, combining
  motives they played separately earlier; keep tempo and accents fixed and fade to silence (Benson).
**Openings ("ear-openers")**
- R9 `ALLOWED` a percussion sound alone can open a piece; it need not be loud. A p solo timpani motif
  (four repeated tonic quarters) can become thematic and pass to the strings (Beethoven Violin
  Concerto).
- R10 `PREFER` a tutti hit with cymbals + bass drum + timpani to change mood abruptly after a slow
  movement (Tchaikovsky 4 finale). Mark which strokes ring and which are choked.
- R11 `ALLOWED` a timpani roll p<ff under a held tutti, then a tonic–dominant eighth ostinato that
  continues alone and under the brass theme (Shostakovich 5 finale).
**March and folk colour**
- R12 `PREFER` `[era: Classical/early Romantic "alla turca", c.1780–1830]` Turkish group = bass drum,
  cymbals, triangle; timpani are not part of it. Build like an approaching band (Beethoven 9): BD pp
  doubling the low winds on the offbeat, then when the tune arrives BD + cymbals on beat 1 and
  triangle on every main beat, slow crescendo.
- R13 `ALLOWED` `[era: 19th-c. exoticism]` Spanish or any Mediterranean colour: tambourine, castanets,
  triangle, snare, cymbals (Rimsky-Korsakov *Capriccio espagnol*, Chabrier, Ibert). Give each
  instrument its own slot of the bar; add tambourine roll and BD only at the ff tutti; converge all on
  the final downbeat. Adler calls the kit a cliché, though a successful one.

## Period practice
- `[era: c.1817 performance tradition]` antiphonal snares (Rossini *La gazza ladra*): roll f on one
  side, p echo on the other, both crescendo into the march; triangle, BD and timpani double the
  brass's dotted rhythm.
- `[era: 19th-c. two-drum timpani]` timpani on tonic and dominant only, doubling trumpet rhythms
  (Brahms). Modern pedal timpani: [[timpani]].

## Apply in MIDI / REAPER
- Build over 8–20 bars: `TIMP` dominant pedal 8ths vel 25–35 with harp + pizz → quarters vel 50–70 →
  main motif vel 80–100 → `SNARE` figure from 2 bars before the peak, vel 60→110 → `CYM` crash on the
  peak downbeat, then every 2 bars. Stagger entries; never start all at once.
- Reserve: `TIMP` silent through the build; first entry at the climax; roll = roll keyswitch + CC1
  ramp (Symphony Series key 38, [[library-translation-table]]).
- Drums-alone coda: each drum loops its earlier motive, overlapped, strict tempo, fade by velocity,
  no ritardando.
- Soft opening: `TIMP` four tonic quarters vel 40–50, woodwind answer, motif later in strings.
- Mood-change hit: `CYM` long-ring note + `BD` + `TIMP` on beat 1; a choke key where the next beats
  must be silent.
- Alla turca: `BD` beat 1, `CYM` with it, `TRI` each main beat, vel 30–45 rising over 16–32 bars;
  no `TIMP` in the group.
- User taste R3 overrides: no snare rolls leading into sections except in march/rock contexts or on
  request; prefer cymbal swells, timpani rolls or silence (see [[film-percussion-phrase-marking]]).

## Checklist
- [ ] Each stage of the build adds one new percussion colour.
- [ ] Peak percussion (crashes, ff rolls) not used before the peak.
- [ ] Turkish kit without timpani; Spanish kit interlocking, not all on the downbeat.
- [ ] Cymbal strokes marked ring or choke.

## Examples
- 12-bar build in D: `TIMP` A2 (45) 8ths pp bars 1–4, quarters 5–8, main motif 9–12; `SNARE` from
  bar 11; `CYM` crash bar 13 beat 1.
