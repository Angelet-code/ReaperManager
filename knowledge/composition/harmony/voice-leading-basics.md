---
id: harmony.voice-leading-basics
title: Voice-leading basics (common tones, shortest path, contrary motion)
aliases: [conducción de voces, enlace de acordes, nota común, movimiento contrario, movimiento directo, movimiento oblicuo, grado conjunto, salto, Stimmführung, Akkordverbindung, liegenbleibender Ton]
domain: harmony
tags: [voice-leading, four-part, smoothness]
style_scope: common-practice (common tones + shortest path = universal smoothness principle for pads, strings, choir)
use_when: Connecting one voiced chord to the next in any sustained multi-voice part (choir, strings, brass, pad) so the inner voices move smoothly.
summary: Write the bass, keep common tones in the same voice, move the other upper voices to the nearest tone of the next chord (step, or leap ≤ P4); when bass and harmony have no common tone (IV–V) move the upper three against the bass. Never all four voices leaping the same way; leaps are fine when the harmony stays the same.
sources: ["hindemith-1 p.4-11", "hindemith-1 p.12-17", "hindemith-1 p.18-24", "hindemith-1 p.34-38", "hindemith-1 p.48-52", "hindemith-2 p.11-18"]
related: ["[[four-part-voices-and-spacing]]", "[[voice-leading-parallels]]", "[[doubling-rules]]", "[[harmony-voicing-for-instruments]]", "[[_harmony]]"]
---

# Voice-leading basics

## Core idea
Hindemith's connection procedure: bass first, first chord complete, hold what can be held, move the rest the
shortest way. Motion types: **similar/direct** (same direction), **contrary**, **oblique** (one voice holds).
Early exercises are strict; later chapters allow larger leaps and augmented/diminished steps when they make
the lines more fluent. The top voice must still be a melody, not a crawl.

## Rules
- R1 `MUST` Procedure: (a) write the bass move; (b) complete the first chord; (c) keep a common tone in the
  same voice; (d) move the remaining upper voices by step to the nearest tones of the next chord.
- R2 `MUST` If two tones could be held, hold one and move the other the shortest way (a leap of a third).
- R3 `MUST` If no tone can be held, move each upper voice the shortest way: step, or leap of at most a P4
  (5 semitones).
- R4 `MUST` IV–V and V–IV (no common tone), simplest form: move the three upper voices in contrary motion to
  the bass.
- R5 `NEVER` All four voices leaping in the same direction. `AVOID` three voices leaping together; if it
  happens, hold the fourth or move it contrary.
- R6 `ALLOWED` Unlimited leaps of upper voices when the chord does not change (re-voicing the same harmony),
  provided one voice holds or moves contrary. `AVOID` the same leap pattern across a chord change.
- R7 `ALLOWED` After a clear caesura (phrase break) all four voices may leap in the same direction.
- R8 `NEVER` (early stage) augmented or diminished melodic intervals. Relaxed: `ALLOWED` approaching the
  leading tone by such an interval (V7 chapter), the 9th/13th of V9/V13, then any tone when it improves
  fluency, especially in minor (V9 chapter). Leaving a tone by such a leap is rarer.
- R9 `AVOID` upper-voice leaps larger than a P5 (7) in strict writing. Relaxed (sixth-chord chapter, later
  exercises): sixths and octaves allowed in the upper voices; the bass may leap a sixth or octave anytime.
- R10 `ALLOWED` Contrary-motion fifths that come from melodic passages (Hindemith sees no reason to ban them,
  unlike many textbooks). Parallels in general: [[voice-leading-parallels]].
- R11 `MUST` The top line is a fluent melody, written as a whole before the inner voices when harmonising a
  bass; it must not crawl from note to note.
- R12 `MUST` Added free voices must be logical, easily followed lines; `AVOID` pure filler voices. Keep their
  rhythm calmer than the main lines so the main lines stay audible.
  - *Outside this style:* rock/pop guitar and keyboard grips move as blocks (all voices parallel); that is
    idiomatic. For legato strings, choir and pads, R1–R3 remain the best smoothness default in any style.

## Apply in MIDI / REAPER
- Nearest-voice assignment: for each upper voice and each candidate pitch of the next chord (pitch classes
  per [[doubling-rules]], within ranges), cost = |Δ semitones|; held common tone cost 0; +3 per leap > 5;
  +6 if all upper voices move in the bass's direction when the bass leaps; reject R5 patterns. Choose the
  minimum-cost voicing that passes [[voice-leading-parallels]].
- Held common tones: on legato string/brass/choir patches write them as one sustained note across the chord
  change (no re-attack); on piano re-strike only if the rhythm asks for it.
- Keep CC1/CC11 continuous across the change; smooth lines need no dynamic dip.

## Checklist
- Common tones kept in the same voice where possible?
- Each upper voice moves ≤ 5 semitones (larger only within the same harmony or by design)?
- No four-voice same-direction leap (except after a caesura)?
- IV–V / V–IV: upper voices against the bass?
- Soprano readable as a melody?

## Examples
- E major I–V: bass E3→B2; tenor B3 held; alto E4→D#4; soprano G#4→F#4.
- C major IV–V: bass F2→G2; tenor A3→G3, alto C4→B3, soprano F4→D4 (all down against the rising bass).
- C major I–I6, same harmony: bass C3→E3 while the upper voices leap to a new position — fine; the same leaps
  into V6 would be poor.
