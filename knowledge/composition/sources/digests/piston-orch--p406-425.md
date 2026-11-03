---
source_id: piston-orch
source_title: Walter Piston, *Orchestration* (W. W. Norton, 1955)
source_era: "1955; mid-20th-c. American orchestral practice (repertoire Haydn to Stravinsky/Copland)"
scan_pages: s203L-s212R
printed_pages: 406-425
chapters: ["Ch. 25 (number inferred) Complex Texture — end: Ex. 405 scheme, Ex. 406 Strauss, Ex. 407 Bartók, Ex. 408 Stravinsky", "Part Three: Problems in Orchestration", "Ch. 26 Orchestration of Melody — intro, Problem 1 strings, Problem 2 woodwinds, Problem 3 brass (start)"]
continues_from: "Complex Texture (Ch. 25, inferred number); range opens mid-analysis of Ex. 405 (work not visible in this range)"
continues_into: "Orchestration of Melody (Ch. 26), Problem 3 (melody for brass), after Fig. 134 on mixed brass doublings"
---

# Piston, *Orchestration* — scans s203L–s212R (printed p.406–425)

Blank pages skipped: s206L (p.412), s207L (p.414). s205L (p.410) is the Ex. 408 score. s206R (p.413) is the Part Three
title page only. Pitch numbers: C4 = MIDI 60, concert pitch unless marked "written".

Texture vocabulary used below (Piston's classification is defined before this range; listed here from the
book's known scheme, inferred, not re-read): type I orchestral unison, II melody and accompaniment, III
secondary melody, IV part writing, V contrapuntal, VI chords, VII complex texture (textura compleja).

## Complex texture: layout of Ex. 405 (scan s203L, printed p.406)

**Concepts**
- Element (elemento): one functional strand of a texture (melody, its harmonizing parts, secondary melody, scale, bass), carried by one or several instruments. Piston writes a texture as a list of elements and the instruments on each, with "8[" brackets for octave doublings.

**Examples**
- Ex. 405 (work named on an earlier page, not visible here), distribution:
  - A, melody harmonized in part writing: a melody = trp I + cl I–II, with hn I + trb I an octave below; b, harmonizing parts = hn II–IV, trp II, trb II.
  - B, secondary melody = picc + fl, with ob I–II an octave below.
  - C, descending scale = vn I / vn II / va / vc, each an octave below the last (4 octaves).
  - D, sustained (tenuto) bass = bn I + trb III, then bn II + tuba + half the d-b an octave lower, then the other half of the d-b another octave lower.
- The horn and trombone do not keep their octave doubling of the melody all the way. The six-part weave is free: the parts sometimes stop being independent (trp II and hn III coincide in mm.1–2).
- Elements A, B and C carry different dynamic markings.

**Rules**
- R1 [PREFER] In a dense tutti, give each element its own instrument group and its own register band. Double the melody at the octave in brass (trumpet above, horn + trombone below). *Why:* keeps four simultaneous elements separable.
- R2 [ALLOWED] Split the double-basses in half to put the bass in two octaves (½ d-b with tuba, ½ d-b an octave lower).
- R3 [PREFER] Mark different dynamics per element rather than one dynamic for the whole orchestra. *Why:* this is how Piston's examples rank the elements.
- R4 [ALLOWED] Let the octave doubling of a melody drop out for part of the phrase, and let inner harmonizing parts merge for a few notes. Free part writing does not need strictly independent voices.

**Agent applicability**
- Model a tutti as a list of elements → instruments → octave offsets, and give each element its own CC1/velocity level. The melody element gets the highest level.

**Tags:** #orchestration/texture/complex #orchestration/doubling/octave #orchestration/balance

## Complex texture: two combined textures, Strauss (scan s203R–s204L, printed p.407–408)

**Examples**
- Ex. 406, Strauss, *Symphonia Domestica* (score p.24, "Ziemlich lebhaft"). Two type-II (melody + accompaniment) textures run together. They share thematic material but differ in meter, rhythm and character. Texture I is notated in 4/4 (C) with long espressivo lines. Texture II is notated in 6/8 with staccato, leggiero sixteenth figures.
  - Texture I: melody = ob d'amore, English horn, hn I–II, vn I, va (ff espress.). Accompaniment = cl I–II, hn III–VI, vn II.
  - Texture II: melody = ob I–II, D clarinet, A clarinet (m.1), fl I–II (from m.2). Accompaniment = bn I–IV, timpani, vc (div.), d-b (repeated staccato notes, mf leggiero).
  - A secondary melody enters in texture II at m.4 (fl III, clarinet). The Bb clarinets join texture I's melody at m.5.
  - Texture I sounds large and full; texture II is heard as background.
  - Neither melody is doubled at the octave, except in mm.4–5 (ob II), where the two lines lie farther apart.

**Rules**
- R5 [PREFER] When two textures run at once, separate them by tone colour (warm double reeds + horns + strings vs. bright high woodwinds), by pitch level, and by rhythm or meter. *Why:* the orchestration then carries the musical duality.
- R6 [ALLOWED] Write two simultaneous meters (4/4 against 6/8) in different groups when the textures should stay apart.
- R7 [PREFER] Leave both melodies undoubled at the octave when they lie close together. Add an octave doubling only where the lines are far apart. *Why:* octave doublings would blur the two lines into each other (inferred reason).
- R8 [PREFER] Make one texture the foreground (more instruments, louder, legato) and the other a lighter background (staccato, leggiero, fewer players).

**Tags:** #orchestration/texture/complex #orchestration/texture/melody-accompaniment #composers/strauss

## Complex texture: canonic layers, Bartók (scan s204R, printed p.409)

**Examples**
- Ex. 407, Bartók, *Concerto for Orchestra* (B&H p.116, Presto). Two contrapuntal textures. Each is built from canonic entries (entradas en canon) one measure apart, and they contrast in rhythm and tone colour:
  - Texture 1: fl I–II and ob I–II enter one after another with repeated staccato notes and grace-note turns, at f.
  - Texture 2: harp I and harp II enter hand by hand with chromatic sixteenth-note figures, at f.
  - The overall texture is sparse.
  - In mm.1–2 the oboes double only the first three notes of each flute entry.
  - The clarinets (a2) are doubled in m.5 because their register there is weak and they sit among many voices.
  - Muted horn (con sord.) enters at m.6.

**Rules**
- R9 [ALLOWED] Reinforce only the head of an entry (its first 2–3 notes) with a second instrument. *Why:* this marks where each canonic entry starts without thickening the whole line.
- R10 [MUST] Double (a2 or with another instrument) a line that lies in its instrument's weak register when it sits in the middle of many voices. *Why:* otherwise it is covered.
- R11 [PREFER] Build a canonic layer from one instrument family (harps; flutes and oboes) so that each layer stays a single colour.

**Agent applicability**
- For a canon texture, offset the entries by one bar per instrument, and give the first 2–3 notes of each entry a doubling track or a velocity boost.

**Tags:** #orchestration/texture/contrapuntal #orchestration/texture/canon #orchestration/harp #composers/bartok

## Complex texture: "tapestry of sound", Stravinsky (scan s204R–s205R, printed p.409–411)

**Concepts**
- Complex texture of the second kind: an ensemble of many elements, none of which is primary. The ear moves from detail to detail. Piston repeats the description of it as a "tapestry of sound" (tapiz sonoro).

**Examples**
- Ex. 408, Stravinsky, *Le Sacre du Printemps* (Introduction, ed. Russe p.9). 31 instrumental parts.
  - Woodwind is in large numbers. Flute I–II, ob II–III and cl II use flutter-tongue (Flatterzunge, frullato). The alto flute (fl in G) holds a trill. The D clarinet is marked *très en dehors* (very prominent).
  - The bassoons and contrabassoons play triplet figures with grace notes.
  - Hn III–IV play short figures; D trumpet is muted.
  - Five violas play a harmonic glissando on the C string (glissando sul Do).
  - Two solo celli: one pizz., one muted and sustained. Six solo d-b: I–III hold a muted (sord.) chord, IV–V sustain, VI plays pizz.
- Piston ranks the elements (by his own account a debatable order; he invites disagreement):
  - A D cl
  - B ob I alternating with D trp
  - C cl I
  - D English horn
  - E picc I+II as one line
  - F fl I, ob II–III, cl II (later alto fl)
  - G bn II–III, cbn I–II, hn III–IV, vc I, d-b VI
  - H fl II, cl III, va (similar function)
  - I bass cl
  - J alto fl, later joined by solo vn
  - K vc II, d-b I–V (held chord)
- The held d-b chord is plainly subordinate, and the bassoon figure works as accompaniment. Even so, a melody/accompaniment reading does not describe the effect.
- Every motive in the passage was introduced in the previous pages, so the listener already knows them.

**Rules**
- R12 [ALLOWED] Use a complex "tapestry" texture to evoke a special atmosphere or extramusical ideas (Piston also cites Honegger, *Pacific 231*), or as a background for one or more superimposed melodies.
- R13 [PREFER] Introduce the motives of a tapestry texture separately before stacking them. *Why:* familiar figures keep a dense web from turning into noise.
- R14 [PREFER] Even in a tapestry, group the many parts into a smaller number of elements (11 elements from 31 parts here). Give each element a distinct colour or technique (flutter-tongue, harmonics, pizz., muted).

**Agent applicability**
- For a "primeval / nature / machine" atmosphere, write 8–12 short ostinato-like cells across solo woodwinds and solo strings with staggered entries and varied techniques. Assign distinct CC levels but no single dominant line.

**Tags:** #orchestration/texture/complex #orchestration/techniques/flutter-tongue #orchestration/strings/harmonics #composers/stravinsky #composers/honegger

## Part Three: Problems in Orchestration; Ch. 26 Orchestration of Melody, introduction (scan s206R–s207R, printed p.413–415)

**Rules**
- R15 [PREFER] Judge orchestration by analogy with similar passages in real scores, or by actual performance. Singing or piano tests cannot verify an orchestration. *Agent note:* render and measure instead (inferred).
- R16 [AVOID] Using piano music as the first material to orchestrate. *Why:* the piano pedal's sustain has no simple orchestral equivalent and poses near-insoluble problems.
- R17 [PREFER] For every melody, find many solutions and compare them, not just the first obvious one or two. The obvious solutions are not always the best.

**Concepts**
- Three overlapping categories of solution: (a) normal or natural, the most important and the hardest; (b) unusual or novel, worth exploring; (c) strange or grotesque, the easiest and usually a sign of ineptitude.

**Tags:** #orchestration/method #orchestration/melody

## Problem 1: melody for strings (scan s208L–s209R, printed p.416–419)

**Examples**
- Fig. 122: the test melody. Andante espressivo, 9/8, mf, legato with hairpins. It runs about A3–E5 (MIDI 57–76), from C4–A3 up through chromatic steps to E5, then down to G#4 [range read from figure].

### Solution without doubling

**Rules**
- R18 [MUST] Hear the melody mentally on each string instrument, first at written pitch and then transposed by octaves. Other intervals are also possible, e.g. a fifth lower changes its effect on viola or cello.
- R19 [ALLOWED] Violins or violas at the given pitch: entirely suitable.
- R20 [AVOID] D-b playing the melody as written, which sounds an octave lower (A2–E4): possible but very unusual, even strange.
- R21 [PREFER] D-b written an octave lower (sounding A1–E3, MIDI 33–52) is a good bass range, but sounds better with cellos doubling an octave above.
- R22 [ALLOWED] Change the colour without doubling by reducing the number of players in a section or by using solo players.

### Unison doubling (doblaje al unísono)

**Rules**
- R23 [ALLOWED] Possible string unisons: vn I+II, vn I+va, vn I+vc, vn II+va, vn II+vc, va+vc, vn I+II+va, vn I+II+vc, vn I+va+vc, vn II+va+vc.
- R24 [AVOID] Cellos in unison with violins or violas in this register (about C4–E5). *Why:* cello high notes on the A string are intense and contrast with the other instruments' tone.
- R25 [PREFER] When a viola doubles a line whose top lies on its A string, mark the upper half *sul D* (sul Re). *Why:* this avoids the penetrating sound of the viola A string.
- R26 [PREFER] Use vn I + vn II in unison, with or without violas, for breadth and power, especially to keep a melody on top against a full background. Adding violas gives warmth and tone-weight (peso sonoro).

### Octave doubling (doblaje a la octava)

**Rules**
- R27 [PREFER] The most common string octave pairs (upper/lower) are vn I/vn II, vn I/va, vn I/vc, va/vc, va/d-b and vc/d-b. For this melody the first two need vn I an octave above the given pitch (Fig. 123a: vn I from C5, vn II from C4).
- R28 [PREFER] Va at pitch + vc an octave lower is the ideal octave pair for this melody (Fig. 123b: va from C4, vc from C3).
- R29 [AVOID] Va + d-b at the octave when the bass part would lie too high for the d-b.
- R30 [ALLOWED] Vc an octave lower + d-b two octaves lower (Fig. 123c: vc from C3, d-b sounding from C2).
- R31 [AVOID] Inverting the natural pitch order of the strings (va above vn, vc above va, even vn II above vn I) unless you want a special effect. Piston counts it as an unusual arrangement.

### Two or more octaves

**Rules**
- R32 [ALLOWED] Two-octave stacks, each part an octave apart: vn I/vn II/va; vn I/vn II/vc; vn I/va/vc; va/vc/d-b.
- R33 [ALLOWED] vn I/vn II/va puts vn I in its extreme high range (melody up to E6, MIDI 88), with an ethereal effect.
- R34 [PREFER] Spread a line over two octaves to enrich the tone. It also makes the expression more impersonal.
- R35 [ALLOWED] Leave out the middle octave (vn I and vc two octaves apart, Fig. 124a: vn I from C5, vc from C3) to strengthen the impersonal quality and give an impression of aloofness.
- R36 [ALLOWED] Octave doublings can span three and four octaves. Fig. 124b stacks vn I/vn II/va/vc. Fig. 124c stacks vn I, vn II, va, vc and d-b down to C2 [exact octaves of the top parts read from a small figure, ?].

### Divisi and mixed unison + octave

**Rules**
- R37 [ALLOWED] Divide vn II (vn II div.) across both octaves to preserve balance when vn I and va play the two octaves (Fig. 125a).
- R38 [ALLOWED] Emphasize the lower octave with a unison doubling: vn I div. on both octaves plus va on the lower (Fig. 125b).
- R39 [ALLOWED] Accent the upper octave the same way: vn I + vn II on the upper octave, va on the lower (Fig. 125c).

**Agent applicability**
- String melody default: vn I (+ vn II unison) at pitch for power. For warmth, use va + vc in octaves.
- Check every cello note above about A4 in a unison with violins or violas and avoid it.
- When one octave of a doubled line sounds thin, add a unison partner (divisi) on that octave rather than raising its CC.

**Tags:** #orchestration/strings/melody #orchestration/doubling/unison #orchestration/doubling/octave #orchestration/strings/divisi

## Problem 2: melody for woodwinds (scan s209R–s212L, printed p.419–424)

**Examples**
- Fig. 126: the test melody. Vivo, 2/4, f, staccato eighths, a sixteenth-note figure, accents and slurs. It spans about an octave starting on Bb4, roughly Bb4–Bb5 (MIDI 70–82) [top note read from a small figure, ?].

**Concepts**
- Standard orchestra assumed for all problems: woodwinds in threes (the third player of each family on the auxiliary instrument: piccolo, English horn, bass clarinet, contrabassoon), 4 horns, 3 trumpets, 3 trombones, tuba, harp, percussion and strings.

**Rules**
- R40 [PREFER] Keep the whole orchestra in mind, including the instruments that are not playing. *Why:* it builds a sense of the orchestra as one instrument.

### Solution without doubling: per-instrument observations for this melody

- R41 Piccolo (sounds 8va: Bb5–Bb6): good as written. Another octave higher is too shrill except in large combinations.
- R42 Flute: comparatively gentle in this range (Bb4–Bb5). Better an octave higher.
- R43 [PREFER] Oboe: excellent range and style. Its staccato and accents are better than the flute's. Also usable an octave lower (Bb3–Bb4), but rather rough.
- R44 English horn (written a 5th higher): too high at the given pitch. Better an octave lower, and less in character than the oboe.
- R45 Clarinet in Bb (written a major 2nd higher): good range and style, especially for the sixteenth-note figure. Its staccato is a little heavier than the oboe's. Good an octave lower too, but quieter.
- R46 Bass clarinet: too high at pitch. Possible an octave lower, better two octaves lower (sounding Bb2–Bb3, MIDI 46–58). Good style, but its staccato is a little slow. Write the part in both French and German notation (see Piston Ch. 9). [era: dual bass-clarinet notation, treble written a 9th vs. a major 2nd above sounding]
- R47 [PREFER] Bassoon: excellent an octave lower (Bb3–Bb4), with a sharp, dry staccato that fits. Two octaves lower is playable but subdued; three octaves lower is possible but sluggish.
- R48 [AVOID] Contrabassoon on a fast staccato melody (written two octaves lower, it sounds three octaves lower: Bb1–Bb2, MIDI 34–46). It speaks slowly. Omit notes and give it only the accents and slurred notes (mm.2–4).

### Unison doubling

**Rules**
- R49 [ALLOWED] Unison doubling creates mixed timbres (timbres mixtos). It matters more in woodwinds than in strings, because woodwind colours and registers differ much more.
- R50 [PREFER] Know that a unison of two players adds less than it seems. They reinforce each other, but each cancels part of the other's intensity, and two of the same kind give somewhat less than twice the tone-weight and carrying power of one.
- R51 [AVOID] Unisons for the most expressive solo lines. *Why:* the subtle expressive fluctuations of one player are largely destroyed when two play together.
- R52 [ALLOWED] Use unisons for dynamic reinforcement and for new colours. In a mixed unison, which colour dominates changes through the phrase as the relative intensities change.
- R53 [ALLOWED] Woodwind unison pairs to know: picc+fl, picc+ob, picc+cl, fl+ob, fl+EH, fl+cl, fl+bass cl, fl+bn, ob+EH, ob+cl, ob+bass cl, ob+bn, EH+cl, EH+bass cl, EH+bn, cl+bass cl, cl+bn, bass cl+bn, bass cl+cbn, bn+cbn. Unisons of three or more are also possible.
- R54 [NEVER] Double at a pitch an instrument cannot reach. In this problem oboe and clarinet cannot double the piccolo's sounding octave (Bb5–Bb6), unless the clarinet climbs to written high C (C7, sounding Bb6 = MIDI 94). The flute cannot play the melody an octave lower because of the opening Bb3 (below flute low C4 = 60).
- R55 [PREFER] For a rhythmic staccato melody: ob + cl at pitch is best; cl + bn in the octave below; fl + picc in the high octave.
- R56 [AVOID] Contrabassoon combinations for a fast staccato melody.

### Octave doubling

**Rules**
- R57 [PREFER] Treat woodwind octave doubling as equalizing registers to keep the two octaves balanced. Two instruments of the same kind often do not balance an octave apart, because their registers differ. Piston calls this a caution, not a rule: it depends on the instrument, the pitch and the dynamic.
- R58 [AVOID] Two flutes at C4/C5 (60/72). The low C4 is weak, so the octave is uneven. B4/B5 (71/83) on two flutes balances well. On E5/E6 (76/88) the upper note is much more brilliant than the lower.
- R59 [ALLOWED] Flute + piccolo on the same written note give a clean octave (the piccolo sounds 8va from the same fingering).
- R60 [AVOID] Two oboes at C4/C5. Opposite to the flutes, the low C4 is the stronger note.
- R61 [ALLOWED] Two oboes at A4/A5 (69/81) are in good balance.
- R62 [PREFER] For an oboe octave on C4/C5, put the English horn on the lower note (written G4, sounding C4) instead of a second oboe. *Why:* it balances much better.
- R63 [PREFER] For a melody spanning an octave in woodwind octaves, these pairs work: ob over bn, cl over bass cl, fl over cl (Fig. 128, upper part at or above the given pitch, lower an octave below).
- R64 [PREFER] Keep woodwinds in their natural pitch order: fl above ob above cl above bn. Normal arrangements usually conform. Violations are common in scores because the ranges overlap.
- R65 [ALLOWED] Inverting the order (cl above ob, bn above bass cl; Fig. 129) is an "unusual/novel" arrangement, acceptable when the balance works.
- R66 [ALLOWED] Doublings spanning two or more octaves (Fig. 130a: fl, ob, cl and bn stacked in octaves).
- R67 [ALLOWED] For special effect, two instruments two or more octaves apart (Fig. 130b: piccolo high and bass clarinet low, with the middle empty).
- R68 [PREFER] Combine unison with octave doubling to add strength, to stress a particular register, or to correct a balance spoiled by register differences. In Fig. 130a, doubling the clarinet and especially the bassoon with other instruments would improve the balance (the bassoon is at the greatest disadvantage).

**Agent applicability**
- Before doubling, check each octave pair against these balance facts. Flute low register (C4–about F4) is weak; oboe low register (Bb3–about D4) is strong and coarse.
- Raise CC/velocity on the weak member, or add a unison partner to it, rather than lowering the strong one.
- The bassoon at the bottom of a four-octave woodwind stack needs a unison partner (bass cl or horn, inferred).

**Tags:** #orchestration/woodwinds/melody #orchestration/doubling/unison #orchestration/doubling/octave #orchestration/balance #orchestration/woodwinds/registers

## Problem 3: melody for brass (scan s212L–s212R, printed p.424–425)

**Examples**
- Fig. 131: the test melody. Maestoso, 3/4, f to più f. Repeated A4s with dotted rhythms, a run of repeated staccato Eb5s, an accented descent from Gb5. Range about G4–Gb5 (MIDI 67–78).

### Solution without doubling

**Rules**
- R69 [ALLOWED] Trumpet: good range as written. An octave lower (G3–Gb4, 55–66) is playable, but the first two measures (around A3–D4) are too low for good effect.
- R70 [AVOID] Horn at the given pitch (too high). Good an octave lower (G3–Gb4). Two octaves lower (G2–Gb3) is possible but too low to sound well alone.
- R71 [PREFER] Trombone: good an octave lower. Two octaves lower is also good but less appropriate.
- R72 [ALLOWED] Tuba: an octave lower suits only the euphonium. The F bass tuba is good two octaves lower (G2–Gb3, 43–54). Three octaves lower (G1–Gb2, 31–42) works only inside heavy sonorities. [era: F tuba as the standard bass tuba]

### Unison doubling

**Rules**
- R73 [PREFER] Two or three trumpets in unison are excellent. They are generally better than an octave doubling with the third trumpet placed below.
- R74 [ALLOWED] Two, three or four horns on the same part. With the melody two octaves lower, hn II and IV would play it in unison (the low-horn players).
- R75 [PREFER] One octave below the given pitch is a good range for three trombones in unison.
- R76 [PREFER] Unison of horns and trombones is effective and normal.
- R77 [ALLOWED] Hn IV can double the tuba two octaves below the given pitch.

### Octave doubling

**Rules**
- R78 [ALLOWED] Same-instrument brass octaves (Fig. 132: trp I/II, trb I/III, hn I/II) are slightly uneven because of register differences, but their attacks match.
- R79 [AVOID] Octaves of different brass on a rhythmic melody (Fig. 133: trp over trb, hn over trb, trb over tuba). *Why:* the articulation of slides (trombone) and valves differs audibly; the horn is slow to speak; the horn has less tone-weight than its companions.
- R80 [PREFER] Hide these attack and weight differences by adding unison doublings and mixed timbres to each octave (Fig. 134):
  - (a) trp I–II on the melody; trp III + trb I an octave below.
  - (b) hn I, III + trb I an octave below the melody; hn II, IV + trb III two octaves below.
  - (c) 3 trp on the melody; hn I, III + trb I–II an octave below; hn II, IV + trb III two octaves below; tuba lowest [tuba octave read from figure, ?].

**Agent applicability**
- Brass melody: put the trumpets in unison at pitch and trombones (+ horns) an octave below.
- Never leave a lone horn line in octave with trombones on a rhythmic part. Pair the horns with trombones in unison.
- Start horn notes slightly earlier than trombone/trumpet notes, or soften the trombone attacks, to cover the horn's slower speech (inferred).

**Tags:** #orchestration/brass/melody #orchestration/doubling/unison #orchestration/doubling/octave #orchestration/brass/articulation #orchestration/horn
