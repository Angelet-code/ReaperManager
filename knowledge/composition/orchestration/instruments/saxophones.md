---
id: orchestration.saxophones
title: Saxophones (sopranino to bass)
aliases: [saxofón, saxofones, saxo, saxos, saxófono, saxofón sopranino, saxofón soprano, saxofón alto, saxofón tenor, saxofón barítono, saxofón bajo, sección de saxos, Saxophon, sassofono, saxofono, saxophone, sonido jazzístico, sonido clásico]
domain: orchestration
tags: [woodwinds, instrument, ranges, registers, transposition, single-reed, jazz, band]
style_scope: universal
use_when: Writing or checking a saxophone part or section (orchestral solo, jazz or pop colour, band or big-band section), or converting between written and concert pitch for saxes.
summary: All saxes read written Bb3–F6 (F#6/G6 on modern horns): alto (−9) sounds 49–80, tenor (−14) 44–75, baritone (−21) 37–68, soprano (−2) 56–87. Keep important material from a P5 above the bottom for about two octaves, no pp at the extremes. In the orchestra a sax is a featured soloist, not a blending inner voice; choose a jazz sound (much vibrato) or a symphonic sound (little vibrato) on purpose.
sources: ["adler-orq-es p.217-221", "piston-orch p.185-187"]
related: ["[[clarinets]]", "[[clarinets-auxiliary]]", "[[transposing-instruments]]", "[[woodwind-basics]]", "[[wind-band]]", "[[woodwind-section-writing]]", "[[_instruments]]"]
---

# Saxophones

## Core idea
Invented by Adolphe Sax (Paris, c.1840): metal body, wide conical bore, single-reed mouthpiece like the
clarinet's. Classed as woodwind: clarinet-like sound and reed, played by clarinettists, seated with the
woods. Fingering resembles the oboe's; fully chromatic. Every size reads the same **written** range in
treble clef: Bb3–F6 (F6 = traditional top, F#6/G6 on modern instruments).

| Sax | Written → sounding | Full (sounding) | Book top (written F6 / G6) | Best zone (written F4–D6) |
|---|---|---|---|---|
| Sopranino Eb | +3 | 61–92 | 92 / 94 | 68–89 |
| Soprano Bb | −2 | 56–87 | 87 / 89 | 63–84 |
| Alto Eb | −9 | 49–81 | 80 / 82 | 56–77 |
| Tenor Bb | −14 | 44–76 | 75 / 77 | 51–72 |
| Baritone Eb | −21 | 37–69 | 68 / 70 | 44–65 |
| Bass Bb | −26 | 32–63 | 63 / 65 | 39–60 |

Full ranges for alto, tenor and baritone are the vault defaults (to written F#6); sopranino, soprano and
bass follow Adler's chart (to written F6). Rare sizes: F sopranino (+5, inferred; Ravel *Boléro*), C soprano and C tenor.
Written zones (Piston): low keys Bb3–C#4, basic scale D4–C#5, octave key D5–C#6, top keys D6–F6.

## Rules
- R1 `MUST` transpose parts as above; Adler and Piston agree the baritone sounds an octave + M6 (−21) below.
- R2 `AVOID` very soft playing at both extremes, above all the lowest notes (written Bb3–F4).
- R3 `PREFER` important material in the best zone (written F4–D6, table).
- R4 `PREFER` the sax as a **featured soloist** in the orchestra: alto most often; soprano, tenor and
  baritone in some works. `AVOID` using it as a blending inner voice: its characteristic sound dominates.
- R5 `PREFER` choosing the sound on purpose. Jazz or popular evocation: much vibrato, sweet or stentorian.
  Symphonic sound: less vibrato, controlled dynamics.
- R6 `ALLOWED` clarinet-like agility, **except** fast tonguing: the embouchure responds a little slower.
  `AVOID` long fast single-tongued staccato: slur pairs or simplify.
- R7 `PREFER` standard band and wind-ensemble sections: 2 altos, tenor, baritone (+ bass); or soprano,
  1–2 altos, tenor, baritone (+ bass). Big band: 2 altos, 2 tenors, baritone (general knowledge).
- R8 `ALLOWED` passing one line between two saxes for a colour change (*Boléro*: F sopranino → Bb
  soprano), or a full quartet with imitative entries inside the orchestra (Strauss *Sinfonia domestica*).
- R9 `ALLOWED` extended techniques developed by virtuosi `[era: late 20th c.]`, with a description.

## Period practice
- `[era: 19th-c. French, before c.1920]` a pure, steady tone placed between horn and reed: Bizet
  *L'Arlésienne* (lyrical alto solo, p); Mussorgsky–Ravel "The Old Castle". Early tone and playing were
  thought primitive, one reason the sax never fully joined the orchestra.
- `[era: 1920s–30s]` the sax as jazz signal: Copland Piano Concerto (soprano sax with piccolo and Eb
  clarinet, accented grace notes), Gershwin *An American in Paris*.
- `[era: 1955, Piston]` the dance-band tone had become tremulous, oversweet and often out of tune, so he
  keeps the sax to featured solos or jazz flavour. Expressive exceptions: Britten *Sinfonia da Requiem*
  (alto, "alla marcia"), Rachmaninoff *Symphonic Dances* (alto), Vaughan Williams 6 (tenor).
- `[era: 2002, Adler]` playing has improved greatly since the 1920s; still mainly a soloist in the
  orchestra and a section in the band.
- Film and pop (general knowledge): an alto or tenor solo with vibrato evokes noir, jazz or late-night
  city; the section plays riffs and soli in big band and funk.

## Apply in MIDI / REAPER
- Tracks `Sop Sax`, `A.Sax`, `T.Sax`, `Bari Sax` at concert pitch. Written parts: +2 / +9 / +14 / +21.
- Check the library first: no sax library is listed among the user's owned libraries ([[user-taste]] R11).
- Solo over an orchestra: it stands out by default, so keep CC11 lower than a clarinet in the same role
  (inferred), then measure: solo about +5 dB over the bed (user taste R15).
- Jazz style: earlier, wider vibrato (CC1 if the patch maps it), scoops and falls with pitch bend
  (general knowledge). Symphonic style: delayed, light vibrato.
- Bottom fifth of each sax: no pp; CC1/CC11 floor about 40 (inferred).
- Breathe like any wind: phrases of ≈ 4–8 bars with gaps (user taste R16).

## Checklist
- [ ] Notes inside the table range for that sax; the top 2 st only on modern-instrument parts.
- [ ] Main lines in the best zone; no pp at the extremes.
- [ ] In an orchestral texture the sax is a soloist, not an inner pad voice.
- [ ] Vibrato style matches the requested genre.
- [ ] No long fast tongued staccato.

## Examples
- Alto solo, symphonic: Db4–F4–Ab4–C5 (61 65 68 72), p espressivo, light delayed vibrato.
- Sax quartet chord, concert C7: Bari C3 (48), Tenor G3 (55), Alto 2 Bb3 (58), Alto 1 E4 (64), mf.
