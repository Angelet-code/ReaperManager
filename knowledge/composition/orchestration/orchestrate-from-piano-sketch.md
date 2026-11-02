---
id: orchestration.orchestrate-from-piano-sketch
title: Orchestrating from a piano sketch or MIDI reduction (step by step)
aliases: [cómo orquestar una obra, orquestar una obra de piano, orquestar desde reducción, reducción de piano, boceto, elaboración sonora, plantilla, líneas discursivas, factura, transcripción, transcripción para orquesta, arreglo, arreglo orquestal, pasar a orquesta, piano a cuatro manos, Bearbeitung, Instrumentierung]
domain: orchestration
tags: [method, workflow, piano-reduction, transcription, arrangement, melody-bass-filler, spacing, recolouring]
style_scope: universal (UNIR method + Adler ch.17 keyboard-to-orchestra principles; also fits original sketches)
use_when: Turning a piano piece, a piano-roll sketch, a lead sheet or a one-track MIDI reduction into an orchestral MIDI arrangement in REAPER.
summary: Decide first whether it is a transcription (complete piece) or an arrangement (melody only, so write a full short score first). Rank the layers (melody, bass, filler, motor), keep the register layout, translate piano idioms instead of imitating them, write crescendi by adding instruments, change colour only at phrase boundaries, and recolour repeats. Never change the harmony or form of an existing piece.
sources: ["unir-orq-tema2 p.4-10", "unir-orq-tema3 p.5", "unir-orq-tema1 p.4-15", "adler-orq-es p.666-675", "adler-orq-es p.676-689", "adler-orq-es p.291-293", "adler-orq-es p.713-715", "piston-orch p.vii-ix", "piston-orch p.461-462"]
related: ["[[orchestrate-from-piano-sketch-idioms]]", "[[orchestrate-from-piano-sketch-other-transcriptions]]", "[[orchestrate-existing-material]]", "[[texture-types]]", "[[texture-accompanied-melody]]", "[[orchestra-sizes-and-section-balance]]", "[[orchestration-errors-checklist]]", "[[dynamics-by-orchestration]]", "[[doubling-colour-and-decay]]", "[[score-and-parts-layout]]", "[[wind-band-transcription]]", "[[_instruments]]"]
---

# Orchestrating from a piano sketch or MIDI reduction

## Core idea
A **transcription** moves a finished work to a new medium; an **arrangement** starts from a melody or
lead sheet and must first get harmony and counterpoint. The goal is **instrumental clarity** (playable,
well-placed parts) and **discursive clarity** (whole lines, right balance). A piano texture holds melody,
bass and filler, often plus a motor figure: find, rank and assign them. Piano idioms:
[[orchestrate-from-piano-sketch-idioms]]. Chamber, band and odd-ensemble sources:
[[orchestrate-from-piano-sketch-other-transcriptions]], [[wind-band-transcription]].

## Rules
- R1 `MUST` Analyse from the top down: form → phrases → blocks → motivic cells. Know every harmony and
  inner line, including thematic inner voices the piano only sketches (Adler principle 5).
- R2 `MUST` Melody only = arrangement: harmonise it and write the whole piece as a piano or condensed
  score, check it, then orchestrate it like a transcription (Adler).
- R3 `MUST` Rank the layers by importance and tag each foreground or background before choosing
  instruments (Adler; UNIR melody/bass/filler).
- R4 `MUST` Know the composer's orchestral habits (favourite winds, doublings), or their period's if they
  never wrote for orchestra (Adler): Schumann → octave doublings.
- R5 `MUST` Keep the piano's register layout (*factura ancha* = wide, *estrecha* = narrow) unless you
  widen it on purpose.
- R6 `NEVER` imitate the piano; translate its idiom into orchestral idioms and keep its spirit
  (Adler principle 1).
- R7 `NEVER` change the harmony, form or phrase structure of an existing piece. Default (UNIR): add no
  notes, sections or dynamics either.
- R8 `ALLOWED` (Adler's models) thicken tutti chords, add a rhythmic layer (pizz. dance rhythm), add a
  countermelody in a contrasting section, or raise a dynamic for intensity. Tag every addition `new`
  and offer it as an A/B.
- R9 `MUST` Write crescendo, diminuendo, rubato and fermatas into the scoring itself: add instruments to
  grow, remove them to fade (UNIR; Adler principle 3).
- R10 `MUST` Simplify for many players: re-bar long irregular bars into shorter ones whose downbeats
  match the accents, and keep one meter where possible (Adler principle 2).
- R11 `AVOID` changing colour inside a melodic phrase or fugue subject, or fragmenting motives (Adler
  principle 6; UNIR). Change at phrase or fragment boundaries. `ALLOWED` for a timbre melody.
- R12 `PREFER` one colour combination per section; change colour at structural changes and on every
  return of a theme. Alter the third statement at least slightly (Adler ch.8). The last bars may return
  to the opening colours (Ravel).
- R13 `AVOID` horror vacui. A section that has played long rests before its next role (Dvořák).
- R14 `MUST` Give each line its own dynamics, articulations and exact note endings (Ravel marks even
  the smallest).

## Period practice
- `[era: Baroque]` Re-scoring for the instruments at hand was normal: free reassignment is period-correct.
- `[era: 19th c., composers transcribing their own dances]` free additions under R8.
- `[Piston 1955]` Transcription is a lesser but legitimate art that works only if you think the
  composer's thoughts; practise on piano pieces with little pianistic idiom. `[Adler 2002]` The direction
  of transcription is no value judgement: *Pictures* sounds better orchestrated, and Schoenberg's Op.43
  arguably better in the band original.
- `[era: 1937, Schoenberg's Brahms]` Eb clarinet, xylophone and heavy trumpets sound 20th-c.: use on purpose.

## Apply in MIDI / REAPER (procedure)
1. `dump_midi` the sketch. Put a marker on each phrase (`A1`, `A2`, `B1`…) and its texture type
   ([[texture-types]]).
2. Split notes into streams `SK MEL`, `SK BASS`, `SK FILL`, `SK MOTOR`, `SK CTR`; rank them (R3).
3. Per phrase, record lowest bass, highest melody and span (narrow < 24 st, wide > 36).
4. Choose the line-up ([[orchestra-sizes-and-section-balance]]) and build tracks in score order with one
   folder per family ([[score-and-parts-layout]]).
5. First pass: melody → one colour in range (vln 55–88, fl 72–93, ob 62–86, cl 50–84, hn 53–72,
   vc 48–69); bass → Vc + Cb an octave below (−12) (+ Bsn); filler → Va + Vln II,
   a wind pair, or horns if sustained. Move an octave only when the range forces it, for the whole phrase.
6. Translate idioms with [[orchestrate-from-piano-sketch-idioms]]: CC64 → held notes, strums → block
   chords, fermatas → measured lengths.
7. Dynamics: CC1 per track, with the melody one level above the filler. Crescendo = entries;
   diminuendo = drop-outs ([[dynamics-by-orchestration]]).
8. Second pass, colour: new melody colour at phrase repeats, doublings with a reason
   ([[doubling-colour-and-decay]]), tutti only at the climax.
9. Odd meters: set `timesig` per tempo change to re-bar (R10).
10. Run [[orchestration-errors-checklist]]. Then render the sketch and the arrangement for an A/B.

## Checklist
- Is every sketch note in some track, or deliberately dropped filler?
- Does each phrase keep the sketch's span within ±12 st?
- Do harmony and form match the source, with every addition tagged `new`?
- Is every track in range and suited to its agility (no fast runs on tuba, contrabassoon or low horn)?
- Do colour changes fall only on phrase or fragment boundaries?
- Is every repeat recoloured, and does every family rest somewhere?
- Are crescendi built by entries, with no CC64 left on orchestral tracks?

## Examples
- Adagio in F (UNIR): narrow spacing → melody Vln I (later Ob 1 + Bsn 1 an octave below), filler Vln I/II
  + Va staccato 8ths at mp, bass Vc + Cb at mp; fl, cl, hn and timpani rest.
