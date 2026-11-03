---
id: orchestration.trombone-period-practice
title: Trombone period practice (alto trombone, national habits, contrabass and valve trombones)
aliases: [trombón alto, trombón contralto, Altposaune, trombone contralto, trombón contrabajo, Kontrabassposaune, trombón de pistones, trombón de válvulas, Ventilposaune, trombón bajo en fa, sección alto-tenor-bajo, trompeta baja]
domain: orchestration
tags: [brass, trombone, period-practice, section-layout]
style_scope: classical-romantic
use_when: Writing trombones in the manner of a period or school (Classical/Romantic alto–tenor–bass section, French or Russian habits, Wagner's contrabass trombone) or reading older trombone parts.
summary: Until the late 19th c. the section was alto (Eb, alto clef) + tenor + bass; the modern default is 2 tenors + bass. The alto (A2–Eb5, 45–75) has a pure, mellow, less piercing top and a weak bottom. French scores favoured three tenors; Russian scores put trombones I–II in alto clef. Contrabass and valve trombones are discouraged today: give contrabass parts to the tuba.
sources: ["adler-orq-es p.339-341", "adler-orq-es p.346-349", "adler-orq-en2 p.311-319", "piston-orch p.206-208", "piston-orch p.269-281", "unir-orq-tema6 p.19-24"]
related: ["[[trombone]]", "[[trombone-slide-techniques]]", "[[tuba]]", "[[tuba-family-and-relatives]]", "[[trumpet]]", "[[natural-horn-period-practice]]"]
---

# Trombone period practice

## Core idea
The modern default (2 tenors + bass, [[trombone]]) is a late-19th/20th-century settlement. Earlier and
national practices are resources for pastiche, not errors. All trombones stay non-transposing in MIDI.

## Period practice
- `[era: 18th c.]` The alto trombone was also a solo instrument (Adler). In church music trombones
  doubled the choir's alto, tenor and bass lines (Bach *Cantata 118*: three trombones, Adler's list;
  colla-parte use is general knowledge).
- `[era: Classical]` Trombones give cadential support and harmonic filling with the trumpets (UNIR);
  symphonies kept 2 horns + 2 trumpets (Piston). Mozart's *Requiem* "Tuba mirum" gives a legato tenor
  trombone solo (orchestrated by Süssmayr; Adler). Beethoven 9/IV "Seid umschlungen": one bass trombone
  doubles the male chorus in ff half notes.
- `[era: until late 19th c.; German and Italian composers]` Section = **alto, tenor, bass** (Piston,
  Adler): Schumann 3/IV (soft legato chorale), Brahms 1/IV (p dolce chorale, upper parts in alto clef),
  Schubert "Great" C major (pp unison).
- `[era: 19th-c. Germany / England]` Bass trombone in F (Eb in Germany, G in England), a P4 or more below
  the tenor; superseded in the 20th c. by the Bb tenor-bass with F attachment (Piston).
- `[era: 20th c.]` Alto parts were played on tenor; today many first trombonists return to the alto for
  its own parts and very high tessituras (Adler). Old alto notes too high for the tenor are sometimes given
  to a trumpet (Piston).
- `[era: French practice]` Three tenor trombones, no bass (Piston).
- `[era: Russian practice]` Trombones I–II written in alto clef even without an alto instrument (Piston).
- `[era: British brass band]` Transposing trombone and tuba parts are normal there, rare in orchestras
  (Adler-en2).

### Alto trombone in Eb (Adler-en2 charts; Piston)
- First position a P4 (5 st) above the tenor; 2nd partials I–VII = Eb3 51, D3 50, Db3 49, C3 48, B2 47,
  Bb2 46, A2 45. Range **A2–Eb5 (45–75)**, F5 (77) extreme. Pedals not feasible.
- Narrower bore: notes from about Eb3 (51) [?] down are weak and poor; the top is pure, mellow and
  brilliant, less piercing than the tenor. Always alto clef.

### Contrabass and valve trombones
- `[era: Wagner *Ring*, Strauss *Elektra*, Schoenberg *Gurrelieder*]` Contrabass trombone in Bb, an octave
  below the tenor (fundamental Bb0 = 22, inferred). Wagner used it so the trombones need not borrow the
  tuba's bass. Both Adler and Piston advise against writing for it (too taxing); its parts are played on
  tuba. `ALLOWED` only for a deliberately Wagnerian low trombone colour.
- `[era: Verdi]` The Italian contrabass trombone was valved (*Falstaff*: ppp very low repeated notes
  around C#1–F1 [?]); give such parts to the tuba.
- Valve trombone: some success in bands, `AVOID` in the orchestra: valve intonation faults and lost slide
  character; few orchestral players own one (Adler, Piston).
- Bass trumpet (Wagner): really a valved trombone, played by trombonists; concert range about E2–Bb4
  (in Bb) to G2–D5 (in D) (Adler-es). See [[trumpet]].

## Apply in MIDI / REAPER
- Classical/early-Romantic section: `ATBN` (alto, voice top 60–72, rarely ≤ 51), `TBN`, `BTBN`; keep the
  alto's line within 52–75. Without an alto sample, a tenor-trombone patch stands in (inferred).
- French impressionist colour: three tenor lines, no bass trombone; tuba (F-tuba sound) on the bass.
- Contrabass trombone parts → the `TUBA` track (or BTBN + tuba in octaves for the Wagnerian colour).
- Bass-trumpet stand-in: a trombone patch, heroic melody in 43–74 (inferred).

## Checklist
- [ ] Period section chosen on purpose (alto–tenor–bass vs 2 tenors + bass vs three tenors).
- [ ] Alto lines kept above ≈ 52; nothing above 75 except a rare F5.
- [ ] No contrabass or valve trombone tracks unless the request names that colour.
