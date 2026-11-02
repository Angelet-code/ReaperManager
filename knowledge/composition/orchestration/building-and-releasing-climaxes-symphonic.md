---
id: orchestration.building-and-releasing-climaxes-symphonic
title: Symphonic climax techniques (reserve, alternation, repetition, orchestrated diminuendo)
aliases: [clímax sonoro, clímax en los metales, reserva de medios, reservar un instrumento, alternancia de secciones, pregunta y respuesta entre secciones, clímax por repetición, diminuendo orquestado, quitar duplicaciones, cantus firmus en los trombones, crescendo poco a poco]
domain: orchestration
tags: [climax, build, release, brass, form, diminuendo, alternation, repetition]
style_scope: symphonic (Classical to 20th c.), also valid in film scoring
use_when: Planning where a cue or movement peaks and how the brass and the other sections get there and back (holding a colour in reserve, call-and-response build, repeated motto build, written-out fade).
summary: Adler builds brass climaxes three ways: keep a group (often the trombones) in reserve and give it a theme at a formal turning point; alternate brass phrases with string/woodwind answers, each turn stronger; or repeat a motto with something new each time, thin out after the plateau, then hit a tutti with a slow trombone cantus firmus; or stack three gestures over a percussion roll that starts p and let one theme emerge alone at the peak (Bloch). Release by removing doublings step by step into a soft chord.
sources: ["adler-orq-es p.382-392", "adler-orq-es p.392-412", "adler-orq-es p.413-423", "adler-orq-es p.590-595", "piston-orch p.222"]
related: ["[[building-and-releasing-climaxes]]", "[[percussion-section-writing-climax-and-openings]]", "[[brass-section-writing]]", "[[brass-section-writing-counterpoint]]", "[[dynamics-by-orchestration]]", "[[texture-unison-and-tutti]]", "[[sonata-form]]", "[[user-taste]]"]
---

# Symphonic climax techniques

## Core idea
A climax needs something the ear has not heard yet, or has not heard so strongly. Adler's three brass
techniques supply that newness: **reserve**, **alternation**, **repetition**. The way back down is an
**orchestrated diminuendo**: take instruments away, not only dynamics. Film-style staging (stages, sweep,
subito release, ending types) lives in [[building-and-releasing-climaxes]].

## Rules
- R1 `PREFER` **reserve:** keep one group (trombones, the tuba, or the full brass melody) on doublings and
  pads for most of the movement, then give it a theme of its own at a structural point (Schubert 9, I;
  Beethoven 5 holds the trombones for the finale; Hindemith saves the tuba for a later variation).
- R2 `ALLOWED` the reserved entry may be pp: Schubert's trombones enter pianissimo and add mystery.
- R3 `PREFER` bring the reserved colour back at the matching formal point (end of the recapitulation) to
  clarify the form ([[sonata-form]]).
- R4 `PREFER` a long crescendo adds layers in order: sustained horns first, then upper woodwinds and
  piccolo, then timpani, with trumpets and cymbals kept for the arrival (Berlioz, *Roman Carnival*;
  Schubert 9: trombone theme → horn dyad → horn repeated chords → ff with trumpets).
- R5 `ALLOWED` **alternation:** a brass phrase answered by woodwinds + strings (horns may count as
  woodwinds), each exchange more intense; the peak itself can then be carried by strings and woodwinds
  (Franck, Symphony III).
- R6 `ALLOWED` **repetition:** restate a memorable motto, the third time at fff (Tchaikovsky 4, I).
  `PREFER` renew something on each statement, e.g. a new agitated string figuration under it.
- R7 `PREFER` after a fff plateau, break the texture and thin it (strings fade until only cellos and basses
  move), then re-enter suddenly with a large tutti. The drop makes the arrival hit harder.
- R8 `PREFER` at that arrival add a new slow element: trombones in octaves on a cantus firmus (dotted halves)
  against the fast fragments already heard, with horns/trumpets on repeated chords, tuba on a pedal and a
  timpani roll.
- R9 `ALLOWED` crown a climax by turning intermittent doublings into strict octave unison for all parts
  (Bruckner 7, finale).
- R10 `PREFER` **orchestrated diminuendo:** remove brass doublings in steps (trombones 1–2 out, trombone 3
  stays with the lowest strings), then lower the dynamics, ending on a pp chord (Schubert, *Rosamunde*).
- R11 `PREFER` end a brass climax with a written diminuendo into a pp chord where the strings re-enter
  softly under the fading brass and winds (Wagner, *Lohengrin* I prelude).
- R12 `AVOID` vigorous brass through the whole work: it robs real climaxes of power (Adler). `MUST` size the
  climax brass to what strings and woodwinds can reach (Piston; [[brass-section-writing]] R11).
- R13 `PREFER` **stacked gestures** (Bloch, *Schelomo*): layer three distinct rhythmic gestures (held wind
  chords *cresc. poco a poco*, a fast string figure, a marcato brass line) into one web; at the peak drop
  the web and let one theme sound alone. After the combination it sounds new.
- R14 `MUST` support such a long crescendo with a percussion roll that starts *p* and grows: timpani first,
  then bass drum (timpani sticks: drier, more articulated). A roll that starts *ff* covers the combined
  themes ([[percussion-section-writing-climax-and-openings]]).

## Apply in MIDI / REAPER
- **Brass budget:** before writing, list sections and mark which brass group is reserved, and where it
  first plays a theme. Until then its tracks hold only pads or doublings at CC1 ≤ 60.
- **Reserved pp trombones:** tenor + bass trombone in octaves (e.g. G3 55 / G2 43), half and whole notes,
  CC1 20–30 with small swells.
- **Layered crescendo (R4), 8 bars:** horns enter bar 1 (CC1 40), woods + piccolo bar 3, timpani roll
  bar 5, CC1 rising about 8 per bar; trumpets and cymbal only at the arrival downbeat.
- **Alternation (R5):** brass 2 bars CC1 70 → woods/strings 2 bars CC1 75 → brass CC1 85 → tutti 100+.
- **Repetition (R6–R8):** motto ×3 at CC1 75 / 90 / 110, new 16th figuration on violins at the third;
  then 1–2 bars of cellos + basses only; then tutti with trombones in octaves (dotted halves), horns and
  trumpets on repeated chords (velocity 105–115), tuba pedal, timpani roll.
- **Stacked gestures (R13–R14), 8 bars:** wind pads CC1 40 → 90, string figure velocity 70 → 100, brass line
  CC1 70 → 95; timpani roll from bar 1 at ≈ 30, bass-drum roll from bar 5 at ≈ 35, both rising; the peak
  bar keeps only the theme, its doublings and the bass.
- **Orchestrated diminuendo (R10), 4 bars:** bar 1 tutti; bar 2 drop trumpets and trombones 1–2; bar 3
  bass trombone with cellos and basses at CC1 35; bar 4 pp string chord at CC1 20. This matches
  [[user-taste]] R3 (space and contrast).

## Checklist
- [ ] Is at least one colour new or newly prominent at the climax?
- [ ] Does each repetition or exchange add something?
- [ ] Is there a thinner moment just before the biggest arrival?
- [ ] Do supporting percussion rolls start p, not ff?
- [ ] Does the release remove tracks step by step rather than only lowering CC1?

## Examples
- Schubert 9, I: pp trombone theme, cresc. poco a poco, horns join, ff tutti with the trombones on the theme.
- Tchaikovsky 4, I: fanfare at fff, texture breaks to cellos and basses, tutti with a trombone cantus
  firmus.
