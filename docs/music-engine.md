# Motor de generación musical

Estado: **construido** (diseño aprobado por el usuario el 2026-11-02). Integrado en `main`.

## Por qué

Hasta ahora cada pieza traía su propio motor copiado y adaptado:

| Pieza | Dónde | Qué reinventaba |
|---|---|---|
| La Forja del Alba | `A:\CERBATANA\...\La Forja del Alba\generator\` | mapa de tempo/compás, voicings, interpretación por instrumento (`expr.mjs`), respiraciones, balance por MIDI, lint, choques |
| Folk metal 1 y 2, K-pop | `.reaper-manager/fx/*-gen.mjs` | RNG, nombres de nota, deriva de banda, batería, keyswitches de Ample, un `swam()` más simple, rangos, solapes |

La interpretación validada de oído (B, R17) vivía solo en La Forja y dependía de sus nombres de pista. Ahora
vive en el motor y se lee de datos.

## Principios

1. Las piezas declaran **qué** suena: notas, dinámica y pistas → perfil de librería.
2. El motor decide **cómo** se toca, leyendo el perfil.
3. Una librería nueva = un JSON + una calibración. Sin código.
4. Si falta un dato: valor genérico + aviso. Nunca un error.
5. Aleatoriedad determinista **por pista y por capa** (humanización, soplo...). Cambiar una capa o una pista no
   mueve la humanización del resto. El flujo único de La Forja (`rng: "shared"`) solo existe para la paridad.

## Tres capas de datos

| Capa | Qué dice | Dónde |
|---|---|---|
| **Instrumento** (mundo real) | familia, aguante de aire o arco (solo / sección) | `src/music/profiles/_players.json` (ids de `knowledge/composition/data/instruments.json`) |
| **Librería** | qué CC lleva dinámica, expresión y vibrato, qué hace la velocity, latencias, legato, keyswitches, rango del patch, tabla CC → dB | `src/music/profiles/<librería>.json` |
| **Pieza** | notas, curvas dinámicas, secciones, grupos que respiran juntos, balance en dB, opciones | carpeta de la pieza |

Es la separación "intérprete / librería" de `library-translation-table.md`. Cada bloque de un perfil lleva
`status`: **M** medido, **D** documentado, **A** supuesto, **R17** validado de oído.

Orden de mezcla (gana el último): `_generic.json` (por estilo) → familia → intérprete → `defaults` de la librería
→ patch → `overrides` de la pista. Si un campo que el estilo necesita sale de `_generic.json`, aparece un aviso.

## Estructura

```
src/music/
  index.js                API pública
  engine.js               createPiece(): escritura, perform(), check(), toBridge(), writeBridge()
  core/                   neutro: no sabe de estilos ni de librerías
    timeline.js           tempo/compás; bar:beat ↔ qn ↔ s; ms → qn al tempo local
    pitch.js              notas, mel(), acordes, voice() con conducción de voces, escalas
    score.js              pistas: notas, CC, curvas dinámicas, line(), harm()
    curves.js             interp, linear, thin, rampas
    random.js             flujos por (pista, capa); modo "shared" para la paridad
    humanize.js           deriva de banda, swing (mismo cálculo que swing_midi), humanización
    validate.js           rango, monofonía, solapes de misma altura, choques sostenidos, lint por instrumento
    bridge.js             ítems por sección (replace_midi) y build_beat
  writing/                pad, bass, harpArp (suelo Do3), roll, pedal, pizzBass; timbal, plato, percusión por zonas
  styles/                 sampled (legato/longs), simple (cortos, piano, percusión, batería), modeled (SWAM),
                          breath (respiraciones), breath-layer (soplo SWAM), balance
  profiles/               JSON de librerías + profiles.js (carga y mezcla) + calibration.js
src/commands/music.js     `music profiles [--assumed]`, `music resolve --profile <lib/patch>`
scripts/new-piece.mjs     pieza nueva (orquesta | banda | beat)
scripts/calibrate-instrument.mjs + scripts/calibration/measure.py
scripts/music-parity.mjs  La Forja con el motor contra su propio generador
```

Perfiles incluidos: Albion ONE (longs, legato, cortos, Darwin), SWAM (vientos, trompa, cuerdas), Symphony
Series (timbales con redoble por CC7, plato), Arturia (Piano V3, Mini V3, Mellotron V), Toontrack (EZdrummer 3,
EZbass), Ample (Guitar L, Bass J), REAPER (RS5k, ReaSynth) y `template-spitfire.json` para BBC SO y similares.

## Una pieza

```js
import { createPiece } from "file:///A:/PROYECTOS/OPENCODE/Reaper Manager/src/music/index.js";
const p = createPiece({
  title: "X", seed: 123, tempo: [{ bar: 1, bpm: 72, num: 4, den: 4 }], lastBar: 32,
  sections: [{ bar: 1, name: "A", vib: 50, rel: 90 }],
  tracks: { "FL SOLO": { profile: "swam/flute-3" }, "STR LEGATO": { profile: "albion-one/strings-high-octave-legato" } },
  breathGroups: { melody: ["STR LEGATO", "WW LEGATO"] },
  balance: [["FL SOLO", 9, 16, -3]],
  options: { breaths: "shared", vibrato: "phrase", swamBreath: false, feel: { sampled: "laid-back" } }
});
p.line("FL SOLO", 1, 0, p.mel("D5:2 E5:1 F5:1 | A5:4"));
p.dyn("FL SOLO", [[1, 0, 50], [3, 0, 66]]);
p.perform();
const report = p.check();          // errores, avisos, lint de idiomática, choques, respiraciones
p.writeBridge("./out", { build: { tracks: [...] } });
```

`node scripts/new-piece.mjs --dir "<carpeta>" --template orquesta|banda|beat` crea todo esto listo para correr.

## Opciones de interpretación

| Opción | Valores | Por defecto |
|---|---|---|
| `breaths` | `"shared"` (v4/v6: las secciones respiran juntas, respetan llegadas y suspiros) · `"independent"` (v3) | `"shared"` |
| `vibrato` | `"phrase"` (v4: no se reinicia dentro de la frase) · `"note"` (v3) | `"phrase"` |
| `swamBreath` | `false` · `true` · `{ end: "B"\|"reo", shape, noise, ride, amount }` | `false` |
| `feel.sampled` / `feel["<pista>"]` | `"laid-back"` (latencias base 25/50 ms) · `"on-beat"` (latencias medidas en contexto, ronda 2) | `"laid-back"` |

Los valores por defecto son los del generador actual de La Forja. El usuario aún no ha elegido de oído v4 ni la
capa de soplo: cuando elija, se cambia aquí (`DEFAULT_OPTIONS` en `engine.js`) en una línea.

La interpretación A **no** se ha portado (decisión del usuario): La Forja conserva `EXPR_A=1` en su propio
generador.

## Paridad con La Forja

`scripts/music-parity.mjs` copia el generador al scratchpad dos veces. Una copia corre tal cual; en la otra,
`core.mjs`, `orch.mjs` y `expr.mjs` se sustituyen por adaptadores al motor (`scripts/music-parity/`), y
las secciones `s1`–`s5`, `bal.mjs` y `main.mjs` no se tocan. Nunca escribe en la carpeta de La Forja.

Resultado (generador v6, 17:44 del 2026-11-02): **27 de 27 pistas idénticas byte a byte**, igual que
`build.json`. Se cumple en todas estas variantes: por defecto, `SOPLO=1`, `SOPLO_END=reo`, `EXPR_ALB_T=2` y
con las revisiones `REV_*=0`. La salida del motor coincide con `out-v6/` y `out-v6-soplo/`. Diferencias
explicadas: ninguna.

```
node scripts/music-parity.mjs --forja "<La Forja>/generator" --work <scratch> [--soplo] [--env K=V]
```

## Calibración de una librería nueva

```
node scripts/calibrate-instrument.mjs --profile <lib/patch> --dry-run          # MIDI de prueba, sin REAPER
node scripts/calibrate-instrument.mjs --profile <lib/patch> --result <x.json>  # importar una medida existente
node scripts/calibrate-instrument.mjs --profile <lib/patch> --yes [--write]    # en vivo: SOLO con permiso
```

En vivo:
1. Comprueba el bridge.
2. Abre el proyecto aparte `calibracion-librerias.rpp`. Nunca usa la pestaña de trabajo.
3. Carga el patch en una pista `CAL` y escribe las notas de prueba según el estilo del patch:
   - legato: transición por velocity;
   - longs: ataque, CC1 → dB y CC11 → dB;
   - cortos: velocity → dB;
   - SWAM: CC11 → dB y portamento.
4. Renderiza la pista y la mide con `measure.py`.
5. Enseña el diff del perfil; solo lo guarda con `--write`.

Para una librería nueva: copia `template-spitfire.json`, rellena `match` y calibra cada patch.

## Pruebas

`npm test` (ahora con patrón explícito, porque en Node 24 `node --test test` fallaba): 156 pruebas. 23 son
del motor:
- núcleo, perfiles y estilos;
- vibrato sin caída en ligados y redoble con reset de CC7;
- flujos independientes, respiraciones compartidas, balance y batería;
- `new-piece` (3 plantillas) y calibración.
