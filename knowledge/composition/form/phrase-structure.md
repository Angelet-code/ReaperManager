---
id: form.phrase-structure
title: Phrase structure and bar counting
aliases: [frase, período, periodo, subperíodo, miembro, semifrase, motivo, ictus, compás real, anacrusa, tético, anacrúsico, acéfalo, final masculino, final femenino, Periode, Satz]
domain: form
tags: [phrase, period, motif, anacrusis, meter, bar-counting]
style_scope: common-practice
use_when: Before writing any melody or section, to size it in bars, decide pickups and endings, and label its internal units.
summary: A phrase is a complete melodic cycle built from periods, subperiods and members (classical default 8 real bars = 2 periods of 4 = 4 subperiods of 2); count bars from initial to final ictus in REAL bars, ignore the opening pickup, and choose thetic/anacrustic starts and masculine/feminine endings on purpose.
sources: ["zamacois-formas p.6-15 (§9-18)", "zamacois-formas p.29-34 (§32-33)"]
related: ["[[suspensive-conclusive-endings]]", "[[phrase-asymmetry]]", "[[thematic-development]]", "[[key-plans-small-forms]]", "[[cadences]]"]
---

# Phrase structure and bar counting

## Core idea
Zamacois's hierarchy, largest to smallest: **phrase → period → subperiod → member**. The square
classical phrase is 8 real bars = 2 periods × 4 bars; each period = 2 subperiods × 2 bars; each member
≈ 1 bar. Many other books call his "period" a *phrase/semifrase* and vice versa (English: 8-bar
*period* = antecedent + consequent *phrases*). Names don't matter; **where units start and end does**.

| Zamacois (ES) | Common English | Default length | Typical ending |
|---|---|---|---|
| frase | period / sentence | 8 bars | conclusive (PAC) |
| período | phrase (antecedent / consequent) | 4 bars | HC or PAC |
| subperíodo | sub-phrase / basic idea | 2 bars | open |
| miembro | motive-group / member | 1 bar | — |
| motivo | motif (head of the theme) | 1–2 beats | — |

## Rules
- R1 `MUST` Count bars in **real bars**, not written ones (§15). Slow 4/4 often = two real 2/4 bars; fast
  3/4 or 3/8 (waltz, scherzo) usually = half a real bar, so a "4-bar period" is 8 written bars. Find the
  real bar from cadences, bass attacks and harmonic rhythm.
- R2 `MUST` A unit runs from its **initial ictus** (strong beat where it really starts) to its **final
  ictus**; the bar holding the final ictus counts as full (§14, §17).
- R3 `MUST` Bar 1 of a piece is the bar of the first downbeat; an opening pickup is not counted (§17).
- R4 `MUST` Pickups (anacrusis) borrow time from the **previous** unit's last bar; feminine endings
  never spill into the next unit's bar (§17). A 2-bar subperiod stays "2 bars" even if it holds 2½ bars
  of notes.
- R5 `PREFER` Choose the start type on purpose (§16): **thetic** (on the downbeat: firm, square),
  **anacrustic** (pickup: forward drive, most singable), **acephalous** (starts just after the
  downbeat on a rest: nervous, syncopated).
- R6 `PREFER` Choose the end type on purpose (§16): **masculine** (last note on the strong beat: firm,
  final) or **feminine** (last strong-beat note is an appoggiatura or suspension resolving on the weak
  beat: soft, lyrical, typical of minuets, sarabandes, mazurkas).
- R7 `PREFER` Plan member rhythms with letters (§18): within a 4-bar period pick `abab` or `abac` for the
  best unity/variety balance; `aaaa` risks monotony, `abcd` incoherence. Changing only the ending
  (masculine↔feminine) does not create a new letter.
- R8 `MUST` A 2-period phrase is **A-A** (parallel) if period 2 restarts with period 1's rhythm, **A-B**
  (contrasting) otherwise (§18).
- R9 `PREFER` Place chord changes on strong beats; a chord may be held from strong into weak beat, not
  attacked on a weak beat and held over the next strong one (§15 fn).
- R10 `ALLOWED` Longer phrases: 3 periods (A-A-B, A-B-A…), 4 periods (normally 2+2 groups), 5–6 periods
  (4 + a coda period, or 2+2+2). Phrases of 4+ periods always group into 2 or 3 halves (§22, §31–33).

## Apply in MIDI / REAPER
- Builder time: `beat` = quarter notes from item start. In 4/4 a 2-bar subperiod = 8 beats; in 3/4 =
  6 beats; in 6/8 = 6 beats (two dotted-quarter pulses per bar = 3 qn per bar).
- **Pickup at the piece start:** the builder has no negative beats. Reserve REAPER bar 1 as the pickup
  bar (notes at its end, e.g. 4/4 one-beat pickup at beat 3.0), so **form bar 1 = REAPER bar 2**. Or
  set a partial first measure in REAPER's tempo map.
- Section starts: `start_bar(n) = 1 + Σ bars of previous sections` (+1 if you reserved a pickup bar).
- Duration: `seconds = bars × quarter_notes_per_bar × 60 / BPM` (4/4 at 120 BPM: 8 bars = 16 s).
- Masculine ending: last melody note at the bar's beat 0 with long `len`, velocity ~ +5 over context.
  Feminine: dissonant note at beat 0 (vel 85–95), resolution at beat 1 (3/4) or 2 (4/4), vel −15.
- Waltz/scherzo: plan in 2-written-bar real units; hypermeter accents every 2 or 4 written bars.

## Checklist
- Is every unit's length counted ictus-to-ictus in real bars?
- Is the opening pickup outside bar 1, and does each later pickup sit inside the previous unit's bar?
- Does the theme have a distinctive head (motif) in its first beat-group?
- Is the member-rhythm plan one of abab / abac (or a deliberate alternative)?
- Do period endings alternate open (HC) and closed (PAC)? See [[suspensive-conclusive-endings]].

## Examples
- 8-bar F major 4/4 theme: bars 1–2 basic idea (a), 3–4 contrasting member (b) ending on C chord (HC);
  bars 5–6 = bars 1–2 (a), 7–8 new cadential member (c) ending on F (PAC) → periods A-A, plan abac.
- Strauss *Blue Danube*: written 3/4, real bar = 6/4 and the first written bar is a pickup (§15).
