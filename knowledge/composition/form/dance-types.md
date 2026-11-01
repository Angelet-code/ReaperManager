---
id: form.dance-types
title: Dance types — meter, tempo, upbeat and MIDI rhythm patterns
aliases: [danzas, alemanda, corriente, zarabanda, giga, gavota, bourrée, rigodón, loure, pavana, gallarda, minué, pasapié, siciliana, musette, hornpipe, marcha, polonesa, mazurca, vals, tarantela, pastoral, berceuse, barcarola, Tanz]
domain: form
tags: [dance, rhythm, meter, upbeat, suite, baroque-dance, romantic-dance]
style_scope: baroque-romantic
use_when: When a request names a dance (gavota, zarabanda, vals, mazurca…) and you need its meter, tempo, pickup, cadence placement and a characteristic rhythm to write in MIDI.
summary: Lookup table of baroque and 19th-century dances with meter, tempo, upbeat and a MIDI-ready characteristic rhythm (onsets/lengths in quarter-note beats from the bar start); dances are square (4+4, 8+8) and wrapped in binary suite form (baroque) or ternary/rondo form with optional intro and coda (19th c.).
sources: ["zamacois-formas p.155-165 (§123-138)", "zamacois-formas p.224-229 (§198-203)", "zamacois-formas p.229-235 (§208, §216-217)"]
related: ["[[baroque-suite]]", "[[binary-form]]", "[[minuet-scherzo-trio]]", "[[phrase-asymmetry]]", "[[phrase-structure]]", "[[character-pieces]]"]
---

# Dance types — meter, tempo, upbeat and rhythm

## Core idea
Once dances became instrumental only their titles and a few rhythmic traits survived (§123). Use the
traits below as the **identity markers**; everything else follows normal phrase rules. Dances are
**square** (no limping bars, §35) and use the binary suite type (baroque) or ternary/rondo form (§198).

## Rules
- R1 `MUST` Keep dance phrases square (multiples of 4 real bars) (§34bis–35).
- R2 `MUST` Respect each dance's upbeat and cadence placement (table); these define the dance more than tempo.
- R3 `AVOID` Mazurka traits (dotted beat 1, feminine endings) in a waltz (§202).
- R4 `PREFER` 19th-c. dances: ternary (A–Trio–A) or rondo, closed sections joined by short welds or
  transitions, optional intro and coda (§198).
- R5 `ALLOWED` Tempos in BPM below are **general knowledge** ranges; Zamacois gives only verbal tempos.

## Table
Pattern notation: `onset:len` in quarter-note beats from the bar start (builder `beat`/`len`); negative
onsets = pickup in the previous bar. `>` = accent (vel +15–25).

| dance | meter | tempo (verbal; BPM gk) | upbeat | characteristic rhythm (melody unless noted) | phrase/cadence notes |
|---|---|---|---|---|---|
| Allemande | 4/4 | Allegro moderato (♩ 60–80) | one 16th, same pitch as next note: `-0.25:0.25` | running 16ths shared between voices: `0,0.25,0.5…:0.25` | binary; texture more than tune |
| Courante (French) | 3/2 (6 qn) | moderate–grave (♩ 90–120) | short pickup | beat 1 dotted into 2: `0:1.5 1.5:0.5 2:1`; hemiola 3/2↔6/4 (gk) | anacrustic; cadences hemiola |
| Corrente (Italian) | 3/4, 3/8 | fast (♩. 60–80 gk) | 8th | running 8ths `0,0.5,1,1.5,2,2.5:0.5` | |
| Sarabande | 3/4 (3/2) | slow, noble (♩ 54–72) | usually none (thetic) | beat 2 lengthened: `0:1 >1:1.5 2.5:0.5` or `0:1 >1:2` | feminine endings frequent; heavy ornament |
| Gigue | 6/8, 12/8 (3/8) | very lively (♩. 100–140) | 8th `-0.5:0.5` | old: `0:0.75 0.75:0.25 1:0.5` per dotted-qn pulse; later `0,0.5,1:0.5` | **fugal entries**; Part II subject inverted |
| Loure | 6/4 (3/4) | moderate–slow (♩ 80–100) | 8th + quarter: `-1.5:0.5 -1:1` | lands on dotted quarter: `0:1.5` | (pattern read from §128) |
| Bourrée / Rigaudon | 2/2 (4 qn) | light, quick (𝅗𝅥 80–100) | one quarter `-1:1` | `0:1 1:1 2:2` / running quarters | phrases end on the 3rd quarter (beat 2) |
| Gavotte | 2/2 | moderate, no very short values (𝅗𝅥 60–80) | **half bar**: `-2:1 -1:1` | `0:1 1:1 2:1 3:1`, cadence `0:2` | phrase runs beat 2 of bar 1 → beat 1–2 of last bar |
| Pavane | 2/2, 4/4 | slow (𝅗𝅥 40–50) | none | `0:2 2:1 3:1` (gk) | often paired with galliard |
| Galliard | 3/2 or 3/4 | lively (gk ♩ 120–160) | none | `0:2 2:1` alternating with `0:1 1:1 2:1` (hemiola, gk) | after the pavane |
| Minuet | 3/4 | moderate (♩ 120–144); sonata minuet livelier | one beat `-1:1` (early: none) | 8ths over quarter bass; cadence `0:1 >` (appoggiatura) → `1:2` | 2-bar groups, **feminine ending on beat 2** |
| Passepied | 3/8, 3/4 | fast (♩. 70–90) | one 8th `-0.5:0.5` | running 8ths | |
| Siciliana | 6/8, 12/8 | moderate, lilting (♩. 40–60) | often 8th | `0:0.75 0.75:0.25 1:0.5 1.5:1.5` | minor, pastoral |
| Chaconne / Passacaglia | 3/4 | slow (♩ 60–80) | often starts beat 2 (gk) | sarabande-like, beat 2 weight | ostinato, see [[ostinato-chaconne-passacaglia]] |
| Musette | 2/2 or 3/4 | moderate, pastoral | as host dance | **drone** bass: tonic (+5th) held or re-struck every bar | used as Gavotte II / Minuet II |
| Hornpipe | 3/2 (later 2/4, 4/4) | lively | — | syncopated `0:1 1:2 3:2 5:1` in 3/2 (gk) | English |
| March | 2/4, 4/4 (6/8) | funeral ♩ 50–60, military ♩ 110–120 | dotted pickup `-1:0.75 -0.25:0.25` | dotted step: simple `0:0.75 0.75:0.25`; compound `0:1 1:0.5` | chords on every beat; trio in IV (gk) |
| Polonaise | 3/4 | moderate (♩ 84–100) | none | accomp. bolero: `0:0.5 0.5:0.25 0.75:0.25 1:0.5 1.5:0.5 2:0.5 2.5:0.5`; melody dotted 16th+32nd `x:0.375 x+0.375:0.125` | **feminine cadence beat 2 → 3** (`1:1` → `2:1`) |
| Mazurka | 3/4 | relatively lively (♩ 120–160) | none or 8th | `>0:0.75 0.75:0.25 1:1 2:1` (or 8th rest for the dot) | feminine cadences; accent may fall on 2 or 3 (gk) |
| Waltz | 3/4 (one beat per bar) | slow–fast (𝅗𝅥. 60–75) | often 1 written bar | accomp. bass `0:1`, chords `1:1 2:1`; melody long values, no dotted beat 1 | real bar = 2 written bars; plan in 2-bar units |
| Tarantella | 6/8 (3/8) | very fast (♩. 140–180) | — | running 8ths or `0:1 1:0.5 1.5:1 2.5:0.5` (quarter+8th) | brilliant, perpetual motion |
| Pastorale | 6/8, 3/4 (12/8) | moderate | — | siciliana-like lilt + drone (gk) | shepherd-pipe melody |
| Berceuse / Barcarolle | 6/8, 12/8 | slow–moderate | — | rocking accomp.: bass `0:1.5` + broken chord 8ths `0.5,1,…` | melody alone carries the piece |

## Apply in MIDI / REAPER
- Set the project time signature first; for 2/2 dances the builder still counts quarter notes (4 per bar).
- Velocity grid (general knowledge): strong beat 90–100, secondary 75–85, weak 60–70; accent marks `>`
  add 15–25. Waltz: bass beat 1 at 85–95, chords 2–3 at 55–65.
- Swing/humanise: none for baroque dances (straight); Viennese waltz may anticipate beat 2 slightly
  (−10 to −30 ms, general knowledge).

## Checklist
- Meter, upbeat and cadence placement match the table?
- Is the characteristic rhythm present in most bars of the melody or accompaniment?
- Are phrases square and the overall form binary (baroque) or ternary/rondo (19th c.)?

## Examples
- "Gavota en Re": 2/2, two-quarter pickup (beat 2–3 of a pickup bar), 4+4 phrases ending mid-bar on a
  half note, binary ‖: D → A :‖: A → D :‖.
- "Vals lento en La b": 3/4, bass Ab2 (44) beat 1, chords on 2–3, melody in dotted halves/quarters, 16-bar
  sections (= 8 real bars), A–B–A + coda.
