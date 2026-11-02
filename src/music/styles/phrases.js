// Shared helpers for the performance styles: events (simultaneous attacks grouped) and phrases.
import { sortNotes } from "./breath.js";

// events = simultaneous attacks grouped (chords) or single notes; joined = the next one follows within 0.12 qn
export function events(notes) {
  const ev = [];
  for (const n of sortNotes(notes)) {
    const last = ev[ev.length - 1];
    if (last && Math.abs(last.pos - n.pos) < 0.04) { last.len = Math.max(last.len, n.len); last.notes.push(n); }
    else ev.push({ pos: n.pos, len: n.len, notes: [n], start: n.start !== false });
  }
  ev.forEach((e, i) => {
    const next = ev[i + 1];
    e.joined = !!next && next.pos - (e.pos + e.len) < 0.12;
    e.phraseEnd = !e.joined;
  });
  return ev;
}

export function phrasesOf(evs) {
  const out = [];
  let cur = [];
  for (const e of evs) { cur.push(e); if (e.phraseEnd) { out.push(cur); cur = []; } }
  if (cur.length) out.push(cur);
  return out;
}

// never slur into the same pitch (the note-off would kill the re-attack)
export function unslurRepeats(ns) {
  ns.forEach((n, i) => { const nx = ns[i + 1]; if (n.slur && (!nx || nx.pitch === n.pitch)) n.slur = false; });
}
