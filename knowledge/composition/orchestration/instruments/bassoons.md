---
id: orchestration.bassoons
title: Bassoon (and contrabassoon overview)
aliases: [fagot, fagotes, Fagott, fagotto, basson, fagot francés, fagot alemán, Buffet, Heckel, bocal, tudel, gancho, clave de tenor, contrafagot, Kontrafagott]
domain: orchestration
tags: [woodwinds, instrument, ranges, registers, bass-line, double-reed]
style_scope: universal
use_when: Writing, checking or doubling a bassoon part (bass of the woodwinds, staccato lines, inner voices, tender or strained high solos); for the contrabassoon see bassoons-contrabassoon.
summary: Bassoon Bb1–Eb5 (34–75; extreme E5 76 by step): low register sonorous but no true pp, middle (43–53) smooth and easily covered, upper-middle (54–62) gentlest, high tense, top strained (Rite of Spring). Staccato especially effective but needs breaks or two players; natural bass of the woodwinds and the standard doubler of cello/bass lines. Contrabassoon: [[bassoons-contrabassoon]].
sources: ["unir-orq-tema5 p.24-28", "unir-orq-tema1 p.8-11", "adler-orq-es p.221-225", "piston-orch p.188-201"]
related: ["[[bassoons-contrabassoon]]", "[[clarinets]]", "[[clarinets-auxiliary]]", "[[oboe-english-horn]]", "[[cello]]", "[[double-bass]]", "[[horn]]", "[[bass-line-doubling]]", "[[woodwind-basics]]", "[[woodwind-section-writing]]", "[[modeled-instruments-swam]]", "[[_instruments]]"]
---

# Bassoon

## Core idea
Conical **double reed** on a curved metal crook (bocal); non-transposing; bass clef, tenor clef from about
G4 (67). Related to the oboe but less nasal. Registers merge without sharp breaks. Section: 2, or 3–4 in
large orchestras, the last doubling contrabassoon.

| Zone (sounding = written) | MIDI | Colour |
|---|---|---|
| Low | 34–42 | sonorous, vibrant, slightly rough; no true pp |
| Middle ("baritone") | 43–53 | smooth, subdued; easily covered |
| Upper-middle | 54–62 | gentlest, least carrying power; tender |
| High | 63–72 | tense, penetrating; well modulated up to 69–70 |
| Top | 73–75 (76) | strained, pinched; deliberate effect |

Full **34–75**, practical 34–72. Variants: Piston's extreme top is E5 (76), approached by step; F5 (77) and
up (Berg) is forced and unreliable. Adler's chart tops near Eb5 (75) [?]. The UNIR chart puts the zone
borders at 44 / 61 / 70.

## Rules
- R1 `AVOID` pp or soft attacks in 34–44; give soft low entries to the bass clarinet. Low Bb1 (34) is
  softer than B1 (35).
- R2 `AVOID` a middle-register line (43–61) under heavy scoring: thin the accompaniment or double it.
- R3 `PREFER` tender, soft solos in about 54–66 (Piston's gentlest zone 54–62; UNIR's 58–70). `MUST`
  accompany lightly any louder solo passing through 54–62.
- R4 `ALLOWED` the top (72–76) for a strained, archaic or haunting colour (Stravinsky *Rite* opening).
  `MUST` approach notes ≥ 74 by step; a unison doubling (violas, cellos) makes them safe. `NEVER` ≥ 77 in
  normal parts.
- R5 `PREFER` staccato: dry, light, comic or grotesque; 2–3 bassoons in unison staccato for a scherzo or
  grotesque march (Dukas *Sorcerer's Apprentice*).
- R6 `AVOID` long unbroken staccato for one player (no time to breathe). `PREFER` a musical break, or two
  bassoons interlocking (one on the downbeats, one on the off-beat figure). In a tutti, very fast
  continuous single tonguing gets slurred or dropped: slur pairs. Double/triple tonguing: last resort.
- R7 `PREFER` wide slurs upward; `AVOID` wide slurs downward. Fast slurred figures around the thumb notes
  34–38 or the Eb3 (51) fork stay short (inferred).
- R8 `PREFER` single-finger trills; `NEVER` trills with both notes on the left thumb (Bb1–C2, 34–36);
  avoid trills below 38 (inferred). Tremolo ≤ P4 (5).
- R9 `PREFER` roles: bass of the woodwinds (with or without bass clarinet); double the cello/bass line in
  unison or octave for point in staccato and rhythm without changing the string colour; inner harmony and
  counterpoint; accompaniment figures with woods and horns (it blends unobtrusively); melodic doubling.
- R10 `PREFER` doublings: + cello (bass or tenor line); + horns in mid chorales (4 horns + 2 bassoons);
  an octave below clarinet or oboe melodies; two bassoons on the inner voices of soft octave-doubled
  strings (Brahms Piano Concerto 1).
- R11 `ALLOWED` a high unison of several bassoons + English horn + horn: a mixed colour in which each
  instrument stays audible (Berlioz *Roméo*).
- R12 `ALLOWED` 2–3 bassoons in unison, parallel intervals or independent counterpoint (Bartók *Concerto*
  trio: two in parallel slurs, one in running staccato).

## Period practice
- `[era: Baroque]` continuo with cello and keyboard; trio of 2 oboes + bassoon.
- `[era: Classical, Haydn/Mozart]` bassoon doubles the Vln I tune an octave below, softer ("Surprise").
- `[era: 19th–20th c.]` German (Heckel) bassoon is the norm; the French (Buffet) one is brighter and freer
  on top: regional colour only.
- `[era: Wagner, Mahler]` low A1 (33) with a long bell joint: outside the normal range.

## Apply in MIDI / REAPER
- Tracks `Bsn 1`, `Bsn 2`, `Cbsn` at concert pitch.
- Dynamic floor (inferred): 34–44 CC1 ≥ 45, velocity ≥ 45. In 43–61 under a tutti, double with cello or
  horn rather than raising CC1.
- Staccato velocity 50–100. An ostinato longer than about 4 bars goes on two tracks, interlocking or
  alternating bars.
- Classical doubling: copy Vln I −12, one dynamic step lower (CC1/velocity about −10).
- SWAM Bassoon 3 loads with Transpose −12: set it to 0 (normalized 0.5) after loading. CC11 is required;
  phrases breathe every ~8 s with ~260 ms gaps (user taste R17, engine `_players.json`).
- Pan centre-right, second woodwind row.

## Checklist
- [ ] Notes 34–75 (76 only by step, doubled); mostly ≤ 72.
- [ ] No pp (CC1 < 40) entries on 34–44.
- [ ] Middle-register line not alone under brass/tutti.
- [ ] Long staccato split or broken by rests; no thumb-key trills.
- [ ] Woodwind chords: bassoon has the lowest note unless the bass clarinet does.

## Examples
- Comic staccato: G2–D3–B2–D3 (43 50 47 50) 8ths, velocity 70–85, Bsn 1–2 a2.
- Tender solo: E4–D4–C4–B3 (64 62 60 59), p, CC1 40–55, strings pp underneath.
