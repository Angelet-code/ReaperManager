---
id: orchestration.texture-counterpoint
title: Contrapuntal texture in the orchestra
aliases: [textura contrapuntística, contrapunto orquestal, orquestación contrapuntística, polifonía, fuga orquestal, líneas independientes, imitación, línea, bloque de instrumentos, Kontrapunkt, polyphoner Satz]
domain: orchestration
tags: [texture, counterpoint, doubling, separation, distribution]
style_scope: universal (Baroque to film; period entry orders tagged in the split note)
use_when: Orchestrating two or more independent lines of similar importance (fugue, canon, combined themes, a theme against another theme), or a tutti built from a few melodic lines.
summary: "A contrapuntal texture is made only of melodic lines (usually 2–5), each carried by a block of instruments in unison and/or octaves. Rank the lines, give each its own composite colour, register band and rhythm profile, let dissonances between them stand, and keep a distribution table line → instruments → octave. Watch where doublings put each line in pitch, break routine pairings when that separates lines, and keep pads out."
sources: ["unir-orq-tema3 p.13-14", "film-4day-challenge slide 5", "piston-orch p.388-395", "piston-orch p.457-458", "adler-orq-es p.133-135", "adler-orq-es p.261-270"]
related: ["[[texture-counterpoint-entries-and-canon]]", "[[line-separation-and-fusion]]", "[[texture-types]]", "[[texture-secondary-melody-countermelody]]", "[[string-section-writing-counterpoint]]", "[[woodwind-section-writing]]", "[[brass-section-writing-counterpoint]]", "[[doubling-colour-and-decay]]"]
---

# Contrapuntal texture

## Core idea
Superimposed melodic lines replace the melody + accompaniment scheme: fugal or imitative voices, or themes
already heard alone and now combined. Piston thinks in **lines, not instruments**: a nearly full tutti can be
just four lines, each a unison/octave block of mixed winds and strings. The job is to keep the lines
**audibly separate** ([[line-separation-and-fusion]]). Entries, canon and stretto:
[[texture-counterpoint-entries-and-canon]].

## Rules
- R1 `MUST` Rank the lines: primary (foreground), secondary (middleground), tertiary (background), so each
  communicates its rank (Adler).
- R2 `MUST` Keep the lines independent in rhythm (different onsets, long against running notes) and let
  them form dissonances (Piston). Dissonances belong to the lines' motion (passing tones, suspensions); a
  held clash under sustained harmony needs its own harmony ([[user-taste]] R21).
- R3 `MUST` Give each line its own colour group: woodwind + string or horn + string mixtures, a different mix
  per line, and no instrument on two lines at once. Models:
  - Mozart 40/III (K.550 minuet): A = Fl, Ob, Cl, Va, Vc, Cb; B = Vln I + II, Bsn, Hn.
  - Bach *Art of Fugue*, Contrapunctus X (Piston): A = Picc + Ob 1 an octave apart (E.H. joins an octave
    below the oboe later); B = Fl 1 + Cl 1 an octave apart; C = Hn 2 + Va in unison; D = Bsn 1–2 + Cb at
    the octave.
- R4 `ALLOWED` Plain block scoring (all lines in strings, or in woodwinds, or in brass) when each
  instrument's range fits its line. Woodwind counterpoint is naturally clear (distinct colours); strings-only
  counterpoint must separate lines by register and rhythm ([[string-section-writing-counterpoint]]).
- R5 `MUST` Check where the doublings put each line. A bass line doubled up by flute and violas, with high
  basses, sounds close to the upper line (Mozart 40/III). Judge the sounding span of each block.
- R6 `ALLOWED` Double each line widely at the octave for a big sound from few lines. But when two lines lie
  close, leave them undoubled at the octave: octave copies blur them (Strauss, Piston).
- R7 `ALLOWED` Break routine pairings when it helps separation: bassoons on the upper line instead of with
  the cellos (Mozart 40/III).
- R8 `PREFER` Keep each line in the best register of every instrument on it. Re-octave or drop single
  notes that fall out of a doubler's range (a contrabassoon note, an English horn note that sounds poor);
  hand notes above a group's top to another instrument (piccolo for an F♯ too high for the violins).
- R9 `PREFER` When a line carried by bassoons gets weak, bring in horns; they may just repeat a held tone.
  When the basses go below their G string, move a doubling bassoon up an octave to keep the bass clear.
- R10 `ALLOWED` Mid-phrase, change a woodwind doubling from unison to octaves: brighter, and it lifts the top
  line without adding instruments.
- R11 `ALLOWED` Extra melodic voices entering in a crescendo add sonority and stay contrapuntal; at the
  climax the strings may stop and winds finish the lines in diminuendo (*Tristan* Prelude). One dominant
  line over four imitating lines reads as melody + contrapuntal accompaniment (Bartók).
- R12 `PREFER` Close a 2-line phrase with a cadence in 4-part writing (Haydn, *Clock* minuet; see
  [[texture-part-writing-chorale]]).
- R13 `AVOID` Pads or sustained chords under real counterpoint: they mask the dissonances the lines create.
  If harmony is needed, keep it soft and in a separate register.

## Apply in MIDI / REAPER
- Keep a **distribution table** per section before writing: line → tracks → octave offset. Name tracks with
  the line letter (`A FL`, `A OB`, `B VLN I`). A legato patch is monophonic, so one line per track.
- **Two lines, f** (Haydn *Clock* minuet model): A = `VLN I` + `FL 1-2` + `OB 1` at pitch, `VLN II` + `OB 2`
  at −12; B = `VLA` + `VC` + `BSN 1-2` at pitch, `CB` at −12. Last two bars: four parts.
- **Two lines, Mozart 40/III (G minor):** A, the bass line, in 4 octaves: `FL` on top, `VLA` + `OB 1-2` +
  `CL 1-2` −12, `VC` −24, `CB` −36 (keep it ≥ 28). B in 3 octaves: `VLN I`, `VLN II` + `HN 1` −12,
  `BSN 1-2` + `HN 2` −24 (Piston's distribution).
- **Four-line tutti** (Milhaud model): A = ½ Vln I + Fl over ½ Vln I + Ob + Tpt 1 (−12); B = Vln II + Cl 1
  over Va + Cl 2 + Hn 1–2; C = ½ Vc + Trb 1 over ½ Vc + bass Cl + Bsn + Trb 2; D = Tuba over Cb + Cbsn.
- **Levels:** primary line CC1/velocity highest; secondary about 3 dB lower ([[user-taste]] R15); tertiary
  lower still. Different articulation patches per line (legato vs staccato/spiccato) help separation.
- **Separation check** per pair of lines: shared onsets below 50 %; median pitches at least 7 semitones
  apart or different families; no unison longer than 1 beat. Scoring: [[line-separation-and-fusion]].

## Checklist
- Is every line ranked, with its own colour group and no instrument on two lines?
- Are shared onsets between lines below 50 %?
- Does each line's sounding span (with its doublings) stay apart from its neighbour?
- Are close-lying lines free of octave doublings?
- Is every doubling note inside its instrument's range or re-octaved?
- Is there no sustained pad masking the counterpoint?
