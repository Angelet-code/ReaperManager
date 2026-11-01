---
id: form.binary-form
title: Binary forms (small binary, rounded binary / binary Lied, baroque suite binary)
aliases: [forma binaria, tipo binario, Lied binario, binario reexpositivo, rounded binary, tipo suite, forma binaria de suite, pequeño tipo binario, zweiteilige Liedform]
domain: form
tags: [binary, rounded-binary, suite, dance, small-forms]
style_scope: common-practice
use_when: When writing a short two-part piece, a baroque dance movement, or a 16-bar AABA-like theme.
summary: Binary = two parts; part 1 states and usually modulates (V or III), part 2 returns home and closes. Variants - A-A' (second part never an exact repeat), A-B, rounded binary/binary Lied (B + partial return of A), and the repeated baroque ‖:I→V:‖:V→I:‖ suite type whose part 2 restarts with the opening motif.
sources: ["zamacois-formas p.19-22 (§22-25)", "zamacois-formas p.29-33 (§32)", "zamacois-formas p.48-52 (§43-45)", "zamacois-formas p.151-154 (§118-122)"]
related: ["[[ternary-form]]", "[[key-plans-small-forms]]", "[[baroque-suite]]", "[[dance-types]]", "[[suspensive-conclusive-endings]]", "[[cadences]]"]
---

# Binary forms

## Core idea
Two main divisions. Applies at every level (a phrase of 2 periods, a piece of 2 parts). Three practical
types: **small binary** (A-A' or A-B), **binary Lied / rounded binary** (A | B + partial A), and the
**baroque suite binary type** (two repeated halves, I→V | V→I).

## Rules
- R1 `NEVER` In A-A', the second A must not be an exact repeat (that is just a repeated single phrase):
  change rhythm, line, harmony or tonal path (§45).
- R2 `MUST` A-B: part 1 = A ending open or closed; part 2 = B (same or opposite mode) ending conclusive (§45).
  Verse (copla) + refrain (estribillo) songs fit here (§223).
- R3 `MUST` Binary Lied (rounded binary): part 1 = exposition of A (open or closed); part 2 = B + return of
  **only part** of A (typically its last period), ending conclusive; if the ending differs from part 1,
  make it **more** conclusive (§45).
- R4 `PREFER` Most common 4-period shape = binary Lied: P1 open | P2 closed | P3 open (contrast or A in
  another key) | P4 closed and reexpositive (§32). Beethoven Sonatas 1 II b.1–16, 2 II b.1–19.
- R5 `MUST` Suite binary type (§122): Part I states the main idea in the home key, spins it out with
  sequences/imitation, modulates and ends with an ample cadence in **V** (major) or **III / v** (minor);
  Part I is repeated. Part II modulates back (often via neighbouring keys) and closes in I; Part II is
  repeated.
- R6 `PREFER` Suite Part II opens with Part I's opening material, as is, in the new key, or **inverted**
  (very common in Bach); Part II's final cadence mirrors Part I's, transposed home (§122).
- R7 `ALLOWED` Minor-key pieces may end on a major tonic chord (Picardy third, cadencia picarda) (§122).
- R8 `PREFER` Part II is often equal to or longer than Part I (inferred from examples: 8+8, 12+16, 16+24).

## Planning templates
Rounded binary / binary Lied (16 bars):
| section | bars | key | material | ends with |
|---|---|---|---|---|
| a | 1–4 | I | theme | HC |
| a' | 5–8 | I (or →V) | theme varied | PAC (in I or V) |
| b | 9–12 | V / vi | contrast or a in another key | HC / V7 of I |
| a'' | 13–16 | I | last period of a | PAC (stronger) |

Suite binary (dance), repeated halves:
| section | bars | key | material | ends with |
|---|---|---|---|---|
| ‖: I | 8–16 | I → V (minor: i → III or v) | head motif, sequences | PAC in V/III :‖ |
| ‖: II | 8–24 | V → ii/vi/IV → I | head (often inverted), sequences | PAC in I, mirrors end of I :‖ |

## Apply in MIDI / REAPER
- Write repeats out in MIDI (the builder has no repeat signs): duplicate the item for the second time and
  ornament it lightly (passing notes, mordents, octave doubling) — baroque convention.
- Regions: `I 1-8`, `I rep 9-16`, `II 17-28`, `II rep 29-40`.
- Inverted head for Part II: mirror the first 1–2 bars around the first note, snap to scale.
- First/second endings: if Part I ends in V and repeats, the 1st ending may add V7 of I to lead back.

## Checklist
- Does part 2 differ from part 1 (not an exact repeat)?
- Does part 1 end in the right key (V / III / v), and part 2 close in I with a cadence at least as strong?
- In a rounded binary, is the return partial (one period) rather than the whole A?
- In a suite binary, does Part II start with the head motif and end with a transposed version of Part I's cadence?

## Examples
- Schumann *Album* No.5: A to bar 8, B to bar 12, return of A's 2nd period to bar 16 (§45).
- Bach French Suite 1 Courante (d, 3/2): Part I ends in A (dominant); Part II starts in A, ends on D major
  chord (Picardy) (§122).
