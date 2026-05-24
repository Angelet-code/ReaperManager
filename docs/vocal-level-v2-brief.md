# Vocal Level V2 Brief

## Decision

The 2026-05-24 listening pass rejects the current phrase-safe absolute default as a musical default. On `43_LeadVoxOD_UncompedTake01`, the tool wrote 48 parts and 175 points with average gain `+9.5 dB`, max `+12 dB`, and 21 parts limited by `maxBoost`. That is not professional pre-compressor leveling; it behaves like fragment normalization.

V2 must not continue by tuning that same absolute-per-part behavior. It must change the control model.

## Product Goal

Automatic pre-compressor clip gain. This is not compression and not final vocal riding. It must do the manual clip-gain job in one command: stabilize macro areas first, then fix audible syllable/word drops without raising material that is already right.

The target `-18 dBFS = 0 VU` remains the gain-staging reference. Selected vocal clips are expected to arrive already gain-staged. If the complete item or one of its main macro areas is not in range, V2 should apply an internal gain-staging phase before detailed leveling, not ask the user to fix it manually.

## Processing Model

1. Analyze only selected items.
2. Detect reliable vocal activity and ignore low-confidence material: silence, room tone, breath-only regions, consonant-only events, tails and noise.
3. Check item-level gain stage. If the whole item is off, apply one internal macro baseline in the take-volume envelope.
4. Split the item into main macro zones when the performance has clear level areas, normally about `3-8` zones and often `5-6` on a long take.
5. Gain-stage each macro zone against the working reference before detailed leveling.
6. Inside each macro zone, level phrases, words or syllables relative to that zone. Do not compare every part directly to the global target.
7. Protect already-good parts: if a part is inside the local acceptable band, leave it alone or move it less than about `1 dB`.
8. Correct audible syllable/word drops by default; the failed pass did not solve this.
9. Write a take-volume envelope with enough points to do the clip-gain job, but not a nervous compressor-like curve.

## Defaults Direction

- `levelMode = macro_micro`
- Target reference: `-18 dBFS = 0 VU`
- Macro zones per long take: normally `3-8`
- Macro gap initial value: about `900 ms`
- Minimum macro-zone length: about `1.2 s`
- Macro correction cap: `+/-8 dB`
- Meso gap initial value: about `350 ms`
- Minimum meso-zone length: about `450 ms`
- Meso phrase correction cap: about `+/-4 dB`
- Micro word/syllable correction cap: about `+2.5 dB boost`, `-3 dB cut`
- Micro boost only for clear drops: about `4 dB` below context
- Micro strong-syllable cut strength: about half-way toward context
- Total normal boost cap: `+8 dB`
- Total normal cut cap: `-8 dB`
- Macro deadband: about `1 dB`
- Micro deadband: about `1.5 dB`
- Already-good part maximum movement: about `1 dB`
- Point density target: `35-70 points/minute` when syllable repair is active
- Point density reject: over `100 points/minute` on normal vocal material
- Keep zero-crossing/ramp protection, but do not use it to justify dense automation.

## Telemetry And Reject Conditions

The normal command should not ask the user to decide. It may report telemetry for review and tests.

Reject a design or test run when:

- It makes the vocal obviously too loud.
- It raises parts that were already good.
- It treats loud and soft macro zones with the same absolute rule.
- It fails to lift clearly dropped syllables/words after macro gain staging.
- It produces a long-take pass where every final segment is boosted and no phase reports meaningful cuts, unless the whole take is genuinely under-gain-staged and no segments are high relative to context.
- It relies on `+12 dB` boosts as a normal path.
- More than `10%` of parts hit max boost.
- Breath, room tone or tails are boosted more than about `2 dB`.
- The envelope looks or sounds like compression instead of clip gain.

## Acceptance Criteria

- The compressor receives a steadier vocal after clip gain, but the performance still breathes.
- Verses, choruses and phrase intent remain partially different when they were sung differently.
- Main macro zones are gain-staged before syllable-level work.
- Loud macro zones, subzones or syllables can be cut; the report should separate boosts and cuts by phase.
- Syllables/words that are audibly low are corrected.
- Parts already at a good level are protected.
- Versions are accepted only after audio-result measurement, not by parameter telemetry alone: `post_level_measurement` must show reduced local dispersion, controlled peaks/outliers, and no boosted silence/breath regions. Applied runs should report `mode = applied_take_envelope`.
- No audible rise in noise, breaths or tails between lines.
- No clicks, pumping, zippering or robotic envelope movement.
- Existing take volume envelopes are skipped unless `--replace-envelope` is explicit.
- Preview remains strictly non-mutating.
- Undo restores the applied pass.

## User Decisions Captured

- The user does not want an interactive warning workflow. The command should level the vocal by itself.
- The material is expected to arrive gain-staged. If it is not, V2 performs gain-stage logic internally before leveling.
- If macro zones are detected and one is low/high, V2 gain-stages that zone first.
- The failed pass sounded too loud, did not level syllables, raised parts that were already fine, and treated macro zones incorrectly.
- Breath protection is desired by default, but the first priority is correct macro/micro gain logic.
- This is clip gain before compression, not compression.

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
3. Implement internal macro gain-stage first, without calling or changing `command_gain_stage_items`.
4. Add macro-zone grouping and per-zone baseline.
5. Add local syllable/word repair active by default but tightly capped.
6. Report telemetry for TESTER, not user-facing blockers.
