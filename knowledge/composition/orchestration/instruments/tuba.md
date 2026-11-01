---
id: orchestration.tuba
title: Tuba
aliases: [tuba, tubas, tuba en fa, Basstuba, Tuba, tuba contrabbasso, tuba tenor, bombardino]
domain: orchestration
tags: [brass, instrument, ranges, registers, bass-line]
style_scope: universal
use_when: Writing, checking or doubling a tuba part (brass bass, sub-octave reinforcement, lyrical solo).
summary: Orchestral F tuba, non-transposing, ≈ D1–G4 (26–67) [range approximate]; very strong in D2–D3 (38–50), heavy and slow at the very bottom, thin and hard to control at the top. Lowest notes only in slow motion; the middle is surprisingly agile but needs frequent breaths; the most beautiful sound is soft legato in the middle.
sources: ["unir-orq-tema6 p.24-27"]
related: ["[[trombone]]", "[[double-bass]]", "[[bassoons]]", "[[horn]]", "[[_instruments]]"]
---

# Tuba

## Core idea
The brass bass, joined the orchestra in the 2nd half of the 19th c. (Wagner, Mahler, Strauss). The player
chooses the tuba per piece; the orchestral standard here is the **12-foot F tuba**, written at concert pitch
(a Bb tuba exists for bands, also non-transposing in orchestral notation). Bass clef.

| Zone | MIDI | Colour |
|---|---|---|
| Very low (lowest four ≈ pedal tones) | 26–37 | deep and heavy; good quality but hard to get; slow notes only |
| Strong | 38–51 | very strong: the core bass zone |
| Upper | 52–62 | weaker but intense; lyrical solo zone (general knowledge) |
| Top | 63–67 | thin, can be shrill, hard to control |

Full range **26–67** (both ends read from a small figure [?]); practical **31–60** (general knowledge).
CC/BBb contrabass tubas reach lower (≈ 22–28) (general knowledge).

## Rules
- R1 `MUST` write the very low notes (26–37) only in slow motion (half notes or longer at moderate tempo);
  there they work at any dynamic, ff to pp.
- R2 `ALLOWED` agility in the middle register is better than expected, but `MUST` leave frequent breaths
  (huge air use): ≈ a rest every 1–2 bars in loud sustained passages (inferred).
- R3 `AVOID` the top register (63–67): thin, loses character.
- R4 `PREFER` soft legato phrases in the middle register for the most beautiful tuba sound.
- R5 `PREFER` role: bass of the brass section; reinforcing the double basses an octave below or in unison
  in tutti; occasional solos (Mussorgsky/Ravel "Bydlo", usually on a smaller tenor tuba — the leap
  C#–G# is very hard on F tuba).
- R6 `PREFER` doublings: tuba + bass trombone (octave/unison), tuba + double basses, tuba + contrabassoon,
  tuba + timpani roll on a tonic pedal (general knowledge).
- R7 `AVOID` close intervals between tuba and other low instruments below ≈ 48: keep 5ths/octaves (muddy
  otherwise) (general knowledge).

## Apply in MIDI / REAPER
- Track `Tuba` at concert pitch.
- Articulations: sustain/legato, marcato/short (velocity), sfz swells.
- Note length: notes in 26–37 at least a half note at ≤ 100 bpm; short stabs there blur (inferred from R1).
- Dynamics: 38–51 at CC1 80–110 anchors a brass tutti; pp low pedals at CC1 20–35 work.
- Pan: centre rear, slightly right.

## Checklist
- [ ] All notes 26–67; mostly 31–60.
- [ ] No fast notes (shorter than a quarter at moderate tempo) below 38.
- [ ] Rests/breath gaps every 1–2 bars in loud sustained writing.
- [ ] Top register (≥ 63) only exceptional.
- [ ] Tuba is the lowest brass voice and ≤ the bass trombone pitch at each moment.

## Examples
- Brass bass: C2–G2–C2 (36 43 36) half notes under trombones, f.
- Lyrical: Bb2–D3–F3–Eb3 (46 50 53 51), p legato.
