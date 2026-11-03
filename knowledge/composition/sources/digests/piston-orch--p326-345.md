---
source_id: piston-orch
source_title: Walter Piston, *Orchestration* (W. W. Norton, 1955)
source_era: "1955; mid-20th-c. American orchestral practice (repertoire Haydn to Stravinsky/Copland)"
scan_pages: s163L-s172R
printed_pages: 326-345
chapters: ["Ch. 17 (number inferred) The Harp — end: pedal notation, enharmonics, glissando, fingering, chords, harmonics, sons étouffés, près de la table, trills and tremolos, melodic uses, accompaniment, special effects, number of harps; The Cimbalom", "Ch. 18 Keyboard Instruments — the piano: five roles, orchestral uses (doubling), solo passages, percussion (start)"]
continues_from: "The Harp (Ch. 17, inferred number); range opens at the end of a paragraph on pedal changes and chromaticism"
continues_into: "Keyboard Instruments (Ch. 18), piano, 'Percussion' section: a piano tremolo combined with bass drum and timpani rolls (example on p.346)"
---

# Piston, *Orchestration* — scans s163L–s172R (printed p.326–345)

Harp pitch facts used below (from Piston's earlier harp pages and standard practice, not re-read here): the concert
harp has 7 pedals, one per pitch class, each with flat / natural / sharp positions. Left foot works D, C, B and
right foot works E, F, G, A. Range is about Cb1 to Gb7 (MIDI 23–102) (inferred from standard practice; the range
figure is outside this page range).

## The Harp, end: chromaticism and pedal notation (scan s163L, printed p.326)

**Concepts**
- Pedal setting (afinación de pedales): the flat/natural/sharp position of all 7 pedals at a given moment. It fixes the pitch of every string of that letter name in every octave.
- Pedal diagram (diagrama de pedales, Fig. 107c): a horizontal line split by a vertical stroke into left-foot pedals (D C B) and right-foot pedals (E F G A). A mark above the line means flat, on the line natural, below the line sharp.

**Rules**
- R1 [AVOID] Continuous chromaticism that needs constant pedal changes. It does not suit the harp. Rapid successive changes on pedals worked by the same foot are the hardest case. *Why:* every chromatic note costs a pedal move.
- R2 [PREFER] Mark pedal changes in the part, although this is not required. *Why:* it makes the composer check that chromatic passages are playable. Harpists must otherwise plan and mark pedaling themselves, so unmarked non-simple parts cannot be sight-read.
- R3 [ALLOWED] Give the opening pedal setting in one of three ways (Fig. 107):
  - (a) all seven degrees with accidentals, e.g. Cb D♮ E# F♮ G# Ab Bb;
  - (b) grouped by foot, right-foot pedals above (E# F♮ G# Ab) and left-foot pedals below (Bb Cb D♮), each in order outward from the centre;
  - (c) the pedal diagram.
- R4 [MUST] Announce each later pedal change ahead of the note that needs it, e.g. "F#, A♮". French scores show this practice.

**Agent applicability**
- Before writing a harp MIDI part, compute one 7-pitch-class pedal set per passage. Flag any bar that needs more than about 1–2 pedal changes, especially on the same foot (inferred threshold).

**Tags:** #orchestration/harp/pedals #orchestration/harp/notation

## Enharmonics (scan s163L–s164L, printed p.326–328)

**Concepts**
- Homophones (homófonos; harpists' term): enharmonic equivalents produced on two different strings, e.g. F# on the F string and Gb on the G string.
- Enharmonic unison (unísono enarmónico): the same pitch sounded on two strings at once.

**Rules**
- R5 [ALLOWED] The harpist may take a note enharmonically to avoid an awkward pedal change (F# played as Gb), whatever the notation says.
- R6 [PREFER] Play fast repeated notes by alternating two strings tuned to the same pitch rather than by re-plucking one string (Ex. 344).
- R7 [ALLOWED] Use the enharmonic unison for a richer sound, especially in the low register. *Why:* a single low string may lack body and carrying power (Ex. 345).
- R8 [PREFER] Have passages with many sharps played enharmonically in flats. *Why:* strings sound best in the flat position, at their greatest length.
- R9 [PREFER] Notate chromatic tones by their harmonic and melodic meaning, even when that needs double sharps or double flats. These notes exist on the harp only as enharmonics. Do not try to write the harpist's enharmonic choices into the part (Ex. 346).
- R10 [ALLOWED] Enharmonic tuning is common in harp glissandos (see Glissando).

**Examples**
- Ex. 344 Debussy, *Le Martyre de Saint Sébastien*: Harps I and II a 2, flat key, pedals set to C# and A# alongside Db and Bb. Rapid repeated 16th-note figures alternate between enharmonic string pairs.
- Ex. 345 Casella, *A Notte Alta* (Lento molto, misterioso, pp): very low notes [octave ?] sounded as an enharmonic unison, Bb in one hand and A# in the other, with tied low notes. Gives a fuller bass tone.
- Ex. 346 Dukas, *Ariane et Barbe-Bleue*: 2 harps, A major, slurred chromatic lines spelled with double sharps. Shows notation that follows the harmony rather than the strings.

**Agent applicability**
- For harp repeated notes faster than about 8th notes at moderate tempo, assume enharmonic string alternation is possible only if both neighbouring strings can be pedalled to that pitch. Many sample libraries model this with round-robin, so MIDI is unaffected (inferred).
- For a low harp note that must carry, double it at the unison (two MIDI notes or a second harp) or add a low string/bassoon pizz doubling (inferred).

**Tags:** #orchestration/harp/enharmonics #orchestration/harp/notation

## The Glissando (scan s164L–s165L, printed p.328–330)

**Concepts**
- Glissando (glissando): the hand sweeps across the strings near their middle. The thumb catches each string going down and the third finger going up (fingers numbered as on the piano, thumb = 1). Every string sounds, so the sounding gliss is the full 7-note pedal set.

**Rules**
- R11 [AVOID] The routine up-beat harp gliss into an orchestral tutti. Piston calls it one of music's worst clichés [era: comment on c.1900–1950 orchestral habit]. Look for more varied gliss uses instead.
- R12 [MUST] Account for all seven pedals in a gliss. To gliss a chord (e.g. a diminished seventh), retune the other pitch classes enharmonically onto chord tones. The resulting doubled strings are not heard as repeated notes.
- R13 [ALLOWED] For a second gliss, list only the strings that change.
- R14 [ALLOWED] Rhythmic values in a gliss don't matter, provided its start and end timing are unambiguous. 32nd notes plus the word *glissando* are the usual notation.
- R15 [ALLOWED] Don't write out every note. One written octave shows the tuning (Ex. 348). Or give the pedal setting plus only the first and last notes (Ex. 349).
- R16 [ALLOWED] A gliss can use one or both hands, can cover the whole range of the harp, and can be built on scales, chords or any arrangement of the 7 tones.
- R17 [ALLOWED] Special gliss colours:
  - near the soundboard (*près de la table*);
  - with flat hands instead of one finger;
  - with the hand reversed so the nails strike the strings.
- R18 [ALLOWED] Glissandos in double notes and in chords are playable (Ex. 350).

**Examples**
- Ex. 347 Debussy, *Printemps*: gliss up from the bass to the top with tuning Db, Fb, Bb added, p → f. Then a descending gliss marked *étouffez*, retuned B♮, A♮, G#, F#, Eb, p → f.
- Ex. 348 Roussel, *Bacchus et Ariane*, Suite 2 (Presto): two harps with different enharmonic tunings written as solfège lists (C#/Db, E/Fb, G, A, B). Harp II glisses up and Harp I glisses down, f. One octave of written notes shows the tuning.
- Ex. 349 Bartók, Violin Concerto: the pedal set is written above (C#, D, E, F#, G#, A, B), with only the first and last notes and a gliss line, p < f. A second gliss uses C#, D#, E, F#, G#, A#, B with top note D♮ [?].
- Ex. 350 Debussy, *La Mer*: chord glissandos, tuning Db, C#, Eb in a 5-sharp key. Harp I sweeps up p → mf to a high 8va chord and Harp II sweeps down mf → p.

**Agent applicability**
- MIDI harp gliss: generate notes only from the chosen 7-pitch-class set, one per string through the octave, evenly spaced at 32nd notes or faster, landing exactly on the target beat. For a chord gliss, map every scale degree to its nearest chord tone (enharmonic retuning) so repeated pitches occur.
- Keep tutti up-beat glisses rare; prefer soft gliss colour, a gliss alone or a chord gliss.

**Tags:** #orchestration/harp/glissando #orchestration/harp/enharmonics #orchestration/cliches

## Fingering, arpeggios and hands (scan s165L–s166L, printed p.330–332)

**Rules**
- R19 [ALLOWED] Strings are plucked near their middle with the fingertips and the outer edge of the thumb. The 5th finger is not used.
- R20 [ALLOWED] All scales use the same fingering, since there are no black/white key patterns. Ascending is 4 3 2 1 4 3 2 1; descending is 1 2 3 4 1 2 3 4.
- R21 [ALLOWED] One-hand interval reach and fingering:
  - seconds, thirds, fourths: 1–2;
  - fifths, sixths: 1–3;
  - sevenths up to tenths (≤16 semitones): 1–4.
- R22 [PREFER] Play arpeggios by alternating the two hands rather than with one hand (Ex. 352).
- R23 [ALLOWED] Both hands can cover the whole range. The left hand reaches the lowest strings more easily, since the harp rests on the player's right shoulder.

**Examples**
- Ex. 351 Berlioz, *Symphonie fantastique*, Valse (Allegro non troppo, 3/8, A major): 2 harps, ff. One rolls chords; the other plays 16th-note broken-chord and scale figures in both hands. Later both play descending 16th scale runs in octaves across the registers. Shows the 19th-c. two-harp waltz texture [era: Romantic, 1830].
- Ex. 352 Ravel, *Le Tombeau de Couperin* (Vif, 12/16, ff): rising 4-note arpeggio groups, left hand then right hand, climbing through several octaves.

**Agent applicability**
- Harp arpeggio MIDI: split every rising arpeggio into left-hand notes (lower half) and right-hand notes (upper half). Each hand's group spans ≤ a 10th (16 semitones) and has ≤4 notes.

**Tags:** #orchestration/harp/technique #orchestration/harp/arpeggio

## Chords (scan s166L–s166R, printed p.332–333)

**Rules**
- R24 [MUST] At most 4 notes per hand in a harp chord, because the little finger is not used. Max hand span is a 10th from thumb to 4th finger, comparable to the piano octave.
- R25 [ALLOWED] By default, harp chords are slightly arpeggiated from bottom to top.
- R26 [ALLOWED] Chord roll notation:
  - wavy vertical line: a more pronounced roll;
  - straight bracket or *non arpeggiato*: all notes plucked together;
  - arrow down: arpeggiate downwards.
  More often the player decides.

**Examples**
- Ex. 353 Bartók, Violin Concerto (Andante tranquillo, 9/8, *arpegg. rapido*, f, dim.): chords of 3–4 notes per hand. Upward and downward rolls alternate, each marked with an arrow.

**Agent applicability**
- Harp chord MIDI: ≤8 notes in total (≤4 per hand, each hand ≤16 semitones). Stagger onsets upward by about 10–30 ms by default (inferred). Use simultaneous onsets only for *non arpeggiato* effects, and a reversed stagger for downward rolls.

**Tags:** #orchestration/harp/chords

## Harmonics (scan s166R–s167R, printed p.333–335)

**Concepts**
- Harp harmonic (armónico): the octave harmonic. One hand stops the node at half the string length and plucks the upper half. The node sits lower when the string is in the sharp position than in the flat position.

**Rules**
- R27 [MUST] Only the octave harmonic is practical. It sounds one octave above the string.
- R28 [ALLOWED] Right hand: one harmonic at a time (fingers closed, node stopped by the second finger's second joint, thumb plucks). Left hand: 2 or even 3 harmonics at once if they are no more than a fifth (7 semitones) apart (open hand, node stopped with the lower outer side of the palm).
- R29 [PREFER] Write harmonics on middle-register strings. Above A5 (treble-clef first ledger line, MIDI 81, string pitch) the strings are too short. The wound bass strings (bottom octave and a fourth, roughly C1/Cb1–F2 (inferred), MIDI ≈23–41) lack the characteristic tone. So the usable sounding harmonics are roughly F3–A6 (inferred from string range + octave).
- R30 [MUST] Notation: write the string to be played with a small circle. It sounds an octave higher. If you write actual pitch instead (some harpists prefer it), say so in the score.
- R31 [ALLOWED] Character: soft, delicate, suggesting distance. A colour resource that other sounds easily cover. Keep the accompaniment very light.
- R32 [ALLOWED] Another colour: a normal plucked note in unison with a harmonic taken on the string an octave below.
- R33 [PREFER] Harp harmonics blend well as a decorative melodic doubling of muted violas and especially the flute.

**Examples**
- Ex. 354 Ravel, *Valses nobles et sentimentales* (Assez lent, pp): 2 harps. Single right-hand harmonics above 2–3-note left-hand harmonic chords, then normal chords swelling to f.
- Ex. 355 Debussy, *Nuages* (Modéré, pp): the harp plays a melody in unison with the flute, then repeated left-hand harmonic dyads in the middle register.

**Agent applicability**
- MIDI: write harmonics at sounding pitch (string + 12) on a harmonics patch, within about F3–A6 (inferred). Use ≤1 note in the right-hand part and ≤3 notes within 7 semitones in the left-hand part.
- Use them to double a soft flute or muted viola line. Never place them under a full texture.

**Tags:** #orchestration/harp/harmonics #orchestration/doubling #orchestration/colour

## Sons étouffés and damping (scan s167R, printed p.335)

**Concepts**
- *étouffez* (Ger. *abdämpfen*; Eng. *damp*; Sp. apagar): stop the sound by damping the strings with the flat of the hands.
- *sons étouffés* (sonidos apagados): each note is damped by the finger that just played it as it moves to the next note; with widely spaced notes the other hand damps. The result is a dry staccato.

**Rules**
- R34 [PREFER] Let harp notes ring. Dry staccato is the exception in the harp idiom.
- R35 [ALLOWED] Middle and low notes ring for a long time while fading. Add *étouffez* where the sound must stop. Mark short staccato chords *secco* as an extra precaution.
- R36 [ALLOWED] *sons étouffés* gives a dry, detached low-register staccato (Ex. 356).

**Examples**
- Ex. 356 Stravinsky, *Perséphone* (quarter = 50, mf): sustained low notes 8va bassa. Then *stacc., sons étouffés, ben marc.* single low bass notes and octaves.

**Agent applicability**
- Default harp MIDI notes should be long (let ring, or sustain pedal / long note-offs). For *étouffez*, cut all notes together at the damp point. For *sons étouffés*, use short note lengths and a staccato/muted harp articulation if the library has one.

**Tags:** #orchestration/harp/articulation

## Près de la table (scan s168L, printed p.336)

**Rules**
- R37 [ALLOWED] Plucking near the soundboard (*près de la table*) gives a metallic, somewhat guitar-like tone.

**Examples**
- Ex. 357 Britten, *Four Sea Interludes* (Peter Grimes) (Presto con fuoco): an upward pp gliss to a high note, *largamente*. Then ppp repeated chords in steady quarters, *près de la table*.

**Agent applicability**
- If the library lacks a *près de la table* articulation, approximate it with a nylon guitar doubling or a brighter EQ'd harp (inferred).

**Tags:** #orchestration/harp/articulation #orchestration/colour

## Trills and tremolos (scan s168L–s168R, printed p.336–337)

**Concepts**
- *bisbigliando* (Ital. "whispering"; susurrando): soft, rustling tremolo. The fingers of both hands move over a few strings in no particular order.

**Rules**
- R38 [ALLOWED] Harp trills and tremolos are comparatively slow. *Why:* re-plucking one string is limited in speed.
- R39 [PREFER] Play trills with alternating hands (Fig. 108b) rather than one hand (108a). That is more rhythmical. Enharmonic tuning of one note (108c) helps further.
- R40 [ALLOWED] *bisbigliando* is the most common orchestral harp tremolo. It suits soft dynamics. Write 3 or 4 notes within one hand's reach as a tremolo.

**Examples**
- Fig. 108: trill on C with Db shown three ways (one hand; hands alternating; with an enharmonic string).
- Ex. 358 R. Strauss, *Also sprach Zarathustra* (Sehr langsam): pp *bisbigliando* on 2–3-note chords written as measured tremolo, cresc.

**Agent applicability**
- Harp tremolo MIDI: use repeated irregular 32nds/sextuplets over 3–4 chord tones within ≤16 semitones, at low velocity (about 30–60), and vary the order. Don't write fast single-note trills on harp.

**Tags:** #orchestration/harp/tremolo #orchestration/harp/technique

## Melodic uses (scan s168R–s169L, printed p.337–338)

**Rules**
- R41 [AVOID] Long sustained harp melodies. The tone is resonant and strong but has no melodic sostenuto.
- R42 [PREFER] Harp melodies should be moderately active in rhythm without too many notes (Ex. 359).
- R43 [AVOID] Expressive melody in the top octave and a half (short strings). [PREFER] The lower-middle register, which Piston rates excellent (roughly C3–C5, inferred).
- R44 [ALLOWED] A few harp notes in a soft, muted texture can carry great expressive weight (Ex. 360).

**Examples**
- Ex. 359 Stravinsky, *Orpheus* (eighth = 96, 3/8, mf, flat key): two-voice right-hand melody in 16ths and 8ths over a plucked bass of single detached notes. A model of a harp-suited phrase.
- Ex. 360 Berg, Violin Concerto (Adagio): the harp plays the chorale melody in bass clef (*p deciso, doloroso, dolce*) in canon a fifth above the muted cellos. The background is very soft muted horns and muted violins.

**Agent applicability**
- For a harp melody, choose a mid-low register and phrases of 8th/16th motion. Use repeated or re-attacked notes instead of long values, and support long tones with a sustaining doubling (strings or flute).

**Tags:** #orchestration/harp/melody #orchestration/doubling

## Accompaniment, special effects, number of harps (scan s169L, printed p.338)

**Rules**
- R45 [ALLOWED] Accompaniment is the harp's everyday role: harmonic figures that break chords into endless arpeggio and decorative patterns, for one or two harps.
- R46 [ALLOWED] Rare effects that were not standard by 1955 [era: 1955]:
  - plectrum;
  - pedal portamento (moving the pedal after plucking, so the pitch slides);
  - a strip of paper woven between the strings, giving a muted, harpsichord-like sound;
  - Carlos Salzedo's effects, which Piston names only: falling hail, thunder effects, xyloflux, xylharmonic and xylophonic sounds, tam-tam and snare-drum-without-snares sounds, fluidic and "esoteric" sounds.
- R47 [ALLOWED] Most symphony orchestras have two harps, and scores call for two more often than one. The second adds richness and volume, and makes chromatic harmony easier by splitting pedal settings between the two players.
- R48 [ALLOWED] Large-score harp counts [era: late-Romantic/early-20th-c. large orchestra]: Stravinsky's *Firebird* 3, Schoenberg's *Gurrelieder* 4, Wagner's *Götterdämmerung* 6.

**Agent applicability**
- In chromatic music, write two harp tracks and give each passage to the harp whose pedal set already holds its pitches (inferred practice from R47).
- Use 2 harps for a full Romantic sound and 1 for classical-size or chamber scoring.

**Tags:** #orchestration/harp/accompaniment #orchestration/harp/effects #orchestration/section-size

## The Cimbalom (scan s169L–s169R, printed p.338–339)

**Concepts**
- Cimbalom (címbalo húngaro; It. *cimbalo ongarese*): the modern form of the ancient dulcimer. A trapezoidal box, laid flat, with metal strings struck in various ways by wooden or leather mallets. Some instruments have a damper pedal. Native to Hungarian gypsy orchestras, where it is played virtuosically and improvisationally.

**Rules**
- R49 [ALLOWED] The cimbalom is rare in the orchestra and is used for its highly individual timbre and idiom, often with Hungarian/folk connotation (inferred).
- Works using it (pointer): Bartók, Rhapsody No. 1 for violin and orchestra; Kodály, *Háry János* Suite; Stravinsky, *Renard* and *Ragtime*.

**Tags:** #orchestration/plucked-struck/cimbalom #orchestration/colour

## Ch. 18 Keyboard Instruments — the piano: roles (scan s170L–s170R, printed p.340–341)

**Concepts**
- Piano (Fr. *piano*; It. *pianoforte*; Ger. *Klavier*; Sp. piano). Treated here as an orchestral instrument on a par with harp or flute, not as a solo instrument.
- Five ways the piano relates to the orchestra:
  - (a) continuo-style support [era: 18th c. "maestro at the harpsichord" realizing figured bass and keeping the ensemble together; died out in the early 19th c. as conducting developed];
  - (b) the piano concerto, where the orchestra accompanies a visiting soloist placed at the front (Mozart, Beethoven);
  - (c) "Piano and Orchestra" works, where the soloist is prominent but the orchestra is an equal partner and the piano sometimes acts orchestrally: Beethoven Concerto 4 slow movement, d'Indy *Symphony on a French Mountain Air*, Falla *Nights in the Gardens of Spain* (piano sometimes seated inside the orchestra);
  - (d) the piano as a regular orchestral member, anonymous [era: 20th c. only], e.g. Copland *Appalachian Spring*;
  - (e) the piano in the small orchestra [era: 20th c.], e.g. Stravinsky, Suites for small orchestra.

**Agent applicability**
- Orchestral piano (roles d/e) is a 20th-c. sound. Leave it out of Classical/Romantic pastiche except as a concerto soloist.

**Tags:** #orchestration/piano/roles #style/20th-century

## Piano: orchestral uses (scan s170R–s171R, printed p.341–343)

**Rules**
- R50 [PREFER] The piano's main orchestral use is doubling. Its percussive attack makes any group more incisive (strings, woodwinds, brass, percussion) in every register.
- R51 [PREFER] The high piano register adds brilliance to upper woodwinds, e.g. piccolos up to the top note C8 (MIDI 108) (Ex. 361).
- R52 [ALLOWED] The right hand can supply strong upper partials an octave above a left-hand line that doubles winds (Ex. 362).
- R53 [AVOID] Piano doubling sustained legato parts. *Why:* its sound decays. [PREFER] Keep the piano part moving in fairly short values.
- R54 [PREFER] Piano doubling pizzicato strings is fully idiomatic.
- R55 [AVOID] Loud low-register staccato on the piano when the pitch matters. *Why:* upper partials stand out unduly, giving a metallic tone that disguises the pitch. It is worse on a small piano.
- R56 [ALLOWED] Piano combined with violins *col legno* is an especially happy blend (Ex. 364).

**Examples**
- Ex. 361 Copland, Symphony No. 3 (Allegro molto, ff *non legato*): 8va figures rising to the piano's top note, doubled by 2 piccolos. The left hand doubles 3 oboes and Vln II, and Vln I + xylophone fill the octave between.
- Ex. 362 Martinů, Symphony No. 4 (Allegro vivo, 6/8, f): right hand an octave above the left hand, as upper partials. The left hand doubles 2 oboes + trumpet, and a bassoon plays an octave below.
- Ex. 363 Shostakovich, Symphony No. 5 (quarter = 92, f): staccato octave figures in the low/deep bass register. Placed after the warning on low loud staccato (what exactly it is cited for is [?]).
- Ex. 364 Copland, Symphony No. 1 (Molto allegro, 3/4): the piano plays repeated accented 8th-note pairs in both hands, p *non leggiero*. Vln II divisi interlock with it *col legno*, p, and Oboe I has the melody, mf *ritmico*.

**Agent applicability**
- To sharpen attacks, add a piano track doubling the line (pizz strings, woodwind staccato, xylophone) at moderate velocity.
- For brilliance, double piccolo/flute lines in the piano's top octave (C7–C8, MIDI 96–108).
- Don't double long pads on piano. Avoid loud staccato below about C2 (MIDI 36) when pitch clarity matters (threshold inferred).

**Tags:** #orchestration/piano/doubling #orchestration/doubling #orchestration/colour

## Piano: solo passages and percussion (scan s171R–s172R, printed p.343–345)

**Rules**
- R57 [ALLOWED] The orchestral piano can deliver imitative thematic figures alone, like any instrument. It also gets important solo parts, sometimes virtuosic, though no more than is expected of other modern orchestral players.
- R58 [ALLOWED] The piano can carry the theme over a sustained or repeated background (Ex. 366).
- R59 [ALLOWED] Dissonant low-register chords are used for percussive rhythmic effects (Ex. 367).
- R60 [ALLOWED] A piano tremolo can be combined with bass drum and timpani rolls. The example is on p.346, outside this range.

**Examples**
- Ex. 365 Stravinsky, *Petrushka* (Allegro, mf → f): solo piano. Rapid two-hand arpeggio sweeps in 32nds and tuplets of 7 and 10 climb to the top register, the hands interlocking.
- Ex. 366 Stravinsky, *Symphony in Three Movements* (quarter = 80, mp, *semi legato*, left hand *poco marcato*): the piano carries the theme over repeated 16ths in 3 horns, while the strings lightly mark certain melodic notes.
- Ex. 367 Bartók, *Dance Suite* (Moderato, 2/4, *sempre martellato*, f/sf, dim.): dense dissonant chords, cluster-like, in the low/middle bass register, in repeated 8th-note rhythms.

**Agent applicability**
- For percussive drive in a 20th-c. idiom, write low-register dissonant piano chords (about C2–C4, MIDI 36–60, inferred) in a rhythmic ostinato. Double them with timpani or bass drum rolls for a tremolo climax.

**Tags:** #orchestration/piano/solo #orchestration/piano/percussive #orchestration/percussion
