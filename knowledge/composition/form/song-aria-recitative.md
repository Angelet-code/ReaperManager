---
id: form.song-aria-recitative
title: Secular vocal forms — song, Lied, madrigal, aria, recitative, opera numbers, cantata/oratorio
aliases: [canción, canción popular, coplas, coplas y estribillo, estrófica, Lied, madrigal, aria, aria da capo, arieta, arioso, cavatina, romanza, recitativo secco, recitativo acompañado, dúo, terceto, concertante, ópera, leitmotiv, cantata, oratorio, ritornello, strophisch, durchkomponiert]
domain: form
tags: [vocal, song, aria, recitative, opera, strophic, text-setting]
style_scope: baroque-romantic
use_when: When setting words - strophic or verse-refrain songs, an aria, a recitative, an opera/oratorio scene - and you need the form and the role of each number.
summary: Songs are strophic (one melody per stanza, repeated) or verse + refrain (coplas y estribillo); the Lied serves the text and may use any form. Opera/oratorio alternate recitative (speech-like, no phrase structure, carries the action, chord support) with closed numbers that comment - da capo aria A–B–A' (ornamented return), two-part slow–fast aria, duets, and a big concertato ensemble at act ends; leitmotifs are transformed, not repeated.
sources: ["zamacois-formas p.236-252 (§220-251)"]
related: ["[[ternary-form]]", "[[binary-form]]", "[[sacred-vocal-forms]]", "[[form-for-modern-songs]]", "[[thematic-development]]", "[[cadences]]"]
---

# Secular vocal forms

## Rules — song and Lied
- R1 `MUST` Popular song: equal stanzas; the music covers **one stanza** and repeats for each; harmony may
  repeat or vary (§223).
- R2 `ALLOWED` Coplas y estribillo: changing verses + a repeated refrain (the origin of the rondo) (§223).
  This is the ancestor of verse–chorus form ([[form-for-modern-songs]]).
- R3 `ALLOWED` Folk word stress may clash with metric stress — idiomatic in that style only (§223 fn).
- R4 `PREFER` Lied (art song): music serves the poem; accompaniment intensifies the words; any form —
  strophic, varied strophic, ternary Lied (§224–225).
- R5 `PREFER` Choral folk-song arrangement = decorative variation: same melody each stanza, new harmony or
  counterpoint each time (§226 fn).
- R6 `MUST` Madrigal (16th c.): a cappella, secular poem, music depicts the text closely; form follows the
  text; short varied motifs (§230).

## Rules — dramatic music
- R7 `MUST` Opera = chain of delimited numbers unified by an overall idea (recitative and aria, duet,
  cavatina, romanza, ensemble) (§244); Wagnerian music drama drops set numbers (§236–243).
- R8 `MUST` Recitative: free key course, **no phrase/period structure**, as close to speech as possible
  (§245). Secco = voice almost free in rhythm over sustained chords that fix keys and cadences; it carries the
  plot. Accompagnato = measured, orchestra comments the text (§245).
- R9 `MUST` Da capo aria (A. Scarlatti): A (virtuosic) – B (simpler vocally, richer harmony, contrasting key)
  – A **ornamented**; orchestral ritornello on the main motif as intro (and between sections) (§246).
- R10 `ALLOWED` Two-part aria: slow expressive part → fast bravura part; recitative before or between (§246).
- R11 `ALLOWED` Arietta = short aria; arioso = recitative turning into song; cavatina = lighter aria or
  entrance aria; romanza = sentimental song, ternary or strophic (§247–249).
- R12 `PREFER` Concertato ensemble (all soloists + chorus + orchestra) at the **end of an act** (§251).
- R13 `PREFER` Leitmotif: tie a 2–4-bar motif to a character/idea and transform it (rhythm, harmony, tempo,
  counterpoint) instead of literal repetition (§236–243).
- R14 `MUST` Cantata/oratorio: non-staged; choruses as pillars, recitatives narrate, arias/duets reflect,
  orchestra throughout; cantata shorter, one feeling (§233–235).

## Planning templates
Strophic / verse–refrain song (bar counts general knowledge):
| section | bars | key | material | ends with |
|---|---|---|---|---|
| Intro (ritornello) | 2–8 | I | refrain or accompaniment motif | V |
| Stanza (copla) | = lines × 2 bars (e.g. 4 lines → 8) | I (→V) | verse melody | HC or PAC in V |
| Refrain (estribillo) | 8 | I | refrain melody, fuller texture | PAC I |
| … repeat per stanza | | | varied accompaniment | |
| Postlude | 2–8 | I | intro material | PAC |

Da capo aria:
| section | bars | key | material | ends with |
|---|---|---|---|---|
| Ritornello | 4–12 | I | main motif, orchestra | PAC I |
| A | 20–40 | I → V → I | vocal theme, coloratura | PAC I + short ritornello |
| B | 12–24 | vi or iii (relative; gk) | contrasting, simpler line | PAC in that key (or HC) |
| A' (da capo) | = A | I | A with improvised ornaments | PAC, cadenza on I6/4 opt. |

## Apply in MIDI / REAPER
- Syllable grid: one note per syllable (syllabic) unless a melisma is intended; stressed syllables on strong
  beats (except folk idiom R3).
- Secco recitative: voice in 8th/16th speech rhythm, small range (≤ a 6th), harpsichord/strings hold chords
  that change only at commas and cadences; close each sentence with V–I (often after the voice ends).
- Ornamented da capo: duplicate A, add passing notes, turns, a cadenza on the final I6/4.
- Act finale (concertato): stack all voices + chorus + tutti, vel 100–120.

## Checklist
- Strophic: does every stanza fit the same melody (syllable counts match)?
- Recitative: free, speech-like, chordal support, cadence at sentence ends?
- Aria: B contrasts in key and texture; A' ornamented?
- Text stresses aligned with strong beats?
