---
id: form.sacred-vocal-forms
title: Sacred vocal forms — chorale, motet, Mass, cantus firmus
aliases: [música religiosa, coral, motete, misa, Kyrie, Gloria, Credo, Sanctus, Benedictus, Agnus Dei, réquiem, misa brevis, canto llano, canto gregoriano, canto firme, cantus firmus, antífona, responsorio, salmo, himno, secuencia, Magnificat, alternatim, Choral, Messe]
domain: form
tags: [sacred, chorale, motet, mass, cantus-firmus, choir]
style_scope: renaissance-baroque
use_when: When writing a chorale harmonisation, motet, Mass movement, cantus-firmus texture or antiphonal choir piece.
summary: Chorale = 4-part, melody in soprano, one text line per phrase with a fermata and cadence at each line end. Motet = a chain of imitative points, one per text phrase, no musical return unless the text repeats. Mass = Kyrie (ternary Kyrie–Christe–Kyrie) – Gloria – Credo (long texts, syllabic) – Sanctus+Benedictus (paired) – Agnus Dei (may recall the Kyrie); keep sober style, soloist/choir and monophony/polyphony alternations.
sources: ["zamacois-formas p.253-268 (§252-273)"]
related: ["[[imitation-and-canon]]", "[[fugue]]", "[[song-aria-recitative]]", "[[cadences]]", "[[_harmony]]"]
---

# Sacred vocal forms

## Rules
- R1 `PREFER` Keep traditional alternations: soloist vs choir (or small vs large choir), monophony vs
  polyphony; organ preferred over orchestra (§252).
- R2 `PREFER` Sober, elevated style; avoid operatic effects and secular tunes (§257).
- R3 `MUST` Officiant's intonations (e.g. "Gloria in excelsis Deo", "Credo in unum Deum") are plainchant,
  unaccompanied, and excluded from the composition; the choir enters after them (§254, §270).
- R4 `ALLOWED` Cantus firmus: chant (or chorale) in long equal notes in one voice, passing between voices
  (soprano → tenor), or fragmented as thematic material, while other voices imitate in faster values (§255).
- R5 `MUST` Chorale melody: long values, phrase = text line, **fermata at each line end** (§258).
- R6 `ALLOWED` Chorale treatments: (a) 4-part, nearly note-against-note, melody on top; (b) melody as cantus
  firmus in complex polyphony; (c) organ chorale alternating ornamented melody lines with free paraphrase,
  beginning and ending with free material; (d) chorale as fugue subject (§259).
- R7 `MUST` Motet: each text phrase gets its own motif, exposed successively by the voices (imitative point —
  the ancestor of the fugal exposition); no musical return unless the text repeats a concept (§263).
- R8 `PREFER` Use each successive chant phrase as the subject of each motet section (§263).
- R9 `MUST` Mass Ordinary order: Kyrie – Gloria – Credo – Sanctus (with Benedictus) – Agnus Dei (§269).
  Missa brevis (Lutheran) = Kyrie + Gloria; Requiem omits Gloria and Credo (§272).
- R10 `MUST` Kyrie text is threefold (Kyrie ×3, Christe ×3, Kyrie ×3) → ternary A–B–A' (§270).
- R11 `PREFER` Gloria and Credo: long texts — few word repetitions and melismas, sectional by text; be more
  lavish in the shorter later movements (§270).
- R12 `ALLOWED` Kyrie and Agnus Dei may share themes, or the Kyrie music may return (§270).
- R13 `PREFER` Sanctus + Benedictus treated as one unit (Hosanna often repeated after the Benedictus) (§270).
- R14 `MUST` Service music must fit the ceremony in style and duration (§273).

## Planning template (short Mass, choir SATB + organ)
| movement | sections | key | texture | ends with |
|---|---|---|---|---|
| Kyrie | Kyrie (A) – Christe (B) – Kyrie (A') | I – vi/V – I | A imitative, B soloists/homophonic | PAC I |
| Gloria | 4–6 text sections (Laudamus, Qui tollis slow, Quoniam, Cum Sancto fugato) | I, IV, vi, I | mostly syllabic homophony | PAC I |
| Credo | Credo – Et incarnatus (slow, hushed) – Crucifixus (minor) – Et resurrexit (fast) – Et vitam (fugato) | I, i/vi, I | syllabic, text painting | PAC I |
| Sanctus–Benedictus | Sanctus (broad) – Hosanna (fast) – Benedictus (soloists, lyrical) – Hosanna repeat | I, IV/V, I | contrast tutti/solo | PAC |
| Agnus Dei | 3 invocations, last "dona nobis pacem" (may reuse Kyrie) | i → I | slow → calm | PAC/plagal |
Section breakdown of Gloria/Credo is general knowledge of the texts.

## Apply in MIDI / REAPER
- Chorale: 4 tracks SATB (S 60–79, A 55–74, T 48–67, B 40–60), one chord per melody note (quarter notes),
  fermata = lengthen the last chord of each line ×2 (or insert a tempo-marker slowdown); cadence each line
  (PAC, HC, or IAC) — see [[cadences]].
- Cantus firmus: one track with whole notes (len 4 in 4/4), other voices imitating a short motif in
  halves/quarters/8ths.
- Antiphonal choirs: two choir tracks panned L/R alternating phrases, uniting (octave doublings, vel +15) on
  the refrain.

## Checklist
- Chorale: melody in soprano, fermata and cadence at every line end, 4 real parts?
- Motet: new imitative point for each text phrase, overlapping cadences, no unmotivated return?
- Mass: movement order and text structure (threefold Kyrie) respected; intonations left to the celebrant?
