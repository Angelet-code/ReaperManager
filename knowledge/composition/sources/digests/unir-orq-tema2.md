---
source_id: unir-orq-tema2
source_title: "UNIR Instrumentación y Orquestación — Tema 2: Cómo orquestar una obra"
scan_pages: 1-17
printed_pages: 1-17
chapters: ["2.2 Planificación inicial: análisis", "2.3 Preparación de la plantilla orquestal", "2.4 Organización de líneas instrumentales", "2.5 Comprobaciones de conjunto"]
continues_from: null
continues_into: null
---

# UNIR Instrumentación y Orquestación, Tema 2: scans 1–17

Topic: a step-by-step method for orchestrating a piano piece. Pitch convention: C4 = MIDI 60.
Skipped: 2.1 study instructions, "Lo + recomendado"/"+ Información" (p.11–14), test (p.15–17).

## 2.2 Initial planning: analysis (scan p.4–6)

**Concepts**
- Prior analysis of the piano score covers: form, discursive lines (líneas discursivas), register/tessitura
  (tesitura) and spacing/layout (factura).
- Analysis order: top-down, from the largest formal units (phrase and its blocks) to the smallest motivic
  cells (rhythmic and/or melodic).
- Three discursive lines (tres líneas discursivas) found in most piano and orchestral writing: **melody
  (melodía), bass (bajo), filler (material de relleno)**. Orchestrating = identifying these in the original
  and assigning each to instruments.
- Texture of the original: homophonic or contrapuntal. In counterpoint watch how the lines combine; in
  accompanied melody watch the melody/accompaniment relation. Simple textures must be recognised first
  before complex/contrapuntal ones.
- Factura ancha (wide spacing): large register span between low and high lines.
- Factura estrecha (narrow spacing): small span between low and high lines.

**Rules**
- R1 [MUST] Reproduce the piano's register layout (tessitura of each voice and overall spacing) as faithfully
  as possible in the orchestra.
- R2 [MUST] Realise a crescendo by progressively adding instruments; a diminuendo by gradually removing
  them (the sound thins naturally).

**Examples**
- Adagio in F major/D minor (Fig. 1–3): melody in upper staff (dotted, ornamented); filler = repeated
  8th-note chords in mid register; bass = half notes. Both staves in treble clef = narrow factura.

**Agent applicability**
- Before writing MIDI, tag each source voice as melody / bass / filler; each tag becomes an instrument group.
- Measure the source span (lowest bass to highest melody note, in semitones) and keep the orchestral span
  similar unless deliberately widening.
- Implement crescendo as staggered entries of extra tracks (plus CC dynamics), not only as CC1/CC11 ramps.

**Tags:** #orchestration/method #texture/melody-bass-filler #orchestration/spacing #dynamics/crescendo

## 2.3 Preparing the line-up (preparación de la plantilla) (scan p.6–7)

**Rules**
- R3 [MUST] Step 1: assign clef and key signature to every instrument, transposing instruments' signatures
  derived from the original key (see Tema 1).
- R4 [MUST] Step 2: "sound elaboration" (elaboración sonora): imagine, then decide which element of the
  original sounds in which instrument and how each small element fits the whole, "like tesserae in a mosaic".

**Examples**
- Orchestra a dos template (Fig. 4) for a piece in F major (1 flat): Flute, Oboe (1 flat); Clarinet in Bb
  (1 sharp, i.e. G major); Bassoon (1 flat, bass clef); Horn in F (treble, no signature); Timpani (bass);
  Violin I, Violin II, Viola (alto clef), Cello, Double bass (all 1 flat).

**Tags:** #orchestration/line-up #notation/transposition

## 2.4 Organising instrumental lines (organización de líneas instrumentales) (scan p.7–9)

**Rules**
- R5 [NEVER] Invent notes, articulations, dynamics, sections or phrases not in the original (in an
  orchestration of an existing piece).
- R6 [MUST] Assign each line to an instrument or group according to its range (tesitura), agility and sound
  possibilities.
- R7 [MUST] Mark strings correctly: ordinary, divisi (div.) or double/triple/quadruple stops (only if
  playable); pizzicato (pizz.) vs arco.
- R8 [MUST] Mark winds correctly: unison (a2, a3), player numbers I., II., III., or two voices on one staff
  with opposite stems.
- R9 [ALLOWED] Octave doubling (octavación / doblajes) of one line across several instruments.
- R10 [ALLOWED] Combining/sharing one line between several instruments, **but** AVOID fragmenting motives or
  leaving lines cut or incomplete.
- R11 [MUST] Each instrumental line carries its own dynamics and articulations, as detailed as possible and
  faithful to the original.
- R12 [MUST] Tempo is marked once for all (or twice: above woodwinds and above strings).
- R13 [AVOID] Horror vacui: not every instrument must play all the time; density depends on texture and form.

**Concepts**
- Orchestration = sound imagination + orchestration technique.
- Orchestration = instrumental clarity + discursive clarity.
- Instrumental errors (errores instrumentales), per instrument: unplayable notes; impossible leaps or
  tremolos; notes out of range; extreme notes that only speak at forte; etc.
- Discursive errors (errores discursivos), ensemble-level: cut/incomplete lines; phrases badly split
  between instruments; truncated phrase endings; **forte arrivals with few instruments; piano arrivals with
  many instruments**.

**Agent applicability**
- Lint pass per track: every note inside the instrument's range; extremes only at matching dynamics
  (e.g., highest notes not at pp) (inferred from "extreme notes only in forte").
- Lint pass across tracks: a phrase handed from one instrument to another must overlap or join at a
  phrase/motif boundary, never mid-motif; count active tracks at cadential arrivals vs. target dynamic.

**Tags:** #orchestration/method #orchestration/doubling #orchestration/errors #strings/divisi #winds/a2

## 2.5 Ensemble checks (comprobaciones de conjunto) (scan p.9–10)

**Rules (final checklist)**
- R14 [MUST] Every part correctly written and transposed, with its clef and key signature.
- R15 [MUST] Every part within its range and, if possible, in its ideal register within the ensemble.
- R16 [MUST] Every line has its dynamics and articulations.
- R17 [MUST] Woodwind and string notation correct (a2/I./II., div./unis., pizz./arco).
- R18 [MUST] Each phrase coherent instrumentally (no cut or incomplete lines).
- R19 [MUST] Check both vertical (chords/sonority) and horizontal (each instrument's line) dimensions.
- R20 [MUST] The melody must stand out; it must not be covered by excessive octave-doubling of bass or filler.
- R21 [MUST] Crescendi/diminuendi carried by the instrumentation itself.
- R22 [MUST] Balance between melody, filler and accompaniment.
- R23 [MUST] Compare the global sonority with the original.

**Examples**
- Fig. 6 (the same Adagio, orchestra a dos): bar 10–11 violin I melody over string chord (tremolo), fermata;
  then melody moves to **Oboe I (from F5) doubled by Bassoon I in a lower register, both mf** (the bassoon
  staff looks copied from the oboe with only the clef changed, so the exact doubling interval is [?];
  intended as octave doubling (inferred)); filler = repeated staccato
  8th-note chords in Vln I, Vln II, Vla at **mp**; bass = half notes in Vc + Cb at **mp**. Flute, clarinet,
  horn, timpani rest.

**Agent applicability**
- Default balance recipe from Fig. 6: melody one dynamic level above accompaniment (mf vs mp); filler as
  short repeated chords in upper strings; bass in Vc + Cb (Cb an octave below).
- A wind melody can be thickened by doubling at a lower octave with a contrasting wind (oboe + bassoon)
  (inferred from Fig. 6).

**Tags:** #orchestration/checklist #orchestration/balance #texture/accompanied-melody
