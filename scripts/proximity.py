#!/usr/bin/env python3
"""Find vocal syllables that lost proximity (singer moved off-axis / away).

Reads a mono or stereo WAV source and reports syllables whose low harmonics
dropped compared to the rest of the take and to their neighbours, the signature
of a singer pulling back or turning the head: the proximity effect fades, the
fundamental and 2nd harmonic lose weight against the 1-4 kHz formant band, the
spectral centroid climbs and the level usually dips.

Per syllable:
  1. voiced frames (autocorrelation clarity) without sibilant energy, split into
     syllables at level valleys and at sharp onsets (a glottal hit starts a new
     syllable even when the previous vowel never dipped). Octave-low pitch errors are fixed by checking
     that the odd harmonics really exist. The whole sustain is measured (an
     attack can keep its body while the held vowel goes thin); only frames far
     below the syllable median (decays, phrase tails) are dropped.
  2. h12: energy of H1+H2 vs 1-4 kHz, minus the singer's own expectation for
     that pitch (robust linear fit over the whole take, dB vs octave). A high
     note is not flagged just for being high.
  3. local deltas vs up to NEIGHBOURS syllables each side in the same phrase:
     h12 drop, level drop and centroid rise.
  4. candidate when h12 drops >= --h12-drop-db locally and is below the take
     model. Thinner can mean two different things, told apart by the level
     of the corrected window vs the neighbours:
       - far ("lejos"): quieter by >= --level-drop-db. Distance always costs
         level, and the proximity effect costs body: EQ + gain.
       - loud ("fuerte"): louder by >= --loud-db. Pressed / shouted phonation
         thins the voice while the level goes up: gain down only, no EQ.
       - in between: probably the vowel itself; left alone.
  5. correction plan per flagged syllable, frame by frame:
       - deficit curve: neighbours' H1+H2 minus this frame's, smoothed.
       - hits (glottal onsets: frames HIT_DB over the syllable sustain, plus
         HIT_HOLD_S of their decay) are never processed. The correction starts
         at the first non-hit frame where the deficit holds for HOLD_S and ends
         where it stops holding; marker and fades follow that window, not the
         syllable edges.
       - the H1+H2 deficit only detects; it is too vowel-dependent to dose
         the EQ. The dose comes from physics: the level gap gives the distance
         ratio (inverse square: 6 dB = twice as far), and the cardioid
         proximity effect |1 + 1/(2jkr)| at both distances gives the bass the
         singer lost. A first-order low shelf at the 3 dB point of the normal
         distance (c / 4 pi r) is fitted to that loss curve: no fixed limit.
       - levels are compared in perceived loudness (K-weighting, as LUFS):
         the unweighted gap is mostly the lost body itself. The diagnosis and
         the level move use the K gap; gain = share x K gap minus the
         loudness the shelf already adds. A dip is often phrasing, so LEJOS
         lifts --level-amount (0.45) of it; a shout sticks out, so FUERTE
         pulls down --loud-amount (0.8). Defaults come from hand corrections.
       - FUERTE: the hit right before the window comes down by --hit-share of
         the vowel's gain, so the hit does not stick out once the vowel drops.
  6. output per correction: kind, windows (source seconds), shelf Hz / dB and
     gain dB. The CLI writes them as take automation (volume envelope + a
     "Proximity EQ" ReaEQ take FX with an automated shelf gain) or, with
     --render, as a corrected WAV.

Requires numpy and scipy.
"""
import argparse
import json
import os
import sys

import numpy as np
from scipy.ndimage import maximum_filter1d
from scipy.signal import find_peaks, stft

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from declip import read_wav, DeclipError  # noqa: E402

HOP_S = 0.010
WIN_S = 0.046
F0_MIN, F0_MAX = 70.0, 1000.0
CLARITY = 0.6            # min normalized autocorrelation peak for a voiced frame
GATE_DB = 30.0           # frames below take p95 - GATE_DB are silence
CORE_DB = 10.0           # syllable core: frames no more than this below the syllable median
VALLEY_DB = 4.0          # level valley prominence that splits two syllables
MIN_SYL_S = 0.08
PHRASE_GAP_S = 0.35      # syllables closer than this belong to the same phrase
NEIGHBOURS = 3
OCTAVE_DB = 8.0          # odd harmonics this far below even ones: f0 is an octave low
SPEED_OF_SOUND = 343.0
STFT_N, STFT_HOP = 2048, 512
FIX_FADE_S = 0.020       # gain curves are smoothed with this window
HIT_DB = 6.0             # frames this far over the syllable sustain are hits
HIT_HOLD_S = 0.030       # a hit's decay is protected for this long
HOLD_S = 0.050           # deficit must hold this long to start / keep correcting
ONSET_RISE_S = 0.050     # a HIT_DB rise within this time is a syllable onset
DEFICIT_MEDIAN = 9       # frames of median smoothing on the deficit curve


def frame_f0(x, sr, centers, win):
    """Autocorrelation pitch per frame, FFT-based, in chunks."""
    half = win // 2
    lo, hi = int(sr / F0_MAX), int(sr / F0_MIN)
    nfft = 1 << int(np.ceil(np.log2(2 * win)))
    f0 = np.zeros(len(centers))
    clar = np.zeros(len(centers))
    pad = np.concatenate([np.zeros(half), x, np.zeros(half)])
    taper = np.hanning(win)
    for a in range(0, len(centers), 2048):
        idx = centers[a:a + 2048]
        frames = np.stack([pad[c:c + win] for c in idx]) * taper
        frames -= frames.mean(axis=1, keepdims=True)
        spec = np.fft.rfft(frames, nfft)
        ac = np.fft.irfft(np.abs(spec) ** 2, nfft)[:, :hi + 1]
        # undo the taper's lag bias so long periods are not penalized
        norm = np.correlate(taper, taper, "full")[win - 1:win + hi]
        ac = ac / np.maximum(norm, 1e-9) * norm[0]
        e = ac[:, 0]
        ok = e > 1e-12
        lag = lo + np.argmax(ac[:, lo:hi], axis=1)
        peak = ac[np.arange(len(idx)), lag] / np.where(ok, e, 1)
        f0[a:a + len(idx)] = np.where(ok, sr / lag, 0.0)
        clar[a:a + len(idx)] = np.where(ok, peak, 0.0)
    return f0, clar


def robust_fit(xv, yv):
    A = np.vstack([xv, np.ones_like(xv)]).T
    w = np.ones_like(yv)
    coef = np.array([0.0, float(np.median(yv))])
    for _ in range(6):
        coef, *_ = np.linalg.lstsq(A * w[:, None], yv * w, rcond=None)
        r = yv - A @ coef
        s = 1.4826 * np.median(np.abs(r)) + 1e-9
        w = 1.0 / np.maximum(1.0, np.abs(r) / (2.0 * s))
    return coef, float(s)


def runs_of(mask):
    """(start, end) index pairs of True runs."""
    d = np.diff(np.concatenate([[0], mask.astype(int), [0]]))
    return list(zip(np.where(d == 1)[0], np.where(d == -1)[0]))


def analyse(x, sr, p):
    hop, win = int(HOP_S * sr), int(WIN_S * sr)
    nfft = 1 << int(np.ceil(np.log2(win * 2)))
    f, t, Z = stft(x, sr, nperseg=win, noverlap=win - hop, nfft=nfft, boundary=None, padded=False)
    P = np.abs(Z) ** 2

    def band(lo, hi):
        return P[(f >= lo) & (f < hi)].sum(axis=0) + 1e-20

    level = 10 * np.log10(P.sum(axis=0) + 1e-20)
    k_w = 10 ** (kweight_db(f) / 10)
    level_k = 10 * np.log10((P * k_w[:, None]).sum(axis=0) + 1e-20)
    e_pres = band(1000, 4000)
    e_sib = band(5000, 12000)
    centers = np.round(t * sr).astype(int)
    f0, clar = frame_f0(x, sr, centers, win)

    floor = np.percentile(level, 95) - GATE_DB
    voiced = (level > floor) & (clar > CLARITY) & (e_sib < e_pres) & (f0 > 0)
    if voiced.sum() < 50:
        raise DeclipError("Not enough voiced audio to build the singer model.")

    df = f[1] - f[0]

    def harm(i, fk):
        a, b = int(np.floor(fk * 0.94 / df)), int(np.ceil(fk * 1.06 / df)) + 1
        return P[a:b, i].sum()

    # octave-low pitch errors: the real harmonics sit on the even multiples only
    for i in np.where(voiced)[0]:
        if f0[i] * 4 >= 8000:
            continue
        odd = harm(i, f0[i]) + harm(i, 3 * f0[i])
        even = harm(i, 2 * f0[i]) + harm(i, 4 * f0[i])
        if 10 * np.log10((even + 1e-20) / (odd + 1e-20)) > OCTAVE_DB:
            f0[i] *= 2

    # H1 + H2 energy, bins within +-6 % of each harmonic
    h12 = np.full(len(t), np.nan)
    e_h12 = np.zeros(len(t))
    for i in np.where(voiced)[0]:
        e_h12[i] = harm(i, f0[i]) + harm(i, 2 * f0[i])
        h12[i] = 10 * np.log10((e_h12[i] + 1e-20) / e_pres[i])
    mask = (f >= 80) & (f < 8000)
    centroid = (P[mask] * f[mask, None]).sum(axis=0) / (P[mask].sum(axis=0) + 1e-20)

    vi = np.where(voiced)[0]
    coef, sigma = robust_fit(np.log2(f0[vi]), h12[vi])
    resid = np.full(len(t), np.nan)
    resid[vi] = h12[vi] - (coef[0] * np.log2(f0[vi]) + coef[1])

    # voiced runs (bridging gaps of <= 3 frames), split at level valleys
    runs, i = [], 0
    while i < len(t):
        if not voiced[i]:
            i += 1
            continue
        j = i
        while j < len(t) and (voiced[j] or voiced[j + 1:j + 4].any()):
            j += 1
        runs.append((i, j))
        i = j
    smooth = np.convolve(level, np.ones(5) / 5, "same")
    min_frames = int(MIN_SYL_S / HOP_S)
    syl = []
    rise_n = max(1, int(round(ONSET_RISE_S / HOP_S)))
    for a, b in runs:
        valleys, _ = find_peaks(-smooth[a:b], prominence=VALLEY_DB, distance=12)
        # a sharp level rise (glottal onset) starts a new syllable even without a valley
        seg_level = smooth[a:b]
        floor_before = np.array([seg_level[max(0, k - rise_n):k + 1].min() for k in range(b - a)])
        onsets, _ = find_peaks(seg_level - floor_before, height=HIT_DB, distance=12)
        onset_cuts = [max(0, k - rise_n) + int(np.argmin(seg_level[max(0, k - rise_n):k + 1])) for k in onsets]
        inner = sorted(set(int(c) for c in list(valleys) + onset_cuts if min_frames <= c <= b - a - 1))
        cuts = [a] + [a + c for c in inner] + [b]
        for s0, s1 in zip(cuts[:-1], cuts[1:]):
            if s1 - s0 < min_frames:
                continue
            seg = np.arange(s0, s1)
            v = seg[voiced[s0:s1]]
            if len(v) < 4:
                continue
            core = v[level[v] >= np.median(level[v]) - CORE_DB]
            if len(core) < 3:
                continue
            syl.append({
                "i0": s0, "i1": s1,
                "start": float(t[s0] - WIN_S / 2), "end": float(t[s1 - 1] + WIN_S / 2),
                "f0": float(np.median(f0[core])),
                "level": float(np.median(level[core])),
                "level_k": float(np.median(level_k[core])),
                "h12": float(np.median(resid[core])),
                "centroid": float(np.median(centroid[core])),
            })

    # phrases and local comparison
    phrase = 0
    for k, s in enumerate(syl):
        if k and s["start"] - syl[k - 1]["end"] > PHRASE_GAP_S:
            phrase += 1
        s["phrase"] = phrase
    take_level = np.percentile([s["level"] for s in syl], 90) if syl else 0.0
    frames = {"t": t, "level": level, "level_k": level_k, "resid": resid, "voiced": voiced, "f0": f0,
              "e_h12": e_h12, "P": P, "f": f, "k_w": k_w}
    found = []
    for k, s in enumerate(syl):
        same = [n for n in syl[max(0, k - NEIGHBOURS):k + NEIGHBOURS + 1] if n is not s and n["phrase"] == s["phrase"]]
        if len(same) < 2 or s["level"] < take_level - p.min_level_db:
            continue
        ref_h12 = float(np.median([n["h12"] for n in same]))
        ref_level = float(np.median([n["level"] for n in same]))
        ref_level_k = float(np.median([n["level_k"] for n in same]))
        d_h12 = s["h12"] - ref_h12
        d_level = s["level"] - ref_level
        d_cent = float(np.log2(s["centroid"] / np.median([n["centroid"] for n in same])))
        z = s["h12"] / sigma
        if d_h12 > -p.h12_drop_db or z > -p.min_z:
            continue
        plan = plan_fix(s, ref_h12, ref_level, ref_level_k, frames, p)
        if plan is None:
            continue
        found.append({
            "start": round(s["start"], 3), "end": round(s["end"], 3),
            "f0_hz": round(s["f0"], 1),
            "h12_drop_db": round(d_h12, 1),
            "level_drop_db": round(d_level, 1),
            "centroid_rise_oct": round(d_cent, 2),
            "take_z": round(z, 2),
            "score": round(-d_h12 + max(0.0, -d_level) + 6 * max(0.0, d_cent), 1),
            **plan["summary"],
            "_plan": plan,
        })
    model = {"h12_slope_db_per_oct": round(float(coef[0]), 2), "h12_sigma_db": round(sigma, 2),
             "syllables": len(syl)}
    return found, model


def plan_fix(s, ref_h12, ref_level, ref_level_k, fr, p):
    """Frame-level EQ / gain plan for one flagged syllable, or None."""
    i0, i1 = s["i0"], s["i1"]
    t, level = fr["t"][i0:i1], fr["level"][i0:i1]
    v = fr["voiced"][i0:i1]
    n = i1 - i0
    # hit = sharp rise (>= HIT_DB within ONSET_RISE_S) until the level has fallen
    # HIT_DB from its peak, plus HIT_HOLD_S. Relative to the hit itself, not to the
    # syllable median, so a loud but steady vowel start is not mistaken for a hit.
    hit = np.zeros(n, bool)
    hold = max(1, int(round(HIT_HOLD_S / HOP_S)))
    rise_n = max(1, int(round(ONSET_RISE_S / HOP_S)))
    lv_full = fr["level"]
    rise = np.array([lv_full[i0 + k] - lv_full[max(0, i0 + k - rise_n):i0 + k + 1].min() for k in range(n)])
    peaks, _ = find_peaks(np.concatenate([[-np.inf], level, [-np.inf]]))
    sustain = float(np.median(level[v]))
    for pk in peaks - 1:
        lo = max(0, pk - rise_n)
        if level[pk] < sustain + HIT_DB:
            continue  # wobble inside the vowel, not a glottal hit
        if level[pk] - lv_full[max(0, i0 + pk - rise_n):i0 + pk + 1].min() < HIT_DB and rise[lo:pk + 1].max() < HIT_DB:
            continue
        end = pk
        while end < n - 1 and level[end] > level[pk] - HIT_DB:
            end += 1
        hit[max(0, lo):min(n, end + hold)] = True

    deficit = np.full(n, np.nan)
    deficit[v] = ref_h12 - fr["resid"][i0:i1][v]
    good = ~np.isnan(deficit)
    if good.sum() < 3:
        return None
    deficit = np.interp(np.arange(n), np.where(good)[0], deficit[good])
    padded = np.pad(deficit, DEFICIT_MEDIAN // 2, mode="edge")
    deficit = np.median(np.lib.stride_tricks.sliding_window_view(padded, DEFICIT_MEDIAN), axis=1)

    need = max(1, int(round(HOLD_S / HOP_S)))
    active = (deficit >= p.h12_drop_db / 2) & ~hit & v
    windows = [(a, b) for a, b in runs_of(active) if b - a >= need]
    if not windows:
        return None
    mask = np.zeros(n, bool)
    for a, b in windows:
        mask[a:b] = True

    # body (unweighted) gap doses the shelf; perceived (K-weighted) gap decides the
    # diagnosis and the level move: lost low/mid energy is body, not loudness
    gap = ref_level - float(np.median(level[mask]))
    gap_k = ref_level_k - float(np.median(fr["level_k"][i0:i1][mask]))
    if gap_k >= p.level_drop_db:
        kind = "lejos"
    elif gap_k <= -p.loud_db:
        kind = "fuerte"
    else:
        return None  # thinner at the same loudness: most likely the vowel itself

    r_near = p.mic_cm / 100.0
    r_far = r_near * 10 ** (max(gap, 0.0) / 20) if kind == "lejos" else r_near
    shelf_hz = shelf_freq(r_near)
    shelf_db = fit_shelf_db(shelf_hz, r_near, r_far, p.amount) if kind == "lejos" else 0.0
    # loudness the shelf adds on this audio, from the K-weighted spectrum of the window
    cols = np.arange(i0, i1)[mask]
    power = fr["P"][:, cols].sum(axis=1) * fr["k_w"]
    eq_rise = 10 * np.log10((power * 10 ** (shelf_model_db(fr["f"], shelf_hz, shelf_db) / 10)).sum()
                            / (power.sum() + 1e-20) + 1e-20)
    share = p.level_amount if kind == "lejos" else p.loud_amount
    gain_db = float(gap_k * share - eq_rise)
    spans = [[round(float(t[a] - HOP_S / 2), 3), round(float(t[b - 1] + HOP_S / 2), 3)] for a, b in windows]

    # FUERTE: a hit right before the window comes down too, by HIT share of the
    # gain, so lowering the vowel does not leave the hit sticking out
    hit_span = None
    hit_gain_db = 0.0
    if kind == "fuerte" and gain_db < 0:
        first = windows[0][0]
        k = first - 1
        while k >= 0 and not hit[k]:
            k -= 1
        if k >= 0 and first - k <= need:
            a = k
            while a > 0 and hit[a - 1]:
                a -= 1
            hit_span = [round(float(t[a] - HOP_S / 2), 3), round(float(t[k] + HOP_S / 2), 3)]
            hit_gain_db = gain_db * p.hit_share
    plan_mask = mask.astype(float)
    return {
        "times": t, "mask": plan_mask, "shelf_hz": shelf_hz, "shelf_db": shelf_db, "gain_db": gain_db,
        "hit_span": hit_span, "hit_gain_db": hit_gain_db,
        "summary": {
            "kind": kind,
            "fix_start": spans[0][0], "fix_end": spans[-1][1],
            "windows": spans,
            "hit_window": hit_span,
            "hit_gain_db": round(hit_gain_db, 2),
            "distance_ratio": round(r_far / r_near, 2),
            "shelf_hz": round(shelf_hz),
            "shelf_db": round(shelf_db, 2),
            "fix_level_gap_db": round(gap_k, 1),
            "body_gap_db": round(gap, 1),
            "fix_level_from_eq_db": round(float(eq_rise), 2),
            "fix_level_db": round(gain_db, 2),
        },
    }


def kweight_db(f):
    """ITU-R BS.1770 K-weighting magnitude: +4 dB high shelf (~1.7 kHz) and RLB high-pass (~38 Hz)."""
    f = np.maximum(f, 1.0)
    shelf = 10 * np.log10((1 + (f / 1681.0) ** 2 * 10 ** 0.4) / (1 + (f / 1681.0) ** 2))
    hp = 10 * np.log10((f / 38.0) ** 4 / (1 + (f / 38.0) ** 4))
    return shelf + hp


def proximity_db(f, r):
    """Cardioid proximity bass lift at distance r (m): |1 + 1/(2jkr)| in dB."""
    k = 2 * np.pi * np.maximum(f, 1.0) / SPEED_OF_SOUND
    return 10 * np.log10(1.0 + 1.0 / (2 * k * r) ** 2)


def proximity_loss_db(f, r_near, r_far):
    return proximity_db(f, r_near) - proximity_db(f, r_far)


def shelf_freq(r_near):
    """Where the cardioid proximity lift is 3 dB at the normal distance (2kr = 1)."""
    return SPEED_OF_SOUND / (4 * np.pi * r_near)


def shelf_model_db(f, fc, gain_db):
    """First-order low shelf: gain_db at DC, half (in power) at fc, 0 dB on top."""
    a = 10 ** (gain_db / 10)
    f2 = np.maximum(f, 1.0) ** 2
    return 10 * np.log10((f2 + a * fc ** 2) / (f2 + fc ** 2))


def fit_shelf_db(fc, r_near, r_far, amount):
    """Shelf gain at fc whose curve best matches amount x the proximity loss (60 Hz - 2 kHz)."""
    f = np.geomspace(60, 2000, 64)
    target = amount * proximity_loss_db(f, r_near, r_far)
    gains = np.arange(0.0, 40.0, 0.05)
    err = [np.mean((shelf_model_db(f, fc, g) - target) ** 2) for g in gains]
    return float(gains[int(np.argmin(err))])


def smooth_env(v, sr, ms):
    n = max(1, int(ms / 1000.0 * sr))
    return np.convolve(v, np.ones(n) / n, "same")


def render_fix(data, sr, syllables):
    """Per plan: time-varying low shelf (same model as --apply's ReaEQ) in the STFT, then gain.

    The EQ amount and the gain follow the planned window, smoothed over
    FIX_FADE_S, so they fade around it and dip under hits. A limiter keeps
    every sample under the syllable's original peak.
    """
    from scipy.signal import istft
    y = data.copy()
    pad = int(0.2 * sr)
    for syl in sorted(syllables, key=lambda s: s["start"]):
        plan = syl.get("_plan")
        if plan is None:
            continue
        t = plan["times"]
        s0 = max(0, int(t[0] * sr) - pad)
        s1 = min(len(y), int(t[-1] * sr) + pad)
        n_t = np.arange(s0, s1) / sr
        inside = smooth_env(np.interp(n_t, t, plan["mask"], left=0, right=0), sr, FIX_FADE_S * 1000)
        gain_curve = inside * plan["gain_db"]
        if plan.get("hit_span"):
            h0, h1 = plan["hit_span"]
            in_hit = ((n_t >= h0) & (n_t < h1)).astype(float)
            gain_curve = gain_curve + smooth_env(in_hit, sr, FIX_FADE_S * 1000) * plan["hit_gain_db"]
        dry = y[s0:s1]
        eq_only = dry
        if plan["shelf_db"] > 0:
            f, ft, Z = stft(dry, sr, nperseg=STFT_N, noverlap=STFT_N - STFT_HOP, axis=0)
            curve = shelf_model_db(f, plan["shelf_hz"], plan["shelf_db"])
            w_frames = np.interp(ft, np.arange(len(inside)) / sr, inside)
            gains = 10 ** ((curve[:, None] * w_frames[None, :]) / 20)
            _, out = istft(Z * gains[:, None, :], sr, nperseg=STFT_N, noverlap=STFT_N - STFT_HOP,
                           time_axis=-1, freq_axis=0)
            out = np.asarray(out).T if np.asarray(out).shape[0] != len(dry) else np.asarray(out)
            eq_only = out[:len(dry)].reshape(dry.shape) if out.size >= dry.size else dry
        cand = dry + inside[:, None] * (eq_only - dry)
        cand = cand * (10 ** (gain_curve / 20))[:, None]
        ref = np.abs(data[int(syl["start"] * sr):int(syl["end"] * sr)]).max() + 1e-12
        over = np.abs(cand).max(axis=1) / ref
        if over.max() > 1.0:
            red = 1.0 / np.maximum(1.0, maximum_filter1d(over, int(0.01 * sr) + 1))
            red = np.minimum(red, smooth_env(red, sr, 10))
            cand = np.clip(dry + (cand - dry) * red[:, None], -ref, ref)
        y[s0:s1] = cand
    return y


def write_wav_float(path, sr, data):
    import struct
    pcm = np.ascontiguousarray(data, dtype="<f4").tobytes()
    ch = data.shape[1]
    fmt = struct.pack("<HHIIHH", 3, ch, sr, sr * ch * 4, ch * 4, 32)
    fact = struct.pack("<I", data.shape[0])
    with open(path, "wb") as f:
        f.write(b"RIFF" + struct.pack("<I", 4 + 24 + 12 + 8 + len(pcm)) + b"WAVE")
        f.write(b"fmt " + struct.pack("<I", 16) + fmt)
        f.write(b"fact" + struct.pack("<I", 4) + fact)
        f.write(b"data" + struct.pack("<I", len(pcm)) + pcm)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("source")
    ap.add_argument("--start-s", type=float, default=0.0, help="report range start in source seconds")
    ap.add_argument("--end-s", type=float, default=None, help="report range end in source seconds")
    ap.add_argument("--h12-drop-db", type=float, default=6.0, help="min H1+H2 drop vs neighbours")
    ap.add_argument("--min-z", type=float, default=1.0, help="min H1+H2 deficit vs take model, in sigmas")
    ap.add_argument("--level-drop-db", type=float, default=1.5, help="quieter than neighbours by this: far")
    ap.add_argument("--loud-db", type=float, default=1.5, help="louder than neighbours by this: shouted")
    ap.add_argument("--amount", type=float, default=1.0, help="share of the body (proximity bass) loss restored")
    ap.add_argument("--level-amount", type=float, default=0.45, help="LEJOS: share of the perceived level dip lifted")
    ap.add_argument("--loud-amount", type=float, default=0.8, help="FUERTE: share of the perceived level excess pulled down")
    ap.add_argument("--hit-share", type=float, default=0.75, help="FUERTE: share of the gain applied to the hit before it")
    ap.add_argument("--mic-cm", type=float, default=10.0, help="normal singer-to-mic distance; closer = more bass at stake")
    ap.add_argument("--min-level-db", type=float, default=20.0, help="ignore syllables this far below take p90")
    ap.add_argument("--max", type=int, default=30, help="keep the N highest scores")
    ap.add_argument("--render", default=None, help="write a corrected float WAV of the whole source here")
    p = ap.parse_args(argv)
    try:
        sr, data = read_wav(p.source)
        x = data.mean(axis=1)
        found, model = analyse(x, sr, p)
    except DeclipError as e:
        print(json.dumps({"error": str(e)}))
        return 2
    end = p.end_s if p.end_s is not None else len(x) / sr
    found = [s for s in found if s["end"] > p.start_s and s["start"] < end]
    found = sorted(found, key=lambda s: -s["score"])[:max(1, p.max)]
    found.sort(key=lambda s: s["start"])
    rendered = None
    if p.render:
        write_wav_float(p.render, sr, render_fix(data, sr, found))
        rendered = p.render
    for syl in found:
        syl.pop("_plan", None)
    print(json.dumps({"ok": True, "sampleRate": sr, "model": model, "syllables": found, "rendered": rendered}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
