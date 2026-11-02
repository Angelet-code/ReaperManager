---
id: orchestration.score-and-parts-layout
title: Score order, parts and cues (track order, family folders, doublings, substitutes)
aliases: [orden de la partitura, partitura general, partitura reducida, partitura abreviada, partitura condensada, reducción a piano, partes, particellas, notas de entrada, notas guía, cues, muta in, cambiar a, letras de ensayo, números de ensayo, vuelta de página, a2, zu 2, get., zus., Partitur, Stimmen, Stichnoten]
domain: orchestration
tags: [score-layout, track-order, template, doubling, cues, substitution, condensed-score, parts]
style_scope: universal (modern concert practice; band order differs, see wind-band)
use_when: Ordering and grouping tracks for an orchestral template, placing extra instruments (saxes, euphonium, Wagner tubas, alto flute), planning player doublings (muta in), exporting a condensed score or piano reduction, or covering a missing instrument with a cue.
summary: Score order = track order. Woodwinds (picc, fl, ob, Eng hn, small cl, cl, bass cl, bsn, cbsn), then brass (hn, tpt, trb, tuba), timpani and percussion, harp, keyboards, then strings (Vln I, Vln II, Va, Vc, Cb), with one folder per family. Extras go inside their family. One track per player-part, each with its own dynamics. A condensed score is 3–4 concert-pitch staves; a piano reduction drops octave doublings. Cue important lines so a missing player or patch never loses them.
sources: ["adler-orq-es p.757-771", "adler-orq-es p.772-784"]
related: ["[[orchestral-mockup-template]]", "[[stage-seating-pan-depth]]", "[[orchestra-sizes-and-section-balance]]", "[[transposing-instruments]]", "[[wind-band]]", "[[orchestrate-from-piano-sketch-other-transcriptions]]", "[[percussion-section-writing]]", "[[horn]]"]
---

# Score order, parts and cues

## Core idea
The score's order groups instruments by family so a conductor sees the sections at a glance. In a
REAPER template it becomes track order and folder structure, and it fixes where extra instruments go.
Parts and cues matter here only where they affect doubling (one player switching instruments) and
substitution (keeping a line alive when an instrument is missing).

## Rules
- R1 `MUST` Full-orchestra order, top to bottom:
  - woodwinds: piccolo, Fl 1–2, Ob 1–2, English horn, D/Eb clarinet, Cl 1–2 (Bb/A), bass clarinet,
    Bsn 1–2, contrabassoon;
  - brass: Hn 1–4, Tpt 1–3, Trb 1–3, tuba;
  - timpani (state the number of drums), percussion (list every instrument at the start);
  - harp, piano or celesta;
  - strings: Vln I, Vln II, Va, Vc, Cb.
- R2 `MUST` Keep visible gaps between families: woodwinds | brass | percussion | harp & keyboards |
  strings.
- R3 `MUST` Extras sit inside their family. Saxophones go between bass clarinet and bassoons; euphonium
  or Wagner tubas between trombones and tuba. Alto flute goes below the flutes (usually Fl 3). A
  dedicated piccolo sits above the flutes; a doubling piccolo stays on its player's line.
- R4 `ALLOWED` `[era: some North American scores]` saxophones below the bassoons, or below the brass just
  above the timpani.
- R5 `PREFER` Player doublings: Ob 2/3 → English horn, a clarinettist → bass clarinet, a bassoonist →
  contrabassoon, Fl 2/3 → piccolo. Mark "muta in X" early, and leave rests for the switch.
- R6 `PREFER` Horns 1–2 on one staff and 3–4 on the other. Use 1–3 and 2–4 only when the horns play many
  unison passages (1 and 3 are the high horns). Trumpets: Tpt 1 alone, 2–3 together. Trombones: 1–2
  tenor, bass trombone on its own staff.
- R7 `MUST` Two instruments sharing a staff still get separate parts and their own dynamics where these
  differ.
- R8 `MUST` Rehearsal letters or numbers (or bar numbers every 5–10 bars) in score and parts. A
  rehearsal mark or meter change breaks a multi-bar rest.
- R9 `MUST` A condensed score is written entirely at concert pitch on 3–4 staves (about one per
  section). It keeps the essential melody, bass, rhythm and harmony.
- R10 `PREFER` A piano reduction is two staves for two hands. It drops redundant octave doublings and
  keeps melody, bass and inner harmony.
- R11 `PREFER` Cue notes in a part before a re-entry after long rests, transposed to that part's key.
- R12 `PREFER` For school or incomplete orchestras, cue important lines in other parts, and show every
  cue in the full score too:
  - oboe or English horn → clarinet, violin or muted trumpet, by register;
  - bassoon → clarinet or cello (or an extra tenor-sax part);
  - missing violas → split the part between a "violin 3" and cello 2.
  A substitute never matches the original timbre, but the line survives.
- R13 `MUST` Wind and brass parts need rests at page turns. In strings the inside desk turns while the
  outside plays, so avoid exposed string passages at a turn (half the section drops out).
- R14 `MUST` When parts share a staff in notation software, write every accidental the extracted parts
  need, and proof-read the ties at system breaks.

## Period practice
- `[era: 1960s–early 1970s, after Stravinsky]` The cut-away score shows a staff only while the instrument
  plays. It is no longer popular. Reduced pages after page 1 (only the playing instruments, same order)
  are still standard.
- `[era: jazz scores]` Clefs and key signatures dropped after page 1. `AVOID` in concert scores.
- `[era: band tradition]` Condensed scores labelled "reeds" (= all woodwinds), "high reeds 8va / brass
  loco", "low reeds & brass". Band order differs (flutes above piccolo): see [[wind-band]].

## Apply in MIDI / REAPER
- Build templates in R1 order. One folder bus per family (`WOODS`, `BRASS`, `PERC`, `HARP-KEYS`,
  `STRINGS`), each an empty bus, coloured per family ([[orchestral-mockup-template]]).
- One MIDI track per player-part (Hn 1, Hn 2…), or one per shared staff (`Hn 1-2`) when they always move
  together. Give each its own CC1/CC11 when the dynamics differ (R7).
- A player doubling (Fl 2 ↔ Picc) is two tracks, but they never sound at once. Check at least ~2 bars of
  rest before each switch (general knowledge; Adler only says "early enough").
- Missing library patch: re-voice the line on the R12 substitute in the same register.
- "Condensed" export for a sketch: 3–4 concert-pitch tracks (`WW`, `BR`, `STR`, `PERC`). A piano
  reduction: 2 tracks with octave duplicates removed.
- Rehearsal letters = REAPER project markers (`A`, `B`… or bar numbers) at section starts and meter
  changes.

## Checklist
- Are tracks in R1 order with one folder per family, and extras inside their family?
- Does each player-part have its own track or a shared track with matching dynamics?
- Do doubling players never play both instruments at once, with rests before each switch?
- Does every missing instrument's line exist on a substitute track?
- Are there markers at every section and meter change?
