---
id: orchestration.texture-part-writing-chorale-doubling
title: Doubling real parts (voice leading in orchestration, chorale tutti)
aliases: [conducción de voces en la orquestación, duplicación de voces reales, reduplicación, doblaje al unísono, doblaje a la octava, coral en tutti, coral orquestal, Stimmführung, Verdopplung]
domain: orchestration
tags: [voice-leading, doubling, part-writing, chorale, tutti]
style_scope: universal (tonal music; checks assume common-practice voice leading)
use_when: Turning a voice-led progression or chorale (3–4 real parts) into a full orchestral layout, or checking that the doublings in a generated score do not spoil its voice leading.
summary: "Score a progression by writing correct real parts first, one instrument each, then add unison and octave doublings. Never double the bass above where it mixes with the upper voices, never double a part below the bass, and do not double the voice just above the bass with the top part an octave higher. Melodic progression beats vertical chord rules. Massive chorale tutti: strings SATB with basses 8vb, trumpets on top, horns on the tune an octave lower, trombones and tuba low, upper woods on the upper strings, low reeds on the bass, piccolo in its lowest octave."
sources: ["piston-orch p.452-458", "piston-orch p.382-387", "piston-orch p.388-395", "piston-orch p.446-447"]
related: ["[[texture-part-writing-chorale]]", "[[voice-leading-parallels]]", "[[doubling-rules]]", "[[bass-line-doubling]]", "[[texture-unison-and-tutti]]", "[[harmony-voicing-for-instruments]]"]
---

# Doubling real parts

## Core idea
The orchestra is mostly made of "singing" instruments, so each voice's melodic line must make sense even
inside a big chord. Piston's method: write a few **real parts** with correct voice leading, then add
**reduplications** (unison or octave doublings) of those parts. Doublings never create new voices. The
parent note is [[texture-part-writing-chorale]].

## Rules
- R1 `MUST` Melodic progression overrules any vertical chord-scoring rule. A chord reached by good voice
  leading may keep a spacing or balance that would be wrong for a chord standing alone.
- R2 `PREFER` Pipeline: write the real parts on one instrument each (e.g. I–V–vi in C, p, for Vln I, Va,
  Vc), then add doublings.
- R3 `ALLOWED` Double the outer parts at the octave with the spare sections (Vln II on the top part,
  Cb an octave below the bass). These are doublings of correct parts, not parallel octaves, and they do not
  upset the balance.
- R4 `ALLOWED` Double any part at the unison or octave. Only unisons add real weight.
- R5 `AVOID` Doubling the **bass** an octave up where it lands among the upper voices.
- R6 `AVOID` Doubling an upper part so low that it sounds **below the bass**.
- R7 `AVOID` Doubling the voice just above the bass an octave or more higher, up in the top part's
  register. It boxes the upper voices in and cuts them off from the bass.
- R8 `AVOID` A doubling note that another line is already sounding at that moment: omit it from the
  doubling, or that pitch gets too much weight.
- R9 `ALLOWED` Woodwinds can grow from 3 real parts to 8 staves by reduplication alone. In brass, put
  unisons on the three real parts and leave the octave doublings above, and the tuba below, single.
- R10 `PREFER` In tonal music, put extra doublings on tonic, dominant and subdominant degrees, and keep the
  3rd light: one instrument on the 3rd already defines a major chord. Extra weight on one chord member
  suggests a key (E minor with a heavy G can sound like ii of D). For atonal or ambiguous chords, spread
  doublings evenly.
- R11 `PREFER` In a massive chorale, keep the bulk of the sound in the middle (vocal) register.
- R12 `MUST` When the bass goes too low for good tone, move Trb 3 up an octave and give Trb 2 the next part
  up, so no gap splits the texture (cf. R7). The threshold is about E2 (40) (inferred).
- R13 `PREFER` Write the piccolo in its lowest octave in a chorale tutti, so it sounds no higher than the
  flutes.
- R14 `ALLOWED` When a line goes beyond a doubler's range, re-octave or drop single notes rather than break
  the line (Piston, Milhaud).

## Apply in MIDI / REAPER
**Chorale tutti, f** (Piston's *Ein' feste Burg* layout; parts A = S, B = A, C = T, D = B):

| Part | Strings | Brass | Woodwinds |
|---|---|---|---|
| A (tune) | VLN I | TPT 1; HN 1+3 at −12 | FL 1-2, OB 1, CL 1 (pitch or +12); PICC lowest octave |
| B | VLN II | TPT 2; HN 2+4 | OB 2, CL 2 |
| C | VLA | TPT 3; TRB 1 | E.H. |
| D (bass) | VC; CB (−12) | TRB 2-3 (or TRB 3 at +12 when low); TUBA | BSN 1-2, BASS CL, CBSN (−12) |

The table is a starting point: Piston's own trumpets take the upper parts and his trombones the lower ones.

**Doubling checker**, per onset (each track is tagged with the real part it doubles):
- `bass-above`: a bass-doubling track sounding above the tenor part's pitch → R5.
- `below-bass`: a non-bass track sounding below the bass part's pitch → R6.
- `boxed-inner`: a track doubling the voice just above the bass at +12 or more, inside the top part's register → R7.
- `double-weight`: a doubling pitch that equals another part's sounding pitch at that onset → R8.
- Skip parallel-octave checks between a part and its own doublings (R3). Run [[voice-leading-parallels]] on
  the real parts only.

**Levels:** per [[user-taste]] R15, trumpets on the tune play CC1 about 5–10 below the horns that double it
an octave lower (reference mock-ups, see [[tutti-balance-by-role]]). Low-reed bass doublers sit about 10
below the strings.

## Checklist
- Were the real parts written and checked before any doubling was added?
- Does any bass doubling enter the tenor/alto register, or any doubling sound below the bass?
- Is the tenor part doubled an octave up by the top part?
- Do tonic and dominant degrees carry most of the doublings, with the 3rd light?
- Is the piccolo in its lowest octave, and was Trb 3 lifted where the bass got too low?

## Examples
- I–V–vi in C, three real parts: Vln I E5–D5–C5 (76–74–72), Va G4–G4–E4 (67–67–64), Vc C3–G2–A2
  (48–43–45). Add Vln II on the top part an octave lower (E4–D4–C4) and Cb an octave below the cellos.
  Avoid: Vln II on the Va part an octave up (G5–G5–E5, boxing the tune), or a horn doubling the cello line
  at C4–G3–A3 (the bass among the upper voices).
