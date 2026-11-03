---
id: orchestration.woodwind-section-writing-with-strings
title: Woodwinds with strings (accompaniment, alternation, antiphony, doubling strings)
aliases: [madera y cuerda, combinación madera/cuerda, maderas con cuerdas, contraste de color, alternancia madera cuerda, escritura antifonal, antifonía, pregunta y respuesta, eco, duplicación discreta, acompañamiento a contratiempo, fondo armónico, transición de maderas a cuerdas, duplicar las cuerdas con maderas]
domain: orchestration
tags: [woodwinds, strings, accompaniment, antiphony, alternation, doubling, transitions]
style_scope: universal (Classical to 20th c.; unison-doubling habits era-tagged)
use_when: Combining woodwinds with strings: winds accompanying a string tune, passing a figure between the sections, call-and-response, moving from a wind passage to strings, or deciding how winds double string lines in soft passages and tutti.
summary: Winds accompany a string tune with off-beat dyads or a passed-around arpeggio; alternate short phrases between sections, rotate a motive across ≥3 timbres at different octaves, then merge both sections at the cadence and alter the third repetition. Double strings at the octave by default (unison for colour or tutti weight), one wind per octave at p and a2 at f, reinforce only weak string voices discreetly, and remove doublers to make a diminuendo.
sources: ["adler-orq-es p.234-238", "adler-orq-es p.255-260", "adler-orq-es p.270-282", "piston-orch p.426-427", "piston-orch p.431-443"]
related: ["[[woodwind-section-writing]]", "[[woodwind-section-writing-chords]]", "[[doubling-colour-and-decay]]", "[[doubling-colour-and-decay-section-pairings]]", "[[string-section-writing]]", "[[string-section-writing-accompaniment]]", "[[texture-accompanied-melody]]", "[[dynamics-by-orchestration]]", "[[building-and-releasing-climaxes]]"]
---

# Woodwinds with strings

## Core idea
Strings are the continuous base; winds join for one function at a time (see [[woodwind-section-writing]]).
Against strings the woodwinds give a **different colour**: they accompany, answer, alternate, or double a
string line at the octave or in unison.

## Rules
**Winds accompanying strings**
- R1 `PREFER` quiet second-theme layout (Schubert 8/I): melody in Vc (later Vln in 3rds/6ths), off-beat
  slurred eighth dyads in Cl doubled by Vla (later Cl + Bsn), pizz bass on beat 1 only, all pp: melody,
  filler and bass each own a rhythmic slot.
- R2 `PREFER` with a melody in a string section, pass an arpeggio figure around the winds (Bsn → Bcl → Cl →
  Fl) rather than giving it to one soloist; `ALLOWED` a Bcl bass partly doubled by EH and Bsn under a string
  tune, Cl off-beat chords and Fl harmonic fill (Piston).
- R3 `PREFER` a syncopated accompaniment from chord tones with its own melodic curve (Cl 1-2 + divided Vln
  II), horns added at the cadence.
- R4 `NEVER` let the accompaniment cover the melody; build figuration from the instruments' technique, not
  from piano writing (Piston).

**Alternation and antiphony**
- R5 `PREFER` alternate short phrases between winds and strings, each section's chord dissolving into the
  other's (Brahms 2/III).
- R6 `PREFER` after passing a figure back and forth, give it to both sections together for fullness or
  resolution (Schumann 1/III, with timpani roll).
- R7 `PREFER` when another section takes over a final chord, keep the top octave the previous section set.
- R8 `PREFER` antiphony: rotate a motive deliberately across ≥3 timbres at different pitch levels (Ob → Cl
  → Fl → Vln 1), over a soft, constant string accompaniment, then recombine everyone in a tutti cadence
  (Beethoven *Eroica* I).
- R9 `PREFER` after a ff tutti, instant contrast with single solo winds p dolce over a soft string figure.
- R10 `PREFER` alter an idea or its scoring the **third** time; the altered repetition links to the next
  section (Adler's general habit of great composers).
- R11 `ALLOWED` `[era: Classical natural brass]` in the tutti recap, winds and strings in octaves/unison,
  horns and trumpets only on dominant–tonic.

**Transitions**
- R12 `PREFER` from a wind passage to strings: solo strings double wind lines at the octave first (solo Vla
  with Ob, solo Vc with Bsn), then the full strings enter (Schumann 2/IV).
- R13 `PREFER` keep cellos and basses out of a wind chorale if a string section follows, so it sounds new.

**Winds doubling strings**
- R14 `PREFER` winds double strings mainly in tutti, and today at the octave: unison thickens the sound and
  blurs both instruments' upper partials (Adler). `ALLOWED` unison for warmth (Fl + Vln 1 soli pp, Berlioz).
- R15 `MUST` count the dynamic (Piston): at p one wind an octave above/below a string part is enough; at f
  the wind line must be doubled (a2) or it won't balance. One wind on a string part mainly strengthens the
  string tone; two make the wind colour audible.
- R16 `PREFER` a single bassoon an octave below a Vln 1 melody for warmth (Brahms 1/II).
- R17 `MUST` reinforce a string voice in a weak low register (e.g. Vln II below the violas) with a soft wind
  of the same register (Copland: Cl 2 + muted horn) — **discreet doubling**.
- R18 `PREFER` make a diminuendo by removing doublers, and replace a too-prominent colour (low oboe) with a
  softer one (low Fl 2). `ALLOWED` a doubler leaving the unison for 3rds to stress a chord tone.
- R19 `MUST` in a dark-to-bright rise, keep the brass low enough for strings and woods to stay on top;
  `AVOID` piccolo before the climax (Tchaikovsky 6/I).

## Period practice
- `[era: 18th–19th c.]` winds doubling strings in unison was the norm; `[era: 1955, Piston]` every
  string–wind unison works where ranges meet. Default for this vault: octave for clarity, unison chosen for
  colour or tutti weight ([[doubling-colour-and-decay-section-pairings]]).
- `[era: 18th-c. theatre]` bassoons double the cello/bass line (small bass sections); still valid as colour.

## Apply in MIDI / REAPER
- **Off-beat dyads (R1):** `CL 1-2` and `VLA` on the off-beat eighths (beat 0.5, 1.5, 2.5 in 3/4,
  after an eighth rest, slurred), len 0.4, velocity 35–45 or CC1 25–35; `CB` pizz on beat 0 only; melody CC1 ~10 above the filler.
- **Antiphony (R8):** motive 1–2 bars per track, `OB` → `CL` −12 → `FL` +12 → `VLN 1`; strings CC1 25–35
  steady underneath; tutti cadence CC1/velocity +20; on the 3rd pass change the pitch level or pairing.
- **Hand-over (R5):** overlap the sections by ~1 beat, outgoing CC11 falling to ~20 while the incoming
  rises.
- **Tutti mapping (Dvořák):** `FL`+`PICC` = Vln 1 +12; `OB`+`CL` = Vla line; `BSN` = Vc +12 and unison.
- **Diminuendo:** end doubler notes one by one rather than lowering every track.
- Low oboe (≈ 58–64, inferred) doubling a soft line → move to `FL 2`.

## Checklist
- [ ] Melody, filler and bass in separate rhythmic slots.
- [ ] Motive passed across ≥ 3 colours, merged at the cadence, varied on the 3rd pass.
- [ ] String doublings at the octave unless unison was chosen for colour/weight.
- [ ] At f, every wind line doubling strings is a2.
- [ ] Weak low string voices reinforced; no piccolo before the climax.
