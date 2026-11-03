---
id: orchestration.texture-accompanied-melody-voice-and-choir
title: Accompanying a singer, vocal ensemble or choir
aliases: [acompañamiento vocal, acompañamiento del cantante, orquesta y coro, coro y orquesta, recitativo, recitativo secco, recitativo accompagnato, aria, lied orquestal, canción orquestal, conjunto vocal, colla parte, ayuda en la entonación, figura acompañante, tesitura vocal, soprano, mezzosoprano, contralto, tenor, barítono, bajo profundo]
domain: orchestration
tags: [texture, accompaniment, voice, choir, opera, recitative, ranges]
style_scope: universal; era-tagged Baroque/Classical/Romantic/20th-c. models
use_when: Writing orchestra under a solo voice (aria, song, recitative), a vocal ensemble, or a choir; or checking vocal ranges and pitch support.
summary: "Singers find pitch by ear, so lead them to each entry and keep pitch references in the orchestra, choirs even more than soloists. Keep the texture thin where the voice is weak (its lowest 5th) and avoid long dense accompaniment; contrast the voice in colour, register and rhythm, double it with violins only at the climax. Choirs: double the parts (colla parte or key notes), write each part in its best register, and use an accompanying figure that supports without covering."
sources: ["adler-orq-es p.639-665"]
related: ["[[texture-accompanied-melody]]", "[[texture-accompanied-melody-concerto-soloist]]", "[[song-aria-recitative]]", "[[four-part-voices-and-spacing]]", "[[sacred-vocal-forms]]", "[[accompaniment-for-solo-line]]", "[[texture-secondary-melody-countermelody]]"]
---

# Accompanying a singer, vocal ensemble or choir

## Core idea
Accompanying voices is the orchestra's oldest job. A voice has no keys or valves: intonation depends on
what the singer hears, its power changes across its range and from singer to singer, and it tires under
heavy orchestration. Choirs, often amateur, need even more help.

## Ranges (Adler, extreme limits for most singers; sounding MIDI)
| Voice | Range | Notes |
|---|---|---|
| Soprano | 60–84 | some go higher; chest voice down to 55 |
| Mezzo-soprano | 57–81 | |
| Contralto | 55–77 (53) | alto in general 55–79 [?] |
| Tenor | 50–70 (48) | written treble 8vb |
| Baritone | 43–65 (67) | |
| Bass | 41–64 | basso profundo 40–62 (38) |

For choral parts use the narrower writing ranges of [[four-part-voices-and-spacing]] (S 60–79, A 55–74,
T 48–67, B 40–60) as the default; Adler's limits are for soloists.

## Rules
- R1 `PREFER` Accompany a voice's lowest 5th (7 semitones) lightly: it is its weakest zone; the next
  octave is relaxed and fairly strong, the top 5th the most powerful. Exception: many basses and altos
  sound better low than high. Soprano and tenor low notes can only be very soft.
- R2 `AVOID` Making a voice sing over dense accompaniment for long stretches: it strains the singer.
- R3 `MUST` Lead the singer to each entry (the orchestra sounds the pitch or a chord with it clearly on
  top) and keep pitch references throughout, more so in chromatic music. This does not mean doubling the
  voice all the time.
- R4 `PREFER` Contrast the voice with its accompaniment: a high soprano over dark low instruments (cello,
  horns, low woodwinds); instruments on short off-beat attacks or sustains while the voice moves.
- R5 `ALLOWED` Double the voice with violins an octave higher only at the dramatic climax (Bizet,
  Micaela's aria).
- R6 `ALLOWED` A busy orchestral "painting" if the voice is never covered: keep figures in the voice's
  rests or far from its register, and let the voice's pitches pass through changing instruments without
  literal doubling (Mahler, *Gesellen* songs).
- R7 `PREFER` Recitative accompagnato: soft sustained (fp) chords under the words, dramatic figures
  (tremolo, stabs) only in the vocal rests (Mendelssohn, *Elijah*).
- R8 `PREFER` Vocal ensemble: double each voice part, continuously or on its key notes, keep the texture
  around the singers very light, put wind flourishes in the gaps between phrases (Beethoven, *Fidelio*
  quartet). A bass part may be doubled octaves higher, a soprano part by a bass instrument.
- R9 `MUST` Choir with a large modern orchestra (Orff model): (a) double the vocal lines often, above all
  at entries; (b) write each part in its most favourable register; (c) add an accompanying figure that
  supports pitch and rhythm without covering.
- R10 `PREFER` When the orchestra doubles the whole choir, vary the doubling from phrase to phrase (flute
  moves from soprano to tenor two octaves up, Haydn).

## Period practice
- `[era: Baroque]` secco recitative: voice over a held continuo bass, keyboard chords at harmony changes.
  Fugal chorus: the continuo (organ, bass, bassoon) carries every entry; upper strings/oboe only at phrase
  starts and cadences (Bach BWV 21).
- `[era: Classical]` choir doubled colla parte: Fl 8va on soprano, Ob/Cl on soprano/alto, alto/tenor/bass
  trombones on A/T/B, Bsn + Vc + Cb (+ Cbsn) on the choral bass, horns/trumpets/timpani on tonic-dominant;
  violins free to answer between choral phrases (Haydn, *Creation*). An undoubled choir took its pitch
  from plain diatonic harmony.
- `[era: 19th-c. Italian opera]` very simple figures (pizz oom-pah, one wind obbligato, held bassoon/horn
  chords) so the singer projects (Verdi, *Traviata*).
- `[era: 20th c.]` alternate ff tutti doubling the choir with long pp stretches over a low staccato
  ostinato + pedal + one reed doubling the tune (Orff, *O Fortuna*); dramatic recit: voice alone, then
  ppp low tremolo with percussion colours between the words (Walton).

## Apply in MIDI / REAPER
- Validate vocal lines against the table; flag sustained notes in a voice's lowest 7 semitones and thin
  the orchestra (fewer tracks, CC1 −15, inferred) there.
- Entry cue: in the beat before each vocal entry, put the entry pitch in an audible top voice (e.g. `CL` or
  `VLN II`); in chromatic passages let some track touch the vocal pitches every bar or two.
- Choir tracks (Mysteria textures or a choir patch): at least one instrument track doubles each part at
  unison or octave at entries and after rests (inferred).
- Aria bed: wind obbligato 16ths staccato, sustained `BSN`/`HN` chords, pizz strings on beats; the voice
  is the only legato line in its register.

## Checklist
- Is every vocal note inside its range, and long notes outside the weak lowest 5th or thinly
  accompanied?
- Does each entry have a pitch reference?
- Is the voice uncovered (contrast in register/colour/rhythm, figures in its rests)?
- Is each choral part doubled at least at its entries?
