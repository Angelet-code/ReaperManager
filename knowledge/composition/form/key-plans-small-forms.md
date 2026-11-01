---
id: form.key-plans-small-forms
title: Key plans for phrases and small forms
aliases: [plan tonal, proceso tonal, proceso modulante, alejamiento, regreso, tonos vecinos, tono de la dominante, relativo mayor, tonal plan, Tonartenplan]
domain: form
tags: [key-plan, modulation, tonal-plan, small-forms]
style_scope: common-practice
use_when: When choosing where a phrase, binary, ternary or dance piece modulates and how it returns home.
summary: Establish the home key, move away (major → V; minor → III or v), optionally digress further among neighbouring keys, then return and re-establish the home key; principal sections stay put, secondary ones modulate, and the move to the subdominant side near the end strengthens closure.
sources: ["zamacois-formas p.19-22 (§22-25)", "zamacois-formas p.42-52 (§42-46)", "zamacois-formas p.151-154 (§122)"]
related: ["[[modulation]]", "[[secondary-dominants]]", "[[cadences]]", "[[binary-form]]", "[[ternary-form]]", "[[section-functions]]"]
---

# Key plans for phrases and small forms

## Core idea
A modulating phrase or piece has two stages: **alejamiento** (moving away to a target key) and **regreso**
(return). Targets are **neighbouring keys** (tonos vecinos: the keys of I's diatonic triads — in C: G, F,
a, e, d; in a: C, e/E, d, F, G). See [[modulation]].

## Rules
- R1 `PREFER` Away-targets (§25): major home → **dominant key (V)**; minor home → **relative major (III)**
  or dominant (v or V). The dominant is the most frequent target.
- R2 `PREFER` Strengthen the plan (§25): (1) establish the home key before leaving; (2) digress in the
  reached key or continue to another neighbour; (3) re-establish home at the end.
- R3 `PREFER` Neighbouring keys only for classical idioms; earlier music modulates less (§25).
- R4 `ALLOWED` Stages need not coincide with period boundaries (§25).
- R5 `PREFER` Hold back IV/ii (subdominant side) until late, so the pre-cadential subdominant has maximal
  weight; a brief touch of the **subdominant key** (C major: F or d) just before the final cadence
  reinforces closure (§25 ex., §41, §45).
- R6 `ALLOWED` Contrast keys for B sections: any key whose tonic triad **shares a note** with the home
  tonic triad gives brightening/darkening (C major: G, g, e, E, a, A, F, f, Ab, Eb, c) (§46 fn).
- R7 `MUST` Returns: arrive on V7 of home at the end of the secondary section (see [[section-functions]]).

## Templates (Zamacois §25 schemes)
| scheme | part 1 | part 2 | part 3 | example |
|---|---|---|---|---|
| Binary 1 | home → away (V/III) | return → home | — | op.13 II b.1–8: Ab→Eb \| Ab |
| Binary 2 | home only (ends HC or PAC) | away + quick return | — | op.2/2 II: D \| A, D, e, G, D |
| Ternary 3 | home → away | digression (other keys), start of return | home | op.2/1 III: f→Ab \| Ab, bb, C \| f |
| Ternary 4 | home only | away ± start of return | home | op.14/1 II: e \| C, G, C \| e |

## Planning table (fill in)
| section | bars | key | material | ends with |
|---|---|---|---|---|
| A1 | 4 | I | theme | HC (V) |
| A2 | 4 | I → V | theme varied | PAC in V |
| B | 4–8 | V → (vi, ii) | derived/contrast | V7 of I |
| A3 | 4–6 | I (touch IV) | theme | PAC in I |

Minor home: replace V by III (relative major) or v; B may touch iv, VI; return via V7 (raised leading tone).

## Apply in MIDI / REAPER
- Modulate to V by pivot (C: Am = ii of G) then V7/V (D7: D–F#–A–C, MIDI 50–54–57–60) → G. Mark the arrival
  bar with a marker `→V`.
- Check accidentals: in C → G, F# must appear (MIDI pitch class 6); in a → C, G♮ replaces G#.
- For each section region add the key to the name (`B V→V7`), so later agents can validate.

## Checklist
- Is the home key clearly established (I–IV–V–I or equivalent) before the first modulation?
- Is the away-target V (major) or III/v (minor), unless a deliberate colour key?
- Does the secondary section end on V7 of home, and does the final section stay in home key?
- Is there a subdominant touch late in the last phrase?

## Examples
- Minuet in G: ‖: G → D (8 bars) :‖: D, e (4) → D7 → G (8) :‖.
- Ternary piece in d: A d → F (8) | B F, g, A7 (8) | A d with Gm touch (8+2).
