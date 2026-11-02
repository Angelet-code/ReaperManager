---
source_id: adler-orq-es
source_title: Samuel Adler, El estudio de la orquestación (Spanish translation of the 3rd ed., Idea Books; original 2002)
source_era: "2002 (3rd ed.); late-20th-c. American/international orchestral practice, with historical notes on earlier periods"
scan_pages: 44-67
printed_pages: 27-50
missing_printed_pages: []
chapters: ["2 Instrumentos de cuerda y arco — jeté, arpeggiando, trills, tremolos, bow placement, col legno, pizzicato, mutes, scordatura, harmonics, contemporary techniques"]
continues_from: "2 Instrumentos de cuerda y arco — bowings (golpes de arco): end of the spiccato section"
continues_into: null
---

# Adler, El estudio de la orquestación — scans 44–67 (printed 27–50)

Pitch convention: C4 = middle C = MIDI 60. Ranges in concert pitch. The double bass sounds an octave below
written; where I give bass harmonics in MIDI I converted to sounding pitch myself. Open strings (sounding):
violin G3 55 / D4 62 / A4 69 / E5 76; viola C3 48 / G3 55 / D4 62 / A4 69; cello C2 36 / G2 43 / D3 50 / A3 57;
bass E1 28 / A1 33 / D2 38 / G2 43 (4-string; inferred from standard tuning, the book's table only names the strings).
Printed page numbers run continuously 27–50; no pages are missing in this scan range.

## 2 Spiccato (end) (scan p.44, printed p.27)

- Additional study pointer: Beethoven Sym. 1/ii m.154–156 (deliberate spiccato); Rossini *William Tell* Overture
  m.336–343 (spontaneous spiccato).

## 2 Jeté / ricochet (scan p.44, printed p.27)

**Concepts**
- jeté (Fr.) / ricochet (Eng.) (*jeté*, *ricochet*): the upper third of the bow is thrown onto the string so it
  bounces, producing 2–6 rapid notes in one stroke. Normally a down-bow; an up-bow is possible.

**Rules**
- R1 [PREFER] In orchestral writing, write at most 3 notes per jeté stroke. *Why:* the more notes per stroke, the
  less practical the jeté; soloists can do many more cleanly.
- R2 [MUST] Cello and bass jeté: limit 3 notes per stroke, 4 at most. *Why:* their bows are slightly shorter.
- R3 [PREFER] Start a jeté group on a down-bow (default); up-bow is allowed.

**Examples**
- Ex 2-41 Rimsky-Korsakov, *Capriccio espagnol* iii m.19–22 (Vivo, 2/4): solo violin bounced arpeggio figures
  across strings (a thrown group then separate dotted notes), over sparse cello quarter notes; rest of strings tacet.
- Ex 2-42 Shostakovich, Sym. 8 ii m.67–72 (♩=144, 3/4): Vn1, Vn2, Va *pp* ricochet groups of ~4–5 repeated
  sixteenths under one slur with dots, alternating with single staccato eighths — a whispered, mechanical texture.
- Study pointer: Rimsky-Korsakov *Capriccio espagnol* v m.89–96; Stravinsky *Firebird* from m.30.

**Agent applicability**
- Jeté is a solo/short-group effect: in MIDI use a spiccato/ricochet patch or very short (≤ 0.1 beat) notes in
  groups of ≤3 (≤3–4 for cello/bass), slightly decaying velocity within each bounced group (inferred).

**Tags:** #orchestration/strings #articulation/jete #articulation/ricochet

## 2 Arpeggiando (scan p.45, printed p.28)

**Concepts**
- arpeggiando (*arpeggiando*): a spiccato-type stroke related to jeté that rolls across 3 or 4 strings. At
  moderate tempo it is just a slurred arpeggio played on the string; at fast tempo the right wrist makes the bow
  bounce on its own and true arpeggiando results.

**Rules**
- R1 [ALLOWED] Use arpeggiando arpeggios across 3–4 strings in solo and chamber music, and also orchestrally
  (e.g. the cadenza in the last movement of Rimsky-Korsakov's *Scheherazade*).
- R2 [PREFER] Build the figure from notes that lie on adjacent strings (one note per string, up and back)
  (inferred from Ex 2-43/2-44).

**Examples**
- Ex 2-43 generic: slurred groups of 4 then triplets, each note on a different string, rising and falling.
- Ex 2-44 Mendelssohn, Violin Concerto i m.328–336 (Allegro molto, cut time): solo violin four-string arpeggios
  in continuous eighths, *ff* with accents then *poco a poco dim.* to *pp* — the cadenza exit over changing chords.

**Agent applicability**
- For string arpeggios across chords, order the notes by string (low→high→low); one string crossing per note.

**Tags:** #orchestration/strings #articulation/arpeggiando

## 2 Trills (Trinos y otros efectos coloristas con el arco) (scan p.45–46, printed p.28–29)

**Concepts**
- trill (*trino*): the written note is stopped and the adjacent upper finger strikes and releases the next note
  as fast as possible for the written duration. Upper or lower neighbour may be specified by the composer.
  Notation: *tr~~* above the note.

**Rules**
- R1 [AVOID] Trills on an open-string main note. *Why:* the open string's colour differs from a stopped string,
  so the trill is less even and effective.
- R2 [PREFER] Use section trills (e.g. 16 violins or 10 violas) for a diffuse, shimmering rhythmic blur; it
  sounds quite unlike a solo trill (no player is in sync with another).

**Examples**
- Ex 2-45 Hindemith, *Mathis der Maler* iii at [16]: whole string section divided (Vn1 a2, Vn2 a2, Va, Vc a2, Cb)
  with trills on chromatic lines and sustained notes, *mp*/*p* swelling to *f*, then thinning to *pp* — a tutti
  trilling texture in every register; meters 3/4–4/4–2/4.

**Agent applicability**
- In MIDI, prefer a library trill patch (half/whole-tone) for section trills; a hand-written trill should be
  slightly irregular in timing per desk/track so the section blurs (inferred). Avoid trilling from an open
  string pitch (violin G3/D4/A4/E5 etc.) when the sample patch models it.

**Tags:** #orchestration/strings #articulation/trill

## 2 Tremolos (scan p.46–47, printed p.29–30)

**Concepts**
- bowed tremolo (*trémolo con arco*): one note repeated as fast as possible for its written value by short, rapid
  up-and-down strokes; unmeasured.
- fingered tremolo (*trémolo ligado*): rapid alternation between two notes a 2nd or wider apart, like a trill;
  the composer gives a total time value, the notes inside are not measured.

**Rules**
- R1 [PREFER] Use bowed tremolo for atmospheric/agitated special effects.
- R2 [MUST] Slur the two alternating notes of a fingered tremolo so the bow moves legato.
- R3 [ALLOWED] A fingered tremolo played détaché (separate bows) is sometimes asked for; then the slur is
  omitted (exception to R2).
- R4 [MUST] In notation, the fingered tremolo shows both notes with the total duration split between them
  (each note written with the full value, as in Ex 2-47) (inferred from the example).

**Examples**
- Ex 2-46 Verdi, *Requiem* "Dies irae" m.46–51 (Allegro agitato, 𝅗𝅥=80): Vn1 *ff* bowed tremolo in the top
  register (8va), descending chromatic-ish line — terror/agitation.
- Other bowed-tremolo uses cited: Bizet *Carmen*, Berlioz *Symphonie fantastique*, Mendelssohn Piano Concerto
  in G minor.
- Ex 2-47 Debussy, *La Mer* i at [8] (Modéré, 6/8, D♭ major area): Vn1 and Vn2 fingered tremolos on
  shifting intervals, *p* < *mf* swells — liquid, shimmering water texture.
- Study pointer: Berlioz *Fantastique* i at [5]; Bizet *Carmen* Overture, Andante moderato; Debussy *Nocturnes*
  "Sirènes" at [1]; Dvořák Cello Concerto at [1] (violas); Prokofiev *Scythian Suite* at [40] (bowed tremolo
  Vn+Va) and [43] (fingered tremolo, violas); Stravinsky *Firebird* start of Finale.

**Agent applicability**
- Bowed tremolo = tremolo patch, one sustained MIDI note; fingered tremolo = a "trill/tremolo" interval patch or
  rapid unmeasured alternation; never write fingered tremolo as metered 32nds if the intent is unmeasured.

**Tags:** #orchestration/strings #articulation/tremolo

## 2 Measured effects that look like tremolos (Efectos medidos) (scan p.47–48, printed p.30–31)

**Concepts**
- measured repetition (*efecto medido*): slashes through a stem are shorthand for exact repeated notes, not a
  tremolo. Number of slashes = number of beams of the subdivision (1 = eighths, 2 = sixteenths, 3 = 32nds)
  (Ex 2-48 shows the written-out values).
- undulating tremolo (*trémolo ondulante*): measured alternation of two notes on adjacent strings — looks like a
  tremolo but is metered; can be slurred or separate.

**Rules**
- R1 [MUST] Do not confuse slash-abbreviated measured notes with real tremolo: render them as exact repeated
  notes at the subdivision shown.
- R2 [ALLOWED] Undulation between two notes on adjacent strings may be slurred or separate bows.

**Examples**
- Ex 2-49 Wagner, *Der fliegende Holländer* Overture m.319–324: Vn1/Vn2 *f* rising scalar/arpeggio lines where
  each slashed eighth is played as measured repeated sixteenths — the storm surge.
- Ex 2-50 Martinů, Sym. 1 i, one bar after [14] (Moderato, 𝅘𝅥.=54, 6/8): violins high (8va) alternating dotted
  quarters on adjacent strings, slashed, *p* < *mf* > *p* — a gently rocking measured shimmer.

**Agent applicability**
- When a score/sketch has slashed stems, expand them to real notes (e.g. 2 slashes on a quarter = 4 sixteenths).

**Tags:** #orchestration/strings #notation/abbreviation

## 2 Unusual bow placements (Colocaciones inusuales del arco) (scan p.48–50, printed p.31–33)

**Concepts**
- Bow contact point changes colour: over the fingerboard, near/at the bridge, or using the stick (wood) instead
  of the hair.
- sul tasto (It.) / sur la touche (Fr.) / am Griffbrett (Ger.): bow over the fingerboard; flute-like, soft, hazy.
- flautando: bow near the fingerboard but not over it; difference from sul tasto is minimal and many composers
  do not distinguish them.
- sul ponticello (It.) / au chevalet (Fr.) / am Steg (Ger.): bow very near or on the bridge; brings out upper
  partials normally inaudible; mysterious, glassy timbre.
- col legno tratto (*col legno tratto*): the bow is turned and the wood is drawn across the string; wood grips
  less than hair, so the sound is faint and ghostly.
- col legno battuto (*col legno battuto*): the string is struck with the wood; percussive, like a very dry short
  spiccato; little pitch definition except at the top and bottom of the range, depending on the strings struck.

**Rules**
- R1 [PREFER] Sul tasto/flautando for soft, veiled melodic lines (*p*).
- R2 [PREFER] Combine sul ponticello with bowed or fingered tremolo (its most common use).
- R3 [PREFER] Col legno tratto mainly for tremolo; occasionally in legato passages.
- R4 [ALLOWED] Col legno battuto is more common than tratto; use it for percussive rhythmic patterns where pitch
  clarity is secondary.
- R5 [MUST] After any special effect (col legno, col legno battuto, sul ponticello, etc.) mark the return with
  *normale*, *naturale* or *modo ordinario* (American scores: "natural", e.g. Copland, Schuman, Persichetti).

**Examples**
- Ex 2-51 Debussy, *Ibéria* part 2 at [40] (♪=92, 6/8): solo cello line *sur la touche, expressif et doucement
  soutenu*, *p* — veiled melody in the cello's low-middle register.
- Study pointer (sul tasto): Debussy *Prélude à l'après-midi d'un faune* m.96–98.
- Ex 2-52 Puccini, *Madama Butterfly* Act I, 3 bars before [38] (Allegro ♩=144): Vn1 sul ponticello bowed
  tremolo on double stops, *mf* → *pp* < *f*.
- Study pointer (sul pont.): R. Strauss *Sinfonia domestica* (throughout).
- Ex 2-53 R. Strauss, *Also sprach Zarathustra* at [12] (Sehr langsam): violins col legno (tratto) tremolo on
  double stops, *pp* — a ghostly, skeletal colour.
- Ex 2-54 Berlioz, *Symphonie fantastique* v m.444–455 (Allegro, 6/8): Vn1, Vn2, Va "frappez avec le bois de
  l'archet" (col legno battuto) in repeated rhythmic figures (witches' dance), while cellos trill and cello 2 +
  basses play *pp* pizzicato — rattling-bones texture.
- Study pointer (col legno): Mahler Sym. 1 iii m.135–137.

**Agent applicability**
- Map to library articulations: sul tasto/flautando → "sul tasto"/"flautando" patch or a soft long with lower
  CC1; sul pont. tremolo → "sul pont tremolo" patch; col legno battuto → "col legno" short patch; never fake col
  legno with a normal staccato at high velocity.
- In MIDI parts/notes, close each effect with a return to the normal articulation (keyswitch back to "ord.").

**Tags:** #orchestration/strings #articulation/sul-tasto #articulation/sul-ponticello #articulation/col-legno

## 2 Pizzicato (Efectos coloristas sin arco) (scan p.50–56, printed p.33–39)

**Concepts**
- pizzicato (*pizzicato*, *pizz.*): plucking. Violin/viola: thumb anchored on the fingerboard edge, pluck with
  index finger (some players now pluck without anchoring). Cello/bass: pluck with index finger, no thumb anchor.
  During pizz the bow is held against the palm by the other three fingers; in long pizz sections with rests
  before and after, players may put the bow down (lap or stand) for more control.
- Sustain depends on string thickness and instrument size: double-bass pizz rings longest of the violin family.
- left-hand pizzicato (*pizzicato con la mano izquierda*, "+" over the note): plucked by a left-hand finger, often
  on open strings with the little finger; a descending series can be played, each higher finger plucking the
  next lower note.
- Bartók (snap) pizzicato (*pizzicato Bartók*, circle-with-line sign): string pulled so it snaps back against the
  fingerboard. 20th-century innovation.
- nail pizzicato (*pizzicato de uña*): plucked with the fingernail (own sign). 20th-century.
- pizzicato chord (*acorde pizzicato*): 3–4-note chord strummed.

**Rules**
- R1 [MUST] Mark *pizz.* where pizzicato starts and *arco* where bowing resumes, in score and parts.
- R2 [MUST] Give time for each change pizz ↔ arco; avoid writing no-time changes (they exist in the repertoire
  but are rare).
- R3 [PREFER] Allow more time for pizz → arco than arco → pizz. *Why:* the hand must regrip the frog.
- R4 [PREFER] Arrange an up-bow just before a pizzicato so the hand arrives near the frog and switches faster.
- R5 [ALLOWED] With no time at all, players keep the bow in hand and pluck with an extended index finger.
- R6 [PREFER] Left-hand pizz is far more common in solo/chamber music than in orchestral writing; use it mostly
  on open strings or descending scale fragments on one string.
- R7 [MUST] Default pizz chords (no indication) are strummed low → high, giving an arpeggiated effect; the
  player minimises it by plucking incisively. Write *non arpegg.* to ask for a near-simultaneous chord.
- R8 [ALLOWED] Chords may be strummed high → low, or alternately up/down on repeated chords: mark direction
  arrows before each chord, or *quasi chitarra* / *a la chitarra*.
- R9 [AVOID] Long, fast pizzicato passages with no rests. *Why:* very tiring. Relieve with occasional rests and
  by alternating the line between Vn1 and Vn2, or violas and cellos (some players alternate index and middle
  fingers).
- R10 [ALLOWED] To make pizz ring as long as possible, write tie-like slurs into nothing and *l.v.* / "let vibrate"
  / *vib.* (*dejar vibrar*). Pizzicato otherwise decays quickly, like staccato/spiccato.
- R11 [ALLOWED] Bartók and nail pizz signs may appear with or without *pizz.*; the sign implies it.

**Examples**
- Ex 2-55 Brahms, Sym. 1 iv m.1–17 (Adagio, C minor): bowed *fp* swells, then a pizzicato passage for all strings
  that accelerates (*stringendo poco a poco*) and crescendos, an *ff* arco chord at m.12, then back to *p* pizz —
  model of planned pizz/arco switches with rests between.
- Ex 2-56: left-hand pizz on the E string: B played spiccato with the bow, then fingers 4-3-2-1 pluck A, G, F and
  open E in turn (descending scale on one string).
- Ex 2-57 Bartók, String Quartet 5 iii m.54–56 (Alla bulgarese, 4+2+3/8): Vn1 bowed melody with single
  left-hand pizz notes inserted; Vn2/Va/Vc sustained.
- Ex 2-58 Bartók, String Quartet 4 iv m.56–63 (Allegretto, 3/4, all-pizz movement): Vn1/Vn2 snap pizz *sf*
  accents within a line; viola and cello strummed pizz chords (arpeggio signs) as guitar-like accompaniment.
- Ex 2-59: pizz chord written as block = played as fast low→high grace-note roll.
- Ex 2-60 Bartók, Concerto for Orchestra v m.5–9 (accel. to Presto 𝅗𝅥=c.134–146): violas and cellos "put the bow
  aside", pizz chords with alternating up/down arrows, *sempre sim.*, *f dim.* to *pp*; basses single pizz; then
  Vn2 enters bowed *punta d'arco* *pp*.
- Ex 2-61 Tchaikovsky, Sym. 4 iii m.1–17 (Allegro, 2/4, F major, *pizzicato sempre*): all strings pizz, scalar
  sixteenth/eighth lines with periodic rests and hand-offs between sections — model of a sustainable long pizz
  movement.
- Ex 2-62 Diamond, Sym. 4 ii m.1 (Adagio ♩=60): all strings *pizz. vib.* *ff* accented — ringing pizz.
- Other pizz pointers: Britten *Simple Symphony* (Playful Pizzicato); Foote *Suite for Strings in E*; Debussy
  *Ibéria* part 3.

**Agent applicability**
- Pizz parts: leave ≥ 1 beat (inferred; book says "time to prepare") between arco and pizz notes on the same
  track; more for pizz → arco. Put pizz on its own keyswitch/patch.
- For long pizz ostinatos, split the line between two sections (Vn1/Vn2 or Va/Vc) and insert rests.
- Pizz chords: roll 3–4 notes low→high with ~10–30 ms offsets (inferred) unless *non arpegg.*; for guitar-like
  strums alternate roll direction.
- Bass pizz sustains longest; short pizz on violins decays fast: use *l.v.* style longer note-offs only where the
  patch rings.

**Tags:** #orchestration/strings #articulation/pizzicato #articulation/bartok-pizz #articulation/left-hand-pizz

## 2 Mutes (Las sordinas) (scan p.56–57, printed p.39–40)

**Concepts**
- mute (con sordino (It.) / avec sourdine (Fr.) / mit Dämpfer (Ger.) / mutes (Eng.)): a small wood, plastic or
  metal device on the bridge absorbs vibration; sound becomes very soft and thin, and the tone quality changes
  radically. All strings can be muted.
- senza sordino / sans sourdine / ohne Dämpfer: remove mutes.

**Rules**
- R1 [PREFER] Muted strings are mostly soft, but *f* / *ff* muted passages are allowed: loud muted strings sound
  restrained, more constricted and tense.
- R2 [MUST] Give enough time to put on or take off mutes silently. Slide-on mutes (kept behind the bridge) are
  quick; old detachable mutes need much more time (place, remove, store).
- R3 [PREFER] Schedule mute changes where the section has rests while others cover, especially in soft passages.

**Examples**
- Ex 2-63 Weber, *Oberon* Overture m.13–21 (Adagio, D major): Vn1/Vn2 *con sordino* with fast ornamental
  figures, violas and cellos *pizz.* then *arco*; at m.16ff the violins drop out to remove mutes (*senza
  sordino*) while violas and divided cellos hold soft sustained notes; basses tacet.

**Agent applicability**
- Muted strings = "con sordino" patch; don't switch a track between muted and open patches without ≥ 1–2 bars
  of rest (inferred from "enough time").

**Tags:** #orchestration/strings #articulation/con-sordino

## 2 Scordatura (scan p.57–58, printed p.40–41)

**Concepts**
- scordatura ("mis-tuning"): retuning one or more open strings, up or down, for colour or practical reasons.
  Used since the 17th century: to ease hard passages in remote keys, to get unusual chords, to change tone colour.
- accord / accordatura: return to normal tuning.

**Rules**
- R1 [MUST] State the tuning of all four strings in score and part, at the start or where the retuning occurs.
- R2 [MUST] Allow enough time after the scordatura passage to retune; mark the return *accord*/*accordatura*.
- R3 [ALLOWED] Today scordatura is used mostly for colour [era: modern]; formerly mainly to ease difficult keys
  [era: Classical, 18th c.].
- R4 [ALLOWED] Raising string tension (tuning up) makes the instrument brighter; raising all four strings by a
  whole tone also strains the tone and reduces its nobility ("cheap fiddle" effect).

**Examples**
- Ex 2-64 Saint-Saëns, *Danse macabre* m.25–32: solo violin E string lowered to E♭ (G3–D4–A4–E♭5), so the open
  A–E♭ tritone sounds as Death tuning his fiddle; *f*, 3/4, open-string double stops.
- Ex 2-65 Mahler, Sym. 4 ii m.6–18: solo violin tuned up a whole tone (A3–E4–B4–F♯5 shown) for a coarse
  "fiddler" colour; the part is written in a transposed key. Book footnote says the notes sound "a minor second
  lower than written", which contradicts the whole-tone-up tuning in the text [?] (translation/print error likely;
  with strings a whole tone up, it should sound a major second higher than written — inferred).
- Ex 2-66 Stravinsky, *Rite of Spring* last bar: cellos lower the A string a semitone to G♯ ("descendez le la un
  demi-ton") to play the final *sfff* *non arpeggiato* chord, unplayable otherwise.
- Mozart, *Sinfonia concertante* K.364 [era: Classical]: solo viola retuned up and written in D major while the
  orchestra is in E♭ [the Spanish text names the tuning "RE, LA, MI, SI" and key "MI Mayor"; flats appear to be
  dropped in translation — historically the viola is tuned up a semitone, D♭–A♭–E♭–B♭, sounding E♭ major
  (inferred)]. Added tension also makes the viola much more brilliant.

**Agent applicability**
- In MIDI, scordatura only matters for range and open-string chords: a retuned lowest string extends the range
  (cello A→G♯ allows chords impossible in normal tuning); keep the instrument's normal low limit otherwise.
- For a period/"devilish fiddle" effect, write open-string tritone double stops (e.g. A4+E♭5) for solo violin.

**Tags:** #orchestration/strings #technique/scordatura

## 2 Harmonics (Armónicos) — natural harmonics (scan p.58–62, printed p.41–45)

**Concepts**
- harmonics (armonici / harmoniques / Flageolett(töne) / harmonics): tones produced by lightly touching the string
  at a node instead of pressing it down. Two kinds: natural (on open strings) and artificial (on stopped notes).
- node (*nodo*): rest point between vibrating segments. Pressing the same point firmly gives the same pitch but
  a different timbre.
- Every string tone = fundamental (1st partial) + higher partials; touching at a node suppresses the fundamental
  and isolates a partial. Touching at 1/2 of the string → octave (2:1); bowing on either side of the node gives
  the same result.

**Rules**
- R1 [PREFER] Use partials 1–6 on violin: they are the strongest and easiest.
- R2 [ALLOWED] Partials up to the 7th–8th are fairly easy on viola, cello and bass (longer, thicker strings); the
  book's chart lists partials 6–10 for the double bass.
- R3 Node positions (fractions of string length from nut or bridge):
  - 2nd partial (octave, +12): touch at 1/2.
  - 3rd partial (octave + 5th, +19): at 1/3 or 2/3.
  - 4th partial (two octaves, +24): at 1/4 or 3/4.
  - 5th partial (two octaves + M3, +28): at 1/5, 2/5, 3/5 or 4/5 from the nut.
- R4 [AVOID] in orchestra the 5th-partial node at 2/5 from the nut (= 3/5 from bridge); only 1/5, 3/5 and 4/5
  from the nut are safe orchestrally. The 2/5 node is mainly for solo/chamber music.
- R5 [MUST] Specify the string for a natural harmonic (*sul G* / *sul SOL*, or Roman numeral), since the same
  pitch can come from more than one string (e.g. violin D5 as 3rd partial on G or 2nd partial on D).
- R6 String numbering (I = highest): violin I E, II A, III D, IV G; viola I A, II D, III G, IV C; cello I A,
  II D, III G, IV C; double bass I G, II D, III A, IV E.
- R7 Notation (natural): (1) small circle over the note that should sound, or (2) diamond notehead at the
  pitch where the node lies on the string.

**Examples** (natural harmonics on the lowest string, sounding pitch; bass converted from written by me)
- 2nd partial: violin sul G → G4 (67); viola sul C → C4 (60); cello sul C → C3 (48); bass sul E → E2 (40).
- 3rd partial: violin → D5 (74); viola → G4 (67); cello → G3 (55); bass → B2 (47).
- 4th partial: violin → G5 (79); viola → C5 (72); cello → C4 (60); bass → E3 (52).
- 5th partial: violin → B5 (83); viola → E5 (76); cello → E4 (64); bass → G♯3 (56).
- General formula: partial n sounds open-string MIDI + {12, 19, 24, 28, 31, 34, 36, 38, 40} for n = 2…10
  (6th = +31, 7th ≈ +34 (flat, inferred), 8th = +36, 9th = +38, 10th = +40). Ex 2-67 shows the harmonic series on
  G3 up to the 16th partial.
- Quick-reference chart (scan p.61–62, printed p.44–45): for every open string of violin, viola, cello (partials
  2–5) and bass (2–10), shows both notations (circle over the sounding note, or diamond at the touch point over
  the stopped "fingered" note). Do not transcribe; derive from the formula above.

**Agent applicability**
- To write natural harmonics in MIDI, compute sounding pitch = open string + interval above; stay within partials
  2–5 for orchestral violins/violas (2–6/7 for cello/bass); prefer 2nd and 4th partial (octave/two octaves) as the
  most secure.
- Harmonics are soft, flute-like and pure: use a "harmonics" patch at *p*–*mp*; don't expect them to carry over a
  tutti (inferred from "do not project" for high artificial ones).

**Tags:** #orchestration/strings #technique/harmonics #range/strings

## 2 Artificial harmonics (scan p.63–64, printed p.46–47)

**Concepts**
- artificial harmonics (*armónicos artificiales*): same flute-like silvery sound as natural ones, but on a stopped
  note. Most practical method: stop a note and lightly touch the node a perfect 4th (5 semitones) above → sounds
  two octaves (+24) above the stopped note.
- Violin/viola: stop with 1st finger, touch the 4th above with 4th finger. Cello: stop with the thumb, touch the
  4th above with 3rd or 4th finger.

**Rules**
- R1 [PREFER] In orchestral writing use only the "touch a 4th above" artificial harmonic (sounds +24 over the
  stopped note). (Other methods for solo/chamber violin and viola are deferred to ch.3.)
- R2 [AVOID] Artificial harmonics on the double bass: the stretch is so wide they can hardly be played cleanly;
  some contemporary composers ask for them in solo music only.
- R3 Notation, three ways: (1) normal stopped note + diamond a 4th above; (2) the same plus the intended sounding
  pitch in parentheses above; (3) small circle over the sounding pitch only.
- R4 [AVOID] Notation (3) alone: it is risky, because the orchestrator (not the player) is responsible for
  showing how the harmonic is produced (Ex 2-75: a cello circle-only harmonic "should be written" as stopped note
  + diamond a 4th above).
- R5 [AVOID] Artificial harmonics above the practical ceiling of Ex 2-76: higher ones are insecure and often do
  not project. Practical highest (read from the example, uncertain): violin stopped C6 + touch F6 → sounds C8
  (~108) [?]; viola stopped ~C5 + touch F5 → sounds ~C7 (~96) [?]; cello stopped ~F4 + touch B♭4 → sounds ~F6
  (~89) [?].

**Examples** — representative repertoire (Pasajes representativos)
- Ex 2-77 Debussy, *Ibéria* part 1 at [15] (♪=160, 3/8): Vn1 *p* line in artificial harmonics (diamond notation),
  chromatic descending figure — eerie, glassy melody.
- Ex 2-78 Saint-Saëns, Violin Concerto (No. 3) ii, final 13 bars (Andante, 6/8): solo violin melody, then a long
  passage of artificial harmonics (stopped note + diamond) in arpeggiated sixteenths, ending on a held harmonic —
  the classic shimmering close.
- Ex 2-79 Borodin, String Quartet 1 iii trio m.1–20 (Moderato ♩=92, 2/4, A major): cello melody entirely in natural
  harmonics, *pp* then *dolce* solo, with string indications "Flag. sul D … sul A … G-D-A-D" (8va shown); later Vn1
  takes over the harmonic melody *p dolce*; Vn2 muted running sixteenths *dolce*, viola muted sustained notes.
  Demonstrates a full melody in natural harmonics by switching strings note by note.
- Study pointer: Barber *Medea* Dance of Vengeance at [31]; Berg *Wozzeck* I/2 just before [230] and II/5 one bar
  before [380]; Copland Sym. 3 ii m.100–106 (Vn1; see also Ex 3-1); Ravel *Shéhérazade* 3 bars after [5];
  Rimsky-Korsakov *Scheherazade* ii Scherzando vivace; Schoenberg Violin Concerto i m.212–225 (solo part);
  Webern *Six Pieces* op.6 no.5 (see Ex 3-19); Webern *Five Pieces* op.10 ii.

**Agent applicability**
- For a harmonic melody, sounding MIDI = stopped note + 24; check the stopped note is in normal range and the
  sounding note ≤ the ceilings in R5. No double-bass artificial harmonics.
- Accompany harmonic melodies very lightly (muted strings, *pp*) as in the Borodin trio.

**Tags:** #orchestration/strings #technique/harmonics #articulation/artificial-harmonics

## 2 Contemporary string techniques (Técnicas contemporáneas para las cuerdas) (scan p.66–67, printed p.49–50)

**Concepts / list** (era: post-1960 avant-garde practice, "the last forty years" from the book's viewpoint)
1. Bowing behind the bridge (on the tailpiece side, between bridge and tailpiece): on 4, 3, 2 or 1 strings
   (special arrow-like signs with 4/3/2/1 strokes). Col legno behind the bridge also possible.
2. Bowing the tailpiece with the hair, or striking it with the wood (mark *battute* before the passage if struck
   with the wood).
3. Knocking, tapping or drumming on the instrument body with fingers or knuckles (x-noteheads; explain in a
   footnote on the first page of the score).
4. Very wide vibrato (shown with a wavy line above the note).
5. Subharmonics (*subarmónicos* / *armónicos inferiores*): bowing at a harmonic node with heavy pressure to get
   pitches below the open string.
6. Highest possible note on a given string (e.g. *sul G*), or, with no string named, the instrument's highest note
   (arrow-head notehead sign).
7. Fingering a passage without bowing (e.g. Foss, *Cycle Time* ii, 1 bar before [95]): faint, ghostly, nearly
   inaudible pitches plus finger-tap noise.
8. Pizzicato with plectrum (picks) or hair combs.
9. Half-harmonics: touching the string lightly away from nodes, or more firmly than usual at a node; sounds a
   bit like sul tasto.
10. Bowing near the nut, on the "wrong" side of the left hand (between nut and fingers), giving a viola-like sound;
    fingering must be inverted; typical of George Crumb (*Black Angels*, amplified string quartet; Crumb even has
    the start pitch chalk-marked on the fingerboard).

**Rules**
- R1 [AVOID] Bass harmonics once thought impossible now appear in solo/chamber repertoire, but should not be used
  in orchestral writing.
- R2 [AVOID] Technique 10 (bowing on the nut side) in orchestral music: few players can produce it.
- R3 [MUST] Whenever any of these techniques is used, give a verbal description of the desired sound and the exact
  technique in the score. Adler recommends the notation conventions of Kurt Stone, *Music Notation in the
  Twentieth Century*; further reading: Cope *New Directions in Music*, Read *Contemporary Instrumental
  Techniques*. (Ex 5-32a, printed p.149, is cited as a model notation key in an orchestral score.)

**Agent applicability**
- Most of these have no reliable MIDI rendering; use them only with a library that has dedicated "FX"/"aleatoric"
  string patches, and only in film/contemporary styles [era: post-1960].

**Tags:** #orchestration/strings #technique/extended #era/20th-century
