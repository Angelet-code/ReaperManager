---
id: performance.guitar-ample-performance
title: Guitar performance with Ample Guitar (classical L) — keyswitches, velocity, legato, tremolo
aliases: [Ample Guitar, Ample L, configuración Ample, Auto Mod, vibrato raro, toque delicado, guitarra Ample, string force, keyswitch de cuerda, trémolo realista, trino, velocity guitarra, ligado Ample, armónico Ample, rasgueo Ample]
domain: performance
tags: [ample, guitar, keyswitch, velocity, legato, tremolo, measured]
style_scope: Ample Sound guitars (measured on Ample Guitar L, the classical nylon guitar)
use_when: Turning a solved guitar part into MIDI for an Ample Sound guitar, or when the user says a guitar "no suena creíble", sounds too strong, or the tremolo sounds mechanical.
summary: "Ample picks its own string unless a String Force keyswitch (31–36 = 6th…1st string) precedes each note; legato needs its keyswitch plus overlapping notes on one string; classical playing lives in the soft velocity layer (hard layer starts between 64 and 72). Choose plugin settings per piece from the R7 table (fresh instance: Auto Mod on, Auto Legato on, Start Time 35 ms; what each does per the manual, which value suits which texture, and how sure we are); always one empty bar before the first note; keep arpeggios even and tempo ramps smooth. Shape dynamics inside each figure, per phrase and per pickup. Tremolo: automate release 230 ms + Start Time 30 ms + Auto Mod off (drop per re-pluck 16.5 → 3.9 dB) and draw mod-wheel vibrato on long notes; finger model still to validate against real recordings."
sources: ["Ample Sound manuals (Documents/Ample Sound/Manuals: Main Panel AGL, Settings and CPC)", "renders measured 2026-11-02", "user and guitarist feedback, Fantasía de San Juan", "user feedback, Remanso (2026-11-02)"]
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
- R6 `MUST` Three levels of dynamics: inside each arpeggio figure (a smooth swell over its time, never
  offsets that alternate note to note, see R7c); per phrase (arc to the culminating note, contour,
  harmonic tension, softer phrase endings, slow breath); per pickup (an anacrusis leans into the next
  downbeat, the tempo breathes before it and never stalls then jumps). Keep steady what should be steady
  (bells).
- R7 `MUST` **Choose the plugin settings for the piece (and per section if needed); never inherit them.**
  Neither the factory defaults nor the last piece's values are right everywhere. Decide each row below from
  the context, write the choice into the FX spec (`build_beat` `fx[].params` or `fx_params`), and automate it
  per section with `write_envelope` when the texture changes (the Fantasía tremolo did). Evidence tags:
  *manual* = Ample manuals; *measured* = rendered and measured here; *ear* = validated by the user;
  *untested* = reasoning only, check by ear before relying on it.

  | Param (fresh instance, measured 2026-11-02) | What it does | When to use which value |
  |---|---|---|
  | `S-Auto Mod Tog` (**On**) | Vibrato follows an envelope (a start delay keeps fast notes straight) while the mod wheel sits at one value: Ample's intended way to get vibrato (*manual*). The mod wheel is global: **every ringing note vibrates, accompaniment included**. | **Off** for polyphonic accompaniment textures (arpeggios, chords) and calm pieces: Remanso v1 with CC1 at 36–44 sounded like "vibrato sostenido raro" (*ear*). **Off** when CC1 is drawn per note (tremolo: Auto Mod restarts on every re-pluck, *measured*). **On** + a moderate CC1 is the natural tool for an expressive single line or a solo passage without held accompaniment (*untested on AGL*). |
  | CC1 (mod wheel, at 0 unless written) | Vibrato depth; ≥ 0.75 (95) adds vibrato noise (*manual*). | 0 where nothing should vibrate. A section-long value only where every sounding note may vibrate. Drawn per-note curves for selected long melody notes (R10). |
  | `S-Mod Pitch Range` (50 cents), `S-Mod Volume Range` (6 dB), `S-Mod Time` (260 ms) | Vibrato width, amplitude part and timing (*manual*: Start/Attack/Hold/Decay/Sustain envelope; the exact meaning of the single Time knob is unverified). | 50 cents is a wide vibrato; a narrower width is the first thing to try for nylon classical (*untested*). |
  | `Auto Legato` (**1**) | Overlapping notes on one string become slides or hammer/pull-offs automatically (*manual*: modes Slide / HP / Off; only in Instrument mode; D#6 = 99 high velocity = slide, low = off). | **0** when legato is written with keyswitches and when overlaps are just let-ring (our generators: automatic slides were "muy raros", *ear*). Auto HP could speed up sketching a lead line (*untested*). |
  | `M-Start Time` (**35 ms**) | Skips the start of each sample; range 0–50 ms, linear, 50 ms per unit. The first ~50 ms are the string starting to vibrate, kept "to avoid sounding like piano"; Ample advises 0 ms with the track 50 ms early for playback/export (*manual*). Lead the notes by about (45–50 ms − Start Time). | **0** (lead 45) = most natural pluck, the default choice (Fantasía). **20 ms** (lead 25) = softer, rounder attack, validated for a delicate arpeggio piece (*ear*, Remanso). **30 ms** (lead 15) in tremolo: steadier pitch, less nail noise (*measured*). Keep the bite (0) for rhythmic, rasgueado or accented playing (*untested*). |
  | `M-Release Time` (50 ms) | Fade time of a released note; range 1–9000 ms, ≈ 50 + 9000·x (*manual*, mapping *measured*). | **≈230 ms (0.02)** for let-ring, delicate textures (*ear*, Remanso) and tremolo (re-pluck drop 16.5 → 3.9 dB, *measured*). **50 ms** or less where notes must stop: staccato, damped basses, rasgueado chokes, golpes (*untested*). |
  | `Cycle Mode Switch` (0) | Sample rotation: Separate Cycle (suits arpeggios and strumming), Round Robin (suits solo melody and bass), Random (*manual*). The value → mode mapping is unverified. | Separate Cycle for arpeggios and strumming, Round Robin for single lines. |
  | `Cycle Plus Tog` (Off) | "Cycle ×3": cycles three times longer, fewer repeats of the same sample (*manual*). | On wherever notes repeat (arpeggios, tremolo, repeated notes); no downside found yet (*ear*: part of the approved Remanso setup, not judged alone). |
  | `Play Mode` (0 = Instrument) | Instrument obeys string rules (one note per string); Keyboard allows several per string; Solo is monophonic and both disable auto legato (*manual*). | Instrument for realistic guitar parts. |
  | Velocity Sensitivity, Velocity Layer Threshold (Settings panel) | How much velocity changes loudness; where the layers switch (*manual*). | To get softness without dropping into thin low layers (*untested*). |
  | `M-Res Release`, `M-FA Gain`, `M-FR Gain` | String resonance and fret-noise levels on attack and release (*manual*). | Candidates for a more intimate or cleaner sound (*untested*). |

  Universal, whatever the settings: **one empty bar before the first note**. A note at time 0 has no room
  for its lead, and the first arpeggio was heard cut (*ear*, Remanso).
  Setup references: `PLUGIN` / `START_MS` in `A:\CERBATANA\Ableton\2026-11-02 Remanso\generator\main.mjs`
  (delicate arpeggio) and `TREMOLO` in the Fantasía `lib/ample.mjs` (tremolo automation).
- R7a `PREFER` Delicate touch for a calm arpeggio piece (*ear*, Remanso): melody p–mp (velocity ~32–60,
  median ~44, below the hard layer at 64), arpeggio fingers ~28, thumb bass ~34 (melody about 5 dB over the
  accompaniment); the melody sounds 14–24 ms after the thumb on shared onsets. Other characters (a
  passionate climax, a dance) need their own levels.
- R7b `AVOID` mod-wheel vibrato over polyphonic accompaniment. Because the wheel is global, a section-long
  CC1 (as the Fantasía library's `ampleEvents` `vibrato` per section writes) makes the arpeggio waver with
  the melody. In such textures pass `vibrato: {}` and draw vibrato only where one note sounds alone or the
  accompaniment is short (R10).
- R7c `MUST` Arpeggio accompaniment is even: no alternating loud/soft offsets between i and m (the
  Fantasía `shapeFigures` by pitch did this on a two-voice p-i-m-i and "no suena realista"), per-note
  variation within ±1–2 velocity (Ample's round robin adds the rest), at most a slight lean to the middle
  of the bar. Tempo rubato as linear ramps of ±2–3 %, never steps ("cambios de tempo demasiado bruscos").
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
- Plugin settings chosen for this piece from the R7 table (not inherited); no global CC1 vibrato over accompaniment; one empty bar before the first note.
- Every note has a String Force keyswitch; MIDI channel = string.
- No velocity above 70 outside f/ff, accents and rasgueado; trill ≤ 24.
- Legato pairs overlap on one string; no automatic slides.
- Re-sending a tempo map uses `replace_tempo` (otherwise markers pile up); render to new file names (an
  overwrite dialog freezes the bridge).
