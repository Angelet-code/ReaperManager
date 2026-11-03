---
id: orchestration.doubling-colour-and-decay-section-pairings
title: Doubling pairs across woodwinds, strings and brass
aliases: [doblajes entre familias, doblar cuerda con madera, doblar metal con madera, unísonos congeniales, peso sonoro, equilibrio de doblajes, tutti concentrado, tutti brillante, madera refuerza armónicos del metal]
domain: orchestration
tags: [doubling, woodwinds, strings, brass, balance, tutti, unison, octave]
style_scope: universal (Piston 1955 and Adler 2002 practice; unison habits era-tagged)
use_when: Choosing a concrete cross-family doubler for a line (which wind with which string or brass instrument, unison or octave) and how many doublers balance at p and f, or choosing a concentrated vs brilliant tutti layout for a melody.
summary: Strings + wind: one wind per octave at p, a2 at f; congenial unisons are Vln+Fl, Vla+EH, Vc+Bcl, Cb+Cbsn; a single bassoon 8vb warms a violin tune. Brass + wind: horns are the link; at p octave doublings with flute, oboe or clarinet sound well; at f high woods only reinforce brass upper partials (double them) and low woods join the brass bass; clarinet/oboe in unison with trumpet dulls it, woods with trombones rarely help. Tutti: concentrated (two adjacent octaves) or brilliant (four octaves, every family in every octave).
sources: ["piston-orch p.426-430", "piston-orch p.436-445", "adler-orq-es p.276-282"]
related: ["[[doubling-colour-and-decay]]", "[[woodwind-section-writing]]", "[[woodwind-section-writing-with-strings]]", "[[texture-unison-and-tutti]]", "[[bass-line-doubling]]", "[[horn]]", "[[brass-section-writing]]", "[[orchestra-sizes-and-section-balance]]", "[[tutti-balance-by-role]]"]
---

# Doubling pairs across woodwinds, strings and brass

## Core idea
The general method (need → criterion → doubler) is in [[doubling-colour-and-decay]]. This note is the
lookup for **cross-family** pairs and their balance, from Piston's melody-scoring problems and Adler's
doubling chapter. Woodwind-with-woodwind pairs are in [[woodwind-section-writing]].

## Rules
**Strings + woodwind**
- R1 `ALLOWED` one wind an octave above or below a string part (Fl over Vln 1, Bsn under it): sounds well
  soft. `MUST` at f, double the wind (a2) or it won't balance the section.
- R2 `ALLOWED` string–wind unison wherever ranges coincide; judge each by register and dynamic. Congenial
  pairs (Piston): **Vln + Fl, Vla + EH, Vc + Bcl, Cb + Cbsn**.
- R3 `ALLOWED` one wind on a string line mostly strengthens the string tone (its colour is absorbed at f);
  two winds tint it audibly.
- R4 `PREFER` a single bassoon 8vb under a Vln 1 tune for warmth (Brahms 1/II).
- R5 `ALLOWED` a warm melody in three octaves: Fl 1 / Vln 1 / Vc + Hn, strongest in the horn–cello octave
  (Piston).
- R6 `PREFER` when low basses sit far below a light texture, double them with bassoons or raise them an
  octave (Piston); see [[bass-line-doubling]].

**Brass + woodwind**
- R7 `PREFER` horns as the link between woods and brass; Hn + Cl or Hn + Bsn in unison blend well.
- R8 `ALLOWED` at p, octave doublings Tpt + Fl and Hn + Fl/Ob/Cl.
- R9 `MUST` at f, treat high woods as reinforcement of the brass upper partials and double them as much as
  possible; put Bsn and Bcl on the bass line with tuba, Tbn 3 and Hn 4.
- R10 `ALLOWED` Cl or Ob in unison with trumpet for weight; `AVOID` it when the trumpet's brilliance is
  wanted.
- R11 `AVOID` woodwind unisons with trombones (seldom useful). `ALLOWED` tuba + Bcl or Cbsn.

**Brass + strings**
- R12 `AVOID` a solo horn doubling the first note of a string melody: it sticks out of the violins.
- R13 `PREFER` a double-bass pedal paired with Hn 4 and Cbsn at the octave (Piston, Brahms 2 rescoring).

**Tutti layouts for a melody (Piston)**
- R14 `ALLOWED` **concentrated** ff: nearly everyone in unison on two adjacent octaves; omit Cb, Cbsn,
  tuba, piccolo, and Tpt 2-3 (so it does not sound like brass alone).
- R15 `ALLOWED` **brilliant** ff over four octaves, each octave covered by all three families.
- R16 `PREFER` when no tutti is needed, part of the orchestra in pure colours (see
  [[doubling-colour-and-decay]] R12).

**Counting weight**
- R17 `ALLOWED` count each string section as one instrument, a divided half-section as about half, a solo
  string as one (wide margin, Piston). One horn < one trumpet or trombone at f.

## Period practice
- `[era: 18th–19th c.]` unison wind doubling of strings was standard. `[era: 1955, Piston]` all
  string–wind unisons work where ranges coincide. `[era: 2002, Adler]` prefer the octave: unison muddies
  both instruments' upper partials. **Vault default:** octave for clarity; unison chosen for warmth, colour
  or tutti weight.
- `[era: 18th-c. theatre]` bassoons reinforcing a small cello/bass section.

## Apply in MIDI / REAPER
| Lead track | Dynamic | Doubler track(s) | Transposition |
|---|---|---|---|
| VLN 1 tune | p | FL 1 | +12 |
| VLN 1 tune | p, warm | BSN 1 | −12 |
| VLN 1 tune | f | FL 1 + FL 2 (or a2 patch) | +12 |
| VLA line | p, colour | EH | 0 |
| VC line | p, colour | BCL | 0 |
| CB line | colour | CBSN | 0 |
| Brass chord, f | f | FL/OB/CL pairs | top chord tones, +12 |
| Brass bass, f | f | BSN + BCL | 0 with TUBA / TBN 3 |
| Horn tune | p | CL or BSN | 0 |
| Trumpet tune | p | FL | +12 |

- **Concentrated tutti, melody around C4–F4:** upper octave `OB`+`EH`+`CL`+`TPT 1`+`HN 1/3`+`TBN 1`+`VLN`+`VLA`;
  lower octave `BSN`+`BCL`+`TBN 2-3`+`HN 2/4`+`VC`.
- **Brilliant tutti:** top `PICC`+`FL`+`VLN 1`; next `OB 1`+`CL`+`TPT 1-2`+`VLN 2`; next `EH`+`OB 2`+`BSN 1`+`TPT 3`+`HN 1/3`+`VLA`;
  next `BCL`+`BSN 2`+`HN 2/4`+`TBN`+`VC`; bottom `CBSN`+`TUBA`+`CB`.
- Doubler CC1 5–15 under the lead, except the f wind-over-brass case, where the woods sit at full CC1 and
  the brass about 10 lower.

## Checklist
- [ ] At f, every wind doubling strings or brass is at least a2.
- [ ] No woodwind unison on a trombone line; no Cl/Ob on a trumpet line meant to be brilliant.
- [ ] Low woods with the brass bass, high woods doubled on top, in f brass passages.
- [ ] No solo horn on the first note of a string melody.
- [ ] Tutti layout chosen: concentrated (2 octaves) or brilliant (4 octaves).
