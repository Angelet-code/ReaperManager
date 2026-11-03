---
id: film-scoring.orchestral-mockup-template
title: Orchestral mock-up template (tracks and patches for REAPER)
aliases: [plantilla orquestal, template, plantilla de maqueta, maqueta orquestal, mock-up, plantilla de cine, patches, pistas de orquesta]
domain: film-scoring
tags: [template, workflow, mock-up, patches, reaper, sample-libraries]
style_scope: film (sample-library mock-ups; fast action sketching to detailed cues)
use_when: Creating the REAPER tracks for an orchestral cue or song section, or deciding which patch type (ensemble, section, long/short) a part should use.
summary: "Build the template in tiers. Tier 1 is full-orchestra and section long/short patches for fast sketching. Tier 2 is individual sections with long, short and legato articulations. Tier 3 is enhancers and percussion, plus piano, choir and a low-end layer. Two reverb returns finish it: Panoramic for longs and Impact for shorts. Sketch with tier 1, then move the parts down to sections. Name tracks by family and articulation, and fold them by family."
sources: ["film-4day-challenge slides 4, 7, 8, 9", "httyd-test-drive p.1", "unir-orq-tema1 p.4-6"]
related: ["[[reverb-strategy-orchestral]]", "[[stage-seating-pan-depth]]", "[[five-elements-arrangement-checklist]]", "[[orchestra-sizes-and-section-balance]]", "[[dynamics-by-orchestration]]", "[[_instruments]]"]
---

# Orchestral mock-up template

## Core idea
Sketch with **big patches** (full orchestra and sections, long + short), then detail with section and
legato patches, then colour with **enhancers**. A fixed template keeps names and routing reusable.

## Rules
- R1 `PREFER` Sketch with full-orchestra and section long/short patches first. Write individual
  sections only once the cue's shape works.
- R2 `MUST` Separate long and short articulations onto different tracks (a sustain track and a
  staccato track per section). They need different reverbs and different dynamic controls (CC1 vs
  velocity).
- R3 `MUST` Order tracks in score order inside family folders: woodwinds, brass, percussion,
  keys/harp/choir, strings, low end, then the returns.
- R4 `PREFER` Legato section patches for melodies, and poly-legato for two-voice lines.
- R5 `PREFER` Several MIDI tracks (one per role) into one shared instance, as with the deck's piano.
- R6 `ALLOWED` Skip whole families the cue doesn't need. Keep the names and order of the rest.

## Template (track list)
| Folder | Track | Patch type (example) | Register (MIDI) | Control |
|---|---|---|---|---|
| SKETCH | FULL ORCH LONG / FULL ORCH SHORT | full-orchestra ensemble | 36–96 | CC1 / vel |
| WOODS | WW LONG, WW SHORT | woods ensemble (Albion-type Woods) | 50–96 | CC1 / vel |
| WOODS | FL, OB, CL, BSN (solo or a2) | section patches | see [[_instruments]] | CC1 + CC11 |
| BRASS | HN LEGATO, HN LONG, HN SHORT | horns a4–a6 | `horn` practical 41–74; home 53–72 | CC1 / vel |
| BRASS | TPT LEGATO, TPT SHORT | trumpets a2–a3 (Brass High) | `trumpet_bb` practical 55–79 | CC1 / vel |
| BRASS | LOW BRASS LONG, LOW BRASS SHORT | trombones + tuba (Brass Low) | `trombone_tenor` 40–70, `trombone_bass` 31–65, `tuba` 31–60 (practical) | CC1 / vel |
| PERC | TIMP (hits, rolls, swells) | timpani | `timpani` practical 38–57 | vel; roll = CC1 |
| PERC | EPIC PERC, SNARES, BD / GRAN CASSA, CYMBALS, TAM-TAM | percussion libraries (HZ-type) | kit map | vel |
| ENH | CELESTA, HARP NOTES, HARP GLISS, MARK TREE, CYMBAL SWELLS, CROTALES, SHAKERS | enhancers, high | 72–108 | vel |
| ENH | TIMP SWELLS, SUB BOOM | enhancers, mid/low | 24–50 | vel |
| KEYS | PIANO (several MIDI tracks → one instance) | piano | 21–108 | vel + CC64 |
| CHOIR | CHOIR (pad / textures) | choir (Mysteria-type) | 48–79 | CC1 |
| STRINGS | STR ENS LONG, STR CON SORD | ensemble strings, EQ'd warm | 36–91 | CC1 |
| STRINGS | VLN I LEGATO, VLN II LEGATO, VC LEGATO, CB+VC 8VE LEGATO | section legato | `violin` 55–88 / `cello` 36–76 / `double_bass` 28–55 (practical) | CC1 + CC11 |
| STRINGS | HI STR STAC, HI STR OCT STAC, LO STR STAC, CB STAC, CB PIZZ | shorts | — | vel |
| STRINGS | VC TREM, VC DIVISI | specials | 36–67 | CC1 |
| LOW | LOW END (synth / close basses) | controlled low end | 24–43 | CC1 |
| FX | REV PANORAMIC, REV IMPACT | reverb returns | — | see [[reverb-strategy-orchestral]] |

Per-instrument registers are the practical ranges in `data/instruments.json` (the `id` is cited; that file
wins on any mismatch). Ensemble, sketch and enhancer rows give the patch's useful span.

Minimum quick template (12 tracks): STR LONG, STR SHORT, LO STR LONG, HN LEGATO, TPT SHORT, LOW BRASS
LONG, WW LONG, TIMP, EPIC PERC, CYMBALS, HARP, REV PANORAMIC + REV IMPACT.

## Apply in MIDI / REAPER
- **Create with the builder** (`node .\bin\reaper-manager.js send spec.json`, `type: "build_beat"`).
  Each track gets `name`, `color` (one per family), `folder` (1 on the first track of a family, −1 on
  its last), `fx`, `sends` and `midi`. Skeleton:
  - The returns (`REV PANORAMIC` and `REV IMPACT`, fx `RVerb`) are created in the same spec, so sends
    can target them.
  - Example long track: `{ "name": "HN LEGATO", "color": "#d9a23a", "sends": [{"dest": "REV PANORAMIC", "db": -12}] }`.
  - Example short track: `{ "name": "HI STR STAC", "sends": [{"dest": "REV IMPACT", "db": -14}] }`.
- **Sample instruments:** bridge-created Kontakt instances are empty, so tell the user which patch to
  load per track (e.g. `HN LEGATO` → Albion ONE Brass, horns legato). Load heavy instruments one at a time.
- **Family colours** (suggested): woods `#6fb36f`, brass `#d9a23a`, percussion `#8a8a8a`, enhancers
  `#c58fe0`, keys/choir `#5aa0d8`, strings `#c85a5a`, low end `#3d3d7a`.
- **MIDI defaults per patch type:**
  - Longs: CC1 from the map in [[dynamics-by-orchestration]], CC11 100–115, a CC1 point every beat for swells.
  - Shorts: velocity only, accents +15, ghost notes −20.
  - Legato: overlap notes by 1/16 beat to trigger the legato transition, and lower the velocity
    (≤ 60) for slow transitions if the patch uses velocity for transition speed.
- **Moving a sketch down a tier:** copy FULL ORCH notes into section tracks by register band (notes ≥ 72
  → violins/flutes, 55–71 → horns/violas, ≤ 54 → low brass/cellos/basses), then delete the sketch items
  or mute the SKETCH folder.

## Checklist
- Do longs and shorts sit on separate tracks with the correct reverb return?
- Is the folder order woods, brass, perc, enhancers, keys/choir, strings, low, FX?
- Does every track name state family + articulation?
- Has the user been told which patch to load on every empty instrument instance?
- Are hall-recorded libraries panned at 0 ([[stage-seating-pan-depth]])?
- Is the low end on its own track (dry)?
- Are SKETCH tracks muted once the parts move to sections?
