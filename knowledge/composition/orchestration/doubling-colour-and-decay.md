---
id: orchestration.doubling-colour-and-decay
title: Doubling by colour, construction and decay
aliases: [doblajes, doblaje, octavación, doblar por color, doblar por envolvente, unísono de timbres, refuerzo, brillo, duplicación al unísono, duplicación a la octava, colores puros, peso sonoro, empalme de timbres, doblaje parcial, doblaje encubierto]
domain: orchestration
tags: [doubling, colour, decay, timbre, sparkle]
style_scope: universal (method from film scoring; examples classical and film)
use_when: Deciding which instrument should double a line (melody, pizzicato, bell figure, ostinato), or checking whether a passage is over-doubled.
summary: Double a layer only when it needs more definition, weight, colour or a specific emotion. Choose the doubler by colour (similar timbre), construction (brass-built, wood-built) or decay type (pizz with harp or piano, mid-decay bells with celesta or vibes), not by range. Reinforce at the octave rather than in unison, keep pure colours when no tutti is needed, count doublers by dynamic (one per octave at p, a2 at f), add doublers through a crescendo and remove them for a diminuendo. Over-doubling removes the colour changes that make an orchestration live.
sources: ["film-4day-challenge slide 6", "unir-orq-tema2 p.7-10", "unir-orq-tema7 p.13-16", "unir-orq-tema8 p.9-11, p.16", "httyd-test-drive p.3-8", "adler-orq-es p.230-240", "adler-orq-es p.276-282", "piston-orch p.426-430", "piston-orch p.436-443"]
related: ["[[doubling-colour-and-decay-section-pairings]]", "[[woodwind-section-writing]]", "[[woodwind-section-writing-with-strings]]", "[[bass-line-doubling]]", "[[line-separation-and-fusion]]", "[[texture-unison-and-tutti]]", "[[chord-voicing-family-stacking]]", "[[_instruments]]"]
---

# Doubling by colour, construction and decay

## Core idea
Doubling widens the palette, letting a line take on a new mixed colour. Too much doubling does the
opposite: with everything doubled all the time, nothing can change colour. Group doublers **by colour,
not by range**.

## Method (four steps)
1. Pick the instrument for the layer (e.g. the melody instrument).
2. Decide what the layer needs: **definition**, **weight**, **expanded colour**, or a specific
   **emotion**.
3. Choose the doubling criterion: colour, construction, decay type, or emotion.
4. Choose the doubling instrument(s) and the octave.

## Rules
- R1 `PREFER` Doublers of similar colour: cello + bassoon; double reeds + muted trumpet; string pizz +
  harp.
- R2 `PREFER` Doublers of similar decay envelope:
  - **Fast fixed decay:** pizz strings, piano, harp.
  - **Medium fixed decay:** tubular bells, celesta, crotales, vibraphone.
  - **Variable (sustaining):** bowed strings, winds, brass.
- R3 `ALLOWED` Doublers of similar construction: brass-built (brass section, tubular bells, cymbal,
  tam-tam) or wood idiophones (wood blocks, marimba).
- R4 `AVOID` Doubling everything all the time. Keep at least one layer undoubled in each section, and
  change doublings at section boundaries.
- R5 `MUST` The melody must not be buried by octave doublings of bass or filler.
- R6 `ALLOWED` Doubling a melody at a lower octave with a contrasting wind (oboe + bassoon an octave
  below, UNIR Adagio).
- R7 `PREFER` (film) Cellos in their high register (treble clef) double a mid-register tune **at the same
  pitch**. This adds body without lowering the line (HTTYD).
- R8 `PREFER` Ornaments only in the solo colour instrument; the doublers play the plain skeleton.
- R9 `ALLOWED` Sparkle doubling: glockenspiel two octaves up, xylophone for dry rhythmic doubling, vibes
  for a soft halo, celesta for magic.
- R10 `AVOID` Glockenspiel or celesta doubling in ff tutti passages: they are inaudible there. Use them
  in f-or-softer sections.
- R11 `PREFER` Reinforce at the **octave** (organ 8' + 4' + 2') rather than in unison. A unison changes
  colour, like a mute, more than it adds clarity; stacking more unisons clouds the line (Adler).
- R12 `PREFER` **Pure colours** when no tutti is needed: score the line for part of the orchestra with few
  unison doublings. Unisons add tone-weight, not transparency (Piston).
- R13 `MUST` Count doublers by dynamic: at p one doubler per octave; at f a wind doubling strings or brass
  needs two or more players on its line (Piston). Cross-family recipes:
  [[doubling-colour-and-decay-section-pairings]].
- R14 `PREFER` Let doublings **accumulate** through a crescendo and **remove** them one by one for a
  diminuendo; keep the top octave (piccolo) for the climax (Piston, Adler).
- R15 `ALLOWED` Partial doubling (a few notes or bars) for intensity, an accent or a colour change; a
  doubler may slip in "under cover" in unison and surface on the cadence's top notes (Schubert 8/I).
- R16 `MUST` When a line runs past one instrument's range, hand it to another colour where the two
  registers are close in colour, overlapping at least one note (**joining colours**, Piston: Bcl → Bsn →
  Cl 2 → Cl 1 → Ob → Fl).

## Apply in MIDI / REAPER
- Create doublers as **separate tracks** with copied notes, never as extra notes inside the lead track.
  Each doubler gets its own CC1 lane, set 5–15 below the lead so the lead colour wins.
- **Doubling lookup:**
| Lead layer | Need | Doubler track | Transposition |
|---|---|---|---|
| String pizz bass or ostinato | definition | HARP (+ PIANO) | same pitch; piano can add −12 |
| Flute or woodwind melody | colour, support | HARP arpeggio accompaniment | — |
| Bell-like melody | sparkle | CELESTA / VIBES / CROTALES | celesta same or +12; crotales +24 |
| Melody in 62–74 | body | VC (treble register) | same pitch |
| Oboe melody | weight | BSN | −12 |
| Cello melody | warmth | BSN or HN | same pitch |
| Horn melody | definition | VLN II | same pitch (HTTYD) |
| Trumpet stab | weight | HN pair + TBN | chord tones, same rhythm |
| Melody in a quiet section | sparkle | GLOCK | +24 (check whether the patch already transposes) |

- **Copy rule:** copy pitch, beat and len exactly. Keep velocities, then subtract 10 for doublers. Humanize
  each copy separately (±5–10 ms) so they don't phase.
- **Range clamp:** after transposing a copy, reject notes outside the doubler's range rather than
  folding single notes by octave. Folding breaks the line (UNIR's "cut lines" error). Move the whole
  phrase instead.
- **Doubling budget:** in a 4-layer texture, at most 2 layers with more than 2 doublers each.
- **Hand-off (R16):** split a long run across tracks; each new track starts on the previous track's last
  note (same pitch, both sounding for that note), at a pitch where both instruments are in a middle
  register.
- **Crescendo/diminuendo (R14):** add doubler tracks at bar lines as CC1 rises; in a diminuendo end doubler
  phrases one by one before lowering the lead.

## Checklist
- Does each doubling serve a stated need (definition, weight, colour, emotion)?
- Do the doublers share colour, construction or decay type with the lead?
- Is at least one layer per section left undoubled, and do doublings change between sections?
- Is there no celesta or glockenspiel in ff tutti?
- Is no doubled phrase folded by octave mid-phrase?
- Is the lead track's CC1 above its doublers'?
- Are reinforcements at the octave unless a unison colour or tutti weight was chosen?
- At f, is every wind doubling strings or brass at least a2?
- Does a line that exceeds one range overlap one note at each hand-off?
