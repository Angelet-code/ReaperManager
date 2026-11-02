---
id: orchestration.orchestrate-from-piano-sketch-other-transcriptions
title: Other transcriptions (chamber group to orchestra, and scoring for whatever ensemble is available)
aliases: [transcripción de cámara a orquesta, trío sonata, concertino, ripieno, concerto grosso, recomposición, transcripción para conjuntos disponibles, conjunto escolar, orquesta de aficionados, tutti, mezzo tutti, soli, solo, sustituto, instrumento sustituto, voz principal, Hauptstimme, Nebenstimme, cifrado, bajo cifrado]
domain: orchestration
tags: [transcription, chamber-to-orchestra, substitution, amateur-ensemble, concerto-grosso, workflow]
style_scope: universal (Stravinsky/Pulcinella and Schoenberg/Brahms models; Adler's school-ensemble workflow)
use_when: Orchestrating a trio sonata, string quartet or piano quartet, or arranging any piece for a given or incomplete instrument set (a library that lacks instruments, a school or community group).
summary: For a chamber source, keep the harmony (take it from the figured bass, not a later editor), set concertino against ripieno, and let winds double outer voices only in tutti phrases, then drop out so a solo pair sounds fresh. For an odd ensemble, reduce to piano, label passages tutti/mezzo tutti/soli/solo, and substitute missing soloists by a similar instrument, then a two-instrument blend, then range and dynamic fit. Reinforce the bass and keep percussion sparse.
sources: ["adler-orq-es p.708-712", "adler-orq-es p.713-715", "adler-orq-es p.741-756", "adler-orq-es p.757-771"]
related: ["[[orchestrate-from-piano-sketch]]", "[[orchestrate-from-piano-sketch-idioms]]", "[[score-and-parts-layout]]", "[[wind-band-transcription]]", "[[orchestra-sizes-and-section-balance]]", "[[texture-secondary-melody-countermelody]]", "[[bass-line-doubling]]", "[[percussion-section-writing]]"]
---

# Other transcriptions: chamber sources and available ensembles

## Core idea
Two jobs beyond the piano piece. **Chamber → orchestra** keeps the composer's harmony and line
hierarchy but spreads them over families (Stravinsky's *Pulcinella*, Schoenberg's Brahms quartet).
**Any work → the forces at hand** treats missing instruments and weak players as constraints to solve
by substitution. A sample library that lacks an instrument is the same problem.

## Rules: chamber group to orchestra
- R1 `MUST` Know the original composer's whole style first; Adler calls it the most important
  precondition (Stravinsky studied "Pergolesi", Schoenberg Brahms).
- R2 `MUST` Keep the harmony. For Baroque music take it from the figured bass; realise it sometimes
  simpler, sometimes more contrapuntal, never against the composer's intention.
- R3 `ALLOWED` Ignore an editor's added dynamics (Stravinsky dropped Riemann's), and reinterpret
  ornaments for the new medium.
- R4 `PREFER` Concertino (solo strings) against ripieno (section strings). Winds double the outer voices
  in tutti phrases (Ob 1 a plainer Vln I line, Ob 2 the Vln II, bassoons bass and tenor, horns harmony).
- R5 `PREFER` Contrast phrases by density. Remove winds, horns and basses so the next solo (Ob + Bsn)
  sounds fresh over pp solo strings.
- R6 `PREFER` Give an inner wind (bassoon) a counter-line that reinforces the figured bass's key harmony
  notes.
- R7 `PREFER` Pass the principal voice between sections at the phrase fragments (Brahms's theme
  2 + 1 + 2 bars → three colours). Mark a new formal function (transition) with a wholly new texture.
- R8 `AVOID` doubling a melody with two strings of similar colour at the unison (Vln I + Vc); put them an
  octave apart (Schoenberg).
- R9 `PREFER` Re-bar to one meter (4/4) where possible: fewer changes, fewer ensemble problems.

## Rules: transcribing for the available ensemble
- R10 `MUST` Step 1: reduce the work to piano (four hands or two pianos for dense scores).
- R11 `MUST` Step 2: label each passage tutti, mezzo tutti, soli or solo.
- R12 `MUST` Step 3: for each solo, check for a suitable soloist. If none, substitute in this order:
  (a) a very similar instrument; (b) a blend of two that gives a similar result; (c) any instrument with
  the needed range and dynamic. Decide by experiment and analysis, not by a fixed table.
- R13 `PREFER` Give exposed solos to the best player available, even if the original used another
  instrument. Keep the weakest section out of the opening and bring it in at the intensification.
- R14 `MUST` Reinforce the bass line (Cb throughout, euphonium or alto sax at key points). Redistribute a
  missing section's function (horns, double reeds, violas) to what is there.
- R15 `PREFER` Use the piano as one ensemble member: filling tuttis, arpeggios, harp substitute,
  occasional doubled solos. `NEVER` let it play the whole reduction.
- R16 `AVOID` percussion where the piece does not clearly call for it: it covers any ensemble.
- R17 `AVOID` extreme registers for amateurs, above all the lowest notes of flute, oboe, bassoon, horn,
  trumpet and tuba.
- R18 `PREFER` A new melody colour and a new accompaniment colour at each statement of a theme.
- R19 `PREFER` Cue important lines (oboe, bassoon, viola, horn) in other parts so they survive an absent
  player ([[score-and-parts-layout]]).

## Exceptions
- Adler's model amateur group (no double reeds, horns or violas; 2nd violins in 1st position only;
  timpanist weak at retuning) is typical of school ensembles `[era: US school orchestras, 1940s–2000s]`.
  With a professional library the skill limits become optional, but the substitution order still holds.

## Apply in MIDI / REAPER
- Missing library instrument → re-voice its line on the R12 substitute in the same register (oboe → Cl,
  violin or muted trumpet; bassoon → Cl or Vc; viola → "Vln 3" + Vc 2 split). Never drop the line.
- Concertino/ripieno: one solo-strings patch set + one section set, pan alike, ripieno 1–2 CC1 levels
  lower in solo phrases.
- Mark tutti / mezzo tutti / soli / solo as project markers before choosing tracks. Count active tracks
  per marker: tutti ≥ 8, solo = 1 + accompaniment (inferred).
- School-ensemble realism (general knowledge): Vln I in 3rd position tops out at D6 (86), Vln II in 1st
  position at B5 (83); timpani with no retuning inside a passage.

## Checklist
- Does the harmony match the source's figured bass or chords?
- Does each solo have a planned substitute, chosen in the R12 order?
- Is the bass doubled through the piece, and is the piano never a running reduction?
- Is percussion present only where the source implies it?
- Do all parts stay inside comfortable ranges?

## Examples
- *Pulcinella* Sinfonia bars 1–15: tutti f with oboes on the plain violin lines; bar 7 solo Ob + Bsn over
  pp whole notes in the solo strings; Vc/Cb continuo-like 8ths.
- Schumann Quintet II for an amateur group: theme on Cl 1 (p marcato), then 2 trumpets; the march chords
  on strings pp, then on Cl 2–3 + alto sax when the trumpets lead, strings pizz.; the euphonium doubles
  the bass.
- Suppé *Poet and Peasant*: the brass chorale opening becomes a string fanfare in double stops + timp;
  the harp arpeggios go to the clarinet; the cello solo goes to a solo violin, later to the flutes.
