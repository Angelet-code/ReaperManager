---
id: form.ternary-form
title: Ternary form and Lied forms (ABA, ternary Lied, five-section Lied)
aliases: [forma ternaria, Lied ternario, ABA, A-B-A, Lied desarrollado, Lied en cinco secciones, forma Lied, tipo Lied, dreiteilige Liedform, song form]
domain: form
tags: [ternary, lied, aba, slow-movement, small-forms]
style_scope: common-practice
use_when: When writing an A-B-A piece, a slow movement, a character piece, or any form with one contrasting middle and a return.
summary: Ternary Lied = A (principal, often itself a small a-b-a) | B (episode in a neighbouring key or mode, transitional, ends on V7 of home) | A (total or partial return in the home key, enriched, closing). B should be neither too short nor too long; the five-section Lied (A B A C A) is its rondo-like extension.
sources: ["zamacois-formas p.28-29 (§31)", "zamacois-formas p.48-52 (§43-46)", "zamacois-formas p.183-191 (§154-157)"]
related: ["[[binary-form]]", "[[rondo-form]]", "[[minuet-scherzo-trio]]", "[[key-plans-small-forms]]", "[[section-functions]]", "[[character-pieces]]", "[[modulation]]"]
---

# Ternary form and Lied forms

## Core idea
**A–B–A**: exposition of the principal idea, a contrasting **episode**, and a **reexposition**. Zamacois
(after Riemann) calls this the ternary Lied. Each section may itself be primary (one phrase), binary or
ternary; the structure of one section never dictates another's (§155).

## Rules
- R1 `MUST` A = principal idea, open or closed; B = episode with its own or A-derived material; A' =
  reexposition, **conclusive**. Only in ternary form may the return be **total** (§46).
- R2 `AVOID` B too short or too long — the return then comes too early or too late. B may be about half of
  A when it is only a link to the return (§46 fn).
- R3 `ALLOWED` B may be A's phrase in another key ("A-B-A by tonality"), ideally a key sharing a note with
  the home tonic triad (§46).
- R4 `PREFER` B starts in a neighbouring key (or tonic major/minor) and ends so as to enter A' smoothly —
  normally on V7 of home (§155).
- R5 `PREFER` A' is enriched: ornamented melody, new accompaniment figure, octave change, sometimes a small
  development; rewrite its last subperiod so it closes in I if A originally ended elsewhere (§155, §46).
- R6 `ALLOWED` Coda built from A's and B's main elements (§155, op.28: 17-bar coda).
- R7 `MUST` Five-section Lied (developed Lied): A – B – A – C – A (+ coda); C is a second, independent
  episode (may reuse B's elements); sections are **shorter** than in a plain ternary Lied (§156).
- R8 `PREFER` In the five-section Lied, keep C's accompaniment figuration in the final A (op.13 II: 16th
  triplets from C carried into the last A) (§156).
- R9 `ALLOWED` Slow movements may also use sonata form, with or without development (see [[sonata-form]]) (§157).

## Planning template (ternary Lied, slow movement)
| section | bars | key | material | ends with |
|---|---|---|---|---|
| intro (opt.) | 0–4 | I | accompaniment figure | V |
| A: a | 8 (×2) | I → V (minor: i → v/III) | principal phrase | PAC in V (or I) |
| A: b | 4–8 | V, on V pedal | episodic, derived | V7 of I |
| A: a' | 6–8 | I | a, ending changed | PAC in I |
| B | 8–24 (≈ ½–1 × A) | IV, vi, relative, or tonic major/minor | new or derived | V7 of I |
| A' | = A or shorter | I | A ornamented, new figuration | PAC |
| coda (opt.) | 4–17 | I (touch IV) | A + B heads | PAC, tonic pedal |

Five-section: A(8–16) B(8) A(8, often not repeated) C(8–12, may go far, e.g. bVI) + 4–6 bars to V7 | A(8–16,
with C's figuration) coda.

## Apply in MIDI / REAPER
- Regions `A`, `B`, `A'`, `Coda`; mark B's last bar `V7→A'`.
- Contrast B by at least two parameters: key/mode, texture (chordal ↔ arpeggiated), register, articulation
  (legato ↔ staccato), tempo feel (use REAPER tempo marker only if a real tempo change is intended).
- A' variation: duplicate A's MIDI, add 16th or triplet figuration in the accompaniment, ornament melody
  (turns, passing notes), raise melody an octave for one period, vel +5–10.

## Checklist
- Does B contrast in key and/or mode and in at least one textural parameter?
- Does B end on V(7) of home (or prepare A' otherwise)?
- Is A' in the home key and conclusive, with its ending adjusted if needed?
- Is B's length between about ½ and 1 × A?

## Examples
- Schumann *Album* No.6: A-B-A, 8 bars each; B built on A's opening notes; return with melody in the left hand (§46).
- Beethoven op.28 II (d): A = 8 (rep.) d→a + 8-bar episode on V + 6-bar return; B in **D major**; A' with
  written-out ornamented repeats; 17-bar coda from A and B (§155).
- Beethoven op.13 II (Ab): A8 – B (f→Eb→V7) – A8 – C (ab → E=Fb) + 6 bars to V7 – A with triplets – coda (§156).
