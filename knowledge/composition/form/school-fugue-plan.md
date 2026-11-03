---
id: form.school-fugue-plan
title: School fugue plan, double fugue, fughetta and fugato
aliases: [fuga de escuela, fuga escolástica, fuga tipo francés, plan de fuga, doble fuga, fuga triple, fugueta, fughetta, fugado, fugato, estilo fugado, Schulfuge, Doppelfuge]
domain: form
tags: [fugue, school-fugue, key-plan, stretto, fugato, double-fugue]
style_scope: baroque
use_when: When you need a ready-made, step-by-step section and key map for a whole fugue, a double fugue, or a short fugato inside another piece.
summary: French school fugue (Gedalge/Dupré) - exposition S R S R → episode → S in the relative → its answer → longer episode → S in IV → (S/R in the relative of IV) → long episode → dominant pedal + half cadence → three S–R strettos in the tonic, each closer, with optional CS strettos between → tonic pedal. Fugato = 3–4 entries inside a larger movement, then dissolve.
sources: ["zamacois-formas p.117-135 (§93-103)"]
related: ["[[fugue]]", "[[fugue-tonal-answer]]", "[[imitation-and-canon]]", "[[sonata-development-and-recap]]", "[[theme-and-variations]]"]
---

# School fugue plan, double fugue, fugato

## Core idea
The Paris Conservatoire "French school fugue" is a fixed template (Cherubini, Dubois, Gedalge, Dupré;
Zamacois follows Gedalge/Dupré). It is the most useful **planning skeleton** for any fugue an agent writes.

## Rules (general observations)
- R1 `MUST` Keep the number of real voices; a voice rests briefly and closes melodically before resting (§97).
- R2 `MUST` A voice re-entering brings S, R, CS or an important design, never filler (§97).
- R3 `MUST` Each entry starts on a chord tone, preferably after a rest in that voice and not in unison with
  another voice (§97).
- R4 `NEVER` The same voice states two consecutive entries (§97).
- R5 `NEVER` A conclusive cadence in section 1; later only if voices keep moving (§97).
- R6 `PREFER` Pedals in the bass; under a pedal add a voice so the active count above stays the same (§97).
- R7 `PREFER` At least 3 S–R strettos: first and last in the tonic, each closer than the previous; first
  and last with 4 equidistant entries S R S R in different voices, the 4th complete (§96).
- R8 `AVOID` A stretto section out of proportion to the rest of the fugue (§96).

## Planning template (C major / A minor; L = subject length in bars)
| # | section | bars | key C major | key a minor | ends with |
|---|---|---|---|---|---|
| 1 | Expo: S R S R (4 voices, one each) | 4L | C G C G | a e a e | entry end |
| 2 | (Counter-expo, optional: R, S in voices not yet used) | 2L | G C | e a | — |
| 3 | Episode 1 | ≈ L–2L | C → a | a → C | V of next key |
| 4 | S in relative | L | a minor | C major | — |
| 5 | its answer | L | e minor | G major | — |
| 6 | Episode 2 (longer) | ≈ 2L | → F | → d | — |
| 7 | S in IV | L | F | d | — |
| 8 | (short episode) + S/R in relative of IV | L | d minor | F major | — |
| 9 | Episode 3 (longest) | 2L–3L | → G | → E | — |
| 10 | Dominant pedal + half cadence (fermata opt.) | 2–6 | G pedal | E pedal | HC |
| 11 | Stretto 1: S R S R equidistant | 2L–3L | C | a | — |
| 12 | Episode or CS stretto (opt.) | L | C/neighbours | a/neighbours | — |
| 13 | Stretto 2 (closer, 2+ entries) | 1.5L | C or neighbour | a or neighbour | — |
| 14 | Stretto 3: S R S R, closest | 1.5L | C | a | — |
| 15 | Tonic pedal: head imitated or S over pedal | 2–6 | C pedal | A pedal (Picardy opt.) | PAC |

Episode length heuristic: grows through section 2 (Gedalge ≈ 2L then > 3L; Dupré ≈ L then 2L).
Voice orders for 4-voice expositions (§97): S-A-T-B, B-T-A-S, A-T-B-S, T-A-S-B. Two-voice fugues: voice 1 =
entries 1 and 4, with a longer codetta between entries 2 and 3.

## Double fugue, fughetta, fugato
- R9 `MUST` Double fugue = a second subject exposed and developed on its own (fewer entries), then **combined**
  with S1, in stretto if possible (§98-103; WTC II/18 combines at b.97).
- R10 `PREFER` Gedalge double-fugue plan (§98-103): expo S1 → episode → S1 in relative → rest on V → expo S2 in
  the tonic → episode on S2 → S1+S2 in ii (major) / VI (minor) → their answers → episode combining both →
  S1+S2 in IV → episode + V pedal → strettos and end.
- R11 `ALLOWED` Fughetta: minimal exposition, slight development (§98-103).
- R12 `PREFER` Fugato: 3–4 fugal entries (S R S R) inside a sonata/symphony movement (often the development)
  or a variation finale, then dissolve into homophony/sequences (§98-103).
- R13 `AVOID` Triple/quadruple fugues unless secondary subjects are combined early (§98-103).

## Apply in MIDI / REAPER
- Compute bars: with L = 2, the plan above ≈ 8 + 3 + 2 + 2 + 4 + 2 + 2 + 5 + 4 + 5 + 2 + 3 + 3 + 4 ≈ 49 bars
  (without counter-exposition) — at ♩=80 in 4/4 ≈ 2 min 27 s.
- One region per row; name with step number and key (`07 S in IV F`).
- Fugato in a development: entries 1 bar apart in strings (vc → va → vn2 → vn1), each entry vel +10, then
  tutti homophony.

## Checklist
- Every step present or deliberately skipped (counter-expo, step 8, CS strettos are optional)?
- Section 2 keys = relative, its answer, IV, relative of IV — none repeating exposition keys?
- Dominant pedal + HC before the strettos; strettos closer each time; final tonic pedal?
- No voice with two consecutive entries; all entries on chord tones?
