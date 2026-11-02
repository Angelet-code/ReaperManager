---
source_id: adler-orq-es
source_title: Samuel Adler, El estudio de la orquestación (Spanish translation of the 3rd ed., Idea Books; original 2002)
source_era: "2002 (3rd ed.); late-20th-c. American/international orchestral practice, with historical notes on earlier periods"
scan_pages: 786-797
printed_pages: 785-796
missing_printed_pages: []
chapters: ["Apéndice A Guías de referencia rápida — Registros de los instrumentos orquestales más comunes (p.786)", "Apéndice A — Nombres de los instrumentos en cinco idiomas (p.793)", "Apéndice A — Términos orquestales frecuentes en cinco idiomas (p.795)"]
continues_from: null
continues_into: "Apéndice A — Términos orquestales frecuentes en cinco idiomas: the term list breaks off at the bottom of printed p.796 ('Con baqueta de madera') and continues on p.797, outside this range"
---

# Adler, El estudio de la orquestación — scans 786–797 (printed 785–796)

Scan p = printed p + 1. Scan 786 is the unnumbered title page "Apéndices — A — Guías de referencia rápida"
(printed 785). No printed pages are missing. Appendix B (bibliography) is not reached.

**How the ranges were read.** The range charts are printed sideways and small. Every note was located by
counting staff lines and ledger lines on the page image (and checked by pixel profile), not guessed from
standard tables. Columns in the book: *Registro escrito (profesional)* (written pro range), *Sonido real*
(how it sounds), *Registro escrito (no profesional)*, *Comentarios*. All concert MIDI numbers below are my
conversions (C4 = 60) from the written note using the book's "Sonido real" interval. Items marked `[?]`
are where the scan is ambiguous or the reading disagrees with the instrument chapter.

## Apéndice A — Registros de los instrumentos orquestales más comunes (scan p.787–793, printed p.786–792)

**Concepts**
- Professional range (registro profesional): the top note varies by player. The book gives notes that
  **every** professional can play and that are normally required in orchestral playing. These are not
  soloists' extremes.
- Non-professional range (registro no profesional): **whole notes** (redondas) = beginning orchestral
  players (principiantes de orquesta). **Black notes** (negras) = amateur groups (grupos de aficionados),
  who reach a little further.
- In the professional column, **black noteheads mark notes not found on all instruments** (extensions:
  bass C extension, flute B foot, low-C bass clarinet, 5-octave vibraphone, 61-key organ…).
- "Sonido real" gives the transposition. "Como se escribe" = sounds as written. "Octava grave/aguda" =
  sounds an octave lower/higher.

**Rules**
- R1 [MUST] Keep generated orchestral parts inside the professional range in the tables below (concert
  MIDI). *Why:* the author defines these as what all professionals can play in orchestral playing.
- R2 [PREFER] When the request is for a school, youth or amateur orchestra ("orquesta de aficionados",
  "orquesta juvenil", "principiantes"), use the non-professional column: the whole-note top for beginners,
  the black-note top for amateur groups.
- R3 [AVOID] Notes shown as black in the professional column (instrument-dependent extensions) unless the
  target instrument or sample library is known to have them.
- R4 [MUST] MIDI is written at concert pitch. Apply the "Sonido real" interval when converting a written
  range or part. Octave transposers (piccolo, guitar, double bass, contrabassoon, xylophone, celesta,
  glockenspiel 2 octaves) only change the octave.
- R5 [AVOID] For non-professional ensembles, these instruments are normally missing: alto flute, English horn
  (very rarely present), D/E♭ clarinets, contrabassoon, alto trombone, euphonium (orchestra). Bass clarinet
  may be missing. Do not give them essential material, or cue the line in another part.
  `[era: late-20th-c. American amateur-orchestra practice]`
- R6 [PREFER] In modern orchestras normally only B♭, C or D trumpets are used. The other trumpets, cornet
  and flugelhorn included, belong mostly to bands. `[era: late-20th-c. orchestral practice]`
- R7 [MUST] Bass clarinet in treble clef sounds a major 9th lower. When written in bass clef (F clef) it
  sounds only a major 2nd lower.
- R8 [MUST] Euphonium (bombardino) and baritone sound as written in bass clef. Band parts in treble clef
  sound a major 9th lower.
- R9 [MUST] Assign timpani notes to drum sizes using the timpani row below. Each drum covers about a 5th.

**Range tables** (written → concert; MIDI = concert)

*Strings*

| Instrument | Sounds | Pro written | Pro concert MIDI | Non-pro written (beginner / amateur top) | Non-pro concert MIDI |
|---|---|---|---|---|---|
| Violin (violín) | as written | G3 – B7 [?] (top printed B6 under 8va, 5 ledger lines) | 55–107 [?] | G3 – D6 / G6 | 55–86 / 91 |
| Viola | as written | C3 – A6 (alto clef, treble on top) | 48–93 | C3 – A5 / B5–C6 [?] | 48–81 / 83–84 [?] |
| Cello (chelo) | as written | C2 – E6 (treble clef on top) | 36–88 | C2 – A4 / G5 | 36–69 / 79 |
| Double bass (contrabajo) | 8vb | E2 – G5 (treble on top); black C2 = C extension | 28–67; ext. 24 | E2 – G4 | 28–55 |
| Harp (arpa, "sin pulsar pedales") | as written | C♭1 (8vb) – G♯7 (8va) | 23–104 | — | — |
| Guitar (guitarra) | 8vb | E3 – E6 | 40–76 | — | — |
| Mandolin (mandolina) | as written | G3 – E6 | 55–88 | — | — |
| Banjo | as written; tenor banjo 8vb | C3 – A4 (only these two notes shown) [?] | 48–69 (tenor 36–57) | — | — |

- Violin top `[?]`: the chart clearly shows B6 on a 5th ledger line under 8va, so it sounds B7 (107). The violin
  chapter (digest p44-67) gives G3–E7 (55–100) as the practical orchestral range. For ensemble writing,
  prefer ≤ E7. Treat 101–107 as possible only for top professional sections.
- Viola amateur top `[?]`: the black note sits between B5 and C6.
- The "pro" tops for viola (A6), cello (E6) and bass (written G5 in treble) are very high. They are what
  the chart prints. For section writing, the chapter digests' safer limits apply. For cello: 36–79 safe,
  80–88 soloistic (from the cello chapter).

*Woodwinds (madera)*

| Instrument | Sounds | Pro written | Pro concert MIDI | Non-pro written | Non-pro concert MIDI | Comment |
|---|---|---|---|---|---|---|
| Piccolo (flautín) | 8va | D4 – C7 (top printed C6 + 8va) | 74–108 | G4 – A6 (A5 + 8va) | 79–105 | |
| Flute (flauta) | as written | (black B3 = B foot) C4 – D7 | (59) 60–98 | D4 – C7 | 62–96 | |
| Alto flute (flauta alto) | P4 lower | C4 – C7 | 55–91 | — | — | normally not available in non-pro groups |
| Oboe | as written | B♭3 – A6 | 58–93 | C4 – E6 | 60–88 | |
| English horn (corno inglés) | P5 lower | B3 – G6 | 52–84 | B3 – D6 | 52–79 | very rarely available in non-pro orchestras |
| Clarinets except bass (todos los clarinetes excepto el bajo) | see below | E3 – A6 (top printed A5 + 8va) | B♭: 50–91 | E3 – F6 | B♭: 50–87 | non-pro orchestras normally have no D or E♭ clarinets |
| Bass clarinet (clarinete bajo) | M9 lower (bass clef: M2 lower) | black D3 [?] and E♭3, whole E3 – E6 | ext. 36 [?], 37; 38–74 | E♭3 – C6 | 37–70 | may not be available in non-pro groups |
| Bassoon (fagot) | as written | B♭1 – E♭5 (tenor clef on top) | 34–75 | B♭1 – G4 / B♭4 | 34–67 / 70 | lowest and highest notes may not be playable by all non-pro players |
| Contrabassoon (contrafagot) | 8vb | B♭1 – B♭4 | 22–58 | — | — | normally not available in non-pro groups |
| All saxophones (todos los saxofones) | see below | B♭3 – G6 [?] | see below | — | — | |

- Clarinet transpositions (written E3–A6 → concert): B♭ (M2 lower) D3–G6 = 50–91; A (m3 lower) C♯3–F♯6 =
  49–90; D (M2 higher) F♯3–B6 = 54–95; E♭ (m3 higher) G3–C7 = 55–96; alto in E♭ (M6 lower) G2–C6 = 43–84.
- Bass clarinet low notes `[?]`: three notes are printed side by side. Black D3 (it may be C3 = MIDI 34 on
  low-C instruments; the notehead sits on the 4th ledger), black E♭3 (MIDI 37), whole-note E3 (MIDI 38). So
  low E♭ and below are not on every instrument.
- Saxophone transpositions (written B♭3–G6): soprano B♭ (M2 lower) 56–89; alto E♭ (M6 lower) 49–82; tenor B♭
  (M9 lower) 44–77; baritone E♭ (8ve + M6 lower) 37–70; bass B♭ (2 8ves + M2 lower) 32–65. `[?]` The top G6
  is read from four ledger lines. The standard keyed top is F6/F♯6, so G6 is already altissimo.

*Brass (metal)*

| Instrument | Sounds | Pro written | Pro concert MIDI | Non-pro written | Non-pro concert MIDI | Comment |
|---|---|---|---|---|---|---|
| Horn in F (trompa, "con notas pedales" = including pedal notes) | P5 lower | F♯2 (bass clef, modern notation) – C6 | 35–77 | C3 (bass clef) – G5 | 41–72 | horn chapter digested elsewhere |
| All trumpets except E♭ and low D (todas las trompetas excepto en Mi♭ y RE grave) | see below | F♯3 – C6 | C: 54–84 | A3 – B♭5 | B♭: 55–80; C: 57–82 | orchestras: B♭/C/D only; others mostly in bands |
| Trumpets in E♭ and low D (trompetas en Mi♭ y RE grave) | E♭: M6 lower; D: "M7 lower" as printed [?] | F3 – C6 | E♭: 44–75; D: 43–74 (if m7) | — | — | |
| Tenor trombone (trombón tenor) | as written | E2 – F5 (tenor clef on top) | 40–77 | E2 – F4 / B♭4 | 40–65 / 70 | |
| Bass trombone (trombón bajo) | as written | B♭1 – B♭4 | 34–70 | B♭1 – F4 | 34–65 | |
| Alto trombone (trombón alto) | as written | A2 – E♭5 (alto clef) | 45–75 | — | — | normally not available in non-pro orchestras |
| Tuba | as written | D2 under 8vb (= D1) – G4 | 26–67 | F2 under 8vb (= F1) – C4 | 29–60 | |
| Euphonium (bombardino) | as written; treble clef M9 lower | B♭1 – B♭4 | 34–70 | — | — | normally not in non-pro orchestras, but always present in bands |
| Baritone (barítono) | as written; treble clef M9 lower | E2 – B♭4 | 40–70 | — | — | |

- Trumpet transpositions of written F♯3–C6: C as written 54–84; B♭ (M2 lower) 52–82; D (M2 higher) 56–86;
  E♭ (m3 higher) 57–87; cornet in B♭ (M2 lower) 52–82 (this line is printed twice); bass trumpet in C (8ve
  lower) 42–72; bass trumpet in B♭ (M9 lower) 40–70; flugelhorn (fiscorno, M2 lower) 52–82.
- `[?]` For the low D trumpet the book prints "séptima Mayor más grave" (major 7th lower). A D instrument that
  sounds below written C actually sounds a minor 7th lower (C→D). The MIDI above uses m7. As printed, M7
  would give 42–73.

*Percussion (percusión)*

| Instrument | Sounds | Written range | Concert MIDI |
|---|---|---|---|
| Timpani (timbales) 32" | as written | C2 – A2 | 36–45 |
| Timpani 28" | as written | F2 – C3 | 41–48 |
| Timpani 25" | as written | B♭2 – F3 | 46–53 |
| Timpani 23" | as written | D3 – A3 | 50–57 |
| Timpani 21" | as written | F3 – C4 | 53–60 |
| Xylophone (xilófono) | 8va | C4 – C7 (C6 + 8va) | 72–108 |
| Marimba | as written | A2 – C7 (C6 + 8va) | 45–96 |
| Vibraphone (vibráfono) | as written | F3 – F6; black C3 on some instruments | 53–89 (ext. 48) |
| Glockenspiel | 2 octaves higher | G3 – C6 | 79–108 |
| Chimes / tubular bells (campanófono) | as written | C4 – G5 [?] (top could be read as F5) | 60–79 |

- Timpani: the appendix shows C2 as the 32" low note. The timpani chapter has D2 with C2 in parentheses, and
  F3–B3 with C4 in parentheses for the 21" drum. Treat C2 and C4 as edge notes.

*Keyboards (teclado)*

| Instrument | Sounds | Written range | Concert MIDI |
|---|---|---|---|
| Piano | as written | A0 (A1 + 8vb) – C8 (C6 + 15ma) | 21–108 |
| Celesta | 8va | C3 – C7; one black note above, read as E7 written [?] | 60–108 (black: ? ) |
| Harpsichord (clavecín) | as written | F1 – F6 | 29–89 |
| Organ manuals (órgano, manuales) | as written | C2 – G6; black C7 on some instruments | 36–91 (ext. 96) |
| Organ pedal (pedal) | as written | C2 – C4; black G4 on some instruments | 36–60 (ext. 67) |
| Harmonium (armonio) | as written | F1 [?] – F6; black C7 on some instruments | 29–89 (ext. 96) |

- Celesta black note `[?]`: it is printed under the 8va bracket on the 3rd ledger line (E6 on paper). Read
  literally, that sounds E8, which is above any real celesta. Do not use it. Cap celesta at C8 (108).
- Organ: 56-key manuals (C2–G6) and a 25-note pedalboard (C2–C4) are the common ground. 61-key manuals (to
  C7) and 32-note pedalboards (to G4) are the black-note extensions.
- Harmonium low F1 `[?]`: read from four ledger lines below the bass staff.

**Exceptions / conditions**
- Professional tops (R1) are lower than soloists' limits. For concerto-style writing, the chapter digests
  give higher notes.
- Non-pro columns are given only for strings, most woodwinds, horn, trumpets, tenor/bass trombone and tuba.
  For other instruments, use the pro range and simplify.

**Agent applicability**
- Build a `range_check(track, midi_notes, level="pro"|"amateur"|"beginner")` against the concert MIDI
  columns. Flag black-note extensions separately as warnings, not errors.
- For "orquesta escolar / juvenil" requests, the safe written ranges shrink a lot. Examples: violin ≤ D6
  (86), cello ≤ A4 (69) for beginners, trumpet ≤ B♭5 written, oboe ≤ E6.
- Never transpose MIDI for piccolo/xylophone/glock/celesta/contrabassoon/guitar/bass a second time. Sample
  libraries already map them at concert pitch (or at their own documented offset).
- For timpani, write each pitch on the drum whose range contains it. A tuning change needs time between
  notes (see the timpani chapter).

**Tags:** #orchestration/ranges #orchestration/transposition #orchestration/strings #orchestration/woodwinds
#orchestration/brass #orchestration/percussion #orchestration/keyboards #orchestration/amateur-ensembles

## Apéndice A — Nombres de los instrumentos en cinco idiomas (scan p.794–796, printed p.793–795)

Spanish names with the book's Spanish and English abbreviations. Use this to map Spanish requests (and
Italian/French/German score labels) to tracks.

| Español (abbr.) | Italiano | Français | Deutsch | English (abbr.) |
|---|---|---|---|---|
| **Cuerda** | Archi | Cordes | Streichinstrumente | Strings |
| Violín (Vln.) | Violino | Violon | Violine / Geige | Violin (Vln.) |
| Viola (Vla.) | Viola | Alto | Bratsche | Viola (Vla.) |
| Violonchelo (Vc.) | Violoncello | Violoncelle | Violoncell | Violoncello (Vlc.) |
| Contrabajo (C.b.) | Contrabbasso | Contrebasse | Kontrabass | Double bass (D.B.) |
| Arpa (Arp.) | Arpa | Harpe | Harfe | Harp (Hp.) |
| **Madera(s)** | Legni / Fiati | Bois | Holzbläser | Woodwinds |
| Flautín (Fltín.) | Ottavino / Flauto piccolo | Petite flûte | Kleine Flöte / Pickelflöte | Piccolo (Picc.) |
| Flauta (Fl.) | Flauto | Flûte | Flöte | Flute (Fl.) |
| Oboe (Ob.) | Oboe | Hautbois | Oboe / Hoboe | Oboe (Ob.) |
| Corno inglés (Corn. Ingl.) | Corno inglese | Cor anglais | Englisches Horn | English horn (Eng. Hn.) |
| Clarinete (Cl.) | Clarinetto | Clarinette | Klarinette | Clarinet (Cl.) |
| Clarinete bajo (Cl. B.) | Clarone / Clarinetto basso | Clarinette basse | Bassklarinette | Bass clarinet (Bs.Cl.) |
| Fagot (Fgt.) | Fagotto | Basson | Fagott | Bassoon (Bsn.) |
| Contrafagot (Cfgt.) | Contrafagotto | Contrebasson | Kontrafagott | Contrabassoon (Cbsn.) |
| Saxofón (Sax.) | Sassofono | Saxophone | Saxophon | Saxophone (Sax.) |
| **Metal(es)** | Ottoni | Cuivres | Blechinstrumente | Brass(es) |
| Trompa (Tr.) | Corno | Cor | Horn | Horn (Hn.) |
| Trompeta (Trpta.) | Tromba | Trompette | Trompete | Trumpet (Tpt.) |
| Trombón (Trbn.) | Trombone | Trombone | Posaune | Trombone (Trb.) |
| Tuba (Tba.) | Tuba | Tuba | Tuba | Tuba (Tba.) |
| **Percusión** (keyboards listed here) | Percussione | Batterie | Schlagzeug | Percussion |
| Piano (Pno.) | Pianoforte | Piano | Klavier | Piano (Pno.) |
| Celesta (Cel.) | Celesta / Celeste | Céleste | Celesta | Celesta (Cel.) |
| Clavecín (Clav.) | Cembalo | Clavecin | Cembalo | Harpsichord (Hpschd.) |
| Órgano (Org.) | Organo | Orgue | Orgel | Organ (Org.) |
| Armonio (Arm.) | Organetto | Harmonium | Harmonium | Harmonium (Harm.) |

*Pitched percussion (altura determinada). Idiophones:* Xilófono (Xil.) = Xilofono / Silofono = Xylophone /
Claquebois = Xylophon / Holzharmonika = Xylophone (Xyl.). Marimba (Mar.) = Marimbaphon (de). Vibráfono
(Vib.) = Vibrafono = Vibraphone = Vibraphon = Vibraphone (Vib.). Glockenspiel (Glock.) = Campanelli /
Campanette = Jeu de timbres / Carillon = Glockenspiel / Stahlspiel = Glockenspiel (Glsp.) or Orchestral
bells. **Campanófono (Camp.)** = Campane / Campane tubolari = Jeu des cloches = Röhrenglocken / Glocken =
Tubular chimes (Chm.). Crótalos (Crot.) = Crotali = Crotales / Cymbales antiques = Zimbeln = Crotales.
Serrucho (Serr.) = Sega cantante = Lame musicale = Singende Säge = Musical saw. Flexatón (Flex.) = Flessatono
= Flexatone = Flexaton = Flexatone. *Membranophones:* **Timbales (Timb.)** = Timpani = Timbales = Pauken =
Timpani (Timp.). Rototoms (Rtoms.) = Roto-Tom = Tom-Tom-Spiel (de) = Roto-Tom (R.Tom).

*Unpitched percussion (altura indeterminada). Metal idiophones:* Platos (Plat.) = Piatti / Cinelli =
Cymbales = Becken / Teller = Crash cymbals. Platos suspendidos (Plat. susp.) = Piatto sospeso = Cymbale
suspendue = Hängendes Becken = Suspended cymbal. Plato claveteado (Plato clav.) = Piatto chiodato = Cymbale
sur tiges = Nietenbecken = Sizzle cymbal. Platos de dedo = Cimbalini = Cymbales digitales = Fingerzimbeln =
Finger cymbals. Triángulo (Triáng.) = Triangolo / Acciarino = Triangle = Triangel. Yunque (Yunq.) = Incudine
= Enclume = Amboss = Anvil. Cencerro (Cencer.) = Cencerro = Sonnailles / Cloches à vache = Kuhglocken /
Kuhschellen = Cowbell. Tam-tam = Tamtam. Gong. Cortina (Cort.) = Bacchette di metallo sospese = Baguettes
métalliques suspendues = Metall-Windglocken = Metal wind chimes. Cortina de madera / de bambú / de cristal =
wooden / bamboo / glass wind chimes (Holz- / Bambusrohre / Glas-Windglocken).
*Wood idiophones:* Cajas chinas (W.Bl.) = Blocchi di legno cinese / Cassettina = Blocs de bois =
Holzblöcke = Wood blocks. Temple-blocks (T.Bl.) = Blocchi di legno coreano = Tempel-Blöcke. Claves =
Claves / Holzstab. Castañuelas (Cast.) = Castagnette / Nacchere = Castagnettes = Kastagnetten = Castanets.
Lija = Carta vetrata = Papier de verre = Sandpapier / Sandblöcke = Sandpaper blocks. Carraca (Carrac.) =
Raganella = Crécelle = Ratsche = Ratchet. Látigo (Lát.) = Frusta = Fouet = Peitsche = Slapstick / Whip.
*Membranophones:* Caja clara (C. clara) = Tamburo piccolo / militare = Caisse claire / Tambour militaire =
Kleine Trommel = Snare drum (S.Dr.). Con / sin bordones = colle / senza corde = avec / sans timbres = mit /
ohne Schnarrsaite = snares on / off. Tambor tenor (T. tenor) = Cassa rullante = Caisse roulante =
Wirbeltrommel / Rührtrommel = Tenor drum. Bombo (Bomb.) = Gran cassa / Gran tamburo = Grosse caisse = Grosse
Trommel = Bass drum (Bs.Dr.); vertical / horizontal = upright / on side (aufrecht / liegend). Tom-Toms.
**Pailas** = Timpanetti = Timbales cubaines = Kuba-Pauken = **Timbales** (Timb.). Bongós (Bg.) = Bongos.
Conga (Cga.) = Tumba = Conga-Trommel. Pandereta (Pand.) = Tamburo basco / Tamburino = Tambour de basque =
Tamburin / Schellentrommel = Tambourine (Tamb.).

**Rules**
- R1 [MUST] Spanish "timbales" = orchestral **timpani** (German Pauken). English/Latin "timbales" = Spanish
  **pailas** (Cuban timbales). Disambiguate by context: orchestra → timpani; salsa/Latin → pailas.
- R2 [MUST] Spanish "trompa" = French horn (Corno/Cor/Horn), not trumpet ("trompeta").
- R3 [MUST] Spanish "campanófono" = tubular bells/chimes (Röhrenglocken). "Cortina" = wind chimes.
  "Cajas chinas" = wood blocks. "Lija" = sandpaper blocks. "Plato claveteado" = sizzle cymbal.
- R4 [PREFER] Use the book's Spanish abbreviations as track-name prefixes when the user writes in Spanish
  (e.g. "Fltín.", "Corn. Ingl.", "Cl. B.", "Cfgt.", "Trpta.", "Trbn.", "Timb.").

**Agent applicability**
- Load these mappings into the Spanish request parser. Example: "pon un campanófono en el clímax" →
  tubular bells track. "Caja clara sin bordones" → snare with snares off (snares-off articulation or a
  tom-like sample).
- When importing Italian/German score labels (e.g. "Pauken", "Posaune", "Clarone", "Gran cassa"), map them
  to the same track roles.

**Tags:** #orchestration/terminology #orchestration/instrument-names #language/es #language/it #language/fr
#language/de

## Apéndice A — Términos orquestales frecuentes en cinco idiomas (scan p.796–797, printed p.795–796; continues past this range)

| Español | Italiano | Français | Deutsch | English | MIDI/agent meaning |
|---|---|---|---|---|---|
| Con sordina | Con sordino / sordini | Sourdine(s) | mit Dämpfer (horns: Gedämpft) | Muted | muted articulation/patch |
| Quitar sordina | Via sordini | Enlevez les sourdines | Dämpfer(n) weg | Take off mutes | back to open patch (allow time) |
| Sin sordina | Senza sordino | Sans sourdine | Ohne Dämpfer | Without mute | open patch |
| Al unísono | Unisono (unis.) | Unis | Zusammen | In unison | merge divisi into one line |
| Solo | Solo | Seul | Allein | Solo | solo patch |
| Todos | Tutti | Tous | Alle | All | section patch |
| 1ª (sólo 1ª), 2ª | 1, 2 | 1er, 2e | 1ste (o einfach), 2te | 1. (first only), 2. | first player only |
| a 2 | a 2 | à 2 | zu 2 | a 2 | both players on one line |
| Cuerda | Corda | Corde | Saite | String | |
| Atril | Leggio | Pupitre | Pult | Desk / stand | |
| Dividido | Divisi (div.) | Divisé(e)s (div.) | Geteilt (get.) | Divided | split into separate voices |
| a 3 / a 4 | div. a 3 / a 4 | div. à 3 / à 4 | Dreifach / Vierfach | Divided in 3 / 4 parts | |
| mitad | la metà | la moitié | die Hälfte | Half (a string group) | half section |
| En el puente | Sul ponticello | Sur le chevalet | am Steg | At (near) the bridge | sul pont patch |
| En el diapasón | Sul tasto / Sulla tastiera | Sur la touche | am Griffbrett | Over the fingerboard | sul tasto patch |
| Con la madera del arco | Col legno | Avec le bois | Col legno / mit Holz | With the wood of the bow | col legno patch |
| Con la punta del arco | Punta d'arco | (de la) pointe | Spitze | At the point of the bow | light, thin bowing |
| Con el talón | al tallone (printed "al allone") | au talon | am Frosch | At the frog | heavy, accented strokes |
| Arco normal | Modo ordinario | Mode ordinaire | Gewöhnlich | Ordinary / natural (after sul pont., sul tasto) | return to normal patch |
| Cerca de la tapa armónica | — | Près de la table | — | Near the soundboard (harp) | harp "près de la table" |
| Cambiar a flautín | Muta in piccolo | Changez en petite flûte | Piccolo nehmen | Change to piccolo | instrument change; leave rest time |
| Cambiar de DO a MI | Do muta in Mi (printed "Sol muta in mi") | Changez do en mi | C nach E umstimmen | Change C to E (winds and timpani) | retune/crook change |
| Tapada | Chiuso (Chiusi) | Bouché(s) | Gestopft | Stopped (horns) | stopped-horn patch |
| Metálico | — | Cuivré | Schmetternd | Brassy | brassy/cuivré patch |
| Abierto | Aperto (Aperti) | Ouvert(s) | Offen | Open | open horn |
| Pabellones en alto | Campane in aria | Pavillons en l'air | Schalltrichter auf / hoch | Bells in the air | louder, brighter brass |
| Con baqueta blanda | Bacchetta di spugna | Baguette d'éponge (molle) | mit Schwammschlegel | With soft stick | soft-mallet patch |
| Con baqueta de madera | Bacchette di legno | Baguettes en bois | mit Holzschlegeln | With hard sticks (printed "hard strings") | wood-stick patch |

- Printed slips, corrected above: "al allone" (should read *al tallone*), "Sol muta in mi" (the Spanish/French
  say C→E), "With hard strings" (should read sticks), "Take of mutes" (off). The list breaks off here and
  continues on printed p.797.

**Rules**
- R1 [MUST] When a Spanish request uses one of these terms ("con sordina", "sul tasto", "a 2", "dividido a
  3", "tapada", "pabellones en alto"), switch to the matching articulation/patch, or split the part, as in
  the last column.
- R2 [PREFER] Leave rest time before "cambiar a flautín" or "quitar sordina" (inferred: the player needs time
  to change; the book only lists the term).

**Tags:** #orchestration/terminology #orchestration/articulation #orchestration/strings/bowing
#orchestration/brass/mutes #language/es
