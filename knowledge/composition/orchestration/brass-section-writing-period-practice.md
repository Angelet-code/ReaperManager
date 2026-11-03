---
id: orchestration.brass-section-writing-period-practice
title: Brass section by period (Renaissance to late Romantic)
aliases: [usos primeros de los metales, metales barrocos, metales clásicos, Turm-Musik, música de torre, coros antifonales, trompetas y timbales, trombones en la ópera, cornetas y trompetas, tubas wagnerianas, Wagnertuben, sección de metal ampliada, metales naturales]
domain: orchestration
tags: [brass, period-practice, baroque, classical, romantic, section-layout, antiphonal]
style_scope: period styles (Renaissance, Baroque, Classical, Romantic); modern default lives in brass-section-writing
use_when: Writing a brass section in the manner of Gabrieli, Handel, Haydn–Beethoven, Schubert, Wagner/Bruckner or 19th-c. French and Russian music, or reading an older score's brass.
summary: Before the Classical period brass numbers depended on the venue; Baroque works rarely let horns, trumpets and trombones play together. Classical symphonies use 2 natural horns + 2 trumpets on tonic and dominant, with trombones mostly in opera and church music and later held back for climaxes. Valve brass was fully accepted only in the 20th c.; late Romantic sections grew to 6–10 horns with Wagner tubas.
sources: ["adler-orq-es p.357-364", "adler-orq-es p.382-392", "adler-orq-es p.413-418", "piston-orch p.206-214"]
related: ["[[brass-section-writing]]", "[[natural-horn-period-practice]]", "[[trumpet-period-practice]]", "[[trombone]]", "[[tuba]]", "[[orchestra-sizes-and-section-balance]]", "[[baroque-suite]]"]
---

# Brass section by period

## Core idea
These are period styles to evoke on purpose (synthesis principle 9). For library-based MIDI the modern
section in [[brass-section-writing]] stays the default unless the request names a period or composer.
Natural-instrument pitches: [[natural-horn-period-practice]], [[trumpet-period-practice]].

## Rules
- R1 `[era: Renaissance, Gabrieli]` `ALLOWED` antiphonal brass choirs: trumpets vs trombones (about 3 + 3),
  possibly a second group in another balcony, trading block chords and imitative entries. Numbers
  depended on the hall and the players available.
- R2 `[era: 17th–18th c.]` `ALLOWED` Turm-Musik: chorale-like brass pieces played from a church tower
  (Pezel, Reiche).
- R3 `[era: Baroque]` typical forces: 2–3 horns, 3 trumpets almost always with timpani, trombones in threes.
  Trumpet and horn lines sit high (clarino fashion).
- R4 `[era: Baroque]` `NEVER` stack horns, trumpets and trombones together in one tutti if it must sound
  authentic: they usually appear in different movements. Exceptions: battle pieces, outdoor music and
  some opera scenes (Handel, *Water Music*, *Royal Fireworks*).
- R5 `[era: Baroque, Handel *Fireworks*]` `ALLOWED` horns 1–3 double trumpets 1–3 part for part (an octave
  lower in the original D crooks), oboes and violins on the same lines, timpani on tonic and dominant.
  Trumpets and horns may also alternate antiphonally.
- R6 `[era: Classical]` `PREFER` 2 horns + 2 trumpets in symphonies. Trombones were standard only in opera
  and church orchestras (Adler, Piston).
- R7 `[era: Classical]` `MUST` after an opening fanfare chord, natural horns and trumpets keep to tonic and
  dominant notes; give chromatic and harmonic filling to trombones where present (Beethoven 5, finale).
- R8 `[era: Classical–early Romantic]` `PREFER` reserve the trombones for a structural point (Beethoven 5
  finale; Schubert 9, I, pp trombone theme) ([[building-and-releasing-climaxes-symphonic]]).
- R9 `[era: early 19th c., Schubert]` `ALLOWED` trombones take the melody with low strings and bassoons,
  while natural trumpets and horns only punctuate or swell on held tones.
- R10 `[era: mid-19th c.]` Wagner and Brahms often still wrote for natural horns and trumpets; valves entered
  the orchestra only well after 1850 and were fully accepted in the 20th c. For a period sound keep
  horn/trumpet parts on natural pitches.
- R11 `[era: 19th-c. French]` `ALLOWED` trumpets + cornets in one score: trumpet on the top line, cornets
  on inner harmony (Franck; Berlioz, *Fantastique*). Today trumpets play all these parts.
- R12 `[era: late-19th-c. Russian/French festive]` `ALLOWED` cornets with Eb trumpets, plus an optional
  extra brass band doubling the tutti (Tchaikovsky, *1812*).
- R13 `[era: late Romantic]` expanded sections: Holst 6 hn + 4 tpt; Wagner *Götterdämmerung* 8 hn +
  4 Wagner tubas + bass trumpet + contrabass trombone; Schoenberg *Gurrelieder* 10 hn + 6 tpt (Piston).
  A "blanket of horns" holds four-part harmony under the orchestra ([[horn]]).
- R14 `[era: late 19th c., Wagner/Bruckner]` Wagner tubas in old notation: Bb tenor tubas sound a M9
  (−14) below written, F bass tubas a P12 (−19) below, contrabass tuba an octave (−12) below (Adler).

## Apply in MIDI / REAPER
- **Baroque festive:** `TPT` (2–3) high, on clarino figuration; timpani on I and V; horns either in a
  different movement or doubling the trumpets an octave lower; no trombones in the same tutti.
- **Classical symphony:** 2 `HN` + 2 `TPT`, pitches limited to the crook's series (I and V notes, repeated
  in tutti); no trombone track unless opera, church music or a finale climax.
- **Early Romantic:** add a trombone track (alto, tenor, bass) that stays silent or pads until a chosen
  structural moment, then plays a theme pp or ff.
- **Late Romantic:** 6–8 horns (two a4 patches or a6), Wagner tubas if the library has them (horn-like
  colour, inferred), tuba + contrabass trombone on the bass.
- **French colour:** trumpet top line on `TPT LEGATO`, the inner 3rds/6ths on a cornet or second
  trumpet patch at CC1 about 10 lower.

## Checklist
- [ ] Does a named period get its own section size (Classical: no trombones in symphonies)?
- [ ] Do natural horn/trumpet parts stay on I/V and series notes?
- [ ] In Baroque style, are the three brass families kept out of one tutti?
