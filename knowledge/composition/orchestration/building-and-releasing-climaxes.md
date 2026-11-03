---
id: orchestration.building-and-releasing-climaxes
title: Building and releasing orchestral climaxes
aliases: [construir un clímax, clímax, clímax sonoro, build, subida, crescendo orquestal, tensión, liberación, rampa de tensión, acelerando, cambio de tonalidad, release, reserva de medios, diminuendo orquestado]
domain: orchestration
tags: [climax, build, release, transition, tempo, film, brass]
style_scope: film (HTTYD / modern adventure scoring) + universal principles (crescendo by instrumentation); symphonic techniques in building-and-releasing-climaxes-symphonic
use_when: Writing a build-up to a big downbeat, a tension ramp, a key lift for a final statement, or the release after a climax.
summary: Build in stages, each one adding layers, register and rhythmic activity. Hold the brightest colour (trumpets) and the widest register for the last stage. Mark the arrival with a one-bar sweep (runs, rolls, harp glissando) landing on the downbeat. Release with a subito drop (f instead of ff, thinner texture, secco hits) or a step-by-step orchestrated diminuendo, and rebuild from a higher key or tempo.
sources: ["httyd-test-drive p.5-15", "unir-orq-tema2 p.4-10", "unir-orq-tema3 p.11", "film-4day-challenge slide 10", "adler-orq-es p.413-423", "piston-orch p.222"]
related: ["[[building-and-releasing-climaxes-symphonic]]", "[[brass-section-writing]]", "[[dynamics-by-orchestration]]", "[[texture-unison-and-tutti]]", "[[film-percussion-phrase-marking]]", "[[httyd-test-drive-case-study]]", "[[five-elements-arrangement-checklist]]", "[[user-taste]]"]
---

# Building and releasing climaxes

## Core idea
Plan a climax **backwards from the arrival**: the arrival bar has the most instruments, the widest
register and the strongest colour; each earlier stage adds layers, octaves, activity, tension or tempo.
A release works only if something is clearly taken away. Symphonic techniques (reserve, alternation,
repetition, orchestrated diminuendo): [[building-and-releasing-climaxes-symphonic]].

## Rules
- R1 `MUST` Build by adding instruments and octaves (see [[dynamics-by-orchestration]]), at least one new
  layer per 2–4 bars.
- R2 `PREFER` Withhold one colour for the last stage: HTTYD keeps the trumpets out until the last beat
  of the build (b.31), then adds an accented 16th-triplet repeated-chord pickup (f < ff).
- R3 `PREFER` A one-bar sweep into the downbeat: piccolo, flutes and violins in rising 16th-sextuplet
  runs, timpani roll, harp glissando up, cymbal swell p < ff. For this user no snare rolls outside
  rock/marching contexts; a silence before the downbeat also works ([[user-taste]] R3).
- R4 `PREFER` For a tension ramp without melody: a harmonic stall (e.g. a bVI pedal) + chromatic
  brass clusters + rising string tremolo glissandi + percussion rolls fp < ff, for 4–5 bars.
- R5 `PREFER` Rhythmic acceleration inside the same tempo before a new section: 8ths → 8th-triplets →
  a quarter-note-triplet bass scale (HTTYD b.53–54).
- R6 `PREFER` Raise the click in small steps at section boundaries (+1.5, +1.5, +3 BPM) rather than a
  continuous accelerando.
- R7 `PREFER` For a final statement, lift the whole section a whole step (D → E) and reuse the same
  chord loop, only when the user has not fixed the key.
- R8 `PREFER` [film] After a climax, restart at **subito f (not ff)** with the opening texture, then
  rebuild. `ALLOWED` [symphonic] a written-out diminuendo that removes doublings step by step into a pp
  chord ([[building-and-releasing-climaxes-symphonic]] R10).
- R9 `PREFER` End a section with **secco** hits (cymbal, tam-tam, bass drum, timpani on beat 1, no ring)
  and a return to a light woodwind/celesta texture to hand off.
- R10 `MUST` Every climax is louder (more tracks, higher CC1) than every earlier entrance; keep the brass
  light earlier (Adler).
- R11 `MUST` Size the climax brass so strings and woodwinds at full strength stay audible (Piston).
- R12 `MUST` Choose the ending type on purpose (table below). "Acabar arriba" means a tutti button on I,
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

- **Sweep:** 6 notes per beat (`len` 1/6), a scale up through the target chord to its tone at N.0;
  velocity 70 → 115.
- **Trumpet stinger:** 16th-triplet repeated chord at beats 3, 3.167 … 3.833 of bar N−1 (`len` 0.15),
  velocity 95 → 115, landing on a held chord at N.0.
- **Rolls:** timpani roll CC1 30 → 110 over the bar (or 32nd hits, velocity 40 → 115); cymbal swell
  sample peaking exactly on N.0.
- **Tension ramp (R4):** bVI pedal in `CB`/`TUBA`; `HN`/`TBN` close clusters moving by semitone every
  2 beats; string tremolo pitch-bend rises staggered 1/4 beat per track; CC1 30 → 115 over 4 bars.
- **Tempo steps:** builder `tempo_changes: [{bar, bpm}]`, e.g. 111 → 112.5 → 114 → 117.
- **Release:** subito = the opening tracks only, CC1 75–85 (f), on the first bar after the climax.
  Secco = a 1/8-beat percussion note, ring choked, all longs ending at beat 0 + 1/4.
- **Brass check (R11):** render brass, string and woodwind stems of the arrival; if the strings vanish,
  lower the brass CC1 first ([[user-taste]] R15).

**Ending types (R12):**
| Type | Use when | MIDI |
|---|---|---|
| Tutti button on I ("acabar arriba") | the cue or piece ends big | full tutti chord on I at beat 0, held 1–2 bars; optional timpani roll on I into a cutoff hit (all perc vel 115) |
| Open V / bare fifth | the music continues into the next cue | V or a root–fifth chord, no third, held or cut on beat 0 |
| Secco release | a hard cut into silence or dialogue | short dry tutti hit (`len` ≤ 0.25), rings choked, then silence |
| Fade / hand-off | the scene continues under | thin to one colour (woodwind, celesta, pad) and let CC1 fall to ~20 over 2–4 bars |

## Checklist
- Does every stage add a track or octave, with one colour held back for the last?
- Do all ramps and sweeps end exactly on the arrival downbeat?
- Does the arrival have the most tracks and widest span, with strings and woods still audible?
- Is the release audibly thinner (fewer tracks, lower CC1)?
- Are tempo changes stepped at section boundaries?
- Does the ending type match the request ("acabar arriba" = tutti I button)?
