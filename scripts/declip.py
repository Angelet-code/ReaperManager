#!/usr/bin/env python3
"""Rebuild clipped peaks of a WAV source as REAPER sample edits.

Reads the source file directly, finds clipped plateaus inside a sample range and
writes a JSON list of (source sample index, new value) per channel. The values
are meant for REAPER's per-take sample edits (SAMPLEEDITS/<SPLS> in the item
chunk), so nothing is rendered and the original file is never modified.

Per clipped run:
  1. detection: |x| >= threshold * clip level, short same-polarity dips inside a
     plateau are bridged, and `edge` neighbouring samples are rebuilt too. A run
     only counts if it holds >= 2 consecutive samples at the clip level, so
     natural peaks of unclipped audio are left alone.
  2. target height (dB re clip), averaged from:
       - anchor: trend line (dB vs time) through the nearest intact main peaks of
         the same polarity on each side, extrapolated into the run
       - slope: parabola continuing the entry/exit slopes of the intact samples
       - micro: opposite-polarity peak of the same period x voice asymmetry
     then soft-knee limited and slew-limited along the main-peak sequence.
  3. curve: minimum-jerk (3rd difference energy) curve through 3 intact samples
     on each side, above every truly flat plateau sample, lifted to the target.
     If it is spikier than the intact audio around it the target is lowered; if
     it is taller than the target its crest is compressed with E*tanh(e/E).
  4. LF balance: per transient, the rebuilt excess of each run is rescaled so
     the runs together add no low-frequency pulse (see lf_balance).

Default method (--method spade): A-SPADE (Kitic et al. 2015). In frames of
--spade-frame samples around the clipped runs (75 % overlap), the signal that is
sparsest in an oversampled DFT and consistent with the observation (intact
samples equal, clipped ones at least as far out, same sign) is found by ADMM
with hard thresholding, then Hann-weighted overlap-added. On synthetic truth
(real vocal onsets clipped ~9 dB deep) it scored the best SDR of the methods
tried: 20.8 dB overall and 14.8 dB above 500 Hz (clipped: 11.6 / 7.9, LSAR:
16.0 / 12.6), with peaks 0.6 dB under the truth (LSAR: 2.3 dB under, which is
heard as residual clipping).

Alternative (--method lsar): consistent least-squares autoregressive
interpolation (Janssen et al.). Around each group of clipped runs an AR model
of --lsar-order is fitted on the intact audio of the window, and the clipped
samples are filled with the values that minimise the model's prediction error
over the whole window, never below their observed magnitude, same sign. It
imposes no peak shape, so it suits voice, drums or bass alike. Against
synthetic truth (unclipped onsets of a real vocal clipped ~6 dB deep) it cut
the error 4-10 dB below the clipped signal in every band, where the legacy
curve model made 0.4-8 kHz worse than leaving the clip alone.

The legacy model (--method curve) is kept for comparison:

Requires numpy and scipy.
"""
import argparse
import json
import struct
import sys

import numpy as np
from scipy.interpolate import CubicSpline
from scipy.optimize import minimize

ABS_CEIL = 0.98          # never write sample edits above this (REAPER clamps to [-1, 1])
MARGIN = 1.01            # rebuilt crest clears every flat plateau sample by ~0.1 dB
FLAT = 0.985             # plateau samples at >= this x clip must be cleared
GAP = 3                  # bridge dips of up to N samples inside a plateau
FIX = 3                  # intact samples each side held fixed by the curve solver
CONTEXT_S = 0.08         # read-only context around each block (anchor peaks)
BLOCK_S = 10.0           # process long ranges in blocks of this length
CEIL_KNEE_DB = 0.5       # rebuilt peaks above ABS_CEIL - this bend smoothly towards it (only what cannot fit)
LF_EVENT_S = 0.020       # rebuilt runs closer than this form one event for the LF balance
LF_PAD_S = 0.060         # LF of an event is measured this far around it
LF_SCALE_MIN, LF_SCALE_MAX = 0.3, 1.2   # per-run scale of the rebuilt excess


class DeclipError(Exception):
    pass


def read_wav(path):
    with open(path, "rb") as f:
        data = f.read()
    if data[:4] != b"RIFF" or data[8:12] != b"WAVE":
        raise DeclipError("Only RIFF/WAVE sources are supported.")
    fmt = None
    pcm = None
    i = 12
    while i + 8 <= len(data):
        cid = data[i:i + 4]
        size = struct.unpack("<I", data[i + 4:i + 8])[0]
        if cid == b"fmt ":
            tag, ch, sr, _, _, bits = struct.unpack("<HHIIHH", data[i + 8:i + 24])
            if tag == 0xFFFE and size >= 40:
                tag = struct.unpack("<H", data[i + 32:i + 34])[0]
            fmt = (tag, ch, sr, bits)
        elif cid == b"data":
            pcm = data[i + 8:i + 8 + size]
        i += 8 + size + (size & 1)
    if fmt is None or pcm is None:
        raise DeclipError("WAV file has no fmt or data chunk.")
    tag, ch, sr, bits = fmt
    if tag == 3 and bits == 32:
        x = np.frombuffer(pcm, dtype="<f4").astype(np.float64)
    elif tag == 3 and bits == 64:
        x = np.frombuffer(pcm, dtype="<f8").copy()
    elif tag == 1 and bits == 16:
        x = np.frombuffer(pcm, dtype="<i2") / 32768.0
    elif tag == 1 and bits == 24:
        b = np.frombuffer(pcm[:len(pcm) // 3 * 3], dtype=np.uint8).reshape(-1, 3).astype(np.int32)
        v = b[:, 0] | (b[:, 1] << 8) | (b[:, 2] << 16)
        x = np.where(v >= 1 << 23, v - (1 << 24), v) / 8388608.0
    elif tag == 1 and bits == 32:
        x = np.frombuffer(pcm, dtype="<i4") / 2147483648.0
    else:
        raise DeclipError(f"Unsupported WAV format (tag {tag}, {bits} bit).")
    frames = len(x) // ch
    return sr, x[:frames * ch].reshape(frames, ch)


def detect(seg, clip, p):
    thr = clip * p.threshold
    idx = np.arange(len(seg))
    bad = np.abs(seg) >= thr
    bi = idx[bad]
    for i0, i1 in zip(bi[:-1], bi[1:]):
        if 1 < i1 - i0 <= GAP + 1 and np.all(np.sign(seg[i0:i1 + 1]) == np.sign(seg[i0])):
            bad[i0:i1 + 1] = True
    # keep only real plateaus: 2 consecutive samples at the clip level, or 3 at >= FLAT
    at_clip = np.abs(seg) >= clip * 0.999
    near_clip = np.abs(seg) >= clip * FLAT
    pair = at_clip[:-1] & at_clip[1:]
    triple = near_clip[:-2] & near_clip[1:-1] & near_clip[2:]
    core = np.zeros_like(bad)
    bi = idx[bad]
    for r in (np.split(bi, np.where(np.diff(bi) != 1)[0] + 1) if len(bi) else []):
        if pair[r[0]:min(r[-1], len(pair) - 1) + 1].any() or triple[r[0]:min(r[-1], len(triple) - 1) + 1].any():
            core[r] = True
    grown = core.copy()
    for _ in range(p.edge):
        g = grown.copy(); g[1:] |= grown[:-1]; g[:-1] |= grown[1:]
        grown = g
    return core, grown, thr


def voice_ratio(x, s0, s1, sr, clip, thr):
    per = int(0.006 * sr)
    ctx = x[max(0, s0 - 3 * sr): s1 + 3 * sr]
    nb = len(ctx) // per
    if nb < 1:
        return 1.0
    blk = ctx[:nb * per].reshape(nb, per)
    bp, bn = blk.max(1), -blk.min(1)
    ok = (bp < thr) & (bn < thr) & (bp > 0.3 * clip) & (bn > 0.3 * clip)
    return float(np.median(bn[ok] / bp[ok])) if ok.sum() > 20 else 1.0


def declip_block(seg, lo, hi, clip, sr, ratio, p, stats):
    """Rebuild runs whose samples lie in seg[lo:hi]; seg[:lo] and seg[hi:] are context."""
    core, bad, thr = detect(seg, clip, p)
    clipped = bad.copy(); clipped[:lo] = False; clipped[hi:] = False
    idx = np.arange(len(seg))
    ci = idx[clipped]
    if len(ci) == 0:
        return seg, ci
    runs = [r for r in np.split(ci, np.where(np.diff(ci) != 1)[0] + 1) if core[r].any()]
    if not runs:
        return seg, np.zeros(0, int)

    per, half = int(0.006 * sr), int(0.004 * sr)
    good = ~bad
    y_spline = seg.copy()
    y_spline[clipped] = CubicSpline(idx[good], seg[good])(idx[clipped])
    ratio_for = {-1: ratio, 1: 1.0 / ratio}

    def soft(e):
        e = max(e, 0.0)
        k0, emax = p.knee_db, p.max_db
        return e if e < k0 else k0 + (emax - k0) * np.tanh((e - k0) / (emax - k0))

    # intact main peaks per polarity (anchors)
    zc = np.where(np.diff(np.signbit(seg)))[0] + 1
    bounds = np.concatenate(([0], zc, [len(seg)]))
    intact = {-1: [], 1: []}
    for a_, b_ in zip(bounds[:-1], bounds[1:]):
        if b_ - a_ < 2:
            continue
        h = seg[a_:b_]
        pol = 1 if h.sum() > 0 else -1
        pk = (pol * h).max()
        if pk < 0.3 * clip or bad[a_:b_].any():
            continue
        intact[pol].append((a_ + int(np.argmax(pol * h)), 20 * np.log10(pk / clip)))
    for pol in (-1, 1):
        lst = intact[pol]
        if not lst:
            intact[pol] = (np.zeros(0, int), np.zeros(0))
            continue
        cs = np.array([q[0] for q in lst]); db = np.array([q[1] for q in lst])
        keep = np.array([db[i] >= db[np.abs(cs - cs[i]) <= per].max() + 20 * np.log10(0.6)
                         for i in range(len(cs))])
        intact[pol] = (cs[keep], db[keep])

    win = int(p.anchor_ms / 1000 * sr)

    def side_fit(c, pol, side):
        cs, db = intact[pol]
        m = ((cs < c) & (cs >= c - win)) if side < 0 else ((cs > c) & (cs <= c + win))
        xs, ys = cs[m], db[m]
        if len(xs) == 0:
            return None
        order = np.argsort(np.abs(xs - c))[:6]
        xs, ys = xs[order], ys[order]
        dist = np.abs(xs - c).min()
        if len(xs) >= 3:
            return np.polyfit((xs - c) / sr, ys, 1)[1], dist
        return ys.max(), dist

    info = []
    for r in runs:
        c = int(r[len(r) // 2])
        pol = 1 if seg[r].sum() > 0 else -1
        floor_db = 20 * np.log10(np.abs(seg[r]).max() * MARGIN / clip)
        parts = []
        r0, r1 = r[0], r[-1]
        sl = pol * (seg[r0 - 1] - seg[r0 - 3]) / 2
        sr_ = pol * (seg[r1 + 1] - seg[r1 + 3]) / 2
        para = 0.5 * (pol * seg[r0 - 1] + pol * seg[r1 + 1]) + max(0.0, 0.5 * (sl + sr_)) * (len(r) + 1) / 4
        parts.append(20 * np.log10(max(para, 1e-9) / clip))
        fits = [f for f in (side_fit(c, pol, -1), side_fit(c, pol, 1)) if f is not None]
        if fits:
            w = np.array([1.0 / max(d, 1) for _, d in fits])
            parts.append(float(np.dot(w, [v for v, _ in fits]) / w.sum()))
        opp = (-pol * seg[max(0, c - half): c + half]).max()
        if 0.3 * clip < opp < thr:
            parts.append(20 * np.log10(ratio_for[pol] * opp / clip))
        info.append({"r": r, "c": c, "pol": pol, "floor": floor_db,
                     "t": max(soft(float(np.mean(parts))), floor_db)})

    # slew limit along main peaks of each polarity; intact peaks act as anchors
    run_of = {}
    for n, d in enumerate(info):
        for k in d["r"]:
            run_of[int(k)] = n
    for pol in (-1, 1):
        seq = []
        for a_, b_ in zip(bounds[:-1], bounds[1:]):
            if b_ - a_ < 2:
                continue
            h = seg[a_:b_]
            if (1 if h.sum() > 0 else -1) != pol:
                continue
            pk = (pol * h).max()
            if pk < 0.3 * clip:
                continue
            ri = next((run_of[k] for k in range(a_, b_) if k in run_of and info[run_of[k]]["pol"] == pol), None)
            seq.append([a_ + int(np.argmax(pol * h)), info[ri]["t"] if ri is not None else 20 * np.log10(pk / clip), ri])
        if not seq:
            continue
        vals = np.array([10 ** (q[1] / 20) for q in seq]); cs = np.array([q[0] for q in seq])
        main = [q for q, v, cc in zip(seq, vals, cs) if v >= 0.6 * vals[np.abs(cs - cc) <= per].max()]
        for forward in (True, False):
            order = range(1, len(main)) if forward else range(len(main) - 2, -1, -1)
            for i in order:
                prev = main[i - 1] if forward else main[i + 1]
                if main[i][2] is not None and main[i][1] > prev[1] + p.slew_db:
                    main[i][1] = max(prev[1] + p.slew_db, info[main[i][2]]["floor"])
        for q in main:
            if q[2] is not None:
                info[q[2]]["t"] = q[1]

    # jerk ceiling learned from intact audio in this block
    loc = np.sqrt(np.convolve(seg ** 2, np.ones(2 * per) / (2 * per), "same")) + 1e-9
    d3 = np.abs(np.diff(seg, 3))
    near = np.convolve(bad.astype(float), np.ones(9), "same") > 0
    okm = (~near[:-3]) & (loc[:-3] > 0.15 * clip)
    jerk_max = float(np.percentile(d3[okm] / loc[:-3][okm], 99.9)) if okm.sum() > 100 else 0.25

    def run_jerk(r, v):
        f = seg[r[0] - 5:r[-1] + 6].copy()
        f[5:5 + len(r)] = v
        return float((np.abs(np.diff(f, 3)) / loc[r[0] - 5:r[-1] + 3]).max())

    def solve(r, pol, floor, target):
        n = len(r)
        left, right = seg[r[0] - FIX:r[0]], seg[r[-1] + 1:r[-1] + 1 + FIX]

        def full(v):
            return np.concatenate((left, v, right))

        def obj(v):
            d = np.diff(full(v), 3)
            return float(d @ d)

        def grad(v):
            d = np.diff(full(v), 3)
            g = np.zeros(n + 2 * FIX)
            g[:-3] -= d; g[1:-2] += 3 * d; g[2:-1] -= 3 * d; g[3:] += d
            return 2 * g[FIX:FIX + n]

        eye = np.eye(n)
        cons = [{"type": "ineq", "fun": lambda v: pol * v - floor, "jac": lambda v: pol * eye},
                {"type": "ineq", "fun": lambda v: ABS_CEIL - pol * v, "jac": lambda v: -pol * eye}]
        v0 = pol * np.clip(pol * y_spline[r], floor, ABS_CEIL)
        res = minimize(obj, v0, jac=grad, constraints=cons, method="SLSQP",
                       options={"maxiter": 300, "ftol": 1e-12})
        if not res.success:
            stats["solver_fails"] += 1
        v = res.x
        flat_idx = np.where(floor > -1.0)[0]
        jm = int(round(flat_idx.mean())) if len(flat_idx) else n // 2
        if target > pol * v[jm]:
            cons2 = cons + [{"type": "ineq", "fun": lambda v: pol * v[jm] - target,
                             "jac": lambda v: pol * eye[jm]}]
            res2 = minimize(obj, v, jac=grad, constraints=cons2, method="SLSQP",
                            options={"maxiter": 300, "ftol": 1e-12})
            if res2.success:
                v = res2.x
            else:
                stats["solver_fails"] += 1
        return v

    y = seg.copy()
    edited = []
    for d in info:
        r, pol = d["r"], d["pol"]
        if r[0] < FIX + 5 or r[-1] + FIX + 6 > len(seg):
            continue
        flat = core[r] & (np.abs(seg[r]) >= FLAT * clip)
        floor = np.where(flat, np.abs(seg[r]) * MARGIN, -1.0)
        target = min(clip * 10 ** (d["t"] / 20), ABS_CEIL)
        v = solve(r, pol, floor, target)
        if run_jerk(r, v) > jerk_max:
            natural = solve(r, pol, floor, 0.0)
            if run_jerk(r, natural) <= jerk_max:
                lo_t, hi_t = (pol * natural).max(), target
                v = natural
                for _ in range(12):
                    mid = 0.5 * (lo_t + hi_t)
                    vm = solve(r, pol, floor, mid)
                    if run_jerk(r, vm) <= jerk_max:
                        lo_t, v = mid, vm
                    else:
                        hi_t = mid
            else:
                v = natural
            stats["lowered"] += 1
        e = pol * v - clip
        emax = e.max()
        want = max(target - clip, p.keep * emax)
        if emax > 0 and want < emax:
            lo_e, hi_e = 1e-6, 100.0
            for _ in range(60):
                mid = 0.5 * (lo_e + hi_e)
                if mid * np.tanh(emax / mid) < want:
                    lo_e = mid
                else:
                    hi_e = mid
            v = np.where(e > 0, pol * (clip + hi_e * np.tanh(np.maximum(e, 0) / hi_e)), v)
            stats["compressed"] += 1
        y[r] = v
        edited.append(r)
        stats["runs"] += 1
    return y, (np.concatenate(edited) if edited else np.zeros(0, int))


def block_cuts(x, s0, s1, clip, thr, block):
    """Block boundaries in [s0, s1], moved to spots with no clipping nearby."""
    cuts = [s0]
    pos = s0 + block
    while pos < s1:
        hot = np.abs(x[pos:min(s1, pos + block // 2)]) >= thr
        quiet = np.convolve(hot.astype(float), np.ones(129), "same") == 0
        hits = np.where(quiet)[0]
        if len(hits) == 0:
            pos += block // 2
            continue
        cuts.append(pos + int(hits[0]))
        pos = cuts[-1] + block
    cuts.append(s1)
    return cuts


def lf_balance(seg, y, touched, sr, p, stats):
    """Keep rebuilt peaks from adding a low-frequency thump.

    Each rebuilt run adds area of one sign. When a transient clips one polarity
    harder (common: the glottal pulse is asymmetric), those areas add up to a
    sub-fundamental pulse of tens of ms: a dull "clac" that is not voice. Per
    event (runs closer than LF_EVENT_S), the added signal of each run is scaled
    by s in [LF_SCALE_MIN, LF_SCALE_MAX] so its content under --lf-hz stays
    --lf-margin-db below the event peak, changing the runs as little as
    possible (cost = each run's own added energy). Shapes are kept; only the
    height of the rebuilt excess moves. Events already under target are untouched.
    """
    if not len(touched) or p.lf_margin_db <= 0:
        return y
    from scipy.optimize import lsq_linear
    from scipy.signal import butter, sosfiltfilt
    sos = butter(4, p.lf_hz, "low", fs=sr, output="sos")
    diff = y - seg
    runs = np.split(touched, np.where(np.diff(touched) > 1)[0] + 1)
    events = [[runs[0]]]
    for r in runs[1:]:
        if r[0] - events[-1][-1][-1] > LF_EVENT_S * sr:
            events.append([r])
        else:
            events[-1].append(r)
    pad = int(LF_PAD_S * sr)
    for ev in events:
        w0, w1 = max(0, ev[0][0] - pad), min(len(seg), ev[-1][-1] + pad + 1)
        cols = []
        for r in ev:
            v = np.zeros(w1 - w0)
            v[r - w0] = diff[r]
            cols.append(sosfiltfilt(sos, v))
        A = np.array(cols).T
        peak = max(float(np.abs(y[r]).max()) for r in ev)
        target = peak * 10 ** (-p.lf_margin_db / 20)
        if np.abs(A.sum(axis=1)).max() <= target:
            continue
        energy = np.array([np.linalg.norm(diff[r]) for r in ev])

        def solve(lam):
            w = np.sqrt(lam) * energy
            M = np.vstack([A, np.diag(w)])
            rhs = np.concatenate([np.zeros(len(A)), w])
            return lsq_linear(M, rhs, bounds=(LF_SCALE_MIN, LF_SCALE_MAX)).x

        lo_l, hi_l = 1e-5, 1e3          # largest lambda (least change) that meets the target
        best = solve(lo_l)
        for _ in range(24):
            mid = np.sqrt(lo_l * hi_l)
            sol = solve(mid)
            if np.abs(A @ sol).max() <= target:
                best, lo_l = sol, mid
            else:
                hi_l = mid
        for scale, r in zip(best, ev):
            y[r] = np.clip(seg[r] + scale * diff[r], -ABS_CEIL, ABS_CEIL)
        stats["lf_balanced"] += 1
        stats["lf_min_scale"] = min(stats["lf_min_scale"], float(best.min()))
    return y


def ar_fit(x, reliable, order):
    """Covariance-method AR fit on the rows whose samples are all reliable."""
    ok = np.convolve(reliable.astype(int), np.ones(order + 1, int), "valid") == order + 1
    rows = np.where(ok)[0] + order
    if len(rows) < order * 3:
        return None
    X = np.lib.stride_tricks.sliding_window_view(x, order)[rows - order][:, ::-1]
    G = X.T @ X
    if np.trace(G) < 1e-12:
        return None
    return np.linalg.solve(G + 1e-6 * np.trace(G) / order * np.eye(order), X.T @ x[rows])


def lsar_window(seg, missing, floor, a, max_iter=20):
    """Consistent LSAR (Janssen) fill of one window.

    Missing samples minimise the AR prediction error of the whole window, with
    each one kept at least at its observed magnitude (floor) and sign: samples
    that would fall short are pinned there and the rest re-solved.
    """
    from scipy.sparse import diags
    from scipy.sparse.linalg import lsqr
    n, order = len(seg), len(a)
    coef = np.concatenate([[1.0], -a])
    # H: (n - order) x n prediction-error operator, row t uses x[t-order .. t]
    H = diags([coef[k] * np.ones(n - order) for k in range(order, -1, -1)],
              list(range(0, order + 1)), shape=(n - order, n)).tocsc()
    sign = np.sign(seg)
    sign[sign == 0] = 1
    work = seg.copy()
    pinned = np.zeros(n, bool)
    for _ in range(max_iter):
        free = missing & ~pinned
        work[pinned] = sign[pinned] * floor[pinned]
        if not free.any():
            break
        Hm = H[:, free]
        b = -(H[:, ~free] @ work[~free])
        work[free] = lsqr(Hm, b, atol=1e-10, btol=1e-10, iter_lim=2000)[0]
        short = free & (sign * work < floor)
        if not short.any():
            break
        pinned |= short
    return work


def soft_ceiling(v, stats):
    """Rebuilt peaks taller than the headroom allows bend smoothly towards
    ABS_CEIL (tanh above CEIL_KNEE_DB under it) instead of being cut flat,
    which would just be a new clip. More headroom in the take avoids it."""
    knee = ABS_CEIL * 10 ** (-CEIL_KNEE_DB / 20)
    mag = np.abs(v)
    over = mag > knee
    if over.any():
        span = ABS_CEIL - knee
        mag = np.where(over, knee + span * np.tanh((mag - knee) / span), mag)
        stats["bent_to_ceiling"] = stats.get("bent_to_ceiling", 0) + int(over.sum())
    return np.sign(v) * mag


def declip_lsar(x, s0, s1, sr, clip, p, stats):
    """LSAR declip of x[s0:s1]; returns (index, value) pairs of changed samples."""
    ctx = int(p.lsar_context_ms / 1000 * sr)
    missing, core = unreliable(x, plateau_level(x) * p.threshold, p.guard, p.bridge, s0, s1)
    idx = np.where(missing)[0]
    if not len(idx):
        return []
    runs = np.split(idx, np.where(np.diff(idx) > 1)[0] + 1)
    stats["runs"] += len(runs)
    groups = [[runs[0]]]
    for r in runs[1:]:
        (groups[-1].append(r) if r[0] - groups[-1][-1][-1] < ctx else groups.append([r]))
    out = []
    for g in groups:
        w0, w1 = max(0, g[0][0] - ctx), min(len(x), g[-1][-1] + ctx + 1)
        seg = x[w0:w1].astype(np.float64)
        miss = missing[w0:w1]
        a = ar_fit(seg, ~miss, p.lsar_order)
        if a is None:
            stats["solver_fails"] += 1
            continue
        floor = np.where(core[w0:w1], np.abs(seg), -np.inf)
        filled = soft_ceiling(lsar_window(seg, miss, floor, a), stats)
        for i in np.where(miss)[0]:
            out.append([int(w0 + i), round(float(filled[i]), 9)])
    return out


def plateau_level(x):
    """Level of the clipped plateaus: the most crowded magnitude near the top.

    max(|x|) is wrong once the clip has been filtered: the overshoot entering
    each plateau sits above it, and the plateau itself ripples a little lower.
    A plateau piles many samples at one height; overshoots are a few strays."""
    a = np.abs(x)
    top = a.max()
    near = a[a >= top * 0.85]
    if len(near) < 50:
        return top
    hist, edges = np.histogram(near, bins=150)
    k = int(np.argmax(hist))
    return float((edges[k] + edges[k + 1]) / 2)


def unreliable(x, thr, guard, gap, s0, s1):
    """Clipped core (|x| >= thr, same-sign dips of <= gap samples bridged) plus
    `guard` samples each side. A clip followed by any filtering (converter,
    resampling) ripples and rings around each plateau, so those neighbours are
    not the true signal either: they are rebuilt freely, without a floor.
    Returns (missing, core) masks limited to [s0, s1)."""
    core = np.abs(x) >= thr
    idx = np.where(core)[0]
    for i0, i1 in zip(idx[:-1], idx[1:]):
        if 1 < i1 - i0 <= gap + 1 and np.sign(x[i0]) == np.sign(x[i1]):
            core[i0:i1 + 1] = True
    missing = core.copy()
    if guard > 0:
        k = np.ones(2 * guard + 1)
        missing = np.convolve(core.astype(float), k, "same") > 0
    for m in (core, missing):
        m[:s0] = False
        m[s1:] = False
    return missing, core


def aspade_frame(obs, clipped, red=2, eps_rel=0.01, max_it=500, core=None):
    """A-SPADE (Kitic et al. 2015) on one frame.

    Looks for the signal that is sparsest in an oversampled DFT (a Parseval
    frame, A^H A = I) and consistent with the observation: intact samples equal,
    clipped samples at least as far out as observed, same sign. The sparsity
    k grows by one each iteration until the consistent and the sparse
    estimates meet (ADMM with hard thresholding).
    """
    n = len(obs)
    nfft = n * red
    sq = np.sqrt(nfft)
    core = clipped if core is None else core
    pos = core & (obs > 0)
    neg = core & (obs < 0)
    rel = ~clipped

    def project(v):
        v[rel] = obs[rel]
        v[pos] = np.maximum(v[pos], obs[pos])
        v[neg] = np.minimum(v[neg], obs[neg])
        return v

    eps = eps_rel * np.linalg.norm(obs)
    x = obs.copy()
    u = np.zeros(nfft, complex)
    k = 1
    for _ in range(max_it):
        c = np.fft.fft(x, nfft) / sq + u
        keep = min(nfft, 2 * k)                     # conjugate pairs of a real signal
        mag = np.abs(c)
        z = np.where(mag >= np.partition(mag, nfft - keep)[nfft - keep], c, 0)
        x = project(np.real(np.fft.ifft(z - u))[:n] * sq)
        r = np.fft.fft(x, nfft) / sq - z
        if np.linalg.norm(r) <= eps:
            break
        u += r
        k += 1
    return x


def declip_spade(x, s0, s1, sr, clip, p, stats):
    """A-SPADE declip of x[s0:s1]; frames of --spade-frame with 75 % overlap
    around clipped samples, Hann-weighted overlap-add. Returns (index, value) pairs."""
    clipped, core = unreliable(x, plateau_level(x) * p.threshold, p.guard, p.bridge, s0, s1)
    idx = np.where(clipped)[0]
    if not len(idx):
        return []
    stats["runs"] += int(1 + (np.diff(idx) > 1).sum())
    n = len(x)
    frame = int(p.spade_frame)
    hop = frame // 4
    win = np.hanning(frame + 1)[:-1]
    starts = set()
    for i in idx:
        base = (i // hop) * hop
        for j in range(4):
            starts.add(min(max(0, base - j * hop), max(0, n - frame)))
    acc = np.zeros(n)
    wsum = np.zeros(n)
    for st in sorted(starts):
        m = clipped[st:st + frame]
        if not m.any():
            continue
        seg = x[st:st + frame].astype(np.float64)
        rec = aspade_frame(seg, m, core=core[st:st + frame])
        acc[st:st + frame] += rec * win[:len(rec)]
        wsum[st:st + frame] += win[:len(rec)]
        stats["frames"] = stats.get("frames", 0) + 1
    out = []
    vals = np.where(wsum[idx] > 1e-9, acc[idx] / np.maximum(wsum[idx], 1e-9), x[idx])
    # overlap-add can pull a core value back inside the clip level: keep consistency
    c = core[idx]
    vals = np.where(c & (x[idx] > 0), np.maximum(vals, x[idx]), vals)
    vals = np.where(c & (x[idx] < 0), np.minimum(vals, x[idx]), vals)
    vals = soft_ceiling(vals, stats)
    for i, v in zip(idx, vals):
        out.append([int(i), round(float(v), 9)])
    return out


def process_channel(x, s0, s1, sr, p):
    clip = float(np.abs(x).max())
    stats = {"clip": clip, "runs": 0, "lowered": 0, "compressed": 0, "solver_fails": 0,
             "lf_balanced": 0, "lf_min_scale": 1.0}
    if clip <= 0:
        return [], stats
    headroom_db = 20 * np.log10(ABS_CEIL / clip)
    stats["headroom_db"] = headroom_db
    if headroom_db < p.min_headroom_db:
        raise DeclipError(
            f"Clip level is {20 * np.log10(clip):.1f} dBFS: only {headroom_db:.1f} dB of headroom to rebuild "
            f"peaks. Render the take with lower gain first (e.g. -6 dB) and run declip on the new take.")
    if p.method in ("lsar", "spade"):
        stats["plateau_level"] = plateau_level(x)
        edits = (declip_spade if p.method == "spade" else declip_lsar)(x, s0, s1, sr, clip, p, stats)
        edits.sort(key=lambda e: e[0])
        stats["edits"] = len(edits)
        peak = max((abs(v) for _, v in edits), default=0.0)
        stats["peak_db_over_clip"] = 20 * np.log10(peak / clip) if peak > 0 else 0.0
        return edits, stats
    thr = clip * p.threshold
    ratio = voice_ratio(x, s0, s1, sr, clip, thr)
    stats["voice_ratio"] = ratio
    m = int(CONTEXT_S * sr)
    edits = []
    peak = 0.0
    cuts = block_cuts(x, s0, s1, clip, thr, int(BLOCK_S * sr))
    for b0, b1 in zip(cuts[:-1], cuts[1:]):
        lo = max(0, b0 - m)
        seg = x[lo:min(len(x), b1 + m)].astype(np.float64)
        y, touched = declip_block(seg, b0 - lo, b1 - lo, clip, sr, ratio, p, stats)
        y = lf_balance(seg, y, touched, sr, p, stats)
        for i in touched:
            edits.append([int(lo + i), round(float(y[i]), 9)])
        if len(touched):
            peak = max(peak, float(np.abs(y[touched]).max()))
    edits.sort(key=lambda e: e[0])
    stats["edits"] = len(edits)
    stats["peak_db_over_clip"] = 20 * np.log10(peak / clip) if peak > 0 else 0.0
    return edits, stats


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("source")
    ap.add_argument("--start", type=int, default=0, help="first source sample to repair")
    ap.add_argument("--end", type=int, default=None, help="end source sample (exclusive)")
    ap.add_argument("--start-s", type=float, default=None, help="range start in source seconds")
    ap.add_argument("--end-s", type=float, default=None, help="range end in source seconds")
    ap.add_argument("--channels", default="all", help="comma list of channel indexes or 'all'")
    ap.add_argument("--out", required=True, help="JSON output path")
    ap.add_argument("--method", choices=["spade", "lsar", "curve"], default="spade",
                    help="spade: sparse spectral fill (A-SPADE), default; lsar: autoregressive fill; curve: legacy")
    ap.add_argument("--spade-frame", type=int, default=2048, help="A-SPADE frame length in samples")
    ap.add_argument("--guard", type=int, default=3, help="spade/lsar: samples each side of a plateau rebuilt freely (ripple)")
    ap.add_argument("--bridge", type=int, default=3, help="spade/lsar: same-sign dips of up to N samples inside a plateau are bridged")
    ap.add_argument("--lsar-order", type=int, default=48, help="AR model order")
    ap.add_argument("--lsar-context-ms", type=float, default=12.0, help="reliable audio used around each clip")
    ap.add_argument("--threshold", type=float, default=0.97, help="plateau detection, x clip level")
    ap.add_argument("--edge", type=int, default=2, help="neighbour samples rebuilt each side")
    ap.add_argument("--anchor-ms", type=float, default=60.0, help="intact-peak search window each side")
    ap.add_argument("--slew-db", type=float, default=1.5, help="max change between consecutive main peaks")
    ap.add_argument("--knee-db", type=float, default=2.0, help="excess left untouched below this")
    ap.add_argument("--max-db", type=float, default=6.5, help="soft ceiling of the excess over clip")
    ap.add_argument("--keep", type=float, default=0.8, help="min fraction of crest excess kept when compressing")
    ap.add_argument("--min-headroom-db", type=float, default=1.0)
    ap.add_argument("--lf-hz", type=float, default=120.0, help="rebuilt peaks must not add content below this")
    ap.add_argument("--lf-margin-db", type=float, default=0.0, help="added LF kept this far under the event peak (0 = off, default)")
    p = ap.parse_args(argv)

    try:
        sr, data = read_wav(p.source)
        start = int(round(p.start_s * sr)) if p.start_s is not None else p.start
        end = int(round(p.end_s * sr)) if p.end_s is not None else (len(data) if p.end is None else p.end)
        start, end = max(0, start), min(end, len(data))
        if end - start < 16:
            raise DeclipError("Range is too short.")
        chans = range(data.shape[1]) if p.channels == "all" else [int(c) for c in p.channels.split(",")]
        out = {"source": p.source, "sampleRate": sr, "channelCount": data.shape[1],
               "start": start, "end": end, "channels": []}
        for ch in chans:
            edits, stats = process_channel(data[:, ch], start, end, sr, p)
            out["channels"].append({"channel": ch, "edits": edits, "stats": stats})
    except DeclipError as e:
        print(json.dumps({"error": str(e)}))
        return 2
    with open(p.out, "w") as f:
        json.dump(out, f)
    print(json.dumps({"ok": True, "sampleRate": sr, "start": start, "end": end,
                      "channels": [{"channel": c["channel"], **c["stats"]} for c in out["channels"]]}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
