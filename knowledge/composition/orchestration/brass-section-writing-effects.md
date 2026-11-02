---
id: orchestration.brass-section-writing-effects
title: Brass section timbral effects (harmon, hat, rips, niente, loud mutes, flutter)
aliases: [efectos tímbricos de los metales, sordina wa-wa, sordina harmon, sordina Derby, sombrero, en el sombrero, rip, niente, metales con sordina fuerte, frullato de metales, Flatterzunge, sf>p, ffpp, doble picado de la sección, metales jazzísticos]
domain: orchestration
tags: [brass, effects, mutes, rip, flutter-tongue, niente, jazz, articulation]
style_scope: 20th-c. orchestral, American and jazz-influenced; modern film
use_when: A cue asks for a special brass colour at section level (jazzy harmon trumpets, a veiled hat solo, ensemble rips into a stab, niente swells, biting muted brass, flutter-tongue, section-wide fast tonguing).
summary: Brass effects are section-level colours, not defaults. Harmon trumpets and trombones give a jazzy, nasal sound; a hat solo enters sf>p; all brass rip together into an sffz stab; muted brass can still be loud and biting; flutter-tongue is a closing or descriptive colour. Notate every non-standard request exactly, and never swap in a different mute silently.
sources: ["adler-orq-es p.407-412", "adler-orq-es p.424-430", "piston-orch p.216-220"]
related: ["[[brass-basics-mutes]]", "[[brass-basics]]", "[[brass-section-writing]]", "[[horn]]", "[[trumpet]]", "[[trombone]]", "[[woodwind-basics-articulation-and-effects]]"]
---

# Brass section timbral effects

## Core idea
Many brass effects are recent, came from jazz, or belong to one composer (Adler). Use them as marked
colours at chosen moments. Mute types and how each instrument mutes: [[brass-basics-mutes]]; single
instrument techniques: [[horn]], [[trumpet]], [[trombone]].

## Rules
- R1 `ALLOWED` **harmon (wa-wa) mute** on trumpets and trombones for a jazzy, buzzy, nasal colour, often in
  call-and-response with saxophone or clarinets (Gershwin, *Rhapsody in Blue*) `[era: late 20th c.,
  American]`. `ALLOWED` mix closed (+) and open (o) harmon within the section.
- R2 `ALLOWED` a soft, veiled trumpet solo **in the hat** or derby, over a soft clarinet choir and muted
  horns (Gershwin, *Concerto in F* II). `PREFER` start such a solo **sf>p** (very common today).
- R3 `ALLOWED` **rip:** a hard-tongued short upward lip glissando into the note. All brass rip together to
  underline the sffz that ends a phrase (Gould, *Interplay*).
- R4 `ALLOWED` **niente:** notes that grow out of and die into silence (n < mp > n) (Druckman, *Windows*).
- R5 `ALLOWED` **muted is not quiet:** straight-muted brass at f–fff gives a pinched, aggressive colour that
  still cuts (Schoenberg, op. 16/1, muted tuba "as loud as possible").
- R6 `ALLOWED` **ffpp** low brass sustain under busy upper parts (Schoenberg).
- R7 `ALLOWED` **flutter-tongue** as a closing colour after a long contrapuntal build (Schoenberg), or as a
  descriptive effect on muted chords (Strauss, *Don Quixote*). Easy on horn and trumpet, less easy on
  trombone and tuba (Piston).
- R8 `ALLOWED` section-wide double-tonguing on fast repeated chords (Rimsky-Korsakov, *Scheherazade*);
  triple-tonguing sounds best on high brass; trumpets are the lightest fast tonguers (Piston). Fast
  repeated notes on muted brass also work at soft dynamics (Debussy, *La Mer*).
- R9 `MUST` notate non-standard techniques exactly: mute type and open/closed state per player, `n`
  dynamics, *senza sord.* returns (Adler).
- R10 `AVOID` effects throughout a passage: they lose their point (general knowledge, in line with Adler's
  warning about over-using the brass).

## Apply in MIDI / REAPER
- **Mutes:** use the library's harmon, straight or cup articulation (keyswitch or separate track, e.g.
  `TPT HARMON`). If the library has no such mute, report it to the user and do not substitute another
  mute silently (inferred, following the project's plugin rule).
- **Rip (inferred):** pitch bend from −3 to −5 semitones up to 0 over 60–120 ms into the target, or 3–5
  short chromatic grace notes (`len` 0.05) before it; target velocity 115–127. Put every brass rip on the
  same sffz beat.
- **sf>p hat solo:** velocity 100–110, CC1/CC11 falling to 30–40 within ~150 ms, then shape the phrase
  ([[cc-expression-phrase-shapes]]).
- **ffpp:** velocity 110–120, CC1 dropping to 20–30 within 100–200 ms (inferred).
- **Niente:** CC11 0 → ~70 → 0 across a long note on a soft-attack patch.
- **Flutter:** a flutter articulation if the library has one; fallback (inferred) 32nd repeated notes at
  velocity 70–90, only on the final chord of the section.
- **Loud mute:** the straight-mute patch at CC1 95–115; it does not replace a dynamic.

## Checklist
- [ ] Is every effect placed at a chosen moment, not spread through the cue?
- [ ] Does the library really have the mute/articulation used, and is the user told if not?
- [ ] Do ensemble rips land together on the accent beat?
- [ ] Are hat or harmon solos over a soft bed (clarinets, muted horns, low strings)?
