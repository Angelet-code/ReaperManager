---
id: orchestration.orchestra-sizes-and-section-balance-by-era
title: Orchestra line-ups by era (Baroque to film)
aliases: [orquesta barroca, orquesta clásica, orquesta romántica, gran orquesta, orquesta de Mahler, orquesta de Berlioz, plantilla por época, orden de la partitura, orquesta a dos, orquesta a tres, orquesta a cuatro, musica fracta, musica sociata]
domain: orchestration
tags: [line-up, history, period-practice, template, score-order]
style_scope: period practice (Renaissance to modern film); the modern default stays in the main note
use_when: Choosing the forces for a piece in a named period or composer's manner (Baroque, Haydn/Mozart, Beethoven, Wagner, Mahler, film), or checking that a template has no anachronistic instruments.
summary: Line-ups grow from a string core with variable winds (Baroque) to the Classical a2 orchestra (2 fl/ob/cl/bsn, 2 hn, 2 tpt, timpani, no trombones in symphonies), the Romantic a3 with auxiliaries and trombones, the late-Romantic large orchestra (strings 18-16-14-12-10, 8 horns) and the modern standard (4 hn, 3 tpt, 3 trb, tuba). Film adds huge brass. Track order follows score order: woods, horns, trumpets, trombones, tuba, timpani, percussion, harp/keys, strings.
sources: ["adler-orq-es p.3-8", "adler-orq-es p.357-364", "adler-orq-es p.148-152", "unir-orq-tema1 p.4-6"]
related: ["[[orchestra-sizes-and-section-balance]]", "[[brass-section-writing-period-practice]]", "[[natural-horn-period-practice]]", "[[trumpet-period-practice]]", "[[timpani-effects-and-period-practice]]", "[[orchestral-mockup-template]]"]
---

# Orchestra line-ups by era

## Core idea
Each period has its own forces, and an anachronistic instrument breaks a pastiche more than any voicing
error. Pick the line-up from the table, then size sections with [[orchestra-sizes-and-section-balance]].
The modern standard is the default unless a period or style is named.

## Line-ups
| Era (tag) | Woodwinds | Brass | Other | Strings I/II/Va/Vc/Cb |
|---|---|---|---|---|
| Renaissance | unspecified: parts by voice (S A T B), any suitable instrument | — | — | consorts (Adler) |
| Baroque c.1680–1750 | fl/rec, ob, bsn (Lully 1686); varies with players available | 2–3 hn, 3 tpt with timpani, trb in threes | continuo | string core (Adler) |
| Classical c.1770–1800 ("a2") | 2 fl, 2 ob, 2 cl, 2 bsn | 2 hn, 2 tpt | timpani (tonic + dominant) | 6-6-4-4-2 (Adler, older norm); UNIR 6–8/4–6/4/4/1–2 |
| Early–mid 19th c. ("a3") | + picc, E.H., bass cl, cbsn | 4 hn, 2 tpt, 3 trb (from opera), later tuba | harps, more percussion | about 12/10/8/8/6 (general knowledge) |
| Berlioz | winds, brass, percussion more than doubled | | | strings greatly enlarged |
| Late Romantic c.1890–1915 (Mahler, Stravinsky) | up to 6 fl, 5 ob, 6 cl, 4 bsn | 8 hn, 4 tpt, 4 trb, 2 tubas | 2 harps, piano, 4–5 percussionists | 18-16-14-12-10 (Adler) |
| 20th c. large ("a4", UNIR) | 3 + picc, 3 + E.H., 3 + bass cl, 3 + cbsn | 6–8 hn, 4 tpt, 3 trb + bass trb, tuba | timpani, percussion, keyboards, mallets | 16/14/12/10/8 |
| Modern standard (Adler 2002) | a2–a3 with auxiliaries (general knowledge) | 4 hn, 3 tpt, 3 trb, tuba (up to 11 brass voices) | timpani, percussion, harp | 16–18/14–16/10–12/10–12/8–10 |
| 1960s sonorism (Penderecki *Threnody*) | — | — | — | 24 vln, 10 va, 10 vc, 8 cb, often one pitch per player |
| Film "big" (HTTYD) | a3 + whistle, contrabass cl | 12 hn, 4 tpt, 4 trb + 2 bass trb, tuba | 7 percussion staves, celesta, 2 harps | full |

## Rules
- R1 `MUST` `[era: Classical]` No trombones in the symphony (only in opera and church music), no
  independent percussion section (snare, bass drum, triangle, cymbals only in opera), timpani tied to the
  trumpets (Adler). Natural horns and trumpets play open notes; see [[natural-horn-period-practice]].
- R2 `PREFER` `[era: early Baroque]` One uniform orchestration through a piece (Monteverdi); `[era: Baroque]`
  trumpets, horns and trombones rarely all play together, usually in different movements; a Baroque tutti
  stacking all three is likely a later arrangement (Adler).
- R3 `ALLOWED` `[era: to c.1750]` Substituting instruments across families (a viola for an alto trombone part)
  was accepted; later it became an exception (Adler).
- R4 `ALLOWED` `[era: Classical, in the score]` Two double basses were the older norm (Adler: 6-6-4-4-2).
  This conflicts with the vault's modern rule "never exactly 2 basses" (UNIR), which is about the sound of
  a section: in a mock-up use one solo bass patch or a section patch.
- R5 `MUST` Keep score order in templates: woods, horns, trumpets, trombones, tuba, timpani, percussion,
  harp/keyboards, strings. Horns sit above trumpets because they joined the orchestra first (Adler).
- R6 `ALLOWED` Re-orchestrating older music for larger forces is a historical practice (Mozart's *Messiah*,
  Mahler's Beethoven), but tastes change: label it as a re-scoring (Adler).
- R7 `PREFER` For a Mahler/Strauss size, the late-Romantic row; for a Haydn/Mozart sound, the Classical row
  with no trombones, tuba or percussion.

## Apply in MIDI / REAPER
- **Classical (a2) track set:** `FL 1-2`, `OB 1-2`, `CL 1-2`, `BSN 1-2`, `HN 1-2`, `TPT 1-2`, `TIMP`,
  `VLN I`, `VLN II`, `VLA`, `VC`, `CB`. Timpani only on tonic and dominant (in D: D2 38, A2 45).
- **Late-Romantic set:** add `PICC`, `EH`, `BCL`, `CBSN`, `HN 1-4` + `HN 5-8` (or two a4 patches),
  `TBN 1-4`, `TUBA`, `HARP 1-2`, percussion tracks; strings on full-section patches.
- **Anachronism lint:** in a Classical spec, flag any `TBN`, `TUBA`, `PERC`, `HARP`, `PICC` or `EH` track,
  and horn/trumpet notes outside the crook's open notes.
- Track order of every template = score order (R5), whatever the stage seating.
