---
id: form.character-pieces
title: Character pieces (nocturne, berceuse, barcarolle, fantasia, toccata, rhapsody…)
aliases: [piezas de carácter, fantasía, capricho, tocata, pastoral, impromptu, romanza sin palabras, balada, leyenda, noveleta, elegía, nocturno, berceuse, canción de cuna, barcarola, rapsodia, momento musical, hoja de álbum, Charakterstück]
domain: form
tags: [character-piece, romantic, miniature, texture]
style_scope: romantic
use_when: When a request names a romantic piano/orchestral miniature by title (nocturno, berceuse, fantasía, rapsodia…) and you need its default form and texture.
summary: The title names a mood, not a structure - default to ternary A–B–A (or rondo) and take texture from the title - rocking 6/8 accompaniment for berceuse/barcarolle, serene arpeggiated nocturne, free improvisatory alternation of themes and runs for fantasia/capriccio/toccata, slow–fast diptych for rhapsody, balanced A–B–A for impromptu.
sources: ["zamacois-formas p.229-235 (§204-219)"]
related: ["[[ternary-form]]", "[[rondo-form]]", "[[dance-types]]", "[[section-functions]]"]
---

# Character pieces

## Core idea
These titles express a **poetic idea**, not a form (like *Sonata*) nor a dance tempo (like *Waltz*), and
are interchangeable (§204). Form is chosen freely; romantic practice overwhelmingly uses **ternary
re-expositive (A–B–A)** or **rondo** (§204 fn).

## Rules
- R1 `PREFER` Default form: A–B–A with a contrasting middle (key/mode/texture), optional intro and coda (§204).
- R2 `MUST` Take the texture/rhythm from the title (table below).
- R3 `PREFER` Impromptu: spontaneous-sounding but balanced — no patchwork, no missing transitions, no tempo
  hopping; ternary preferred (Schubert op.142/3 is variations) (§209).
- R4 `PREFER` Fantasia: alternate passages of defined structure with fast figuration (scales, arpeggios);
  frequent changes of meter, tempo and theme; or a medley "fantasia on (opera)" naming its source (§205).
- R5 `PREFER` Rhapsody: freely linked themes of varied character, commonly two parts **slow → fast**
  (Liszt: lassan + friska) (§218).
- R6 `MUST` Berceuse: simple tender melody that alone carries the piece over an always **rocking**
  accompaniment (§216). Barcarolle: same rocking (boat), melody of a love song or rower's song (§217).

## Title → texture lookup
| title (ES) | character | default form | texture / rhythm (MIDI hint) |
|---|---|---|---|
| Nocturno | serene, contemplative (§215) | A–B–A | wide LH arpeggios in 8ths/triplets spanning 1.5–2 octaves under a cantabile RH; sustain CC64 per harmony |
| Berceuse / canción de cuna | tender (§216) | A–A'–coda or A–B–A | 6/8 (gk) rocking LH `0:1.5`+`0.5,1,2,2.5` 8ths on one chord or tonic pedal; soft vel 40–60 |
| Barcarola | swaying boat (§217) | A–B–A | 6/8 or 12/8 (gk) LH bass on beats 0 and 1.5 + broken chord; melody in 3rds/6ths |
| Romanza sin palabras | intensely lyrical (§210) | A–B–A, short | melody + chordal/arpeggiated accompaniment, melody vel +15 over accompaniment |
| Fantasía / Capricho | free, surprising (§205–206) | sectional, through-composed | alternate themed sections with runs; tempo markers allowed |
| Tocata | brilliant, virtuoso (§207) | sectional | broad opening chords, then continuous 16ths, fugato fragments |
| Pastoral | shepherd scene (§208) | A–B–A | 6/8 or 3/4 moderate; drone fifth in bass; siciliana lilt |
| Balada / Leyenda / Noveleta | narrative (§211–213) | episodic, returns of a narrative theme | changing tempi, recurring "storyteller" theme |
| Elegía | lament (§214) | A–B–A | slow, minor, descending lines |
| Rapsodia | varied, brilliant (§218) | slow part → fast part | lassan (rubato melody) → friska (dance, accelerating) |
| Impromptu | spontaneous but balanced (§209) | A–B–A | one consistent figuration per section |
| Momento musical / Hoja de álbum | miniature (§219) | any, 16–64 bars | single texture |

## Planning template (ternary character piece, 3–4 min)
| section | bars | key | material | ends with |
|---|---|---|---|---|
| Intro | 2–4 | I | accompaniment figure alone | (V) |
| A | 16 (8+8) | I → V / I | cantabile theme | PAC I |
| B | 16–24 | vi, IV, bVI or parallel minor | contrasting texture/agitation | V7 of I |
| A' | 12–16 | I | theme ornamented, fuller | PAC |
| Coda | 4–8 | I | intro figure, tonic pedal | PAC / plagal |

## Apply in MIDI / REAPER
- Piano: separate LH/RH tracks or items; CC64 pedal down just after each harmony change (+0.05 beat),
  up just before the next.
- Nocturne at ♩=60, 4/4: 56 bars ≈ 3 min 44 s.

## Checklist
- Does the texture match the title?
- Is there a clear return (A') and a contrasting middle?
- Rocking pieces: is the rocking pattern unbroken through A sections?
