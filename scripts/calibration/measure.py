# Ported from calibracion-librerias/resultados/measure.py (2026-11-02); used by scripts/calibrate-instrument.mjs.
"""Measure a calibration render against its spec: legato transition delay, attack time, CC -> dB response,
velocity -> dB, SWAM portamento time. Usage: python -I measure.py render.wav spec.json"""
import json
import sys
import numpy as np
from scipy.io import wavfile
from scipy.signal import stft

wav, spec = sys.argv[1], json.load(open(sys.argv[2]))
sr, x = wavfile.read(wav)
x = x.astype(np.float64)
peak = np.abs(x).max()
if peak > 2:
    x /= float(2 ** 31) if peak > 2 ** 24 else float(2 ** 23)
mono = x.mean(axis=1) if x.ndim > 1 else x

HOP = int(sr * 0.005)
frames = len(mono) // HOP
rms = np.sqrt(np.array([np.mean(mono[i * HOP:i * HOP + 2 * HOP] ** 2) for i in range(frames)]) + 1e-12)
db = lambda v: 20 * np.log10(max(v, 1e-9))
at = lambda t: min(frames - 1, max(0, int(t / 0.005)))

f, tt, Z = stft(mono, fs=sr, nperseg=4096, noverlap=4096 - HOP)
mag = np.abs(Z)
def band(freq):
    e = np.zeros(mag.shape[1])
    for h in (1, 2, 3):
        lo, hi = freq * h * 0.97, freq * h * 1.03
        e += mag[(f >= lo) & (f <= hi)].sum(axis=0)
    return e
hz = lambda p: 440 * 2 ** ((p - 69) / 12)
ti = lambda t: int(np.searchsorted(tt, t))

def attack(t0, t_end):
    steady = np.median(rms[at(t0 + 0.9):at(min(t_end, t0 + 1.9))])
    a = rms[at(t0 - 0.05):at(t_end)]
    def first(th):
        idx = np.where(a >= th)[0]
        return round((idx[0] * 0.005 - 0.05) * 1000) if len(idx) else None
    return {"onset_ms(-20dB)": first(steady * 0.1), "attack_ms(-6dB)": first(steady * 0.5), "steady_dB": round(db(steady), 1)}

def transition(b):
    e1, e2 = band(hz(b["p1"])), band(hz(b["p2"]))
    i0, i1 = ti(b["t2"] - 0.1), ti(b["end"])
    share = e2[i0:i1] / (e1[i0:i1] + e2[i0:i1] + 1e-9)
    def cross(th):
        idx = np.where(share >= th)[0]
        return round((tt[i0 + idx[0]] - b["t2"]) * 1000) if len(idx) else None
    return {"vel": b["vel"], "start_ms(20%)": cross(0.2), "mid_ms(50%)": cross(0.5), "done_ms(90%)": cross(0.9)}

def steps(lst):
    vals = [(s["value"], db(np.sqrt(np.mean(mono[int((s["t1"] - 0.8) * sr):int((s["t1"] - 0.05) * sr)] ** 2)))) for s in lst]
    top = max(v for _, v in vals)
    return [{"cc": c, "dB": round(v - top, 1)} for c, v in vals]

res = {"id": spec["id"], "patch": spec["patch"], "peak_dBFS": round(db(peak if peak <= 2 else np.abs(mono).max()), 1)}
k = spec["kind"]
if k == "legato":
    res["attack_by_vel"] = [{"vel": b["vel"], **attack(b["t1"], b["t2"])} for b in spec["blocks"]]
    res["legato_by_vel"] = [transition(b) for b in spec["blocks"]]
if k == "long":
    res["attack_by_cc1"] = [{"cc1": a["cc1"], **attack(a["t"], a["end"])} for a in spec["attacks"]]
    res["cc1_response"] = steps(spec["cc1"])
    res["cc11_response"] = steps(spec["cc11"])
if k == "short":
    out = []
    for h in spec["hits"]:
        seg = rms[at(h["t"] - 0.05):at(h["t"] + 0.6)]
        pk = seg.max()
        idx = np.where(seg >= pk * 0.1)[0]
        out.append({"cc1": h["cc1"], "vel": h["vel"], "peak_dB": round(db(pk), 1), "onset_ms": round((idx[0] * 0.005 - 0.05) * 1000) if len(idx) else None,
                    "to_peak_ms": round((int(np.argmax(seg)) * 0.005 - 0.05) * 1000)})
    top = max(o["peak_dB"] for o in out)
    for o in out:
        o["rel_dB"] = round(o["peak_dB"] - top, 1)
    res["shorts"] = out
if k == "swam":
    res["cc11_response"] = steps(spec["cc11"])
    res["portamento_by_vel"] = [transition(b) for b in spec["blocks"]]
    res["attack_first"] = attack(spec["blocks"][0]["t1"], spec["blocks"][0]["t2"])
print(json.dumps(res, indent=1))
