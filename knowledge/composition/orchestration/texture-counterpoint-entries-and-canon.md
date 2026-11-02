---
id: orchestration.texture-counterpoint-entries-and-canon
title: Fugal entries, canon and stretto across the orchestra
aliases: [entradas fugadas, orden de entradas, fugato, canon, canon por color y registro, entradas en canon, stretto, estrecho, exposición fugada, inversión del sujeto, Engführung, Kanon, Fugato]
domain: orchestration
tags: [texture, counterpoint, fugue, canon, stretto, entries]
style_scope: universal (Baroque to 20th c.; entry orders era-tagged)
use_when: Scoring a fugato, fugal exposition, canon or stretto, or any passage where a subject enters several times and each entry must be heard.
summary: "Make every entry heard: separate entries by colour family and register, state the subject alone first with a recognisable rhythm, and let the entering voice lead (f, marcato) over continuing voices at mf/p. Each new entry adds a colour, a family or a dynamic level. Entry order depends on period and family; canonic layers enter one bar apart, each in one family, with the head of each entry reinforced; close with stretto."
sources: ["adler-orq-es p.133-135", "adler-orq-es p.261-270", "adler-orq-es p.392-406", "piston-orch p.374-381", "piston-orch p.409", "unir-orq-tema3 p.13-14"]
related: ["[[texture-counterpoint]]", "[[string-section-writing-counterpoint]]", "[[brass-section-writing-counterpoint]]", "[[woodwind-section-writing]]", "[[dynamics-by-orchestration]]", "[[building-and-releasing-climaxes]]"]
---

# Fugal entries, canon and stretto

## Core idea
In imitative counterpoint the listener follows the **subject** from entry to entry. Orchestration helps by
giving each entry a new colour and register and by letting the entering voice lead while the others step
back. The parent note on line blocks and separation is [[texture-counterpoint]].

## Rules
- R1 `PREFER` Let the subject be heard alone first, with an easily recognised rhythm and an anacrusis that
  gives it thrust (Adler). The countersubject moves in other note values.
- R2 `PREFER` Separate canon entries by colour family **and** register: bassoons a2 (low) → trombones + tuba
  → flutes + oboes in octaves (Berlioz, *Roman Carnival*).
- R3 `PREFER` The entering voice leads: subject *f*, *ben marcato*; continuing voices *mf* or *p* (Bartók,
  Hindemith).
- R4 `PREFER` Each entry adds a colour, a family or a level, so the texture grows as voices accumulate.
- R5 `PREFER` When one section plays alone, give each voice to a unison group (Trb a3, Hn a3, Tpt a2): two
  horns in unison weigh about as much as one trumpet or trombone (Adler).
- R6 `MUST` Keep every entry in the best register of its instruments; a line in a weak register among many
  voices must be doubled (a2 or another instrument) or it is covered (Bartók's clarinets).
- R7 `PREFER` Second exposition: invert the subject in a new family (horns after trumpets and trombones).
- R8 `PREFER` End with stretto: entries one bar apart, accented on each entry (Bartók: Tpt 1–3 and
  Trb 1–3, six voices).
- R9 `ALLOWED` Anticipate an entry with a slightly varied version of the subject in another group.
- R10 `ALLOWED` Canonic layers (Bartók, *Concerto*, Presto): each layer is one family (Fl + Ob; two harps),
  entries one bar apart. Reinforce only the **head** of each entry (its first 2–3 notes) with a second
  instrument, to mark where it starts without thickening the line.
- R11 `ALLOWED` A secondary melody can be the tune itself in canon at the octave one beat behind. Give the
  first entry slight precedence; a true-unison block (Va + Vc + Bsn) weighs more than a block split in
  octaves (Berlioz, *Roman Carnival*, Andante).
- R12 `ALLOWED` Frame a section-alone fugato with short *ff* tutti hits; timpani may state the subject with
  brass punctuating (Hindemith).

## Period practice
Default for library mock-ups: R4 (each entry adds a family), choosing the order by register.

| Family | Order | Era / model |
|---|---|---|
| Strings | Cb + Vc → Va → Vln II → Vln I (low to high) | `[era: Baroque]` Vivaldi Op.3/11 |
| Strings | Vln I → Vln II → Va → Cb (reverse); or start on Vln II or Va | `[era: Baroque]` (Adler) |
| Woodwinds | Picc → Fl a2 → Ob a2 → Cl a2 → Bsn a2, *p* → *ff* (high to low) | `[era: 20th c.]` Britten, *Young Person's Guide* |
| Brass | Trb a3 → Hn a3 → Tpt a2 → Tuba → 4 Hn | `[era: 20th c.]` Hindemith, *Symphonic Metamorphosis* |
| Mixed canon | Bsn a2 → Trb + Tuba → Fl + Ob 8ves; Hn, Picc and Timp added in the crescendo | `[era: Romantic]` Berlioz |
| Strings + winds | Va → Vln II + Cl → Vln I + Ob → Vc + Cb + Bsn | modern default (UNIR) |

## Apply in MIDI / REAPER
- One track group per entry (`E1 BSN 1-2`, `E2 TRB 1-3`, `E3 FL+OB`); never the same group on two
  consecutive entries.
- **Velocity/CC map:** entering subject velocity 95–105 (shorts) or CC1 +15 (longs); continuing voices
  60–75; drop each continuing voice by about 10 at the bar where the next entry starts.
- **Head doubling:** copy the first 2–3 notes of each entry to a second track (another family), velocity 10
  below the entry.
- **Stretto:** copy the subject to Tpt 1–3 and Trb 1–3, each shifted one bar (or one beat for a tight
  stretto); accent the first note (velocity +15).
- **Canonic layers:** shift each copy by one bar; one family per layer; give each layer its own rhythm
  profile.
- **Octave canon one beat behind:** copy the tune to the second block at −12 (or +12), offset +1 beat; keep
  the leader's CC1 5 above the follower's.
- **Build:** each entry raises the overall CC1 by about 8 ([[dynamics-by-orchestration]]); keep trumpets
  and cymbals for the arrival ([[building-and-releasing-climaxes]]).

## Checklist
- Is the subject heard alone, or over sparse counterpoint, at its first entry?
- Does each entry change family and register from the previous one?
- Does the entering voice sit above the continuing voices in level?
- Are weak-register entries doubled?
- Does the passage end with stretto or a tutti frame rather than just stopping?
