---
id: orchestration.percussion-unpitched
title: Unpitched orchestral percussion
aliases: [percusión, percusión de altura indeterminada, tambor, caja, caja clara, tambor militar, tambor tenor, bombo, gran cassa, platillos, platos, plato suspendido, platillo suspendido, plato chino, charles, tam-tam, gong, triángulo, pandereta, pequeña percusión, con bordones, sin bordones, golpe de aro, apoyatura, floreo, escobillas, dejar vibrar, música turca, Schlagzeug, kleine Trommel, Rührtrommel, große Trommel, Becken, Triangel, Schellentrommel]
domain: orchestration
tags: [percussion, instrument, unpitched, crescendo, rolls]
style_scope: universal
use_when: Adding or checking snare, tenor drum, bass drum, cymbals, suspended cymbal, tam-tam, triangle or tambourine in an orchestral cue, or layering a percussion tutti.
summary: Unpitched percussion has no range; MIDI notes follow the library key map. Use the standard section (snare, bass drum, cymbals, triangle, tambourine, tam-tam) sparingly and mark every ring length. The bass drum is the most powerful instrument, so few notes and no busy rhythms; the suspended-cymbal roll swells a crescendo (don't overuse it); triangle and tam-tam are most effective soft. In a tutti, give each instrument its own rhythm.
sources: ["unir-orq-tema7 p.4-5, 8-12", "unir-orq-tema1 p.4-6", "adler-orq-es p.431-436, 452-456, 461-466", "piston-orch p.296-297, 303-313, 320-322"]
related: ["[[percussion-unpitched-latin-and-effects]]", "[[timpani]]", "[[mallet-percussion]]", "[[percussion-section-writing]]", "[[film-percussion-phrase-marking]]", "[[building-and-releasing-climaxes]]", "[[library-translation-table]]", "[[user-taste]]", "[[_instruments]]"]
---

# Unpitched orchestral percussion

## Core idea
Written on a one-line staff (or a 5-line staff, lines or spaces only) with the percussion clef.
Piston's working groups: **standard** (timpani, snare, bass drum, cymbals, triangle, tambourine, glock, wood
block, tam-tam), **auxiliary** (castanets, xylophone, tenor drum, bells, crotales, vibes), **effects** and
**Latin/"exotic"**. Wood, Latin drums and effects: [[percussion-unpitched-latin-and-effects]]. Player
count and instrument-change time: [[percussion-section-writing]].

| Instrument | Character | Writing |
|---|---|---|
| Snare drum (caja) | crisp, rattling, high | ostinati, flams, drags, rolls; snares off ≈ tom-tom; rim shot = pistol crack; brushes for soft or jazz |
| Tenor / field drum | deeper, no snares / darker snared | processional, march ruffs |
| Bass drum (bombo) | most powerful; speaks late | few notes; secco or ringing; pp roll = distant thunder |
| Clash cymbals | brilliant, long ring | clash l.v., choked, soft clash, swish |
| Suspended cymbal | whisper to fff | soft-mallet roll swell; stick, brush, triangle beater, bow; edge / bow / bell |
| Tam-tam | dark, quivering; violent when hard | one stroke, long bloom |
| Triangle | high, luminous, heard over any tutti | few strokes, soft is best |
| Tambourine | festive jingles | struck, shaken roll (loud), thumb roll (soft) |

## Rules
- R1 `PREFER` Default template = the standard section; add other instruments for colour or programme.
- R2 `MUST` Mark every duration: l.v. (tie to nothing) or a damped/secco length, for bass drum, cymbals,
  tam-tam and triangle.
- R3 `PREFER` Bass drum sparingly: its effect falls as its frequency rises. Under a chord it sounds like
  the fundamental; soft notes are felt more than heard. `AVOID` fast repeats and complex rhythms (it
  speaks with a lag). `ALLOWED` a single stroke to open or close a passage; a pp roll for thunder or
  dread.
- R4 `PREFER` Snare to sharpen the rhythmic outline of a tutti. `ALLOWED` soft, crisp ostinati (Prokofiev
  5, Ravel *Rapsodie*, *Boléro*). `AVOID` long sustained rolls: they go dull.
- R5 `ALLOWED` Snare roll as a crescendo driver (Piston). **Override for this user** ([[user-taste]] R3): in
  non-rock styles no snare rolls into sections; use a suspended-cymbal swell, a timpani roll or silence.
- R6 `ALLOWED` Suspended-cymbal roll with two soft mallets from pp to fff into a downbeat. `AVOID`
  overusing it (UNIR, Piston). Name the contact point and striker for special colours (Adler).
- R7 `ALLOWED` Clash cymbals: let ring, choked, soft clashes (very effective), swish. `AVOID` the two-plate
  roll (crude) and the hi-hat, except to imitate a jazz kit.
- R8 `MUST` Tam-tam very sparingly. `PREFER` soft strokes: dramatic, ominous (Piston). Never repeat it
  quickly.
- R9 `MUST` Triangle with extreme economy. `PREFER` soft dynamics: loud ones turn shrill (Adler). It adds
  luminosity to a big chord and blends with high strings and woods. `AVOID` long trills (an electric
  bell, Piston).
- R10 `ALLOWED` Tambourine in any style, not only Spanish. Specify the size; the player uses 25 cm if none
  is given (Adler).
- R11 `PREFER` In a percussion tutti give each instrument a different rhythm; together they make the
  overall pattern (Ravel *Daphnis*). `AVOID` all percussion in unison rhythm (Piston).
- R12 `PREFER` Match register to the harmony: unpitched sounds take on the chord's colour (Adler).

## Period practice
- `[era: Classical, c.1770–1825]` "Turkish" (Janissary) colour: bass drum, cymbals, triangle (+ snare) only
  in march or military passages (Mozart, Haydn "Military", Beethoven 9 alla marcia).
- `[era: mid–late 19th c.]` The same instruments become full timbral members of the orchestra.
- `[era: 20th c.]` Percussion as a self-sufficient ensemble (Varèse *Ionisation*); later, Asian, African
  and Latin instruments mixed with Western ones.

## Apply in MIDI / REAPER
- One track per instrument (`SNARE`, `BD`, `CYMBALS`, `SUS CYM`, `TAM-TAM`, `TRI`, `TAMB`), rear of the stage.
- Key maps: **Symphony Series Cymbal 1** keyswitches 36 hard / 38 soft mallets, 48/50 long hit, 52/53
  short choke, 55 roll (CC1), 57 recorded crescendo. **Darwin Percussion Ensemble** zones: Sub 24–36, Low
  40–52, Mid 57–67, High 71–81, sticks 84–95, Metal 96–107 ([[library-translation-table]]). GM fallback
  (inferred): BD 35/36, snare 38, side stick 37, crash 49/57, Chinese 52, ride 51/53, tambourine 54,
  triangle 80 mute / 81 open.
- Sus-cymbal swell: roll with CC1 15 → 120 over 1–4 bars, ending exactly on the downbeat crash.
- Flam: grace note 15–40 ms early, about 20 velocity lower; drag = two grace notes (inferred).
- Bass drum: nudge 5–20 ms early only if the sample attack is slow (inferred).
- Velocity = dynamics, ±5–10 on repeats; choke/secco only if the patch damps on note-off.
- Tutti groove: spread one bar of eighths over BD, cymbals, snare, triangle and tambourine, no two alike.

## Checklist
- [ ] Each instrument on its own track with the right key-map note.
- [ ] Every cymbal, tam-tam, triangle and bass-drum note has a deliberate ring or damp.
- [ ] At most ≈ 1 cymbal swell per minute; no snare rolls into sections unless rock or march.
- [ ] Bass drum: few notes, on structural accents with brass and timpani.
- [ ] Percussion tutti layered, not unison.

## Examples
- *Boléro*: snare ostinato p, unchanged, while the orchestra grows.
- Rise: sus cymbal roll CC1 20 → 120 over 2 bars → crash + BD + timpani on bar 3 beat 1.
