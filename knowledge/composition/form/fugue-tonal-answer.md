---
id: form.fugue-tonal-answer
title: Fugue answer — real vs tonal, mutation algorithm
aliases: [respuesta tonal, respuesta real, respuesta plagal, mutación, cabeza del sujeto, tono de la tónica, tono de la dominante, tonal answer, real answer, tonale Beantwortung, reale Beantwortung]
domain: form
tags: [fugue, answer, mutation, counterpoint, algorithm]
style_scope: baroque
use_when: When generating the answer to a fugue subject (or any fugal entry at the dominant) and deciding where to place mutations.
summary: Default = real answer (+7 semitones). Make it tonal when the subject's head or ends involve tonic/dominant - scale degree 1 is answered by 5 and 5 by 1; bracket the subject into tonic-key (answer +7) and dominant-key (answer +5) fragments, mutate where the dominant-key fragment ends, never reverse an interval's direction, hide the mutation, verify by harmonising, and fall back to a real answer when the tonal one ruins a characteristic interval.
sources: ["zamacois-formas p.87-117 (§84-92)", "zamacois-formas p.269-275 (App. C-E)"]
related: ["[[fugue]]", "[[school-fugue-plan]]", "[[imitation-and-canon]]", "[[modulation]]"]
---

# Fugue answer — real vs tonal

## Core idea
In a fugue in C (major or minor) only two keys exist: **tonic key (T)** and **dominant key (D)**. A **real**
answer transposes everything a 5th up (+7). A **tonal** answer keeps the tonic↔dominant exchange: material
heard as tonic key is answered in the dominant key (+7) and material heard as dominant key is answered in the
tonic key (+5); the seam is the **mutation** (§59, §85–89).

## Rules
- R1 `MUST` Tonic ↔ dominant at the edges: if the subject begins and/or ends on 1, the answer has 5 there,
  and vice versa (§87a).
- R2 `MUST` A tonic appearing before the end of the **head** (opening segment) is answered by 5, even if the
  subject started elsewhere; a 1→5 motion in the head is answered 5→1 (§87b–c).
- R3 `MUST` Elsewhere, 1 is answered by 5 only inside T fragments, and 5 by 1 only inside D fragments; a
  fragment is D only if D's accidentals (F# in C) are present or clearly implied (§88).
- R4 `MUST` Mediating notes between the first 1 and the first 5 of the head: if the last of them is 1 or 3
  (repeated tonic or its third), the whole group is T; otherwise the whole group is D (Gedalge, §89).
- R5 `MUST` D→T anywhere: the D fragment ends **at** that dominant note; the next note is already T (§89).
- R6 `MUST` A mutation changes one answer note by a step relative to strict transposition and may **never
  reverse the direction** of an interval (ascending stays ascending; a 2nd may become a unison) (§86).
- R7 `MUST` Subject ending on 3 → answer ends on 7 of the tonic key = 3 of the dominant (C major E→B;
  C minor Eb→Bb, never the leading tone) (§88).
- R8 `MUST` Chromatic fragments: mutate at the **start** of the chromatic run; easier: drop chromatic notes,
  answer the diatonic skeleton, reinsert chromatics (§89).
- R9 `PREFER` Choose among candidate answers by harmonising subject and answer: keep harmonic functions
  (a suspension stays a suspension), keep "soft"/"hard" interval character, hide the mutation on a rest or
  weak note, prefer the answer that allows stretto (§89).
- R10 `MUST` Real answer when the subject begins and ends in T and 5 is absent or only a passing/neighbour
  note (§90).
- R11 `ALLOWED` Real answer even where rules ask for tonal, when the tonal one is poor: 5 reached from
  diatonic 4; VI–V semitone; sequences; chromatic scales; characteristic dim7/aug2 intervals; arpeggio of
  I starting on 1 (§91). Bach answers near-identical subjects both ways (App. C).
- R12 `ALLOWED` Plagal answer (at the 4th above, subdominant) — rare; avoid in school fugue (§92).

## Algorithm (C major / C minor; adapt by transposition)
1. Mark scale degrees of every subject note; identify the head (first motif, up to the first long note or
   about the first bar).
2. Bracket fragments T or D (R2–R5); with no D fragment and no 5 at the edges/head → real answer, stop.
3. Answer pitch = subject pitch **+7** for T notes, **+5** for D notes (diatonic: in C, D fragment F#→B
   etc.; in minor use the D key g minor / tonic c minor accidentals).
4. Check every interval direction (R6) and the end degree (R7); move the mutation to a rest/weak beat if two
   positions are legal.
5. Harmonise both (I/V in subject ↔ V/I in answer, R9); if a characteristic interval breaks or a semitone
   becomes a unison/aug 2nd, switch to a real answer (R11).

## Apply in MIDI / REAPER
- Worked example 1 (tonal, starts on 5): subject G4 C5 B4 C5 D5 E5 D5 C5 = 67 72 71 72 74 76 74 72.
  G = D fragment (+5) → C5 72; rest is T (+7) → G5 F#5 G5 A5 B5 A5 G5. Answer: 72 79 78 79 81 83 81 79.
  First interval +5 becomes +7: direction kept.
- Worked example 2 (tonal, 1→5 in head): subject C4 E4 D4 E4 G4 = 60 64 62 64 67. Mediating group ends on E
  (3) → T (+7); final G is D-side → +5. Answer G4 B4 A4 B4 C5 = 67 71 69 71 72 (E→G +3 becomes B→C +1).
- Worked example 3 (real): C4 D4 E4 C4 → G4 A4 B4 G4 (all +7).
- Place the answer in the next voice's register (octave shifts allowed: ±12 on the whole answer).

## Checklist
- Do start/end degrees follow 1↔5 (and 3→7)?
- Is every interval direction preserved?
- Is there at most the necessary number of mutations, placed at fragment seams?
- Does the harmonised answer keep the subject's functions? If not, is a real answer better?

## Examples
- WTC I/7 (Eb): one Eb functions as IV of the D key and is answered Ab; of three Bb's only the first and last
  get Eb (§88).
- Chromatic subject C–C#–D–D#–E–F–F#–G: unanimous real answer (§91).
