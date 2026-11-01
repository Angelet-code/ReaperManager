---
id: form.suspensive-conclusive-endings
title: Suspensive vs conclusive endings
aliases: [fórmula suspensiva, fórmula conclusiva, final suspensivo, final conclusivo, interrogativa, afirmativa, inconcreta, semicadencia, antecedente consecuente, Halbschluss, Ganzschluss]
domain: form
tags: [cadence, period, phrase-ending, open-closed]
style_scope: common-practice
use_when: When deciding how a period, phrase or section should end (open or closed) and how to combine open and closed periods into a phrase.
summary: A unit ends suspensive (open - melody off the tonic triad, half cadence, or ending in another key) or conclusive (closed - melody on the home tonic, strong beat, root-position V–I in the main key); the last period decides the phrase, and the second of two closed units must sound more final than the first.
sources: ["zamacois-formas p.15-17 (§19-20)", "zamacois-formas p.19-22 (§23-24)", "zamacois-formas p.26-34 (§30-33)", "zamacois-formas p.42-48 (§42)"]
related: ["[[phrase-structure]]", "[[cadences]]", "[[key-plans-small-forms]]", "[[section-functions]]", "[[form-for-modern-songs]]"]
---

# Suspensive vs conclusive endings

## Core idea
Every unit ends either **suspensive** ("question", open door, motor running: the listener expects
continuation) or **conclusive** ("answer", closed door, motor stopped). Melody and harmony each carry a
character; harmony has the final word. Only the **home-key tonic** closes: a perfect cadence in another
key is still open because the return is missing.

## Rules
- R1 `MUST` Melodic test (§19): suspensive = last note **not** in the tonic triad (degrees 2, 4, 6, 7);
  conclusive = last note on **degree 1** of the main key, masculine, on a strong beat; indeterminate =
  degree 3 or 5, or 1 with a feminine ending (reads open next to a strong close, closed next to an open one).
- R2 `MUST` Harmony overrides melody (§20): the same melodically closed period becomes fully conclusive
  with root-position V–I (bass 5→1), weaker with inverted chords, and suspensive if the bass does not land
  on root-position I. See [[cadences]].
- R3 `MUST` A phrase ending in a key other than the main one is **never** conclusive (§24), even with
  V–I there. (Exception: some folk songs/dances end on V.)
- R4 `MUST` The **last period defines the phrase** (§23): a phrase is conclusive iff its last period is.
- R5 `PREFER` Default 2-period phrase = **suspensive + conclusive** (§30). Period 1 ends on root-position
  V, either as a half cadence or by modulating to the dominant key.
- R6 `AVOID` Two consecutive conclusive units with the same cadence type (§30). If both close, make the
  second **more** conclusive (stronger cadence, melody on 1 an octave higher, longer value).
- R7 `PREFER` Inside a piece, secondary phrases end **suspensive**, typically on V7 of the main key, so
  the principal phrase can return (§42.2). Ending on a foreign tonic makes listeners expect a return;
  ending on a non-tonic chord makes them want to move on.
- R8 `AVOID` Fully conclusive phrases in the middle of a piece unless the next section restarts momentum
  at once (anacrusis, change of mode, faster accompaniment) (§42.1).
- R9 `ALLOWED` Repeat a suspensive period immediately as a conclusive one (very common, §21b); or turn
  a conclusive one suspensive on return to keep the piece moving.

## Combination table (conclusive phrases, Zamacois §30–32)
| periods | common patterns (s = suspensive, c = conclusive) | notes |
|---|---|---|
| 2 | **s-c** (best), c-c only if 2nd stronger | A-A or A-B rhythm |
| 3 | s-s-c, c-s-c, s-c-c (3rd = coda) | c-c-c almost unused |
| 4 | **s-c-s-c** (binary Lied), s-s-s-c, s-s-c-c | if P3 is c, P4 acts as coda |

## Apply in MIDI / REAPER
- Suspensive period end: melody on 2 or 7 (e.g. C major: D5=74 or B4=71) over G chord root position
  (bass G2=43), held 1–2 beats; keep accompaniment moving through the rest so energy carries over.
- Conclusive: melody 7→1 or 2→1 (B4→C5 / D5→C5) on a downbeat over bass G→C (43→36 or 48), final chord
  ≥ 2 beats, a small ritardando only at the very end of a piece.
- Mark each cadence in REAPER with a marker named by type (`HC b4`, `PAC b8`) to audit the open/closed
  rhythm of the whole form.
- Velocity: suspensive arrivals often crest (vel 90–100, CC11 rising); conclusive arrivals settle
  (CC11 easing 10–20 down over the last bar).

## Checklist
- Does each period's last melody note and bass match the intended open/closed character?
- Does every phrase that must close end on root-position I **in the main key**?
- Are no two adjacent conclusive units equally strong?
- Do secondary/contrasting sections end open (V or V7 of home)?

## Examples
- C major 4+4: bars 1–4 end D5 over G (HC); bars 5–8 end C5 over C after G7 (PAC).
- A minor 4+4: bars 1–4 modulate to C (III) and cadence there — still suspensive for the phrase; bars
  5–8 return to A minor, E7–Am PAC.
