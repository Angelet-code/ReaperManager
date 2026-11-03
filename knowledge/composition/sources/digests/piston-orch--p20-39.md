---
source_id: piston-orch
source_title: Walter Piston, Orchestration (W. W. Norton, 1955)
source_era: "1955; mid-20th-c. American orchestral practice (repertoire Haydn to Stravinsky/Copland)"
scan_pages: s010L-s019R
printed_pages: 20-39
chapters: ["Ch.1 Stringed Instruments (general; chapter number inferred) — accents, color effects, pizzicato, harmonics, trills, tremolo, détaché, mutes, scordatura", "Ch.2 The Violin (opening: construction, fingering, finger articulation)"]
continues_from: "Ch.1 Stringed Instruments (general techniques, bowing section)"
continues_into: "Ch.2 The Violin"
---

# Piston, Orchestration — printed p.20–39 (scans s010L–s019R)

Pages 38 (plate: drawing of the violin) and 36 bottom half are non-content. Nothing in this range belongs
to the horn chapter.

## Ch.1 Stringed Instruments — accents (printed p.20)

**Concepts**
- Accent shapes (Fig. 10), as envelopes of one bowed tone:
  - `>` / `^` (acento): hard attack, then the tone continues at a steady, lower level.
  - *sf* (sforzando): quick rise to a peak just after the attack, then decay to a sustained level (diamond-then-line shape).
  - *fp* (forte-piano): loud block at the onset, then an abrupt drop to soft, held.
  - `< >` (swell, regulador): tone grows and shrinks within the note.
- Fig. 9 shows an accent on the second of two slurred notes (a: C5→B4, b: B4→C5) [?]: accent applies inside a slur (inferred: the accent is made by bow pressure, not a bow change).

**Rules**
- R1 [PREFER] Treat accents as relative to the prevailing dynamic of that note (an accent in *p* is still soft). *Why:* author states accents are relative to the general nuance.
- R2 [PREFER] Choose the accent type deliberately; composers often wrote them interchangeably (pianistic habit), leaving the conductor to decide. (inferred for agents: pick one envelope per accent rather than one generic velocity bump.)

**Agent applicability**
- `>`: higher velocity + CC1/CC11 settling to the base level within ~1/8 beat. *sf*: short CC rise peaking after the onset, then decay. *fp*: high velocity, CC1/CC11 drop to *p* within ~0.1–0.2 beat. `< >`: CC11 arch over the note. (inferred mapping)

**Tags:** #orchestration/strings #performance/accents #midi/cc-dynamics

## Ch.1 — Effects of color: sul tasto, sul ponticello, col legno (printed p.20–23)

**Concepts**
- Sul tasto (sur la touche, sulla tastiera, am Griffbrett; flautando-like): bow over the upper end of the fingerboard where string amplitude is greater; very soft, floating tone.
- Sul ponticello (au chevalet, am Steg): bow very close to or on the bridge; brings out upper partials not normally heard; "glassy, metallic".
- Modo ordinario / naturale: cancels sul tasto or sul ponticello.
- Col legno: strings struck (or drawn) with the wood of the bow. *Col legno battuto* (geschlagen) = tapped; *col legno tratto* (gestrichen) = wood drawn across the string. *Arco* cancels col legno.

**Rules**
- R3 [AVOID] Heavy bow pressure in sul tasto: the bow may catch more than one string.
- R4 [ALLOWED] Sul tasto marked for passages climbing high on the violin E string, even though the body curve makes it physically impractical there; players read it as a tone-quality request.
- R5 [PREFER] Combine sul ponticello with bowed tremolo; that is its usual setting.
- R6 [MUST] Mark modo ordinario/naturale (or arco after col legno) where the effect ends; MIDI analog: switch the articulation back explicitly.
- R7 [PREFER] Use col legno (battuto) for dry, percussive off-string staccato effects.
- R8 [AVOID] Expecting volume from col legno tratto: friction of wood is tiny, sound is faint. Col legno tremolo and legato exist in scores but are rare; Mahler footnoted his Sym. 1 to say they were not a misprint.
- R9 [era: mid-20th c.] Col legno is "not common" but better known by 1955 than before.

**Examples**
- Ex.18 Debussy, *Rondes de printemps*: cellos divided, sur la touche, *p*, "avec charme", rubato — soft floating divisi cello melody in thirds/sixths.
- Ex.19 Strauss, *Symphonia Domestica*: violas divided in 3, muted, *pp*, sul ponticello tremolo chords — glassy sustained harmony.
- Ex.20 Britten, *Peter Grimes* Passacaglia: Vn I, Vn II, Va col legno, *p (con forza)* cresc. to *mf*, accented off-beat eighths — percussive agitated rhythm in three string sections.
- Ex.21 Mahler, Sym. 1 (slow mvt): Vn I divided in 3 equal parts, col legno, *pp*→*ppp*, accented slurred figures — col legno as soft rattling color.

**Agent applicability**
- Load the library's sul tasto / sul pont / col legno patch or keyswitch; sul pont usually as tremolo patch. Keep col legno parts rhythmic and short; do not rely on them for melody or loudness.

**Tags:** #orchestration/strings #technique/sul-tasto #technique/sul-ponticello #technique/col-legno

## Ch.1 — Pizzicato (printed p.23–28)

**Concepts**
- Pizzicato (pizz.): string plucked by the right first finger over the fingerboard; continues until *arco*.
- Cello and bass may pluck with the thumb, especially chords arpeggiated upward.
- Left-hand pizzicato: marked with `+` over/under the note; possible when a free finger can pluck, or a finger plucks as it lifts off a stopped note.
- Quasi guitarra: rapid repeated pizz chords strummed back and forth, directions shown by arrows or down/up-bow signs.
- Snap pizzicato (Bartók pizz.), sign ⦶ (circle with a vertical line): string pulled so it strikes the fingerboard.
- Other new pizz effects (rare in 1955): pizz sul ponticello, pizz sul tasto, pizz harmonics, picking with the fingernail near the nut.

**Rules**
- R10 [MUST] Leave time to switch arco→pizz; how much depends on bow position. After a down-bow ending at the point, allow a larger gap; after an up-bow ending at the heel, the switch can be nearly instant.
- R11 [PREFER] Pizz→arco is slightly more awkward than arco→pizz (bow must be repositioned), but per-bar alternation is common in practice (Ex.22, Ex.23).
- R12 [MUST] Treat pizz as staccato: the sound decays quickly. Do not write long pizz notes expecting sustain.
- R13 [PREFER] Expect longer pizz ring on larger/heavier strings (double bass > violin) and on open strings; vibrato slightly prolongs stopped pizz.
- R14 [ALLOWED] Pizz in high positions sounds hard and dry; use it on purpose for a brittle color (Ex.24).
- R15 [AVOID] Long, fast, continuous pizz passages, especially loud ones, on large instruments, or with many string crossings. Speed is limited because one finger plucks; alternating two fingers is not a universal skill.
- R16 [MUST] Expect 3- and 4-note pizz chords to be arpeggiated bottom-up unless marked otherwise.
- R17 [ALLOWED] Minimize the spread with a sharp sudden stroke; two notes can be plucked simultaneously with two fingers (marked by a straight bracket, "non arpegg.", "avec 2 doigts").
- R18 [PREFER] Fast repeated pizz chords: alternate stroke direction (quasi guitarra).
- R19 [ALLOWED] Vary pizz tone by plucking point and force, from gentle fingertip to snap.

**Examples**
- Ex.22 Debussy, *Pelléas et Mélisande*: Vc and Db, *pp*, alternating pizz and arco within each bar, "sourdement agité" — quick switching at soft level.
- Ex.23 Berlioz, *Harold in Italy* (Allegro frenetico): Va, Vc, Db alternate pizz chords *f* with arco slurred eighths *mf* every half bar — the "not uncommon" pizz/arco activity.
- Ex.24 Ravel, *Daphnis et Chloé* ("animé et très rude"): Vn I divided with very high pizz, Vn II and Va divided double-stop pizz, *mf* — dry high-position pizz.
- Ex.25 Dukas, *L'Apprenti sorcier* (Vif, dotted quarter = 126, 3/8): Va and Vc in continuous eighth-note pizz, *mf*→*p*, cresc. at the end — successful fast pizz at a rapid tempo, kept in middle register with simple string crossings.
- Ex.26 Stravinsky, *Symphony in C*: Vn I/II switch quickly from bowed figures to pizz with `+` (left-hand pizz) notes, *sf*.
- Ex.27 Ravel, *L'Enfant et les sortilèges*: 4 violins and 4 violas, *p*, pizz chords in sixteenths with alternating down/up strokes — quasi guitarra.
- Ex.28 Stravinsky, *Ragtime* (quarter = 160): Vn I/II pizz chords marked "non arpegg.", "avec 2 doigts", then arco — unarpeggiated two-finger pizz.
- Ex.29 Bartók, *Violin Concerto* (Vivace, quarter ≈ 140): all five string sections snap pizz on repeated quarters and eighths, *mf* — snap pizz as tutti rhythmic color.

**Agent applicability**
- Pizz notes: short `len` (decay is in the sample); velocity carries dynamics (CC1 usually ignored).
- Before a pizz passage in a part that also plays arco, leave at least ~1 beat of rest at moderate tempo unless deliberately quick (R10); for a single track with keyswitches, the switch needs no real time, but the written part should still respect it.
- Fast pizz (eighths at ≥ 126 dotted-quarter in 3/8 ≈ 6 notes/s) is the practical upper area for sections; prefer middle register and few string crossings (inferred from Ex.25).
- Pizz chords: stagger note starts bottom-up by ~10–25 ms for realism, or keep them aligned for "non arpegg." (inferred).
- Very high violin pizz → brittle; for warm pizz use low/middle register, cellos and basses.

**Tags:** #orchestration/strings #technique/pizzicato #technique/bartok-pizz #articulation/keyswitch

## Ch.1 — Harmonics: natural (printed p.29–30)

**Concepts**
- A string vibrates in partials with frequency ratios 1:2:3:4:5…; points of no motion are nodes (nodos).
- On the violin G string (Fig. 12): partial 1 G3 (MIDI 55, 196 Hz), 2 G4 (67, 392 Hz), 3 D5 (74, 588 Hz), 4 G5 (79, 784 Hz), 5 B5 (83, 980 Hz).
- Timbre (timbre) = number and relative strength of partials; the fundamental dominates, so partials are not heard as a chord.
- Natural harmonic (armónico natural; sons harmoniques, armonici, Flageolettöne): touching an open string lightly at a node suppresses the fundamental and sounds the partial of that node. Example: touch the G string at 1/3 (or 2/3) of its length → sounds D5 (partial 3).
- Notation: (a) small circle over the sounding note, or (b) diamond notehead at the touch point on the string. Fig. 13 shows partials 2–5 on the G string with alternative touch points [?: exact diamonds partly cut off in scan].
- String indication: *sul G* (G-Saite) = play all on the G string; French use Roman numerals, I = highest string (IVe corde = G on violin).

**Rules**
- R20 [PREFER] Use harmonics for their distinct, pure, flute-like color (only partials sharing the node sound), not as ordinary notes. (color description partly inferred)
- R21 [MUST] When a passage should stay on one string for color, mark the string (sul G / IV); MIDI analog: choose a sul G / single-string patch if available.

**Agent applicability**
- Natural harmonics on violin G string sound only 55·(partials) set: 67, 74, 79, 83 (plus higher). Analogous series on other open strings (inferred).

**Tags:** #orchestration/strings #technique/harmonics #acoustics/partials

## Ch.1 — Artificial harmonics; notation (printed p.30–31)

**Concepts**
- Artificial harmonic (armónico artificial): first finger stops a note (new fundamental), fourth finger lightly touches a perfect fourth (5 semitones) above → 4th partial sounds, two octaves (24 semitones) above the stopped note. Violin and viola use fingers 1+4; cello uses thumb + third finger.
- Natural harmonics = open string as fundamental; artificial = stopped note as fundamental.
- Notation: (a) circle over the sounding note; (b) stopped note as normal notehead + diamond a P4 above; (c) (b) plus the sounding pitch above in small notes. Fig. 14: stopped Bb [Bb3?] with diamond Eb a fourth above → sounds Bb two octaves higher [Bb5?].

**Rules**
- R22 [PREFER] Use the "touched fourth" artificial harmonic; it is the most dependable node. Sounding pitch = stopped pitch + 24 semitones.
- R23 [ALLOWED] Writing only the sounding pitch with a circle (a) is common; the player chooses natural or artificial production.
- R24 [ALLOWED] Writing (b) with an open string as the lower note is technically incorrect but understood.

**Agent applicability**
- To write a violin/viola harmonic at MIDI n, check that n − 24 is a playable stopped note on that instrument; in MIDI write the sounding pitch n on a harmonics patch.

**Tags:** #orchestration/strings #technique/harmonics

## Ch.1 — Trills (printed p.31)

**Rules**
- R25 [ALLOWED] Major and minor trills (half step 1 or whole step 2 semitones) are good in all ranges of all string instruments.
- R26 [AVOID] Trills on the lowest note of the instrument (open string alternating with a stopped note): less effective than trills on stopped notes.
- R27 [PREFER] Remember a section trill is played by many players at once (e.g. 16 first violins): rhythmically unsynchronized, less clear than the same trill on a solo wind (e.g. flute 1). Use section trills for shimmer, solo instruments for articulate trills.

**Agent applicability**
- Avoid trills from the open bottom string: violin G3 (55), and by analogy viola C3 (48), cello C2 (36) (inferred). For a crisp trill, give it to a solo wind or a solo string; section string trills = texture.

**Tags:** #orchestration/strings #technique/trill

## Ch.1 — Tremolo: fingered and bowed (printed p.32–34)

**Concepts**
- Fingered tremolo (trémolo de dedos): alternation of two notes more than a major second (> 2 semitones) apart, slurred in one bow.
- Measured tremolo (trémolo medido): alternation at a stated rhythmic speed (e.g. 16ths, 32nds) vs. an unmeasured "real" tremolo as fast as possible.
- Undulating-bow tremolo: when the interval exceeds the left-hand stretch on one string, the notes are held as a double stop and the bow rocks between two strings; less clear than a fingered tremolo (no finger articulation).
- Bowed tremolo (trémolo de arco): rapid up/down bow strokes on a held note or notes; a characteristic orchestral effect with great dynamic range and accent variety.

**Rules**
- R28 [MUST] For an unmeasured tremolo, write values fast enough to guarantee it, or mark *tremolo*/*tremolando*. Slurs are needed to show fingered tremolo is legato in one bow.
- R29 [ALLOWED] Split a fingered-tremolo interval across divided players (each half sustaining one note) so both notes sound at each bow change (Ex.30, Vn I bar 1).
- R30 [PREFER] Fingered tremolo only within one-string stretch; otherwise expect the undulating double-stop version (softer articulation).
- R31 [PREFER] Use bowed tremolo for dynamic swells, accented chords and intensity in any register.

**Examples**
- Ex.30 Debussy, *Prélude à l'après-midi d'un faune*: Vn I, Vn II, Va each divided, sur la touche, *pp* with hairpins, fingered tremolos in 32nds — soft shimmering divisi tremolo bed.
- Ex.31 Brahms, Sym. 1 (finale intro, Più Andante): Vn I and II muted, *pp*, mixed measured fingered tremolos (sextuplets, 32nds) — some on one string, some needing two strings; all playable as double stops with undulating bow.
- Ex.32 Debussy, *La Mer*: full strings (Vc div.) with accented *sfz>* chords then *p e molto dim.* sustained chords, Vn I/II briefly pizz then arco — bowed-tremolo chord texture with accent variety [?: tremolo slashes hard to read in scan].

**Agent applicability**
- Unmeasured tremolo = tremolo patch/keyswitch, dynamics via CC1; measured fingered tremolo = actual alternating notes in the given rhythm on a legato or short patch.
- Fingered tremolo intervals: keep ≤ about a fourth on one string (inferred from "limit of extension"); wider → write as two notes held in divisi or a tremolo patch on both notes.

**Tags:** #orchestration/strings #technique/tremolo #texture/pad

## Ch.1 — Détaché (printed p.34)

**Rules**
- R32 [PREFER] Use continuous separate bow strokes (détaché) on runs of notes to add energy and volume to string tone; idiomatic orchestral writing.

**Examples**
- Ex.33 Mozart, Symphony K.543 (Allegro, *f*): Vn I and II in unison, continuous 16th/eighth détaché runs — energetic unison violin passage.

**Agent applicability**
- Energetic unison runs: violins I+II in unison on a détaché/short-sustain patch, notes not overlapped, velocity ~90–110 at *f* (inferred).

**Tags:** #orchestration/strings #technique/detache #doubling/unison

## Ch.1 — Mutes (printed p.35)

**Concepts**
- Mute (sordina): three-pronged clamp (wood, metal, bone…) on the bridge that absorbs vibration.
- Indications: on = con sordina/sordino, pl. sordine/sordini (avec sourdines; mit Dämpfer, gedämpft); off = senza sordini (sans sourdines; ohne Dämpfer) or via sordini (ôtez les sourdines; Dämpfer weg).

**Rules**
- R33 [PREFER] Use mutes for their distinct tone color; the color change matters more than the volume loss.
- R34 [AVOID] Using mutes as the main way to get soft strings: a fine *pp* is possible unmuted.
- R35 [ALLOWED] Muted strings at *forte* are a valid special effect.
- R36 [MUST] Allow time to put mutes on or take them off: at least a couple of bars in moderate tempo; more is better. [era: 1955 — spring-clip and permanent mutes existed but were not fully accepted.]
- R37 [ALLOWED] Gradual transition to muted tone: mutes put on one player or one desk at a time, with a point marked where all are muted.

**Agent applicability**
- Switching between con sord and normal patches: leave ≥ 2 bars rest in that part at moderate tempo. For a gradual change, crossfade from normal to con sord patch over several bars (inferred).

**Tags:** #orchestration/strings #technique/mute

## Ch.1 — Scordatura (printed p.35–36)

**Concepts**
- Scordatura: retuning strings away from normal tuning.

**Rules**
- R38 [AVOID] Retuning more than a minor second (1 semitone): strings lose tone quality.
- R39 [AVOID] Scordatura only to extend the low range (basses, cellos): disruption of retuning outweighs the gain. Rare cases: Strauss, *Don Quixote* (solo viola C string → B2, MIDI 47); Casella, *Partita* (cellos similar).
- R40 [ALLOWED] Scordatura for tone color: Mahler Sym. 4, 2nd mvt, solo violin tuned all strings up a whole tone (2 semitones) to sound like a cheap fiddle; the concertmaster uses a second instrument to avoid retuning.

**Agent applicability**
- Keep orchestral string MIDI within normal open-string bottoms; one semitone lower only as a deliberate scordatura (e.g. viola B2 = 47). For a harsh "folk fiddle" solo, a brighter/edgier solo violin patch is the analog.

**Tags:** #orchestration/strings #technique/scordatura

## Ch.2 The Violin — construction (printed p.37)

**Concepts** (violín; violon, violino, Violine)
- Overall length 23⅜ in; body 14 in; neck just under 5¼ in; sounding string length (nut to bridge) just over 12¾ in; bow 29 in.
- Belly pine/spruce, back maple; ebony tailpiece, fingerboard, nut, pegs. Bass-bar under the G-string side; sound post near the E-string side of the bridge (support and vibration transfer); f-holes either side of the bridge.

**Tags:** #orchestration/instruments/violin

## Ch.2 The Violin — fingering and finger articulation (printed p.37–39)

**Concepts**
- Held between chin and left shoulder (chin rest left of tailpiece); left hand free to shift along the fingerboard; elbow far right so fingers fall nearly perpendicular.
- Fig. 15: G-string scale G3 (open, 0) A3 (1) B3 (2) C4 (3) D4 (4) and back: ascending, each finger drops and stays down; descending, fingers lift one by one.
- In one legato bow, ascending notes are articulated by striking (finger drop), descending notes by lifting.

**Rules**
- R41 [PREFER] Expect finger-drop (ascending) notes to articulate more clearly than lift (descending) notes within a slur (inferred from text).
- R42 [ALLOWED] Finger action ranges from very energetic strokes (Ex.34) to extremely light, fleet articulation (Ex.35); choose by character.

**Examples**
- Ex.34 Schumann, Sym. 2 (Allegro molto vivace): Vn I then Vn II (canonic entry a bar later) with *sf* long notes launching fast slurred ascending scales up to the high register — energetic finger strokes.
- Ex.35 Mendelssohn, *Italian* Symphony (Presto, *pp*): Vn I fast slurred eighth-note figures in middle register — light, fleet finger articulation.

**Agent applicability**
- Fast slurred violin runs: legato/fast-legato patch; ascending runs with *sf* starts for energy, *pp* light runs at low CC1 (~30–45) with short overlaps (inferred).
- Violin lowest note G3 = MIDI 55 (open G string, Fig. 12/15).

**Tags:** #orchestration/instruments/violin #technique/fingering #performance/articulation
