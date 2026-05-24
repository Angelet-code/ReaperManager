# Vocal Level V2 Brief

## Decision

The 2026-05-24 listening pass rejects the current phrase-safe absolute default as a musical default. On `43_LeadVoxOD_UncompedTake01`, the tool wrote 48 parts and 175 points with average gain `+9.5 dB`, max `+12 dB`, and 21 parts limited by `maxBoost`. That is not professional pre-compressor leveling; it behaves like fragment normalization.

V2 must not continue by tuning that same absolute-per-part behavior. It must change the control model.

## Product Goal

Prepare the vocal before the compressor so the compressor reads more comfortably around the working point without flattening the performance. The tool should feel like careful clip-gain preparation by a senior mix engineer, not automatic final vocal riding.

The target `-18 dBFS = 0 VU` remains a calibration reference, not a mandate that every phrase must land exactly at `0 VU`.

## Processing Model

1. Analyze only selected items.
2. Detect reliable vocal activity and ignore low-confidence material: silence, room tone, breath-only regions, consonant-only events, tails and noise.
3. Estimate item-level or block-level macro offset first.
4. Split into long musical blocks or phrases after macro context is known.
5. Apply meso phrase correction partially.
6. Apply micro correction only when still needed, and keep it optional/off by default.
7. Stop early if macro/meso already makes the compressor input stable enough.

## Defaults Direction

- `levelMode = macro_micro`
- Macro gap: about `900 ms`
- Macro max correction: `+/-8 dB`
- Normal max boost default: `+6 dB`
- Permissive max boost ceiling: `+8 dB`
- Max cut default: `-8 dB`
- Micro correction default: `+/-3 dB`
- Hard micro cap: `+/-4.5 dB`
- Deadband: `1.5 dB`
- Point target: under `40 points/minute`
- Hard warning: over `80 points/minute`
- Points per phrase target: `3-4`
- Points per phrase warning: over `6`
- Keep zero-crossing/ramp protection, but do not use it to justify dense automation.

## Warnings And Reject Conditions

Preview should warn or reject the normal path when:

- Average gain needed is over `+4 dB` without first recommending macro offset.
- More than `10%` of phrases hit max boost.
- Any normal default needs `+12 dB`.
- Breath or room tone would be boosted by more than about `+2 dB`.
- Point density is above normal musical limits.
- A take is globally low and would be solved by many local boosts instead of one macro/base move.

## Acceptance Criteria

- The compressor receives a steadier vocal, but the performance still breathes.
- Verses, choruses and phrase intent remain partially different when they were sung differently.
- No audible rise in noise, breaths or tails between lines.
- No clicks, pumping, zippering or robotic envelope movement.
- Existing take volume envelopes are skipped unless `--replace-envelope` is explicit.
- Preview remains strictly non-mutating.
- Undo restores the applied pass.

## Questions For The User

These questions are product decisions, not implementation trivia:

1. When a whole take is too low, should `vocal-level` write a simple macro offset in the take envelope, or should it only warn and ask the engineer to adjust clip/take gain first?
2. Do you prefer conservative behavior with warning when the take remains below `-18`, instead of forcing it up to target?
3. In the failed pass, what was the main audible problem: voice too loud, noise/breaths lifted, pumping, phrase intention lost, or compressor reacting worse?
4. Should breaths be fully protected from boost by default, or can intentional loud breaths move with the surrounding phrase?
5. Is the intended compressor behavior closer to smooth LA-2A/1176 preparation, or more surgical modern clip gain before compression?

## Implementation Map

Keep `gain-stage` untouched. It uses `command_gain_stage_items`, `gain_target = "take"`, and does not create take envelopes. V2 work should stay inside `vocal-level` paths.

Likely files:

- `src/commands/items.js`: builder defaults, new CLI options, and validation for `macro_micro` mode.
- `src/cli.js`: help text only if new flags are exposed.
- `reaper/Reaper Manager Bridge.lua`: runtime analysis and envelope writing.
- `test/commands.test.js`: builder defaults and legacy compatibility.
- `test/bridge-static.test.js`: guardrails for preview, selected-only, existing envelopes, point density warnings and gain-stage isolation.

Likely bridge functions:

- `vocal_level_settings`: add macro/micro settings and safer defaults.
- `detect_vocal_parts`: keep as energy/activity detector, but feed macro block creation instead of treating every part as a final automation target.
- `analyze_audio_range_for_vocal_part`: stop using absolute target as the only gain decision for every part.
- `analyze_item_for_vocal_level`: add item/block macro analysis before per-phrase envelope gains are finalized.
- `apply_relative_vocal_stabilization`: useful precedent for weighted reference behavior; V2 can extend this idea rather than the absolute path.
- `consolidate_vocal_level_segments`: likely needs macro/phrase grouping and point-density control.
- `build_vocal_level_curve_points` and `append_curve_phrase_points`: keep smooth/ramped writing, but feed fewer macro/meso points.
- `command_vocal_level_items`: extend reporting with macro offset suggestion, point density warnings, reject/warning counts and V2 mode metadata.

Lowest-risk route:

1. Keep current `absolute` and `relative` modes as legacy expert modes.
2. Add `macro_micro` as the new default builder/runtime mode.
3. In preview, report macro suggestion and warnings before any apply path changes.
4. Then implement conservative apply for `macro_micro`, with low point density and no micro by default.
