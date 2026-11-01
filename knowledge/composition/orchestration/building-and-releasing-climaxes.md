---
id: orchestration.building-and-releasing-climaxes
title: Building and releasing orchestral climaxes
aliases: [construir un clímax, clímax, build, subida, crescendo orquestal, tensión, liberación, rampa de tensión, acelerando, cambio de tonalidad, release]
domain: orchestration
tags: [climax, build, release, transition, tempo, film]
style_scope: film (HTTYD / modern adventure scoring) + universal principles (crescendo by instrumentation)
use_when: Writing a build-up to a big downbeat, a tension ramp, a key lift for a final statement, or the release after a climax.
summary: Build in stages, each one adding layers, register and rhythmic activity. Hold the brightest colour (trumpets) and the widest register for the last stage. Mark the arrival with a one-bar sweep (runs, rolls, harp glissando) landing on the downbeat. Release with a subito drop (f instead of ff, thinner texture, secco hits) and rebuild from a higher key or tempo.
sources: ["httyd-test-drive p.5-15", "unir-orq-tema2 p.4-10", "unir-orq-tema3 p.11", "film-4day-challenge slide 10"]
related: ["[[dynamics-by-orchestration]]", "[[texture-unison-and-tutti]]", "[[film-percussion-phrase-marking]]", "[[httyd-test-drive-case-study]]", "[[five-elements-arrangement-checklist]]", "[[user-taste]]"]
---

# Building and releasing climaxes

## Core idea
A climax is planned **backwards from the arrival**. The arrival bar has the most instruments, the
widest register and the strongest colour. Each stage before it adds something: layers, octaves,
rhythmic activity, harmonic tension, or tempo. A release only works if something is clearly taken away.

## Rules
- R1 `MUST` Build by adding instruments and octaves (see [[dynamics-by-orchestration]]), at least one new
  layer per 2–4 bars.
- R2 `PREFER` Withhold one colour for the last stage. HTTYD keeps the trumpets out until the last beat
  of the build (b.31), then brings them in with an accented 16th-triplet repeated-chord pickup (f < ff).
- R3 `PREFER` A one-bar sweep into the downbeat:
  - Piccolo + flutes + violins play 16th-sextuplet runs upward for the whole bar.
  - Timpani and snare roll with a crescendo.
  - The harp plays a glissando up.
  - The suspended cymbal swells p < ff.
  - Override: For this user, prefer cymbal swells, timpani rolls or a silence before the downbeat; snare rolls only in rock/marching contexts or on explicit request ([[user-taste]] R3).
- R4 `PREFER` For a tension ramp without melody: a harmonic stall (e.g. a bVI pedal) + chromatic
  brass clusters + rising string tremolo glissandi + percussion rolls fp < ff, for 4–5 bars.
- R5 `PREFER` Rhythmic acceleration inside the same tempo before a new section: 8ths → 8th-triplets →
  a quarter-note-triplet bass scale (HTTYD b.53–54).
- R6 `PREFER` Raise the click in small steps at section boundaries (+1.5, +1.5, +3 BPM) rather than a
  continuous accelerando.
- R7 `PREFER` For a final statement, lift the whole section a whole step (D → E) and reuse the same
  chord loop, only when the user has not fixed the key.
- R8 `PREFER` After a climax, restart at **subito f (not ff)** with the opening texture, then rebuild.
- R9 `PREFER` End a section with **secco** hits (cymbal, tam-tam, bass drum, timpani on beat 1, no ring)
  and a return to a light woodwind/celesta texture to hand off.
- R10 `MUST` Every climax is louder (more tracks, higher CC1) than every earlier entrance in the cue.
  Keep earlier entrances below it.
- R11 `MUST` Choose the ending type on purpose (table below). "Acabar arriba" means a tutti button on I,
  not a release.

## Apply in MIDI / REAPER
**Four-stage build to bar N** (4/4; beats are 0-based in the builder):
| Stage | Bars | Add | CC / velocity |
|---|---|---|---|
| 1 | N−8 to N−7 | strings motor + horns melody | CC1 70 |
| 2 | N−6 to N−5 | woodwinds in octaves + low brass half notes + timpani | CC1 80 |
| 3 | N−4 to N−2 | sextuplet fills on beats 3–4, cymbal on each 2-bar downbeat, a countermelody | CC1 90 |
| 4 | N−1 | sweep bar (R3) + trumpet stinger on beat 4 (R2) | CC1 ramps 90 → 110, ending at N.0 |
| Arrival | N | tutti, widest span (≥ 42 semitones), crash + bass drum + sub boom on beat 0 | longs CC1 105–115, shorts vel 112–120 |

- **Sweep notes:** 6 notes per beat (`len` = 1/6). Fill bar N−1 with a scale up through the target chord,
  ending on the arrival chord tone at beat 0 of bar N. Velocity rises 70 → 115 across the bar.
- **Trumpet stinger:** a repeated chord in 16th-triplets on the last beat of bar N−1 (builder beats 3,
  3.167, 3.333, 3.5, 3.667, 3.833, each `len` 0.15), velocity 95 → 115, landing on a held chord at N.0.
  In HTTYD it starts on the 3rd beat and lasts about one beat.
- **Roll crescendo:**
  - Timpani as a roll patch with a CC1 ramp 30 → 110 over the bar, or as 32nd-note hits with
    velocity 40 → 115.
  - Suspended cymbal swell sample placed so it peaks exactly on N.0.
- **Tension ramp (R4):** sustained bVI pedal in `CB`/`TUBA`. `HN`/`TBN` hold close clusters that move by
  semitone every 2 beats. String tremolo patches use pitch-bend rises, staggered per track by 1/4 beat,
  to imitate an aleatoric glissando. CC1 runs 30 → 115 over 4 bars.
- **Tempo steps:** builder `tempo_changes: [{bar, bpm}]` at section boundaries, e.g. 111 → 112.5 →
  114 → 117.
- **Release:**
  - Subito: drop to the opening tracks only, at CC1 75–85 (f), on the first bar after the climax.
  - Secco: a 1/8-beat note on percussion with the ring choked, no sustain samples, and all longs
    ending at beat 0 + 1/4.

**Ending types (R11):**
| Type | Use when | MIDI |
|---|---|---|
| Tutti button on I ("acabar arriba") | the cue or piece ends big | full tutti chord on I at beat 0, held 1–2 bars; optional timpani roll on I into a cutoff hit (all perc vel 115) |
| Open V / bare fifth | the music continues into the next cue | V or a root–fifth chord, no third, held or cut on beat 0 |
| Secco release | a hard cut into silence or dialogue | short dry tutti hit (`len` ≤ 0.25), rings choked, then silence |
| Fade / hand-off | the scene continues under | thin to one colour (woodwind, celesta, pad) and let CC1 fall to ~20 over 2–4 bars |

## Checklist
- Does every build stage add at least one new track or octave?
- Is one colour (often trumpets) held back for the last stage?
- Do all ramps and sweeps end exactly on the arrival downbeat?
- Does the arrival have the most tracks and the widest span in the cue?
- Is the release audibly thinner (fewer tracks, lower CC1) than the climax?
- Are tempo changes stepped at section boundaries?
- Does the ending type match the request ("acabar arriba" = tutti I button)?
