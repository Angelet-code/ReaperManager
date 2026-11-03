---
id: orchestration.timpani
title: Timpani
aliases: [timbales, timbal, Pauken, timpani, timbales de pedal, timbales sinfónicos, redoble, redoble de timbal, baquetas, baquetas duras, baquetas blandas, secco, seco, apagar, cambio de afinación, Pedalpauken, Paukenwirbel, timbalero]
domain: orchestration
tags: [percussion, instrument, ranges, pitched-percussion, rolls, retuning]
style_scope: universal
use_when: Writing or checking a timpani part (choosing pitches and drums, rolls and their endings, retuning time, stick choice, timpani's role in the tutti).
summary: Timpani sound as written, 36–60 (practical 38–57) on four pedal drums plus an optional piccolo; put each note in the middle of a drum, never ask for more pitches than drums, and leave rests for retuning. They reinforce the tutti bass with the brass, underline rhythm, and roll for sustain; mark every roll ending and every short (secco) note.
sources: ["unir-orq-tema7 p.5-8", "unir-orq-tema1 p.6-8", "adler-orq-es p.433, 435-436, 445-448", "piston-orch p.296-303"]
related: ["[[timpani-effects-and-period-practice]]", "[[percussion-unpitched]]", "[[mallet-percussion]]", "[[percussion-section-writing]]", "[[trumpet]]", "[[trumpet-period-practice]]", "[[brass-section-writing]]", "[[film-percussion-phrase-marking]]", "[[library-translation-table]]", "[[user-taste]]", "[[_instruments]]"]
---

# Timpani

## Core idea
Copper kettles with a head; modern drums retune with a pedal. Non-transposing, bass clef. The low drums
stand at the player's left. Effects, roto-toms and period styles (Classical two-drum writing, Beethoven,
Berlioz): [[timpani-effects-and-period-practice]].

| Drum (UNIR/Piston size; Adler's label) | Range (MIDI) | Best, mid-head (inferred) |
|---|---|---|
| 30" (Adler: 32" / 81 cm) | 38–45 (D2–A2) | 40–43 |
| 28" (71 cm) | 41–48 (F2–C3) | 43–46 |
| 25" (63 cm) | 46–53 (Bb2–F3) | 48–51 |
| 23" (58 cm) | 50–57 (D3–A3); 58 on some drums (Piston) | 52–55 |
| 21" piccolo (53 cm), optional | 53–59 (F3–B3); 60 approx. | 55–57 |

Vault default: full **36–60**, practical **38–57**. 36–37 (C2–C#2) need a 32"+ drum (Piston) or a
stretched low drum (Adler: "possible"). Above 59 only small extension drums (see the effects note).

## Rules
- R1 `MUST` Assume four drums (30/28/25/23"); the piccolo is optional (Adler). Never more distinct pitches
  in a passage than drums, and [[user-taste]] R16: at most 4 per passage.
- R2 `PREFER` The drum that puts the note mid-head: neither slack nor tight gives the best tone. In the
  F2–F3 overlap choose accordingly; F2/F#2 sound better on the 30" than on the 28" (Piston).
- R3 `MUST` Know which drum plays each note and plan every retuning. Pedals make small changes quick, but
  the player checks pitch, often while the orchestra plays in another key. Leave ≈ 1–2 beats for a small
  change at moderate tempo and a bar or more for a large one (general knowledge). Notate the change
  ("Bb → B") in a rest (Adler).
- R4 `MUST` The timpanist plays only timpani; give other percussion to other players (Adler).
- R5 `PREFER` Role: dynamic reinforcement of the tutti, above all its bass, with the brass on cadences and
  climaxes; also underline the rhythmic outline. Not a continuous layer (Piston, UNIR).
- R6 `ALLOWED` Soft timpani: a pp ostinato can be the only bass under a thin texture (Tchaikovsky 4); a pp
  roll gives atmosphere (Haydn "Drumroll").
- R7 `ALLOWED` Solos: one player on four drums (Holst *Planets*); exposed strokes alternating with the
  orchestra (Strauss *Zarathustra* C–G).
- R8 `MUST` A roll is the timpani's sustain. Notate its exact length and ending (Piston): (a) separate
  rolls, each new note accented; (b) a roll tied across the barline, no accent at the join; (c) a roll
  ending on a short unaccented release note. For a tremolo between two drums, say measured or unmeasured
  (Adler).
- R9 `MUST` Mark every duration. Timpani ring; the player damps by hand. Mark short notes staccato and add
  *secco* to an isolated short note (Piston, Adler).
- R10 `MUST` Mark dynamics precisely: every change is exposed on percussion. The dynamic range is enormous
  (Piston, Adler).
- R11 `ALLOWED` Sticks: hard = louder and clearer (also clarifies soft rhythmic figures); soft = warmer
  and more resonant; medium otherwise. Leave time for a stick change.
- R12 `ALLOWED` Agility: fast single strokes and rolls on one drum are easy. Figures across adjacent
  drums must let the hands alternate naturally. A melody needs pre-tuned drums or a pedal change per
  note.
- R13 `ALLOWED` Two drums struck together (double stops), e.g. an oom-pah waltz bass with a 2-note
  chord on beats 2–3 (Adler).

## Apply in MIDI / REAPER
- Track `TIMP`, own player, pan centre, rear depth with the brass. Reason in concert pitch, then check the
  patch's key mapping: **Symphony Series Timpani** plays concert + 12 (hit keys 48–71 sound an octave
  lower; low D2 = key 50). Its keyswitches are 36 hits, 38 tremolo roll (CC1 dynamics), 40 crescendo
  roll, 41 flam ([[library-translation-table]]). Darwin Percussion Ensemble has no timpani.
- Pitch plan first: list the pitches per passage (≤ 4), assign each to a drum in the table, keep it in
  the "best" column, and check the gaps between pitch changes on one drum.
- Velocity = dynamics (inferred): p 40–60, mf 70–85, f 90–110, accented ff 115–127. Repeated strokes ±5
  jitter.
- Roll: the roll keyswitch with CC1 drawn like the hairpin. Case (a) starts a new note with a velocity
  bump of about +10. Case (b) keeps one long note over the barline. Case (c) ends with a release note of
  0.25–0.5 beat at the roll's final level. Fallback: 32nd single strokes, velocity ±8 (inferred).
- Secco: a short note (≤ 0.25 beat) only if the patch damps on note-off; otherwise use a short/damped
  articulation.
- Climax pickup: 16ths on one or two drums rising 90 → 115 into the downbeat, with the brass.

## Checklist
- [ ] All notes 36–60 in concert pitch, mostly 38–57; library key offset applied.
- [ ] ≤ 4 distinct pitches per passage; each change has its rest.
- [ ] Each roll has a defined length and ending; short notes are short or secco.
- [ ] Timpani sit with brass/tutti accents and cadences, not in every bar.
- [ ] Timpani track holds no other percussion.

## Examples
- Film ostinato in E minor: E2 (40), B2 (47), E3 (52) on 30"/25"/23" drums, f, hard sticks.
- Soft bass: pp A2–E3 (45, 52) eighths alone under p strings, soft sticks.
- Roll into a tutti: roll on D3 (50) p → ff over 2 bars, accent on the downbeat, release 0.5 beat.
