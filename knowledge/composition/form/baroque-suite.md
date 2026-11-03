---
id: form.baroque-suite
title: Suite, partita, divertimento — multi-dance plans
aliases: [suite, suite antigua, suite moderna, partita, ordre, sonata da camera, intermedios, alemanda, corriente, zarabanda, giga, minué I y II, gavota I y II, casación, serenata, divertimento, Suite]
domain: form
tags: [suite, partita, dance, baroque, divertimento]
style_scope: baroque
use_when: When planning a set of dance movements (baroque suite/partita), a divertimento/serenade, or a modern suite of cues.
summary: Old suite = (prelude/overture) – Allemande – Courante – Sarabande – (intermezzos - minuets, gavottes, bourrées…) – Gigue, all in one tonic (mode may change), each in repeated binary suite form; paired dances play I–II–I without repeats; a double is an ornamented repeat. Modern suites keep only the idea of a series of pieces.
sources: ["zamacois-formas p.151-155 (§118-122)", "zamacois-formas p.155-166 (§123-140)"]
related: ["[[binary-form]]", "[[dance-types]]", "[[theme-and-variations]]", "[[minuet-scherzo-trio]]", "[[multi-movement-cycle]]", "[[overture-prelude-symphonic-poem]]"]
---

# Suite, partita, divertimento

## Core idea
A **suite** (ordre, partita, sonata da camera) is a set of independent instrumental pieces played in
succession as a whole (§118). Four basic dances plus optional intermezzos and an opening piece.

## Rules
- R1 `PREFER` Order (§118-121): (Prelude / Overture / Preamble) – **Allemande** – **Courante** – **Sarabande** –
  (intermezzos: Minuet, Gavotte, Bourrée, Passepied, Loure, Air…) – **Gigue**. A rondo or a variation piece
  may replace the gigue. Number and length are free.
- R2 `MUST` All pieces in the **same tonic**; mode may change (Bach keeps the mode except some second dances) (§118-121).
- R3 `MUST` Paired dances (Minuet I/II, Gavotte I/II, Bourrée I/II): II in another mode or key, often
  lighter or a musette over a drone; performance I – II – I, the return **without repeats** (§118-121).
- R4 `ALLOWED` A **Double** after a dance = ornamental variation keeping meter, tempo and harmony (§118-121).
- R5 `MUST` The basic dances and most intermezzos use the **binary suite type** (‖: I→V :‖: V→I :‖, see
  [[binary-form]]); prelude, rondo, chaconne keep their own forms (§121-122).
- R6 `PREFER` Contrast neighbouring movements in meter and tempo: moderate 4/4 → quick triple → slow triple →
  light duple/triple → fast compound (dance table in [[dance-types]]).
- R7 `ALLOWED` Modern suite: only "series of pieces forming a whole" remains; any form/style; often a
  selection from a ballet, film or incidental score (§139).
- R8 `ALLOWED` Cassation / serenade / divertimento (18th c.): five or more light pieces — marches, allegros,
  minuets, slow movements — for soloist ensembles (first winds outdoors, later strings) (§140).

## Planning template (keyboard/orchestral suite in D minor)
| mvt | form | key | meter / tempo | bars (each half repeated) | ends with |
|---|---|---|---|---|---|
| Prelude | free (figuration) | d | 4/4 moderate | 20–40 | PAC d |
| Allemande | binary | d → F/a ‖ → d | 4/4 moderate, 16th pickup | 12 + 14 | PAC d |
| Courante | binary | d | 3/2 (French) or 3/4 fast (Italian) | 16 + 16 | PAC d |
| Sarabande (+Double) | binary | d | 3/4 slow, beat 2 stressed | 8 + 16 | PAC d |
| Minuet I – II – I | binary each | d / D | 3/4 moderate | 8+16, 8+16 | PAC |
| Gigue | binary, fugal entries | d (Picardy optional) | 6/8 or 12/8 fast | 24 + 28 | PAC d / D |

## Apply in MIDI / REAPER
- One project per suite with a region and time-signature/tempo marker per movement, 2 empty bars between.
- Write repeats out (duplicate item; add light ornaments the second time).
- Paired dances: render Minuet I, Minuet II, Minuet I (copy without repeats) as consecutive regions.
- Gigue: start Part I with a fugal exposition (voice 1 subject, voice 2 answer at the 5th) and Part II with
  the subject **inverted** (see [[imitation-and-canon]]).

## Checklist
- Same tonic for every movement (mode changes only)?
- Allemande–Courante–Sarabande–Gigue order respected (intermezzos between Sarabande and Gigue)?
- Each dance in repeated binary form with Part I ending in V / III?
- Paired dance performed I–II–I with no repeats on the return?
- Meter/tempo alternate between consecutive movements?

## Examples
- Bach English Suite VI: Sarabande + Double (d, 3/2) (§111-117).
- Corelli concerto grosso in F: Preludio, Allemanda, Corrente, Giga, Sarabanda, Gavotta, Minuetto — all in F (§171).
- Modern: Tchaikovsky's *Nutcracker* suite (general knowledge): ballet numbers in different keys and forms.
