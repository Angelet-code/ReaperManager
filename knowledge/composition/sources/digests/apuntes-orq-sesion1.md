---
source_id: apuntes-orq-sesion1
source_title: "Apuntes de orquestación — Primera sesión (+ PDF1 'La orquesta en la actualidad')"
scan_pages: 1-6 (Primera sesión) + 1 (PDF1)
printed_pages: null
chapters: ["1A La orquesta en la actualidad. Balances", "1B Claves", "1C Instrumentos transpositores", "1D Partitura general y partes", "2 Secciones: violín, viola"]
continues_from: null
continues_into: "2. Secciones en la orquesta (notes stop after the viola)"
---

# Apuntes de orquestación, Primera sesión + PDF1: scans 1–6 + 1

**Octave convention warning:** these class notes name pitches with **middle C = C3** (violin strings
"G2-D3-A3-E4"). Everything below is converted to **C4 = middle C = MIDI 60**. Staff figures were read directly.
PDF1 is in English (a table); PDF2–PDF4 (transposition chart, parts, score) are only referenced, not included.

## 1A The orchestra today: size and balance (la orquesta en la actualidad, balances) (scan p.1–2; PDF1)

**Concepts**
- Two factors set the size of an orchestra or section: (1) **volume** (more players = louder) and
  (2) **type of sound**: adding players changes the quality and eventually the *kind* of sound (a horn section
  vs a solo horn line; one violin vs six violins in unison are different sounds, not just louder).
- Live/old-school sessions: the main issue is volume (brass/woodwinds must not cover strings, rarely the
  reverse). Modern sessions often record section by section (or sub-section), so balance is fixed later in the
  mix, as long as each room recording is internally balanced.
- Too-small string sections sound **thin**, then like **a few soloists** on one line, and also **out of tune**
  (even top players struggle to match pitch with only 3–4 per part).
- The bigger the instrument, the louder it sounds (basis for the ratios below).

**Balanced string-orchestra proportions (table, scan p.2)** (Vln I / Vln II / Va / Vc / Cb):

| Type of sound | Vln I | Vln II | Va | Vc | Cb |
|---|---|---|---|---|---|
| Soloist | 1 | 1 | 1 | 1 | 0–1 |
| Thin | 5 | 4 | 3 (4) | 2–3 | 1 |
| Thin | 6 | 5 | 4 (5) | 3–4 | 1 |
| Mid-thin | 7 | 6 | 5 (6) | 4 | "1/3" [?, likely 1–3] |
| Mid-thin | 8 | 7 | 6 (7) | 5 | 3 |
| Mid | 9–12 | 8–10 | 7–8 (8–10) | 6–7 | 4 |
| Symphonic orchestra | 13–16 | 11–14 | 9–12 (11–14) | 8–10 | 5–7 |
| Full orchestra | 17–20 | 15–18 | 13–16 (15–18) | 11–14 | 8–10 |

Viola numbers in parentheses carry a footnote that is not visible [?]; presumably an alternative larger
viola count (inferred).

**What N players of one part sound like (PDF1; "all numbers approximate")**
- Violins: 1 = soloist. 2 = very hard to tune together; two soloists, not a section. 3 = still three
  soloists; use only in an emergency, in the 2nd violins. 4 = starts to sound like a very thin section but
  individual players still audible. 5–7 = minimum to sound like a section (thin, players no longer
  distinguishable). 8–11 = good mid-size. 12–15 = symphonic. 16–20 = full orchestra.
- Violas: 1 = soloist. 2 = two soloists, usable in an emergency (rounder, lower sound than two violins).
  3 = very thin section, players still audible. 4 = minimum to sound like a section (thin). 5–7 = section
  (thin). 8–11 mid; 12–15 symphonic; 16–20 full.
- Cellos: 1 = soloist. 2 = usable (less bad than 2 violins or 2 violas: rounder, lower). 3 = very thin
  section. 4 = bare minimum section sound; thin but players comfortable. 5–7 = section (thin). 8–11 mid;
  12–15 symphonic; 16–20 full.
- Double basses: 1 = soloist; also good reinforcing the cello line at the same octave or an octave below.
  **2 = strongly NOT recommended** (hard to tune, sounds like two basses, not much bigger). 3 = bare minimum
  section sound, players start to be comfortable. 4 = minimum section sound. 5–6 = good bass section.
  7–8 = symphonic bass section. 9–10 = full-orchestra bass section. More = too many.

**Rules**
- R1 [MUST] Size sections for both loudness and the intended *type* of sound (solo vs section timbre).
- R2 [AVOID] 2–3 players per string part when a section sound is wanted: thin, soloistic and out of tune.
- R3 [NEVER] Use exactly 2 double basses; use 1 (soloist/reinforcement) or ≥ 3.
- R4 [PREFER] Proportions Vln I ≥ Vln II > Va > Vc > Cb, roughly decreasing by 1–2 players per part
  (e.g. symphonic 14/12/10/9/6), since bigger instruments sound louder.

**Agent applicability**
- Choose string-library patches by target count: solo patch for 1–3 players per part, chamber/small-section
  patch for ≈4–8, full section for ≥ 9 (inferred mapping from the table).
- Never stack two "solo" patches in unison to fake a section (they read as two soloists).
- A single solo-bass patch can reinforce the cello line at unison or an octave below.

**Tags:** #orchestration/balance #strings/section-size #orchestration/recording #samples/patch-choice

## 1B Clefs (claves) (scan p.2–3)

**Concepts**
- A clef names every line/space of the staff. Several clefs keep most notes inside the staff, reduce 8va/8vb
  lines and help identify instruments in a large score.

**Clef table (scan p.3)**
- Treble (G clef, 2nd line): violin, flute, trumpet, (guitar, footnote [?]).
- Bass (F clef, 4th line): cello, bassoon, trombone.
- Alto (C clef, 3rd line): viola.
- Tenor (C clef, 4th line): upper register of cello, bassoon, trombone.
- Percussion (neutral, "3rd line"): all unpitched percussion.

**Tags:** #notation/clefs

## 1C Transposing instruments (instrumentos transpositores) (scan p.3–4)

**Concepts**
- Transposing instrument: notation doesn't show absolute pitch; when the player reads C, a constant interval
  above or below sounds. Named after the note sounding when C is written (Bb clarinet: written C sounds Bb,
  a major 2nd (2 st) below).
- Historical reason: the lowest/fully-open-tube note of a wind instrument was called C, so the player keeps the
  same fingering for the same written notes across sizes of one family (e.g. switching Bb → A clarinet with no
  fingering change).
- Second reason, register: the transposition plus the instrument's clef shows the best register.

**Rules**
- R5 [PREFER] Notes that fall inside the staff (in the instrument's written clef/transposition) are in a good
  register; notes outside generally are not. *Exceptions:* flute and piccolo, violins, and the high cello
  register are good above the staff.

**Agent applicability**
- Register sanity check: convert the sounding MIDI note to the written note and flag notes far outside the
  staff, except for fl/picc/vln/high vc (inferred implementation of R5).

**Tags:** #notation/transposition #orchestration/register

## 1D Score and parts (partitura general y partes) (scan p.4)

**Concepts**
- After orchestration two document types are needed: full score and parts. Both keep a fixed set of
  consistent features so information is found fast, which is crucial in time-limited recording sessions
  (details in PDF3/PDF4, not included). Reference text: Samuel Adler, *The Study of Orchestration*.

**Tags:** #notation/parts #orchestration/recording

## 2 Sections: strings (secciones en la orquesta, cuerda) (scan p.5–6)

### Violin (violín)

**Concepts**
- Held between chin and shoulder; smallest string. Bright, lyrical, clear, powerful; warms as one moves up the
  fingerboard toward the bridge.
- Open strings G3 D4 A4 E5 (MIDI 55 62 69 76).
- Orchestral range: **G3 (55) to about E7 (100)**; solo/chamber may go higher depending on the player.
- Per-string comfortable span (figure, "tension" grows toward the top of each span): G string G3–G4;
  D string D4–D5; A string A4–A5; E string E5–E6, extended (in parentheses) to about G6–A6.

**Rules**
- R6 [AVOID] Going beyond 6th–7th position (≈ G6–A6, MIDI 91–93) normally.
- R7 [PREFER] Stay within the first octave of each string (G3–G4, D4–D5, A4–A5, E5–E6). *Why:* toward the bridge
  intonation gets harder and power and accuracy are progressively lost.
- Roles: two violin sections. Vln I usually "soprano" but not always the melody in full orchestra; also
  accompaniment patterns, counterpoint or a textural line. Vln II usually harmonises or doubles Vln I's
  melody, or takes any of the same roles (accompaniment, textures, harmony). Listening ref.: Rimsky-Korsakov,
  *Scheherazade* I (violin solos).

### Viola

**Concepts**
- Next larger/lower string; larger than the violin but acoustically too small, hence less powerful; this gives
  its dark, warm, soft, somewhat melancholy character.
- Open strings C3 G3 D4 A4 (MIDI 48 55 62 69).
- Per-string span (figure): C string C3–C4; G string G3–G4; D string D4–~D5; A string A4–~A5, extended (in
  parentheses) to about C6 [approx].

**Rules**
- R8 [AVOID] Viola above **A5 (MIDI 81)** in orchestral writing (rare). *Why:* the larger size makes high
  positions harder, violins already cover that register, and the A string turns nasal as it rises.
- Roles: historically the alto voice (SATB) of the strings; also accompaniment patterns, counterpoint, chordal
  textures or melodies.

**Agent applicability**
- Comfortable MIDI windows: Vln 55–88 (to E6) normal, up to ~93 sparingly, ≤ 100 orchestral max;
  Va 48–81.
- Assign SATB string voicing: Vln I = S, Vln II = S2/A doubling or harmony, Va = A, Vc/Cb = T/B.

**Tags:** #strings/violin #strings/viola #strings/ranges #orchestration/register
