---
id: form.moc
title: Form — map of content
aliases: [formas musicales, forma musical, estructura, morfología musical, Formenlehre]
domain: form
tags: [moc, form]
style_scope: universal
use_when: Entry point for any request about the structure of a piece - pick the 3–6 form notes needed to plan sections, bar counts, keys and cadences.
summary: Index of the form notes (Zamacois's Curso de Formas Musicales + the user's sonata outline + general knowledge for modern songs), grouped by phrase level, small forms, large instrumental forms, contrapuntal forms, dances/genres and vocal forms, with a planning procedure for turning a form into REAPER regions.
sources: ["zamacois-formas", "sonata-outline"]
related: ["[[_harmony]]", "[[glossary-form]]"]
---

# Form — map of content

## How to plan a piece (procedure)
1. Pick the form (tables below) and open its note; copy its **planning table**
   `| section | bars | key | material | ends with |`.
2. Size phrases with [[phrase-structure]] (real bars, pickups) and decide each section's ending with
   [[suspensive-conclusive-endings]]; give each section a job with [[section-functions]].
3. Fix the key plan ([[key-plans-small-forms]], [[modulation]]) and cadence types ([[cadences]]).
4. Convert to REAPER: `start_bar(n) = 1 + Σ previous bars` (+1 if bar 1 is reserved for a pickup);
   `seconds = bars × quarter_notes_per_bar × 60 / BPM`. Create one region per section named
   `function key bars` (e.g. `B V 21-36`) and markers at cadences (`HC b8`, `PAC b16`).
5. Run the note's checklist on the generated MIDI.

## Reading order for beginners
1. [[phrase-structure]] — units and bar counting.
2. [[suspensive-conclusive-endings]] — open vs closed.
3. [[section-functions]] — what each section does.
4. [[ternary-form]] — the most used small form.
5. [[sonata-form]] — the big classical plan (or [[form-for-modern-songs]] for pop/film).

## Phrase level and building blocks
| note | use_when | summary |
|---|---|---|
| [[phrase-structure]] | Before writing any melody or section: size it, pickups, endings | phrase → period → subperiod → member; 8 = 4+4 = 2+2+2+2 real bars; thetic/anacrustic; masculine/feminine |
| [[suspensive-conclusive-endings]] | Deciding open vs closed endings | melody off/on tonic + harmony; last period decides; only the home tonic closes |
| [[phrase-asymmetry]] | Non-4/8/16 sections, overlaps, square checks | elision −1, contraction, dilatation, echo, appendix, amplification, weld |
| [[thematic-development]] | Inventing, deriving and varying themes | head motif; repetition vs transformation; fragmentation, sequence, inversion, aug/dim |
| [[section-functions]] | Assigning a job to each section | principal stable, secondary modulating → V7; intro, bridge, retransition, coda |
| [[key-plans-small-forms]] | Where to modulate and how to return | away (V / III) → digress → home; subdominant touch before the end |

## Small forms
| note | use_when | summary |
|---|---|---|
| [[binary-form]] | Two-part pieces, baroque dances, 16-bar themes | A-A', A-B, rounded binary (binary Lied), ‖:I→V:‖:V→I:‖ suite type |
| [[ternary-form]] | A-B-A, slow movements, character pieces | ternary Lied; B ≈ ½–1 × A ends on V7; five-section Lied ABACA |
| [[minuet-scherzo-trio]] | Third movements, dance + trio, scherzi | Minuet ‖:a:‖:ba':‖ – Trio (IV/parallel/relative) – D.C. without repeats |
| [[rondo-form]] | Refrain-based pieces and finales | refrain always in I; ABACA; rondo-sonata ABACABA |
| [[theme-and-variations]] | Variation sets, doubles | ornamental / decorative / amplifying; same bars, cadences, harmony per bar |
| [[ostinato-chaconne-passacaglia]] | Repeated bass or harmonic loop with variations | short tonal ostinato, rising density, mode block, top-voice transfer |

## Large instrumental forms
| note | use_when | summary |
|---|---|---|
| [[sonata-form]] | Planning a sonata-form movement (exposition + full template) | A I → bridge → B V/III → closing ‖ dev → V pedal ‖ A I → B I → coda |
| [[sonata-development-and-recap]] | Writing development, retransition, recap, coda | new keys, fragment work, dominant pedal; bridge rewritten so B lands in I |
| [[multi-movement-cycle]] | Sonata/symphony/quartet movement plans | fast – slow – minuet/scherzo – finale; first/last in I; cyclic cells |
| [[concerto-form]] | Soloist + orchestra | ritornello; double exposition (B in I, then V/III); cadenza on I6/4 → V7 |
| [[overture-prelude-symphonic-poem]] | Openers, programmatic pieces, ballet, incidental music | French/Italian overture; sonata-based overture; programme must not stifle form |

## Contrapuntal forms
| note | use_when | summary |
|---|---|---|
| [[imitation-and-canon]] | Echoing voices, canons, call-and-response | interval + distance + transformation; closer = tighter; strict vs diatonic |
| [[fugue]] | Writing or validating a fugue/fugato | expo S R S R + CS; middle entries in new keys + episodes; stretto, pedals |
| [[fugue-tonal-answer]] | Generating the answer | real +7; tonal: T fragments +7, D fragments +5, 1↔5, keep directions |
| [[school-fugue-plan]] | Step-by-step fugue key map; double fugue; fugato | relative → its answer → IV → relative of IV → V pedal → 3 strettos → tonic pedal |

## Dances, suites, genres
| note | use_when | summary |
|---|---|---|
| [[dance-types]] | A dance is named in the request | meter, tempo, upbeat, cadence placement, MIDI rhythm cells for 25 dances |
| [[baroque-suite]] | Multi-dance sets, divertimenti, modern suites | A–C–S–(intermezzos)–G, one tonic, binary dances, paired dances I–II–I |
| [[character-pieces]] | Romantic miniatures by title | title = mood; default A–B–A; texture from the title |

## Vocal forms and modern songs
| note | use_when | summary |
|---|---|---|
| [[song-aria-recitative]] | Setting words; opera/oratorio numbers | strophic / verse+refrain; recitative vs aria; da capo aria; concertato finale |
| [[sacred-vocal-forms]] | Chorale, motet, Mass, cantus firmus | fermata per line; imitative points per text phrase; Kyrie–Gloria–Credo–Sanctus–Agnus |
| [[form-for-modern-songs]] | Pop/rock/film song structure | verse–chorus = coplas y estribillo; pre = transition; bridge = episode → V; outro = coda |

## Sources
- [[zamacois-formas]] — Zamacois, *Curso de Formas Musicales* (classical/romantic forms, fugue).
- [[sonata-outline]] — the user's class outline of sonata form.
- Glossary ES/EN/DE: [[glossary-form]].
