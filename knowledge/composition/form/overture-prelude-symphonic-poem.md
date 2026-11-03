---
id: form.overture-prelude-symphonic-poem
title: Overture, prelude, symphonic poem, ballet, incidental music
aliases: [obertura, obertura francesa, obertura italiana, sinfonía (obertura), preludio, poema sinfónico, ballet, entradas, música incidental, ilustraciones musicales, música de escena, Ouvertüre, Vorspiel, symphonische Dichtung]
domain: form
tags: [overture, prelude, symphonic-poem, ballet, programmatic, incidental-music]
style_scope: baroque-romantic
use_when: When planning a one-movement orchestral opener, a programmatic piece that follows a story, a ballet number chain, or background music for theatre/film.
summary: French overture = slow dotted – fast fugato – slow return; Italian = fast–slow–fast; classical opera overture = slow intro ending on V + sonata-form Allegro (with or without development); synthesis overture develops the drama's themes (mosaic medley = weak); symphonic poems invent a form from the programme but must keep musical returns; ballets are chains of self-contained numbers or one symphonic flow; incidental music sets atmosphere.
sources: ["zamacois-formas p.214-223 (§177-197)"]
related: ["[[sonata-form]]", "[[section-functions]]", "[[thematic-development]]", "[[baroque-suite]]", "[[dance-types]]", "[[form-for-modern-songs]]"]
---

# Overture, prelude, symphonic poem, ballet, incidental music

## Rules
- R1 `MUST` French overture (Lully): Lento (dotted, majestic) – Allegro (usually fugato) – Lento (return of
  the first); Italian overture/sinfonia (A. Scarlatti): Allegro – Lento – Allegro (§181).
- R2 `PREFER` Rameau 2-part type: Lento → Allegro; the Lento ends so the Allegro starts in the main key (same
  or opposite mode) (§181).
- R3 `PREFER` Classical opera overture: slow intro (optional) → Allegro in sonata form, either without
  development (Mozart *Figaro*) or full (Don Giovanni) (§182).
- R4 `ALLOWED` Insert an episode from the drama, preferably in or at the end of the development (Leonore 3:
  offstage trumpet) (§182).
- R5 `PREFER` Synthesis overture: themes chosen and ordered by dramatic meaning, developed symphonically;
  `AVOID` the mosaic/medley that only strings tunes together (§183).
- R6 `PREFER` Wagnerian prelude: short, limited to the central feeling's theme(s), or a mere curtain-raiser (§184).
- R7 `ALLOWED` Keyboard prelude before a fugue: free; often one figuration (arpeggios/scales) establishing the
  key, or a persistent theme (§178).
- R8 `MUST` Symphonic poem: invent the form from the programme, but **do not let the story stifle the
  musical structure** — cut, merge or reorder story beats to keep balance and thematic returns (§188).
- R9 `ALLOWED` Programme detail from bar-by-bar narration to a single general mood (§188).
- R10 `PREFER` Classical ballet: chain of independent, clearly delimited numbers, each with its own form;
  Russian (Diaghilev) ballet: one continuous symphonic-poem-like flow driving the mime (§194–195).
- R11 `PREFER` Incidental music creates atmosphere around spoken action rather than carrying it; its pieces
  keep their own forms (§197).

## Planning templates
Classical overture (sonata-based; bar ranges are general knowledge):
| section | bars | key | material | ends with |
|---|---|---|---|---|
| Slow intro | 8–30 | i or I | motto chords, motif seed | V (HC, fermata) |
| Allegro A | 16–30 | I | main theme | → bridge |
| Bridge → B | 10–20 / 20–40 | → V (III) | B lyrical | PAC in V |
| Development (or link) | 0–60 | away | A/B fragments, drama episode | V pedal |
| Recap | ≈ expo | I | A, B in I | — |
| Coda | 10–40 | I | stretta, faster | PAC |

Symphonic poem / programmatic cue (general-knowledge template applying R8):
| section | story beat | key/colour | theme state | ends with |
|---|---|---|---|---|
| 1 | setting | home | motif fragments | open |
| 2 | protagonist | home | theme A complete | HC |
| 3 | conflict | remote keys | A transformed + antagonist B | climax on V or tritone key |
| 4 | resolution | home | A apotheosis | PAC |
| 5 | epilogue | home | A fragment, quiet | PAC/plagal |

## Apply in MIDI / REAPER
- Use REAPER markers for story beats and regions for musical sections; check that each region still has a
  thematic identity (A, B, transformation of A) — R8.
- Leitmotif transformation per scene: same head, changed mode/harmony/tempo/orchestration
  (see [[thematic-development]]).
- French overture Lento: dotted rhythms sharpened to double-dotted (`0:0.875 0.875:0.125` within each quarter
  beat — performance convention, general knowledge).

## Checklist
- Overture type chosen (French/Italian/classical/synthesis) and its section order respected?
- Symphonic poem: do story beats map onto sections that still recall themes musically?
- Ballet: is each number self-contained (own form, meter) or deliberately continuous?
