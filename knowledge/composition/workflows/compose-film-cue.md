---
id: workflow.compose-film-cue
title: Compose an orchestral / film cue in REAPER
aliases: [componer un cue, música para imagen, banda sonora, pieza épica, música orquestal, música de aventura, tema heroico]
domain: workflow
tags: [workflow, film, orchestral, planning]
style_scope: film
use_when: The user asks for an original orchestral, cinematic, epic, trailer-like or "soundtrack" piece or section.
summary: "Eight stages: brief, harmonic plan, section map with tension curve, template tracks, the five elements written per section, orchestration and doubling, validation, then hand-over for listening. Each stage has one required note; open the others only when that stage needs them. Total is about 8–12 notes."
sources: ["film-4day-challenge", "httyd-test-drive", "hindemith-2", "unir-orquestacion"]
related: ["[[user-taste]]", "[[plan-a-piece]]", "[[validate-generated-midi]]"]
---

# Compose an orchestral / film cue

Each stage has one **Required** note and some **On demand** notes. Open an on-demand note only if the
required note's summary leaves the decision open. Each stage produces a small table that the next stage
uses. Keep the tables in the chat or a scratch file: they are the plan.

## 1. Brief
Required: [[user-taste]].
- Pin down mood words (in the user's Spanish), length, tempo, meter, key and the reference track.
- **Length:** `bars = seconds × bpm / (60 × beats_per_bar)`. For example, 60 s at 114 BPM in 4/4 is
  about 28 bars.
- If the user fixed the key, don't apply the key-lift tricks.
- Settle the ensemble against the user's libraries (R11).
- Ask one question if the mood or the length is unclear.

## 2. Harmonic plan
Required: [[harmony-emotion-mapping]].
On demand:
- [[harmonic-storytelling-chord-functions]] for the order of chord functions;
- [[harmonic-rhythm-scene-dialogue]] for chords per bar, or when there is dialogue;
- [[secondary-dominants]] and [[mode-mixture-and-neapolitan]] for colour chords.

Output: the chord palette and the harmonic rhythm per section.

## 3. Section map and tension curve
Required: [[building-and-releasing-climaxes]] (it includes ending types; "acabar arriba" means a
tutti button on I).
On demand:
- [[harmonic-planning-seven-factors]] for long or subtle cues;
- [[httyd-test-drive-case-study]] for its section maps scaled to 30, 60 and 90 s;
- [[section-functions]].

Output: `| section | bars | key | tension 0–3 | texture | lead | ends with |`, plus REAPER regions per section.

## 4. Template
Required: [[orchestral-mockup-template]].
On demand: [[reverb-strategy-orchestral]] and [[stage-seating-pan-depth]], when creating the returns and
the pans.
Create only the tracks the map needs (build_beat spec) and tell the user which Kontakt patches to load.

## 5. Write per section, layer by layer
Required: [[five-elements-arrangement-checklist]].
On demand, layer by layer:
1. Bass and harmony: [[harmony-voicing-for-instruments]].
2. Melody: [[heroic-theme-orchestration]] for a heroic tune, [[thematic-development]] for variation.
3. Movement: [[action-ostinato-pedal-gallop]].
4. Glue and enhancers: [[texture-accompanied-melody]].
5. Percussion: [[film-percussion-phrase-marking]].

Every section has bass plus direction or movement. Enhancers go mostly at transitions.

## 6. Orchestrate
Required: [[doubling-colour-and-decay]].
On demand:
- [[bass-line-doubling]] and [[line-separation-and-fusion]];
- [[dynamics-by-orchestration]], which holds the CC1/velocity map;
- the note for an instrument whose limits you are unsure of ([[_instruments]]).

## 7. Validate
Required: [[validate-generated-midi]]. It drives `data/instruments.json`, the
[[orchestration-errors-checklist]] and [[voice-leading-parallels]] for chorale-like passages.

## 8. Hand over
Summarise in Spanish: sections and bars, what each track plays, and which patches to load. Ask the
user to listen. Apply fixes surgically ([[user-taste]] R10).
