"""Imagen estéreo por stem y de la mezcla: balance L/R, correlación, relación side/mid, centroide.
Uso: python -I stereo_report.py <carpeta_stems> <prefijo> <mezcla.wav>"""
import os
import sys
import numpy as np
from scipy.io import wavfile
from scipy.signal import butter, sosfilt

folder, prefix, mix_path = sys.argv[1], sys.argv[2], sys.argv[3]


def load(path):
    sr, x = wavfile.read(path)
    x = x.astype(np.float64)
    peak = np.abs(x).max()
    x /= float(2 ** 31) if peak > 2 ** 24 else float(2 ** 23) if peak > 2 else 1.0
    if x.ndim == 1:
        x = np.stack([x, x], axis=1)
    return sr, x


def db(v):
    return 20 * np.log10(max(v, 1e-12))


def band(x, sr, lo=None, hi=None):
    if lo is None:
        sos = butter(4, hi, "lowpass", fs=sr, output="sos")
    elif hi is None:
        sos = butter(4, lo, "highpass", fs=sr, output="sos")
    else:
        sos = butter(4, [lo, hi], "bandpass", fs=sr, output="sos")
    return sosfilt(sos, x, axis=0)


def stats(x, sr):
    # sólo donde el instrumento suena (ventanas de 50 ms por encima de -50 dBFS)
    win = int(0.05 * sr)
    n = len(x) // win
    frames = x[: n * win].reshape(n, win, 2)
    level = np.sqrt((frames ** 2).mean(axis=(1, 2)))
    active = level > 10 ** (-50 / 20)
    if not active.any():
        return None
    a = frames[active].reshape(-1, 2)
    L, R = a[:, 0], a[:, 1]
    M, S = (L + R) / 2, (L - R) / 2
    corr = float(np.corrcoef(L, R)[0, 1]) if L.std() > 0 and R.std() > 0 else 1.0
    spec = np.abs(np.fft.rfft(M[: sr * 8] if len(M) > sr * 8 else M))
    freqs = np.fft.rfftfreq(len(M[: sr * 8] if len(M) > sr * 8 else M), 1 / sr)
    centroid = float((spec * freqs).sum() / max(spec.sum(), 1e-12))
    return {
        "rms": db(np.sqrt((a ** 2).mean())),
        "bal": db(np.sqrt((L ** 2).mean())) - db(np.sqrt((R ** 2).mean())),  # + = más a la izquierda
        "corr": corr,
        "sm": db(np.sqrt((S ** 2).mean())) - db(np.sqrt((M ** 2).mean())),  # side/mid en dB
        "centroid": centroid,
        "active_s": active.sum() * 0.05,
    }


def verdict(s):
    if s["sm"] < -30:
        return "MONO (L=R)"
    if s["corr"] > 0.9:
        return "casi mono"
    if s["corr"] < 0.2:
        return "muy ancho / descorrelado"
    return "estéreo"


rows = []
for f in sorted(os.listdir(folder)):
    if not f.startswith(prefix + "_") or not f.endswith(".wav"):
        continue
    sr, x = load(os.path.join(folder, f))
    s = stats(x, sr)
    if s:
        rows.append((f[len(prefix) + 1:-4], s))

print(f"{'pista':<16} {'RMS act':>7} {'L-R dB':>7} {'corr':>6} {'S/M dB':>7} {'centro Hz':>9}  imagen")
for name, s in rows:
    print(f"{name:<16} {s['rms']:7.1f} {s['bal']:+7.2f} {s['corr']:6.2f} {s['sm']:7.1f} {s['centroid']:9.0f}  {verdict(s)}")

sr, mix = load(mix_path)
print("\nMEZCLA (master) por bandas:")
for name, lo, hi in [("sub <120", None, 120), ("grave 120-400", 120, 400), ("medio 400-3k", 400, 3000), ("agudo >3k", 3000, None)]:
    s = stats(band(mix, sr, lo, hi), sr)
    print(f"  {name:<14} corr {s['corr']:5.2f}  S/M {s['sm']:6.1f} dB  L-R {s['bal']:+5.2f} dB")
s = stats(mix, sr)
print(f"  {'total':<14} corr {s['corr']:5.2f}  S/M {s['sm']:6.1f} dB  L-R {s['bal']:+5.2f} dB")
# correlación por compás (detecta tramos estrechos o con problemas de fase)
bar = int(2.0 * sr)
print("\n  correlación por compás:", " ".join(f"{np.corrcoef(mix[i:i + bar, 0], mix[i:i + bar, 1])[0, 1]:.2f}"
                                           for i in range(0, len(mix) - bar, bar)))
