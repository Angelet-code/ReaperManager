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

- R15 `MUST` **Balance with the performance, never with faders.** Relative level depends on the section and on
  each line's role (melody, countermelody, bed), so set it per section in the MIDI: CC1/CC11 on long notes,
  velocity on shorts. Measure stems per segment. As a guide:
  - an exposed solo sits about +5 dB over its bed;
  - a countermelody sits about 3 dB under the melody;
  - a section melody in a tutti sits about 4 dB under the bed.
  Lower the heavy bed (low strings, low brass, percussion, piano) before raising melodies. Don't double a section
  with its own soloist. Place dry modelled soloists (SWAM) in a room at a stage distance so they match the
  sampled orchestra.
- R16 `MUST` **Idiomatic stamina and speed.**
  - Winds and brass breathe: a phrase that is too long gets a breath at its best point.
  - Solo strings change bow by dynamic: about 4 s at f, about 10 s at pp.
  - Horns and trumpets rest after high or long passages.
  - Basses don't play fast figures in the low register.
  - The tuba plays no short notes below D2.
  - Timpani use at most 4 drums per passage, with time to retune.
- R17 `PREFER` **Measured performance shape for modelled soloists and Albion sections.** Validated by ear
  on 2026-11-02 in an A/B on *La Forja del Alba* bars 52–64 (solo violin SWAM over Albion string legato).
  The user chose B, "la medida". The B values were taken from professional reference MIDI; see
  [[_performance]]. **They were validated as a set (B against A), not change by change.**
  - **SWAM slur velocity** (sets the portamento time) depends on the slurred note's length:
    - about 110 for notes under 0.25 s;
    - about 98 for 0.25–0.5 s;
    - about 88 for 0.5 s or more;
    - ±6, and 4 lower on strings;
    - the solo horn never below 100, because its portamento reaches 2.4 s.
  - **SWAM phrase in CC11:**
    - the curve starts moving 150 ms (winds) or 120 ms (strings) before the first note-on, from 60 % of
      the target;
    - it reaches the target 90/110 ms after the note-on;
    - the phrase arc peaks early, at about 0.37 of the phrase;
    - the final fall is short, about 22 points over the last 240/300 ms, and the note-off does the rest.
      Don't sink it to the floor.
  - **SWAM timing and overlap:**
    - human timing of about ±24 ms (triangular);
    - slur overlap that varies between 28 and 50 ms.
  - **Albion longs and legato:**
    - the CC1 dynamic layer about 16 % lower (0.78·v + 6);
    - phrase CC11 8 points higher to give the level back;
    - attack offsets ±8 ms around the usual 25/50 ms;
    - shorter section phrases with breaths: string legato every ~7 s with a 120 ms gap, woods and horn
      legato every ~8 s with 220 ms.
  - Reference implementation: the music engine `src/music` (styles `modeled` and `sampled`, numbers in
    `src/music/profiles/*.json`; design `docs/music-engine.md`). It reproduces La Forja's `expr.mjs` output
    exactly and only carries B. La Forja's own generator keeps `EXPR_A=1` for the old version.

- R18 `MUST` **Dynamics breathe at three levels, never flat.** Validated on *Fantasía de San Juan*
  (guitar, 2026-11-02):
  - inside each repeated figure (an arpeggio rises to its top note and recedes; equal attacks on every
    note were rejected). The shape is a smooth swell over time: offsets that alternate note to note (a
    two-voice p-i-m-i going loud-soft-loud) sounded unrealistic on *Remanso*, where an even hand with a
    slight lean to the middle of the bar was approved;
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
  leaps were "muy raros"). Add them only where marked. Plugin defaults are effects nobody chose either: a
  fresh Ample Guitar L has Auto Mod on, and a mod wheel held over an arpeggio made everything waver. Know what
  each setting does and choose it for the piece and section; do not inherit defaults or the last piece's
  values (see [[guitar-ample-performance]] R7).
- R23 `MUST` **Match the number of ideas to the length.** A ~2-minute piece wants one theme, one
  accompaniment texture and a plain form (intro – A – A – B – A – coda, B made from the same motif). Seven
  sections with new textures, a thumb melody, triplets, a borrowed chord and a harmonics coda were
  "demasiada cosa distinta, falta estructura y orden" (*Remanso*, Nov 2026); save variety for multi-part
  pieces.
- R24 `PREFER` **When a piece asks for delicacy** (*Remanso*, calm guitar arpeggio, "bastante mejor, así se
  queda"): soft dynamics with the melody singing about 5 dB over an even accompaniment, a softened attack
  and natural release tails, smooth tempo ramps (±2–3 %), no vibrato over the arpeggio. This is the
  recipe for that character, not a default for every piece.

## Apply
Before delivering, play the result back mentally against R1–R6. After delivering, ask the user to listen
and record what they validate. New validated taste goes into memory, and into this note if it is
style-agnostic.
