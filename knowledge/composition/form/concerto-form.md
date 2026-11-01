---
id: form.concerto-form
title: Concerto forms — ritornello, double exposition, cadenza
aliases: [concierto, concerto grosso, concertino, ripieno, tutti, solo, ritornello, ritornelo, doble exposición, cadencia del solista, cadenza, sinfonía concertante, Konzert, Ritornellform]
domain: form
tags: [concerto, ritornello, double-exposition, cadenza, solo-tutti]
style_scope: baroque-classical
use_when: When writing for soloist(s) and ensemble — baroque ritornello movements, classical concerto first movements, or placing a cadenza.
summary: Concertos are fast–slow–fast (only the middle movement may change key). Baroque first movements alternate an orchestral ritornello (tonic, then other keys, tonic at the end) with virtuoso solo episodes; classical first movements are sonata form with a double exposition (orchestra with B in the tonic, then soloist with B in V/III); the cadenza sits on the orchestra's cadential 6/4 and the orchestra re-enters on V7.
sources: ["zamacois-formas p.206-213 (§169-176)"]
related: ["[[sonata-form]]", "[[sonata-development-and-recap]]", "[[rondo-form]]", "[[multi-movement-cycle]]", "[[cadences]]"]
---

# Concerto forms

## Core idea
A concerto displays one or more soloists against an orchestra. Three models: **concerto grosso**
(concertino group vs ripieno, between suite and fugue), **baroque ritornello** movement, **classical
double-exposition** sonata form. Post-classical concertos compress the orchestral exposition.

## Rules
- R1 `MUST` Three movements fast–slow–fast, the last usually fastest; only the middle movement may be in
  another key (§171–172).
- R2 `ALLOWED` Slow movement may end on a half cadence and go attacca into the finale (§171).
- R3 `MUST` Ritornello first movement (§171): I orchestra states the theme + complements, cadences in
  the tonic → II solo episodes alternate with the theme (or its head) in various keys → III theme back in
  the tonic, optional complements and coda.
- R4 `PREFER` Ritornello roles: orchestra states/restates the theme; soloist shines in episodes, lightly
  accompanied, and also plays in the tutti; orchestra may punctuate episodes with theme fragments (§171, §174).
- R5 `MUST` Classical first movement = sonata form with **double exposition**: Exp.1 orchestra, Exp.2
  soloist + orchestra; orchestra opens the development and the recap and closes the movement (§172, §174).
- R6 `MUST` Theme B: in Exp.1 **in the tonic** (or drifting toward it); in Exp.2 in the sonata key (V / III) (§172).
- R7 `AVOID` Identical restatement between the two expositions: condense, enlarge, swap between soloist and
  orchestra, reorder complements (§172).
- R8 `PREFER` Longest solo display in the bridge and in b''/b''' (§174).
- R9 `MUST` Cadenza: orchestra arrives on the **cadential 6/4** (I6/4 of home), stops (fermata), soloist
  plays alone, orchestra re-enters on **V(7)** → I. Place it before the recap or near the end of the recap
  (sonata movements), before/after the last refrain (rondos) (§175).
- R10 `PREFER` Cadenza content: virtuoso development of the movement's main themes; romantic option:
  accompanied or omitted (§175).
- R11 `ALLOWED` Post-classical: skip the long orchestral exposition — state A twice at once (orchestra↔solo),
  then B likewise; or let the soloist open (Beethoven 4, 5; Mendelssohn; Schumann) (§173).

## Planning templates
Baroque ritornello (Allegro, ~100–150 bars):
| section | bars | key (major / minor) | material | ends with |
|---|---|---|---|---|
| R1 tutti | 8–16 | I / i | ritornello | PAC I |
| S1 solo | 8–16 | I → V / i → III | figuration on R head | → V |
| R2 | 4–8 | V / III | ritornello (part) | PAC V |
| S2 | 8–16 | V → vi / III → v | sequences | → vi |
| R3 | 4–8 | vi (or ii) / v (or iv) | ritornello head | PAC vi |
| S3 | 8–16 | → I | longest display | V7 |
| R4 | 8–16 | I | full ritornello | PAC I |

Classical first movement:
| section | key | content | ends with |
|---|---|---|---|
| Exp.1 (orch.) | I | A, bridge (non-modulating), B in I, closing | PAC I |
| Exp.2 (solo + orch.) | I → V/III | solo entry (opt. new idea), A, bridge, B in V/III, virtuoso closing | trill → PAC V, orch. tutti |
| Development | away | orchestra starts, soloist figuration | V pedal |
| Recap | I | A, bridge, B in I (mix of both expos) | orch. → I6/4, fermata |
| Cadenza | I → V7 | solo alone, themes developed | trill on V7 |
| Coda (orch.) | I | tutti | PAC |

## Apply in MIDI / REAPER
- Separate tracks for solo and orchestra (tutti/ripieno); in tutti the soloist may double the first violins.
- Solo episodes: orchestra reduced to strings sustaining or pizzicato chords, vel 45–65; soloist vel 80–100.
- Cadenza: write as an unmetered-feeling passage in a region `CADENZA` (free tempo via tempo markers, e.g. ♩
  50–70 with accel/rit), ending with a trill (alternating 16ths/32nds on 2 and 1 over implied V7).
- Orchestra re-entry: V7 → I tutti on the next downbeat after the trill.

## Checklist
- Fast–slow–fast with only the middle movement in another key?
- Ritornello: tonic at start and end, other keys between, solo episodes modulating?
- Double exposition: B in I in Exp.1 and in V/III in Exp.2?
- Cadenza prepared by I6/4 + fermata and closed by V7 → I?

## Examples
- Vivaldi Violin Concerto in A, I: full orchestral theme in A; solo; theme in E; solo; tonic return with solos
  inserted between its elements (§171).
- Bach Harpsichord Concerto in d, I: theme – solo – theme toward a – long solo on the head – theme in a –
  episode – theme in g – longer episode – tonic theme as at the start (§171).
