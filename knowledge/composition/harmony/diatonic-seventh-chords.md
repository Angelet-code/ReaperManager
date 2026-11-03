---
id: harmony.diatonic-seventh-chords
title: Diatonic (secondary) seventh chords and the II6/5
aliases: [acordes de séptima secundarios, séptimas diatónicas, preparación de la séptima, sexta agregada, II6/5, acorde de subdominante con sexta añadida, Nebenseptakkorde, Septakkord-Sequenz, sixte ajoutée]
domain: harmony
tags: [seventh-chords, sequences, preparation, predominant]
style_scope: common-practice (7th preparation/resolution is a style law; maj7/m7 as static colour is normal in jazz, pop, film)
use_when: Using seventh chords on I, II, III, IV, VI, VII (e.g. ii7, IVmaj7, vii°7), writing circle-of-fifths seventh sequences, or the II6/5 pre-cadential chord.
summary: Secondary sevenths sound best complete, with the seventh prepared (held over from the previous chord) and resolved down a step; if a note must go, drop the fifth (or third), double the root and put the seventh on top. Parallel fifths are tolerated around them when unavoidable, never between soprano and bass. II6/5 (in C: F–A–C–D) is the classic chord before I6/4 or V.
sources: ["hindemith-1 p.48-52", "hindemith-1 p.60-72", "hindemith-2 p.18-22"]
related: ["[[diatonic-secondary-triads]]", "[[voice-leading-parallels]]", "[[cadences]]", "[[doubling-rules]]", "[[accompaniment-for-solo-line]]", "[[_harmony]]"]
---

# Diatonic seventh chords and the II6/5

## Core idea
Every diatonic triad can carry a seventh. In C: Cmaj7, Dm7, Em7, Fmaj7, Am7, Bø7; in A harmonic minor:
Am(maj7), Bø7, C+maj7, Dm7, Fmaj7, G#°7. Many can be read as a triad plus a non-chord tone. Their harshness is
softened by preparing the seventh. Chains of them form idiomatic sequences.

## Rules
- R1 `AVOID` I7 and III7 in minor; VII7 in minor (the diminished seventh) is very common.
- R2 `PREFER` Prepare the seventh: the same voice holds it as a chord tone of the previous chord.
- R3 `PREFER` Resolve the seventh down a step (general knowledge as an explicit rule; Hindemith's examples
  follow it). For VII7 and II7 of minor, resolve the tritone as in V7.
- R4 `PREFER` Use them complete (4 notes).
- R5 `ALLOWED` Drop a note for better lines: in chords without a tritone (major I7, II7, III7, IV7, VI7; minor
  IV7, VI7) and in minor VII7, drop third or fifth; in the others (major VII7; minor I7, II7, III7) drop any
  note that is neither in the tritone nor the seventh.
- R6 `MUST` When a note is dropped, double the root and put the seventh on top.
- R7 `NEVER` Double the leading tone, even when it is the root (VII7).
- R8 `ALLOWED` Parallel fifths in progressions triad/V ↔ secondary seventh or seventh ↔ seventh when
  unavoidable; `NEVER` between soprano and bass; `NEVER` in progressions of plain triads and dominants only.
- R9 `ALLOWED` Non-chord tones in inner voices at good moments; do not overload the texture.
- R10 `PREFER` II6/5 (subdominant with added sixth) in endings, before I6/4, V or V7.
- R11 `NEVER` Omit the two notes forming its characteristic second (C and D in C). The third (A/Ab) may go;
  then doubling is free, but in the incomplete form used as neighbour chord to V do not double the note that
  falls to the leading tone (C→B).
- R12 `MUST` (accompaniment) If a sung/lead line holds the chord seventh, decide whether the accompaniment
  needs it at all; never double it in the same octave. If only the accompaniment has it, put it where it
  stands out (top of the voicing).
  - *Outside this style:* maj7, m7 and m9 chords are static colours in jazz, pop and film pads — no
    preparation or resolution needed. Keep R12 anyway: a doubled seventh in unison with the lead smears it.

## Apply in MIDI / REAPER
- Circle-of-fifths sequence (C): Cmaj7–Fmaj7–Bø7–Em7–Am7–Dm7–G7–C. Voice it so two voices trade roles:
  the 7th of chord n steps down to the 3rd of chord n+1, while the 3rd of chord n is held and becomes the
  (prepared) 7th of chord n+1. Cmaj7 → Fmaj7: B→A, E held. Alternate complete and incomplete (no fifth)
  forms to keep the bass free to leap by fifths.
- In the generator, tag each 7th: `prepared` if the same voice had that pitch on the previous chord; warn on
  unprepared sevenths in `strict` mode only.
- Template (C, B/T/A/S): II6/5 F2, A3, D4, C5 → I6/4 G2, G3, E4, C5 → V7 G2, F3, D4, B4 → I C3, E3, C4, C5
  (complete V7 to incomplete I, see [[dominant-seventh]]).

## Checklist
- Sevenths prepared (strict) and resolved down a step?
- Dropped notes follow R5, root doubled, seventh on top?
- No fifths soprano–bass; leading tone never doubled?

## Examples
- Templates from the book's drills: II7–V, II6/5–I6, IV6/5–V7, VI7–V7, VII7–I, VII4/3–I6, I4/3–II6/5.
- D major chain: I I6/5 IV7 V2 I6 II7 V III7 | VI I4/3 VII4/3 III7 I6 II6/5 V4/3 VI V7 I.
- Cadence: C# minor I6–II6/5–I6/4–V7–I.
