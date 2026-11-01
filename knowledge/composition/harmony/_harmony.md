---
id: harmony.moc
title: Harmony — map of content
aliases: [armonía, armonía tradicional, índice de armonía, Harmonielehre]
domain: harmony
tags: [moc, index]
style_scope: common-practice (with "Outside this style" notes per rule)
use_when: Entry point for any harmony task (progressions, voicings, bass lines, harmonizing a melody, modulation, tension planning); pick 3–6 notes from the tables below.
summary: Tonal harmony distilled from Hindemith's Traditional Harmony I–II, written for MIDI generation. Rules are common-practice style laws unless marked universal; each note says how strict a rule is for film/pop/rock writing.
sources: ["hindemith-1", "hindemith-2"]
related: ["[[_form]]", "[[_orchestration]]", "[[_film-scoring]]", "[[glossary-harmony]]", "[[hindemith-1]]", "[[hindemith-2]]"]
---

# Harmony — map of content

Precedence: Hindemith teaches common-practice harmony (c.1600–1900) as school exercises. Treat
`MUST/NEVER` rules as laws **only** for chorale, classical and romantic textures; for film, pop and rock
read each rule's *Outside this style* line. Smoothness principles (common tones, nearest-voice motion,
wide spacing at the bottom) are universal. Spanish/German terms: [[glossary-harmony]].

## Reading order for beginners
1. [[four-part-voices-and-spacing]] — the voice skeleton and ranges in MIDI.
2. [[voice-leading-basics]] — how chords connect.
3. [[voice-leading-parallels]] — the checker every generated texture must pass.
4. [[cadences]] — how phrases end and keys are confirmed.
5. [[harmonic-planning-seven-factors]] — plan before generating.

## Voices and voice-leading
| note | use_when | summary |
|---|---|---|
| [[four-part-voices-and-spacing]] | Laying out a progression as four concrete MIDI voices | SATB ranges 60–79 / 55–74 / 48–67 / 40–60; S–A, A–T ≤ 12 semitones |
| [[doubling-rules]] | Choosing which chord member to double or drop | Root first; never leading tone or seventh; 6/4 doubles the bass |
| [[voice-leading-basics]] | Connecting chords smoothly in any sustained part | Hold common tones, nearest tone, upper voices against the bass in IV–V |
| [[voice-leading-parallels]] | Validating MIDI for parallel/hidden 5ths and 8ves | Checker algorithm, strictness modes, licences, NCT handling |
| [[non-chord-tones]] | Melodies faster than the harmony; suspensions | Each NCT type with approach, leave and metric rule |

## Chords
| note | use_when | summary |
|---|---|---|
| [[triads-and-inversions]] | Chord quality per degree; root, 6 or 6/4 | Harmonic minor qualities; 6/4 only cadential, passing, pedal |
| [[diatonic-secondary-triads]] | Adding II, III, VI, VII; deceptive cadence | Diminished triads in 6 with doubled third; V→VI |
| [[dominant-seventh]] | Placing and resolving V7 and inversions | LT up, 7th down; V6/5→I, V4/3→I/I6, V2→I6 |
| [[dominant-ninth-and-thirteenth]] | Colouring V with 9th or 13th | Drop the 5th, colour tone on top, resolve as V7 |
| [[diatonic-seventh-chords]] | ii7, IVmaj7, sequences, II6/5 | Prepare the seventh, resolve down; fifths tolerated except S–B |

## Chromatic harmony
| note | use_when | summary |
|---|---|---|
| [[secondary-dominants]] | Emphasising a non-tonic chord with V7/x | Third up a semitone, 7th down; use few |
| [[mode-mixture-and-neapolitan]] | Borrowed iv, bVI, Neapolitan, Picardy | Mid-piece colour; Nap6→V with diminished third allowed |
| [[augmented-sixth-chords]] | German/French/Italian sixth, augmented dominant | Aug 6th expands to the octave on V; fifths tolerated |
| [[diminished-seventh-pivot]] | Fast or ambiguous key change via dim7 | Any tone = leading tone → 4 target roots |

## Keys, phrases and procedures
| note | use_when | summary |
|---|---|---|
| [[cadences]] | Ending phrases; confirming keys | V–I strongest; plagal softer; half/Phrygian open; final = root-position I |
| [[modulation]] | Changing key or planning a tonal route | Cadence → pivot → new cadence; direct shifts rare |
| [[harmonizing-a-melody]] | Adding chords/bass/pad under a melody | Harmonic rhythm, NCTs, main chords on accented bars, bass first |
| [[figured-bass-reading]] | Realising a given bass or figures | Figure table; lone accidental = third; top melody first |
| [[accompaniment-for-solo-line]] | Writing the accompaniment for a solo | Sections/keys → bass skeleton → texture → harmony |

## Planning, texture and instruments
| note | use_when | summary |
|---|---|---|
| [[harmonic-planning-seven-factors]] | Pre-generation per-bar plan of any piece/cue | Form, key, oscillation, gradient, density, style, voices; reduce the others |
| [[harmonic-texture-and-voice-count]] | How many voices; crescendo by thickening | 4 default; 3 only for simple harmony; accent by density on pads |
| [[harmony-voicing-for-instruments]] | Turning a progression into strings/brass/piano/pad notes | Wide at the bottom, no thirds below ~C3, melody alone on top |

## Related domains
- Form and phrase structure: [[_form]]. Instruments, doublings and balance: [[_orchestration]].
  Cues, tension under picture: [[_film-scoring]]. Sources: [[hindemith-1]], [[hindemith-2]].
