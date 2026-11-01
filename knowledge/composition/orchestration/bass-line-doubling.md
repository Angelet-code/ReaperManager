---
id: orchestration.bass-line-doubling
title: Bass line doubling and the orchestral low end
aliases: [doblaje del bajo, bajo orquestal, línea de bajo, graves, low end, contrabajos y chelos, sub boom, pedal grave]
domain: orchestration
tags: [doubling, bass, low-end, pedal, film]
style_scope: universal (classical Vc+Cb practice) + film (modern low-end layer)
use_when: Writing or reinforcing the bass line of any orchestral passage, or when the low end of a mock-up sounds weak, muddy or uncontrolled.
summary: "The classical bass is cellos with double basses an octave below, plus bassoon in the winds. The full film-orchestra bass is double basses + piano + harp + trombone + bassoon, with a separate controlled low-end layer (sub boom, low synth or well-recorded basses) and almost no reverb. Keep the lowest octave sparse: roots and fifths only."
sources: ["film-4day-challenge slides 6, 9, 10", "unir-orq-tema4 p.32-40", "unir-orq-tema5 p.23-28", "unir-orq-tema3 p.14-17", "httyd-test-drive p.1, p.5, p.9-12"]
related: ["[[doubling-colour-and-decay]]", "[[five-elements-arrangement-checklist]]", "[[reverb-strategy-orchestral]]", "[[chord-voicing-family-stacking]]", "[[double-bass]]", "[[tuba]]"]
---

# Bass line doubling and the orchestral low end

## Core idea
The double bass historically **doubled the cello an octave lower** (separate bass parts were the
exception). Modern orchestral and film sound needs a **solid, compact, controlled low end** as its own
element (see [[five-elements-arrangement-checklist]]). Build it by colour-matched doubling, keep it
sparse, and keep it dry.

## Rules
- R1 `PREFER` Default bass: `VC` on the line, `CB` 12 semitones below. Pizzicato basses under an arco
  cello line are a common lighter variant.
- R2 `PREFER` Full film-orchestra bass: double basses + piano (low octave) + harp + trombone + bassoon.
- R3 `MUST` (modern film/epic style) Provide a dedicated low-end layer: sub boom hits, a low synth,
  electric bass or close sampled basses, controlled in level.
- R4 `PREFER` Woodwind bass: bassoon, or bass clarinet for soft entries. The contrabassoon needs rests.
- R5 `AVOID` Reverb on bass instruments, or keep it very low (the film deck's practice).
- R6 `AVOID` Thirds or full chords below MIDI 45 in sustained writing. The lowest octave carries roots,
  fifths and octaves only (general knowledge).
- R7 `PREFER` (film) Hold a pedal in the low instruments while the harmony above changes, and
  re-attack it with an accent every 2–4 bars (HTTYD).
- R8 `NEVER` Exactly 2 double basses (see [[orchestra-sizes-and-section-balance]]). A single solo bass
  may reinforce the cellos at unison or an octave below.

## Apply in MIDI / REAPER
**Track layout (bottom of the template):**
| Track | Range (MIDI) | Role | Reverb send |
|---|---|---|---|
| VC | 36–60 | line in its own octave | normal |
| CB | 28–48 (24 with a C extension patch) | line −12 | −24 dB or none |
| BSN / CBSN | 34–60 / 22–48 | wind colour on the bass | low |
| TBN / BASS TBN / TUBA | 33–55 / 26–50 | weight at f–ff only | low |
| PIANO LOW | 21–45 | attack definition, octaves | none to low |
| HARP LOW | 23–45 | attack definition | low |
| LOW END (sub boom / synth) | 24–40 | hits on structural downbeats | none |

- **Octave copy:** `CB` = `VC` − 12. When a note falls below 28, move the whole phrase up, or leave
  that phrase to the cellos alone.
- **Pedal:** a whole-note tied pedal, re-attacked every 2 or 4 bars.
  - Velocity of the re-attack: 110 (ff accent).
  - CC1 decays from 110 to 85 over each 4-bar span (ff → f, HTTYD).
  - Cymbal or bass drum on each re-attack.
- **Gallop/motor bass:** see [[action-ostinato-pedal-gallop]]. Basses add a low octave on every beat.
- **Sub boom:** only on section downbeats and big hits, at roughly 1 hit per 4–8 bars. Pitch = the tonic or
  the chord root in 24–36. Sidechain or level-check it against the basses.
- **Level control:** high-pass non-bass tracks at about 80–120 Hz (strings Hi, woodwinds, horns), so
  the low end belongs to the bass tracks only (general knowledge).
- **Mud lint:** for each chord, count notes below 48. If there are more than 3 distinct pitch classes, or
  any interval smaller than 7 semitones below 45, re-voice.

## Checklist
- Does every bass note in `CB` sit an octave below `VC` (or at unison by design)?
- Is there a dedicated low-end layer in film/epic cues, used sparingly?
- Are the basses and low end dry or nearly dry?
- Are there only roots, fifths and octaves below MIDI 45?
- Are long pedals re-attacked every 2–4 bars rather than tied for 10+ bars?
- Do brass basses (tuba, bass trombone) appear only where the dynamic is f or louder, or as soft pads
  by design?
