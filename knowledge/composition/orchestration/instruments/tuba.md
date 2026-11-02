---
id: orchestration.tuba
title: Tuba
aliases: [tuba, tubas, tuba en fa, tuba en do, tuba contrabajo, tuba baja, Basstuba, Kontrabasstuba, tuba contrabbasso, bombardón, cuarto pistón, cuarta válvula, tuba con sordina]
domain: orchestration
tags: [brass, instrument, ranges, registers, bass-line, doubling]
style_scope: universal
use_when: Writing, checking or doubling a tuba part (brass bass, sub-octave reinforcement, pizzicato-like punch under basses, lyrical solo).
summary: One orchestral tuba (F, Eb, CC or BBb, the player's choice), non-transposing, ≈ D1–G4 (26–67), practical 31–60; very powerful in C2–E3 (36–52), low notes good at any dynamic if slow, middle agile, top thin and hard to keep soft. Bass of the trombones (4-part or doubling the bass trombone), unison/octave with basses; needs frequent breaths.
sources: ["unir-orq-tema6 p.24-27", "adler-orq-es p.295-307", "adler-orq-es p.349-354", "piston-orch p.209-222", "piston-orch p.282-295"]
related: ["[[tuba-family-and-relatives]]", "[[trombone]]", "[[double-bass]]", "[[bassoons]]", "[[horn]]", "[[brass-basics]]", "[[brass-section-writing]]", "[[_instruments]]"]
---

# Tuba

## Core idea
The true bass of the brass, alongside double bass and contrabassoon. Always written **at sounding pitch,
bass clef**; a key name (F, Eb, CC, BBb) only names the tube, not a transposition. The tubist picks the
instrument per piece; MIDI uses one `TUBA` track. Types, the 4th valve, euphonium, Wagner tubas and
ophicleide: [[tuba-family-and-relatives]].

| Zone (vault default) | MIDI | Colour |
|---|---|---|
| Very low (pedal-like) | 26–37 | deep and heavy; slow notes only |
| Strong | 38–51 | very strong core bass |
| Upper | 52–62 | weaker but intense; lyrical, horn-like when soft |
| Top | 63–67 | thin, shouts, hard to control |

Full **26–67**, practical **31–60** (vault defaults). Variants: Adler: D1–F4 (26–65) for any modern tubist;
registers 26–34 deep and heavy, 36–52 very powerful, 53–65 increasingly weak but very intense. Piston:
F tuba pedals 26–29 (good, difficult), chromatic to F4 65, G4 67 extreme; safe floor for every bass tuba
Eb1 (27); never above the 8th partial. UNIR: 26–67.

## Rules
- R1 `MUST` low notes (≤ 37) as slow bass notes: then they are controlled and effective from ff to pp
  (Adler); they speak a bit sluggishly. User taste: no short notes below D2 (38).
- R2 `ALLOWED` the middle and upper register is refreshingly agile; wide leaps (two octaves) and active
  figures work, slurred or detached (Adler, Piston: Prokofiev 5, Ravel *La Valse*, Shostakovich 7).
- R3 `MUST` breath: the largest brass uses enormous air. Rest often, never tiring parts; slurs no longer
  than one breath; in slow low non-legato basses the player may breathe between notes (Adler, Piston).
- R4 `PREFER` soft legato in the middle register for the most beautiful sound (Wagner *Faust*, Mahler 1).
- R5 `AVOID` soft playing high up: the top shouts and resists subduing (Piston); near the extreme top the
  tone thins and loses character, use it only for a strained colour (Adler). Loud tuba carries over a tutti.
- R6 `PREFER` roles: (a) bass of a quartet with three trombones; (b) doubling the bass trombone (or 4th
  horn) as bass of the whole brass; (c) adding massive solidity to the tutti bass at unison or octave below;
  (d) sole bass of a wind group (Stravinsky *Jeu de cartes*) (Piston, Adler).
- R7 `ALLOWED` tuba + arco basses on the same notes: the tuba adds a pizzicato-like punch; pp tuba staccato
  can replace or double a bass pizzicato (Adler, Piston; Mahler 8).
- R8 `ALLOWED` hard attacks sffz > p < ff on sustained notes (Adler).
- R9 `AVOID` long stretches of sharp rhythmic tonguing, especially f: heavy, drags (Piston). Double/triple
  tonguing works (Piston) but is not normal in the standard orchestral repertoire (Adler).
- R10 `ALLOWED` valve trills: rare in symphonic music, very effective (Wagner *Meistersinger*).
  Flutter-tongue: 20th c., possible even ppp (Adler; Schoenberg *Erwartung*); Piston calls it very unusual.
- R11 `ALLOWED` glissando: possible but less easy than on trombone; write it ascending (Adler).
- R12 `MUST` mute (one kind only, a big cone): rests before and after, it is awkward to insert. Range:
  Adler finds it best middle-to-high; Piston finds muted high notes strained → default 45–60 (inferred).
- R13 `MUST` for a solo, name the tuba (Ravel "Bydlo" lies high, about G#4 [?], and suits the euphonium);
  otherwise most tuba parts are plain basses, neither very high nor very low (Piston).
- R14 `ALLOWED` two tubas for a bass under a large horn/trumpet section or to rest one player: tuba 1 high,
  tuba 2 low (Adler; Berlioz *Fantastique*, Strauss *Zarathustra*).
- R15 `AVOID` close intervals with other low instruments below ≈ 48; prefer 5ths/octaves (general knowledge).
- R16 `MUST` score: own staff below the bass trombone; euphonium/Wagner tubas go between them (Adler).

## Apply in MIDI / REAPER
- Track `TUBA` at concert pitch, lowest track in the BRASS folder; at or below `BTBN` at every moment.
- Lengths: below 38 a half note or longer at ≤ 100 bpm; fast figures only from ≈ 40 up.
- Breath gap ≥ 1/8 beat every 1–2 bars of loud sustained writing; never tie low slurred notes across many bars.
- Dynamics: 38–51 at CC1 80–110 anchors a brass tutti; low pp pedals CC1 20–35; notes ≥ 60 CC1 ≥ 70.
- sffz>p<ff: velocity ≈ 120, CC1 drop to ≈ 30 within 1/4 beat, swell back over 1–2 bars.
- Doubling basses: tuba on accented/important notes only, short and hard (velocity 100+), not every note.
- Muted: muted articulation/patch in 45–60, ≥ 2 bars rest each side. Pan centre rear, slightly right.

## Checklist
- [ ] Notes 26–67, mostly 31–60; nothing below 27 unless a named contrabass effect.
- [ ] No short notes below 38; leaps and runs only from ≈ 40 up.
- [ ] Breath gaps every 1–2 bars in loud sustained writing.
- [ ] No soft notes ≥ 63; top register only exceptional.
- [ ] Tuba ≤ bass trombone pitch at each moment.

## Examples
- Brass bass: C2–G2–C2 (36 43 36) half notes under trombones, f.
- Lyrical: Bb2–D3–F3–Eb3 (46 50 53 51), p legato.
- Pizz punch: tuba pp staccato on beats 1 and 3 under basses arco, G2–C3 (43 48) (staccato stays ≥ 38).
