---
id: form.section-functions
title: Section functions — principal, secondary, intro, transition, retransition, coda
aliases: [período principal, período secundario, frase principal, frase secundaria, introducción, coda, codetta, puente, transición, conducción, retransición, apéndice de dominante, episodio, soldadura, Überleitung, Rückführung]
domain: form
tags: [form-function, transition, retransition, coda, introduction, episode]
style_scope: common-practice
use_when: When deciding what job each section of a piece does (state, contrast, connect, prepare a return, close) and how its harmony and stability should behave.
summary: Principal sections are tonally stable and get re-exposed; secondary sections (episodes, transitions) serve them — modulating, less characterful, ending open on V7 of home; intros prepare, codas affirm the tonic, retransitions prolong the dominant before a return, and welds fill gaps without adding bars.
sources: ["zamacois-formas p.22-24 (§26-28)", "zamacois-formas p.38-41 (§40)", "zamacois-formas p.42-48 (§42)", "sonata-outline"]
related: ["[[suspensive-conclusive-endings]]", "[[key-plans-small-forms]]", "[[phrase-asymmetry]]", "[[thematic-development]]", "[[sonata-form]]", "[[form-for-modern-songs]]", "[[modulation]]"]
---

# Section functions

## Core idea
Every section has a **function** independent of its material. Zamacois: alternate **rest** (principal,
stable) and **motion** (secondary, modulating); returns are prepared on the dominant; the end is affirmed
on the tonic. Plan the function first, then fill it with material.

## Rules
- R1 `PREFER` One **principal** unit per phrase/section, usually the first; whatever is re-exposed is
  principal by definition (§26).
- R2 `MUST` Secondaries must not outshine the principal, and the principal must have personality (§26d).
- R3 `PREFER` Principal sections stay in the home key (brief internal touches only); secondary sections
  modulate (§42.5).
- R4 `PREFER` Secondary sections between returns end suspensive on **V7 of the home key** — classic path:
  reach the dominant key, affirm its tonic, then reinterpret that tonic as V(7) of home (§42.2).
- R5 `PREFER` Near the end of a section, introduce the germ (rhythm or motif) of the next one (§42.3).
- R6 `ALLOWED` Reduced phrases or fragments may serve as connecting "no-man's-land" passages (puente);
  a single V7 chord can be the whole link (§42.7).
- R7 `PREFER` Codas are far more common than introductions; long codas chain short fragments, each of
  which could end the piece; a coda affirms the tonic (§27, §42.8). Modern taste: short, sudden endings.
- R8 `ALLOWED` Introductions: from a few notes to a whole slow section; often slow before a fast movement;
  their material may become thematic later (§42.8, op.13 Grave).
- R9 `PREFER` Use a weld (soldadura) — a run or fill in the gap — rather than adding a bar when a rhythmic
  hole would open between sections (§28).

## Function table (planning vocabulary)
| function | ES | tonal behaviour | typical length | ends with |
|---|---|---|---|---|
| introduction | introducción | prepares home key, often on V | 2–16 bars | HC / V (or V7) |
| principal / theme | frase principal / tema | stable in key | 8–16 | HC or PAC |
| transition / bridge | puente, transición, conducción | **modulates** | 4–16 | V of new key or its I |
| episode / contrast | episodio, frase secundaria | new key/mode | ½–1× principal | V7 of home |
| development | desarrollo | keys away, sequences | free | V pedal of home |
| retransition | retransición, apéndice de dominante | dominant prolongation | 2–8 | V7 → return downbeat |
| closing / codetta | coda de exposición, codetta | affirms key reached | 2–8 | PAC in that key |
| coda | coda | tonic, often subdominant touch | 4–25+ | PAC, repeated cadences |

## Apply in MIDI / REAPER
- Create one REAPER **region per section** named `function key bars`, e.g. `A I 1-8`, `TR I→V 9-20`,
  `B V 21-36`, `RT V-ped 97-100`. Colour by function (principal = one colour, all transitions another).
- Retransition: bass pedal on degree 5 (C major: G1=31 or G2=43) held/re-attacked every bar; upper voices
  sequence a motif fragment; CC1/CC11 ramp up 20–40 across the region; optional fermata/break on V7.
- Coda: repeat V–I or IV–V–I in shortening units (2 bars, 1 bar, half bar), then 2–4 bars of tonic; a
  touch of IV or ii (subdominant) before the last V strengthens closure (§41).
- Weld: 16th-note pickup run or drum fill in the last beat before the new section.

## Checklist
- Does each section have exactly one function label?
- Do principal sections stay in key and transitions actually modulate?
- Does each contrasting section end on V/V7 of the key that follows?
- Is there a dominant preparation (or a deliberate sudden entry) before each return?
- Does the coda affirm the tonic and stay shorter than the main sections (unless a codal development)?

## Examples
- Sonata op.13 II (Ab): principal 8 bars stays in Ab; secondary (bar 17) f minor → Eb, Eb turned into V7 of
  Ab, dominant appendix bars 23–28, return (§42).
- Pop analogue: pre-chorus = transition, drum fill = weld, last chorus + tag = coda (see [[form-for-modern-songs]]).
