"""Mide un render del cue: nivel y bandas por medio compás, y detalle fino en una transición.
Uso: python -I analyze_render.py file.wav [bpm] [bar_from bar_to (detalle)]"""
import sys
import numpy as np
from scipy.io import wavfile
from scipy.signal import butter, sosfilt

path = sys.argv[1]
bpm = float(sys.argv[2]) if len(sys.argv) > 2 else 120.0
detail = (float(sys.argv[3]), float(sys.argv[4])) if len(sys.argv) > 4 else None

sr, x = wavfile.read(path)
x = x.astype(np.float64)
if x.dtype.kind == "i" or np.abs(x).max() > 2:
    x /= float(2 ** 31) if np.abs(x).max() > 2 ** 24 else float(2 ** 23)
mono = x.mean(axis=1) if x.ndim > 1 else x
bar_s = 4 * 60.0 / bpm

BANDS = {"sub<80": (None, 80), "grave 80-250": (80, 250), "medio 250-2k": (250, 2000), "agudo>2k": (2000, None)}
filtered = {}
for name, (lo, hi) in BANDS.items():
    if lo is None:
        sos = butter(4, hi, "lowpass", fs=sr, output="sos")
    elif hi is None:
        sos = butter(4, lo, "highpass", fs=sr, output="sos")
    else:
        sos = butter(4, [lo, hi], "bandpass", fs=sr, output="sos")
    filtered[name] = sosfilt(sos, mono)


def db(v):
    return 20 * np.log10(max(v, 1e-9))


def rms(sig, a, b):
    seg = sig[int(a * sr):int(b * sr)]
    return np.sqrt(np.mean(seg ** 2)) if len(seg) else 0.0


print(f"{'compás':>7} {'RMS':>6} {'pico':>6} " + " ".join(f"{n:>13}" for n in BANDS))
nbars = int(len(mono) / sr / bar_s + 0.999)
for half in range(nbars * 2):
    a, b = half * bar_s / 2, (half + 1) * bar_s / 2
    seg = mono[int(a * sr):int(b * sr)]
    if not len(seg):
        break
    label = f"{half // 2 + 1}{'.1' if half % 2 == 0 else '.3'}"
    print(f"{label:>7} {db(rms(mono, a, b)):6.1f} {db(np.abs(seg).max()):6.1f} "
          + " ".join(f"{db(rms(filtered[n], a, b)):13.1f}" for n in BANDS))

if detail:
    print(f"\nDetalle c.{detail[0]}–{detail[1]} (ventanas de 1/8 de tiempo = {bar_s / 32 * 1000:.0f} ms)")
    step = bar_s / 32
    t = (detail[0] - 1) * bar_s
    while t < (detail[1] - 1) * bar_s:
        bar = 1 + t / bar_s
        beat = (bar % 1) * 4
        print(f"  c.{int(bar)} t{beat + 1:4.2f}  RMS {db(rms(mono, t, t + step)):6.1f}  "
              + "  ".join(f"{n.split()[0]} {db(rms(filtered[n], t, t + step)):6.1f}" for n in BANDS))
        t += step
