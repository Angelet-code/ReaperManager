---
id: orchestration.stage-seating-pan-depth-planes
title: Sound planes (foreground, middleground, background) and how to stage them
aliases: [planos sonoros, primer plano, plano medio, plano de fondo, profundidad musical, transparencia, fondo y acompañamiento, Klangfarben, melodía de timbres, Hauptstimme, Nebenstimme]
domain: orchestration
tags: [planes, depth, foreground, background, balance, transparency, mix]
style_scope: universal (orchestral practice; mix numbers = mock-up practice, inferred)
use_when: Making a melody stand in front of its accompaniment, deciding which line is foreground, middleground or background, handing the foreground between sections, or translating planes into level, depth and pan in REAPER.
summary: Planes are built in the orchestration before the mix. Give the foreground its best register and a colour that contrasts with the background; bring a new foreground in with a new colour at its phrase start (upbeat included) or after a silence; turn the outgoing section into background a bar early; keep a colour in reserve. The background must never cover the melody: thin layers, staggered rests, light articulation. Only then use CC levels, reverb depth and pan to confirm the planes.
sources: ["adler-orq-es p.558-563", "piston-orch p.431-443", "piston-orch p.396-403"]
related: ["[[stage-seating-pan-depth]]", "[[texture-types]]", "[[texture-accompanied-melody]]", "[[line-separation-and-fusion]]", "[[string-section-writing]]", "[[tutti-balance-by-role]]", "[[reverb-strategy-orchestral]]", "[[user-taste]]"]
---

# Sound planes and how to stage them

## Core idea
Adler describes most textures as **foreground** (primer plano: the melody or main idea),
**middleground** (plano medio: an important counterline) and **background** (plano de fondo: harmony,
pulse, pedals). The ear reads the planes from register, colour, rhythm and density first; level, reverb
and pan only confirm them. Piston's ideal background is **transparent**: elaborate, but a soft solo line
is still heard through it.

## Rules
- R1 `MUST` Label every element FG, MG or BG before writing levels ([[texture-types]]); at most two
  elements in the foreground at once ([[five-elements-arrangement-checklist]]).
- R2 `MUST` Melody notes more prominent than harmony notes (Adler). `NEVER` let the accompaniment
  overwhelm the melody in sound (Piston).
- R3 `PREFER` Give the foreground its instrument's best register, and a colour that contrasts with the
  accompaniment (Adler). `ALLOWED` same-family accompaniment (all strings is the commonest case, Piston);
  contrast of colour is one means, not a requirement.
- R4 `PREFER` A new foreground idea enters with a **new colour at the start of its phrase, upbeat
  included**, or after a short silence, so it is clearly perceived (Adler; vital in polyphony).
- R5 `PREFER` Switch the outgoing section from foreground to background one bar before the new foreground
  enters (Weber: violins to arpeggios, low strings to long notes, a bar before the horns), and contrast
  the layer below when the melody changes hands (Adler).
- R6 `PREFER` Hold back a colour (the horns, the tuba, the low strings) so its first entry sounds fresh
  (Adler).
- R7 `PREFER` Transparent background: split it into subelements that rest at different points, keep
  articulation light, omit or thin the double basses, and derive figuration from the instruments' own
  technique rather than from piano writing (Piston).
- R8 `PREFER` Keep background figures out of the melody's register band and in a contrasting rhythm
  ([[string-section-writing]], [[line-separation-and-fusion]]).
- R9 `ALLOWED` Klangfarben: spread both layers over many instruments, so no two play the same material for
  more than a few notes (Adler on Mahler); or treat the big orchestra as a chamber ensemble. Both are
  valid when done on purpose.
- R10 `ALLOWED` Deliberately weight one register zone of a chord to set its plane (Piston); a background
  pad sits as a flat plane where no note protrudes.

## Apply in MIDI / REAPER
- **Level by plane** ([[user-taste]] R15, [[tutti-balance-by-role]]): an exposed solo about +5 dB over its
  bed; a countermelody about 3 dB under the melody; inside a tutti, the section melody can measure about
  4 dB under the bed because the bed has many more players. Lower the heavy bed before raising the
  melody. Set these with CC1/CC11 and velocity; faders stay at 0 dB.
- **CC shapes:** the foreground moves most (CC1 range ~35 inside a phrase); background pads flatter, with
  the outer voices slightly over the inner ones.
- **Hand-off:** at the bar before a new foreground enters, change the outgoing tracks to background
  material (longer notes or arpeggios) with CC1 15–20 points lower; the new foreground's first note,
  including its upbeat, is on its new track.
- **Depth** (inferred, dry or mixed libraries): keep each instrument at its stage depth
  ([[stage-seating-pan-depth]]); do not pull a foreground line forward with less reverb than its seat,
  except a dry modelled soloist, which goes into the room at a near-stage distance. Background pads may
  take 1–2 dB more reverb send than the table.
- **Pan** (inferred): if the seating allows, avoid placing a busy background figure at the same pan
  position as the foreground line.
- **Render check:** measure foreground and background stems per phrase; if the melody is covered, thin or
  re-register the background before touching levels.

## Checklist
- Does every section have its FG/MG/BG labels, with at most two foreground elements?
- Does each new foreground enter on a new colour at its upbeat, or after a rest?
- Does the outgoing section turn to background a bar before the hand-off?
- Is the background transparent (staggered rests, light articulation, outside the melody's band)?
- Is the plane made by scoring first, with CC, depth and pan only confirming it?
