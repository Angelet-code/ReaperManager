---
id: harmony.harmonic-texture-and-voice-count
title: Texture decisions: number of voices, thickening and accent by density
aliases: [número de voces, textura, a tres voces, a cinco voces, densidad de la textura, plenitud del acorde, crescendo por acumulación, estilo mixto de teclado, homofonía, contrapunto, Stimmenzahl, Satzdichte, Akkordfülle]
domain: harmony
tags: [texture, voice-count, dynamics, homophony, counterpoint]
style_scope: universal (Hindemith's statements are tonal-era, but the density logic holds for film and pop arrangement)
use_when: Deciding how many voices/notes a passage gets, how to build a crescendo or accent without (or besides) velocity, and whether a section should be chordal or contrapuntal.
summary: Four voices is the default; three only when the harmony is simple (heavy chromaticism needs more voices to be clear); five or more real voices suit calm, vocal-style music, not busy instrumental music. Build crescendos and accents by adding chord tones and doublings (fullness), thin out at section starts, and keep only one active line at a time.
sources: ["hindemith-1 p.34-38", "hindemith-1 p.53-59", "hindemith-1 p.109-116", "hindemith-1 p.117-125", "hindemith-2 p.11-22", "hindemith-2 p.22-29", "hindemith-2 p.34-41", "hindemith-2 p.41-71"]
related: ["[[harmonic-planning-seven-factors]]", "[[accompaniment-for-solo-line]]", "[[harmony-voicing-for-instruments]]", "[[four-part-voices-and-spacing]]", "[[_orchestration]]", "[[_harmony]]"]
---

# Texture decisions: voice count, thickening, accent by density

## Core idea
Voice count and chord fullness are expressive parameters, not just arranging details. Hindemith uses them as
the "stratification" factor of his plan ([[harmonic-planning-seven-factors]]): fewer voices = lighter and
clearer, more voices = weight, calm or climax. On instruments without accent (organ, harmonium, pads) density
is the only way to shape metre.

## Rules
- R1 `PREFER` Four real voices as default.
- R2 `AVOID` Heavy alteration in three-voice writing: chromatic connections are unclear with only three voices.
- R3 `PREFER` Five or more real voices for calm, vocal-style music; `AVOID` them in lively instrumental
  textures, where independent voices obstruct each other.
- R4 `PREFER` Mixed keyboard style: full many-note chords alternating with thinner passages.
- R5 `MUST` Support a dynamic swell by graded chord fullness (more notes and doublings), not only volume.
- R6 `MUST` On a non-accenting instrument (organ, harmonium, sustained pads without velocity response),
  express accents by quantity: accented chords contain more tones than their neighbours.
- R7 `PREFER` Thin the texture at section starts; build it toward climaxes and the final statement.
- R8 `AVOID` An independent upper melody against an equally independent bass at the same time; let one line
  lead (if the bass is active, keep the top in halves/quarters, middle voice in the shadow).
- R9 `PREFER` Contrasting middle section = change texture type (polyphonic ↔ homorhythmic), e.g. all voices
  in the same rhythm, or two paired voices against one calm voice.
- R10 `MUST` Free (non-thematic) voices: calmer rhythm than the main lines; too many eighths in middle or low
  voices rob the top line of importance.
- R11 `MUST` Five voices in a compact choir: keep the total range small; fifth voice = second soprano or
  second tenor.
- R12 `ALLOWED` Open-fifth (no third) sonorities anywhere — hollow sound; bare unison only as final chord.
- R13 `AVOID` Pure block chords and maximal counterpoint as the only styles of a complex fast piece; pick a
  middle style per section.
  - *Outside this style:* film and pop builds use the same principle — add layers, octave doublings and
    register spread toward the hit, then strip back for the next section (general knowledge). See
    [[_orchestration]].

## Apply in MIDI / REAPER
- `voices` per bar from the plan → number of simultaneously sounding notes (excluding octave doublings for
  "real" voices; including them for fullness).
- Crescendo by thickening: e.g. 3 notes → 4 → 5 → 6 (+ bass octave) over the build, with CC1 rising in
  parallel; do not push fullness, harmonic-rhythm speed and tension all to maximum before the climax
  (reduce-the-others rule).
- Pads/organ accents: downbeat chords 5–6 notes, offbeats 3 notes; keep velocity constant.
- One active line: if two tracks both have ≥ 50 % of their notes shorter than a quarter in the same bar
  and both are in exposed registers, simplify one.

## Checklist
- Voice count matches the section role (thin entry, full climax/final)?
- Chromatic passages have ≥ 4 voices?
- Crescendo has growing fullness, not only velocity?
- Only one active line at a time?

## Examples
- 16-bar build (strings): bars 1–4 two voices (Vc + Vln I), 5–8 three, 9–12 four, 13–16 five + Cb octave.
- Organ/pad in 3/4: beat 1 = 5 notes, beats 2–3 = 3 notes.
