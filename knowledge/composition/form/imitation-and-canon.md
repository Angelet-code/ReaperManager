---
id: form.imitation-and-canon
title: Imitation and canon
aliases: [imitación, canon, antecedente, consecuente, dux, comes, propuesta, respuesta, movimiento contrario, inversión, retrógrado, cancrizante, aumentación, disminución, imitación rítmica, canon infinito, Kanon, Imitation]
domain: form
tags: [counterpoint, imitation, canon, texture]
style_scope: universal
use_when: When one voice should echo another (call-and-response, canon, fugal entries, imitative episodes) or when choosing the interval/time distance of an imitation.
summary: Imitation = a later voice (consequent) reproduces a melody stated by another (antecedent) at any interval and time distance — direct, inverted, retrograde, augmented, diminished or rhythm-only; a canon sustains it through a piece. Closer entries are tighter and more interesting; strict imitation keeps exact interval qualities; rhythmic imitation is one of the most fertile development tools.
sources: ["zamacois-formas p.53-57 (§47-52bis)", "zamacois-formas p.117-127 (§95)"]
related: ["[[fugue]]", "[[thematic-development]]", "[[school-fugue-plan]]", "[[sacred-vocal-forms]]"]
---

# Imitation and canon

## Core idea
Imitation is a **writing technique**, not a form (§47). Antecedent (dux, propuesta) → consequent (comes,
respuesta), several consequents numbered 1, 2… (§48). A **canon** is imitation sustained at length,
usually through a whole piece (§52).

## Rules
- R1 `ALLOWED` Any length and any time distance; the **closer** the entry, the tighter and more interesting
  (más cerrada) (§49).
- R2 `ALLOWED` Any interval; unspecified means unison/octave; otherwise name it ("canon at the 5th above")
  (§49).
- R3 `MUST` Strict (textual) imitation preserves interval **qualities** (M2→M2, m6→m6); changing them
  (M2 answered by m2, i.e. staying diatonic) is free/inexact imitation (§49). Diatonic (free) imitation is
  normal in tonal music.
- R4 `ALLOWED` Classes (§50): direct motion; contrary motion (inversion); retrograde (crab, cancrizante);
  retrograde inversion; augmentation; diminution — combinable.
- R5 `PREFER` Direct motion is the most useful; retrograde the least audible (§51).
- R6 `ALLOWED` Imitate only the pitch line (new rhythm) or only the rhythm (rhythmic imitation) (§49);
  rhythmic imitation is among the richest development tools (§51).
- R7 `ALLOWED` Canon types (§52): infinite (loops back) vs finite (free ending); open (all parts written),
  closed (one part + signs), enigmatic (puzzle).
- R8 `PREFER` In episodes, pass designs between voices (imitations) rather than repeating a sequence in one
  voice; exchanged designs must work in invertible counterpoint (§95).

## Planning template (imitative passage / canon)
| element | value to choose | typical |
|---|---|---|
| antecedent length | 1–4 bars | 2 bars |
| entry distance | ½ bar – 2 bars | 1 bar (tight), 2 bars (clear) |
| interval | P8, P5 above, P4 below, unison | P8 or P5 |
| transformation | direct / inverted / aug / dim | direct |
| voices | 2–4 | 2 (+ free bass) |
| ending | free cadence after the last entry | PAC with all voices |

## Apply in MIDI / REAPER
- Consequent = copy of the antecedent item, shifted `+d` beats and transposed `+n` semitones (strict) or by
  scale degrees (diatonic). Inversion: `p' = 2·axis − p`, snap to the scale.
- Check every vertical interval between voices on strong beats: consonant (semitones mod 12 ∈ {0, 3, 4, 7, 8, 9};
  5 = P4 is dissonant against the lowest voice — general knowledge) or a prepared dissonance; adjust the free continuation, not the
  imitation, when possible.
- Put antecedent and consequent on different instruments/tracks with contrasting colour so the echo is
  audible (e.g. violins → violas, flute → clarinet); same register span shifted by the interval.
- Call-and-response in modern arrangements: 1–2 bar riff answered 1–2 beats or a bar later at the octave/5th
  by another instrument; rhythmic imitation of the hook in drums/bass (general knowledge application).

## Checklist
- Is the entry distance short enough to be heard as imitation (≤ 2 bars) and long enough to be clear (≥ ½ bar)?
- Strict or diatonic imitation chosen deliberately?
- Do strong-beat verticals stay consonant or properly treated?
- Does the passage end with a cadence where the imitation is released?

## Examples
- Canon at the octave, 1 bar apart: voice 1 C5–D5–E5–C5 | E5–F5–G5 ; voice 2 enters bar 2 on C4 — the
  "Frère Jacques" principle (general knowledge).
- Schumann *Album* No.27: canon at the octave; the parts swap roles at bar 13 and back by bar 22 (§52).
