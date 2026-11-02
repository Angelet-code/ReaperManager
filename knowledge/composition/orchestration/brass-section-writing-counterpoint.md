---
id: orchestration.brass-section-writing-counterpoint
title: Brass counterpoint, canon and fugato
aliases: [contrapunto en los metales, escritura contrapuntística para metales, fugato de metales, canon por color y registro, stretto, puntuación del metal, parte de tipo clarino, imitación en los metales, registros de órgano, p ma marcato, ben marcato, Blechfugato]
domain: orchestration
tags: [brass, counterpoint, canon, fugato, stretto, imitation, punctuation]
style_scope: universal (symphonic; Romantic to 20th c.)
use_when: Writing imitative or contrapuntal passages for brass (canon, fugato, stretto, organ-like chorale variations, independent brass lines in dense counterpoint).
summary: Separate canon entries by colour family AND register (bassoons → trombones → flutes + oboes). In a brass fugato give each voice to a unison group in its best register, bring each entry in f ben marcato over mf/p continuing voices, invert the subject in the horns for the second exposition, and close with stretto one bar apart, framed by tutti hits.
sources: ["adler-orq-es p.392-412"]
related: ["[[brass-section-writing]]", "[[brass-section-writing-melody]]", "[[texture-counterpoint]]", "[[imitation-and-canon]]", "[[fugue]]", "[[line-separation-and-fusion]]", "[[trumpet-period-practice]]", "[[building-and-releasing-climaxes-symphonic]]"]
---

# Brass counterpoint, canon and fugato

## Core idea
Brass counterpoint is either strict imitation (canon, fugato, stretto) or free independent lines. The
brass speaks clearly, so it carries counterpoint well, but only if each entry is set apart by colour,
register and dynamics. General contrapuntal scoring: [[texture-counterpoint]]; the imitation itself:
[[imitation-and-canon]], [[fugue]].

## Rules
- R1 `PREFER` **canon by colour and register:** each entry in a different family and register, e.g. 2
  bassoons in unison → trombones (+ tuba) → flutes + oboes in octaves (Berlioz, *Roman Carnival*).
- R2 `ALLOWED` trombones may state a canonic subject at p: soft brass counterpoint is idiomatic.
- R3 `ALLOWED` anticipate a coming entry with a slightly varied version of the subject in another group.
- R4 `ALLOWED` **organ registrations:** give each contrapuntal voice its own wind or brass colour (2 trumpets,
  2 trombones, flute + bassoon) and double the cantus firmus with soft low strings and low reeds
  (Stravinsky, *Vom Himmel hoch*, var. IV).
- R5 `ALLOWED` clarino-style florid trumpet lines in the middle register: the style lies in the
  figuration, not in the height ([[trumpet-period-practice]]).
- R6 `PREFER` mark brass counterpoint against a chorale "p ma marcato": soft but articulated.
- R7 `MUST` in a brass fugato keep every instrument in its best register so each entry is clear (Adler).
- R8 `PREFER` with brass alone, give each fugal voice to a unison group (trombones a3, horns a3,
  trumpets a2, tuba, then 4 horns), not to one player (inferred from Hindemith, *Symphonic Metamorphosis*).
- R9 `PREFER` the entering subject leads: entry f "ben marcato", continuing voices mf (Bartók), or entry mf,
  continuing p (Hindemith). Count 2 horns as one trumpet or trombone ([[brass-section-writing]] R3).
- R10 `PREFER` second exposition: the subject inverted in a new family (horns 1–3 a2 and 2–4 a2), then
  the rest of the brass (Bartók, *Concerto for Orchestra* I).
- R11 `PREFER` end the fugato with stretto (entries one bar apart, trumpets 1–3 and trombones 1–3, six
  voices) for cumulative excitement.
- R12 `ALLOWED` frame a brass-alone fugato with short ff tutti chord hits; let the timpani state the subject
  while the brass punctuates (Hindemith).
- R13 `ALLOWED` grow a string tremolo bed under the brass fugato, entering p cresc. one section at a time,
  then hand the fugato to a tutti ff run (Bartók).
- R14 `PREFER` in dense free counterpoint, give trombones, trumpets and woodwinds truly independent lines and
  let the horns add separate rising calls instead of doubling (Schoenberg, op. 16/1).
- R15 `PREFER` give real material to neglected instruments (tuba, contrabassoon, double bass) for fresh colour
  and a stronger bass (Schoenberg).

## Apply in MIDI / REAPER
- **Canon:** one track group per entry, never the same group twice in a row: e.g. bassoons (subject in
  48–60) → `LOW BRASS LONG` (same register, or −12) → flutes + oboes (+12/+24).
- **Fugato velocities:** entering subject velocity 90–100 (f) or CC1 80–90 on longs; continuing voices
  velocity 60–75. Accent the first note of each entry (+10).
- **Unison groups:** with Albion, `LOW BRASS SHORT` = trombones a3, `HN SHORT` = horns, `TPT SHORT` =
  trumpets; give the tuba entry on a separate tuba patch if one exists (else bass trombone + octave).
- **Stretto:** copy the subject to `TPT` and `LOW BRASS` tracks, shifted by one bar (or ½ bar in 4/4),
  each with the +10 accent on its first note.
- **Tremolo bed (R13):** string tremolo tracks enter one per 2 bars (vln 2 → vc → vla → db), CC1 ramps
  25 → 90 under the brass, landing on the tutti bar.
- **Organ texture:** soft florid lines on trumpet, trombone, flute and bassoon tracks at velocity 45–60;
  cantus firmus in long legato notes on violas, basses and bassoons at CC1 25–35.

## Checklist
- [ ] Does each canon/fugato entry change family or register from the previous one?
- [ ] Is every brass voice inside its best register?
- [ ] Is the entering subject louder than the continuing voices?
- [ ] Does the passage tighten (stretto, added bed) towards its end?

## Examples
- Hindemith, *Symphonic Metamorphosis*, Turandot scherzo: trombones a3 → horns a3 → trumpets a2 → tuba →
  4 horns, then the timpani take the subject.
- Bartók, *Concerto for Orchestra* I: trombone/trumpet fugato, horn inversion, stretto, string tremolo bed,
  tutti hand-off.
