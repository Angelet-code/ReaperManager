---
id: form.fugue
title: Fugue — elements and overall structure
aliases: [fuga, sujeto, respuesta, contrasujeto, contrarrespuesta, entrada, exposición de la fuga, contraexposición, episodio, divertimento, codetta, estrecho, stretto, pedal, fuga libre, fuga de escuela, Fuge, Durchführung der Fuge, Engführung]
domain: form
tags: [fugue, counterpoint, subject, countersubject, episode, stretto]
style_scope: baroque
use_when: When writing a fugue, fughetta or fugato, or analysing/validating fugal entries, episodes and strettos.
summary: A fugue has a fixed number of real voices built on a subject; Section 1 (exposition) gives each voice the subject or answer (S tonic, R dominant, S, R) with countersubjects, no voice re-entering before all have entered; Section 2 brings entries in neighbouring keys separated by sequential, imitative episodes; Section 3 returns to the tonic, usually with strettos and dominant then tonic pedals; cadences are rare and never stop all voices.
sources: ["zamacois-formas p.57-89 (§53-84)", "zamacois-formas p.117-127 (§93-96)"]
related: ["[[fugue-tonal-answer]]", "[[school-fugue-plan]]", "[[imitation-and-canon]]", "[[thematic-development]]", "[[cadences]]", "[[modulation]]"]
---

# Fugue — elements and overall structure

## Core idea
One-movement polyphonic piece for a fixed number of real voices, built on insistent imitation of a
**subject** with free passages between entries (§53). School fugue = strict plan ([[school-fugue-plan]]);
free fugue = only the exposition is fixed (§56, §72).

## Rules — subject and entries
- R1 `MUST` The fugue begins with the subject, normally alone (§57–58).
- R2 `MUST` Subject: clear key and personality, especially its head; starts on 1 or 5; ends on 1, 5 or
  their 3rds (not the leading tone in minor); must not sound finished early; vocal range ≤ an octave;
  ideally allows stretto with its answer; only passing modulation, preferably to V (§57, §84).
- R3 `MUST` The answer (R) enters on the subject's last note or right after it, at the 5th above / 4th below:
  **real** (exact) or **tonal** (mutated) — see [[fugue-tonal-answer]] (§59–60).
- R4 `MUST` Countersubject (CS): invertible counterpoint with S and R (works above and below); distinct
  rhythm (moves when the subject holds, holds when it moves); starts after S/R has attacked; never appears
  alone (§61–63, §74, §94).
- R5 `MUST` Exposition: each voice states S or R at least once; first two entries S then R; usual order
  S-R-S-R; no voice enters twice before all have entered; S in tonic, R in dominant, invariable (§73–74).
- R6 `MUST` When S enters alone, each voice continues after its entry with CS1, then CS2…, then free; the
  last voice to enter carries no CS (§75).
- R7 `PREFER` Codetta only to fill a gap between entries (e.g. to lead the answer back to the tonic) (§93).

## Rules — sections 2 and 3
- R8 `PREFER` Section 2: entries in neighbouring keys **not** used in the exposition (relative, IV, ii,
  vi…), separated by episodes (§78). An episode is needed at least before the first entry of section 2 and
  before section 3 (§95).
- R9 `PREFER` Episodes: derived from S/R/CS fragments, developed by sequence, imitation, inversion,
  aug/dim; each episode different and more interesting than the last; start the episode's design before the
  previous entry ends (no block seams); modulate smoothly to the next entry's key without "spending" it (§67–68, §95).
- R10 `AVOID` A sequence that always stays in the same voice or where all voices just transpose together;
  rotate designs through the voices (§95).
- R11 `PREFER` Section 3: tonic entries, often in **stretto** (overlapping entries), strettos getting closer;
  in an S–R stretto alter the earlier voice, never the last-entering one (§81, §96).
- R12 `PREFER` End over a tonic pedal (usually bass), with a dominant pedal shortly before (§83).
- R13 `PREFER` Cadences sparingly; when cadencing, keep inner voices moving (§70); no conclusive cadence in
  section 1 (§97).
- R14 `ALLOWED` Temporarily reduce or add voices (free filler parts at the end) (§71).

## Planning template (free fugue, 3–4 voices, subject length L bars)
| section | bars | key (major / minor) | material | ends with |
|---|---|---|---|---|
| Exposition | 4L (+codetta) | I–V–I–V / i–v–i–v | S R S R + CS | entry end, no PAC |
| Episode 1 | L–2L | → vi / → III | head/CS sequence | arrival on new key |
| Middle entries | L each | vi, IV, ii (minor: III, iv, VII, v) | S or R, CS optional | elided |
| Episodes 2–3 | L–3L | modulating | new combos, inversion | V of next key |
| Final section | 2L–4L | I / i | stretto(s), V pedal | — |
| Coda | 2–6 bars | I (Picardy in minor optional) | head over tonic pedal | PAC |

## Apply in MIDI / REAPER
- One track per voice (S, A, T, B or instrument names); never let two entries start in the same voice
  consecutively; regions `Expo`, `Ep1`, `Mid vi`, …, `Stretto`, `Pedal`.
- Entry visibility: first note of each entry vel +10 over the texture; free voices vel 60–75.
- Each entry starts on a chord tone, after a rest in that voice (§97).
- Ranges: keep each voice in its own register band (e.g. S 60–79, A 55–74, T 48–67, B 40–60) so entries are
  distinguishable.

## Checklist
- Subject: starts on 1/5, ends on 1/3/5/7(major), range ≤ 12 semitones, distinctive head?
- Exposition: S-R-S-R (or legal variant), keys I/V invariable, all voices enter before any re-entry?
- CS invertible and rhythmically complementary?
- Section 2 keys ≠ exposition keys; episodes between entries; smooth modulations?
- Final tonic section with stretto and pedal; no full stop of all voices before the end?

## Examples
- WTC I/12: tenor S + codetta → CS1; alto R b.4; bass S b.7; soprano b.13 (§75).
- WTC I/3 (C#) section 2: R in relative a# (b.14), S in e# (b.19), g# (b.24), c# (b.26) (§78).
