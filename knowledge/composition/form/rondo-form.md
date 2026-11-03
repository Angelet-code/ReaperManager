---
id: form.rondo-form
title: Rondo and rondo-sonata
aliases: [rondó, rondeau, rondo, estribillo, copla, couplet, rondó-sonata, rondo desarrollado, ABACA, ABACABA, Rondoform, Sonatenrondo]
domain: form
tags: [rondo, refrain, finale, rondo-sonata]
style_scope: common-practice
use_when: When writing a lively finale or any piece built on a recurring refrain alternating with contrasting episodes.
summary: A rondo alternates a strongly characterised refrain, always back in the tonic, with episodes (couplets) in other keys that end so each return gets maximum relief; the rondo-sonata (A B A C A B A + coda) re-exposes the first couplet in the tonic like a sonata's second theme and treats the middle couplet as a development.
sources: ["zamacois-formas p.155-165 (§127)", "zamacois-formas p.196-199 (§161-162)", "zamacois-formas p.200-205 (§163)", "zamacois-formas p.48-52 (§46bis)"]
related: ["[[ternary-form]]", "[[sonata-form]]", "[[section-functions]]", "[[multi-movement-cycle]]", "[[form-for-modern-songs]]", "[[modulation]]"]
---

# Rondo and rondo-sonata

## Core idea
**Refrain (estribillo, A)** alternates with **couplets/episodes (coplas, B, C…)**. Origin: song with
changing verses and a repeated refrain (§223). Three sizes: baroque **rondeau** (equal 16-bar blocks),
**simple rondo** A B A C A, **rondo-sonata** A B A C A B A.

## Rules
- R1 `MUST` The refrain returns in the **same key (tonic)** each time; couplets go to other keys chosen so
  the junctions are smooth (§127).
- R2 `PREFER` Refrain = cheerful, playful, strongly characterised; couplets less important, shaped to
  give each refrain return maximum relief (§127).
- R3 `PREFER` Ornament or vary later refrain returns (Bach Partita 2 Rondeau: refrains 3 and 4 newly
  ornamented) (§127).
- R4 `ALLOWED` Shorten later refrains (e.g. only their first 8 bars) or lengthen them; one refrain in
  another key (e.g. subdominant) is possible (§161 fn).
- R5 `PREFER` End couplets on a suspensive gesture leading to V7 of home (e.g. a descending scale onto
  V7) and invert that gesture into an affirmative one in the coda (§161, op.13 finale).
- R6 `MUST` Rondo-sonata default (§161): A (I) – B (bridge optional; B in V or III, **not** I, may have
  several elements) – A (I) – C (new element in a new neighbouring key **or** a development) – A (I) –
  B re-exposed **in the tonic** – A (I) or development of its head – coda.
- R7 `PREFER` With more than three couplets, the re-expositive (tonic) couplet is usually the **last** one
  (§161 fn).
- R8 `ALLOWED` Post-classical: freer keys for middle refrains/couplets (§163).
- R9 `PREFER` As a sonata finale, the rondo is the default (Beethoven: 19 of 32 sonata finales) (§162).

## Planning template (rondo-sonata finale)
| section | bars | key (major / minor) | material | ends with |
|---|---|---|---|---|
| A1 | 16–20 | I / i | refrain | PAC in I |
| TR | 4–8 | I → V / i → III | bridge | V of new key |
| B | 16–36 | V / III | b', b'' (b''') | V7 of I |
| A2 | 8–18 | I / i | refrain (whole or first 8) | PAC (or elided) |
| C | 20–30 | IV, vi / VI, iv — or development | new element / development | V(7) of I, retransition |
| A3 | 8 | I / i | refrain first 8 bars | elided into TR |
| TR' | 4–8 | I | bridge, non-modulating | V of I |
| B' | 16–30 | I (minor: I or i) | B in tonic | V7 or PAC |
| A4 | 8 | I | refrain head | — |
| Coda | 8–25 | I | refrain cell, B fragment, scale gesture inverted | PAC |

Simple rondo: A(8–16) B(8–16, V) A C(8–16, vi/IV or parallel minor) A + coda. Baroque rondeau: equal
16-bar blocks, couplets in neighbouring keys (Bach Partita 2: refrain b.1, 33, 65, 97; couplets 17, 49, 81).

## Apply in MIDI / REAPER
- Build A once as a MIDI item; reuse copies for A2–A4 (ornament the copies, or trim to 8 bars).
- Regions `A1 I`, `B V`, `A2 I`, `C vi`, …; colour all refrains identically so the alternation is visible.
- Junction couplet→refrain: last 2–4 bars on V7 (C: G7 = 43–47–50–53), a scale run (soldadura) into the
  refrain downbeat.
- Keep tempo constant; contrast couplets by texture, mode, register.

## Checklist
- Is every refrain in the tonic and recognisable from its first bar?
- Does every couplet end on V/V7 of home (or elide smoothly into the refrain)?
- Rondo-sonata: is B first in V/III, later in I? Is C in a new key or developmental?
- Are later refrains shortened or varied so the form does not drag?

## Examples
- Beethoven op.13 III (c): A to b.17; bridge 18; B in Eb (b.25, 37, 43) → V7 of c; A exact (61–78);
  C in Ab (79) → V of c; A first 8 bars (120–128); new bridge; B in C major (134); A 8 bars; coda (178) (§161).
