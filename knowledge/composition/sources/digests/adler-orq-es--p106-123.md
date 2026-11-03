---
source_id: adler-orq-es
source_title: Samuel Adler, El estudio de la orquestación (Spanish translation of the 3rd ed., Idea Books; original 2002)
source_era: "2002 (3rd ed.); late-20th-c. American/international orchestral practice, with historical notes on earlier periods"
scan_pages: 106-123
printed_pages: 91, 94-110
missing_printed_pages: [92, 93]
chapters: ["4 Instrumentos de cuerda punteados — El arpa (pedals, chords, harmonics, effects)", "4 — La guitarra (p.101)", "4 — La mandolina (p.103)", "4 — El banjo (p.106)", "4 — La cítara (p.108)"]
continues_from: "4 Instrumentos de cuerda punteados — El arpa (range starts at 'Colocación de los pedales')"
continues_into: null
---

# Adler, El estudio de la orquestación — scans 106–123 (harp end, guitar, mandolin, banjo, zither)

Pitch convention: C4 = middle C = MIDI 60. The book's Spanish octave names (e.g. "LA2", "FA5", "MI5") match this
convention (checked against the staff positions). MIDI numbers are my conversion. Scan p0106 = printed p.91, scan
p0107 = printed p.94: printed pp.92–93 are missing from the scan (they probably held more harp glissando/arpeggio
material and Ex. 4-3 to 4-6 [?]). Printed p.98 (scan p0111) has its header cropped but the sequence is continuous.

## 4 El arpa — pedal layout (Colocación de los pedales) (scan p.106, printed p.91)

**Concepts**
- Pedal order, left to right: left foot D C B | right foot E F G A. (The scan prints the header as "DO RE SI", but all of
  the book's own pedal examples list Re–Do–Si on the left; the real harp order is D C B — treat "DO RE SI" as a typo,
  inferred.)
- Each pedal has three notches (posiciones): top = flat, middle = natural, bottom = sharp. The top notch is the
  "all flats" setting.
- Pedal-setting notation (three ways, harpists prefer the first two):
  1. Letters: e.g. "Db C# Bb / E♮ Fb G# A#" (left group / right group).
  2. Pedal diagram (diagrama): a horizontal line with a vertical bar separating the feet; a tick above the line =
     flat, on the line = natural, below = sharp. Pitch names are not written in the score, only the ticks.
  3. Alternating letters, numbered from the inside out (E = pedal 1 right, B = pedal 1 left). Less common, less clear.

**Rules**
- R1 [NEVER] Ask for two simultaneous pedal changes on the same foot (e.g. E and G together, both right foot).
  *Why:* one foot moves one pedal at a time.
- R2 [ALLOWED] Two simultaneous changes on different feet (e.g. D and G).
- R3 [PREFER] Give the full pedal setting just before the start of a passage.
- R4 [ALLOWED] Enharmonic tuning (afinación enarmónica) to collapse the 7 string names onto fewer pitches: A# = Bb,
  C# = Db, E♮ = Fb, G# = Ab. With the setting Db C# Bb / E♮ Fb G# A# the harp sounds only four pitch classes
  (Bb, Db, Fb, Ab = a Bb half-diminished seventh) and any glissando produces that chord.

**Examples**
- Debussy, *Prélude à l'après-midi d'un faune*, bar 4 (Ex. 4-2): the famous opening glissando with exactly that
  enharmonic setting; LH gliss upward from the bass, up to a high top note and back down (Très modéré).

**Agent applicability**
- For a harp gliss, generate the MIDI run from the 7-string pedal set (one pitch per string name per octave);
  duplicated pitches from enharmonic strings repeat in MIDI.
- When planning chromatic harp writing, check that consecutive pedal changes alternate feet.

**Tags:** #orchestration/harp #orchestration/harp/pedals #orchestration/harp/glissando

## 4 El arpa — passage redistribution (scan p.107, printed p.94; example begins on missing pages)

**Examples**
- Ex. [4-7?] (title on a missing page, composer unknown [?]): a. a piano-like D-major passage of 16th-note broken
  chords in both hands, ending with rolled chords and *riten.*; b. "Cómo se interpreta" (how it is played) — the harpist
  re-splits the figuration into falling 3-note groups alternating between hands (A major, 3/4), each hand
  re-placing for the next group. Shows that fast piano figuration gets redistributed between the hands.

**Agent applicability**
- For fast harp figuration, write groups of ≤ 4 notes per hand alternating hands rather than continuous one-hand
  scales (inferred from the example).

**Tags:** #orchestration/harp #orchestration/idiomatic-writing

## 4 El arpa — chords (Acordes) (scan p.107–110, printed p.94–97)

**Concepts**
- Chord (acorde) may be rolled (arpegiado) or struck together (plaqué / en bloque).
- Wavy line (línea ondulada) before a chord: a slower, more expressive roll; arrows on the line give direction (up or
  down). Bracket ([) before the chord: play without rolling (plaqué).

**Rules**
- R5 [MUST] Use at most 4 notes per hand, 8 in total. *Why:* the harpist plays with the first four fingers; the little
  finger is never used.
- R6 [PREFER] 3- and 4-note chords in each hand give a very full sound.
- R7 [ALLOWED] Tenths (16 semitones) within one hand are fairly easy. *Why:* an octave on the harp is a much smaller
  span than on the piano.
- R8 [MUST] Assume every harp chord is rolled bottom-to-top unless marked with the plaqué bracket. *Why:* traditional
  practice; with no arrowhead on a wavy line the roll goes upward.
- R9 [PREFER] Mark a wavy line in slow passages when you want a deliberate expressive roll.
- R10 [ALLOWED] Even chords written plain (no roll marking) are at least slightly rolled in performance; at fast tempo
  harpists use a quick roll on each chord.
- R11 [PREFER] Final/plaqué chords in slow, soft music are rolled even without a sign; playing them dead-together would
  sound too abrupt.

**Examples**
- Ex. 4-8 "Acordes para el arpa" (Maestoso, C major-ish, with pedal diagram): idiomatic spacing — RH 2–4-note
  close chords in the treble, LH open octaves and wide 3-note chords in the bass, wavy-line rolls on sustained chords.
- Bartók, *Violin Concerto* [No. 2], 1st mvt, bars 1–13 (Ex. 4-9): harp *p* quarter-note repeated block chords, 3–4
  notes per hand, written unrolled but in practice lightly and quickly rolled at Allegro non troppo.
- Brahms, *Ein deutsches Requiem*, 1st mvt, bars 150–158 (Ex. 4-10): harp *f* upward arpeggio sweeps through
  both hands, then *p* off-beat chords together with string pizzicato under the choir, ending on a long rolled
  chord with fermata; the plaqué chords here are traditionally rolled.
- Debussy, *Faune*, bars 79–81 (Ex. 4-11): Flute 1 *p doux et expressif* melody over Harp 1 *pp* continuous
  rising broken-chord arpeggios (16th-note groups) shared between the hands across ~3 octaves, E major. Shows the
  classic flute + harp-arpeggio combination.

**Agent applicability**
- Cap harp MIDI chords at 4 notes per hand (split at around middle C between staves) and 8 total.
- Render rolled chords by offsetting note starts bottom-up (a few ms to tens of ms per note; slower for wavy-line
  rolls) — offsets are inferred, the book gives no timing.
- Harp under a woodwind solo: continuous soft arpeggios spanning both hands, *pp* under a *p* solo.

**Tags:** #orchestration/harp/chords #orchestration/harp/arpeggio #orchestration/combinations/flute-harp

## 4 El arpa — harmonics (Armónicos) (scan p.111–112, printed p.98–99)

**Concepts**
- Harp harmonic (armónico): sounds one octave above the string's normal pitch; bell-like. Two methods: (1) lower palm of
  the left hand touches the node at the string's midpoint, left thumb plucks; (2) outside of the right index-finger
  knuckle touches the node, right thumb plucks.
- Notation: small circle (0) over the note, sounding an octave higher than written. Some composers write the sounding
  pitch with a circle — confusing unless explained in the score's notes.

**Rules**
- R12 [MUST] Right hand: only one harmonic at a time.
- R13 [ALLOWED] Left hand: 2 or 3 simultaneous harmonics, but all of them must be from the same pedal kind (all sharps,
  all flats or all naturals) [as stated; the reason is not given].
- R14 [PREFER] Write harmonics in the notated range A2 (45) – F5 (77); above and below, they are hard and unreliable.
  (This range is in written pitch; the sound is an octave higher, so roughly 57–89, inferred.)
- R15 [MUST] Accompany harp harmonics very lightly or not at all. *Why:* they are very soft.
- R16 [ALLOWED] Mix harmonics with ordinary notes in the same texture (Salzedo example).

**Examples**
- Debussy, *Nocturnes*, "Nuages", bars 74–78 (Ex. 4-12): harp melody in normal notes, then the same kind of figure
  answered in LH harmonics in the bass clef (B major area); solo texture.
- Ravel, *Daphnis et Chloé* suite, "Nocturne", bars 49–53 (Ex. 4-13): Harp 1 plays a melody in harmonics in the
  bass-clef register (sounding an octave higher), while Harp 2 gives a soft *pp* bass ostinato — two harps divide
  melody and support.
- Salzedo, *Modern Study* "On the doubling of notes", opening (Ex. 4-14): *clair*, ♩=44; RH melody with harmonics
  and LH 2–3-note harmonic chords plus ordinary bass notes; pedal changes C#–D♮–C# marked under the staff.

**Agent applicability**
- To simulate a harp harmonic in MIDI, play the sounding pitch (written + 12) at low velocity on a harp patch with a
  harmonic articulation if available; keep the surrounding orchestra thin.
- Limit harmonic chords to ≤ 3 notes and only in the left-hand (lower) part.

**Tags:** #orchestration/harp/harmonics #orchestration/balance

## 4 El arpa — special effects (Efectos especiales) (scan p.112–114, printed p.99–101)

**Concepts**
- The harp works as melodic instrument, accompaniment, or for doubling other voices; it also has many timbral
  effects.
- *Près de la table* (Fr.): pluck near the soundboard → hard, tense, almost metallic sound.
- *Sons étouffés* (Fr.): every note is damped right after plucking; like a *pizzicato secco* in the strings.
- Glissando: the harp's best-known sound.
- Bisbigliando (It., "whispering"): a very soft, quick alternation of the hands on chord notes, a whispered tremolo.

**Rules**
- R17 [MUST] For *sons étouffés*, keep the passage slow enough for the whole hand to damp the string(s) between notes.
- R18 [ALLOWED] Pluck with the fingernail for an even more metallic *étouffé*.
- R19 [AVOID] Using glissandos too often only to show off the harp.
- R20 [MUST] For every glissando, give the pedal setting (string tuning) plus the starting and ending notes.
- R21 [ALLOWED] Multiple glissandos: chord shapes (several fingers) glissed together; two-note gliss in the LH (e.g.
  Bb–Eb shape) (Ex. 4-18).
- Trills (trinos), three methods:
  - R22 [ALLOWED] Two fingers of one hand — cannot be very fast.
  - R23 [ALLOWED] One string alternated by both hands — not always easy or even.
  - R24 [PREFER] Tune two strings to the same pitch (enharmonic) and alternate the hands — the most effective and most
    common method (Ex. 4-19b: RH and LH alternate 16ths on the same sounding pitch).
- R25 [ALLOWED] Ordinary tremolo: both hands alternate on the strings.
- R26 [PREFER] Bisbigliando very soft (*ppp* in Ex. 4-20, 2–3-note chords in each hand, slurred over many bars).
- Newer effects (20th c.; see K. Stone, *Music Notation in the Twentieth Century*, 1980, pp. 228–256):
  - R27 [ALLOWED] Knock on the soundboard (golpear en la caja de resonancia).
  - R28 [ALLOWED] Pull the strings with the fingernails.
  - R29 [ALLOWED] Pluck with a plectrum or pick.
  - R30 [ALLOWED] Harmonics other than the octave harmonic.
  - R31 [ALLOWED] Buzzing/sliding string: pluck, then move its pedal up or down (pitch bend).
- R32 [MUST] Notate unusual effects clearly; when unsure if a technique is feasible, check with a professional harpist.

**Examples**
- Britten, *Four Sea Interludes* (*Peter Grimes*), "Storm", bars 112–116 (Ex. 4-15): harp *ppp près de la table*,
  repeated 8th-note chords in both treble staves (Bb/Ab LH, chromatic RH dyads), then pedal reset to D major for a *pp*
  glissando. Shows the metallic, nervous colour.
- Ex. 4-16 (no composer): a few scattered *sons étouffés* notes and a final chord, with rests between each.
- Ex. 4-17: glissando with pedal set C# D# E F# G# A# B (B major) from a low G#/A [?] up to a high note and back.

**Agent applicability**
- Gliss in MIDI: fast run (e.g. 30–60 notes/s, inferred) through the pedal-set scale between named start and end notes;
  never chromatic.
- Harp trill: alternate the two pitches in 16ths/32nds with slightly irregular timing; for an enharmonic "same-pitch"
  trill, repeat one pitch quickly (two strings).
- Bisbigliando: soft (velocity ~20–35, inferred) fast irregular repeated 2–3-note chords.

**Pointer:** further study passages listed on printed p.101 — Dukas *L'apprenti sorcier* (opening harmonics), Falla
*Three-Cornered Hat*, Foss Symphony 3, Ginastera & Henze harp concertos, Hindemith, Ravel *Introduction et Allegro*,
Stravinsky *Firebird* (1919) "Berceuse" (harmonics), Varèse *Amériques* (soundboard knocks), Zwilich *Symbolon*;
also Tchaikovsky *Nutcracker* Act II pas de deux (two harps).

**Tags:** #orchestration/harp/effects #orchestration/extended-techniques

## 4 La guitarra (scan p.114–116, printed p.101–103)

**Concepts**
- Guitar (guitarra; chitarra It., guitare Fr., Gitarre Ger.). Many types (Spanish, Hawaiian, electric, acoustic);
  the book covers the classical guitar, which is the one used in the orchestra whenever a guitarist is called for
  unless the composer specifies otherwise.
- Tuning comes from the old lute tunings; irregular intervals between the six strings. Written: E3 A3 D4 G4 B4 E5;
  sounding an octave lower: E2 (40), A2 (45), D3 (50), G3 (55), B3 (59), E4 (64).
- Transposition: written in treble clef, sounds one octave lower (all notes).
- Register (Ex. 4-22): written E3 – E6 [? top note read as on the 3rd ledger line] = sounding E2 (40) – E5 (76).
- Technique: LH frets with four fingers; RH plucks with all five fingers; frets make pitch-finding easy.

**Rules**
- R33 [ALLOWED] Single-line melodies, chords, and melody with accompaniment are all idiomatic.
- R34 [ALLOWED] Harmonics, especially natural ones, are very effective…
- R35 [MUST] …but an unamplified guitar has little volume and its harmonics can be nearly inaudible: use the guitar in
  solos or in very small combinations with soft strings and winds, or with voice.

**Examples**
- Stravinsky, *Tango*, bars 1–6 (Ex. 4-23; score in C, guitar written at sounding pitch in bass clef here): guitar *p*
  plays 3–4-note chords in a dry 8th-note tango rhythm, in a small ensemble of 4 clarinets, bass clarinet, trumpets
  and trombones (*non stacc.*); the brass and clarinets keep to sparse rhythmic chords so the guitar stays audible.
- Repertoire with guitar parts: Rossini *Il barbiere di Siviglia* (Act I cavatina), Weber *Oberon*, Thomson *The Plow
  That Broke the Plains* (also banjo), Boulez *Le marteau sans maître*, Penderecki *The Devils of Loudun* (bass
  guitar). `[era: guitar in early-19th-c. opera serenades]` for Rossini/Weber.

**Agent applicability**
- MIDI is concert pitch: keep classical guitar notes in 40–76 (book's limit), write the part an octave higher only in
  notation.
- For string assignment, open strings are 40/45/50/55/59/64 (see AGENTS.md: `chan` 0–5 = strings 1–6).
- Thin the orchestra around an acoustic guitar: soft winds/strings, few simultaneous parts.

**Pointer:** further passages on printed p.103 — Berg *Wozzeck* II (waltz), Corigliano *Troubadours*, Gould *Pop's
Serenade*, Grainger *Willow Willow*, Harbison and Lennon guitar concertos, Maxwell Davies *The Blind Fiddler*,
Rossini *Barbiere*, Schoenberg *Serenade* op. 24, Stravinsky *Tango*, Takemitsu *To the Edge of Dream*, Webern op. 10
nos. 3 and 5.

**Tags:** #orchestration/plucked/guitar #orchestration/balance

## 4 La mandolina (scan p.116–119, printed p.103–106)

**Concepts**
- Mandolin (mandolina; mandolino It., mandoline Fr./Ger.): eight strings in four pairs (cuerdas afinadas por pares),
  tuned like the violin: G3 (55), D4 (62), A4 (69), E5 (76). Non-transposing (inferred: no transposition is given).
- Register (Ex. 4-25): G3 (55) – A6 (93).
- Single notes and double stops are plucked with a plectrum (púa); sustained notes are made by tremolo, either on the
  same note on the paired strings or on two different notes on neighbouring strings. Fretted.

**Rules**
- R36 [MUST] Render held mandolin notes as tremolo (fast repeated plucks); there is no true sustain.
- R37 [PREFER] Use it solo or with light accompaniment — muted strings or soft winds. *Why:* a quiet instrument.
- R38 [ALLOWED] `[era: Classical, Grétry/Mozart]` Occasional use in opera/orchestra as serenade accompaniment.
- R39 [ALLOWED] `[era: late 19th–20th c.]` Revival as an orchestral colour: Verdi *Otello*, Mahler Symphony 7,
  Schoenberg *Serenade*, Respighi *Feste romane*, Stravinsky *Agon*, Crumb *Ancient Voices of Children*.

**Examples**
- Mozart, *Don Giovanni* Act II, "Deh vieni alla finestra", bars 1–10 (Ex. 4-26): mandolin obbligato of running
  16th-note arpeggio/scale figures in D major over pizzicato strings (vln 1 off-beat dyads, vln 2/vla/vc+db on the
  beat), 6/8 Allegretto; the baritone enters later. Shows the serenade texture: mandolin figuration + all-pizz strings.
- Crumb, *Echoes of Time and the River*, 4th mvt, bars 8–9 (Ex. 4-27): offstage mandolin *ppp* "delicate, fragile"
  tremolo line, then *senza trem.*, with piano strings plucked by fingertips *pppp*. "A distant music" effect.

**Agent applicability**
- Mandolin MIDI range 55–93. Long notes = 32nd-note (or faster) repeated notes with small velocity variation, or a
  tremolo articulation on the sample library.
- Pair a mandolin solo with pizzicato or muted strings at lower dynamics.

**Pointer:** further passages on printed p.106 — Respighi *Feste romane* III [24], Schoenberg *Serenade* op. 24 and
*Variations* op. 31 (bar 420 to end), Stravinsky *The Nightingale*, Webern *Das Augenlicht* (bars 8–9, 39–42),
Webern op. 10 nos. 3–5.

**Tags:** #orchestration/plucked/mandolin #orchestration/era/classical

## 4 El banjo (scan p.119–121, printed p.106–108)

**Concepts**
- Banjo: West African origin; brought to the USA by enslaved Africans; modern form reached by 1847 (Joe Sweeney):
  a closed tambourine-like resonator with parchment head and bridge, long neck. Played with or without a plectrum.
- Five-string tuning (bluegrass and minstrel bands; Ex. 4-28): C3 (48), G3 (55), B3 (59) or C4 (60) ("any of the
  tunings"), D4 (62), plus a short string G4 (67).
- Short high G string = thumb string (cuerda del dedo pulgar), attached to a peg partway up the neck; used as a drone
  (bordón) and similar effects. All other strings are fretted.
- Each string's range is a major ninth (14 semitones) above its open pitch; e.g. E5 (76) on the D4 string.
- Register (Ex. 4-29): shown as C3 (48) – A4 (69) [? the drawn top note is lower than the M9 rule implies for the D4
  string, E5 = 76].
- Tenor banjo (banjo tenor) sounds an octave lower than written.
- Four-string banjos exist; banjos with five or more full-length strings are often tuned quite differently; some
  pieces tune the banjo like a guitar.

**Rules**
- R40 [ALLOWED] `[era: 1920s–30s theatre orchestras and jazz bands]` Guitarists were expected to double mandolin and
  banjo, so tunings of the three were kept similar.
- R41 [AVOID] The banjo as a regular orchestral member; today it appears mainly in theatre orchestras and bluegrass
  imitations.
- R42 [MUST] Check balance: in Gershwin's *Rhapsody in Blue* [28]–[29] the banjo is barely heard over two horns.

**Examples**
- Gershwin, *Rhapsody in Blue*, [28]–[29] (Ex. 4-30): banjo *p* plays accented 3–4-note chords in a syncopated
  rhythm matching the horns' accented line (Hn 1–2 a2), while 3 saxes hold long chords; balance problem — the banjo
  hardly comes through.

**Agent applicability**
- Banjo MIDI: open strings 48/55/59/62 + drone 67; keep the comping rhythmic and chordal; don't put it against horns
  at the same register/dynamic if it must be heard.

**Pointer:** further passages on printed p.108 — Carpenter *Skyscrapers*, Delius *Koanga* ("La Calinda"),
Gershwin *Porgy and Bess* suite, Gould *Foster Gallery*, Harbison *The Great Gatsby*, Krenek *Kleine Symphonie* op. 51,
Thomson *The Plow That Broke the Plains*, Weill *Mahagonny*, Zinn *Ragtime Symphony*.

**Tags:** #orchestration/plucked/banjo #orchestration/era/jazz-age #orchestration/balance

## 4 La cítara (zither) (scan p.121–123, printed p.108–110)

**Concepts**
- Zither (cítara; cythare It./Fr., Zither Ger./Eng.): an ancient instrument, today used mainly for special colour (e.g.
  the main theme of the film *The Third Man*). Folk instrument of southern Germany and Austria; modern practical form
  only perfected at the end of the 19th c.
- Five melody strings (cuerdas melódicas) over a fretboard, carrying the top staff of the score. Two usual tunings
  (Ex. 4-31): A4 A4 D4 G3 C3 (69 69 62 55 48), or A4 D4 + two strings around G3 [?] + C3 [?].
- 24 accompaniment and bass strings (cuerdas de acompañamiento y bajos), open (unfretted): accompaniment set written as a
  cycle of fifths Ab–Eb–Bb–F–C–G–D–A–E–B–F#–C#–G# within about F#4–Ab5 (13 strings, Ex. 4-32); bass set written as
  another fifths cycle Eb–Bb–F–C–D[?]–A–E–B–F#–C#–G# within about F#3–G4 (11 strings, Ex. 4-33). All accompaniment
  and bass strings sound an octave lower than written.
- Playing: the instrument lies on a table or stand; the left hand stops the melody; the right thumb, with a plectrum,
  plucks the melody strings; the remaining four right-hand fingers pluck accompaniment and bass strings.

**Rules**
- R43 [ALLOWED] Every zither string may be retuned at the composer's discretion; the tunings above are the most usual.
- R44 [PREFER] `[era: 19th-c. Viennese]` Use the zither to evoke local Austrian/Bavarian colour (Johann Strauss).
- R45 [PREFER] Accompany the zither solo very lightly (muted strings, *p*).

**Examples**
- J. Strauss II, *Tales from the Vienna Woods* (*Geschichten aus dem Wienerwald*), bars 75–93 (Ex. 4-34): zither solo
  *p*, 3/4 Ländler tempo, G major: RH melody in thirds/sixths, LH oom-pah-pah (bass note + two offbeat chords);
  then only Vln 2, Vla and Vlc *con sord. div.* *p* add sustained notes and offbeat chords — no Vln 1, no winds.

**Agent applicability**
- Zither solo texture in MIDI: melody in 2-note parallel thirds/sixths (G4–G5 area), waltz/Ländler bass + chords from
  the open accompaniment strings an octave lower; accompany with a few muted strings only.

**Pointer:** further passages on printed p.110 — Foss *American Landscapes* (guitar concerto; opening harp–guitar
duet), Gubaidulina *The Book of Hours* (zither, electric guitar, guitar), Torke *Adjustable Wrench* (electric guitar),
Webern op. 10 (mandolin, guitar, harp).

**Tags:** #orchestration/plucked/zither #orchestration/era/romantic #orchestration/local-colour
