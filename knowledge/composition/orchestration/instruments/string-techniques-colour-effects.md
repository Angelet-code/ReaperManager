---
id: orchestration.string-techniques-colour-effects
title: String colour effects — tremolo, trills, bow position, col legno, mutes, extended techniques
aliases: [trémolo, trémolo de arco, trémolo con arco, trémolo ligado, trémolo de dedos, trémolo medido, trémolo ondulante, tremolando, trino, trinos, sul ponticello, sul pont., sul tasto, flautando, sur la touche, au chevalet, am Steg, am Griffbrett, col legno, col legno battuto, col legno tratto, modo ordinario, ord., naturale, con sordina, con sordino, senza sordina, sordina, sordinas, avec sourdine, mit Dämpfer, ohne Dämpfer, gedämpft, técnicas contemporáneas, técnicas extendidas, subarmónicos, detrás del puente]
domain: orchestration
tags: [strings, tremolo, trill, sul-ponticello, col-legno, mute, extended-techniques, sample-library]
style_scope: universal
use_when: Writing string tremolos, trills, sul ponticello/sul tasto, col legno, con sordino passages or extended (contemporary) string effects, or mapping them to patches.
summary: Bowed tremolo is one unmeasured note (three slashes) for agitation, shimmer and swells; fingered tremolo slurs two notes more than a tone apart within one string's stretch; slashes on stems are otherwise measured shorthand. Section trills blur into shimmer. Sul pont. is glassy (usually with tremolo), sul tasto soft and floating, col legno battuto dry and percussive, tratto faint. Mutes change colour more than level and need time; always cancel an effect with ord./naturale.
sources: ["unir-orq-tema4 p.5-14, 26-32", "adler-orq-es p.28-33, 39-40, 49-50", "piston-orch p.20-23, 31-35"]
related: ["[[string-techniques]]", "[[string-techniques-stops-and-divisi]]", "[[string-techniques-pizzicato-harmonics]]", "[[violin]]", "[[viola]]", "[[cello]]", "[[string-section-writing]]", "[[building-and-releasing-climaxes]]"]
---

# String colour effects — tremolo, trills, bow position, col legno, mutes, extended techniques

## Core idea
These effects change colour more than notes. Each is marked on and cancelled (*ord.*, *arco*, *senza
sord.*). In MIDI each maps to a patch or keyswitch; without one, fake it modestly or re-orchestrate.

## Rules
**Tremolos**
- R1 `PREFER` **bowed tremolo** (three slashes, or *trem.*): one note or chord repeated as fast as possible.
  Agitation (Verdi "Dies irae"), shimmer at pp, the widest swells and accents.
- R2 `MUST` **fingered tremolo**: two notes more than a whole tone apart, slurred in one bow, total value
  shared between them. Keep it within one string's stretch (about a 4th); wider, it becomes an undulating
  bow between two strings (softer, less clear).
- R3 `ALLOWED` split a wide fingered tremolo between divisi players, each holding one note (Piston,
  *Faune*). Separate-bow fingered tremolo exists but is rare.
- R4 `MUST` slashes on a stem with a countable value are **measured** repeats: one slash = 8ths, two = 16ths,
  three on a short note = 32nds. Only "as fast as possible" is a tremolo; write *trem.* to make sure.

**Trills**
- R5 `ALLOWED` half- and whole-tone trills in all registers of all strings.
- R6 `AVOID` trilling from an open string (violin 55, viola 48, cello 36): uneven colour.
- R7 `PREFER` section trills for shimmer: unsynchronised players blur (Hindemith *Mathis*). For a crisp
  trill, give it to a solo string or a wind.

**Bow position and col legno**
- R8 `PREFER` **sul tasto/flautando** (they barely differ) for soft, veiled, floating lines, p. `AVOID`
  heavy pressure there (it catches two strings).
- R9 `PREFER` **sul ponticello** for glassy, metallic, eerie colour, usually with bowed or fingered tremolo
  (Strauss *Domestica*, muted violas a 3).
- R10 `ALLOWED` **col legno battuto** (strike with the wood): dry, percussive rhythm with little pitch
  (Berlioz *Fantastique* witches, Britten *Grimes* Passacaglia). **Col legno tratto** (draw the wood) is
  faint; use it for ghostly tremolo or pp colour, never for volume.
- R11 `MUST` cancel each effect: *modo ordinario/naturale* after bow position, *arco* after col legno.

**Mutes**
- R12 `PREFER` mutes for their veiled colour, not as the way to get pp: a fine pp is possible unmuted.
  Loud muted strings are allowed and sound tense and constricted.
- R13 `MUST` give time to put mutes on and take them off. Slide-on mutes are quick; detachable ones need
  much more. Place changes in rests while other sections cover. A gradual change is possible, desk by desk.

**Extended techniques** `[era: post-1960]`
- R14 `ALLOWED` behind the bridge, bowing or striking the tailpiece, knocking on the body, very wide
  vibrato, subharmonics, highest possible note, fingering without bow, plectrum pizz, half-harmonics.
- R15 `MUST` explain each in words in the score. `AVOID` in orchestra: bowing between nut and finger, and
  bass harmonics once thought impossible.

## Period practice
- `[era: Romantic]` col legno was rare: Mahler footnoted it in Sym. 1 so players would not take it for a
  misprint. By 1955 it was better known (Piston).
- `[era: 1955, Piston]` a couple of bars or more for a mute change (detachable mutes). Modern slide-on
  mutes (Adler 2002) are quicker.

## Apply in MIDI / REAPER
- **Bowed tremolo:** Albion "Strings - Long Tremolo", one held note per pitch, CC1 for swells and
  crescendos (vibrato scale 0 in the profile). Swells: CC1 ramps over 1–4 bars.
- **Fingered/measured tremolo:** unmeasured → a trill/tremolo patch if present, otherwise alternate the two
  notes at 32nds on a short patch with velocity ±8. Measured → write the real notes. Never metre an
  unmeasured tremolo by accident.
- **Trills:** a trill patch if present. Otherwise alternate at about 12–14 notes/s on a short patch, a
  little uneven, on divisi tracks offset by 10–20 ms for a section blur (inferred).
- **Sul pont./sul tasto/col legno/con sord.:** none are among the captured Albion patches. Use the
  library's patch or keyswitch; otherwise sul tasto ≈ Long at CC1 ≤ 45 with less CC21, and sul pont.
  tremolo ≈ Long Tremolo plus a high-mid EQ boost (inferred). `NEVER` fake col legno with a loud staccato:
  use a col legno patch or a dry wood percussion sound.
- **Switching:** keyswitch back to "ord." after each effect. For a mute change on the same track, leave
  ≥ 1 bar of rest at moderate tempo, 2 bars when slow and soft (inferred from R13). Prefer separate
  `... con sord` tracks.
- **Extended techniques:** only with aleatoric/FX string patches, in film or contemporary styles.

## Checklist
- [ ] Every unmeasured tremolo is on a tremolo patch, and measured slashes are expanded into notes.
- [ ] Fingered tremolo intervals are > 2 st and ≤ ~5 st on one string, or split into divisi.
- [ ] No trill from an open bottom string.
- [ ] Each effect has a return marking or keyswitch; each mute change has a rest of ≥ 1 bar.
- [ ] Col legno and sul pont. are used as colour, p–mf, not as a main loud line.

## Examples
- Ghost pad: Vln I/II div., con sord., sul pont. tremolo, pp, CC1 20–35 with slow swells.
- Debussy *Faune* type: Vln I/II/Va div., sul tasto, pp fingered tremolos in 32nds, hairpins.
