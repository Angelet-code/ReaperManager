---
id: orchestration.texture-accompanied-melody
title: Accompanied melody (melody, bass, filler)
aliases: [melodía acompañada, melodía y acompañamiento, relleno, material de relleno, acompañamiento, homofonía, traspaso de melodía]
domain: orchestration
tags: [texture, accompanied-melody, melody-handoff, balance]
style_scope: universal
use_when: Orchestrating a tune with accompaniment (the most common texture), or moving a melody from one instrument to another.
summary: Split the music into melody, bass and filler and give each its own instruments. The melody sits one dynamic level above the accompaniment and in a distinct colour, while the filler stays subtle (short repeated chords or soft sustains). When the melody moves to another group, keep one instrument common to both groups and switch only at phrase or motif boundaries.
sources: ["unir-orq-tema3 p.8-10", "unir-orq-tema2 p.4-10", "httyd-test-drive p.3-4"]
related: ["[[texture-types]]", "[[orchestrate-from-piano-sketch]]", "[[line-separation-and-fusion]]", "[[texture-secondary-melody-countermelody]]", "[[bass-line-doubling]]"]
---

# Accompanied melody

## Core idea
A simple texture: one melody over an accompaniment. Most pieces contain three lines: **melody, bass and
filler** (relleno). Orchestrating means choosing instruments for each and balancing them so the melody
is never covered.

## Rules
- R1 `PREFER` Give the melody to one wind instrument (or a unison pair) over a very subtle string
  accompaniment, or to a string section over soft winds.
- R2 `MUST` The melody stands out. It must not be covered by bass or filler doubled at too many octaves.
  Keep the filler **below** the melody, or in a contrasting colour, at a lower dynamic.
- R3 `PREFER` Dynamic offset: melody about one level above the rest (mf over mp).
- R4 `ALLOWED` The melody may move between instruments or be broken into motives across instruments.
- R5 `MUST` When the melody moves, switch at a phrase or motif boundary, never mid-motif. Keep one
  instrument common to the outgoing and incoming groups (Brahms 2/I keeps the bassoons when horns +
  bassoons hand over to flutes + clarinets + bassoons).
- R6 `PREFER` Only the solo colour instrument ornaments (grace notes, turns). The instruments doubling it
  play the plain line (HTTYD whistle + oboes + bassoons + celli, b.13).
- R7 `AVOID` Filler in the same register **and** same colour as the melody: the melody disappears.

## Apply in MIDI / REAPER
**Dark lyrical opening** (Tchaikovsky 5/I recipe, minor key, around q = 80):
- `CL 1-2` melody in unison in the chalumeau, MIDI 50–64. Legato patch, CC1 30–45 (p), with CC1 swells
  of ±10 on long notes.
- `VLA`, `VC` short sustained chords on the beat, notes 45–62, CC1 30.
- `CB` roots 28–43, an octave below the cellos, sustain patch CC1 30.
- `VLN I/II` stay silent until a later phrase, then enter with tenuto chord notes at mf (CC1 60).

**Classical a2 recipe** (UNIR Adagio, Fig. 6):
- Melody `OB 1` (e.g. from F5 77), doubled an octave lower by `BSN 1` (65 and below), both mf.
- Filler: repeated staccato 8th-note chords in `VLN I`, `VLN II`, `VLA` at mp (velocity 55–65).
- Bass: half notes in `VC` + `CB` (CB 12 semitones below), mp.
- Flute, clarinet, horn and timpani rest.

**Folk / film tune** (HTTYD b.13):
- Solo colour (`WHISTLE` or `FL`) with grace notes, f, in 64–71.
- `OB a3`, `BSN a2` (high tenor) and `VC` in treble clef double at the **same pitch** without ornaments.
- High violins hold tremolo pads (D5 74, A5 81), basses hold a D pedal, re-attacked every 2 bars.

**Handoff procedure:**
1. Find phrase boundaries (rests, long notes, cadences).
2. Move the melody track at the boundary.
3. Overlap the incoming instrument by one note, or keep a shared doubler across the switch.
4. Match the new instrument's CC1 to the old one's dynamic at the switch.

## Checklist
- Is the melody at least one dynamic level above the filler and bass?
- Are there no filler notes above the melody for more than a beat, unless the colours contrast?
- Do melody handoffs happen only at phrase or motif boundaries, with a common instrument or overlap?
- Do only the solo instruments carry ornaments?
- Is the bass in its own octave (Cb an octave below Vc when both play)?
