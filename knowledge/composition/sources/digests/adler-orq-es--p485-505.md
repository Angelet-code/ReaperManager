---
source_id: adler-orq-es
source_title: Samuel Adler, El estudio de la orquestación (Spanish translation of the 3rd ed., Idea Books; original 2002)
source_era: "2002 (3rd ed.); late-20th-c. American/international orchestral practice, with historical notes on earlier periods"
scan_pages: 485-505
printed_pages: 486-506
missing_printed_pages: []
chapters: ["14 Orquestación para percusión con teclado solo o en combinación (start): Distribución de la percusión en la partitura general (organización, asignación de ejecutantes, notación, ejemplos escritos), Organización de la sección de percusión, Usos de la sección de percusión: simulación de música de marcha y folclórica, refuerzo de la acentuación rítmica (start)"]
continues_from: null
continues_into: "14 — Refuerzo de la acentuación rítmica (Ex. 14-16 Copland, Appalachian Spring, begun on printed p.506)"
---

# Adler, El estudio de la orquestación — scans 485–505 (ch. 14 start: percussion score layout, notation, staging, Turkish/Spanish colour, rhythmic reinforcement)

Pitch convention: C4 = MIDI 60. Scan p.N = printed p.N+1 throughout; printed numbers are not visible on
scans 499 and 504 (printed 500, 505) but the sequence is continuous, so no printed page is missing. Chapter 14
opens on printed p.486. Full-score examples are too small for reliable note transcription; they are described by
what they demonstrate, with only rhythmic placements that are clearly legible.

## 14 Introduction (scan p.485, printed p.486)

**Concepts**
- Keyboard percussion (percusión con teclado / instrumentos de láminas): mallet instruments plus celesta, piano,
  harpsichord, organ; Adler treats them, with the harp, together with the percussion section because they are
  usually seated and scored with it.
- The chapter has two parts: (1) score organization and special notation for percussion and keyboards;
  (2) the percussion ensemble (keyboards included) combined with the other orchestral sections.

**Rules**
- R1 [AVOID] Using percussion to cover weak spots in the composition; overuse hides important musical detail.
  *Why:* the inexperienced orchestrator's typical abuse.
- R2 [AVOID] `ff` timpani doubled by bass drum (bombo) when anything else must be heard: per Piston (quoted),
  nothing else in the orchestra will be audible. *Why:* masking.
- R3 [AVOID] Loud bass drum strokes or cymbal rolls (redoble de platos) under a passage that must stay
  transparent: with the full brass section either can cover the whole orchestra, however loud the tutti.
- R4 [PREFER] Restraint: "the fewer, the better" (Bernard Rogers, *The Art of Orchestration*, 1951, quoted).
- R5 [MUST] Every percussion instrument used should be organic to the piece, as if no other instrument or group
  could replace it; the choice serves the musical idea.

**Agent applicability**
- Keep timpani + bass drum below `ff` velocity (inferred: ≤ ~100) whenever melody or harmony must read over them;
  reserve simultaneous `ff` timp + BD + cymbal roll for climax peaks.
- Before adding a percussion track, state what idea it serves; drop it if it only "fills".

**Tags:** #orchestration/percussion #orchestration/balance #orchestration/restraint

## Distribución de la percusión en la partitura general — Organización de los instrumentos (scan p.485–487, printed p.486–488)

**Concepts**
- Section size: a symphony orchestra has at least 3–4 percussionists, not counting the timpanist or the pianist;
  since few players cover many instruments, the score layout must be organized carefully and instantly legible.
- Score position: the percussion-and-keyboard block sits between brass and strings, timpani first.

**Rules**
- R6 [MUST] Score/track order: brass → timpani → unpitched percussion → mallets/keyboards → (strings).
- R7 [PREFER] Order unpitched percussion (percusión no afinada) by one or both criteria: (a) pitch, highest on top,
  lowest at the bottom; (b) material: metal, then wood, then membrane (skin).
- R8 [PREFER] Reference order for common unpitched instruments, directly below timpani: triangle (triángulo),
  sleigh bells (cascabeles), cymbals (platos), tam-tam, Chinese blocks (cajas chinas), temple blocks, tambourine
  (pandereta), snare drum (caja clara), tenor drum (tambor tenor), bass drum (bombo). (Adler notes that even this
  set rarely plays together in one orchestral work.)
- R9 [PREFER] Mallet/keyboard instruments come next, below timpani and unpitched percussion, high to low:
  glockenspiel, crotales (crótalos), xylophone (xilófono), vibraphone (vibráfono), marimba, chimes/tubular bells
  (campanófono), celesta, piano, harpsichord (clavecín), organ (órgano).
- R10 [PREFER] Harp(s) (arpa) go above all mallet instruments in a large work. Example set → order: timpani,
  harp, xylophone, celesta.
- R11 [PREFER] If unpitched percussion is also present: below timpani, above the harp (timp → unpitched → harp →
  mallets → keyboards). Note: Shostakovich Ex. 14-8 puts xylophone above harp — see Examples; both orders occur.

**Exceptions / conditions**
- Published scores do not always follow these guidelines (Mozart, Orff, Stravinsky examples below).
- Piano treated as soloist (Stravinsky *Les Noces*: four pianos) may sit above the timpani.

**Agent applicability**
- REAPER `PERCUSSION` folder child order: TIMP, then unpitched high→low (TRI, BELLS/SLEIGH, CYM, TAM-TAM, BLOCKS,
  TAMB, SNARE, TENOR DR, BD), then HARP, then GLOCK, CROT, XYL, VIB, MAR, CHIMES, CELESTA, PIANO, HPSCD, ORGAN.
  Keep the folder parent an empty bus (vault rule).

**Tags:** #orchestration/percussion #orchestration/score-order #workflow/track-layout

## Asignación de ejecutantes (scan p.487, printed p.488)

**Rules**
- R12 [ALLOWED] Which player gets which instruments matters little, except when (1) stage positions are fixed by
  the instrument set or the space allotted to the section, or (2) one player must play two instruments at once.
- R13 [MUST] For two instruments at once, either (a) one mallet (maza) in one hand and one stick (baqueta) in the
  other, or (b) the same beater type on both instruments.
- R14 [NEVER] Write a roll (redoble) for a player unless they hold suitable sticks in both hands at that moment.
- R15 [PREFER] Group instruments per player so two can be played simultaneously with one beater per hand. Model
  assignment for 3 players: P1 triangle, suspended cymbal with stick, snare; P2 tam-tam, tenor drum, bass drum;
  P3 sleigh bells, Chinese blocks, temple blocks, tambourine.

**Agent applicability**
- When writing a realistic part: per virtual "player", allow at most 2 simultaneous unpitched instruments, and
  no simultaneous roll + other note (two hands needed for the roll).

**Tags:** #orchestration/percussion #performance/percussion-players

## Notación (scan p.488–490, printed p.489–491)

**Concepts**
- Pitched percussion: five-line staff, treble or bass clef (as in ch. 12). Unpitched: many possible notations.

**Rules**
- R16 [MUST] Name every instrument clearly at the start of the score and in the percussion parts.
- R17 [MUST] With 3–4 players, check each can handle all assigned instruments and has time to reach the next
  instrument or group.
- R18 [ALLOWED] Single unpitched instrument (maracas, claves, tambourine): one-line staff, or one line/space of a
  five-line staff (Ex. 14-1: tambourine on a one-line staff, or military drum on a five-line staff, same rhythm, `f`).
- R19 [ALLOWED] One player with snare, tenor drum and bass drum (Ex. 14-2): separate staves (one- or five-line)
  per instrument, or all three on one five-line staff, each on its own line/space. [PREFER] the single combined
  staff — most percussionists' choice. In the separate-staff versions, tenor-drum stems may go up and down.
- R20 [MUST] If the three instruments of Ex. 14-2 are split among three players, the first two notations still
  work but the snare and tenor drum stems must be separated where they coincide (m. 5).
- R21 [ALLOWED] Several sizes of one instrument (3 Chinese blocks, 5 temple blocks, 3 timbales (pailas), 4
  cymbals): one-, two- or five-line staves. [PREFER] five-line staff for 4 or more sizes (Ex. 14-3: 4 cymbals,
  3 wood blocks, 5 temple blocks written both on one-line and on five-line staves).
- R22 [ALLOWED] Two adjacent instruments for one player on a single line, with written cues naming the next
  instrument (Ex. 14-4: triangle `pp` then "(Bombo)" … "Bombo" `sf` strokes). Saves space; useful with one
  percussionist or little percussion music.
- R23 [PREFER] In that single-line notation, bass-drum stems down and triangle stems up (Ex. 14-5; cf. Ex. 12-47).
- R24 [MUST] Leave time for beater changes when a player switches instruments. Triangle ↔ bass drum is fast
  (triangle beater in one hand, BD mallet in the other); triangle → snare needs time to put the beater down and
  pick up two snare sticks.
- R25 [MUST] Unpitched ↔ pitched on the same line by the same player (Ex. 14-6: 5 temple blocks ↔ xylophone, with
  "(Xil.)"/"Xil." and "(T. Bl.)"/"T. Bl." cues and a clef change): allow time to change sticks↔mallets, unless
  the score states both are played with xylophone mallets; then less time is needed and the player can set them up
  to play both almost simultaneously.

**Agent applicability**
- In MIDI, model a player switch as a gap: no note on the new instrument within (inferred) ~1 beat at moderate
  tempo after the last note on the old one when beaters must change (e.g. triangle → snare).
- On a single drum-sampler track, the combined five-line staff corresponds to one MIDI track with distinct keys per
  instrument; split tracks only when instruments belong to different virtual players.

**Tags:** #orchestration/percussion #notation/percussion #performance/percussion-players

## Ejemplos escritos de partes de percusión (scan p.490–493, printed p.491–494)

**Examples**
- Ex. 14-7, Mozart, *Die Entführung aus dem Serail* (El rapto en el serrallo), Overture, mm. 1–9 (Presto): the
  edition lists Turkish percussion as tamburo grande (bass drum, five-line staff) first, then triangle and piatti on
  one-line staves — not high→low. Shows the Janissary group silent through the `p` violin opening, then
  entering `f` with the tutti (piccolo, oboes, clarinets a2, bassoons, horns, trumpets, timpani in C–G); triangle in
  running quarters.  `[era: Classical "alla turca", 1780s]`
- Ex. 14-8, Shostakovich, *Symphony No. 6*, opening layout: Timpani, Tamburino, Tamb. milit., Triangolo, Piatti,
  Gr. Cassa, Tam-tam, Xilofono, Arpa, Celesta — unpitched below timpani and above xylophone, high to low (follows
  the prescribed sequence; harp here below the xylophone).
- Ex. 14-9, Orff, *Carmina Burana* No. 14 "In taberna quando sumus", mm. 83–96: xylophone placed above the unpitched
  group (timp, xyl, tamb. basco, c. chiara, 2 piatti, gr. cassa) — acceptable but less common. Shows timpani
  driving accented repeated eighths, xylophone with accented repeated-note groups, and the unpitched group
  hitting short accented strokes together (`ff`/`sf` entries) [details small, `?`].
- Ex. 14-10, Stravinsky, *Les Noces* (Las Bodas), 2nd tableau, mm. 163–173: four pianos (I–IV) placed above timpani
  as soloists; then timp, xylophone, then unpitched roughly high→low (Tr./Piatti, C.cl.[?], Tamb. s.c.[?], Tamb.
  b.[?], Piatti/Gr.C.). Shows pianos I and III `fff` tremolo, II "très rythmé et bien martelé" `fff`, IV `fff`
  accented repeated chords, timpani `f sempre` repeated eighths, xylophone `fff` trill, a bass-drum/cymbal stroke
  pattern underneath, against soloists and chorus — piano + percussion as a percussive orchestra.

**Tags:** #orchestration/percussion #orchestration/score-order #repertoire

## Organización de la sección de percusión (scan p.493–495, printed p.494–496)

**Rules**
- R26 [PREFER] Leave the assignment of players and the placement of instruments to the principal percussionist or
  the players, unless a specific layout is required (e.g. antiphonal work) or the composer has first-hand
  experience choreographing the section. Professional sections have their own (often idiosyncratic) systems.
- R27 [MUST] If you supply a setup diagram, state the number of players and make sure each can reach every assigned
  instrument at any moment of the piece.
- R28 [PREFER] Ask for one extra player in a very active percussion work rather than expecting a few players to
  cover a huge number of instruments.
- R29 [era: early 20th c. large-percussion works] Respighi, *Feste Romane*, needs 14 different percussion
  instruments, 10 playing at once at one point; most orchestras cannot hire 10+ players, so unless the regular (or
  slightly enlarged) section can cover everything, some parts get cut. (Footnote; a practical-feasibility warning.)

**Examples**
- Ex. 14-11, W. Kotoński, *a battere*: stage diagram (two percussion setups btt I/btt II, cymbal, guitar[?],
  viola, cello, conductor), instructions in three languages — composer-specified spatial layout.
- Ex. 14-12, Crumb, *Echoes of Time and the River*: "Processional I/II/III" — percussionists (Perc. III–VI) and
  pairs of trumpet/horn/trombone walk across and around the stage along drawn paths; theatrical, moving layout.
- Ex. 14-13, Berio, *Circles*: two multi-percussion setups (Perc. I, Perc. II, 15 numbered stations each: e.g.
  wood blocks, log drum, marimbaphone, bongos, tom-toms, small timpani, triangles, hi-hat, suspended cymbals,
  tam-tams, cowbells (cencerros), lujon, suspended chimes; Perc. II adds vibraphone, Chinese gongs, tambourine,
  congas, snare, pedal bass drum, temple blocks, maracas, xylophone), harp and voice, with a placement diagram and a
  stick legend (1 hard, 2 soft, 3 wood, 4 metal, 5 brushes). Shows how a modern score documents setup and beaters.

**Agent applicability**
- For sample-based mock-ups this is mostly irrelevant, except: keep the number of simultaneous unpitched
  instruments plausible for 3–4 players (+ timpanist) unless deliberately writing a huge Respighi-style section.

**Tags:** #orchestration/percussion #orchestration/staging #performance/percussion-players

## Usos de la sección de percusión (scan p.496, printed p.497)

**Concepts**
- Five representative uses of percussion in Western scores of the last 100 years:
  1. imitate march music (e.g. *à la Turque*) or add folk flavour — not the early use of timpani;
  2. reinforce accents and general rhythmic activity;
  3. build or crown a climax;
  4. create a dramatic opening (e.g. the cymbal stroke at the very start of Bizet's *Carmen* prelude);
  5. colour single notes or whole passages by doubling other instruments.
- Modern practice: with today's larger section and virtuoso players, composers also treat percussion, especially
  pitched percussion, as an independent section, often alternating with other sections.
- Harp and keyboards are analysed together with percussion; percussion-only works (Varèse, *Ionisation*) are out of
  scope.

**Rules**
- R30 [PREFER] Give each percussion entry one of these five jobs (or an independent, section-alternating role);
  an entry without a job is a candidate for deletion (inferred from R1/R5).

**Tags:** #orchestration/percussion #orchestration/function

## Simulación de música de marcha y folclórica (scan p.496–504, printed p.497–505)

**Concepts**
- Turkish instruments (instrumentos turcos, Janissary group): bass drum, cymbals, triangle — the march-percussion
  group Classical and early Romantic composers used to evoke soldiers' marches, war, conflict.

**Rules**
- R31 [era: Classical/early Romantic, c.1780–1830] The Turkish group excludes timpani: by Beethoven's time timpani
  were regular orchestra members, not part of this colour group.
- R32 [PREFER] Turkish march build-up (Beethoven model): bass drum first, doubling the low winds; triangle and
  cymbals join only when the tune arrives; play it with a gradual crescendo, as if a band were approaching from
  afar. `[era: Classical/early Romantic "alla turca"]`
- R33 [PREFER] Spanish dance colour: tambourine and castanets combined with triangle, snare and cymbals
  (Rimsky-Korsakov). The same kit evokes any Mediterranean region ("Italian", "Moroccan" pieces).
- R34 [AVOID] Treating this colour kit as automatically "exotic": Adler calls it a cliché of 18th–19th c.
  composers, though many successful pieces belong to that tradition. `[era: 18th–19th c. exoticism]`

**Examples**
- Ex. 14-14, Beethoven, *Symphony No. 9*, IV, Alla marcia, mm. 1–33 (Allegro assai vivace, dotted quarter = 84,
  6/8, Bb major). Bass drum `pp` on the 2nd dotted-quarter beat of each bar (4th eighth), doubling bassoons and
  contrabassoon on low Bb; from m. 9 clarinets and horns add the same offbeat. From m. 13, when winds and horns
  bring the tune (`pp`, flutes/piccolo, oboes, clarinets, horns in 3rds/6ths), the bass drum moves to beat 1,
  cymbals hit beat 1, triangle hits both dotted-quarter beats, all `pp`; trumpet `pp sempre` from m. 17; strings
  enter `pp` staccato at m. 28; `sempre pp` at m. 30. Shows soft, steady Janissary pulse under a wind band.
- Ex. 14-15, Rimsky-Korsakov, *Capriccio espagnol*, IV (Scena e canto gitano), mm. 78–98 (Allegretto, 6/8,
  tempo marked 69 [note value `?`]). m. 78 tutti `sf` stroke with triangle `f` and cymbal `mf`; m. 79 harp `ff`
  strummed chords simile, snare roll crescendo. From m. 82 (letter P) an interlocking ostinato: timpani `p` low
  tonic on the downbeat plus a fifth later in the bar; triangle `p` triplet-16th flourish after the first eighth;
  snare `p` roll-eighth + eighth on the last two eighths; cymbal `pp` one stroke late in the bar — each instrument
  owns a different slot of the 6/8 bar, under violins alternating arco/pizz and an A-clarinet triplet motif. At
  m. 92 (letter Q) `ff` tutti with trombones: tambourine added (shake/trill roll on beat 1 + strokes), bass drum
  `mf` on the downbeat, cymbal `mf`, timpani `f`; m. 98 everything converges on the downbeat with diminuendo.
  (Castanets, named in the text, are not visible in this excerpt.)
- Pointers (no example): Chabrier, *España*; Tchaikovsky, *Capriccio Italien*; Ibert, *Escales* — same instruments
  for Mediterranean colour.

**Agent applicability**
- Alla turca / march: BD on beat 1 (or offbeat when doubling a bass ostinato), cymbal with BD on beat 1, triangle on
  every main beat; velocities low (`pp` ≈ 30–45, inferred) with a long crescendo over 16–32 bars for "approaching
  band"; no timpani in the colour group.
- Spanish/Mediterranean: give tambourine, triangle, snare, cymbal, timpani different subdivisions of the bar so they
  interlock instead of all hitting the downbeat; add tambourine roll + BD only at the `ff` tutti; converge all on the
  final downbeat.

**Tags:** #orchestration/percussion #style/alla-turca #style/spanish #orchestration/colour #repertoire

## Refuerzo de la acentuación rítmica (scan p.505, printed p.506; continues)

**Rules**
- R35 [PREFER] Second common use: percussion reinforces overall rhythmic activity or strong accents; Copland's
  *Appalachian Spring* has several imaginative instances.
- R36 [PREFER] Double only the accented notes of a string line on xylophone (not the whole line), and put a single
  drum stroke on the brass accent it supports.

**Examples**
- Ex. 14-16, Copland, *Appalachian Spring*, mm. 51–54 (Allegro, quarter = 160, C): violins/violas tutti `f
  vigoroso` with accented leaps, doubled by piano `f vigoroso` (octaves, 8va); xylophone `f` plays only the accented
  notes of the violin line; tabor (field drum) gives one `sf` stroke under the horns' `sf` cuivré (stopped/brassy)
  fermata accent (mm. 53–54), the horns then decaying to `p`. Clarinet and bassoons hold under fermatas.

**Agent applicability**
- Copy accented string notes (velocity ≥ ~100) to a xylophone track, short notes only; place one field-drum/snare
  hit (no roll) under brass `sf` accents.

**Tags:** #orchestration/percussion #orchestration/doubling #orchestration/accents #style/americana
