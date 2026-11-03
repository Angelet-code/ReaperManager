---
id: orchestration.bass-line-doubling
title: Bass line doubling and the orchestral low end
aliases: [doblaje del bajo, bajo orquestal, línea de bajo, graves, low end, contrabajos y chelos, sub boom, pedal grave, bajo sólido, bajo tenuto]
domain: orchestration
tags: [doubling, bass, low-end, pedal, film]
style_scope: universal (classical Vc+Cb practice) + film (modern low-end layer)
use_when: Writing or reinforcing the bass line of any orchestral passage, or when the low end of a mock-up sounds weak, muddy or uncontrolled.
summary: "The classical bass is cellos with double basses an octave below (one element), plus bassoon in the winds; check the 4-string limit E1 (28). The full film-orchestra bass is double basses + piano + harp + trombone + bassoon, with a separate controlled low-end layer (sub boom, low synth) and almost no reverb. Keep the lowest octave sparse (roots and fifths) and drop or lighten the basses in transparent passages."
sources: ["film-4day-challenge slides 6, 9, 10", "unir-orq-tema4 p.32-40", "unir-orq-tema5 p.23-28", "unir-orq-tema3 p.14-17", "httyd-test-drive p.1, p.5, p.9-12", "piston-orch p.357-363, 366-381, 416-419, 426-443", "adler-orq-es p.548-556, 570-584"]
related: ["[[bass-line-doubling-recipes]]", "[[doubling-colour-and-decay]]", "[[five-elements-arrangement-checklist]]", "[[reverb-strategy-orchestral]]", "[[chord-voicing-family-stacking]]", "[[double-bass]]", "[[tuba]]", "[[texture-accompanied-melody]]"]
---

# Bass line doubling and the orchestral low end

## Core idea
The double bass historically **doubled the cello an octave lower**; Piston treats Vc + Cb in octaves as
one element, the standard octave doubling. Modern orchestral and film sound needs a **solid, compact,
controlled low end** as its own element (see [[five-elements-arrangement-checklist]]). Build it by
colour-matched doubling, keep it sparse, and keep it dry. Period and colour recipes (solid Wagner bass,
brass-forte bass, pedals, light basses): [[bass-line-doubling-recipes]].

## Rules
- R1 `PREFER` Default bass: `VC` on the line, `CB` 12 semitones below. Pizzicato basses under an arco
  cello line are a common lighter variant.
- R2 `MUST` Check the double-bass part against the 4-string low limit E1 (28). Raise lower notes an
  octave unless a 5-string or C-extension patch is assumed (Piston: Mozart's Eb1 played 8va).
- R3 `PREFER` Full film-orchestra bass: double basses + piano (low octave) + harp + trombone + bassoon.
- R4 `MUST` (modern film/epic style) Provide a dedicated low-end layer: sub boom hits, a low synth,
  electric bass or close sampled basses, controlled in level.
- R5 `PREFER` Woodwind bass: bassoon, or bass clarinet for soft entries. The contrabassoon needs rests.
- R6 `AVOID` Reverb on bass instruments, or keep it very low (the film deck's practice).
- R7 `AVOID` Thirds or full chords below MIDI 45 in sustained writing. The lowest octave carries roots,
  fifths and octaves only (general knowledge; Mahler's brilliant final chord keeps only the tonic in its
  lowest octave, Adler).
- R8 `AVOID` Basses far below the rest of a light texture: too heavy. Double them with bassoon(s) to
  bridge the gap, or write them an octave higher for a more melodic bass (Piston).
- R9 `ALLOWED` Omit the double basses in a light, transparent accompaniment, or keep them to a single
  note or sparse pizz downbeats (Piston, Debussy *La Mer*).
- R10 `PREFER` Under a dry, detached accompaniment give the bass a tenuto (sustained) line: it binds the
  texture (Piston, Berlioz).
- R11 `PREFER` (film) Hold a pedal in the low instruments while the harmony above changes, and re-attack
  it with an accent every 2–4 bars (HTTYD).
- R12 `NEVER` Exactly 2 double basses (see [[orchestra-sizes-and-section-balance]]). A single solo bass
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
- **Pedal:** a whole-note tied pedal, re-attacked every 2 or 4 bars; re-attack velocity 110 (ff accent);
  CC1 decays from 110 to 85 over each 4-bar span (ff → f, HTTYD); cymbal or bass drum on each re-attack.
- **Gallop/motor bass:** see [[action-ostinato-pedal-gallop]]. Basses add a low octave on every beat.
- **Sub boom:** only on section downbeats and big hits, roughly 1 hit per 4–8 bars, pitch = tonic or
  chord root in 24–36. Level-check it against the basses.
- **Level control:** high-pass non-bass tracks at about 80–120 Hz so the low end belongs to the bass
  tracks only (general knowledge). Balance the bass in the MIDI first (user-taste R15: lower the heavy bed
  before raising melodies).
- **Mud lint:** for each chord, count notes below 48. If there are more than 3 distinct pitch classes, or
  any interval smaller than 7 semitones below 45, re-voice.

## Checklist
- Does every `CB` note sit an octave below `VC` (or at unison by design), and not below 28 without an
  extension patch?
- Is there a dedicated low-end layer in film/epic cues, used sparingly?
- Are the basses and low end dry or nearly dry?
- Only roots, fifths and octaves below MIDI 45?
- In light passages, are the basses thinned, raised or bridged by bassoons?
- Are long pedals re-attacked every 2–4 bars rather than tied for 10+ bars?
- Do brass basses (tuba, bass trombone) appear only at f or louder, or as soft pads by design?
