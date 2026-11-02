// Tempo and meter map of a piece. Positions are quarter notes (qn) from the start of bar 1; bars are
// 1-based, beats are quarter notes from the start of the bar (a 7/8 bar is 3.5 qn long).

// changes: [{ bar, bpm, num?, den? }] sorted by bar; the first one should be bar 1 with num/den.
export function createTimeline(changes, totalBars) {
  let num = 4, den = 4, bpm = 120, qn = 0, sec = 0;
  const measures = [];
  for (let b = 1; b <= totalBars + 8; b++) {
    const ch = changes.find((c) => c.bar === b);
    if (ch) {
      if (ch.bpm) bpm = ch.bpm;
      if (ch.num) { num = ch.num; den = ch.den; }
    }
    const len = (num * 4) / den;
    measures[b] = { bar: b, qn, len, num, den, bpm, sec };
    qn += len;
    sec += (len * 60) / bpm;
  }
  const measure = (bar) => {
    const m = measures[bar];
    if (!m) throw new Error(`bar ${bar} is outside the tempo map (1–${measures.length - 1})`);
    return m;
  };
  const pos = (bar, beat = 0) => measure(bar).qn + beat;
  const barLen = (bar) => measure(bar).len;
  const measureAt = (p) => {
    let lo = 1, hi = measures.length - 1;
    while (lo < hi) {
      const mid = (lo + hi + 1) >> 1;
      if (measures[mid].qn <= p + 1e-9) lo = mid; else hi = mid - 1;
    }
    return measures[lo];
  };
  const bpmAt = (p) => measureAt(p).bpm;
  const secOf = (p) => { const m = measureAt(p); return m.sec + ((p - m.qn) * 60) / m.bpm; };
  // seconds → qn at the local tempo of position p
  const ms2qn = (ms, p) => (ms / 1000) * (bpmAt(p) / 60);
  // duration in seconds of lenQn starting at p, at the local tempo (La Forja's secs())
  const secs = (lenQn, p) => (lenQn * 60) / bpmAt(p);
  const barOf = (p) => measureAt(p).bar;
  const fmtPos = (p) => { const m = measureAt(p); return `c.${m.bar}:${(p - m.qn).toFixed(2)}`; };
  return { changes, totalBars, measures, pos, barLen, measureAt, bpmAt, secOf, ms2qn, secs, barOf, fmtPos };
}
