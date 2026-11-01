---
id: harmony.cadences
title: Cadences (authentic, plagal, half/Phrygian, deceptive, Picardy)
aliases: [cadencia, cadencia perfecta, cadencia auténtica, cadencia plagal, semicadencia, cadencia frigia, cadencia rota, cadencia evitada, cadencia deceptiva, tercera de Picardía, seis cuatro cadencial, Kadenz, Ganzschluss, Halbschluss, Trugschluss, plagaler Schluss, phrygischer Halbschluss, pikardische Terz]
domain: harmony
tags: [cadence, phrase-ending, key-definition]
style_scope: common-practice (strength ranking is useful in any tonal style; film often avoids full closure on purpose)
use_when: Ending a phrase, section or piece, establishing a key (start of piece, after a modulation), or choosing how closed or open an ending should sound.
summary: A cadence of at least three chords ending V–I establishes a key and is the strongest close; the further the penultimate chord is from the tonic, the weaker the cadence (IV–I plagal is softer). Half cadences end on V (Phrygian: iv6→V in minor) and sound open; V→VI is deceptive; the final chord of a piece is root-position tonic.
sources: ["hindemith-1 p.18-24", "hindemith-1 p.25-33", "hindemith-1 p.48-52", "hindemith-1 p.53-59", "hindemith-1 p.73-81", "hindemith-1 p.99-108", "hindemith-2 p.11-18", "hindemith-2 p.22-29"]
related: ["[[modulation]]", "[[triads-and-inversions]]", "[[dominant-seventh]]", "[[diatonic-secondary-triads]]", "[[mode-mixture-and-neapolitan]]", "[[_form]]", "[[_film-scoring]]", "[[_harmony]]"]
---

# Cadences

## Core idea
The shortest form of a cadence is three chords of one key, the last the tonic. It is the main tool to make a
key unmistakable — at the start, at section ends and after every modulation. Cadence strength depends on the
penultimate chord: V is the strongest, more distant chords make weaker closes.

## Rules
- R1 `PREFER` Establish a key with a cadence ending on I with V immediately before it; the chord before V may
  be any degree (II, II6/5, IV, I6/4…).
- R2 `MUST` Principle: the more distant the penultimate chord from the tonic, the less decisive the cadence.
- R3 `AVOID` Plagal IV→I where the strongest close is needed; use it as a softer close or an extension after
  V–I.
- R4 `PREFER` Cadential formula: (II6/5 or IV) → I6/4 → V(7) → I, with the 6/4 on the stronger beat and its
  bass doubled (see [[triads-and-inversions]]).
- R5 Half cadence (semicadencia) ends on V. Phrygian form: in minor iv6→V (bass b6→5); in major the borrowed
  minor iv6→V. `AVOID` using it to define a key; use it inside a progression or as a deliberately open ending.
- R6 `PREFER` Deceptive cadence V(7)→VI in place of an expected V→I; darker variant in major V7→bVI.
- R7 `ALLOWED` Neapolitan cadence: bII6 → (I6/4) → V → I (see [[mode-mixture-and-neapolitan]]).
- R8 `ALLOWED` End a minor piece on a major tonic (Picardy third); a major piece ending minor is rarer.
- R9 `MUST` Final chord: tonic in root position; never a seventh chord or inversion. A bare-root unison chord
  only as last chord; no bare fifth/unison right after a tritone chord.
- R10 `ALLOWED` Cadences may be expanded with extra chords and ornamentation into whole phrases.
- R11 `AVOID` Bass-type cadential leaps (4ths/5ths) when the bass line is in tenor register (~C3–C4, MIDI
  48–60); move by step or third there.
- R12 `MUST` (exercise stage without modulation) Only diatonic full cadences and half cadences; return to the
  tonic often when using altered chords so the listener stays oriented.
  - *Outside this style:* film cues often avoid V–I closure to stay open under picture (end on IV, bVI, a
    suspended chord or a pedal); pop uses plagal, bVII–I and iv–I as normal closes (general knowledge).
    Keep a real V–I where the drama needs a full stop. See [[_film-scoring]].

## Apply in MIDI / REAPER
- Strength score for a phrase end (inferred from R2): V7–I root position, soprano on tonic = 5; V–I with
  soprano on 3rd/5th = 4; inverted V or I = 3; IV–I = 2; deceptive V–VI = 1 (continuation); half cadence =
  0 (open). Pick per phrase from the form plan ([[_form]]): last phrase 5, intermediate 2–4, antecedent 0.
- Place the final tonic on a strong beat (bar 1 of the bar group), the cadential 6/4 on the beat before V's
  arrival, V on a weaker beat or half-bar.
- Ritardando and dynamics belong to the performance layer: for a final close, slow the tempo map 5–10 %
  over the last bar and let CC1 settle on the tonic.

## Checklist
- Each key area confirmed by a cadence ending V→I?
- Penultimate chord matches the intended strength?
- Final chord root-position tonic, not after a bare fifth?
- Bass in tenor register approaches the final note by step?

## Examples
- C: II–V–I (bass D3–G2–C3); II6/5–I6/4–V7–I.
- C minor half cadence: Ab2 (iv6) → G2 (V, B natural).
- Deceptive: C: V7 → A minor; dark variant V7 → Ab major.
- A minor Picardy: … E7 → A major.
