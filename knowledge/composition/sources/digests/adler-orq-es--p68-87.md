---
source_id: adler-orq-es
source_title: Samuel Adler, El estudio de la orquestación (Spanish translation of the 3rd ed., Idea Books; original 2002)
source_era: "2002 (3rd ed.); late-20th-c. American/international orchestral practice, with historical notes on earlier periods"
scan_pages: 68-87
printed_pages: 51-70
missing_printed_pages: []
chapters: ["3 Instrumentos de cuerda y arco — El violín (p.51)", "3 Instrumentos de cuerda y arco — La viola (p.65)"]
continues_from: null
continues_into: "3 Instrumentos de cuerda y arco — La viola, 'Pasajes emblemáticos del repertorio' (Ex. 3-39 violins+violas in octaves and Ex. 3-40 violas+cellos are announced on printed p.70 but printed on p.71+)"
---

# Adler, El estudio de la orquestación — scans 68–87 (violin, viola start)

Pitch convention: C4 = middle C = MIDI 60. The book's Spanish octave names ("SOL 3", "MI 7", "RE 4") match this
convention (checked against the staff positions in Ex. 3-2 and 3-3). Violin and viola are non-transposing, so all
pitches below are concert pitch. MIDI numbers are my conversion. Printed p.56 (scan p0073) has no visible page number
but the sequence 51–70 is continuous.

## 3 El violín — introduction (scan p.68, printed p.51)

**Concepts**
- Violin (violín; violino It., violon Fr., Violine/Geige Ger.): soprano of the string section; held on the left
  shoulder, left hand on the neck.

**Rules**
- R1 [ALLOWED] Every string technique and timbral effect of ch.2 (bowings, pizz., harmonics, tremolo, mutes…) works
  on the violin; it is the most versatile string instrument.

**Tags:** #orchestration/strings/violin

## Tuning, register, fingering (Afinación, registro y digitación) (scan p.69–70, printed p.52–53)

**Concepts**
- Open strings (cuerdas al aire), numbered by players I–IV from the top: I = E5 (76), II = A4 (69), III = D4 (62),
  IV = G3 (55).
- Clef: always treble (clave de sol).
- Positions (posiciones): the book charts 1st–5th position; half positions (medias posiciones) are alternative
  fingerings in 1st position for chromatic, whole-tone or artificial-scale passages.

**Rules**
- R1 [MUST] Practical orchestral range (excluding harmonics): G3–E7 (MIDI 55–100), all chromatic notes.
- R2 [ALLOWED] Solo/chamber writing can reach B7 (107) or higher.
- R3 [AVOID] Lean on the extreme top register for sections: it is hard to control on every string instrument.
- R4 [era: Classical period] The upper limit was A6 (93). Writing much higher than that is a practice of roughly
  the last 150 years. Cap violins at A6 to sound Classical (inferred from the period note).
- R5 Why the top is hard: above 7th position (where A is the top note) the finger spacing keeps shrinking and the
  thumb loses its anchor on neck/body, so the hand finds high notes without a positional reference.
- R6 [MUST] G3–C#4 (55–61) exist only on the G string; B6 (95) and above only on the E string. From D4 (62) upward
  each note is available on more than one string.
- R7 [PREFER] Leave fingering/string choice to the player; specify a string only for a deliberate timbre.
- R8 Open strings ring more (more sympathetic resonance) but cannot take finger vibrato. In fast passages mixing open
  and stopped notes is fine; in slow expressive lines an open note stands out from the vibrated ones, so players aim
  for even timbre.
- R9 [ALLOWED] Exploit that contrast on purpose, e.g. keep a whole melody on the G string (Ex. 3-4).

**Examples**
- Ex. 3-4 Brahms, Symphony 1/iv, m.61–75: the big violin tune kept entirely on the G string; listen for the
  resonant open G.

**Agent applicability**
- Clamp violin MIDI to 55–100 for section patches; reserve 101+ for solo violin; 93 max for Classical pastiche.
- Any violin note below 62 is G-string-only: low passages are single-string and dark by necessity.

**Tags:** #orchestration/strings/violin #orchestration/ranges #era/classical

## Passages on a single string (Pasajes interpretados exclusivamente en una sola cuerda) (scan p.70–72, printed p.53–55)

**Rules**
- R1 [MUST] To keep a passage on one string, mark `sul` + string name (sul E/MI, sul A/LA, sul D/RE, sul G/SOL);
  French scores use the Roman numerals I–IV instead. Same marking for the whole violin family.
- R2 G string (cuerda SOL): thickest and most sonorous; in higher positions it becomes very intense because the
  vibrating length keeps shrinking.
- R3 D string (cuerda RE): the least characteristic of the four, but warm and lyrical; sweeter still in high positions.
- R4 A string (cuerda LA): most striking in 1st position; loses brilliance and power in high positions, which suits
  soft lyrical lines.
- R5 [PREFER] If you want brilliance in the high register, send the player to the E string for the rest of the
  passage instead of climbing on A.
- R6 E string (cuerda MI): the brightest; luminous in the high register. At soft dynamics it can also sound hushed
  and mysterious.

**Examples**
- Ex. 3-5 Tchaikovsky, Symphony 5/ii, m.111–119: Vln 1 sul G, Andante, mf with swells to sf/f; intense G-string
  cantabile.
- Ex. 3-6 Rimsky-Korsakov, *Scheherazade*/iii, m.1–8: sul D, p, 6/8 lyrical melody; warm D-string colour.
- Ex. 3-7 Puccini, *Madama Butterfly* Act II at [16]: Vln 1 sul A, Largamente, f; singing A-string melody.
- Ex. 3-8 R. Strauss, *Don Juan*, m.9–17: Vln 1 sul E, ff, high leaping figures; E-string brilliance.
- Ex. 3-9 Prokofiev, *Classical Symphony*/ii, m.5–13: Vln 1 sul E, pp, high register with trills and triplets;
  delicate, mysterious E string.
- Study pointers: Mahler 3/i m.5–8 (G string); Brahms 3/iii m.13–24 (A-string section).

**Agent applicability**
- Pick the register to imply the string colour: dark/intense melody in 55–74 (G string up to ~5th position),
  brilliant lines ≥ 76 (E string). Sample libraries rarely model `sul`; choose register and patch (e.g. a
  "sul G" or "sul tasto" articulation) instead (inferred).

**Tags:** #orchestration/strings/violin #orchestration/timbre

## Multiple stops (Cuerdas múltiples) (scan p.72–74, printed p.55–57)

**Concepts**
- Double, triple, quadruple stops (cuerdas dobles, triples, cuádruples). Ex. 3-10–3-13 chart a partial list
  (diatonic and chromatic doubles, triples, quadruples), mostly built on the open strings and lower positions.

**Rules**
- R1 [AVOID] The hardest double stops belong to solo (and sometimes chamber) music, not the orchestra.
- R2 [PREFER] In orchestral parts use only the accessible double stops, especially for loud dry chords (acordes
  *secco*) and very sonorous passages.
- R3 [PREFER] Use divisi for anything awkward: a standard section has at least 16 first and 14 second violins, so
  a passage hard for one player is simple when split.
- R4 [MUST] Triple and quadruple stops are always arpeggiated (broken from bottom to top), never truly simultaneous.
- R5 [AVOID] Some multiple stops are hard for small hands; prefer chords that include open strings (inferred from the
  charts, which lean on open strings).

**Agent applicability**
- For violin-section chord hits, write ≤ 2 notes per staff as a double stop; spread 3–4-note chords as divisi
  tracks or accept a slight roll (stagger note-ons by a few ms, bottom first) to imitate the arpeggiated stop.
- Section sizes for realism: Vln I ≥ 16, Vln II ≥ 14.

**Tags:** #orchestration/strings/multiple-stops #orchestration/divisi

## Harmonics (Armónicos) (scan p.74–77, printed p.57–60)

**Concepts**
- Artificial harmonics: one finger stops a note (nota pulsada), another lightly touches a higher point
  (nota rozada ligeramente, diamond notehead). In the charts, `0` under a note = open string, `1` = first finger.
- Touch-a-fourth (armónico "de 4ª"): touch a P4 (5 st) above the stopped note → sounds two octaves (24 st) above it.
- Touch-a-fifth ("de 5ª"): sounds an octave + P5 (19 st) above the stopped note.
- Touch-a-major-third ("de 3ª Mayor"): sounds two octaves + M3 (28 st) above.
- Touch-a-minor-third ("de 3ª menor"): sounds two octaves + P5 (31 st) above.

**Rules**
- R1 [PREFER] The touch-a-fourth harmonic is the easiest and by far the most common in orchestral scores.
- R2 [AVOID] Touch-5th, M3 and m3 harmonics in orchestral writing: they are very weak and risky. They appear in solo
  violin and some chamber music.
- R3 [ALLOWED] Natural and artificial harmonics both appear in orchestral repertoire (examples below).

**Examples**
- Ex. 3-18 Copland, Symphony 3/iv, m.3–8 after [128]: Vln 1 and 2 in accented (>>>) rhythmic harmonic chords
  [? exact pitches] in an Allegro: harmonics used percussively, not only as soft colour.
- Ex. 3-19 Webern, *Six Pieces* Op.6/5, m.20–26 (strings only): muted solo strings (solo violin, Vln 1 "alle",
  solo Vln 2, Vla, 2 Vc soli) hold pp natural/artificial harmonics, dying away (verlöschend); a glassy sustained
  chord under a muted solo line.
- Ex. 3-20 Stravinsky, *Rite of Spring* at [101] (strings only): Vln 1 divided in 8, Vln 2 and Vla also divisi,
  sustaining very high harmonics (several under 8va) while 3 solo cellos play a slurred chromatic line and the other
  cellos/violas add short low grace-note figures; dense divisi harmonic cloud as an eerie backdrop.

**Agent applicability**
- A touch-4th harmonic sounds 24 st above the stopped note; when writing MIDI for a harmonics patch, write the
  sounding pitch.
- Use harmonics for pp shimmer pads (divisi, many voices) or, rarely, accented rhythmic colour; keep them out of
  loud tutti melody.

**Tags:** #orchestration/strings/harmonics #orchestration/textures

## The solo violin (El violín solista) (scan p.77–80, printed p.60–63)

**Rules**
- R1 Concertos for violin exist from the Baroque onward (Bach, Mozart, Beethoven, Mendelssohn, Brahms, Dvořák,
  Tchaikovsky, Bruch, Lalo, Schoenberg, Berg, Stravinsky, Bartók, Prokofiev, Penderecki, Rochberg): study them.
- R2 [MUST] An orchestral "violin solo" is played by the concertmaster (concertino).
- R3 With two soloists, they are the first-desk Vln 1 players; with a solo part in Vln 1 and another in Vln 2, they
  are the concertmaster and the principal second.
- R4 [ALLOWED] Orchestral solos can be virtuosic: section principals are expected to play at soloist level.

**Examples**
- Ex. 3-21 Brahms, Symphony 1/ii, m.91–105: solo violin over a light full orchestra (strings p, cello pizz.,
  woodwind and horn lines); later the solo plays sextuplet figuration above staccato triplet chords in winds and
  strings while the horn carries an espressivo melody. Shows how to keep the tutti thin and soft under a solo violin.
- Ex. 3-22 R. Strauss, *Don Juan*, m.73–81: solo violin, Andante, molto espressivo, high-register phrases with wide
  upward leaps and triplets.
- Study pointers: Grofé *Grand Canyon* "On the Trail" opening cadenza; Respighi *Roman Festivals*/iii 4 bars after
  [25]; Rimsky-Korsakov *Scheherazade*/i at [C] (recurring cadenza, also at [G] and opening of mvt ii);
  R. Strauss *Till Eulenspiegel* m.205–209. See also Ex. 2-41.

**Agent applicability**
- Put an orchestral violin solo on its own solo-violin track (not the section patch) and thin/soften the
  accompaniment around it.

**Tags:** #orchestration/strings/violin #orchestration/solo

## Other violin techniques: leaps (Saltos) (scan p.80–81, printed p.63–64)

**Rules**
- R1 [AVOID] Treat wide leaps as genuinely hard even on an agile violin, especially for a whole section; a soloist
  executes sudden leaps more accurately than a section.
- R2 Why: the whole left-hand position changes, strings may be skipped, and sometimes a very high note must be followed
  by a very low one on the same string, while keeping the shift silent.
- R3 [ALLOWED] Leaps from low to high register sound exciting; good players can make them sound legato even across
  strings.
- R4 Recordings are misleading: sections re-record leaps until clean, so do not assume live sections can do it.
- R5 Three hard types: (1) wide leaps on the same string; (2) wide leaps in extreme registers; (3) wide leaps
  played legato.

**Examples**
- Ex. 3-23 Wagner, *Meistersinger* Prelude, m.33–38: Vln 1 wide leaps on one string, cresc. to f, then staccato.
- Ex. 3-24 Bartók, *Divertimento*/i, m.50–52: Vln 1 ff jumps from low notes to very high ledger-line notes in 9/8
  [? meter].
- Ex. 3-25 Berg, *Lyric Suite*/iv, m.10–14: wide slurred leaps with triplets and hairpins, mf to pp.
- Study pointers: same string, Shostakovich 5/i m.51–62; extreme registers, Copland 3/iv m.2–4 after [96] and
  Prokofiev *Classical*/i second theme; legato, Stravinsky *Agon* Pas de deux m.411–418.

**Agent applicability**
- Validator idea: flag violin-section intervals > ~P12 (19 st) between consecutive notes, especially legato or
  crossing into ≥ 88; prefer octave displacement or a solo track (inferred threshold).

**Tags:** #orchestration/strings/violin #orchestration/idiomatic-limits

## Chromatic passages (Los pasajes cromáticos) (scan p.81–82, printed p.64–65)

**Rules**
- R1 [ALLOWED] Every chromatic note from G3 to the top is easy on the violin.
- R2 Standard chromatic fingering reuses the finger of the natural note for its alteration (same finger for F and F#,
  Ex. 3-26), which slides and risks an audible portamento.
- R3 [PREFER] For fast chromatic passages players use "half-position" fingering (media posición), with a different
  finger for each note (Ex. 3-27, same fingering on every string); it minimizes finger noise when changing notes.

**Agent applicability**
- Fast chromatic runs are idiomatic for strings; slow chromatic slides may carry slight portamento (fine for
  expressive legato patches).

**Tags:** #orchestration/strings/violin #orchestration/idiomatic-limits

## 3 La viola — introduction (scan p.82, printed p.65)

**Concepts**
- Viola (viola It., alto Fr., Bratsche Ger.): alto voice of the strings; technique similar to the violin.

**Rules**
- R1 The viola is noticeably bigger than the violin (sometimes by 3–4 in, ~7.5–10 cm): the hand must stretch more to
  play in tune and left-hand tension is greater, especially in high positions.
- R2 Viola sizes vary; there is no agreed ideal size for its dark characteristic sound. Players pick a size to suit
  their left hand.
- R3 [ALLOWED] Trills, bowings, harmonics, arpeggios and double/triple/quadruple stops work as well on viola as on
  violin.
- R4 [era: 18th c.] Masters rarely wrote four independent string parts, and violists were often converted violinists
  not trusted by composers, so the viola was long neglected (i.e. often doubling bass or filling, inferred). Bach, Stamitz and Mozart
  wrote occasional solo/concertante viola works.
- R5 [era: from Berlioz, 19th c.] Berlioz was the first to give the viola a truly independent orchestral voice.

**Agent applicability**
- For 18th-c. pastiche, let violas double the bass line an octave up or fill harmony; from Romantic style on, give
  them independent lines (inferred from R4–R5).

**Tags:** #orchestration/strings/viola #era/classical #era/romantic

## Viola tuning, register, fingering (scan p.83–84, printed p.66–67)

**Concepts**
- Open strings IV–I: C3 (48), G3 (55), D4 (62), A4 (69): a fifth below the violin.
- Clef: normally alto clef (clave de Do en 3ª); treble clef for high notes to avoid ledger lines (Ex. 3-29 shows the
  same pitch in both clefs).

**Rules**
- R1 [MUST] Range: C3 (48) up through all chromatic notes; Ex. 3-30 draws the top in treble clef around G6–A6
  (91–93) [? ledger lines unclear; text gives no number].
- R2 The viola bow is a little heavier than the violin bow.
- R3 [PREFER] Strings are thicker and resist the bow more, so a firmer stroke is needed for a full tone; lighter
  strokes are possible but harder.
- R4 [ALLOWED] Harmonics speak more easily and reliably than on violin because of the thicker strings.
- R5 Fingering system identical to the violin; the same multiple-stop patterns work a fifth lower; half positions,
  chromatic fingering, pizzicato and other timbral effects apply as on the violin.

**Agent applicability**
- Clamp viola MIDI to 48 – ~93; treat the top as solo territory and keep section writing lower (inferred, the book
  gives no practical section limit here).

**Tags:** #orchestration/strings/viola #orchestration/ranges

## Viola single-string colours (scan p.84–85, printed p.67–68)

**Rules**
- R1 C string (cuerda DO): the string the violin lacks, considered the most characteristic viola sound; Gevaert
  called it sombre, austere, even menacing.
- R2 G and D strings: the least characteristic, "accompaniment strings" where violists play the traditional
  accompaniment figures; [ALLOWED] they can also be exploited for their dark quality.
- R3 A string (cuerda LA): less brilliant than the violin E string but penetrating and nasal. Blends very well with
  woodwinds and sometimes doubles well with soft trumpets and trombones. Its projection makes it the usual string for
  viola solos.

**Examples**
- Ex. 3-31 Hindemith, Viola Sonata Op.11 No.4/i, m.15–16: low C-string cadenza, f fading to pp.
- Ex. 3-32 Bartók, *Concerto for Orchestra*/iv, m.42–51: violas f cantabile in mixed meters on the middle strings;
  a dark, warm tune.
- Ex. 3-33 Hindemith, *Der Schwanendreher*/i, m.48–59: solo viola climbing into treble clef, mf to f, triplet
  figures; the projecting A string.

**Agent applicability**
- Dark/ominous viola colour: write in 48–60 (C string). Accompaniment figures sit in 55–74. Solo viola lines and
  doublings with soft brass or woodwinds sit on the A string (69+).

**Tags:** #orchestration/strings/viola #orchestration/timbre #orchestration/doubling

## Viola multiple stops (scan p.85–86, printed p.68–69)

**Rules**
- R1 Ex. 3-34–3-36 chart doubles, triples and quadruples. Doubles shown on C–G transfer the same way to G–D and
  D–A; triples on C–G–D transfer to G–D–A. All charted triple stops are first-position.
- R2 [ALLOWED] The viola section can take multiple stops divisi, as violins do.

**Tags:** #orchestration/strings/viola #orchestration/multiple-stops

## Viola: emblematic passages (Pasajes emblemáticos del repertorio) (scan p.87, printed p.70)

**Rules**
- R1 [ALLOWED] Violas can serve as the bass of the string section (Ex. 3-37).
- R2 Filler passages (pasajes de relleno) are a staple viola role (Ex. 3-38).
- R3 [PREFER] Violins + violas in octaves, and violas + cellos, are satisfying pairings (Ex. 3-39, 3-40, pages
  beyond this range).

**Examples**
- Ex. 3-37 Mendelssohn, *Midsummer Night's Dream* Overture, m.45–49: no cellos/basses; violas pizz. give the bass,
  Vln 2 divisi pizz. then arco, Vln 1 divisi staccato line: a light, airy string texture.
- Ex. 3-38 Wagner, *Lohengrin* Act III "In fernen Land", m.12–19: Vln 1, Vln 2 and Vla all divisi in repeated
  triplet chords, sempre f: violas as harmonic filler in a pulsing string chord texture.

**Agent applicability**
- For a light/fairy texture, drop cellos and basses and let violas pizz. carry the bass.
- Repeated-triplet chord fill: split Vln 1, Vln 2 and Vla into two notes each (divisi) for a full six-voice pulse.

**Tags:** #orchestration/strings/viola #orchestration/textures #orchestration/roles
