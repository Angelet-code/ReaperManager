---
id: orchestration.string-techniques
title: String techniques — bowing, strokes and articulation patches
aliases: [técnicas de cuerda, articulaciones de cuerda, golpes de arco, arcadas, arco arriba, arco abajo, ligado, legato, détaché, destacado, louré, portato, staccato, staccato ligado, spiccato, saltando, saltato, martelé, martellato, jeté, ricochet, arpeggiando, punta d'arco, a la punta, al tallone, al talón, acentos, Bogenstriche, Abstrich, Aufstrich, an der Spitze, am Frosch, Springbogen]
domain: orchestration
tags: [strings, articulation, bowing, accents, sample-library, hub]
style_scope: universal
use_when: Choosing a string articulation, patch and note lengths for a bowed line (slurs, détaché, staccato, spiccato, martelé, jeté, accents); start here for any string technique.
summary: A slur means one bow, never a phrase; unslurred notes are détaché, the default and fastest stroke. Dots become spiccato at moderate tempo p–mf, bounce by themselves when fast, and turn into martelé when loud and hammered; on-string staccato sounds at about half value. Pick the patch from tempo and dynamic; stops/divisi, pizz/harmonics and colour effects live in the three linked notes.
sources: ["unir-orq-tema4 p.5-14, 15-21, 21-26, 26-32", "unir-orq-tema1 p.6-8", "adler-orq-es p.16-28", "piston-orch p.7-20, 34"]
related: ["[[string-techniques-stops-and-divisi]]", "[[string-techniques-pizzicato-harmonics]]", "[[string-techniques-colour-effects]]", "[[violin]]", "[[viola]]", "[[cello]]", "[[double-bass]]", "[[string-section-writing]]", "[[legato-overlap-and-attack-offsets]]", "[[library-translation-table]]", "[[_instruments]]"]
---

# String techniques — bowing, strokes and articulation patches

## Core idea
The score gives slurs, dots, dashes, accents, tempo and dynamic; the player picks the stroke (Piston).
Strokes stay **on the string** (legato, détaché, louré, staccato, martelé) or **leave it** (spiccato,
saltando, jeté). Other techniques:
- [[string-techniques-stops-and-divisi]]: double stops, chords, divisi, vibrato, glissando, scordatura.
- [[string-techniques-pizzicato-harmonics]]: pizzicato variants, natural and artificial harmonics.
- [[string-techniques-colour-effects]]: tremolos, trills, sul pont./tasto, col legno, mutes, contemporary.

## Rules
**Bow direction and distribution**
- R1 `PREFER` down-bow (⊓, frog→tip) on strong beats, up-bow (V) on upbeats; an anacrusis starts up-bow.
- R2 `PREFER` crescendos on up-bows, diminuendos on down-bows. Two strong attacks in a row: change bow
  unheard inside the long note before (⊓V) so both land down-bow.
- R3 `NEVER` use a slur as a phrase mark: slur = one bow. Unslurred long notes still sound connected.
- R4 `MUST` fit notes per bow to tempo and dynamic: fast and soft allows many; at f about six (Adler,
  Mendelssohn 4). `AVOID` overloading slow bows, above all cellos and basses (shorter bows). A bow lasts
  about 4 s at f and about 10 s at pp ([[user-taste]] R16).
- R5 `PREFER` staggered bowing (half the section changes elsewhere) for endless pads.
- R6 `AVOID` unequal groups in alternating bows (4 down, 2 up): the short bows pop out (Piston).
- R7 `ALLOWED` near the bridge louder and brighter, near the fingerboard softer; tip light, frog heavy.

**Strokes**
- R8 `PREFER` **détaché** (no slur, no dot) for moving notes: one bow per note, audible but not separated;
  the fastest stroke; unison détaché runs add energy (Mozart K.543). `AVOID` legato for fast runs.
- R9 `PREFER` punta d'arco for fast, light pp figures; the frog or lifted down-bows for heavy, equal stress
  (moderate tempo; Sacre, "Augurs").
- R10 `ALLOWED` **louré/portato** (dashes under a slur): gentle pulses in one bow; the classic soft
  repeated-chord accompaniment (Sibelius 2).
- R11 `MUST` on-string **staccato** sounds about half its written value (Adler); best at slow to moderate
  tempo, p or f. Slurred staccato = several short notes in one bow.
- R12 `MUST` dots become off-string with speed: **deliberate spiccato** at moderate tempo p–mf, **saltando**
  (the bow bounces by itself) when fast and light. Call fast staccato spiccato.
- R13 `PREFER` **martelé** for hard, square, loud strokes: on the string, a bite at each start, a gap after.
- R14 `PREFER` **jeté/ricochet** (thrown bow, dots under a slur) at ≤ 3 notes per stroke in orchestra,
  3–4 for cellos and basses (Adler). Piston allows 2–6; treat > 3 as soloistic.
- R15 `ALLOWED` **arpeggiando**: one note per string, rolling across 3–4 strings low→high→low.
- R16 `MUST` dotted figure in one bow: shorten the **long** note (gap before the short one); dot the short
  note only. Light, fast dotted rhythms: separate bows near the tip.

**Accents (Piston)**
- R17 `PREFER` one envelope per accent, relative to the current dynamic: `>` hard start, then steady lower;
  *sf* peak just after the start, then decay; *fp* loud start, sudden p; `< >` swell inside the note.

## Period practice
- `[era: Baroque bow, 17th–18th c.]` the outward-curved stick held chords more easily than the modern
  Tourte bow (after c. 1780).
- `[era: Piston 1955]` off-string names were disputed; composers wrote dots only. Adler (2002) splits
  spiccato into deliberate, spontaneous (saltando) and slurred.

## Apply in MIDI / REAPER
Captured Albion ONE patches; numbers inferred unless cited.

| Marking | Patch | MIDI |
|---|---|---|
| slur | Strings High (Octave) Legato; low strings Long | overlap = slur ([[legato-overlap-and-attack-offsets]]); velocity does nothing on Albion legato |
| unslurred long notes | Strings - Long | `len` ends ~30 ms before the next onset; one CC1 swell per bow |
| détaché, moderate | Strings - Long | `len` 85–95 % of the slot; even CC1 |
| détaché, fast runs | Short Spiccato | even velocity, ±5 |
| louré | Long / Legato | `len` 80–90 % or a CC11 dip of 3–6 per note |
| staccato (on string) | Short Staccato Combo | `len` ≈ 50 % (R11) |
| dots, moderate, p–mf | Short Spiccato | velocity 40–90 |
| martelé, down-bow series | Short Staccato Combo | velocity 95–120, equal on every note |
| jeté group | Short Spiccato | ≤ 3 notes, `len` ≤ 0.1 beat, −8 velocity per bounce |
| accent `>` / *fp* | Long | CC1 peak, back to base in 1/8 beat (`>`) or 0.1–0.2 beat (*fp*) |

- Albion longs: CC1 dynamics, CC11 expression, CC21 vibrato; shorts: velocity. Curves in
  [[library-translation-table]]; dynamic → number in [[_instruments]].
- Albion legato: re-articulate about every 7 s with a 120 ms gap ([[user-taste]] R17). That is the MIDI
  bow change.

## Checklist
- [ ] Slurs fit one bow (≤ ~4 s at f, ≤ ~10 s at pp); no slur used as a phrase mark.
- [ ] No legato patch on fast runs (16ths at ≥ ~120 bpm).
- [ ] Dots: spiccato when moderate/fast and light; staccato combo when loud or hammered.
- [ ] Jeté groups ≤ 3 notes; dotted figures shorten the long note; accents have one envelope each.
