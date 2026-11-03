---
id: orchestration.transposing-instruments
title: Transposing instruments and clefs
aliases: [instrumentos transpositores, transposición, nota real, sonido real, en si bemol, en la, en fa, en mi bemol, claves, clave de sol, clave de fa, clave de do, transponierende Instrumente, Schlüssel]
domain: orchestration
tags: [transposition, notation, clefs, parts]
style_scope: universal
use_when: Converting between written parts and concert-pitch MIDI, reading a score into MIDI, or producing parts/key signatures for players.
summary: MIDI is always concert pitch; transpositions only matter when reading or producing parts. Written→sounding: Bb −2, A −3, F −7, G −5, Eb clarinet +3, Eb alto sax −9, bass clarinet and tenor sax −14, baritone sax −21, piccolo/celesta/xylophone +12, glockenspiel/crotales +24, double bass/contrabassoon −12. A transposing part's key signature is the concert key moved up by the instrument's interval.
sources: ["unir-orq-tema1 p.8-15", "apuntes-orq-sesion1 scan p.2-4", "unir-orq-tema5 p.10-28", "unir-orq-tema6 p.4-19", "unir-orq-tema7 p.13-16", "unir-orq-tema8 p.16"]
related: ["[[clarinets]]", "[[horn]]", "[[trumpet]]", "[[flute-piccolo]]", "[[double-bass]]", "[[mallet-percussion]]", "[[_instruments]]"]
---

# Transposing instruments and clefs

## Core idea
A transposing instrument sounds a fixed interval away from what is written; it is named after the note that
sounds when it reads C (Bb clarinet: written C sounds Bb). Reasons: the same fingering for the same written
note across sizes of a family, and keeping the best register inside the staff. Octave transpositions only
save ledger lines.

| Instrument | Written → sounding (st) | To write a part from MIDI |
|---|---|---|
| Bb clarinet, Bb trumpet, flugelhorn, Bb soprano sax | −2 (M2 down) | +2 |
| A clarinet | −3 (m3 down) | +3 |
| Alto flute in G | −5 (P4 down) | +5 |
| Horn in F, English horn | −7 (P5 down) | +7 |
| Eb alto sax | −9 (M6 down) | +9 |
| Bass clarinet (treble/French), tenor sax, bass trumpet in Bb | −14 (M9 down) | +14 |
| Bass clarinet in bass clef (German) | −2 | +2 |
| Baritone sax (Eb) | −21 (8ve + M6 down) (general knowledge; tema 1 table says −9 [?]) | +21 |
| Eb clarinet (requinto) | **+3** (m3 up) | −3 |
| Trumpet in D / Eb | +2 / +3 | −2 / −3 |
| Piccolo, celesta, xylophone | +12 | −12 |
| Glockenspiel, crotales | +24 | −24 |
| Double bass, contrabassoon, bass trumpet in C | −12 | +12 |
| Strings (except Cb), flute, oboe, bassoon, trombones, tuba, timpani, harp, piano, marimba, vibes, bells | 0 | 0 |

Historic horn crooks (written→sounding): C −12, D −10, Eb −9, E −8, F −7, G −5, A −3, Bb alto −2.
Old (19th-c.) horn bass-clef notation is written an octave low: in F it sounds a P4 *above* written (+5);
modern parts use −7 in both clefs (adler-orq-es p.315-316, piston-orch p.225-245; see [[horn]]).

**Clefs:** treble — violin, flute, oboe, clarinets, trumpet, horn (bass clef for low notes); alto — viola
(treble when high); tenor — high cello, bassoon, trombone; bass — cello, double bass, bassoon,
contrabassoon, trombone, tuba, timpani; grand staff — harp, keyboards; neutral single line — unpitched
percussion.

## Rules
- R1 `MUST` keep MIDI at concert pitch; never apply written transpositions to MIDI notes.
- R2 `MUST` when reading a part into MIDI, add the written→sounding value (Bb clarinet written D5 74 → 72).
- R3 `MUST` when producing a part, subtract it (concert C4 60 on horn in F → written G4 67).
- R4 `MUST` key signature of a transposing part = concert key moved up by the "to write" interval: Bb → +M2,
  A → +m3, G → +P4, F → +P5, Eb (alto sax) → +M6. Example: concert F major → Bb clarinet G major, horn C major.
- R5 `ALLOWED` scores in "C" (concert pitch) are common from c.1850 on and in film; parts stay transposed.
- R6 `PREFER` (register check) notes that fall inside the written staff are in a good register; notes far
  outside are suspect — except flute/piccolo, violins and the high cello, which are good above the staff.
- R7 `NEVER` treat the trombone as transposing; tema 1's claim that the bass trombone "reads an octave
  lower" is doubtful (standard practice: concert pitch).
- R8 `MUST` check each sample patch: most play sounding pitch, but some mallet/celesta/piccolo patches are
  mapped to written pitch.

## Apply in MIDI / REAPER
- `data/instruments.json` stores `transposition_semitones` (written→sounding) per instrument: sounding =
  written + value; written = sounding − value.
- Register check (inferred implementation of R6): compute written pitch; flag notes more than ≈ 4 ledger
  lines outside the instrument's clef (≈ > 7 st above F5 or below E4 in treble clef) except the listed
  instruments.

## Checklist
- [ ] MIDI notes are concert pitch on every track.
- [ ] Imported parts converted with the correct sign (Eb clarinet is the "up" exception).
- [ ] Exported parts carry the transposed key signature.
- [ ] Patch mapping (sounding vs written) verified for piccolo, glock, xylophone, celesta, bass.

## Examples
- Beethoven *Pastoral* (F major): Bb clarinets in G major, horns in F in C major.
- Brahms 4 (E minor): A clarinets in G minor; horns in E written a m6 up.
