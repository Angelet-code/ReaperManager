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


def process_channel(x, s0, s1, sr, p):
    clip = float(np.abs(x).max())
    stats = {"clip": clip, "runs": 0, "lowered": 0, "compressed": 0, "solver_fails": 0}
    if clip <= 0:
        return [], stats
    headroom_db = 20 * np.log10(ABS_CEIL / clip)
    stats["headroom_db"] = headroom_db
    if headroom_db < p.min_headroom_db:
        raise DeclipError(
            f"Clip level is {20 * np.log10(clip):.1f} dBFS: only {headroom_db:.1f} dB of headroom to rebuild "
            f"peaks. Render the take with lower gain first (e.g. -6 dB) and run declip on the new take.")
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
    ap.add_argument("--threshold", type=float, default=0.97, help="plateau detection, x clip level")
    ap.add_argument("--edge", type=int, default=2, help="neighbour samples rebuilt each side")
    ap.add_argument("--anchor-ms", type=float, default=60.0, help="intact-peak search window each side")
    ap.add_argument("--slew-db", type=float, default=1.5, help="max change between consecutive main peaks")
    ap.add_argument("--knee-db", type=float, default=2.0, help="excess left untouched below this")
    ap.add_argument("--max-db", type=float, default=6.5, help="soft ceiling of the excess over clip")
    ap.add_argument("--keep", type=float, default=0.8, help="min fraction of crest excess kept when compressing")
    ap.add_argument("--min-headroom-db", type=float, default=1.0)
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
