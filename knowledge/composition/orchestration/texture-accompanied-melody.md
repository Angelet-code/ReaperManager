---
id: orchestration.texture-accompanied-melody
title: Accompanied melody (melody, bass, filler)
aliases: [melodía acompañada, melodía y acompañamiento, relleno, material de relleno, acompañamiento, homofonía, traspaso de melodía, fondo, transparencia, subelemento, cola de milano, superposición de entradas, dovetailing]
domain: orchestration
tags: [texture, accompanied-melody, melody-handoff, balance, accompaniment, transparency]
style_scope: universal
use_when: Orchestrating a tune with accompaniment (the most common texture), designing the accompaniment layer, or moving a melody from one instrument to another.
summary: "Split the music into melody, bass and filler and give each its own instruments. The melody sits about one dynamic level above a transparent accompaniment built from 2–4 subelements with their own rhythms and rests, in idiomatic figuration and usually a contrasting colour or articulation. Hand the melody over at phrase boundaries, with a shared note or a common instrument, and re-colour it when a phrase repeats."
sources: ["unir-orq-tema3 p.8-10", "unir-orq-tema2 p.4-10", "httyd-test-drive p.3-4", "piston-orch p.364-373, 431-443", "adler-orq-es p.558-562, 576-577, 602"]
related: ["[[texture-accompanied-melody-doubling-the-tune]]", "[[texture-accompanied-melody-concerto-soloist]]", "[[texture-accompanied-melody-voice-and-choir]]", "[[texture-types]]", "[[orchestrate-from-piano-sketch]]", "[[line-separation-and-fusion]]", "[[texture-secondary-melody-countermelody]]", "[[bass-line-doubling]]", "[[accompaniment-for-solo-line]]", "[[string-section-writing-homophony]]"]
---

# Accompanied melody

## Core idea
Piston's type II: a melody (element A) over an accompaniment (element B). Most pieces have three lines:
**melody, bass and filler** (relleno). The accompaniment is part of the composition: it gives key, harmonic
colour, harmonic rhythm and the pulse rate, and can change what the melody means (Piston). Choosing and
doubling the melody instrument: [[texture-accompanied-melody-doubling-the-tune]].

## Rules
- R1 `PREFER` Contrast the melody's colour with the accompaniment's (woodwinds over strings, a wind solo
  over soft strings, a string tune over soft winds). Same-family accompaniment is allowed; all-strings is
  the most common layout (Adler, Piston).
- R2 `NEVER` Let the accompaniment overwhelm the melody. Markings alone don't guarantee balance: an
  accompaniment marked pp still covers a tune if every part is not in a register where it plays softly
  (Piston). Keep filler below the melody or in a contrasting colour.
- R3 `PREFER` Dynamic offset: melody about one level above the rest (mf over mp, p over pp).
- R4 `PREFER` **Transparency:** build the accompaniment from 2–4 subelements (sustained tones, repeated-
  note harmony, a bass pulse), each with its own rhythm and rests at different points (Piston, *La Mer*).
- R5 `PREFER` Derive figuration from the instruments' technique, not from piano writing: off-beat
  detached strings, bowed repeated notes, pizz bass, wind sustains (Piston).
- R6 `PREFER` Contrast articulation between elements: light staccato strings under legato winds.
- R7 `ALLOWED` A soft held horn note between bass and melody glues a thin texture (Mahler 4/IV).
- R8 `MUST` Move the melody only at a phrase or motif boundary, never mid-motif. Keep one instrument
  common to both groups (Brahms 2/I keeps the bassoons), or **dovetail**: the incoming instrument enters
  on the outgoing one's last note (Adler). A plain cut makes each fragment sound accented.
- R9 `PREFER` Bring a new colour in at the phrase start, upbeat included, or after a short silence, and
  turn the outgoing section into background (arpeggio or long notes) about a bar before (Adler, Weber).
- R10 `AVOID` An entry that sits a step from another instrument's last note when no connection is meant:
  the ear hears one line (Piston, Beethoven 1).
- R11 `PREFER` When a phrase or refrain returns, re-colour the melody or one octave of it but keep the
  texture and chords recognisable (Piston, Adler).
- R12 `PREFER` Only the solo colour instrument ornaments; doublers play the plain line (HTTYD b.13).
- R13 `ALLOWED` Violins may figure a decorated version of the tune under plain wind soloists if they are
  a level softer and leave rests (Piston, Schumann 1).
- R14 `ALLOWED` At a cadence the accompaniment and melody may merge into part writing (Piston).
- R15 `AVOID` Filler in the same register **and** colour as the melody: the melody disappears.

## Apply in MIDI / REAPER
**Light string accompaniment** (Piston Fig. 143): `VLN I` melody p; `VLN II` + `VLA` detached quarters on
beats 2 and 4 (velocity 40–50, len 0.5); `VC` held bass; `CB` pizz on some downbeats or tacet.

**Transparent bed under a soft flute** (*La Mer*): Fl a2 melody p (CC1 35–45); EH/Cl/Bsn short overlapping
pp figures with CC1 falling 10–15 within each; `HN 2+4` low pp pedal (CC1 15–25); `VLN I` div high pp trill;
`VLN II/VLA/VC` staccato very light (vel 25–35); `CB` one note.

**Dark lyrical opening** (Tchaikovsky 5/I): `CL 1-2` unison melody in 50–64, legato, CC1 30–45 with ±10
swells; `VLA`, `VC` short soft chords on the beat (45–62, CC1 30); `CB` roots 28–43 an octave under the
cellos; violins silent until a later phrase.

**Classical a2** (UNIR Adagio): `OB 1` melody, `BSN 1` an octave lower, mf; staccato 8th chords in
`VLN I/II`, `VLA` (vel 55–65); half notes in `VC` + `CB`.

**Folk/film tune** (HTTYD b.13): ornamented `WHISTLE`/`FL` f in 64–71; `OB a3`, `BSN a2`, `VC` double at
the same pitch, plain; high violin tremolo pads (74, 81); bass D pedal re-attacked every 2 bars.

**Handoff procedure:**
1. Find phrase boundaries (rests, long notes, cadences).
2. One bar before, switch the outgoing track to background material at lower CC1.
3. Start the incoming track on the outgoing track's last note (overlap one note) or keep a shared doubler.
4. Match the new instrument's CC1 to the old one's level at the switch.

Levels (user-taste R15): an exposed solo about +5 dB over its bed; set it with CC1/CC11, not faders.

## Checklist
- Is the melody at least one dynamic level above filler and bass, and in a contrasting colour or
  articulation?
- Does the accompaniment have subelements with different rhythms and staggered rests?
- Is every accompaniment part in a register where it can play as softly as marked?
- Do handoffs happen only at phrase boundaries, with a dovetail or a common instrument?
- Do only the solo instruments carry ornaments? Is the bass in its own octave?
