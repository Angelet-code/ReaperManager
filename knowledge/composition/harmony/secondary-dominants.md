---
id: harmony.secondary-dominants
title: Secondary (auxiliary) dominants and leading-tone chords
aliases: [dominante secundaria, dominante auxiliar, dominante de la dominante, V/V, V7/ii, sensible artificial, acorde de sensible secundario, Zwischendominante, Doppeldominante, Wechseldominante]
domain: harmony
tags: [secondary-dominant, chromaticism, tonicization, leading-tone-chords]
style_scope: common-practice (also standard in pop, jazz and film; the "use few" advice is Hindemith's taste and holds broadly)
use_when: Intensifying the arrival on a non-tonic chord (V7/X → X), adding chromatic drive to a progression, or deciding how many secondary dominants a phrase can take.
summary: Put the dominant (preferably dominant-seventh type: major triad + minor 7th, root a P5 above the target) of any major or minor chord other than the tonic before it; its third rises a semitone to the target root and its seventh falls. A leading-tone chord (dim/half-dim 7th a semitone below the target root) works the same way. Use few, at structural targets, preferably on short/weak positions — chains of them devalue the main harmonies.
sources: ["hindemith-1 p.82-87", "hindemith-2 p.29-33"]
related: ["[[dominant-seventh]]", "[[diminished-seventh-pivot]]", "[[modulation]]", "[[harmonizing-a-melody]]", "[[mode-mixture-and-neapolitan]]", "[[_harmony]]"]
---

# Secondary (auxiliary) dominants

## Core idea
Any major or minor chord except the tonic can be preceded by its own dominant, borrowed for a moment. The
chord contains notes foreign to the key (a temporary leading tone), so it adds chromatic pull without
modulating. It is a local emphasis, not a key change, as long as the main key returns.

## Rules
- R1 `ALLOWED` Targets: in major II, III, IV, V, VI; in minor IV, V, VI — plus any altered major/minor chord
  (Neapolitan, bVI, altered III…).
- R2 `PREFER` Dominant-seventh type (root, +4, +7, +10 above its root); a plain major triad is next; a minor
  triad as "dominant" is rare.
- R3 `ALLOWED` V/V before the key's own V7; the tonic itself as dominant of IV (I(7) → IV).
- R4 `MUST` Resolve it as a normal dominant: its third rises a semitone to the target root, its seventh falls
  by step (inferred from the V7 rules and the book's realizations).
- R5 `ALLOWED` Secondary leading-tone chords: VII, VII6, VII6/4, VII7 (diminished or half-diminished, any
  inversion) on the semitone below the target root.
- R6 `AVOID` Many secondary dominants: they take over, devalue the main harmonies, jolt the key, and in excess
  produce the manner of second-rate 19th-century and sentimental entertainment music (chains of V/x).
- R7 `PREFER` Use them where their repetition supports the construction (same place in parallel phrases);
  stop where they are only ornament.
- R8 `PREFER` Place V/x → x on short metric units of the accompaniment (e.g. a two-eighth figure), not on main
  structural points.
- R9 `MUST` Harmonizing method: (1) mark every melody spot where a secondary dominant is possible; (2) fix
  where the main harmonies go; (3) keep only a few of (1), those that support (2).
- R10 `PREFER` (general knowledge) Keep the chromatic inflection in one voice (C → C# in the same voice) to
  avoid a cross relation; the Neapolitan → V case is the accepted exception
  ([[mode-mixture-and-neapolitan]]).
  - *Outside this style:* pop, gospel, jazz and film use chains (III7–VI7–II7–V7–I, "ragtime"
    progression) freely; Hindemith's warning still predicts the sweet, nostalgic effect of such chains.

## Apply in MIDI / REAPER
- Target root x (pitch class): V7/x = {x+7, x+11, x+2, x+5}; vii°7/x = {x−1, x+2, x+5, x+8}.
- Budget (inferred from R6–R8): at most one per phrase-level target, at most two chained, unless the style is
  explicitly late-Romantic/sentimental.
- Generator: place primary chords first; then for each target chord test whether V7/x fits the melody note
  sounding at that point (melody pc ∈ chord or a valid NCT); keep the best 1–2.
- Voice the temporary leading tone in an inner voice of the pad when the melody is busy; give it to the top
  when the arrival should feel emphatic.

## Checklist
- Target is not the tonic; resolution: leading tone +1, seventh −1/−2?
- Few secondary dominants, placed at structural targets or repeated spots?
- No unintended cross relations?

## Examples
| Key | V7 of ii | of iii | of IV | of V | of vi |
|---|---|---|---|---|---|
| C major | A7 → Dm | B7 → Em | C7 → F | D7 → G | E7 → Am |
| A minor | — | — | A7 → Dm | B7 → E | C7 → F |
- vii°7/V in C: F#–A–C–Eb → G (or → I6/4 → V).
