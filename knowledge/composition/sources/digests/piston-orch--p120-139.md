---
source_id: piston-orch
source_title: Walter Piston, Orchestration (W. W. Norton, 1955)
source_era: "1955; mid-20th-c. American orchestral practice (repertoire Haydn to Stravinsky/Copland)"
scan_pages: s060L-s069R
printed_pages: 120-139
chapters: ["Ch.6 Woodwind Instruments (general; end, p.120-127)", "Ch.7 The Flute (start, p.128-139)"]
continues_from: Woodwind Instruments
continues_into: The Flute
---

# Walter Piston, Orchestration — scans s060L–s069R (printed p.120–139)

The range opens near the end of the general woodwind chapter (Ch.6), in the paragraph on tone quality,
and covers pitch, tonguing, phrasing, registers and score markings. Chapter 7 (The Flute) starts on p.128.
The digest stops on p.139, in the section on the second flute. The flute does not transpose: all flute
pitches below are concert pitch (C4 = MIDI 60). No page in the range was blank or unreadable.

## Ch.6 Woodwind Instruments — tone quality, end of section (printed p.120)

**Concepts**
- Woodwind tone quality depends on bore, tone holes, materials and the player. The player can vary it
  for expression. Sensitivity, warmth and natural vibrato are human factors that machines cannot copy.
- On reed instruments, the condition and pliability of the reed affect the tone.

**Agent applicability**
- Rendered wind parts sound mechanical without performance variation. Add continuous expression
  (CC11), vibrato (CC1 on SWAM) and small timing and velocity variation, not fixed values (inferred).

**Tags:** #orchestration/woodwinds #performance/expression

## Ch.6 — Pitch (afinación) (printed p.120)

**Rules**
- R1 [ALLOWED] The player tunes mostly with the lips. Small changes of overall tube length (joints,
  fittings) are possible, but they put the tone holes out of tune.
- R2 [PREFER] Enharmonic notes share a fingering (e.g. F# = Gb). The player adjusts them by ear to the
  harmony and to the rest of the orchestra, mostly by instinct.
- R3 [ALLOWED] Temperature changes pitch: a cold instrument plays flat until warmed up, and a hot one
  plays sharp. [era: acoustic-performance fact, not relevant to samples]

**Tags:** #orchestration/woodwinds #performance/intonation

## Ch.6 — Tonguing (articulación con la lengua, picado) (printed p.120–124, Ex.142–147)

**Concepts**
- Single tonguing: the tongue blocks the air and releases it with a sudden "tu". The note ends when the
  tongue returns. A wind attack is never imperceptible the way a bow can engage a string gradually. Softer
  attacks use "du", or even "htu".
- Unmarked notes (no slur, no dot) are each tongued with "tu" (non-legato, detached but not short).
- Staccato (dots): strokes made as sharply as possible.
- Double-tonguing (doble picado): "tu-ku-tu-ku", for articulations too fast for single tonguing.
- Triple-tonguing (triple picado): "tu-tu-ku, tu-tu-ku" (most players prefer this), or "tu-ku-tu, tu-ku-tu".
  Some players apply double-tonguing to triplets, so the groups begin alternately on t and k: "tu-ku-tu,
  ku-tu-ku".
- Flutter-tonguing (frullato; Ger. Flatterzunge): a tremolo made by rolling the tongue like an Italian or
  Spanish rolled r.

**Rules**
- R1 [MUST] With no slur or articulation mark, render each wind note with its own attack (separate
  notes, no overlap). *Why:* each note is tongued.
- R2 [ALLOWED] Fast repeated single-tongued notes are possible, but not for long stretches without a rest
  for the tongue.
- R3 [PREFER] Double-tonguing is easy on the flute. Oboe, clarinet and bassoon players use it when they
  must, but it is less satisfactory on reeds: the "k" is formed at the back of the mouth, away from the reed,
  so the notes can be uneven. Prefer fast repeated-note staccato in flutes over the reeds.
- R4 [ALLOWED] Fast triplet repeated notes are idiomatic with triple-tonguing (Ex.145, Ex.158).
- R5 [PREFER] Flutter-tonguing is more practicable on the flute than on reeds. It works poorly on oboe and
  bassoon and somewhat better on clarinet.
- R6 [ALLOWED] Flutter-tonguing combined with a rapidly fingered chromatic scale gives a whirring,
  picturesque effect (Ex.146).

**Examples**
- Ex.142 Brahms, *Variations on a Theme by Haydn* (Andante, 2/4, f): full wind band (2 fl, 2 ob, 2 cl in
  Bb, 2 bn, cbn) plays the chorale theme as tongued, unslurred chords. Shows a wind choir with detached
  "tu" articulation and the contrabassoon as the bass.
- Ex.143 Berlioz, *Symphonie fantastique*, finale (Allegro 6/8, p leggiero): piccolo, flute, 2 oboes, Eb
  and C clarinets and 2 bassoons in light staccato eighth-note figures traded between instruments. Shows
  rapid staccato tonguing across the section.
- Ex.144 Mozart, *The Marriage of Figaro*, overture (Presto, cut time, f): flutes, oboes and clarinets in A,
  a 2, in rapid detached scale runs, with bassoons joining in thirds. Shows fast articulated scales doubled
  across the woodwinds.
- Ex.145 Wagner, *Lohengrin*, prelude to Act III (Sehr lebhaft, ff): 3 flutes, 3 oboes and 3 clarinets
  play repeated triplet chords while the 3 bassoons play the melody a 3. Shows triple-tonguing on
  repeated-chord triplets.
- Ex.146 Ravel, *La Valse* (Tempo di valse, p): flute III plays a flutter-tongued ("tremolo") chromatic
  scale up and back down.
- Ex.147 Berg, *Violin Concerto* (Grazioso, p): 2 clarinets and bass clarinet play flutter-tongued
  (Flatterzunge) chords. In the score, harp, bassoons and saxophone double them with ordinary tonguing.
  The clarinet parts are written at concert pitch.

**Agent applicability**
- Map articulations to MIDI. Slur: overlap the notes (legato; on SWAM, overlap = slur). Unmarked: a short
  gap and a fresh attack. Staccato: shorter notes with sharper attack velocity.
- For fast repeated notes or triplet chords in winds, give flutes the longest runs and keep reed runs
  shorter (inferred from R2–R3).
- Use flutter-tongue as a flute colour effect, if the library has a frullato articulation, and avoid it on
  oboe and bassoon.

**Tags:** #orchestration/woodwinds #orchestration/articulation #performance/tonguing

## Ch.6 — Phrasing and breath (fraseo, respiración) (printed p.125–126, Ex.148)

**Concepts**
- Slur (ligadura): the notes under it are played on one uninterrupted stream of air. Fingering changes
  the length of the air column note by note (some notes are fundamentals, others harmonics), so the
  embouchure keeps adjusting to hold tone and intensity even.
- Phrases normally combine several slurs, or slurs and single notes. The air stays full and steady until a
  breath, and the tongue articulates the rhythm inside it.
- The breath sets up vibration at the embouchure. It does not blow through the instrument.

**Rules**
- R1 [PREFER] A wide slur upward (more embouchure tension) is easier than the same slur downward. A
  sudden drop to a lower fundamental after notes on upper partials meets resistance, and tonguing
  overcomes it more reliably. Tongue wide downward leaps rather than slurring them (inferred).
- R2 [AVOID] Wind tremolos between two notes a sixth (8–9 semitones) or more apart. The lower note risks
  failing to speak on repetition.
- R3 [MUST] Breathing marks are not written in parts, but wind writing must allow breaths at natural
  places. Distribute wind effort by the dynamic and mechanical needs of each note in the phrase.
- R4 [ALLOWED] A fresh breath can sharpen the definition of a motive.
- R5 [PREFER] Give wind lines a natural, sung breathing quality, like vocal phrases.
- R6 [PREFER] In fast passages, leave out notes to create a breath. Do not force the player to snatch
  breaths in tiny gaps.

**Examples**
- Ex.148 Beethoven, *Symphony no. 3*, finale (Poco andante, 2/4, p): oboe I solo mixing short slurs and
  staccato notes. The oboist likely takes no breath until after the Bb in the fifth full bar, so one breath
  carries a long, varied phrase.

**Agent applicability**
- In a solo wind line, schedule a real gap (rest or shortened note, ≥ about 1/8 beat at moderate tempo)
  every phrase, usually every 2–4 bars. Never write long unbroken runs (inferred quantification).
- On SWAM, keep CC11 continuous through slurs and dip it only at breath points (matches the
  project rule).

**Tags:** #orchestration/woodwinds #performance/breathing #orchestration/articulation

## Ch.6 — Registers (registros) (printed p.126)

**Rules**
- R1 [MUST] Each woodwind changes in tone colour, intensity, carrying power and tone-weight across its
  range, much more than the strings do. Knowing each register is essential. Pick a woodwind's register for
  its colour and carrying power, not only for its pitch.

**Agent applicability**
- Before assigning a line to a woodwind, check which register it falls in (see the flute register map
  below) and balance it for that register's carrying power.

**Tags:** #orchestration/woodwinds #orchestration/registers

## Ch.6 — Score markings (notación en partitura) (printed p.126–127, Fig.44)

**Rules**
- R1 [MUST] Woodwind score order, top to bottom: piccolo, flutes, oboes, English horn, clarinets, bass
  clarinet, bassoons, contrabassoon.
- R2 [PREFER] Write 1st and 2nd parts of the same instrument on one staff. Add a temporary second staff
  only when rhythms or other complications would confuse the reading.
- R3 [MUST] Two parts on one staff: 1st part stems up, 2nd part stems down. Dots and accents go at the
  stem ends.
- R4 [ALLOWED] Both players on the same part: double stems, or a single part marked "a 2".
- R5 [ALLOWED] 1st player alone: rests in the 2nd part, or mark the single line "1", "I", "1°" or "I°". The
  2nd player alone is shown the same way with "2", "II", "2°" or "II°".
- R6 [NEVER] Use "divisi" or "unis." for winds. Those marks are for strings only.

**Agent applicability**
- In REAPER, track names and track order should follow the score order (FL, OB, EH, CL, BCL, BN, CBN).
  When a single track carries "a 2", render it as one doubled line (or two tracks with the same notes).

**Tags:** #orchestration/woodwinds #notation/score-layout

## Ch.7 The Flute — instrument (flauta; Fr. flûte, grande flûte; It. flauto, flauto grande; Ger. Flöte, große Flöte) (printed p.128–129)

**Concepts**
- Metal flutes (silver, gold, even platinum) have replaced wooden ones. Compared with wood they speak
  more easily and are more agile, brilliant and secure in the high register. Their tone is pure, clear and
  serene. Wooden flutes were mellower. [era: wooden flute largely obsolete by 1955; some wooden flutes
  with silver-lined heads still in use]
- The flute is about 26½ in long, with a sounding length near 24 in. The bore is cylindrical (¾ in) and
  narrows slightly toward the embouchure in a parabolic curve. It has three sections: head, body and
  foot joint. The foot joint adds the low C# and C.
- Lowest note: C4 (60), called "2-foot C". A longer foot joint (about 2 in longer) adds low B3 (59), used
  rarely.

**Rules**
- R1 [MUST] Normal lowest flute note is C4 (60).
- R2 [ALLOWED] B3 (59) only when a B foot joint is assumed, on rare occasions.

**Tags:** #orchestration/woodwinds/flute #orchestration/ranges

## Ch.7 — Fingering system (Boehm) (printed p.129–131, Fig.45)

**Concepts**
- Boehm system (mid-19th c.): a hole for every chromatic note, each in its acoustically correct place.
  Holes are as large as possible and stand open, and keys, plates and axles let the fingers control every
  hole. Keys are named after the note that sounds when the key is pressed.
- To finger a note, every hole above it must be closed, except holes opened as vents for upper partials.
  The right little finger opens the D# key and keeps it open for almost all notes above. It also works a
  split key for low C or C#. There are trill keys for high D and D#, and an extra Bb trill key.
- The player holds the instrument with the right thumb, the base of the left index finger and the chin.
  The lower lip partly covers the embouchure hole.
- Fig.45, a fingering chart, covers C4 up to about C7 or D7 [?: top notes of the chart are small].

**Rules**
- R1 [ALLOWED] Enharmonic equivalents use the same fingering (G# = Ab).

**Tags:** #orchestration/woodwinds/flute #orchestration/technique

## Ch.7 — Overblowing and harmonic series (sobresoplado) (printed p.131, 133, Fig.46)

**Concepts**
- Upper notes come from fingering a fundamental and overblowing, usually with one or more holes opened as
  vents. Fig.46 maps the main harmonics used:
  - Harmonic 2 (octave): D5, D#5 from D4, D#4. E5–C#6 are overblown octaves of E4–C#5 played without
    vents ("not vented").
  - Harmonic 3: D6 (86) from G4.
  - Harmonic 4: D#6–G#6 from the low D#4–G#4 fingerings, and Bb6 (94) from Bb4.
  - Harmonic 5: A6 (93) from F4, B6 (95) from G4.
  - Harmonic 6: C7 (96) from F4, and C#7 (97) as a sharp 6th harmonic.
  - Harmonic 7 (sharp): D7 (98).
- High notes built on different harmonics differ in tone and brilliance. Top Bb6 (harmonic 4) is clearer
  and easier to manage than B6 (harmonic 5). The high A6 fingering is sometimes awkward in passages.

**Rules**
- R1 [PREFER] In high flute writing, Bb6 (94) is safer and clearer than B6 (95).
- R2 [AVOID] Fast, exposed passage work that repeatedly crosses A6 (93) (awkward fingering).

**Tags:** #orchestration/woodwinds/flute #acoustics/harmonics

## Ch.7 — Tone qualities of the registers (registros de la flauta) (printed p.131–134, Ex.149–153)

**Concepts / register map (concert pitch)**
- Lowest half-octave, C4–about F#4 (60–66), especially the foot-joint notes C4–D4: a warm, velvety tone.
  It sounds deceptively heavy alone, but other instruments, and the strong overtones of low bass notes,
  cover it easily. *Why:* the upper partials are weak in this register.
- Rest of the first octave, up to about B4 (71): the tone brightens gradually as the tube gets shorter,
  but these fundamental notes never reach the clarity and serenity of the second octave.
- Second octave, C5–B5 (72–83): overblown notes with a clear, serene tone.
- Third octave, C6 upward (84+): brilliant and carrying, without shrillness up to A6 (93), or even Bb6
  (94).
- Extreme top: C#7 (97) and D7 (98) are "extremely exceptional" extensions.

**Rules**
- R1 [AVOID] Burying low-register flute (C4–F#4) under other instruments or above loud low bass notes.
  It will be covered.
- R2 [PREFER] When the low flute must be heard, make it the lowest voice of a light texture, or give it
  nothing heavy underneath (Ex.149).
- R3 [PREFER] For clear, serene flute melody, use the second octave (C5–B5).
- R4 [ALLOWED] For brilliance and projection over the orchestra, use the third octave up to A6–Bb6
  (93–94).
- R5 [NEVER] C#7 or D7 in soft passages. They belong only in loud passages, preferably doubled by the
  piccolo, and are rare.
- R6 [MUST] Practical top of the flute range: C7 (96). Treat 97–98 as exceptional (see R5).
- R7 [ALLOWED] A melody may span the whole range of the flute.
- R8 [PREFER] Do not count on the flute for large dynamic contrasts: its dynamic range is narrow. Get
  dynamic shape from register and orchestration (inferred consequence).

**Examples**
- Ex.149 Stravinsky, *Symphony of Psalms* (mf): flute I high, flute III low and oboe I in the middle. The
  low C4 of flute III sounds clearly because it is the lowest of the three voices, with no bass beneath.
- Ex.150 Ravel, *Ma Mère l'Oye* (Lent, pp): flute II alone in the first octave and around C5, then flute I in
  the second and third octaves over flute II's low chromatic neighbour figures. Compares the
  first-octave tone with the overblown second octave.
- Ex.151 Schumann, *Symphony no. 1* (finale cadenza): flute I solo cadenza with a trill and runs, then a
  p, a tempo staccato passage in the upper second and third octaves. Shows third-octave brilliance at soft
  dynamics.
- Ex.152 Strauss, *Symphonia domestica* (Scherzo, mf–f): flute I climbs to the extreme top [?: top note
  under an 8va bracket], then descends in triplets. Illustrates the use of the highest notes.
- Ex.153 Ravel, *Daphnis et Chloé* (Très lent, p, expressive and supple): the long solo flute pantomime
  melody over the whole range, with free rubato, tuplets, retenu and a tempo, and ppp to f. A model of a
  modern flute solo.

**Agent applicability**
- Flute melody default: C5–A6 (72–93). Use C4–B4 only for soft, exposed, thin textures. Hard ceiling 96,
  and only use 97–98 at ff doubled by the piccolo an octave up.
- If the flute plays in the low octave while strings or brass play mf or louder, either move the flute
  up an octave or thin out what sounds against it.

**Tags:** #orchestration/woodwinds/flute #orchestration/registers #orchestration/ranges #orchestration/balance

## Ch.7 — Agility (agilidad) (printed p.134–136, Ex.154–158)

**Rules**
- R1 [ALLOWED] The flute is the most agile wind instrument: rapid scales, arpeggios and brilliant
  passage work of every kind are idiomatic.
- R2 [ALLOWED] Wide leaps between registers are idiomatic on the flute (Ex.155).
- R3 [MUST] Loud high-register passages use more air. Leave room for at least a quick breath, either
  in the phrasing or with a rest.
- R4 [PREFER] Two flutes can split a passage into alternating motives that overlap on the accented notes.
  This makes breathing easier for both players and sounds more rhythmic than both playing the whole phrase
  in unison (Ex.156).
- R5 [ALLOWED] Double-tonguing and triple-tonguing are both effective and efficient for fast flute
  staccato (Ex.157–158).

**Examples**
- Ex.154 Strauss, *Elektra* (Sehr schnell, half note = 176, ff–sfz): 3 flutes a 3 in very fast chromatic and
  zig-zag sixteenth runs in the high register, ending in a falling run. Shows flute virtuosity at full power.
- Ex.155 Strauss, *Ein Heldenleben* (Sehr lebhaft, p): flutes I–II and III in staccato figures with wide
  leaps between registers, traded between players.
- Ex.156 Stravinsky, *L'Oiseau de feu* (Vivo, mf with hairpins): flutes I and II alternate rising
  sixteenth-note groups, each entering on the other's accented peak note.
- Ex.157 Tchaikovsky, *Nutcracker Suite no. 1*, March (Tempo di marcia viva, mf): flute I double-tongued
  repeated-sixteenth staccato figures.
- Ex.158 Debussy, *La Mer* (Assez animé, p cresc. to mf): flutes I–II in rapid triple-tongued staccato
  repeated notes in thirds.

**Agent applicability**
- For long virtuoso flute runs, split them between Fl I and Fl II on separate tracks, with the hand-offs
  on accented notes. Insert a breath gap at least every few bars when the line is loud and high.

**Tags:** #orchestration/woodwinds/flute #orchestration/technique #orchestration/texture

## Ch.7 — Harmonics (armónicos de flauta) (printed p.136–137, Fig.47, Ex.159)

**Concepts**
- Every normal flute note above the open C#5 (73) is already a harmonic. In woodwind usage, "harmonic"
  means a note produced on a different harmonic from the usual one.
- Fig.47a: high D6 (86) can be played three ways: (1) normal, as harmonic 3 of G4 with the C# hole opened
  as a vent; (2) the same fingering with the vent closed; (3) as harmonic 4 of low D4, with no vents.
- Fig.47b: some flutists can play the whole harmonic series of low C4, unvented, up to the 7th or 8th
  partial (C5, G5, C6, E6, G6, Bb6, C7).

**Rules**
- R1 [ALLOWED] The notes normally written as flute harmonics are the unvented 3rd harmonics of the 14
  chromatic fingerings C4–C#5. They sound G5–G#6 (79–92) and are marked with a small circle, as for strings.
- R2 [PREFER] Flute harmonics have a veiled quality but are less clear and less in tune than normal tones.
  Use them for colour in soft passages, not for exposed in-tune melody.
- R3 [ALLOWED] Harmonic fingering for one or two notes can make a difficult passage easier without
  noticeably changing the overall sound.

**Examples**
- Ex.159 Ravel, *Daphnis et Chloé* (Très lent, 6/8, p): flutes I–II and alto flute play repeated chords
  entirely in harmonics, held with fermatas, before a ff–pp run. An extraordinary harmonic sonority. The
  alto flute is in the score.

**Agent applicability**
- If the library has a flute-harmonics or "flautando-like" patch, use it only in G5–G#6, at p or softer,
  for an airy colour.

**Tags:** #orchestration/woodwinds/flute #orchestration/extended-techniques

## Ch.7 — Trills and tremolos (trinos y trémolos) (printed p.137–138)

**Rules**
- R1 [PREFER] Treat trill and tremolo playability as a matter of degree. Difficulty comes from changing
  several fingers or harmonics at once. Trill keys (high D, D#) and harmonic fingerings make some trills
  easier.
- R2 [AVOID] Fast trills C4–C#4 and C#4–D#4, and the tremolo C4–D#4. All three use the foot-joint keys
  worked by the right little finger alone, so they are possible only rather slowly.
- R3 [ALLOWED] Single-note tremolo by flutter-tonguing exists but is not often used.
- R4 [PREFER] The usual wind tremolo is a fingered tremolo: a "trill" on an interval larger than a second,
  like the strings' fingered tremolo.
- R5 [AVOID] Flute tremolos wider than a perfect fifth (7 semitones) in the first octave (C4–B4): they are
  uncertain. *Why:* the lower note may fail to speak, and with harmonics the fundamental may sound by
  mistake.
- R6 [AVOID] Flute tremolos wider than a major third (4 semitones) above the first octave (from C5 / 72
  up). A major third is the safe limit there.

**Agent applicability**
- Flute fingered tremolo: allow up to 7 semitones if both notes are below 72, and up to 4 semitones
  otherwise. Never write a trill or tremolo on the C4/C#4/D#4 foot-key pairs at speed.

**Tags:** #orchestration/woodwinds/flute #orchestration/technique/trills

## Ch.7 — The second flute (segunda flauta) (printed p.138–139, Ex.160–162; continues past p.139)

**Rules**
- R1 [PREFER] The second flute most often doubles the first in unison, for tone-weight.
- R2 [ALLOWED] Less often it doubles an octave below. Its octave overtone then reinforces the first flute,
  but the lower flute is at a slight disadvantage because it sits in a less brilliant register.
- R3 [PREFER] When both flutes are not needed, give some of the first player's material to the second.
  This rests the first player and makes the second part more interesting.
- R4 [ALLOWED] The two flutes may carry two melodies of equal importance (Ex.160).
- R5 [ALLOWED] Two flutes can carry light accompaniment figures (Ex.161).
- R6 [ALLOWED] Two flutes can supply the two inner voices of a four-part texture whose outer voices are
  doubled in octaves by the strings (Ex.162).

**Examples**
- Ex.160 Stravinsky, *Orpheus* (Andante con moto, leggiero, mf): two independent, interlocking florid
  flute lines of equal weight.
- Ex.161 Debussy, *Première Rhapsodie* (quarter = 72, pp léger): flutes I–II in a light, repeated
  off-beat sixteenth-note accompaniment figure on one staff.
- Ex.162 Mendelssohn, *Italian Symphony*, 2nd movement (Andante con moto, p): flutes I–II play flowing
  inner voices in eighth notes. The soprano is in the violins (with oboe I and viola added later), and the
  bass is staccato eighths in cellos and basses (bassoon added later, an octave below), both in octaves.

**Agent applicability**
- Default Fl II is a unison doubling of Fl I in loud tutti passages. Use the octave-below doubling only
  when Fl I is already high (C6+), so Fl II stays in its clear second octave.
- In a light 4-part texture, the two flutes can take the alto and tenor lines (about C5–C6), with the
  violins (sop.) and cellos/basses (bass) in octaves around them.

**Tags:** #orchestration/woodwinds/flute #orchestration/doubling #orchestration/texture
