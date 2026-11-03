---
id: form.phrase-asymmetry
title: Square phrases and deliberate asymmetry
aliases: [frase cuadrada, frase simétrica, frase asimétrica, frase coja, elisión, doble función, contracción, dilatación, eco, apéndice, amplificación, extensión de frase, phrase extension, elision]
domain: form
tags: [phrase-rhythm, hypermeter, elision, extension, contraction]
style_scope: common-practice
use_when: When a section must be other than 4/8/16 bars, when two phrases should overlap, or when checking that dance/groove material stays square.
summary: Keep dance and groove music square (2+2, 4+4, 8+8); elsewhere break monotony on purpose with elision (shared bar, −1), contraction (−1), dilatation, echo, appendices or amplification (+n, typically a deceptive cadence or detour before the final cadence) — never an unmotivated missing or extra bar.
sources: ["zamacois-formas p.34-42 (§34-41)", "zamacois-formas p.22-24 (§28)"]
related: ["[[phrase-structure]]", "[[suspensive-conclusive-endings]]", "[[section-functions]]", "[[cadences]]", "[[form-for-modern-songs]]"]
---

# Square phrases and deliberate asymmetry

## Core idea
A **symmetric** phrase has equal-length periods; a **square** phrase (frase cuadrada) is binary at every
level (2+2 → 4+4 → 8+8). Almost all dances are square. Asymmetry is good when it is **audibly caused**
by a technique; a bar missing or extra for no reason gives a "limping" phrase (frase coja).

## Rules
- R1 `NEVER` Limping phrases: an unexplained extra or missing bar. Worst in dance music, where steps must
  match (§35).
- R2 `PREFER` Square phrasing for dances, marches, grooves and anything choreographed (§34bis).
- R3 `PREFER` Elsewhere, vary bar counts with one of these techniques (§35); always count **real** bars:

| technique (ES) | effect on bar count | how |
|---|---|---|
| elisión / doble función (§36) | −1 | the final bar of unit 1 is also bar 1 of unit 2 (cadence chord = new downbeat). Very frequent. |
| contracción (§37) | −1 (or more) | shorten note values so two bars fuse into one; may shift accents |
| dilatación (§38) | +1…+n | lengthen values (augmentation, broadening) — gives rotundity at section ends |
| eco (§39) | +n only if it adds bars | immediate repeat of a note group, other octave/dynamic |
| apéndice (§40) | +n | extra fragment prolonging the tonal function reached: **dominant appendix** (makes the tonic more wanted) or **tonic appendix** (affirms it = coda) |
| amplificación (§41) | +n | enlarge with sequences, repetitions or a modulating detour, mainly when a phrase returns |
| soldadura (§28) | 0 | filler notes (run, fill) in the gap between units, no bar added |

- R4 `PREFER` Before a return (reexposition), prolong the dominant 2–4 bars (dominant appendix), unless a
  surprise "sudden return" is intended (§40).
- R5 `PREFER` On the return of a phrase, extend it 2 bars via a deceptive cadence (V–vi) or a detour
  through ii/IV before the final PAC (§41, Sonata op.26 bar 23: a deceptive modulating cadence adds 2 bars).
- R6 `ALLOWED` Appendices that form whole periods of the same length as the others do not create
  asymmetry (§40).
- R7 `PREFER` Use dilatation at the very end of an exposition or piece for weight (§38).

## Apply in MIDI / REAPER
- **Elision**: write the cadence chord of unit 1 and the first downbeat of unit 2 as the same event (one
  bar, one chord); in a region plan, unit 2's region starts on unit 1's last bar (regions overlap 1 bar).
- **Deceptive extension**: replace the expected I at bar 8 with vi (C major: Am, bass A2=45), add 2 bars
  ii6–V7–I (bars 9–10). Phrase becomes 10 bars.
- **Dominant appendix**: hold V (or V pedal in the bass, G1/G2 = 31/43 in C) 2–4 bars, crescendo CC1/CC11
  +20–30 across it, then the return on the downbeat.
- **Soldadura**: in the last beat before the next section put a 4–8 note pickup run (16ths) or a drum fill
  instead of silence; the next section still starts on its downbeat.
- **Echo**: repeat the last 2 beats an octave up/down at vel −20.

## Checklist
- Is every irregular bar count explained by one named technique?
- Are dance/groove sections square (multiples of 4 real bars)?
- Is there a dominant appendix (or a deliberate sudden entry) before each return?
- If a returning phrase is extended, does the extension delay the final PAC rather than adding filler after it?

## Examples
- 8-bar phrase + elided 8-bar phrase = 15 bars total (bar 8 = bar 1 of phrase 2).
- Sonata 2 op.2/2 II: dominant reached bar 64, held to bar 67, principal phrase returns bar 68 (§40).
- Return extended: A (4, open) – B (4, open) – A' (6, closed) via touches of ii and IV (§41).
