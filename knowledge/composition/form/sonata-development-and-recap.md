---
id: form.sonata-development-and-recap
title: Sonata form — development, retransition, recapitulation, coda
aliases: [desarrollo, reexposición, recapitulación, retransición, pedal de dominante, pedal de V, falsa reexposición, coda final, desarrollo codal, Durchführung, Reprise, Rückführung]
domain: form
tags: [sonata-form, development, retransition, recapitulation, coda]
style_scope: common-practice
use_when: When writing the second half of a sonata-form movement (development through coda) or any development section that must lead back to a return.
summary: The development works exposition material (fragmentation, sequence, mode change, imitation, superposition) through keys not used in the exposition and ends on a carefully prepared dominant (pedal of V, or a key-area tonic reinterpreted as V); the recapitulation starts with A in the home key and original form, rewrites the bridge so B lands in the tonic, and may end with a larger coda.
sources: ["zamacois-formas p.177-183 (§150-153)", "zamacois-formas p.188-189 (§157)", "zamacois-formas p.38-41 (§40)", "sonata-outline"]
related: ["[[sonata-form]]", "[[thematic-development]]", "[[section-functions]]", "[[phrase-asymmetry]]", "[[modulation]]", "[[secondary-dominants]]"]
---

# Sonata form — development, retransition, recapitulation, coda

## Core idea
Development = free play, modulating, with all or part of the material; it ends on the **dominant of the
home key** (outline: *pedal de V*). Recapitulation = exposition again with **B transposed to the tonic**
(the bridge is adjusted). The coda confirms the home key and may contain a second development.

## Rules — development
- R1 `ALLOWED` Structure and key plan free, but purposeful — never capricious, never a copy of the
  exposition's tonal path (§150).
- R2 `MUST` Work with exposition elements: fragmentation, rhythmic/melodic/modal change, expansion,
  reduction, imitation, superposition (§150).
- R3 `AVOID` A theme in the same key **and** same harmonisation as before; change one (§150).
- R4 `ALLOWED` New complementary elements, even an important new theme (op.10/2) (§150; outline: new
  elements optional).
- R5 `ALLOWED` Any starting key; often the key that closed the exposition (op.2/1 starts in Ab) (§150).
- R6 `ALLOWED` Fugato is a classic development texture: 3–4 imitative entries, then dissolve (see
  [[school-fugue-plan]]).
- R7 `PREFER` End on the dominant family of the home key (V, V7, vii°7), carefully prepared — the effect of
  the return depends on it (§150). Two devices: (a) **dominant pedal** 4–8 bars (outline); (b) dwell on a
  chord as a local tonic (e.g. G in a C movement), then reinterpret it as V (op.2/3) (§150).
- R8 `MUST` The recapitulation begins when A returns in its **original key and form**; a complete A in
  another key inside the development is a **false recapitulation** (op.10/2: A in D, real recap in F) (§150).

## Rules — recapitulation
- R9 `MUST` A in the home key; bridge kept, varied, replaced or omitted, but it must lead to **B in the home
  key**; B (with or without all its elements) in the home key; coda re-exposed in the home key, replaced
  or extended (§151; outline R7).
- R10 `PREFER` Bridge rewrite: start as in the exposition, then bend the path to end on **V of I** (not V
  of V) — often by dipping toward IV/ii at the point where the exposition went sharp (§151, §157).
- R11 `ALLOWED` Drop, shorten, substitute or expand secondary elements; change texture (§151).
- R12 `ALLOWED` If B was major in a minor movement, recap it in the tonic minor or major (op.2/1: tonic minor) (§151).
- R13 `ALLOWED` Bigger licences: start b' in IV then return (op.13); start A from its second element after a
  false recap; B before A (a Mozart D-major sonata) (§151).
- R14 `PREFER` Final coda is often weightier than the exposition's: deceptive cadence to vi, brief cadenza-like
  passage, A head, development fragments, broad cadential formula, tonic close (op.2/3 recap) (§151–152).
- R15 `ALLOWED` Slow movements may omit the development entirely, replacing it with a short link
  (conducción) from exposition end to recap (§157).

## Planning template (second half)
| section | bars | key | material | ends with |
|---|---|---|---|---|
| Dev 1 (entry) | 8–12 | V or a surprise key (bVI, iii) | A head or closing theme | modulation |
| Dev 2 (core) | 12–24 | ii, vi, IV, iii (minor: iv, VI, v, bII) | sequences, fugato, A+B superposed | arrival on V of a key |
| Retransition | 4–8 | V pedal of I | A head fragments, rising | V7 (fermata optional) |
| Recap A | = A | I | A | HC / elided |
| Bridge' | ±A bridge | I (→IV dip) | bridge rewritten | V of I |
| B' | = B group | I | B group | PAC in I |
| Coda | 8–25 | I (IV, ii touches) | A head, cadences, maybe codal development | PAC, tonic pedal |

## Apply in MIDI / REAPER
- Sequence engine: take a 1–2 bar fragment, transpose by descending 5ths (A–D–G–C roots) or by steps,
  2–4 statements, with a secondary dominant before each new key (see [[secondary-dominants]]).
- Dominant pedal: bass G1/G2 (31/43 in C) repeated 8ths or held; upper voices climb by step; CC1 crescendo
  +30; last bar V7 (or vii°7/V–V7); 0–1 beat of silence before A.
- Bridge' transposition check: compute the exposition bridge's target (V/V) and replace the final 2–4
  bars so the target becomes V of I (C: G chord, not D).
- Regions `Dev`, `RT`, `Recap`, `Coda`; marker `RECAP` at A's downbeat.

## Checklist
- Does the development avoid the exposition's key/harmony pairings and visit at least two other keys?
- Is the last development chord V/V7/vii°7 of home, prepared by a pedal or reinterpretation?
- assert key(A recap) == home and key(B recap) == home?
- Does the bridge' end on V of I (not V of V)?
- Does the coda end with PAC in I, preferably after a subdominant touch?

## Examples
- Op.2/3 development: b''' material modulating (b.90) → arpeggios on the bridge rhythm (b.97) → A in D,
  modulating, with a syncopated counter-line (b.139) → G chord reinterpreted as V → recap (§150).
- Op.10/1 Adagio (no development): codetta in Eb + one bar turning Eb into V7 of Ab → recap (§157).
