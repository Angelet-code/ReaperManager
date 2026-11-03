---
id: harmony.voice-leading-parallels
title: Parallel and hidden fifths and octaves (checker spec)
aliases: [quintas paralelas, octavas paralelas, quintas consecutivas, octavas consecutivas, quintas ocultas, octavas ocultas, quintas directas, Quintenparallelen, Oktavparallelen, verdeckte Quinten, verdeckte Oktaven]
domain: harmony
tags: [voice-leading, parallels, checker, four-part]
style_scope: common-practice (style law in chorale/classical textures; NOT a law for rock, planing, or octave doubling of a line)
use_when: Validating generated multi-voice MIDI (choir, string/brass chorale, pad voicings) for forbidden parallel or hidden perfect intervals, and deciding which licences apply.
summary: Between two independent voices, a P5 or P8/unison followed by the same interval with both voices moving the same direction is a parallel and is forbidden; outer voices also must not move in similar motion into a P5/P8 (hidden). Hindemith later tolerates hidden ones in inner/upper pairs, fifths near secondary sevenths and augmented sixths, and fifths involving one non-chord tone — never octaves.
sources: ["hindemith-1 p.4-11", "hindemith-1 p.25-33", "hindemith-1 p.34-38", "hindemith-1 p.39-47", "hindemith-1 p.53-59", "hindemith-1 p.60-72", "hindemith-1 p.88-98"]
related: ["[[voice-leading-basics]]", "[[non-chord-tones]]", "[[diatonic-seventh-chords]]", "[[augmented-sixth-chords]]", "[[harmony-voicing-for-instruments]]", "[[_harmony]]"]
---

# Parallel and hidden fifths and octaves

## Core idea
Two independent voices that move together in perfect fifths or octaves stop sounding independent. The
common-practice ban is a **style law**, not acoustics: it applies between *independent voices*, and Hindemith
relaxes it step by step. An octave doubling of one melodic line (orchestration) is not a parallel.

## Rules
- R1 `NEVER` Parallel octaves or unisons between any two voices.
- R2 `NEVER` Parallel fifths between any two voices in progressions of plain triads and dominant chords.
- R3 `NEVER` Two voices leaping in the same direction into an octave.
- R4 `NEVER` (strict mode) Hidden octaves or fifths between the **outer voices** (soprano–bass): both moving
  in the same direction into a P8 or P5 from another interval. Inner and soprano–inner pairs are exempt (the
  standard rule; Hindemith's very first exercises also ban hidden octaves in other pairs).
- R5 `ALLOWED` (after V7 inversions) Hidden octaves between the outer voices; octaves by contrary motion in
  the outer voices only at the end of a piece or clearly articulated section.
- R6 `ALLOWED` (after V9) Hidden fifths/octaves between two inner voices or soprano + inner voice; `PREFER`
  to mask them with strong contrary motion in another voice.
- R7 `AVOID` Hidden fifths/octaves between soprano and bass even when the texture is constrained (accept them
  elsewhere as the least bad option when soprano/bass are given).
- R8 `NEVER` Two voices moving from a seventh or ninth into an octave in similar motion.
- R9 `ALLOWED` Contrary-motion fifths arising from melodic lines.
- R10 `ALLOWED` Parallel fifths in progressions that contain a secondary seventh chord, when avoiding them
  would force clumsy lines; `NEVER` between soprano and bass.
- R11 `ALLOWED` Parallel fifths in progressions with altered dominants (German sixth → V); the ear is busy with
  the chromatic relation.
- R12 Non-chord tones: fifths between a non-chord tone and a chord tone `ALLOWED`; octaves between them
  `NEVER`; fifths between two non-chord tones of the same kind `NEVER`.
- R13 `NEVER` Let a suspension hide parallels: replace each suspension by its resolution; if the skeleton has
  parallels it fails. `ALLOWED` only in slow tempo, where the delay is long.
- R14 `AVOID` V13/7 → I without checking: it often produces octaves.
  - *Outside this style:* power chords (root+5th) and planing (whole chords sliding in parallel) are
    idiomatic in rock, metal, impressionism, pop and much film music. Bass doubling chord roots in pop
    creates constant octaves — fine. In an orchestral film chorale or string pad, still avoid **exposed**
    parallel octaves/fifths between top line and bass; inner-voice parallels are rarely heard.

## Apply in MIDI / REAPER
Checker over consecutive chord states (voices sorted, independent voices only; merge octave-doubling
tracks into one logical voice first):

```
for t in chords[0..n-2], for each pair (hi, lo):
  i1 = hi[t]-lo[t];  i2 = hi[t+1]-lo[t+1]
  dh = hi[t+1]-hi[t]; dl = lo[t+1]-lo[t]
  same = dh*dl > 0;  contrary = dh*dl < 0
  perf(i) = i%12==0 ? "8" : i%12==7 ? "5" : null
  if perf(i1) and perf(i1)==perf(i2) and same:        -> PARALLEL (R1/R2)
  if perf(i2) and perf(i1)==perf(i2) and contrary:    -> CONTRARY 5/8 (R5/R9, info)
  if perf(i2) and perf(i1)!=perf(i2) and same:        -> HIDDEN (R4/R7 outer pair only; else info, R6)
      if i1%12 in {10,11,1,2} and perf(i2)=="8":      -> FAIL (R8)
  if all 4 voices leap (|d|>2) same direction:        -> FAIL (voice-leading-basics R5)
```

- Severity by `mode`:
  - `strict` = school chorale / harmony exercise: fails R1, R2, R3, R8 and R4 (outer-voice hidden 5ths/8ves).
  - `relaxed` = "estilo clásico" pieces, string quartet, orchestral pads/choir (default): fails R1, R2, R3, R8;
    outer-voice hidden 5ths/8ves are warnings (R7).
  - `pop/film-planing` = pop, rock and film colour layers (pads, power chords, planing): reports parallels
    between top and bass only, as warnings.
- Licences: downgrade R2 to warning if either chord is a secondary seventh (R10) or an augmented-sixth/altered
  dominant (R11), unless the pair is soprano–bass.
- NCT pass: run once on chord tones (suspensions replaced by resolutions, R13), once on the surface applying
  R12. Treat tempo ≤ 60 BPM with suspensions ≥ 1 beat as "slow" (heuristic, not in source).
- Skip pairs where either voice is static (dh or dl = 0): oblique motion is never a parallel.

## Checklist
- No parallel 8ves/unisons anywhere? No parallel 5ths outside R10/R11 licences?
- Soprano–bass free of parallels and hidden 5ths/8ves?
- No octave reached from a 7th/9th in similar motion?
- Suspensions do not hide parallels (or tempo is slow)?

## Examples
- C: bass C3→D3 under alto G3→A3 = parallel fifths (fail).
- Outer voices: soprano B4→C5 while bass G2→C3 rises = hidden octave (fail strict, warning relaxed).
- German sixth Ab2–C4–Eb4–F#4 → G2–B3–D4–G4: Ab/Eb → G/D fifths (licensed, R11).
