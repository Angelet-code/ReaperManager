---
id: orchestration.instruments-moc
title: Instruments — map of content
aliases: [instrumentos, instrumentación, fichas de instrumentos, Instrumentenkunde]
domain: orchestration
tags: [moc, instruments, ranges]
style_scope: universal
use_when: Before writing or validating any orchestral MIDI part, to find the note for each instrument and the shared conventions (dynamics mapping, range data file).
summary: One hub note per instrument (or tight family) with sounding ranges in MIDI, registers, dynamics per register, agility, sample-articulation mapping, roles, doublings and a checklist, plus split notes for techniques, auxiliary members and period practice; machine-readable ranges live in data/instruments.json.
sources: ["unir-orq-tema1", "unir-orq-tema4", "unir-orq-tema5", "unir-orq-tema6", "unir-orq-tema7", "unir-orq-tema8", "apuntes-orq-sesion1", "adler-orq-es p.3-110", "adler-orq-es p.164-228", "adler-orq-es p.295-356", "adler-orq-es p.431-485", "adler-orq-es p.785-796", "adler-orq-en2 p.311-319", "piston-orch p.3-352"]
related: ["[[_orchestration]]", "[[glossary-instruments]]", "[[unir-orquestacion]]", "[[adler-orq-es]]", "[[adler-orq-en2]]", "[[piston-orch]]"]
---

# Instruments — map of content

All ranges are **sounding (concert) MIDI numbers, C4 = 60**. Orchestration technique (texture, section
writing, doubling, balance between families) lives one folder up in [[_orchestration]]. Each family opens
with a basics note; indented names (↳) are split notes of the hub above them.

## Strings (bowed)
| note | use_when | summary |
|---|---|---|
| [[string-techniques]] | Choosing a string articulation, patch and note lengths for a bowed line; start here for any string technique | slur = one bow; détaché default; dots → spiccato / saltando / martelé; marking → Albion patch → `len`/velocity/CC table |
| ↳ [[string-techniques-stops-and-divisi]] | Two or more notes at once (stops, chords, divisi), vibrato, glissando/portamento, scordatura | stops on adjacent strings, 3–4-note chords rolled at ≥ mf; sections use divisi; open strings can't vibrate |
| ↳ [[string-techniques-pizzicato-harmonics]] | Pizzicato variants or string harmonics (natural/artificial, sounding pitch) | pizz decays fast, pizz→arco needs time, ≈ 6 notes/s top; natural = open + 12/19/24/28; artificial = stopped + 24, never on bass |
| ↳ [[string-techniques-colour-effects]] | Tremolo, trills, sul pont./tasto, col legno, mutes, extended effects | bowed tremolo unmeasured; sul pont. glassy, sul tasto floating; mutes need time; always cancel with ord./senza sord.; extended techniques post-1960 |
| [[violin]] | Writing/checking Vln I or Vln II (section or solo) | 55–100 (secure 55–88; Classical ≤ 93; solo ≈ 107); E string brightest, D weakest, G dark; Vln I themes, Vln II doubles/accompanies |
| ↳ [[violin-technique-limits]] | Is this violin line, leap, chord, arpeggio, gliss or harmonic playable? | judge by strings and shifts; 1st position 55–83 safest; chords on adjacent strings ≤ P8 apart, rolled |
| [[viola]] | Writing/checking violas (inner voice, filler, light bass, melody) | 48–88, practical ≤ 81, comfortable ≤ 79; dark veiled tone; dyads below 55 as divisi |
| ↳ [[viola-technique-limits]] | Is this viola line, chord, harmonic, pizz or high passage playable? | ≤ 3rd position for fast passages; P4 hand span; open-string 3-note chords; alto clef |
| ↳ [[viola-damore]] | Viola d'amore, or a Baroque/operatic obbligato with a sympathetic-string halo | solo colour only; 7 + 7 strings in D major; ≈ 45–93; fake with solo viola + resonance |
| [[cello]] | Writing/checking cellos (bass, tenor melody, filler, divided, solo) | 36–81 (practical 36–76, solo to 88); A string projects, D string dolce; Vc with Cb an octave below |
| ↳ [[cello-techniques]] | Thumb position, stops/chords, arpeggios, harmonics, pizz, colours | hand spans a m3, frequent shifts; thumb position prepared; chords of 3 with an open string; pizz good to ≈ 71 |
| [[double-bass]] | Writing/doubling basses, simplifying fast cello lines | written 8va; 28–55 default (Adler 59, Piston 62), 24–27 only with extension; slow speech; never 2 basses |
| ↳ [[double-bass-techniques]] | Below E1, harmonics, double stops, bowings, tremolo, pizz | 5-string / C extension / scordatura in octaves; 1-2-4 fingering; natural harmonics excellent; pizz ≤ 59 |

## Woodwinds
| note | use_when | summary |
|---|---|---|
| [[woodwind-basics]] | Before writing for any woodwind: register, transposition, dynamics by register, breaths, section size | four families; flutes weak low, oboe/bassoon never pp in the lowest 5th, clarinet full dynamics; every line breathes; modern section by threes |
| ↳ [[woodwind-basics-articulation-and-effects]] | Tonguing, slurs, staccato, fp envelopes, flutter, glissando, key clicks, multiphonics | unslurred notes tongued; double/triple tonguing idiomatic on flute only; flutter poor on oboe/bassoon; effects soft and rare |
| [[flute-piccolo]] | Flute or piccolo parts (melody, runs, high doublings, pairs) | flute 60–96 (59 B foot, 97–98 exceptional); weak 60–66; piccolo +12 (74–108, practical ≤ 103), sparing peaks |
| ↳ [[flute-piccolo-alto-and-bass-flute]] | Low warm flute colour, flute-choir bass | alto flute −5 (55–91), rich low octave, hand to C flute above ≈ 79; bass flute −12 (48–≈ 84), soft |
| [[oboe-english-horn]] | Oboe or English horn parts, exposed solos, staccato | oboe 58–89 (92–93 never), never pp at 58–65, sings 65–81; EH −7 (52–82), darker, softer low notes |
| ↳ [[oboe-english-horn-damore-and-heckelphone]] | Rare oboe-family instruments, Bach double-reed choir, Straussian low reed | d'amore −3 (56–≈ 85); da caccia = Baroque EH; heckelphone −12 (45–≈ 76), very rare |
| [[clarinets]] | Bb/A clarinet parts, soft entries, dark low lines, family choice | Bb 50–89 (A 49–88): chalumeau / throat / clarino / high; niente and echo; glissando up only |
| ↳ [[clarinets-auxiliary]] | Eb/D, bass, alto, basset horn, contrabass clarinet | Eb +3 55–94 (low half parody); bass cl −14, floor 37, soft low pp; basset horn −7 41–84; alto/contrabass = band |
| [[bassoons]] | Bassoon parts: woodwind bass, staccato, inner voices, high solos | 34–75; no low pp, middle easily covered, gentlest 54–62, strained top; doubles cello/bass |
| ↳ [[bassoons-contrabassoon]] | Contrabassoon, woodwind sub-octave, sarrusophone | −12, 21–60 (practical 22–53), best 22–41; slow, no fast runs, frequent rests |
| [[saxophones]] | Sax part or section (orchestral solo, jazz/pop colour, band) | all written Bb3–F6; alto −9, tenor −14, bari −21, soprano −2; best zone written F4–D6; featured soloist |

## Brass
| note | use_when | summary |
|---|---|---|
| [[brass-basics]] | Before any brass part, or checking brass idiom (slurs, tonguing, breaths, glissandi, trills, balance, score order) | harmonic-series offsets; partials 7, 11, 13, 14 out of tune; slur adjacent partials; frequent rests; balance by scoring and CC1 |
| ↳ [[brass-basics-mutes]] | Choosing or reading a muted colour, or mute vs horn stopping | "con sord." = straight mute; name any other; muted ≠ quiet; trumpets carry many mutes, horns/tubas one |
| [[horn]] | Horn parts: pads, heroic tunes, stopped notes, rips | F horn −7, 35–77; home 53–72; 1/3 high, 2/4 low; double loud highs and soft lows; rests after the top |
| ↳ [[natural-horn-period-practice]] | Horns in the manner of Haydn–Brahms, crooked parts | crook = key; open harmonics 2–12 (16 from Beethoven); stopped notes only p; horn fifths |
| [[trumpet]] | Modern trumpet parts (melody, fanfare, punctuation, tonguing, mute) | C 54–84, Bb 52–84 (Piston/App. A top 82); melodies ≈ 58–79; no open-trumpet unison with non-brass |
| ↳ [[trumpet-family-auxiliary]] | D/Eb, piccolo, bass trumpet, cornet, flugelhorn | D +2 / Eb +3 ≈ 56–86 / 57–87; piccolo +10 64–91; bass trumpet = valve trombone; cornet/flugelhorn sweeter |
| ↳ [[trumpet-period-practice]] | Trumpets à la Bach/Handel, Haydn–Beethoven, Wagner–Mahler; crook keys | natural trumpet = crook series only; clarino partials 8–16; Classical partials 3–12 with timpani; valved F trumpet 54–84 |
| [[trombone]] | Tenor/bass/alto trombone parts, chorales, unison themes | tenor 40–70 (72–77 risky), bass 34–70 + pedals to 24; very strong 45–65; 2 tenors + bass default |
| ↳ [[trombone-slide-techniques]] | Positions, pedals, F attachment, glissando, trills, mutes | one series per position; 40–51 one position only; slide gliss ≤ tritone; pedals Bb1–Ab1 good |
| ↳ [[trombone-period-practice]] | Alto–tenor–bass sections, French/Russian habits, contrabass and valve trombones | alto (Eb) 45–75 until late 19th c.; modern 2 tenors + bass; contrabass parts to tuba |
| [[tuba]] | Tuba bass, sub-octave reinforcement, lyrical solo | ≈ 26–67, practical 31–60; very powerful 36–52; low notes slow; bass of the trombones; frequent breaths |
| ↳ [[tuba-family-and-relatives]] | Which tuba; euphonium, Wagner tuba, ophicleide; low valve notes | F/Eb bass, CC/BBb contrabass; 4th valve −5; euphonium 34–70; Wagner tubas = horns 5–8 |

## Percussion
| note | use_when | summary |
|---|---|---|
| [[timpani]] | Timpani pitches, drums, rolls and endings, retuning, sticks, tutti role | 36–60 on four pedal drums (+ piccolo); never more pitches than drums; mark roll endings and secco notes; library plays concert + 12 |
| ↳ [[timpani-effects-and-period-practice]] | Pedal glissandi, coperti, special sticks, several timpanists, roto-toms, Classical/Beethoven/Berlioz style | stroke-then-pedal gliss; roto-toms ≈ 40–74 drier; Classical two drums on tonic + dominant with trumpets |
| [[mallet-percussion]] | Glock, xylophone, marimba, vibes, tubular bells, crotales | glock +24 79–108, xylo +12 65–108, crotales +24; marimba 45–96, vibes 53–89, bells 60–77 as written |
| ↳ [[mallet-percussion-extended-and-rare]] | Dead strokes, bowed vibes/crotales, cimbalom, steel drums, saw, flexatone, glasses, period mallets | glock = 19th-c. colour, xylophone late 19th c., vibes/marimba after 1950; saw/flexatone approximate pitch |
| [[percussion-unpitched]] | Snare, tenor drum, bass drum, cymbals, tam-tam, triangle, tambourine | key-map instruments; mark ring lengths; BD few notes; sus-cymbal swell sparingly; no snare-roll lifts (user-taste R3) |
| ↳ [[percussion-unpitched-latin-and-effects]] | Wood blocks, temple blocks, claves, castanets, Latin drums, cowbells, anvil, effects | graded sets play melodic-rhythmic lines; Latin ostinati; whip/anvil single hits; effects programmatic and rare |

Section-level percussion (players, order, climaxes): [[percussion-section-writing]] in [[_orchestration]].

## Harp and plucked strings
| note | use_when | summary |
|---|---|---|
| [[harp]] | Any harp part (range, chords, rolls, arpeggios, melody, one or two harps) | 23–103 (practical 24–96), ≤ 4 notes and ≤ a 10th per hand, chords rolled up; melody short-breathed; two harps for Romantic/film |
| ↳ [[harp-pedals]] | Is this harp passage playable? Pedal changes, enharmonics, two-harp split | one setting per letter in all octaves; D, G, A have no homophone; change a pedal only while its letter is silent |
| ↳ [[harp-techniques]] | Glissandi, harmonics, étouffé, près de la table, trills, bisbigliando, 20th-c. effects | gliss = whole pedal set; chord gliss needs ≥ 4 pitch classes; harmonics +12 on strings 45–77 |
| [[plucked-strings]] | Classical guitar, mandolin or banjo in an orchestral or chamber texture | guitar 40–83 (written 8va), mandolin 55–93 (tremolo sustain), banjo ≈ 48–76 + G4 drone: quiet colour, thin the orchestra |
| ↳ [[plucked-strings-zither-cimbalom]] | Zither or cimbalom local colour | zither melody in 3rds/6ths over oom-pah-pah; cimbalom 40–88, florid 16ths cut through tutti, long notes rolled |
| [[classical-guitar-solo]] | A solo classical-guitar part that must really be playable | write from string/fret; one shape per chord; melody owns its string; home theme, contrast, prepared climax |

## Keyboards
| note | use_when | summary |
|---|---|---|
| [[piano-celesta-keyboards]] | Piano or celesta inside an orchestral texture; any keyboard range | piano 21–108 is a doubler in short incisive notes, its low register percussion; celesta +12 soft glitter, lost in loud textures |
| ↳ [[piano-celesta-keyboards-organ-harpsichord]] | Harpsichord, organ, harmonium, ondes Martenot, continuo, church or storm colour | harpsichord 29–89 quiet; organ keys 36–96 / pedal 36–67 at 8', constant-level sustainer; harmonium under recitative |

## Cross-cutting
| note | use_when | summary |
|---|---|---|
| [[transposing-instruments]] | Reading parts into MIDI or producing parts | MIDI = concert pitch; written→sounding table; key-signature rule; clefs |

Voices (soprano to bass) have range entries in `data/instruments.json`; the writing rules are in
[[texture-accompanied-melody-voice-and-choir]].

## Shared conventions used by these notes
- **Dynamics → MIDI (project convention, inferred):** pp ≈ CC1/velocity 15–35, p 35–50, mp 50–64,
  mf 64–80, f 80–100, ff 100–127. Longs use CC1 (dynamic crossfade) + CC11 (expression); shorts use velocity.
- **Ensemble patches** (e.g. Albion ONE strings/brass/woods high–low) still represent real instruments:
  validate each line against the instrument it stands for.
- **Period practice:** Adler (2002) is the modern default; Piston (1955), UNIR and older practice appear
  as era-tagged variants beside it (synthesis spec, principle 9). [[user-taste]] overrides all books.
- **`data/instruments.json`** (one object per instrument, concert-pitch MIDI):
  - `transposition_semitones`: written→sounding (sounding = written + value).
  - `range_full`: hard limit — notes outside are errors. `range_practical`: outside = warning.
  - `registers[]`: colour zones; `weak_dynamics[]`: zones where a given dynamic/use is weak or risky → warning.
  - `family`: strings, woodwinds, brass, percussion-pitched, percussion-unpitched, harp, plucked,
    keyboards, voices. `note`: the vault note to load for that instrument.
  - Unpitched percussion has `range_full: null` and `range_practical: null` (MIDI note = library key map);
    validators must skip range checks for them. Organ ranges are key numbers at 8' pitch.
  - `notes` lists author variants ("Adler", "Piston", "Adler App. A" = Adler's quick-reference range
    tables, with beginner/amateur tops for school or community ensembles). Values marked "general
    knowledge", "inferred" or "[?]" are not firm source data.

## Reading order for beginners
1. [[transposing-instruments]] — concert pitch vs written, so no part is mis-transposed.
2. [[string-techniques]] and [[violin]] — the backbone section and the articulation→patch logic.
3. [[woodwind-basics]] and [[brass-basics]] — register, breath and idiom rules shared by each family.
4. [[horn]] — the blending brass and the mid-register home of orchestral harmony.
5. [[clarinets]] and [[flute-piccolo]] — the two most flexible woodwinds.
