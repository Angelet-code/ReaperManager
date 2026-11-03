---
id: orchestration.clarinets
title: Clarinets (Bb and A; family overview)
aliases: [clarinete, clarinetes, clarinete en si bemol, clarinete en la, clarinete en do, Klarinette, clarinetto, clarinette, chalumeau, registro chalumeau, clarín, registro clarín, sonidos de garganta, notas de garganta, sonidos guturales, cambio de registro, paso del clarinete, ataque dal niente, sonido de eco, echo tone, subtono, ruiseñor de la orquesta]
domain: orchestration
tags: [woodwinds, instrument, ranges, registers, transposition, single-reed]
style_scope: universal
use_when: Writing, checking or doubling a Bb or A clarinet part; choosing a woodwind for soft entries, dark low lines or lively accompaniment figures; picking a clarinet-family member.
summary: Bb clarinet sounds D3–F6 (50–89; A clarinet 49–88): dark chalumeau 50–64, pale throat tones 65–68, bright clarino 69–82, shrill top 83–89. The most even woodwind across registers and dynamics (niente entries, ppp echo tones, soft low notes), dry staccato, agility second to the flute; glissandi go up only. Eb/D, bass, alto, basset horn and contrabass clarinets: [[clarinets-auxiliary]].
sources: ["unir-orq-tema5 p.18-23", "unir-orq-tema1 p.11-15", "adler-orq-es p.205-209", "piston-orch p.163-177", "piston-orch p.184"]
related: ["[[clarinets-auxiliary]]", "[[saxophones]]", "[[flute-piccolo]]", "[[oboe-english-horn]]", "[[bassoons]]", "[[transposing-instruments]]", "[[woodwind-basics]]", "[[woodwind-section-writing]]", "[[modeled-instruments-swam]]", "[[_instruments]]"]
---

# Clarinets (Bb and A; family overview)

## Core idea
Cylindrical bore, **single reed**, overblowing at the twelfth (19 st): distinct registers, with the
**break** (written Bb4 → B4) between throat tones and clarino. One fingering system for every size; all
transpose; MIDI stays at concert pitch.

| Instrument | Written → sounding | Full (sounding) | Practical | Detail |
|---|---|---|---|---|
| Bb clarinet | −2 | 50–89 (written E3–G6) | 50–84 | this note |
| A clarinet | −3 | 49–88 | 49–83 | this note; the only one with 49 |
| Eb clarinet (requinto) | **+3** | 55–94 | 55–91, used high | [[clarinets-auxiliary]] |
| Bass clarinet (Bb) | −14 (German notation −2) | 34–82 | 38–72 | [[clarinets-auxiliary]] |
| Alto (Eb), basset horn (F), contrabass (Bb/Eb) | −9 / −7 / −26, −21 | see detail note | | [[clarinets-auxiliary]] |

Bb registers (sounding; A clarinet −1): **50–64 chalumeau** (dark, rich, dramatic) · **65–68 throat tones**
(pale, less vibrant) · **69–82 clarino** (bright, incisive, warm) · **83–89 high** (piercing in f,
flute-like when soft) · 90–94 extreme. Break on Bb = 68↔69, on A = 67↔68.
Top variants: Piston's safe top is written G6 (89 / 88); Adler's chart runs to about written C7 (94) [?].

## Rules
- R1 `PREFER` the throat tones as a pale colour and pass through them freely (Piston). `AVOID` putting an
  important exposed sustained note on 65–68 (Bb): give it to the A clarinet, where it is a clarino note.
- R2 `ALLOWED` slurred lines across the break for professionals (Piston). Adler: avoid exposed fast
  crossings for student or amateur players.
- R3 `PREFER` the chalumeau for dark, menacing or atmospheric colour, low melodies (Tchaikovsky 5 opening)
  and repeated-note or accented accompaniment figures.
- R4 `ALLOWED` register contrast inside the pair: Cl 1 sings in the clarino while Cl 2 runs arpeggios in
  the chalumeau (Mozart 39, Trio).
- R5 `AVOID` f above 82 unless shrillness is wanted; 90–94 only doubled in a tutti.
- R6 `PREFER` the clarinet for niente entries and exits, ppp echo tones and pp chords. It has the widest
  dynamic range of the woodwinds in every register, low notes included (unlike oboe and bassoon).
- R7 `ALLOWED` agility second only to the flute: scales, arpeggios, wide leaps, cadenzas. `PREFER` wide
  legato leaps upward.
- R8 `PREFER` single tonguing; relieve long fast tongued passages with 2–3-note slurs. Double/triple
  tonguing is an emergency resource. Staccato is dry and cutting: less pointed than the oboe's, drier than
  the flute's.
- R9 `ALLOWED` all major and minor trills; fingered tremolos are best in the chalumeau. `NEVER` tremolos
  wider than M6 (9) in the chalumeau, P4 (5) above the break, M3 (4) above written F5.
- R10 `MUST` glissandi go **up** only, and not across the break. Downward, only a small lip bend
  (microtonal colour).
- R11 `PREFER` roles: soloist, unobtrusive doubler, harmony section, lively background figures (trills,
  flourishes, repeated notes).
- R12 `PREFER` doublings: + flute (unison or octave, round melody); + oboe (unison, rounds the oboe);
  + violas/cellos (warm inner lines); bass clarinet + cellos/basses.
- R13 `MUST` breathe (user taste R16): rests every ≈ 4–8 bars in long lines (general knowledge). Key
  clicks and multiphonics need a verbal description `[era: late 20th c.]`.

## Period practice
- `[era: tonal 18th–19th c.]` Bb for flat keys, A for sharp keys (Adler). In 20th-c. and later scores Bb
  predominates. Piston (1955) calls the key reason misleading and the tone difference hardly audible.
- `[era: Classical–Romantic]` C clarinet parts are now played on Bb/A. Write C only for period colour.
- `[era: late Romantic]` large clarinet sections: Mahler 8 (2 Eb, 3 Bb/A, bass), Strauss *Elektra* (Eb,
  4 Bb/A, 2 basset horns, bass), *Rite of Spring* (D, 3 Bb/A, 2 bass).
- `[era: Mahler]` bells up (pabellón en alto, Schalltrichter auf) at ff for a wild, brassy colour.

## Apply in MIDI / REAPER
- Tracks `Cl 1`, `Cl 2`, `Eb Cl`, `B.Cl`. Use a Bb patch unless 49 is needed. Written parts: Bb +2, A +3
  (see [[transposing-instruments]]).
- Niente: velocity ≤ 20, CC11/CC1 ramp from 0–10, no accent. Echo tone: CC1 10–25 (inferred).
- Staccato length about 50–60 % of the grid step (oboe 35–45 %) (inferred from Piston).
- Fast 16ths: slur 2–3 notes (overlap) between tongued notes.
- Chalumeau accompaniment: repeated staccato dyads, p, velocity 40–60.
- Throat-tone check: flag notes 65–68 held ≥ 1 beat at a phrase peak (matters for players; samples may
  hide it, inferred).
- SWAM Clarinet 3: CC11 is required, overlap = slur; phrases breathe about every 8–10 s with ~220 ms gaps
  (user taste R17, engine `_players.json`). See [[modeled-instruments-swam]].
- Pan centre-left, second woodwind row.

## Checklist
- [ ] Bb 50–89 (mostly ≤ 84); A 49–88; only the A track plays 49.
- [ ] No exposed sustained peak notes on 65–68 (Bb) / 64–67 (A).
- [ ] Notes ≥ 83 are climaxes or doublings; nothing ≥ 90 exposed.
- [ ] Tremolo widths within R9; no downward glissando.
- [ ] Breath gaps exist in long lines.

## Examples
- Chalumeau melody: E3–G3–B3–E4 (52 55 59 64), p, CC1 40–55.
- Niente entry on C5 (72): 2-bar CC1 ramp 0→70, velocity 15.
