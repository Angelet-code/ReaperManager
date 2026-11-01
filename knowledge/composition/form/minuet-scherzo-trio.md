---
id: form.minuet-scherzo-trio
title: Minuet, scherzo and trio
aliases: [minué, minueto, minué de sonata, scherzo, trío, da capo, D.C., maggiore, minore, scherzo con dos tríos, Menuett, Scherzo und Trio]
domain: form
tags: [minuet, scherzo, trio, da-capo, ternary, dance]
style_scope: classical-romantic
use_when: When writing the third movement of a sonata/symphony, any dance + trio piece, or a scherzo.
summary: Compound ternary - Minuet (repeated a I→V, then repeated b + a' closing in I) – Trio (same shape in IV, the parallel mode or the relative; contrasting, may end on V7) – Minuet da capo without repeats. The scherzo keeps the plan but is fast (one beat per bar), longer, more contrapuntal, with a broad cantabile trio; romantics add a second trio (S T1 S T2 S).
sources: ["zamacois-formas p.190-197 (§157bis-160)", "zamacois-formas p.200-205 (§164)", "zamacois-formas p.155-165 (§121, §133)", "zamacois-formas p.269-275 (App. G)"]
related: ["[[ternary-form]]", "[[binary-form]]", "[[dance-types]]", "[[multi-movement-cycle]]", "[[key-plans-small-forms]]"]
---

# Minuet, scherzo and trio

## Core idea
The sonata minuet is ternary at two levels: **Minuet – Trio – Minuet (da capo)**, and each of those is
itself a small rounded form with repeats. The suite minuet, by contrast, is binary (see [[binary-form]]).
Beethoven's **scherzo** keeps the form and drops the dance character.

## Rules
- R1 `MUST` Minuet section: ‖: principal phrase :‖: episode (derived or new) → reexposition (whole or part)
  of the principal phrase **ending in the tonic** (+ optional codetta) :‖ (§158).
- R2 `PREFER` The principal phrase ends almost always in **V** (relative major or v if minor), occasionally in I (§158).
- R3 `ALLOWED` Condense the reexposition (two phrases → one closed period); write repeats out when details change (§158 fn).
- R4 `MUST` Trio key: same tonic (mode changed or not) or a key whose tonic triad shares a note with the
  home tonic — **subdominant preferred** among these (§158).
- R5 `PREFER` Trio contrasts in theme (lighter texture, legato, often wind-led or a drone "musette"); it may end
  conclusive or suspensive on V7 to lead into the da capo (§158).
- R6 `MUST` Third section = Minuet again **without repeats** ("Menuetto D.C."); general coda optional (§158).
- R7 `ALLOWED` Binary (uncommon) or one-part sections; rondo-minuet (op.49/2) (§158).
- R8 `PREFER` Scherzo: fast triple meter (3/4, 3/8) felt one-in-a-bar, playful, freer and longer lines,
  often contrapuntal; its Trio usually a **broad, dominating melody** (§158bis–159).
- R9 `ALLOWED` A piece titled Scherzo can be rondo or sonata form, and minuet form can appear untitled (§160).
- R10 `MUST` Two-trio scherzo (Schumann): S – T1 – S – T2 – S (+ coda); T2 freer, even in meter/tempo; last S may
  be developed. Beethoven variant: S T S T S with identical trios (§164).
- R11 `ALLOWED` Big scherzi may alternate hypermeters of 4 and 3 bars (Beethoven 9: "ritmo di quattro/tre battute") (App. G).
- R12 `PREFER` Minuet phrasing: one-beat upbeat common, melody in 2-bar groups with feminine endings on beat 2 (§133).

## Planning template
| section | bars | key (major / minor) | material | ends with |
|---|---|---|---|---|
| Minuet ‖: a :‖ | 8 (scherzo 16) | I → V / i → III | principal | PAC in V/III |
| ‖: b | 4–8 (scherzo 8–30) | V / III, V pedal | episode, derived | V7 of I |
| a' :‖ | 8 (±codetta 2–4) | I | principal, end rewritten | PAC I |
| Trio ‖: c :‖ | 8 (scherzo 16) | IV, parallel or vi | contrasting tune | PAC in its V or I |
| ‖: d c' :‖ | 12–16 | trio key | episode + return | PAC, or V7 of I |
| Minuet D.C. | = minuet, no repeats | I | written copy | PAC I |
| Coda (opt.) | 4–16 | I | minuet head | PAC |

## Apply in MIDI / REAPER
- Minuet: 3/4, ♩ ≈ 120–144 (general knowledge; Haydn/Mozart sonata minuets), bass on beat 1, chords on 2–3
  or 8th-note melody over quarter-note bass. Velocity beat 1 ~90, beats 2–3 ~70.
- Scherzo: 3/4 dotted-half ≈ 80–110 (general knowledge); plan phrases in 4-bar hypermeasures; accent bar 1 of
  each hypermeasure (vel +10).
- Write repeats and the da capo out as duplicated MIDI items; drop the repeats in the D.C. copy.
- Regions `Minuet`, `Trio`, `Minuet DC`, `Coda`; Trio region name includes key (`Trio IV`).

## Checklist
- Does the minuet's first phrase end in V (or III/v in minor) and its second part close in I?
- Is the trio in an allowed key (same tonic, IV, relative/common-tone key) and audibly contrasting?
- Is the da capo present and without repeats?
- Scherzo: fast, one-in-a-bar, broad trio melody?

## Examples
- Beethoven op.2/1 Minuet (f): ‖: f → Ab :‖: episode → C (V) – return in left hand, ends f :‖; Trio F major,
  same shape; D.C. (§158).
- Beethoven op.2/3 Scherzo (C): 16-bar theme cadencing in G; Trio in a minor (theme in the bass), its
  written-out repeat ends on V7 of C; D.C. with extended coda (§158).
