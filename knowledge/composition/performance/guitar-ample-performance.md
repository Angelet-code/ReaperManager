---
id: performance.guitar-ample-performance
title: Guitar performance with Ample Guitar (classical L) — keyswitches, velocity, legato, tremolo
aliases: [Ample Guitar, Ample L, guitarra Ample, string force, keyswitch de cuerda, trémolo realista, trino, velocity guitarra, ligado Ample, armónico Ample, rasgueo Ample]
domain: performance
tags: [ample, guitar, keyswitch, velocity, legato, tremolo, measured]
style_scope: Ample Sound guitars (measured on Ample Guitar L, the classical nylon guitar)
use_when: Turning a solved guitar part into MIDI for an Ample Sound guitar, or when the user says a guitar "no suena creíble", sounds too strong, or the tremolo sounds mechanical.
summary: "Ample picks its own string unless a String Force keyswitch (31–36 = 6th…1st string) precedes each note; legato needs its keyswitch plus overlapping notes on one string; classical playing lives in the soft velocity layer (hard layer starts between 64 and 72). Shape dynamics inside each figure, per phrase and per pickup. Tremolo: automate release 230 ms + Start Time 30 ms + Auto Mod off (drop per re-pluck 16.5 → 3.9 dB) and draw mod-wheel vibrato on long notes; finger model still to validate against real recordings."
sources: ["Ample Sound manuals (Documents/Ample Sound/Manuals: Main Panel AGL, Settings and CPC)", "renders measured 2026-11-02", "user and guitarist feedback, Fantasía de San Juan"]
related: ["[[classical-guitar-solo]]", "[[_performance]]", "[[user-taste]]", "[[velocity-and-timing-humanization]]", "[[library-translation-table]]"]
---

# Guitar performance with Ample Guitar

## Core idea
**Ample Guitar L is the classical (nylon) guitar**, not a Les Paul. Ample names C3 = MIDI 60, so its
keyswitch octave 0 starts at 24. Reference implementation: `generator/lib/ample.mjs`, `legato.mjs`,
`macro.mjs`, `anacrusis.mjs` in `A:\CERBATANA\Ableton\2026-11-02 Fantasia San Juan`; profile facts in
`src/music/profiles/ample.json`.

## Rules
- R1 `MUST` String Force (G0–C1 = 31–36 = 6th…1st string) 2–3 ticks before every note; without it the
  instrument re-strings the part and cuts notes a guitar would let ring (measured: E4 on string 3 and
  E4 open sound clearly different). Give chord notes ≥ 8 ticks between them so each keyswitch pairs.
- R2 `MUST` Articulation latches: C0 (24) sustain, C#0 (25) natural *and* artificial harmonics; switch only
  on change, plain notes before harmonics in the same moment.
- R3 `MUST` Legato: F0 (29) hammer/pull, E0 (28) slide, held from before the first note to after the
  destination; both notes overlap (~30 ms) **on one string**. While it is held, other strings must not be
  re-struck within ~90 ms of their previous note (Ample hears a releasing note as overlapping and makes
  phantom slides). Measured: the destination enters ~9 dB softer with no pluck.
- R4 `NEVER` automatic expressive slides: they sounded arbitrary ("slides muy raros"). Slide only where the
  score asks.
- R5 `MUST` Velocity (measured, AGL): 33 dB from 8 to 120; a hard-layer jump between 64 and 72 (+4…+8 dB,
  sharper attack), another near 100; round robin varies ±2–4 dB. Velocity 127 = pop. Classical writing:
  pp 26, p 38, mp 46, mf 54–62; only f/ff, accents and rasgueado above 70.
- R6 `MUST` Three levels of dynamics: inside each arpeggio figure (rise to the top note, recede); per phrase
  (arc to the culminating note, contour, harmonic tension, softer phrase endings, slow breath); per pickup
  (an anacrusis leans into the next downbeat, the tempo breathes before it and never stalls then jumps).
  Keep steady what should be steady (bells).
- R7 `PREFER` Plugin setup: Auto Legato off (also D#6 = 99 at low velocity), Instrument play mode, Start
  Time 0 and every event 45 ms early (keeps the natural pluck), Cycle ×3, Open String First off.
- R8 `PREFER` Rasgueado: one stroke-noise FX (A5/A#5 = 93/94) per stroke at velocity 18–48 (they are very
  loud) and a golpe (F6 = 101) only on the strongest accents.

## Tremolo (p a m i)
Measured on 2026-11-02 (melody band of a trill at ~9 notes/s, Ample Guitar L):
- In Instrument mode each re-pluck on the melody string **cuts the ringing note** and the new sample needs
  ~45 ms to speak, so with the defaults the line drops **~16 dB per note** (the machine gun). Gaps or
  overlaps between notes change nothing; Keyboard mode is worse.
- R9 `MUST` Automate the tremolo section only: **release 230 ms** (`M-Release Time` 0.02; the cut note fades
  through its release while the next one speaks), **Start Time 30 ms** (0.6; less nail noise, steadier
  pitch) with notes 15 ms early instead of 45, and **Auto Mod off**. In the piece the drop went 16.5 → 3.9 dB.
- R10 `MUST` Vibrato: Auto Mod restarts on every re-pluck, so a trill never vibrates with it. With Auto Mod
  off the mod wheel gives a continuous vibrato that survives re-attacks: draw CC1 only on long melody notes
  (≥ 0.75 s), entering after ~0.3 s, peaking 35–85 by dynamics (below 95, the vibrato-noise threshold),
  released before the note changes. Pitch bend works too but bends every string.
- Trill (a m i) very light: about a third of a plucked melody (velocity ≈ 15/16/17, cap 24); thumb ≈ 22.
- Fingers: a weakest and ~7 ms late after the thumb, m +3 ms, i firmest; slow drift per finger. These
  ±1.5 dB differences sit under Ample's ±2–4 dB round robin.
- Macro-dynamics per phrase: arc to the culminating note, contour, messa di voce inside long notes, fading
  phrase ends, harmonic tension, breath.

## Open work (tremolo — high priority for this user)
Done on 2026-11-02: re-attack drop (release + Start Time automation), vibrato on long notes. Still to do,
by A/B with the user:
1. Measure real tremolo recordings the user provides (gap per finger, level per finger, swell shapes, tempo
   push in crescendos) and copy the proportions; the finger timing/level model is still a guess.
2. Thumb balance and legato in the bass line under the trill.
3. Try Ample's Poly Repeater (D6/E6) and Cycle mode Random for repeated notes.
4. If the softest layer sounds thin, get softness from Velocity Sensitivity (GUI setting) instead of
   velocities near 10.

## Checklist
- Every note has a String Force keyswitch; MIDI channel = string.
- No velocity above 70 outside f/ff, accents and rasgueado; trill ≤ 24.
- Legato pairs overlap on one string; no automatic slides.
- Re-sending a tempo map uses `replace_tempo` (otherwise markers pile up); render to new file names (an
  overwrite dialog freezes the bridge).
