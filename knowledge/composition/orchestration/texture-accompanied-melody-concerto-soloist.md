---
id: orchestration.texture-accompanied-melody-concerto-soloist
title: Accompanying a concerto soloist
aliases: [acompañamiento del solista, orquesta como acompañamiento, concierto, solista y orquesta, diálogo solo-tutti, solo y tutti, densidad adecuada, Begleitung, Solokonzert]
domain: orchestration
tags: [texture, accompaniment, concerto, soloist, balance]
style_scope: universal (Classical to 20th-c. concerto; applies to any soloist over an orchestral bed)
use_when: Writing an orchestra (or orchestral bed) under a solo instrument: concerto passages, a SWAM soloist over sampled strings, a featured solo in a film cue.
summary: "An orchestral soloist fuses with the orchestra far more easily than a piano, so separate them actively: dialogue (solo first, tutti answers), role swaps, colour contrast (no orchestral instruments of the soloist's kind while it plays), rhythmic independence, thin simple beds, and register distance. Drop the tutti to p at a solo entry, especially in the soloist's weak register."
sources: ["adler-orq-es p.611-638"]
related: ["[[texture-accompanied-melody]]", "[[concerto-form]]", "[[texture-accompanied-melody-voice-and-choir]]", "[[line-separation-and-fusion]]", "[[tutti-balance-by-role]]", "[[modeled-instruments-swam]]", "[[accompaniment-for-solo-line]]"]
---

# Accompanying a concerto soloist

## Core idea
The orchestra accompanying a soloist is older than the independent orchestra. The problem is fusion:
a violin, cello, flute or horn soloist melts into an orchestra of its own colours. Adler gives six ways
to keep soloist and orchestra apart; use one or more at every moment.

## Rules
- R1 `MUST` Classify the soloist first: piano (blends with nothing, stands out naturally) or an
  orchestral instrument (needs active separation).
- R2 `PREFER` **Dialogue:** let the soloist state the material alone, then let the orchestra answer with
  a clear change of colour and articulation (legato solo → winds on the tune over pizz strings,
  Beethoven Romance Op. 40). Short motive exchanges with fp tutti chords also work (Schumann).
- R3 `ALLOWED` **Role swap:** the orchestra takes the theme and the soloist accompanies, but `MUST` with
  its most idiomatic figuration: big chords or arpeggios on piano (Tchaikovsky 1), running 16th scales and
  arpeggios on a string soloist (Saint-Saëns cello).
- R4 `PREFER` **Colour contrast:** open with a family unlike the soloist's (woodwind chorale before a solo
  violin, Tchaikovsky; wind trio before the cello, Dvořák) so the solo entry sounds fresh.
- R5 `AVOID` Orchestral instruments of the soloist's own kind while it plays: Mozart drops the orchestral
  horns under the solo horn and writes no orchestral flutes in a flute concerto. Use them only in tutti
  and interludes.
- R6 `ALLOWED` Intermittent doubling of the soloist by a strongly contrasting colour (Vln I shadowing a
  solo horn); a held pedal in another colour (horns + cellos + basses) under a solo passage.
- R7 `MUST` When the soloist enters in a weak register, cut the tutti drastically to p at the entry
  (flute entering low after a forte tutti, Mozart K. 313).
- R8 `MUST` **Rhythmic independence** when colours are similar (strings under a solo violin): the
  accompaniment neither doubles nor imitates the solo's rhythms (Tchaikovsky, Mendelssohn violin
  concertos). A canonic countermelody in Vln I over simple harmony is allowed.
- R9 `PREFER` **Simple, thin beds** under the soloist's first statement: one repeating figure plus
  sustained notes (Sibelius: muted divisi violins rocking pp; Bartók 3: whispering 16th oscillations,
  quiet timpani pulse, a held clarinet dyad, pizz bass).
- R10 `PREFER` **Register distance:** keep the accompaniment away from the solo's register, or put the
  soloist above the whole wind chord, even replacing its top voice (Beethoven Violin Concerto). A strongly
  contrasting rhythm makes register separation less necessary.
- R11 `ALLOWED` A wind may carry the melody in its most intense register while the soloist plays
  virtuoso figuration over a harmonically simple string background (Beethoven: bassoon tune, violin
  32nds).
- R12 `ALLOWED` Double only the key notes of a solo line with an idiomatic instrument (flute with trills
  under a high piano, Liszt 1).
- R13 `PREFER` Light accompaniment gives the soloist rhythmic freedom (scales, rubato); keep strings
  mostly as harmonic background, coming forward only briefly.

## Period practice
- `[era: pre-1900]` the piano was the favourite concerto soloist because it blends with nothing.
- `[era: Classical]` 2 oboes + 2 horns + strings; winds only in tutti and interludes, strings alone
  under the solo (Mozart horn and flute concertos).
- Treatises advise strings-only accompaniment; the repertoire doesn't keep to it (Adler).

## Apply in MIDI / REAPER
- Mute every orchestral track of the soloist's family while the solo plays (e.g. `VLN I` stays only if
  the rhythm is clearly different; horn section off under a solo horn). User-taste R15: never double a
  section with its own soloist.
- Solo entry bar: orchestral CC1 down ≥ 2 levels (f → p, about −30 CC1); if the entry is low, strings
  + one sustained pedal only.
- Rhythm lint (inferred): accompaniment onsets shared with the solo < 50 %, no copied solo cell.
- Default bed under a long-note solo: `VLN II`/`VLA` sustained pp, `VC`/`CB` pizz on beats, one section
  with light off-beat staccato.
- Ethereal bed: 4 divisi violin voices, con sordino patch, pp, two-note slurred 8th rocking, 2–3 bars
  before the entry.
- Level: the exposed soloist about +5 dB over its bed (user-taste R15), shaped with CC11/CC1; place a dry
  SWAM soloist in the room at stage distance so it matches the samples.

## Checklist
- Is a same-family orchestral instrument playing with the soloist? Remove it.
- Is the solo separated by at least one of colour, rhythm, register or density at every bar?
- Is the tutti cut to p at each solo entry?
- Under the soloist's first statement, is the bed one figure + sustains?
