#!/usr/bin/env node
// Scaffold a new piece that uses the music engine (docs/music-engine.md). Writes into --dir:
//   piece.mjs    tempo, sections, tracks → profiles; runs the parts, performs, checks and writes out/
//   tracks.mjs   track declarations (profile per track) and the REAPER session template for build_beat
//   parts/       one module per section with a small runnable example to replace
//   README.md
// Usage: node scripts/new-piece.mjs --dir "A:/CERBATANA/Ableton/2026-11-xx Name" --template orquesta|banda|beat
//        [--title "Name"] [--bpm 90] [--force]
// Then: node "<dir>/piece.mjs" → <dir>/out/cmd/*.json (replace_midi) and <dir>/out/build.json.
import { existsSync, mkdirSync, writeFileSync, readdirSync } from "node:fs";
import { join, resolve, basename } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const ENGINE = pathToFileURL(resolve(fileURLToPath(new URL(".", import.meta.url)), "..", "src", "music", "index.js")).href;

// [name, profile, color, folder (1 opens, -1 closes, 0 none), volume dB, pan, send ("P" hall, "I" impact, "S" soloist hall)]
// folder parents are empty buses (folder tracks carry MIDI).
const TEMPLATES = {
  orquesta: {
    bpm: 72, sig: [4, 4], reverbs: true,
    breathGroups: { melody: ["STR LEGATO", "WW LEGATO", "HN LEGATO"] },
    tracks: [
      ["WOODS", null, "#6fb36f", 1, 0, 0, null],
      ["FL SOLO", "swam/flute-3", "#e0c060", 0, -3, -0.15, "S"],
      ["WW LEGATO", "albion-one/woods-high-legato", "#6fb36f", 0, -3, -0.1, "P"],
      ["WW SHORT", "albion-one/woods-high-short", "#6fb36f", -1, -4, -0.1, "I"],
      ["BRASS", null, "#d9a23a", 1, 0, 0, null],
      ["HN LEGATO", "albion-one/brass-mid-legato", "#d9a23a", 0, -1, -0.3, "P"],
      ["LOW BRASS", "albion-one/brass-low-long", "#d9a23a", -1, -3, 0.35, "P"],
      ["PERCUSSION", null, "#8a8a8a", 1, 0, 0, null],
      ["TIMP", "symphony-series/timpani", "#8a8a8a", 0, -1, -0.1, "I"],
      ["CYMBALS", "symphony-series/cymbal-1", "#8a8a8a", -1, -5, 0.1, "I"],
      ["PIANO", "arturia/piano-v3", "#7f8fd0", 0, -6, -0.2, "P"],
      ["STRINGS", null, "#c85a5a", 1, 0, 0, null],
      ["VC SOLO", "swam/cello-3", "#e0c060", 0, -3, 0.15, "S"],
      ["STR LEGATO", "albion-one/strings-high-octave-legato", "#c85a5a", 0, -1, -0.25, "P"],
      ["STR LONG", "albion-one/strings-long", "#c85a5a", 0, -3, -0.05, "P"],
      ["STR SPICC", "albion-one/strings-short-spiccato", "#c85a5a", 0, -3, -0.15, "I"],
      ["LO STR LONG", "albion-one/strings-low-8ves-long", "#9c3f3f", -1, 0, 0.25, "P"]
    ],
    part: `export function sectionA(p) {
  // replace with the real material; keep notes and dynamics here, the engine plays them
  const rows = p.harm(1, ["Dm", "Gm/D", "A7/C#", "Dm"]);
  p.line("FL SOLO", 1, 0, p.mel("D5:2 E5:1 F5:1 | A5:3 G5:1 | E5:2 C#5:2 | D5:4"));
  p.dyn("FL SOLO", [[1, 0, 50], [3, 0, 66], [4, 2, 40]]);
  p.pad("STR LONG", rows, 3, 52, 67, { center: 59 });
  p.bass("LO STR LONG", rows, 38, 52);
  p.dyn(["STR LONG", "LO STR LONG"], [[1, 0, 40], [3, 0, 55], [5, 0, 35]]);
  p.timpRoll(4, 0, 4, 38, [[4, 0, 20], [4, 3, 90]]);
  p.timpHit(5, 0, 38, 100);
}
`
  },
  banda: {
    bpm: 140, sig: [4, 4], reverbs: false,
    tracks: [
      ["DRUMS", "toontrack/ezdrummer-3", "#c0392b", 0, -2, 0, null],
      ["BASS", "toontrack/ezbass", "#8e44ad", 0, -3, 0, null],
      ["GTR L", "ample/guitar-l", "#d35400", 0, -8, -0.9, null],
      ["GTR R", "ample/guitar-l", "#d35400", 0, -8, 0.9, null],
      ["LEAD", "swam/violin-3", "#16a085", 0, -5, 0.2, null],
      ["PAD", "albion-one/strings-long", "#2c7a7b", 0, -7, 0, null]
    ],
    part: `export function sectionA(p) {
  // one drummer: the engine adds the shared band drift and the per-group placement (profile feel)
  const k = p.resolve("DRUMS").cfg.map;
  for (let bar = 1; bar <= 4; bar++) for (let b = 0; b < 4; b++) {
    const t = p.pos(bar, b);
    p.noteAt("DRUMS", t, 0.2, b % 2 ? k.snare : k.kick, { vel: b % 2 ? 112 : 116 });
    p.noteAt("DRUMS", t, 0.2, k.hat, { vel: 70 });
    p.noteAt("DRUMS", t + 0.5, 0.2, k.hat, { vel: 58 });
  }
  const rows = p.harm(1, ["Am", "F", "C", "G"]);
  p.bass("BASS", rows, 40, 52); // EZbass is written an octave up (low E = 40)
  p.pad("PAD", rows, 3, 55, 72);
  p.dyn(["BASS", "PAD"], [[1, 0, 80]]);
  p.line("LEAD", 1, 0, p.mel("A5:2 C6:1 B5:1 | A5:2 E5:2 | G5:3 F5:1 | E5:4"));
  p.dyn("LEAD", [[1, 0, 70], [3, 0, 85], [4, 3, 50]]);
}
`
  },
  beat: {
    bpm: 90, sig: [4, 4], reverbs: false,
    tracks: [
      ["KICK", "reaper/rs5k-oneshot", "#c0392b", 0, -3, 0, null],
      ["SNARE", "reaper/rs5k-oneshot", "#c0392b", 0, -4, 0, null],
      ["HATS", "reaper/rs5k-oneshot", "#c0392b", 0, -8, 0.15, null],
      ["BASS", "ample/bass-j", "#8e44ad", 0, -4, 0, null],
      ["KEYS", "arturia/piano-v3", "#7f8fd0", 0, -6, -0.1, null]
    ],
    part: `export function sectionA(p) {
  // one-shot drums, one track per piece; swing on the 8th grid shared by the kit (beat-making-preferences)
  const hit = p.resolve("KICK").cfg.map.hit;
  for (let bar = 1; bar <= 4; bar++) {
    for (const b of [0, 1.5, 2.5]) p.note("KICK", bar, b, 0.2, hit, { vel: 112 });
    for (const b of [1, 3]) p.note("SNARE", bar, b, 0.2, hit, { vel: 104 });
    for (let b = 0; b < 4; b += 0.5) p.note("HATS", bar, b, 0.1, hit, { vel: b % 1 ? 62 : 80 });
  }
  const rows = p.harm(1, ["Cmaj7", "Bm7", "Am9", "Em9"]);
  p.pad("KEYS", rows, 4, 52, 72, { cluster: true });
  p.bass("BASS", rows, 40, 52);
  p.dyn(["KEYS", "BASS"], [[1, 0, 64]]);
}
`
  }
};

const args = process.argv.slice(2);
const arg = (k, d) => { const i = args.indexOf(k); return i >= 0 ? args[i + 1] : d; };
const dir = arg("--dir"), kind = arg("--template", "orquesta");
const T = TEMPLATES[kind];
if (!dir || !T) { console.error(`usage: --dir <folder> --template ${Object.keys(TEMPLATES).join("|")} [--title X] [--bpm N] [--force]`); process.exit(2); }
const out = resolve(dir);
if (existsSync(join(out, "piece.mjs")) && !args.includes("--force")) { console.error(`${out} already has a piece.mjs (use --force to overwrite)`); process.exit(1); }
const title = arg("--title", basename(out).replace(/^\d{4}-\d{2}-\d{2}\s*/, "") || "Pieza nueva");
const bpm = Number(arg("--bpm", T.bpm));
const swingFeel = kind === "beat" ? `\n  options: { feel: { KICK: { swing: { amount: 55, grid: 0.5 } }, SNARE: { swing: { amount: 55, grid: 0.5 } }, HATS: { swing: { amount: 55, grid: 0.5 } } }, band: { maxMs: 2 } },` : "";

mkdirSync(join(out, "parts"), { recursive: true });
const decl = T.tracks.filter(([, profile]) => profile).map(([n, profile]) => `  ${JSON.stringify(n)}: { profile: ${JSON.stringify(profile)} }`).join(",\n");
const sendOf = (s) => (s ? `[{ dest: ${s === "I" ? '"REV IMPACT"' : '"REV PANORAMIC"'}, db: ${s === "S" ? -5 : s === "P" ? -10 : -14} }]` : "[]");
const build = T.tracks.map(([n, profile, color, folder, vol, pan, send]) => {
  const fx = profile ? `, fx: [fxOf(${JSON.stringify(profile)})]` : "";
  return `  { name: ${JSON.stringify(n)}, color: "${color}"${folder ? `, folder: ${folder}` : ""}, volume_db: ${vol}, pan: ${pan}, sends: ${sendOf(send)}${fx} }`;
}).join(",\n");
const reverbs = T.reverbs ? `,
  { name: "REV PANORAMIC", color: "#5a5a8a", volume_db: -4, fx: [{ candidates: ["VST3:RVerb Stereo (Waves)", "ReaVerbate"] }] },
  { name: "REV IMPACT", color: "#5a5a8a", volume_db: -6, fx: [{ candidates: ["VST3:RVerb Stereo (Waves)", "ReaVerbate"] }] }` : "";

writeFileSync(join(out, "tracks.mjs"), `// Tracks of "${title}": each one declares a profile (library + patch); the engine reads how to play it
// from src/music/profiles. Change a library = change the profile here (and calibrate it if it is new).
import { findPatch, loadProfiles } from "${ENGINE}";

export const TRACKS = {
${decl}
};
${T.breathGroups ? `// sections that breathe together (a doubled melody), in order: the first chooses, the others copy
export const BREATH_GROUPS = ${JSON.stringify(T.breathGroups)};
` : "export const BREATH_GROUPS = {};\n"}
// the plugin or captured patch for a profile: its first "match" name (a patch name loads with load_patch)
const registry = loadProfiles();
function fxOf(profile) {
  const name = findPatch(registry, { profile })?.patch.match?.[0];
  if (!name) return { name: "ReaSynth" };
  if (name === "sampler") return { sampler: { file: "" } }; // set the sample file
  return name.startsWith("VST") || name.startsWith("JS") ? { name } : { patch: name };
}

// REAPER session for build_beat (folder parents are empty buses)
export const BUILD_TRACKS = [
${build}${reverbs}
];
`);

writeFileSync(join(out, "parts", "a.mjs"), `// Section A of "${title}". Write notes, lines and dynamic curves with the piece's helpers
// (p.line, p.mel, p.note, p.chord, p.harm, p.pad, p.bass, p.harpArp, p.dyn, p.timpRoll, ...).
${T.part}`);

writeFileSync(join(out, "piece.mjs"), `// "${title}" (${kind}), generated by scripts/new-piece.mjs on ${new Date().toISOString().slice(0, 10)}.
// Run: node piece.mjs → out/cmd/*.json (one replace_midi per track) and out/build.json (session).
// Arrange only: render, measure and mix when the user asks (no-early-render-mix).
import { fileURLToPath } from "node:url";
import { createPiece } from "${ENGINE}";
import { TRACKS, BREATH_GROUPS, BUILD_TRACKS } from "./tracks.mjs";
import { sectionA } from "./parts/a.mjs";

const LAST = 4;
export const piece = createPiece({
  title: ${JSON.stringify(title)}, seed: ${Math.floor(Math.random() * 1e8)},
  tempo: [{ bar: 1, bpm: ${bpm}, num: ${T.sig[0]}, den: ${T.sig[1]} }],
  lastBar: LAST,
  sections: [{ bar: 1, name: "A", vib: 50, rel: 90 }],
  tracks: TRACKS, breathGroups: BREATH_GROUPS,
  // contextual balance in MIDI, never faders: [track, fromBar, toBar, dB]
  balance: [],${swingFeel}
});

sectionA(piece);
if (piece.rolls?.length) piece.timpVolumeReset();
piece.perform();
const report = piece.check();
const midi = piece.writeBridge(fileURLToPath(new URL("./out/", import.meta.url)), {
  build: { tracks: BUILD_TRACKS, markers: piece.sections.map((s) => ({ bar: s.bar, name: s.name })) }
});
for (const [t, its] of Object.entries(midi)) console.log(\`\${t.padEnd(14)} notes \${its.reduce((s, i) => s + i.notes.length, 0)}  items \${its.length}\`);
console.log(\`warnings: \${report.warnings.length}\`); report.warnings.slice(0, 20).forEach((w) => console.log("  ·", w));
console.log(\`idiom: \${report.lint.length}\`); report.lint.slice(0, 20).forEach((w) => console.log("  ·", w));
console.log(\`errors: \${report.errors.length}\`); report.errors.forEach((e) => console.log("  ✗", e));
if (report.errors.length) process.exitCode = 1;
`);

writeFileSync(join(out, "README.md"), `# ${title}

Pieza creada con \`scripts/new-piece.mjs\` (plantilla **${kind}**) sobre el motor de Reaper Manager
(\`docs/music-engine.md\`).

- \`piece.mjs\`: tempo, secciones, balance y opciones de interpretación. \`node piece.mjs\` escribe \`out/\`.
- \`tracks.mjs\`: cada pista declara su perfil (librería + patch). Cambiar de librería = cambiar el perfil.
- \`parts/\`: notas y curvas dinámicas por sección. El motor decide cómo se tocan.

Cargar en REAPER (pestaña nueva, con el bridge activo):

\`\`\`powershell
node .\\bin\\reaper-manager.js send "${out.replaceAll("\\", "/")}/out/build.json"
\`\`\`

Después, para iterar, reenviar solo las pistas cambiadas: \`out/cmd/<PISTA>.json\` (replace_midi).
`);

console.log(`created ${kind} piece in ${out}: ${readdirSync(out).join(", ")}`);
