---
id: orchestration.wind-band-transcription
title: Band ↔ orchestra transcription (string effects for band, band colours for orchestra)
aliases: [transcripción de banda a orquesta, transcripción de orquesta a banda, adaptar para banda, pasar a banda, adaptar banda a orquesta, simular cuerdas en banda, recomposición, voz principal, voz secundaria, Hauptstimme, Nebenstimme, sustitución de colores]
domain: orchestration
tags: [band, wind-ensemble, transcription, substitution, recolouring, strings, balance]
style_scope: band and orchestral transcription (Adler's models — Milhaud *Suite française*, Schoenberg Op.43a/b; 20th-c. American practice)
use_when: Converting an orchestral cue to concert band or wind ensemble, or a band/wind piece to orchestra, including mapping band-only instruments (saxes, cornets, euphonium) and string effects.
summary: "Map by function, not by name, and keep the foreground/background planes and the composer's colour choices. Band → orchestra: no orchestral section equals the band's clarinet mass, so thin each wind part to one player, move sustained countermelodies to strings, keep the brass in reserve, and thin the accompaniments. Orchestra → band: pick the wind that best makes each string effect (pizz. → staccato brass + mallet, single-note tremolo → xylophone or piano tremolo) and never try to imitate cellos + basses."
sources: ["adler-orq-es p.715-741", "adler-orq-es p.779-784"]
related: ["[[wind-band]]", "[[orchestrate-from-piano-sketch]]", "[[orchestrate-from-piano-sketch-other-transcriptions]]", "[[string-techniques-colour-effects]]", "[[string-techniques-pizzicato-harmonics]]", "[[saxophones]]", "[[tuba-family-and-relatives]]", "[[mallet-percussion]]", "[[line-separation-and-fusion]]"]
---

# Band ↔ orchestra transcription

## Core idea
Neither medium can sound like the other, and arguing which version is better is pointless. Winds and
brass work the same in both, so the real changes are the doubling scale (band) and the strings
(orchestra). Keep every musical idea, the composer's choice of sound quality, the dynamics and the
foreground/background plan. Then choose: a faithful transfer, or a **recomposition** that changes the
timbres on purpose (Schoenberg Op.43b sounds completely different from Op.43a).

## Rules: band → orchestra
- R1 `MUST` Do not expect 2–3 orchestral clarinets to replace a band clarinet section. Spread the line
  over clarinets + violins or flutes, or accept a lighter result on purpose.
- R2 `NEVER` lose musical content or override the composer's choice of sound for a line.
- R3 `MUST` Keep each line's plane (foreground, middle, background) and decide in detail how the strings
  take over colour and planes.
- R4 `PREFER` Lighter, chamber-like scoring: one player per woodwind part where the band doubled
  (Milhaud).
- R5 `PREFER` Move the band's sustained horn countermelody to the strings, and short off-beat chords to
  bassoons + horns + timpani.
- R6 `PREFER` Keep the brass in reserve for the important entry; the band version keeps them busy.
- R7 `PREFER` Alternate the doubling family (now brass, now woodwinds) where the band keeps one colour.
- R8 `MUST` A band "solo" may be several players, so band accompaniments are denser. Thin them when one
  orchestral player carries the solo.
- R9 `PREFER` Map band-only instruments by function (inferred from Schoenberg):
  - flugelhorns, cornets and the clarinet choir (melody mass) → violins + woodwinds;
  - saxophones (sustained harmony, swells) → trombones or strings;
  - baritone/euphonium secondary line → solo low string (muted) or a trombone;
  - band tubas in a quiet close → muted low strings (a calm ending comes far more easily);
  - muted trumpets + tambourine chord figure → Vln II col legno battuto + muted trumpets on the
    off-beats.
- R10 `ALLOWED` Replace a solid band colour with one clear solo (oboes + clarinets f → one trumpet p), or
  reassign the principal voice to another instrument.
- R11 `ALLOWED` Add idiomatic string figures the band could not have (sul pont. tremolo, col legno,
  undulating Vln II).
- R12 `PREFER` Swap high and low between phrases: phrase 1 woodwinds over Vln II an octave below,
  phrase 2 violins high over woodwinds an octave below.
- R13 `PREFER` For school violins, give the high octave of a fast melody to flutes so Vln I stays low
  (Milhaud) `[era: school orchestras]`.

## Rules: orchestra → band
- R14 `PREFER` Pick the band instrument that best makes each string effect:
  - pp two-note tremolo → flute or clarinet (by register; sometimes saxes or horns);
  - single-note tremolo → xylophone or piano tremolo, `AVOID` flutter-tongue as the default;
  - pizzicato → staccato brass, or a wind doubled in unison by xylophone, marimba, piano or harp for
    the "ping";
  - sul tasto, sul ponticello, col legno → imagine the sound and choose the nearest wind blend, or
    recast the idea.
- R15 `AVOID` imitating the cello + double bass combination with any band bass; use tuba, trombones,
  low reeds and saxes on their own terms. A string bass may be added; Adler prefers the band's own low
  sound.
- R16 `PREFER` Spread string figures (triplet accompaniment) over many wind instruments, and pass an
  exposed string solo around several low winds (tenor/alto/bari sax, bassoon, bass clarinet, tuba).

## Apply in MIDI / REAPER
- Before swapping, tag each line `P` (principal), `S` (secondary) or `BG`. After the swap, check that `P`
  has the clearest colour or the most doublings in every bar.
- Band → orchestra: delete the band clarinet layers, put the line on Vln I + Fl (+ Cl), and mute the
  brass tracks until the climax marker.
- Orchestra → band: pizz. track → trombone or trumpet staccato (short length, velocity accent) +
  xylophone or marimba doubling at the same pitch; tremolo → xylophone roll; Vc/Cb line → tuba +
  bass clarinet + baritone sax, re-voiced rather than copied.

## Checklist
- Is any band clarinet tutti mapped 1:1 onto 2–3 clarinets with nothing added?
- Does the principal voice still lead in level and register after the swap?
- Are brass held back until the main arrival?
- Has every band-only instrument a functional orchestral home, or every string effect a band equivalent?

## Examples
- Milhaud *Suite française* ii: the band's clarinet-choir melody and horn countermelody become Vln I
  melody mf + strings sustaining the countermelody; short chords go to 2 Bsn + 2 Hn + timp p.
- Schoenberg Op.43 opening: band Ob + Cl f → one C trumpet p over bassoons, bass clarinet and tuba.
- Schoenberg Op.43b Var. IV: a flugelhorn theme → low flute + high bassoon; clarinet + alto sax → muted
  trombones.
