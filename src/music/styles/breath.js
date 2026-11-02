// Breath (winds, brass) and bow (strings) planner. When a slurred line runs longer than the player's stamina,
// cut it at the best note of the last stretch: the longest note, preferably ending on a barline, where other
// sections can breathe too; never inside a fast run, between the two notes of a sigh, or just before an arrival.
// stamina: { sec (at mf; longer at p, shorter at f), gapMs (breath silence; 0 = bow change, no gap) }.
import { clamp } from "../core/util.js";

// sigh: a note resolving down by step into an equal or shorter note
const sigh = (c, nx) => !!nx && nx.pitch < c.pitch && c.pitch - nx.pitch <= 2 && nx.len <= c.len;

export function createBreathPlanner({ timeline, arrivals = [], mode = "shared", log = [] }) {
  const { secOf, measureAt, ms2qn } = timeline;
  const v4 = mode === "shared";
  const atArrival = (p) => v4 && arrivals.some((a) => Math.abs(a - p) < 0.15);
  const planned = new Set();
  let sharedAt = () => 0;

  function breathAt(name, stamina, line, k) {
    const c = line[k];
    if (stamina.gapMs) c.len -= Math.min(ms2qn(stamina.gapMs, c.pos + c.len), c.len * 0.5);
    c.slur = false; c.breath = true;
    if (line[k + 1]) line[k + 1].afterBreath = true;
    log.push(`${name} ${stamina.gapMs ? "resp" : "arco"} c.${measureAt(c.pos).bar}`);
  }

  // ns: the track's notes sorted; D: its dynamic curve. onCut(pos) receives every cut.
  function plan(name, stamina, ns, D, onCut = () => {}) {
    if (!stamina || planned.has(name)) return;
    const line = ns.filter((n) => n.line);
    const end = (n) => secOf(n.pos + n.len);
    let i = 0;
    while (i < line.length) {
      const t0 = secOf(line[i].pos);
      let j = i;
      for (; j < line.length; j++) {
        const n = line[j], nx = line[j + 1];
        const d = D(n.pos);
        const lim = stamina.gapMs ? stamina.sec * (d < 45 ? 1.25 : d > 90 ? 0.75 : 1) : clamp(11.5 - d * 0.07, 3.5, 10) * (stamina.sec / 5);
        const phraseBreak = !nx || secOf(nx.pos) - end(n) > 0.08;
        if (end(n) - t0 > lim && j > i) {
          let best = null, score = -Infinity;
          for (let k = i; k < j; k++) {
            const c = line[k], cn = line[k + 1];
            if (end(c) - t0 < lim * 0.4) continue;
            const dur = secOf(c.pos + c.len) - secOf(c.pos);
            const m = measureAt(c.pos + c.len - 0.01), onBar = Math.abs(c.pos + c.len - (m.qn + m.len)) < 0.02;
            let s = dur * 2 + (onBar ? 1.2 : 0) + (k - i) * 0.01 + 1.5 * sharedAt(name, c.pos + c.len);
            if (v4 && cn && atArrival(cn.pos)) s -= 6;
            if (v4 && sigh(c, cn)) s -= 4;
            if (s > score) { score = s; best = k; }
          }
          if (best === null) best = j - 1;
          // other sections match the cut on the note's written end, before the breath shortens it
          const nominalEnd = line[best].pos + line[best].len;
          breathAt(name, stamina, line, best);
          onCut(nominalEnd);
          i = best + 1;
          break;
        }
        if (phraseBreak) { i = j + 1; break; }
      }
      if (j >= line.length) break;
    }
  }

  // Sections that breathe together (a doubled melody and its countermelodies), in order: each first copies the
  // cuts already chosen by the previous ones where it has a slurred boundary, then adds what its own stamina
  // still needs. Finally, the ones that double the same line (same attacks), or two winds, copy later cuts too.
  // group: [{ name, notes, dyn: D, stamina, wind }]
  function planShared(group) {
    if (!v4) return;
    const G = group.filter((g) => g.stamina).map((g) => {
      const ns = sortNotes(g.notes);
      ns.forEach((n, i) => { const nx = ns[i + 1]; if (n.slur && (!nx || nx.pitch === n.pitch)) n.slur = false; });
      return { ...g, ns, line: ns.filter((n) => n.line) };
    });
    const bounds = new Map(G.map((g) => [g.name, g.line.filter((n, k) => n.slur && g.line[k + 1]).map((n) => n.pos + n.len)]));
    sharedAt = (name, p) => G.filter((g) => g.name !== name && bounds.has(name) && bounds.get(g.name).some((b) => Math.abs(b - p) < 0.05)).length;
    const at = (g, p) => g.line.findIndex((n, k) => n.slur && g.line[k + 1] && Math.abs(n.pos + n.len - p) < 0.05);
    const onsets = (g, a, b) => g.line.filter((n) => n.pos >= a && n.pos < b).map((n) => n.pos);
    const doubles = (g, h, p) => {
      const x = onsets(g, p - 3, p + 3), y = onsets(h, p - 3, p + 3);
      return x.length >= 3 && y.length >= 3 && x.filter((q) => y.some((r) => Math.abs(q - r) < 0.05)).length >= 0.8 * Math.max(x.length, y.length);
    };
    const cuts = [];
    for (const g of G) {
      for (const c of cuts) { const k = at(g, c.p); if (k >= 0) breathAt(g.name, g.stamina, g.line, k); }
      plan(g.name, g.stamina, g.ns, g.dyn, (p) => cuts.push({ p, by: g.name }));
      planned.add(g.name);
    }
    for (const g of G) for (const c of cuts) {
      const h = G.find((x) => x.name === c.by), k = at(g, c.p);
      if (g !== h && k >= 0 && (doubles(g, h, c.p) || (g.wind && h.wind))) breathAt(g.name, g.stamina, g.line, k);
    }
    sharedAt = () => 0;
  }

  return { plan, planShared, log, isPlanned: (name) => planned.has(name) };
}

export const sortNotes = (ns) => [...ns].sort((a, b) => a.pos - b.pos || a.pitch - b.pitch);
