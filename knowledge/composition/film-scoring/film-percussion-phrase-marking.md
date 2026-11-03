---
id: film-scoring.film-percussion-phrase-marking
title: Percussion as phrase punctuation in film cues
aliases: [percusión orquestal, platos, plato suspendido, redoble, caja, bombo, gran cassa, timbales, tam-tam, golpes secos, secco, swell de platillo, marcar frases]
domain: film-scoring
tags: [percussion, phrasing, transitions, enhancers, timpani, cymbals]
style_scope: film (orchestral adventure scoring, HTTYD; transferable to trailer and epic)
use_when: Writing orchestral percussion for a cue, so it marks phrases, lifts sections and cuts off climaxes instead of playing a constant groove.
summary: In orchestral film writing, percussion punctuates the form. A cymbal hits each phrase downbeat (every 2–4 bars) with a suspended-cymbal swell in the bar before; timpani play single strokes on downbeats and rolls on sustains; the snare plays lift rolls and saves its march figure for the climax. Secco hits cut a climax off cleanly, and celesta and glock sparkle only in lighter sections.
sources: ["httyd-test-drive p.1-15", "film-4day-challenge slide 8", "unir-orq-tema7 p.4-16"]
related: ["[[building-and-releasing-climaxes]]", "[[five-elements-arrangement-checklist]]", "[[action-ostinato-pedal-gallop]]", "[[timpani]]", "[[percussion-unpitched]]", "[[mallet-percussion]]", "[[user-taste]]"]
---

# Percussion as phrase punctuation

## Core idea
Outside the action gallop, orchestral percussion in HTTYD rarely plays a groove. It **marks the
hypermeter** (phrase downbeats), **lifts** into the next phrase (rolls, swells), and **cuts** (secco). That
makes the form audible. Each instrument has a fixed job.

## Rules
- R1 `MUST` (this style) Mark each phrase downbeat (every 2 or 4 bars) with a cymbal or suspended-cymbal
  hit, and put a suspended-cymbal swell p< in the bar before.
- R2 `PREFER` Start a big entry with a percussion pickup: a timpani roll mf<, a suspended cymbal p< and a
  bass-drum roll p<mf in the bar before (HTTYD b.1–2).
- R3 `PREFER` Timpani: single strokes on phrase downbeats, rolls on sustains, the gallop rhythm doubling
  the basses in action, 16th pickups into downbeats at climaxes.
- R4 `PREFER` Lift pattern per bar (musical beats, 1-based): a snare roll p<f over beats 1–2 resolving to an accent on beat 3, with
  bass drum on beat 3. Horns play a half note with an mf<f swell on beat 1 (HTTYD theme B).
  Override: For this user, prefer cymbal swells, timpani rolls or a silence before the downbeat; snare rolls only in rock/marching contexts or on explicit request ([[user-taste]] R3).
- R5 `PREFER` Save the snare march figure (16th groups + 8ths) for the big climax.
- R6 `PREFER` End a climax with secco hits (cymbal, tam-tam, bass drum and timpani on beat 1, no ring).
- R7 `AVOID` Celesta or glockenspiel in ff tutti. Use them only in f-or-softer ostinato sections.
- R8 `PREFER` Leave a tune statement without drums when the tune should carry itself (HTTYD b.21: only
  a cymbal on bar 1).
- R9 `ALLOWED` Enhancer palette (film deck): high = celesta, harp notes or gliss, mark tree, cymbal
  swells, piatti, shakers, crotales; mid/low = tam-tam, snares, timpani hits, swells and rolls, gran
  cassa, sub boom, drums.

## Apply in MIDI / REAPER
Separate tracks: `TIMP`, `SNARE`, `BD`, `CYMBALS` (clash), `SUS CYM`, `TAM-TAM`, `MARK TREE`, `SUB BOOM`
(each one-drum-per-track or kit-mapped; check the library's note map with `dump_midi` or the patch).

| Gesture | Placement (builder beats) | MIDI |
|---|---|---|
| Phrase downbeat | bar start, beat 0, every 2/4 bars | CYMBALS vel 100–115; BD vel 90; TIMP root vel 100 |
| Cymbal swell into it | the bar before, starting about 1–2 beats before the target | SUS CYM roll: CC1 20 → 110 ending exactly at the target, or a swell sample ending on it |
| Lift bar | beats 0–2 roll, accent on beat 2 | SNARE roll CC1 30 → 95 (or 32nds vel 40 → 95), hit vel 110 on beat 2; BD vel 95 on beat 2 |
| Timpani roll on a sustain | through the held chord | roll patch, CC1 shaped like the chord's hairpin |
| Climax pickup | last beat before the climax downbeat | TIMP 16ths (offsets 3, 3.25, 3.5, 3.75) vel 90 → 115 |
| Secco cut | beat 0 | all perc vel 115, `len` 0.1; choke the cymbal (choke articulation, or a short sample with no tail) |

- **Timpani pitch:** tonic and dominant in the timpani range (e.g. D: D2 38 and A2 45; E: E2 40 and B2
  47). In a Classical style, use only those two notes for the whole piece.
- **Mark tree / crotales:** one gesture per 4–8 bars, at transitions only.
- **Density guard:** at most one cymbal event per 2 bars outside climaxes, and no snare in tune statements
  unless it is a lift or a march.

## Checklist
- Does every phrase downbeat (2/4-bar grid) have a cymbal or timpani mark, with a swell before the main ones?
- Do the swells and rolls end exactly on the target downbeat?
- Is the snare march reserved for the climax?
- Does a climax end with a secco (choked) hit when it hands off to a quiet section?
- Is there no celesta or glockenspiel in ff tutti?
- Are the timpani notes tonic and dominant, inside their range?
