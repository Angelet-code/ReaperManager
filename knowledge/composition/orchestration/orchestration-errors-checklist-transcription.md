---
id: orchestration.orchestration-errors-checklist-transcription
title: Transcription, band and layout errors (extra checks)
aliases: [errores de transcripción, revisión de transcripción, errores de banda, errores de plantilla, comprobación de reducción]
domain: orchestration
tags: [checklist, errors, lint, validation, transcription, band, template]
style_scope: universal (piano/chamber/band transcription and template layout)
use_when: Validating an orchestration made from a piano, chamber or band source, a band arrangement, or a new orchestral template, after the main error checklist.
summary: "Extra checks for transcriptions: piano leftovers (CC64, strummed onsets, imitated tremolos, unmeasured fermatas), changed harmony or untagged additions, a principal voice that does not lead, band masses mapped 1:1, missing-instrument lines dropped, unplanned substitutes, overused percussion and amateur extremes. Layout checks: track order, family folders, doubling players playing two instruments at once."
sources: ["adler-orq-es p.666-756", "adler-orq-es p.757-784", "piston-orch p.vii-ix"]
related: ["[[orchestration-errors-checklist]]", "[[orchestrate-from-piano-sketch]]", "[[orchestrate-from-piano-sketch-idioms]]", "[[orchestrate-from-piano-sketch-other-transcriptions]]", "[[wind-band]]", "[[wind-band-transcription]]", "[[score-and-parts-layout]]"]
---

# Transcription, band and layout errors

## Core idea
A transcription can pass every range and balance check and still fail its source: piano habits survive
on orchestral tracks, the harmony drifts, or the line that led in the original no longer leads. Run
these after [[orchestration-errors-checklist]] whenever a source exists (piano, chamber, band) or a
template is new. Codes continue the main note: T = transcription, B = band, L = layout.

## Rules
- R1 `MUST` Keep the source's reduction (piano or condensed) as a reference track while checking.
- R2 `MUST` Report hits in the main note's format: `bar.beat | track | code | fix`.

## Transcription checks
| # | Error | Automatic check |
|---|---|---|
| T1 | Pedal left on | CC64 on any orchestral track; held notes shorter than the source's pedal-down span |
| T2 | Strummed chord | onsets of one chord spread > ~60 ms (inferred) where the source roll was only for hand span |
| T3 | Imitated piano decay | piano-style tremolo or re-struck chords where one sustained chord would do; fermata with no measured length |
| T4 | Harmony changed | pitch classes per beat differ from the source reduction (ignoring added octaves and tagged additions) |
| T5 | Untagged addition | a countermelody, rhythmic layer or dynamic change not in the source and not tagged `new` |
| T6 | Principal voice not leading | the tagged `P` line has fewer doublings or lower CC1 than a `S`/`BG` line in the same bars |
| T7 | Foreground/background swapped | a source background line now louder or higher than the source melody |
| T8 | Irregular bars kept | long odd bars (5/4, 7/4) whose accents fall off the downbeats, not re-barred |
| T9 | Missing soloist dropped | a source line with no track after the swap (no substitute) |
| T10 | Substitute out of order | the substitute is not a similar instrument, nor a two-instrument blend, nor fit for range and dynamic |
| T11 | Piano as a running reduction | a piano track that duplicates the whole reduction instead of doubling tuttis or arpeggios |
| T12 | Soft passage in a hard register | p/pp notes in the top register of piccolo, flute or brass; write them 8vb |

## Band checks
| # | Error | Automatic check |
|---|---|---|
| B1 | Clarinet mass mapped 1:1 | a band clarinet tutti given to 2–3 orchestral clarinets with no violins or flutes added |
| B2 | Band accompaniment not thinned | the band's accompaniment density kept under a single orchestral soloist |
| B3 | Brass never in reserve | trumpets and trombones active in > 80 % of bars before the main arrival (inferred threshold) |
| B4 | Band-only parts left idle | saxes, cornets or euphonium never carry melodic material in a band score |
| B5 | Fixed-size divisi in a band part | a band part that only works with a known number of players |
| B6 | Cello + bass imitated | an orchestral Vc/Cb line copied note for note onto band basses instead of re-voiced |
| B7 | Percussion overuse | percussion with no job (march, accents, climax, colour) in more than a few bars |

## Layout checks
| # | Error | Automatic check |
|---|---|---|
| L1 | Track order | tracks not in score order (orchestra or band order, [[score-and-parts-layout]], [[wind-band]]) |
| L2 | No family folders | families not grouped in empty folder buses |
| L3 | Extras misplaced | saxes, euphonium, Wagner tubas or alto flute outside their family |
| L4 | Impossible player doubling | two tracks of one player (Fl 2 / Picc, Ob 2 / Eng hn) sounding at once, or < ~2 bars between them (general knowledge) |
| L5 | Shared track, different dynamics | `Hn 1-2` style track where the two players need different dynamics |
| L6 | No rehearsal markers | sections and meter changes without project markers |

## Apply in MIDI / REAPER
- Fix order: T1–T5 (fidelity), T6–T8 and B1–B2 (planes and balance), T9–T12 and B3–B7 (colour and
  idiom), then L1–L6.
- For T4, compare per-beat pitch-class sets between the reduction and the summed orchestral tracks.
- For T6/T7, carry `P`/`S`/`BG` tags in track names or the arrangement spec.

## Checklist
- Is no CC64, strum or imitated decay left (T1–T3)?
- Do harmony and form match the source, with additions tagged (T4, T5)?
- Does the principal voice lead in every bar (T6, T7)?
- Does every source line exist on some track (T9)?
- Are band masses re-thought rather than copied (B1, B2, B6)?
- Are tracks in score order, in family folders, with playable doublings (L1–L4)?
