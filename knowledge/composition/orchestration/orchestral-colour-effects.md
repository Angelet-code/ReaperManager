---
id: orchestration.orchestral-colour-effects
title: Orchestral colour effects (two-colour sforzando, subito piano, dovetailing, note colouring)
aliases: [efectos especiales orquestales, usos de la orquesta para efectos especiales, sforzando a dos colores, sforzando combinado, forte subito piano, subito piano por superposición, fp orquestal, cola de milano, superposición, encadenamiento de timbres, relevo, coloración de una nota, colorear una nota, nota coloreada, digitaciones alternativas, cuerda indicada, voz principal, voz subsidiaria, Hauptstimme, Nebenstimme, orquestación por mezcla de colores, gesto primario]
domain: orchestration
tags: [effects, colour, sforzando, subito-piano, dovetailing, note-colouring, hauptstimme, timbre]
style_scope: universal (Adler 2002; examples Classical to 20th c.)
use_when: Making an orchestral accent, a sudden drop from ff to p, a seamless relay of a figure between sections, a held note that changes colour, or marking which line is principal in a dense texture.
summary: "Orchestral effects come from combining sections, not from one track's CC. An sf is two colours on one attack (a short pizz, trumpet or oboe note over a held note); a forte-subito-piano is a soft group entering under a loud one that then stops; a seamless relay shares one note between outgoing and incoming instruments; a held note can be coloured by passing it between instruments at one soft dynamic. In dense textures mark the principal line one dynamic level above the rest."
sources: ["adler-orq-es p.595-599", "adler-orq-es p.601-603"]
related: ["[[orchestral-colour-effects-klangfarbenmelodie]]", "[[texture-accompanied-melody]]", "[[texture-accompanied-melody-doubling-the-tune]]", "[[texture-secondary-melody-countermelody]]", "[[doubling-colour-and-decay]]", "[[dynamics-by-orchestration]]", "[[building-and-releasing-climaxes]]", "[[line-separation-and-fusion]]", "[[string-techniques-colour-effects]]", "[[woodwind-basics-articulation-and-effects]]", "[[legato-overlap-and-attack-offsets]]", "[[user-taste]]"]
---

# Orchestral colour effects

## Core idea
Adler's chapter-15 "special effects" are made by **overlapping sections**, not by one instrument playing
harder or softer. Each effect has a mechanism an agent can write as separate tracks. Choosing and doubling
the melody itself is in [[texture-accompanied-melody-doubling-the-tune]]; one note per instrument across a
whole line (pointillism, Klangfarbenmelodie) is in [[orchestral-colour-effects-klangfarbenmelodie]].

## Rules
**Sforzando and subito piano**
- R1 `PREFER` Build an important *sf* from **two colours on the same attack**; an accent alone is often not
  enough (Ex. 15-36). Pairs: string pizz *sf* on a long woodwind note's attack (Beethoven 1/I); a short
  trumpet a2 *sf* over sustained strings *sf*; a short oboe *sf* over strings *sf* → *pp*; divided viola
  pizz *sff* under sustained violins *pp*.
- R2 `MUST` **Forte subito piano by overlap:** group A plays the *ff* note or chord; before it ends, a
  different group B enters *p* (or *pp*) and holds that level; when A stops, the ear hears a sudden piano.
  The two must overlap (Ex. 15-37: 3 trumpets *ff* with 3 flutes entering *pp*; Vln I div *ff* with Vln II
  div entering *pp*). This complements [[dynamics-by-orchestration]] R10.

**Seams and relays**
- R3 `MUST` **Dovetailing (cola de milano):** when a figure passes between similar instruments for a
  seamless colour change, each incoming instrument enters on the outgoing one's **last note**, so both play
  it (Ex. 15-38a: rising triplet arpeggio cello → viola → Vln II → Vln I). Same rule for melody handoffs:
  [[texture-accompanied-melody]] R8.
- R4 `ALLOWED` Hand over **without** the shared note only when you want each group to sound accented
  (Ex. 15-38b).

**Colouring a note**
- R5 `ALLOWED` **Colour one held pitch** by passing it between instruments, each entering before the last
  releases, all at the same soft dynamic (Ex. 15-39: one C, probably C5 = 72 [?], oboe → flute → bassoon →
  clarinet → English horn, all *pp*).
- R6 `ALLOWED` Colour **each note of a line** with a different instrument (Ex. 15-40). Only practical when
  every instrument plays its note in a comfortable register at the same dynamic. Fully developed, this is
  pointillism: [[orchestral-colour-effects-klangfarbenmelodie]].
- R7 `ALLOWED` Colour a note **within one family**: `[era: late 20th c.]` alternate fingerings on two flutes
  alternating the same pitch (Ex. 15-41); on strings, name the string (*sul G*, *sul D*, see
  [[string-techniques-colour-effects]]); on brass, alternate valve fingerings, checked with a player first.

**Principal and subsidiary voices**
- R8 `PREFER` In a dense contrapuntal texture mark the **Hauptstimme** (H, principal) one dynamic level above
  the **Nebenstimmen** (N, subsidiary): cello H *p*, trumpet, clarinet, trombone and EH ideas *pp*
  (Schoenberg Op. 16/5). The general rule lives in [[texture-secondary-melody-countermelody]] R4.
- R9 `PREFER` Keep H audible: a light texture needs no doubling (solo oboe); when brass thickens around
  it, add woodwinds (clarinets join flutes + Vln II); when H sits in an inner instrument against a busy
  counter-gesture, let others trace its outline. Double only at unison or octave.
- R10 `ALLOWED` A doubler may enter on a dissonant note for momentary tension (Vln I on E6 = 88, resolving
  to C#4 = 61); a soft high lyrical solo may go to muted trombone 1 instead of cello.

## Period practice
- `[era: early 20th c., Schoenberg]` orchestration **by colour mixing**: any instrument takes any plane and
  all families blend for each gesture (Adler hears Op. 16/5 as close to the 19th-c. sound, modern in its
  extreme registers). The opposite habit, section blocks, is in [[texture-types]].

## Apply in MIDI / REAPER
Dynamic numbers follow the vault map in [[dynamics-by-orchestration]].
- **Two-colour sf:** long track (`FL`/`OB`/`CL` or string longs) with an fp CC1 shape (≈ 100 for the first
  16th, down to the target within an 8th) plus **one short note** on the same beat in `STR PIZZ`, `TPT` or
  `OB` staccato (len ≤ 0.5), velocity 110–125, onsets within ±5 ms (inferred). The short attack also hides the slow attack of sampled longs (inferred; see
  [[legato-overlap-and-attack-offsets]]).
- **Subito p:** group A's notes last 1–2 beats past group B's entry; B enters on the same chord (inferred)
  at CC1 15–35, flat; A stops with a clean note-off, not a CC fade. Never fake it with one track's CC1 drop.
- **Dovetail relay:** track B's first note = track A's last note (same pitch and onset); A's note may end
  0.5–1 beat into B's segment, which also hides patch attack differences. For R4, end A a 16th before B and
  accent B's first note (velocity +10).
- **Coloured held note:** 2–5 tracks on one pitch, each overlapping the previous by about one beat, all at
  CC1 15–25 (pp); crossfade CC11 over the overlap (incoming 60 → 100, outgoing 100 → 60). Prefer solo
  patches; ensembles blur the change (inferred).
- **Hauptstimme:** H track CC1 about 10–15 above every N track (inferred); [[user-taste]] R15 gives the
  measured target (countermelody about 3 dB under the melody). Lower the N tracks before raising H.

## Checklist
- Is every important *sf* made of two colours sharing one onset?
- Does each subito piano have the soft group sounding **before** the loud group stops?
- Do relays share a note unless an accented hand-over is wanted?
- In a coloured note, do all instruments sit in a comfortable register at one dynamic?
- Is exactly one H line per passage, one level above the rest, and audible in its texture?
