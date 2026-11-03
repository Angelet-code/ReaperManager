---
id: orchestration.brass-basics-mutes
title: Brass mutes and stopping
aliases: [sordina, sordinas, con sordina, senza sordina, sin sordina, sordina recta, sordina straight, straight mute, sordina de copa, cup mute, sordina harmon, wa-wa, wah-wah, sordina whisper, sordina whispa, solotone, sordina bucket, velvet tone, plunger, sombrero, derby, hat, en el sombrero, en el atril, in the stand, Dämpfer, mit Dämpfer, ohne Dämpfer, Dpf, sourdine, gestopft, offen, tapar con la mano, mano en la campana]
domain: orchestration
tags: [brass, mutes, timbre, effects, notation]
style_scope: universal (cup, harmon, plunger, solotone, bucket and hat come from jazz and theatre bands)
use_when: Choosing or reading a muted brass colour (con sordina, harmon, cup, plunger…), or deciding between a mute and horn stopping.
summary: Plain con sord. means the straight mute, the orchestral default for trumpet and trombone; any other mute must be named. A mute changes colour, not just level, and muted brass play from pp to a piercing fff. Trumpets carry many mutes, trombones usually only a straight, horns and tubas one each. Horn stopping is a separate colour; trumpets cannot stop.
sources: ["adler-orq-es p.307-311", "adler-orq-es p.333-335", "adler-orq-es p.347", "adler-orq-es p.353-354", "piston-orch p.212-214", "piston-orch p.253-261"]
related: ["[[brass-basics]]", "[[trumpet]]", "[[horn]]", "[[trombone]]", "[[tuba]]", "[[oboe-english-horn]]", "[[_instruments]]"]
---

# Brass mutes and stopping

## Core idea
A mute is a plug in the bell (cone with cork pads). It changes timbre and character and allows an
extremely soft pianissimo, but muted brass can also play loud. Mark *con sordino / senza sordino*
(Ger. *mit / ohne Dämpfer*, "Dpf"; recent scores write "open").

| Mute | Sound | Use and limits |
|---|---|---|
| Straight (default) | veiled, nasal; fiber less cutting than metal at ff | soft or loud; trumpet pitch unchanged |
| Cup | dark, muffled; can turn colourless, ghostly, nasal | `AVOID` in symphonic writing (jazz-band sound); section ~25 mm open, solo nearly closed |
| Harmon (wa-wa) | stem out: penetrating, bright | hand over stem: + closed, o open = wa-wa; comic or jazzy; much duller on trombone |
| Whisper | softest of all, offstage | `AVOID` very high notes |
| Solotone | nasal, old radio or telephone | character solos |
| Bucket ("velvet tone") | soft, sweet | absorbs most of the sound |
| Plunger | muffled; hand-held wa-wa | close to the bell with very fast notes: explosive |
| Hat / derby | less intensity, no distortion | any style; also "in the hat" |
| Hand in or before bell | muffles less than a mute, bends pitch | trumpet, trombone; allow for the pitch change |
| Into the stand | less force, brilliance and level | bell ~5 cm from the stand (jazz) |
| Cloth in bell | softer, darker, no pitch change, full control | Ives *The Unanswered Question* |

## Rules
- R1 `MUST` *con sord.* alone = straight mute; name any other mute exactly in score and part (Adler).
- R2 `PREFER` mutes as colour, not volume. `ALLOWED` muted ff–fff, the most piercing orchestral sound
  (Stravinsky *Petrushka*); full muted brass ff has been used for a century; muted pp chords (Vaughan
  Williams 6) and distant echoes (Berg, Debussy *Fêtes*).
- R3 `PREFER` per instrument: trumpets carry several mutes; trombonists rarely more than one (straight);
  horn one mute (it corrects pitch, so the written note sounds) plus hand stopping; tuba one mute, best in
  its middle and high register.
- R4 `MUST` time to put a mute in and take it out: rests before and after (Adler, tuba); the same applies to
  all brass (general knowledge).
- R5 `NEVER` hand-stop a trumpet (Adler, Piston). Horn stopping: [[horn]] R13–R14. Its pitch effect is
  described oppositely (Adler: stopping raises pitch, the player fingers a semitone lower; Piston: the hand
  lowers pitch); samples already sound the written note.
- R6 `ALLOWED` fast tonguing and flutter-tongue muted, even pp (Debussy *La Mer*; Strauss *Don Quixote*,
  the bleating chords).
- R7 `PREFER` muted trumpet + English horn in unison: a blend the open trumpet never gives (Piston).

## Period practice
- `[era: late-19th-c. German scores]` *gestopft* in trumpet parts means muted, *offen* open (Adler); on
  horn *gestopft* means hand-stopped.
- `[era: early 20th c.]` muted trumpets were briefly as common as open ones (Piston).
- `[era: Adler 2002]` cup, harmon, bucket, solotone and whisper mutes moved from dance and theatre bands
  into recent symphonic scores; players also make their own.

## Apply in MIDI / REAPER
- Use a muted patch or articulation (straight by default). Never fake a mute with low CC1 on an open patch
  (Adler). If the library has no such mute, tell the user and choose another colour (inferred).
- Keep muted material on its own track or keyswitch range, and leave a rest at each switch as a player
  would need.
- Distant or offstage trumpet: muted patch at p, more reverb and less presence, out of the extreme top
  (inferred).
- Harmon wa-wa: a harmon patch; shape + / o with CC11 or a filter in 1/8–1/4-beat ramps (inferred).

## Checklist
- [ ] Every muted passage names its mute; plain "con sord." means straight.
- [ ] Muted loud passages use a muted patch at high CC1, not an open patch.
- [ ] Rests around each mute change; no stopped trumpet; no whisper mute up high.
