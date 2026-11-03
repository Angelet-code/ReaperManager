---
source_id: piston-orch
source_title: Walter Piston, *Orchestration* (W. W. Norton, 1955)
source_era: "1955; mid-20th-c. American orchestral practice (repertoire Haydn to Stravinsky/Copland)"
scan_pages: s223L-s232R
printed_pages: 446-465
chapters: ["Ch. 28 (number inferred) Scoring of Chords (end)", "Ch. 29 Voice Leading and Counterpoint", "Conclusion", "Index p.463-465 (skipped, not instructional)"]
continues_from: "Scoring of Chords (Ch. 28, number inferred from Ch. 29 following); range opens at the end of the 'balance' discussion (index: balance in chords p.444-446)"
continues_into: null
---

# Piston, *Orchestration* — scans s223L–s232R (printed p.446–465)

Pitch notes: C4 = MIDI 60. Piston's "foot" pitch names follow organ usage (his flute low C4 is "2-foot C",
p.120s digest), so "4-foot C" = C3 (MIDI 48). All examples here are concert pitch unless marked. Printed pages
463–465 are the book's index and were skipped. The last part of this range is the end of the book.

## Ch. 28 Scoring of Chords — end of Balance (scan s223L, printed p.446)

**Concepts**
- Balance of sonorities (equilibrio sonoro): every chord member heard at the intended relative weight. Piston
  calls a perfect balance an ideal that is never fully reached, but still worth approaching.

**Rules**
- R1 [PREFER] Write so each part can be balanced by players adapting to one another; better scoring makes the
  players' own balancing easier. *Why:* performers' cooperation is a large part of balance in a real orchestra.
- R2 (inferred, agent) [MUST] An agent has no players to rebalance a chord, so it must set the balance itself
  (velocity, CC1/CC11, doubling count) and check by render/measurement.

**Agent applicability**
- In sample libraries no section "listens"; treat Piston's player-balancing as a job the MIDI must do.

**Tags:** #orchestration/balance #orchestration/chords

## Ch. 28 — Balance of Registers (scan s223L, printed p.446)

**Concepts**
- Register balance (equilibrio de registros): strings are fairly even in tone across their range (each string
  instrument's D-string region is less brilliant). Winds change strength a lot by register, so evening out
  registers is a constant concern when combining them.

**Rules**
- R3 [AVOID] In one chord, putting a weak register and a strong register of the **same** instrument together
  (Fig.154a: 2 flutes, one low near G4, one high above the staff). *Why:* the high flute swamps the low one.
- R4 [AVOID] Pairing the weak register of one instrument with the strong register of another (Fig.154b:
  flute low near the bottom of the treble staff over oboe on low C4 [? exact notes]; the reedy low oboe wins).
- R5 [MUST] Judge a wind chord's balance only at the pitch where it is written. Transposing it, even by a
  semitone, changes the register relationship. Fig.154c: flute over oboe in the upper treble staff is evenly
  balanced. Fig.154d: the same pair above the staff (around C6 [?]) favours the flute clearly.
- R6 [ALLOWED] Strengthen the weaker voice by unison doubling (doblaje al unísono).

**Agent applicability**
- When transposing a voiced wind chord (key change, sequence), re-check each instrument's register strength
  instead of copying the balance. A rough guide: flute is weak low (C4–G4) and strong high; oboe is strong
  and reedy low. Fix the weak voice by adding a unison double, not by trusting dynamics alone.

**Tags:** #orchestration/balance #orchestration/registers #instruments/flute #instruments/oboe

## Ch. 28 — Tonality (scan s223R, printed p.447)

**Rules**
- R7 [PREFER] In tonal music, double the tonal degrees (grados tonales: tonic, dominant, subdominant) more
  than the modal degrees (grados modales: mediant, submediant). *Why:* they are structurally more important
  to the key.
- R8 [ALLOWED] A single instrument on the third can be enough to define a major chord. Fig.155a: Db major
  with ten instruments (3 trp, 4 hn, trb, tuba) on root and fifth and only trombone I on F. The chord still
  reads as major and could belong to Ab, Gb or Db.
- R9 [MUST] Remember that the extra doublings on one chord member suggest a key. Fig.155b: E minor triad with
  extra weight on G (woodwinds + 4 hn) can sound like ii of D major. Fig.155c: move the extra doubling to B
  and it suggests a key where B is a tonal degree (E minor or B minor).
- R10 [PREFER] In music meant to avoid tonality, do not stress any chord member with extra doublings
  (Fig.155d: a sharp-heavy dissonant chord for 2 fl, 2 ob, Eng hn, 2 cl, 2 bn, bass cl, 2 hn, with members
  spread evenly).

**Agent applicability**
- Count instruments per chord member. In a tonal context, give most of them to the root and fifth (and the
  key's tonic/dominant). For an atonal or ambiguous cluster, give each pitch about the same count.

**Tags:** #orchestration/chords #orchestration/doubling #harmony/tonality

## Ch. 28 — Spacing (scan s223R–s224L, printed p.447–448)

**Concepts**
- Overtone conflict (conflicto de parciales): low notes produce strong upper partials that can clash with
  the chord, or with each other when low notes are close together.

**Rules**
- R11 [PREFER] Loud chords: close position with chord tones present wherever possible, so upper tones
  cover the bass notes' disturbing overtones. *Why:* open gaps that leave room for the partials would make
  the chord uneven, because partials are too weak to fill them.
- R12 [ALLOWED] Soft woodwind chords: open spaces that let overtones colour the sound are often attractive.
  The result is unpredictable, so try it and check (render and listen/measure).
- R13 [AVOID] Close spacing in low registers. Fig.156a: a diminished seventh chord close together low
  (2 bn, bass cl, d-b) at f. Its overtones mix C, Eb, F# and A major. Use it only as a percussive effect.
- R14 [PREFER] Moving such a chord up one octave (better, two) makes its overtones much thinner and less
  noticeable.
- R15 [AVOID] Below 4-foot C (C3, MIDI 48), intervals smaller than a fifth or fourth, when clarity is
  wanted. (Fourth = 5 semitones, fifth = 7.)
- R16 [ALLOWED] Spacing that follows the harmonic series (Fig.156b: tuba on the fundamental, 3 trb on wide
  intervals above, 4 hn and 3 trp closer at the top) is ideal, but only works for a root-position major
  chord.
- R17 [ALLOWED] Harmonic doubling habits can leave gaps as large as a fifth between upper parts. Fig.156c:
  Bb major first inversion (I6) for winds and 4 hn at f. The bass D (2 bn, bass cl) is not doubled in the
  upper voices, which leaves a fifth gap. This is correct.

**Agent applicability**
- Voicing check: for notes below MIDI 48, require adjacent intervals of at least 5 semitones (better 7).
  Fill upper gaps of loud chords. Allow gaps up to a fifth in upper voices when caused by not doubling the
  bass of an inversion.

**Tags:** #orchestration/spacing #orchestration/chords #acoustics/overtones

## Ch. 28 — Blend of Tone Colors (scan s224L, printed p.448)

**Rules**
- R18 [ALLOWED] Any combination of tone colours can work in scoring chords. Try all the chord-scoring devices:
  unison doubling, overlapping (solapamiento), superposition (superposición), interlocking (entrelazado) and
  enclosing (encerramiento). Piston refuses to rank them for blend. (Blend factors: Ch. 24, p.396 ff., earlier
  digest.)

**Tags:** #orchestration/blend #orchestration/chords

## Ch. 28 — Tutti Chords (scan s224R–s225L, printed p.449–450)

**Concepts**
- Tutti chord (acorde tutti): the full orchestra, mostly at f/ff, at climaxes or brilliant endings. The brass
  dominates it. Inside the brass, trumpets and trombones dominate. The softer horns are the hard part to place.

**Rules**
- R19 [MUST] Build a tutti chord brass-first: the brass alone must sound well as a unit.
- R20 [ALLOWED] Horn method (a): double the 4 horns in pairs as two voices, equal to trumpets and
  trombones (Fig.157a: 3 trp on a close triad, 4 hn on two notes below them, 3 trb + tuba below).
- R21 [ALLOWED] Horn method (b): score trumpets + trombones first, with tuba on the bass. Trombones often
  repeat the trumpet triad an octave lower (natural octave relation, Fig.157b). Then set the 4 horns as a
  4-part chord placed with the heavy brass, here between trumpets and trombones (Fig.157c).
- R22 [AVOID] Planning the woodwinds as a separate self-sufficient chord in a tutti. *Why:* the brass makes
  middle-register woodwinds useless.
- R23 [PREFER] Put the high woodwinds (picc, fl, ob, cl) above the brass, where they add brilliance by
  reinforcing upper partials (Fig.157d).
- R24 [PREFER] Put bassoons, bass clarinet and contrabassoon with the bass (tuba, low trombones). They help
  most in their low registers (Fig.157d).
- R25 [PREFER] English horn has no good place, since it is weak high. Still give it some doubling (e.g. in
  the middle with the trumpets/horns) rather than leaving it out of the tutti.
- R26 [ALLOWED] Place strings wherever they sound best as a section. Divide them (vns, va, vc div.) for a
  richer sonority (Fig.157e: vn I/vn II/va in the treble around the trumpets; vc and d-b with the bass;
  picc to the top).
- R27 Piston calls this recipe a commonplace: a starting point for finding other, more interesting tutti
  chords, not a formula.

**Agent applicability**
- Tutti template (low→high): tuba + c-bn + bass cl (+ vc, d-b) on bass; 3 trb on a close triad; 4 hn as a
  4-part chord or 2 pairs; 3 trp on a close triad about an octave above the trombones; fl/ob/cl/picc
  doubling chord tones above the trumpets; Eng hn doubling a middle chord tone; strings divided across
  the whole range. Mix by brass first, then add the others.

**Tags:** #orchestration/tutti #orchestration/chords #orchestration/brass #orchestration/layout

## Ch. 28 — Dynamic Level (scan s225L, printed p.450)

**Rules**
- R28 [AVOID] Marking different dynamics for brass and woodwinds to correct their natural inequality. *Why:*
  doing this all the time makes split dynamics meaningless when you need them for a real special effect.
  A dynamic mark is a shared overall level that all players adapt to, not a measured quantity.
- R29 [ALLOWED] Muted brass and stopped horns are closer to woodwinds in colour and weight.
- R30 [ALLOWED] Brass can play softly, muted or open. Do not overlook it.
- R31 [MUST] Do not equate thin with soft or thick with loud. Texture density and dynamic level are
  independent.

**Agent applicability**
- In MIDI the agent must still balance each section (CC1/CC11/velocity). Piston's point is about score
  markings: keep one shared dynamic mark per section, then correct balance with doubling and register. For
  soft brass, use quiet CC dynamics or mutes instead of removing the brass.

**Tags:** #orchestration/dynamics #orchestration/balance #instruments/brass/mutes

## Ch. 28 — Range and Pitch Location (scan s225L–s225R, printed p.450–451)

**Rules**
- R32 [ALLOWED] At any dynamic, a chord's range can run from the whole orchestra's spread to a small
  interval. It can sit high, middle or low.
- R33 [ALLOWED] A wide chord can be weighted toward its high, middle or low register by placing more
  tone-weight (doublings, stronger instruments) there.
- R34 [PREFER] In a staccato chord, placing each instrument where it gives its best staccato or accent
  matters more than a fine blend of colour.
- R35 [PREFER] Work method: first a condensed plan of the chord (sketch, like the figures), then write it out
  in full score with a real duration.

**Exercises (what they teach, one line):** Problems 15–18 (p.451, Fig.158) teach scoring one chord for strings,
woodwinds by threes and full brass (3 trp, 4 hn, 3 trb, tuba) separately: a pp V7 in first inversion for winds,
a forte minor triad for strings + woodwinds + horns, and given voicings for interlocked woodwind pairs, woodwinds
+ horns and full tutti.

**Tags:** #orchestration/chords #orchestration/register #articulation/staccato

## Ch. 29 Voice Leading and Counterpoint — intro and three-part progression (scan s226L–s227L, printed p.452–454)

**Concepts**
- Melodic vs vertical forces: counterpoint makes harmony from melodies, and harmony makes melodic motion from
  chord progression. Orchestration must handle both.
- Real parts vs reduplications (voces reales vs reduplicaciones): from Ch. 22, a few real parts with octave
  or unison doublings.

**Rules**
- R36 [MUST] Melodic progression can overrule any vertical chord-scoring rule of Ch. 28. *Why:* the
  orchestra is mostly "singing" instruments, and each voice's melodic line matters for coherence.
- R37 [PREFER] To score a progression, first write the real parts with correct voice leading, each on one
  instrument (Fig.159a: I–V–VI in C, p, three real parts for vn I, va, vc).
- R38 [ALLOWED] Doubling the two outer parts at the octave with the spare string sections (Fig.159b: vn II
  doubles the top an octave lower [? octave direction], d-b doubles the bass an octave below) does not count
  as parallel octaves. These are doublings of correct real parts and do not upset the balance.
- R39 [ALLOWED] Double any part at the unison or octave. A unison doubling adds weight to that part.
- R40 [AVOID] Doubling the bass part above, where it mixes with the upper voices (Fig.159c).
- R41 [AVOID] Doubling another part so low that it sounds below the bass (Fig.159d).
- R42 [AVOID] Doubling the voice just above the bass at the octave with the top part (Fig.159e: vn I + vn II
  on the inner part's octave). *Why:* it boxes the upper voices in and cuts them off from the bass.
- R43 [ALLOWED] Divided strings and unison doublings give other valid settings.
- R44 [ALLOWED] Woodwinds can go from 3 real parts to as many as 8 lines by reduplication with no new real
  parts (Fig.160: a cl I/cl II/bn; b fl + 2 cl / 2 bn; c fl, 2 ob, 2 cl, Eng hn, bass cl, 2 bn).
- R45 [ALLOWED] A chord that comes from good voice leading is acceptable even with poor spacing or balance
  that would be wrong as a standalone chord (final chord of Fig.160c).
- R46 [ALLOWED] Brass version (Fig.161): a 3 trb plain; b 2 trp on top + 3 hn; c 3 trp + 3 hn + 2 trb +
  tuba. Unison doublings on the three real parts, with the octave doublings above and the tuba's octave below
  left undoubled.

**Agent applicability**
- Pipeline: generate N real parts with clean voice leading → assign → add octave/unison doublings. Then
  check: no doubling of the bass above the bass line in the tenor/alto range; no doubling below the bass line;
  avoid the inner-voice-above-bass + soprano octave pairing. Do not flag parallel octaves between a part and
  its doubling.

**Tags:** #orchestration/voice-leading #orchestration/doubling #texture/part-writing

## Ch. 29 — Chorale Style (scan s227L–s228L, printed p.454–456)

**Concepts**
- Chorale style (estilo coral): common in orchestral music, for small groups or the whole orchestra.

**Rules / worked solution** (Bach, *Ein' feste Burg*, D major, 4/4 [C], full tutti at f, Figs.162–165)
- R47 [PREFER] For a massive chorale, keep the bulk of the tone in the middle or vocal register.
- R48 [PREFER] Strings take the obvious SATB layout: A vn I, B vn II, C va, D vc, with d-b also on D an
  octave below.
- R49 [PREFER] Brass: double the melody in the tenor register to make the arrangement work (Fig.163):
  3 trp on the upper parts; hn I+III on the melody an octave lower; hn II+IV on an inner part; 3 trb on
  the lower parts; tuba on the bass.
- R50 [MUST] When the bass gets too low for good tone, move trombone III to the upper octave. In the same
  move, give trombone II part B so the texture is not split (cf. R42, Fig.159e) (beat 5, Fig.163).
- R51 [PREFER] Woodwinds split between the bass and the octave/unison doubling of violins and trumpets
  (Fig.164): 2 fl + 2 cl and 2 ob on the upper parts; Eng hn, 2 bn, bass cl, c-bn on the bass and lower
  parts.
- R52 [PREFER] Write piccolo in its lowest octave so it sounds no higher than the flutes in a chorale tutti.
- Fig.165 (full score) shows the layout: picc; fl I–II a2; ob I–II; Eng hn; cl I–II in Bb; bass cl in Bb;
  bn I–II; c-bn; hn I–IV in F; trp I–III in Bb; trb I–II (tenor clef); trb III + tuba; vn I, vn II, va,
  vc, d-b; all f. `[era: written transpositions hn in F / trp in Bb, standard mid-20th c.]`

**Agent applicability**
- Chorale tutti template: strings SATB + d-b 8vb; trumpets on top 2–3 parts; horns doubling the tune an
  octave lower; trombones + tuba on the lower parts; flutes/clarinets/oboes doubling the upper strings;
  low reeds + c-bn on the bass; piccolo no higher than the flutes. If the bass goes below about E2 (MIDI 40),
  lift trombone III an octave (inferred threshold).

**Tags:** #orchestration/chorale #orchestration/tutti #texture/homophony

## Ch. 29 — Contrapuntal Scoring (scan s228R–s229L, printed p.457–458)

**Concepts**
- Contrapuntal orchestration (orquestación contrapuntística): when the voices are melodically and
  rhythmically independent, give each voice its own tone colour suited to its melody, with a balanced whole.

**Rules**
- R53 [ALLOWED] Chorale-style block scoring (all parts in strings, or woodwinds, or brass) also works for
  counterpoint if each instrument's range fits its part.
- R54 [PREFER] For truly contrapuntal textures, treat each voice separately as a melody to orchestrate (four
  voices → four different tone colours). Try unison doublings, octave doublings and pure colours.
- Worked solution (Bach, *Art of the Fugue*, Contrapunctus X, D minor, Moderato, mf; Figs.166–167):
  - A (top): picc + ob I an octave apart; Eng hn joins an octave below ob from bar 3.
  - B: fl I + cl I in Bb an octave apart.
  - C: hn II in F + va in unison.
  - D (bass): bn I+II + d-b at the octave; d-b with bowing marks.
- R55 (inferred) [PREFER] Mix families per voice (woodwind + string, horn + viola) so each line has its own
  composite colour and voices stay separate.

**Exercises (what they teach, one line):** Problem 22 (Fig.168): three short progressions (A major 2/4 p;
G minor 3/2 f; Ab major/F minor C mf [?]) scored for woodwinds + 2 hn, brass + woodwinds, strings + woodwinds
+ 4 hn. Problem 23: Bach chorale *Es ist genug* (Fig.169, A major), once p for strings + woodwinds and once
f for full tutti. Problem 24: Bach *WTC II* Fugue 5 in D (Fig.170) for brass + woodwinds.

**Agent applicability**
- For fugal/contrapuntal MIDI, give each voice a distinct timbre or octave-coupled pair (e.g. picc+ob,
  fl+cl 8va, hn+va, bn+cb) and avoid putting two voices on the same patch.

**Tags:** #orchestration/counterpoint #texture/contrapuntal #orchestration/doubling

## Ch. 29 — Problem 25: role swap (scan s230L, printed p.460)

**Examples**
- Brahms, *Variations on a Theme by Haydn*, Var. IV (Andante con moto, Eb minor, 3/8), Fig.171: legato
  eighth-note melodic lines in fl/ob/bn pairs plus hn in Bb basso (f with hairpins). Against them, a running
  sixteenth-note counterline in vn I, va and vc (vn II rests, d-b enters bar 4). The exercise swaps the roles:
  string element into the woodwinds (woodwinds by threes), woodwind element into the strings.
  `[era: horn in Bb basso, crook notation]`

**Agent applicability**
- Running 16ths suit strings. Moved to woodwinds they need staggered breathing and several instruments
  (by threes). Legato wind lines moved to strings need slurred bowing. Use this as a role-swap variation
  device.

**Tags:** #orchestration/variation #texture/counterline #repertoire/brahms

## Conclusion (scan s230R–s231L, printed p.461–462)

**Rules**
- R56 [MUST] Write parts well for each instrument. Piston calls this the biggest single factor in good
  orchestration: well-written parts make the ensemble sound well, and poorly suited parts ruin it. Not
  knowing the instruments is the main fault in scores by inexperienced composers.
- R57 [PREFER] Analyse scores every day, from short fragments up to whole movements. Watch how texture and
  distribution change, and how the instrumental forces expand and contract for dynamic purposes.
- R58 [PREFER] For practice, orchestrate piano reductions or piano pieces with little pianistic idiom
  (pedal effects, figuration).
- R59 [ALLOWED] Composing method: sketch the piece as textural elements, then orchestrate it. No method is
  required.
- R60 [PREFER] Aim for clarity, naturalness, beauty of sound, faithfulness to the musical idea, and fresh
  interest without fussiness.
- R61 [AVOID] Orchestration made from admired sound combinations copied from others, or from formulas and
  "devices". Orchestration should grow from the musical material.

**Agent applicability**
- Validate idiom per instrument first (ranges, breathing, bowing, articulation). Plan the score as texture
  elements (melody, counterline, harmony, bass), then assign instruments by material, not by a fixed
  template.

**Tags:** #orchestration/method #orchestration/idiom
