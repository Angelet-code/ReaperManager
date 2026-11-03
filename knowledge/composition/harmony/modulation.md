---
id: harmony.modulation
title: Modulation (pivot chord, direct, remote, chained)
aliases: [modulación, modular, acorde pivote, acorde común, zona intermedia, eje, modulación directa, modulación por terraza, tonalidad de destino, tonalidades vecinas, Modulation, Drehakkord, Umdeutung, Rückung]
domain: harmony
tags: [modulation, key-change, pivot, tonal-plan]
style_scope: common-practice (cadence-pivot-cadence logic is universal; direct shifts are idiomatic in pop and film)
use_when: Changing key inside a piece or cue, planning a tonal route through several keys, or making a sudden key shift sound intentional.
summary: Establish the old key with a cadence, pass through a pivot chord that makes sense in both keys (best: the old tonic, else its V or IV, or a chord that becomes a secondary dominant or borrowed/Neapolitan chord of the new key), then confirm the new key with its own cadence V–I. Direct ("terrace") shifts are a rare special effect; remote keys are reached fast via an altered dominant or diminished seventh.
sources: ["hindemith-1 p.99-108", "hindemith-1 p.109-116", "hindemith-2 p.22-29", "hindemith-2 p.41-71"]
related: ["[[cadences]]", "[[secondary-dominants]]", "[[mode-mixture-and-neapolitan]]", "[[augmented-sixth-chords]]", "[[diminished-seventh-pivot]]", "[[harmonic-planning-seven-factors]]", "[[key-plans-small-forms]]", "[[_form]]", "[[_film-scoring]]", "[[_harmony]]"]
---

# Modulation

## Core idea
A clear modulation expresses each key purely: old key confirmed → pivot zone (chords that belong to both) →
new key confirmed by the same means (a cadence). The pivot can be a single chord. Faster or more distant
routes use chromatic pivots or direct juxtaposition, but every key you pass through must still be readable.

## Rules
- R1 `MUST` Do not leave the old key before it is firmly established (normally a V–I cadence).
- R2 `MUST` Establish the target key the same way: a cadence ending V–I.
- R3 `PREFER` Simplest pivot: the old tonic, reinterpreted in the new key. `ALLOWED`: the old V or IV.
- R4 `ALLOWED` The pivot may become in the new key: (a) the secondary dominant of its V or IV; (b) the
  secondary dominant of its II, III or VI; (c) a simply altered chord (borrowed minor chord, Neapolitan).
  Any chord of the old key that can take one of these roles may be the pivot.
- R5 `ALLOWED` Direct ("terrace") modulation: after the old key is set, start the new key without pivot, as a
  contrast. `PREFER` keeping a perceptible link between the last old and first new chord (shared tone,
  similar sonority, or a deliberate contrast of density). `AVOID` frequent close abrupt shifts: incisive, then
  disturbing, then incomprehensible.
- R6 `ALLOWED` Fast moves to distant keys: make the last chord of the old key an altered dominant (German /
  French sixth, augmented dominant) of the new key (see [[augmented-sixth-chords]]); not usable everywhere.
- R7 `ALLOWED` Reach the target through intermediate keys; `MUST` define each one clearly (at least a short
  cadential gesture) so it does not sound like a neighbouring key.
- R8 `PREFER` Keep bars between two clear key regions tonally neutral; `AVOID` rapid or unbalanced modulations.
- R9 `MUST` (tonal plan) The main key has the most bars and holds the first and last place; the second key
  must also be well confirmed. A late excursion to the subdominant key must sound like IV of the home key:
  colour it with home-tonic and home-dominant notes.
  - *Outside this style:* pop uses direct shifts up a semitone or whole tone for a last chorus, and film uses
    chromatic-mediant jumps (C → Ab, C → E) as emotional cuts (general knowledge). Those are Hindemith's
    "terrace" type: keep one common tone or a clear new-key V–I soon after.

## Apply in MIDI / REAPER
- Closely related keys (general knowledge): the keys whose tonic is a major/minor diatonic triad of the old
  key (C: Dm, Em, F, G, Am).
- Pivot search: list the diatonic triads of both keys (pitch-class sets); intersection = common chords
  (C→G: C, Em, G, Am). Prefer in order: old I, old V, old IV, any common chord, then chromatic pivots per R4.
- Template: old cadence (≥ 3 chords ending V–I) → pivot (1 chord, weak-to-medium beat) → new V7 (often with
  pre-dominant) → new I on a strong beat, then extend the new key ≥ 2 bars before leaving it.
- Remote route: pick the new key t'; write {t'+8, t', t'+3, t'+6} (German sixth of t') as the old key's last
  chord when it is enharmonically a V7 there (e.g. C7 in F = German sixth of E) → B → E.
- Write the key change in REAPER as a text marker at the bar where the new V–I lands (for later analysis).

## Checklist
- Old key confirmed before moving; new key confirmed by V–I?
- Pivot has a valid role in both keys?
- Every intermediate key readable (short cadence)?
- Direct shift keeps a link and is not overused?

## Examples
- C → G: C: I–IV–V–I | C (= IV in G) – D7 – G.
- C → A minor: C: … I | F (IV = VI) – E7 – Am.
- C → Eb: C: … I | Fm (borrowed iv = ii in Eb) – Bb7 – Eb.
- C → E (remote): C: … I – C7 (= German sixth of E) – B (V) – E.
