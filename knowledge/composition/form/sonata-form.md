---
id: form.sonata-form
title: Sonata form — plan and exposition
aliases: [forma sonata, tipo sonata, allegro de sonata, exposición, tema A, tema B, primer tema, segundo tema, puente, transición, grupo B, codetta, tono asociado, Sonatenhauptsatzform, sonata-allegro]
domain: form
tags: [sonata-form, exposition, bridge, key-plan, first-movement]
style_scope: common-practice
use_when: When planning a first movement, overture, or any large piece with two contrasting key areas, a development and a recapitulation.
summary: Exposition = (intro) A in I → modulating bridge → B group in V (major) or III (minor) with contrasting character → closing in B's key; development = free modulating work ending on a dominant pedal; recapitulation = A in I → bridge rewritten to stay home → B in I → coda. Use the fill-in table below.
sources: ["zamacois-formas p.167-183 (§141-153)", "zamacois-formas p.42-48 (§42)", "sonata-outline"]
related: ["[[sonata-development-and-recap]]", "[[section-functions]]", "[[thematic-development]]", "[[multi-movement-cycle]]", "[[modulation]]", "[[cadences]]", "[[secondary-dominants]]"]
---

# Sonata form — plan and exposition

## Core idea
A ternary form with **two key areas**: Exposition (tension: home vs. new key) – Development (instability)
– Recapitulation (resolution: everything in the home key). The user's outline and Zamacois agree on the
skeleton; Zamacois adds the B group (b' b'' b'''), bridge options and Beethoven's key licences.
Development and recapitulation details: [[sonata-development-and-recap]].

## Rules — exposition
- R1 `MUST` Theme A starts in the home key (both sources); it may end open (HC, often followed by a rest)
  or closed (PAC elided into the bridge) (§146).
- R2 `PREFER` A vs B contrast: A vigorous, concise, rhythmic; B lyrical, smoother ("opposite character" in
  the outline). Not absolute: early sonatas often have B ≈ A transposed (§144).
- R3 `PREFER` Use a bridge (direct A→B almost never). Material: own elements, A continuing, a preview of B,
  or a mix (§147).
- R4 `MUST` The bridge is the **modulating** part; A and B stabilise their keys. It ends on **V of B's key**
  (most common, often with a caesura) or on B's tonic (§147).
- R5 `NEVER` Theme B in the home key in the exposition (§148).
- R6 `MUST` B's key: major movement → **V**; minor movement → **III** (relative major) (both sources;
  pre-Beethoven norm, §148).
- R7 `ALLOWED` Beethoven: other keys whose tonic triad shares a note with the home tonic, never IV
  (op.31/1 G→B; op.106 Bb→G; op.111 c→Ab; op.31/2 d→a) (§148).
- R8 `PREFER` B is a **group**: b' (principal), b'' (complementary), b''' (closing) — all in one key, mode
  may vary (op.2/3: g–G–G) (§148–149).
- R9 `ALLOWED` Exposition coda/codetta: from earlier material or own; usually ends with PAC in B's key
  (outline: "ends in B's key"); may instead turn to V7 of home (for the repeat) or of the development key (§149).
- R10 `ALLOWED` Exposition repeat ‖: :‖ was the norm through Beethoven op.57; optional later (§149).
- R11 `ALLOWED` Slow introduction (optional): a few bars to a small slow movement; may feed later themes (§146).

## Planning template (fill in)
Proportions (general knowledge, classical first movements): exposition 35–40 %, development 20–30 %,
recap 30–35 %, coda 0–15 %. Zamacois's landmark example, op.2/1 (f, 152 bars): bridge b.9, B b.21,
development b.49, recap b.101 (§42).

| section | bars (≈160-bar mvt) | key major (minor) | material | ends with |
|---|---|---|---|---|
| Intro (opt.) | 0–16 | I or V (i) | slow, motif seed | HC / V7 |
| A | 8–16 | I (i) | theme A, rhythmic | HC or PAC (elided) |
| Bridge | 8–16 | I → V (i → III) | A fragments / own | **V of new key** (+ caesura) |
| B b' | 8–16 | V (III) | lyrical theme | IAC/HC or PAC |
| B b'' | 8–12 | V (III, mode may vary) | complementary | PAC in V |
| Closing b'''/codetta | 4–12 | V (III) | cadential, A/bridge rhythm | PAC in V; or V7 of I for repeat |
| Development | 30–50 | away (vi, ii, IV, iii; minor: iv, VI, v) | fragments, sequences | **V pedal** of I (4–8 bars) |
| Recap A | 8–16 | I | A (maybe varied) | HC or elided |
| Bridge' | 6–16 | stays I (or dips to IV) | rewritten bridge | V of I |
| B' (b' b'' b''') | 24–36 | I (minor: i or I) | B group | PAC in I |
| Coda | 0–25 | I (touch IV/ii) | A head, cadences | PAC, tonic pedal |

## Apply in MIDI / REAPER
- Duration check: at ♩=132 in 4/4 one bar = 1.82 s; 160 bars ≈ 4 min 51 s (without exposition repeat).
  At ♩=144 in 2/2 (= 4 qn/bar), one bar = 1.67 s.
- Regions: `Intro`, `A I`, `TR I→V`, `B1 V`, `B2 V`, `Cod V`, `Dev`, `RT V-ped`, `A' I`, `TR' I`, `B' I`, `Coda I`.
  Add markers at the medial caesura (end of bridge) and at the double bar.
- Medial caesura (general knowledge term; Zamacois notes rests/fermatas at these joins, op.2/1): end the bridge on V/V (C major: D major chord, D3–F#3–A3 = 50–54–57) held, then 1–2
  beats of rest in all tracks before b'.
- A and B orchestration contrast: A tutti/forte (vel 95–115), B reduced texture, legato, vel 60–80.

## Checklist
- Key(A expo) = home; key(B expo) ≠ home (V or III, or a licensed common-tone key, never IV)?
- Does the bridge actually modulate and end on V of B's key?
- Is B a group with a clear closing cadence in its key?
- See [[sonata-development-and-recap]] for the second half checks.

## Examples
- C major plan: A C (12) → bridge 14 bars C→G, ends on D7/G → b' G (14) → b'' G (10) → codetta G (8) ‖ dev
  a, d, F, ends on G pedal (40) ‖ A C (12) → bridge stays C, ends on G (12) → B C (32) → coda C (12).
- Op.2/3 bridge: 14 bars, two elements; b.13 starts on C tonic, b.26 lands on G tonic (§147).
