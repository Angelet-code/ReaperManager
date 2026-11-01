---
id: form.theme-and-variations
title: Theme and variations
aliases: [tema con variaciones, variación, variación ornamental, variación melódica, variación decorativa, variación armónico-contrapuntística, variación amplificativa, gran variación, variación libre, doble, diferencias, canzona, Variationen]
domain: form
tags: [variation, theme-and-variations, double, ornamentation]
style_scope: common-practice
use_when: When writing a set of variations, a varied repeat (double), or deciding how far a returning theme may be changed.
summary: State a plain, usually slow theme (8–32 bars) first; ornamental variations keep its bar count, cadences, harmony per bar and melodic basic points while changing surface rhythm/figuration; decorative variations keep the melody and change harmony/counterpoint around it; amplifying (free) variations build a new idea from one cell. Same key throughout, one variation in the opposite mode, optional fugal finale or coda.
sources: ["zamacois-formas p.136-150 (§104-117)", "zamacois-formas p.151-154 (§121)"]
related: ["[[ostinato-chaconne-passacaglia]]", "[[thematic-development]]", "[[phrase-structure]]", "[[school-fugue-plan]]", "[[_harmony]]"]
---

# Theme and variations

## Core idea
A chain of short, closed pieces all based on one theme, stated first (§104). Three types (§105):

| type (ES) | what changes | what stays |
|---|---|---|
| ornamental / melodic (rítmica if only values change) | melody surface: figuration, rhythm, meter, mode, tempo | melody's **basic points**, harmony, period structure, bar count |
| decorative / harmonic-contrapuntal | harmony, counterpoint, texture, register of the theme | the melody, unchanged |
| amplifying / free / grand | almost everything | one cell (contour, rhythm or harmony) generating a new idea |

**Basic points** of a melody = its highest/lowest chord tones, the notes on the main metric accents, and
its cadences (§105-109).

## Rules
- R1 `MUST` Begin with the theme; it is normally the only protagonist (§110).
- R2 `PREFER` Theme slow-ish and plain in line, so figuration does not overload it; a complete phrase or a
  short piece (minuet, gavotte, song) (§110).
- R3 `MUST` Non-amplifying variations run **parallel** to the theme: same bar count, same period lengths,
  essentially the same harmony in each bar (§110).
- R4 `ALLOWED` Amplifying variations are completely free in length and plan (§110).
- R5 `PREFER` Each variation is a closed, numbered unit; links between them are audible seams (§110).
- R6 `PREFER` Same tonic for all; changing **mode** for one variation is allowed and classic
  (Minore/Maggiore). Key changes are a post-classical licence (op.34: F–D–Bb–G–Eb–c–F) (§110).
- R7 `ALLOWED` End with a non-variation piece derived from the theme (fugue, fugato) or a coda (§110).
- R8 `ALLOWED` Mix types within one variation (theme in the left hand + ornamented former accompaniment) (§105-109).
- R9 `AVOID` Variations that are only scales/arpeggios unrelated to the theme (19th-c. virtuoso filler) (§116).
- R10 `MUST` A **double** = ornamented repeat of a dance piece **without** changing meter, tempo or
  harmonic frame (§111-117, §121). Spanish *diferencias* (Cabezón), English divisions and *follias* are the same family.
- R11 `ALLOWED` Canzona-type rhythmic variation: theme in duple meter, restated in triple meter, same key (§111-117).

## Planning template (theme + N variations)
| section | bars | key | material | ends with |
|---|---|---|---|---|
| Theme | 16 (8+8, often ‖: :‖) | I | plain melody, simple chords | HC b.8, PAC b.16 |
| Var. 1 | 16 | I | ornamental: 8th-note figuration | same cadences |
| Var. 2 | 16 | I | 16ths or triplets; melody in inner/bass voice (decorative) | same |
| Var. 3 | 16 | I | rhythmic: dotted/syncopated, or meter change | same |
| Var. 4 | 16 | i (Minore) | mode change, slower, expressive | same (minor) |
| Var. 5 | 16 | I | canon or imitation on the head | same |
| Var. 6 | 16–32 | I | Adagio ornamental, or free (amplifying) | may extend |
| Finale | 20–60 | I | fugato on the head / brilliant coda | PAC |

Order principle (general knowledge): rising rhythmic density (8ths → triplets → 16ths), then a slow/minor
relief, then the fastest or most contrapuntal variation and the finale.

## Apply in MIDI / REAPER
- Keep the theme's chord-per-bar list as data; every ornamental variation must reuse it bar for bar.
- Extract basic points (downbeat notes + local peaks/troughs + cadence notes) from the theme MIDI; figuration
  must hit each basic point on (or within one 16th of) its original beat.
- Figuration patterns: neighbour-note 16ths around each melody note; arpeggiate the bar's chord in triplets;
  Alberti bass (low–high–mid–high 16ths) under a held melody.
- One REAPER region per variation (`Var 3 minore`); 0–1 bar gap or none; tempo markers only where the variation
  is marked slower.

## Checklist
- Does each ornamental/decorative variation have exactly the theme's bar count and cadence points?
- Are the basic points of the melody audible on their beats?
- Is there contrast of density/mode/register between consecutive variations?
- Is at least one variation in the opposite mode and does the set end with a clear close?

## Examples
- Beethoven op.26 (Ab, 3/8): Var. I and V align bar-for-bar with the theme (ornamental) (§105-109).
- Beethoven op.14/2 II: Var. I puts the theme in an inner voice under a new syncopated line (decorative) (§105-109).
- Beethoven op.109 III: Var. V built on the theme's first notes (amplifying) (§105-109).
- Schumann *Symphonic Etudes*: 16-bar AABA theme; variations in other keys, a canon, a rondo finale (§117).
