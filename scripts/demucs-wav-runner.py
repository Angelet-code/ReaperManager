#!/usr/bin/env python
import argparse
import math
import struct
import sys
from pathlib import Path

import numpy as np
import torch

from demucs.apply import apply_model
from demucs.audio import convert_audio
from demucs.pretrained import get_model


def main():
    parser = argparse.ArgumentParser(description="Separate a PCM/float WAV with Demucs without FFmpeg.")
    parser.add_argument("source", type=Path)
    parser.add_argument("--model", default="htdemucs_6s")
    parser.add_argument("--out", required=True, type=Path)
    parser.add_argument("--device", default=None)
    parser.add_argument("--shifts", type=int, default=1)
    parser.add_argument("--overlap", type=float, default=0.25)
    parser.add_argument("--segment", type=float, default=None)
    parser.add_argument("--jobs", type=int, default=0)
    args = parser.parse_args()

    model = get_model(args.model)
    model.cpu()
    model.eval()

    device = args.device or ("cuda" if torch.cuda.is_available() else "cpu")
    out_dir = args.out / args.model / args.source.stem
    out_dir.mkdir(parents=True, exist_ok=True)
    print(f"Separated tracks will be stored in {out_dir.resolve()}")
    print(f"Separating track {args.source}")

    wav, sample_rate = load_wav(args.source)
    wav = convert_audio(wav, sample_rate, model.samplerate, model.audio_channels)

    ref = wav.mean(0)
    ref_std = ref.std()
    if not torch.isfinite(ref_std) or ref_std <= 0:
        raise RuntimeError("Reference WAV is silent or unreadable.")

    wav -= ref.mean()
    wav /= ref_std
    sources = apply_model(
        model,
        wav[None],
        device=device,
        shifts=args.shifts,
        split=True,
        overlap=args.overlap,
        progress=True,
        num_workers=args.jobs,
        segment=args.segment,
    )[0]
    sources *= ref_std
    sources += ref.mean()

    for source, name in zip(sources, model.sources):
        write_wav(out_dir / f"{name}.wav", source, model.samplerate)


def load_wav(path):
    data = path.read_bytes()
    if data[:4] != b"RIFF" or data[8:12] != b"WAVE":
        raise RuntimeError(f"Only RIFF/WAVE files are supported: {path}")

    fmt = None
    pcm = None
    offset = 12
    while offset + 8 <= len(data):
        chunk_id = data[offset : offset + 4]
        size = struct.unpack_from("<I", data, offset + 4)[0]
        start = offset + 8
        chunk = data[start : start + size]
        if chunk_id == b"fmt ":
            fmt = chunk
        elif chunk_id == b"data":
            pcm = chunk
        offset = start + size + (size % 2)

    if fmt is None or pcm is None:
        raise RuntimeError(f"Invalid WAV structure: {path}")

    audio_format, channels, sample_rate, _byte_rate, block_align, bits = struct.unpack_from("<HHIIHH", fmt, 0)
    if audio_format == 0xFFFE and len(fmt) >= 40:
        audio_format = struct.unpack_from("<H", fmt, 24)[0]

    frame_count = len(pcm) // block_align
    bytes_per_sample = bits // 8
    expected = frame_count * channels * bytes_per_sample
    pcm = pcm[:expected]

    if audio_format == 3 and bits == 32:
        samples = np.frombuffer(pcm, dtype="<f4").reshape(frame_count, channels)
    elif audio_format == 1 and bits == 16:
        samples = np.frombuffer(pcm, dtype="<i2").astype(np.float32).reshape(frame_count, channels) / 32768.0
    elif audio_format == 1 and bits == 24:
        raw = np.frombuffer(pcm, dtype=np.uint8).reshape(frame_count * channels, 3).astype(np.int32)
        values = raw[:, 0] | (raw[:, 1] << 8) | (raw[:, 2] << 16)
        values = np.where(values & 0x800000, values | ~0xFFFFFF, values)
        samples = values.astype(np.float32).reshape(frame_count, channels) / 8388608.0
    elif audio_format == 1 and bits == 32:
        samples = np.frombuffer(pcm, dtype="<i4").astype(np.float32).reshape(frame_count, channels) / 2147483648.0
    else:
        raise RuntimeError(f"Unsupported WAV encoding: format={audio_format}, bits={bits}")

    wav = torch.from_numpy(np.ascontiguousarray(samples.T)).float()
    if not torch.isfinite(wav).all():
        raise RuntimeError(f"Invalid sample data in WAV: {path}")
    return wav, sample_rate


def write_wav(path, wav, sample_rate):
    import wave

    tensor = wav.detach().cpu().float()
    if tensor.dim() != 2:
        raise RuntimeError(f"Expected source tensor [channels, samples], got {tuple(tensor.shape)}")

    samples = tensor.clamp(-1, 1).numpy().T
    samples = np.round(samples * 32767.0).astype("<i2", copy=False)

    with wave.open(str(path), "wb") as handle:
        handle.setnchannels(samples.shape[1])
        handle.setsampwidth(2)
        handle.setframerate(int(sample_rate))
        handle.writeframes(samples.tobytes())


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        raise
    except Exception as exc:
        print(f"demucs-wav-runner failed: {exc}", file=sys.stderr)
        sys.exit(1)
