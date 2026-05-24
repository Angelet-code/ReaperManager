# Vocal Level Bench 2026-05-23

## Context

REAPER project:

```text
A:\CERBATANA\TRABAJO\2026-05-23 TEST REAPER MANAGER\Test Vocal Leveler Precomp\Test Vocal Leveler Precomp.rpp
```

Bridge status during bench: running, 32 tracks, one vocal item per track.

Purpose: validate `vocal-level` as pre-compressor preparation, not interpretive riding. The priority from AUDIODESIGN is no artifacts, no unnecessary curves, zero-crossing-aware boundaries, and professional phrase-level behavior.

## Main Finding

The previous micro defaults were too nervous on long lead material. On `42_LeadVoxScratch`, a single 226.9 s item produced roughly 293 parts and 597 points. The phrase-safe defaults reduced this to about 51 parts and 168 written points while preserving the same target model.

## Phrase-Safe Defaults Tested

```text
measurementMode = sustain_robust
levelMode = absolute
automationMode = smooth_curve
calibrationDb = -18
targetVu = 0
maxBoostDb = 12
maxCutDb = 12
minPartMs = 300
partMergeGapMs = 350
syllableSplitDb = 20
syllableSplitHoldMs = 140
gainDeadbandDb = 3
minGainChangeDb = 5
curveSmoothMs = 320
curveToleranceDb = 2
curveMinPointGapMs = 240
curveDetail = 0.5
curveEdgeRampMs = 80
zeroCrossing = true
```

## Preview Results

These were run with one selected item per family using the phrase-safe defaults. The installed bridge at that moment still reported `points = 0` in preview, so point density was measured with apply/undo on the long lead.

| Family | Matched | Segments | Detected | Avg Gain | Min | Max | Limited Boost | Limited Peak |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| lead_scratch | 19 | 51 | 82 | +7.05 dB | -3.82 dB | +10.75 dB | 13 | 5 |
| lead_od | 1 | 49 | 58 | +9.35 dB | -5.31 dB | +12.00 dB | 21 | 4 |
| backing | 1 | 4 | 6 | +3.01 dB | +0.61 dB | +5.10 dB | 0 | 0 |
| guttural | 1 | 2 | 5 | +2.95 dB | +2.37 dB | +3.52 dB | 0 | 2 |
| agudo_gritado | 1 | 7 | 13 | +5.22 dB | +0.89 dB | +11.69 dB | 0 | 0 |
| grave | 1 | 4 | 21 | +3.73 dB | +3.33 dB | +4.46 dB | 0 | 0 |

## Apply/Undo Result

On the hardest long lead item:

```text
matched = 1
processed = 1
segments = 51
detected_parts = 82
points = 168
applied = 1
undo = ok
```

The follow-up preview after undo did not report an existing envelope, so the created take volume envelope was reverted by REAPER undo.

## Tester Notes

- `preview` must never write envelopes. It should report `estimated_points`, with `points = 0` and `envelope_points_written = 0`.
- Existing take volume envelopes are skipped unless `--replace-envelope` is explicit.
- Selected-only scope is non-negotiable.
- Any default that lifts breaths/noise, writes hundreds of unnecessary points, or ignores peak/zero-crossing guards is a blocker.

## Open Listening Questions

- Lead overdubs still hit `maxBoostDb = 12` often. Listen for room/noise lift before lowering the default; the target is precomp stability, not hiding weak takes.
- Backings behave more conservatively with phrase defaults, but role-aware macro behavior belongs to V2.
- If the long lead still feels overworked, first try lower `maxBoostDb` or higher `curveToleranceDb`; do not return to syllable splitting.
