---
id: workflow.user-taste
title: The user's validated taste (overrides the books)
aliases: [preferencias del usuario, gusto, criterio del usuario]
domain: workflow
tags: [preferences, precedence, arrangement, midi-expression]
style_scope: universal
use_when: Before writing any music for this user, in any style. Read it with every workflow.
summary: The user is a sound engineer who judges by ear. Their validated preferences beat any book rule. Write idiomatic parts per instrument, make the MIDI expressive, mark sections with space and contrast, and get the real chart/reference before writing a cover.
sources: ["user feedback sessions Oct 2026 (Claude memory: music-arrangement-principles, beat-making-preferences)"]
related: ["[[START-HERE]]", "[[compose-film-cue]]", "[[arrange-modern-song]]"]
---

# The user's validated taste

These come from corrections the user made by ear (Oct 2026). **If one conflicts with a book rule, this
note wins.** This note is self-contained for any agent, Codex included. Claude Code also keeps more
detailed, genre-specific feedback in its project memory (`music-arrangement-principles`,
`beat-making-preferences`). When either source gains a style-agnostic rule, copy it here.

## Rules
- R1 `MUST` **Choose the instrument for the role first, then write the part the way a player of that
  instrument plays it.** Basses change technique, keys use real voicings with rolls and pedal, winds
  breathe, guitars play riffs and not block chords. "Suena a MIDI" means flat velocity, one articulation
  or uniform timing.
- R2 `MUST` **Expressive MIDI:**
  - shape velocity per voice, with the top note singing;
  - vary note lengths, from legato to dry stabs;
  - draw smooth CC1/CC11 curves, never stepped (the builder writes linear CC);
  - add pitch bend or vibrato where the instrument allows.
- R3 `PREFER` **Space and contrast over density.** Silences, drops and elements entering or leaving
  mark sections better than fills. In non-rock styles, no snare rolls into sections.
- R4 `PREFER` **Melodies:** a repeated motif with variations, long and short notes, rests and dynamics.
  Rotate the lead between instruments by section while a bed keeps the harmony and low end.
- R5 `MUST` **Scale runs:** stay in the mode and land the target, usually the tonic, on a strong beat.
- R6 `MUST` **Groove is one band:** shared swing and drift, and the bass locked to the kick.
- R7 `AVOID` low sine pads and pure-sine basses (mud). Prefer real multisampled instruments.
- R8 `MUST` **Covers:** get the real chord chart and check what the reference actually contains before
  writing. Never infer major/minor from colour voicings.
- R9 `PREFER` **Audible, musical FX moves:** filter sweeps, delay throws, reverse cymbals. Avoid subtle
  noise risers.
- R10 `MUST` **Session safety:**
  - Ask the user to save the project early.
  - Edit their live work surgically (dump/delete/write) rather than regenerating.
  - Check each build response.
  - Load heavy plugins one at a time; SWAM crashed REAPER.
- R11 `MUST` A bridge-created Kontakt instance is empty. Tell the user exactly which .nki to load.
  Owned libraries: Albion ONE (strings, brass low/mid/high, woods), HZ01/HZ02 percussion, Mysteria choir
  textures, Rise and Hit, and SWAM solo instruments (risky).
- R12 `MUST` Never type into plugin windows during computer use: the keystrokes trigger REAPER shortcuts.
- R13 `MUST` Library pitch quirks the user corrected:
  - **EZbass:** write an octave above real pitch, low E = MIDI 40, not 28.
  - **Ample Bass J:** C3 = 60; playable from MIDI 40. Notes 24–33 are latching keyswitches (sustain,
    mute, slide, hammer, slap, pop), so a bass note there switches articulation. Switch technique like a
    real player, and never randomize velocity (126–127 = accent).
  - **SWAM** solo instruments: concert pitch, with CC11 expression per note and delayed CC1 vibrato on
    long notes.
  - **Drums:** Toontrack GM-style map (36 kick, 38 snare, 42/44/46 hats, 49/57 crashes, 51 ride; toms
    48/47/45/43/41), one drum piece per track.
- R14 `PREFER` Swing on the 8th grid. Hats laid back by about 5 ms and the snare by about 6 ms, never
  pushed. The bass is locked to the kick.

- R18 `MUST` **Dynamics breathe at three levels, never flat.** Validated on *Fantasía de San Juan*
  (guitar, 2026-11-02):
  - inside each repeated figure (an arpeggio rises to its top note and recedes; equal attacks on every
    note were rejected);
  - per phrase: an arc to the culminating note, melodic contour, harmonic tension, softer phrase
    endings, a slow breath; repeated figures that all sound the same (tremolos, ostinatos) "no terminan
    de quedar bien";
  - pickups belong to the next phrase: they lean into its downbeat, and the tempo breathes before them,
    never stalling on them and jumping back.
  Keep steady only what should be steady (bells, a groove's pulse).
- R19 `MUST` **Calibrate velocity to the library before trusting a formula.** Measure the velocity curve
  and its layer changes, and keep quiet styles in the soft layer. Classical guitar on Ample sounded "fuerte
  en general" at velocities 80–110; the tremolo trill had to go down twice, to about a third of a plucked
  melody.
- R20 `MUST` **Every movement goes somewhere.** A home theme that returns, a contrast (key, register,
  texture) and a prepared climax. A chain of attractive ideas without return was "no sé hacia dónde van";
  A–B–A' with a dominant-pedal retransition was "mucho mejor".
- R21 `MUST` **No out-of-key ornaments.** An ornament or passing note that clashes with what sounds under it
  (C5 over E7 while G#4 rings) is heard as a wrong note. In sustained textures (tremolo, held chords) a
  non-chord tone needs its own harmony.
- R22 `NEVER` **Automatic expressive effects the score did not ask for** (auto slides/glissandi on big
  leaps were "muy raros"). Add them only where marked.

## Apply
Before delivering, play the result back mentally against R1–R6. After delivering, ask the user to listen
and record what they validate. New validated taste goes into memory, and into this note if it is
style-agnostic.
