---
id: orchestration.string-section-writing
title: Writing for the string section (roles, planes, melody)
aliases: [orquestación para cuerda, escritura para cuerda, sección de cuerda, cuerdas, la individualidad dentro del conjunto, primer plano, plano medio, plano de fondo, cruce de voces, doble emparejamiento, sul G, unísono de cuerda, Streicherorchester, Streichersatz]
domain: orchestration
tags: [strings, texture, balance, register, melody, doubling, section-writing]
style_scope: universal
use_when: Writing any passage for the string section as a whole (string orchestra or the strings inside the orchestra), deciding which section carries the melody, or balancing melody, counterpoint and accompaniment inside the strings.
summary: Treat the strings as five independent voices (Vln I, Vln II, Vla, Vc, Cb), label every line foreground, middleground or background, and give the foreground its instrument's best register first; balance by register and scoring before dynamics. Save the highest register of a theme for its climax, keep background figures out of the melody's register and in a contrasting rhythm.
sources: ["adler-orq-es p.111-135", "adler-orq-es p.144-145", "piston-orch p.366-381"]
related: ["[[string-section-writing-homophony]]", "[[string-section-writing-counterpoint]]", "[[string-section-writing-accompaniment]]", "[[texture-types]]", "[[texture-accompanied-melody]]", "[[texture-secondary-melody-countermelody]]", "[[texture-unison-and-tutti]]", "[[line-separation-and-fusion]]", "[[building-and-releasing-climaxes]]", "[[violin]]", "[[viola]]", "[[cello]]", "[[double-bass]]", "[[string-techniques]]", "[[tutti-balance-by-role]]", "[[orchestra-sizes-and-section-balance]]"]
---

# Writing for the string section

## Core idea
Five voices of one colour (Vln I, Vln II, Vla, Vc, Cb); since the Classical quartet each can carry any
role. With one colour, **register and rhythm** separate the lines. Hub note; chords and spacing:
[[string-section-writing-homophony]]; counterpoint: [[string-section-writing-counterpoint]]; soloist
accompaniment and piano transcription: [[string-section-writing-accompaniment]]; texture recipes:
[[texture-types]].

## Rules
- R1 `MUST` Label every line: **foreground** (FG, melody), **middleground** (MG, important counterpoint),
  **background** (BG, chords or figures). Choose the FG instrument and register first, from the line's
  rhythm and intensity; it dictates the MG and BG (Adler).
- R2 `PREFER` Balance by register and scoring first, dynamics second: the leading voice in its best
  register, the supporting voices in weaker ones (Adler).
- R3 `ALLOWED` Rotate a repeated theme through Vln I, Vln II, Vc and Vla (Adler).
- R4 `PREFER` When a lower section takes the melody, keep it in that section's rich upper register even if
  it **crosses** above the parts normally over it; those parts then sit lower or thin out (Adler).
- R5 `MUST` Save a theme's highest register for its climax. `AVOID` raising a first statement an octave
  to strengthen it: it spends the octave the final statement needs (Adler).
- R6 `PREFER` A lyrical, intense mid-low melody (about 55–67) goes to **cellos** in their upper register
  (A string, 57+), then returns later in Vln I an octave higher for the intensification (Adler, Brahms 3/III).
- R7 `AVOID` for an intense lyrical melody in that same band: Vln I low (weak next to the cello), viola
  (sweet but bland) and double bass (a caricature). `ALLOWED` Vln II *sul G*: intense but darker than the
  cello (Adler).
- R8 `PREFER` Melody around 62–72, light to heavy: Vln I alone; Vln II + Vln I 8va; unisons (Vln I+II,
  vlns+vlas, vlns+vcs, vlas+vcs); violin *sul G* for warmth; solo viola or cello for intensity; vlns+vlas+vcs
  unison (strongest single line); all five sections over 4–5 octaves (Adler).
- R9 `PREFER` Keep BG figures **out of the melody's register**. If they must share it, put the FG in its
  best register, the BG figures in their instruments' duller registers, and the basses pizz. (Adler).
- R10 `AVOID` Moving the accompanying violins and violas an octave up: the BG then draws attention and
  steals the register reserved for a later statement (Adler).
- R11 `PREFER` Give the BG a rhythm unlike the melody (soft, fast arpeggios under long melody notes) and
  **dovetail** the sections' figures so the BG flows unbroken (Adler, Brahms 3/III).
- R12 `PREFER` Unisons add weight, octaves add colour but little weight (Piston); Vln I + II in unison
  give body to a melody in a dull register (Adler). High, energetically bowed Vln I holds its own against
  full woodwinds, even ff (Piston).
- R13 `ALLOWED` Contrast phrases by texture: a f unison or octave antecedent, then a p consequent with
  Vln I melody over Vln II + Vla in parallel 3rds (Mozart). Stopping a repeated accompaniment makes the
  next phrase weightless (Adler).
- R14 `ALLOWED` Crescendo on one line: start with 2–3 violins, add sections one octave lower each, up to
  fff (Adler, *Leonore* 3). See [[building-and-releasing-climaxes]].
- R15 `PREFER` Before winds enter, drop the string melody an octave, or double low Vln I with the cellos,
  so the winds are heard (Adler, Haydn 103, Shostakovich 6).

## Period practice
- `[era: Classical, Haydn–Schubert]` The double bass doubles the cello an octave lower in most tutti and is
  dropped for a lighter texture; independent bass parts grow in the 19th century (Adler). Pastiche:
  Cb = Vc − 12 on the structural bass (opening, cadences, dominant pedals, end), tacet in light bars.
- `[era: late 19th c. onward]` Double-bass solos are for lugubrious or comic effect only (Adler).

## Apply in MIDI / REAPER
- Tracks `Vln I`, `Vln II`, `Vla`, `Vc`, `Cb` (+ divisi tracks); note each track's plane per section.
- Levels per plane, from the vault map in [[dynamics-by-orchestration]]: FG at the marked dynamic, MG about
  one step lower (CC1 −10 to −15), BG two steps lower and flatter. [[user-taste]] R15: countermelody about
  3 dB under the melody; lower the heavy bed before raising the melody.
- FG not heard: move or thin a BG part before raising the FG's CC1.
- Cello melody under violin figures: Vc 57–69 at mf, Vln figures 62–76 at pp–p, Cb pizz. on downbeats,
  velocity 50–65.
- (inferred) Albion ONE `Strings High (Octave) - Legato` already plays octaves: add no written octave on
  top. Build planes from separate tracks per register band; exposed solos on SWAM or solo patches.

## Checklist
- [ ] Every string track has one plane (FG/MG/BG) per section.
- [ ] The FG sits in its instrument's best register; no BG figure in the FG band unless in a dull register.
- [ ] The theme's highest octave appears only at its climax.
- [ ] Unisons where weight is needed, octaves where range or colour is needed.

## Examples
- Haydn op.76/3 (after Adler): theme Vln I (Vln II in 3rds/6ths below); var. 1 Vln II under Vln I
  figuration; var. 2 Vc high, Vln II a 3rd above, Vla tonic/dominant pedal; var. 3 Vla above both violins,
  Vc countermelody; var. 4 Vln I an octave higher (climax) over a Vc dominant pedal.
