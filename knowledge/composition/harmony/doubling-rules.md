---
id: harmony.doubling-rules
title: Doubling rules by chord type
aliases: [duplicaciones, duplicar la fundamental, duplicar la tercera, nota duplicada, omitir la quinta, Verdopplung, Terzverdopplung]
domain: harmony
tags: [four-part, doubling, voicing]
style_scope: common-practice (avoid doubling tendency tones = near-universal for exposed sustained parts)
use_when: Deciding which chord member gets two (or more) voices when a 3-note chord is written for 4+ voices, or which note to drop from a 4-note chord.
summary: Double the root by default, the fifth is fine, the third is fine in sixth chords and resolutions unless it is the leading tone. Never double the leading tone or a chordal seventh (they must resolve and would make parallel octaves); in 6/4 chords double the bass.
sources: ["hindemith-1 p.1-3", "hindemith-1 p.12-24", "hindemith-1 p.25-38", "hindemith-1 p.39-52", "hindemith-1 p.53-72", "hindemith-1 p.88-98"]
related: ["[[four-part-voices-and-spacing]]", "[[voice-leading-parallels]]", "[[dominant-seventh]]", "[[harmony-voicing-for-instruments]]", "[[_harmony]]"]
---

# Doubling rules by chord type

## Core idea
A triad in four voices has exactly one doubled member (or a tripled root with the fifth left out). The
choice is not cosmetic: a doubled **tendency tone** (leading tone, seventh, altered note) has two voices that
both want to move to the same pitch, which produces parallel octaves or forces one voice to break its
resolution. Hindemith starts strict and relaxes chapter by chapter; the table gives the final state.

## Rules
- R1 `MUST` A triad in four parts has exactly one doubled tone, or the fifth is omitted and another tone
  takes its place (root tripled, or root and third doubled).
- R2 `PREFER` Double the root; doubling the fifth is `ALLOWED`.
- R3 `ALLOWED` Double the third in root-position and sixth chords, especially in sixth chords and in the
  chord that resolves a V7 (early chapters forbid it; relaxed from the V7 chapter on).
- R4 `NEVER` Double the leading tone when it is the third of a dominant chord. Exceptions (R11) are narrow.
- R5 `NEVER` Double the seventh of any seventh chord (V7, secondary sevenths) or the 9th/13th of V9/V13.
- R6 `PREFER` In a 6/4 chord double the bass (the fifth); less often the root or third.
- R7 `PREFER` In a diminished triad double the tone that is not part of the tritone (its third); use it in
  first inversion so that doubled note is in the bass.
- R8 `NEVER` Double the leading tone inside the augmented triad (III of minor).
- R9 `MUST` When a seventh chord loses a note, double the root and place the seventh in the top voice.
  Which note may go: see [[diatonic-seventh-chords]] (V7, V9 lose the fifth).
- R10 `NEVER` Double any note that acts as a leading tone in altered dominants, augmented-sixth chords or
  diminished sevenths — also not in thinner or thicker than four-part textures.
- R11 `ALLOWED` Doubled leading tone when (a) it is not the third of a dominant, or (b) it is, but the
  dominant moves to II, III, IV or VI (not to I) and the two leading tones move in different directions, or
  (c) it gives clearly better voice leading, normally with the two voices in contrary motion.
- R12 `ALLOWED` A suspension resolving to the third of a **minor** chord may double that third; `AVOID` it on
  a **major** chord; `NEVER` when that third is the leading tone.
- R13 `ALLOWED` Non-chord tones may produce otherwise forbidden doublings (leading tone, sevenths, 9ths,
  13ths) because they are transitory.
- R14 `NEVER` Omit the two notes that form the characteristic second of II6/5 (in C: C and D); its third may
  be dropped. In an incomplete II6/5 that acts as neighbour chord to V, do not double the note that falls to
  the leading tone.

  - *Outside this style:* in orchestral and pad writing "doubling" mostly means octave reinforcement. Keep
    R4/R5/R10 for exposed sustained parts (a doubled leading tone in octaves sounds heavy and pulls the
    balance). Rock power chords double root and fifth with no third at all — fine in that idiom.

## Apply in MIDI / REAPER
- Implement as an ordered preference list per chord type that returns the four roles for T/A/S + bass:

  | Chord | First choice | Second | Forbidden doubling |
  |---|---|---|---|
  | Major/minor 5/3 | root ×2 | fifth ×2; root ×3 no fifth | third if leading tone |
  | Major/minor 6 | root or fifth ×2 | third ×2 | leading tone |
  | 6/4 | bass (fifth) ×2 | root ×2 | — |
  | Diminished triad (6) | third ×2 | — | tritone notes |
  | V7 complete | none (4 notes) | no fifth, root ×2 | 7th, leading tone |
  | V9 | no fifth, 9th on top | — | 9th, 7th, leading tone |
  | Secondary 7th | complete | drop 5th/3rd, root ×2, 7th on top | 7th, leading tone |

- For 5+ voices add doublings in the order root, fifth, (third), always rechecking the forbidden column.

## Checklist
- Exactly one doubled member per triad (or a justified omission)?
- No doubled leading tone, seventh, 9th or altered note (except R11–R13 cases)?
- 6/4 chords doubled on the bass note?

## Examples
- C major I6 with doubled third: E3–E4–G4–C5 (third doubled, allowed after the V7 chapter).
- B diminished in C, first inversion: D3 (bass), F3, B3, D4 — D doubled, B and F single.
