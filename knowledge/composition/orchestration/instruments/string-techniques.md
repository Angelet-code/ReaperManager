---
id: orchestration.string-techniques
title: String techniques and articulations
aliases: [técnicas de cuerda, articulaciones de cuerda, golpes de arco, arcos, pizzicato, sordina, con sordina, divisi, trémolo, armónicos, sul ponticello, sul tasto, col legno, spiccato, détaché, Bogenstriche, Dämpfer, geteilt]
domain: orchestration
tags: [strings, articulation, sample-library, divisi, pizzicato, mute]
style_scope: universal
use_when: Choosing string articulations/patches, writing bowings, pizz, mutes, tremolo, harmonics, double stops or divisi for any string section.
summary: Bowed strokes run legato → détaché (unmarked, the most common, fastest) → staccato/spiccato (dotted, bouncing at moderate tempo p–mf); fast runs are détaché, not legato. Pizz, mute and divisi changes need time; double stops need an open string; in sections prefer divisi to chords.
sources: ["unir-orq-tema4 p.5-14, 15-21, 21-26, 26-32", "unir-orq-tema1 p.6-8"]
related: ["[[violin]]", "[[viola]]", "[[cello]]", "[[double-bass]]", "[[orchestra-sizes-and-section-balance]]", "[[_instruments]]"]
---

# String techniques and articulations

## Core idea
Two families of bowing: bow **drawn** on the string (legato, détaché, and lifted staccato) and bow **struck/
bounced** on the string (spiccato, jeté, col legno) with an audible noise component. Plus left-hand and
colour techniques: pizzicato, mute, tremolo, harmonics, bow position. Each maps to a sample-library patch.

## Rules
**Bowing**
- R1 `PREFER` down-bow (frog→tip, natural diminuendo) on strong beats, up-bow (natural crescendo) on upbeats.
- R2 `AVOID` bow changes inside long notes except very long ones; sections stagger bowing for endless
  pads (general knowledge: a single bow lasts ≈ 3–5 s at f, up to ≈ 10–15 s at pp).
- R3 `ALLOWED` near the bridge = brighter, more powerful; at the tip = lighter; at the frog = heavier.
**Articulations**
- R4 `PREFER` **détaché** (no slur, no dot) as the default stroke: slightly separated, light, allows the most speed.
- R5 `PREFER` fast passages in détaché, `AVOID` legato for fast runs (blurs; Flight of the Bumblebee).
- R6 `ALLOWED` staccato/spiccato (dot): bounced from mid-bow at moderate tempo, p–mf.
- R7 `MUST` slurs (several notes in one bow) = legato; notes under one slur must fit one bow length.
**Pizzicato**
- R8 `MUST` mark "pizz." and "arco" and leave time to switch (more after a down-bow).
- R9 `ALLOWED` pizz sustains better on longer/heavier strings and open strings: basses and cellos ring,
  violin pizz is short and weak against winds. Orchestral pizz is rare before the 19th c.
**Mute (con sordino / sord.)**
- R10 `MUST` mark on/off with time to fit or remove the mute; it veils and softens the sound.
**Multiple stops and divisi**
- R11 `MUST` triple/quadruple stops include at least one open-string pitch; keys near open strings
  (D, G, A, E, C) are easiest. Violin most flexible, viola rare, cello no seconds, bass rare.
- R12 `PREFER` divisi over multiple stops in sections; each desk of two splits (outer = upper, inner = lower).
  `MUST` mark "div." and "unis.". Divisi halves the players per line: a 12-player section div. a 2 sounds like two 6-player
  sections (thinner, softer); div. a 3/a 4 of a small section turns soloistic (inferred). Small numbers are
  least harmful in cellos (2 usable), worst in violins (see [[orchestra-sizes-and-section-balance]]).
**Colour techniques (general knowledge; source only names sul pont/sul tasto/jeté)**
- R13 `ALLOWED` bowed tremolo (unmeasured: three slashes) for tension/shimmer; fingered tremolo between two
  notes ≤ a 4th on one string.
- R14 `ALLOWED` sul ponticello (glassy, eerie), sul tasto/flautando (soft, flute-like), col legno (wood of
  the bow, dry clicks), natural and artificial harmonics (pure, whistle-like, pp only).
- R15 `ALLOWED` measured trills (half/whole tone) on all strings.

## Apply in MIDI / REAPER
| Score marking | Sample patch | MIDI behaviour |
|---|---|---|
| slur | legato | overlapping notes (5–30 ms) trigger transitions; CC1 dynamics |
| no marking, long notes | sustain/long | CC1 + CC11 shapes; one swell per bow |
| no marking, fast notes | short détaché / staccato / spiccato | velocity = dynamics; note length ≈ 50–80 % of the step |
| dot, moderate tempo, p–mf | spiccato | velocity 40–90 |
| accent / marcato | marcato or short with high velocity | vel 90–120 |
| pizz. | pizzicato | velocity = dynamics; length irrelevant except damping |
| trem. | tremolo | CC1 swells; good for crescendos |
| con sord. | con sordino long/short | separate track or keyswitch |
| sul tasto / flautando, sul pont., harmonics, col legno | matching patch if present | otherwise long pp + EQ (inferred) |

- Patch switches (pizz ↔ arco, mute on/off) on the same section: leave ≥ 1 beat at moderate tempo for pizz,
  ≥ 2 beats for the mute (inferred from R8, R10). Put muted/pizz material on separate tracks when possible.
- Divisi: one monophonic track per divisi line (`Vln I div a`, `div b`); use smaller-section patches if
  the library offers them.
- Ensemble patches (e.g. Albion ONE "strings high/low") cover several sections at once: still apply each
  real instrument's range ([[violin]], [[viola]], [[cello]], [[double-bass]]).

## Checklist
- [ ] Slurred groups fit one bow (≈ ≤ 4 s at f, ≤ 10 s at pp).
- [ ] No legato patch on fast runs (16ths ≥ ~120 bpm).
- [ ] Every pizz/arco and sord change has a rest before it.
- [ ] Chords on one string track are playable stops (open string included) or split into divisi tracks.
- [ ] Harmonics, col legno and sul pont are marked p–mp and used as colour, not as the main line.

## Examples
- Ravel *Tombeau de Couperin*, Rigaudon middle: pizz with divisi.
- Upbeat 8th up-bow → downbeat half note down-bow: CC1 small rise into the downbeat.
