# Motor de generación musical (diseño)

Estado: **borrador para aprobar**. Fecha: 2026-11-02. No hay código todavía.

## Por qué

Hoy cada pieza trae su propio motor copiado y adaptado:

| Pieza | Dónde | Qué reinventa |
|---|---|---|
| La Forja del Alba | `A:\CERBATANA\...\La Forja del Alba\generator\` | mapa de tempo/compás, voicings, interpretación por instrumento (`expr.mjs`), respiraciones, balance por MIDI, lint, choques |
| Folk metal 1 y 2, K-pop | `.reaper-manager/fx/*-gen.mjs` | RNG, nombres de nota, deriva de banda, batería, keyswitches de Ample, un `swam()` más simple, rangos, solapes |
| Primer cue orquestal | scratchpad (perdido) | `expression.mjs`, antecesor de `expr.mjs` |

La interpretación validada de oído (B, R17) vive solo en La Forja y depende de sus nombres de pista
(`"HN SOLO"`, `"STR LEGATO"`...). Cada pieza nueva la copiaría otra vez, y una librería nueva (Spitfire BBC
SO, CSS...) obligaría a tocar código.

## Objetivo

1. Las piezas solo declaran **qué** suena: notas, dinámica, pistas → instrumento + librería + estilo.
2. El motor decide **cómo** se toca, leyendo datos.
3. Una librería nueva = un JSON + una calibración. Sin código.
4. Si falta un dato: valor genérico + aviso. Nunca un error.

## Tres capas de datos

Separamos lo que hoy está mezclado en `PROFILE` y `STAMINA` de `expr.mjs`:

| Capa | Qué dice | Ejemplo | Dónde |
|---|---|---|---|
| **Instrumento** (mundo real) | rango, familia, aguante de aire/arco, vibrato propio del instrumento | el clarinete casi no vibra; la flauta aguanta ~7 s | `knowledge/composition/data/instruments.json` (rangos, ya existe) + `src/music/profiles/_players.json` (aguante, vibrato, retardo) |
| **Librería** (cómo responde el sample o el modelo) | qué CC lleva la dinámica, qué significa la velocity, latencia del legato, keyswitches, tabla CC → dB | Albion ignora la velocity del ligado; SWAM no sube de nivel por encima de CC11 95 | `src/music/profiles/<librería>.json` |
| **Pieza** (decisiones artísticas) | notas, curvas dinámicas, rol de cada pista, balance por secciones, sensación de timing | `["VLN SOLO", 53, 60, -5]` | carpeta de la pieza |

Es la misma separación "intérprete / librería" de `library-translation-table.md`: el estilo aplica la parte
del intérprete (forma de frase, timing, respiraciones) y el perfil la traduce a los CC de esa librería.

## Estructura

```
src/music/
  index.js                 API pública: createPiece, render, writeBridge
  core/                    neutro: no sabe de estilos ni de librerías
    timeline.js            mapa de tempo/compás por pieza; bar:beat ↔ qn ↔ s; ms→qn al tempo local
    pitch.js               nombres de nota, mel(), parseChord, voice() con conducción de voces, escalas, dshift
    score.js               modelo de pista: notas, CC, curvas dinámicas, frases; line(), chord()
    curves.js              interp, ramp, thin, formas de frase, suavizado
    random.js              RNG con semilla: un flujo por pista (o el flujo único de La Forja)
    humanize.js            timing/velocity, deriva de banda compartida, swing (mismo cálculo que swing_midi)
    validate.js            rango, choques sostenidos, solapes de misma altura, polifonía en mono, aguante
    bridge.js              ítems por sección para replace_midi (con valor de arranque de cada CC) y build_beat
  writing/                 helpers de escritura sin librería: pad con notas comunes, bajo, harpArp, pizzBass,
                           roll y pedal de piano, armonía diatónica a 3ª, batería GM y patrones de guitarra
  profiles/
    _generic.json          valores por defecto por estilo y familia
    _players.json          capa intérprete por instrumento
    albion-one.json        longs, legato, shorts, tremolo (medidos en parte)
    swam.json              vientos, metales, cuerdas (medidos en parte)
    symphony-series.json   timbales (redoble por CC7), plato
    darwin-percussion.json
    arturia-piano.json
    toontrack.json         EZdrummer 3 (mapa GM), EZbass (una octava arriba)
    ample.json             Ample Guitar / Bass J (keyswitches que se quedan enganchados)
    sampler-oneshot.json   RS5k
    profiles.js            carga y mezcla: genérico → librería → patch → pieza; avisos
  styles/                  cómo se toca, por familia; leen el perfil, no nombres de pista
    sampled-legato.js      Albion legato y longs (CC1 capa + forma de nota, CC11 frase, CC21 vibrato, CC17)
    sampled-short.js       cortos: velocity por la curva, CC11 entre ataques
    modeled.js             SWAM viento y cuerda: CC11 continuo, CC1 vibrato, velocity = portamento
    piano.js               voz superior canta, suelo de velocity
    percussion.js          golpes, redobles (CC7 + reset), swells de plato, Darwin con manos y flams
    drums.js               batería de banda: un solo baterista, offsets por pieza, ghost notes
    breath.js              planificador de respiraciones y arcos, compartidas entre secciones, llegadas
    balance.js             dB por pista y tramo → MIDI según el perfil (CC11 → CC1, velocity, SWAM ~6 CC/dB)
  engine.js                render(piece): respiraciones → estilo por pista → balance → validación
src/commands/music.js      CLI: `music render <pieza>`, `music profiles`, `music check <pieza>`
scripts/
  calibrate-instrument.mjs genera notas de prueba, renderiza vía bridge, mide y escribe el perfil
  calibration/measure.py   el measure.py de calibracion-librerias, generalizado
  new-piece.mjs            plantilla de pieza nueva
  music-parity.mjs         La Forja con el motor contra su propia salida (copia en temp)
test/music-*.test.js
```

Encaje con el repo: los comandos CLI van en `src/commands/` como los demás dominios. El motor musical es
su propio paquete en `src/music/` porque no comparte casi nada con `src/core/` (que es mezcla y pistas).

## Perfil de librería (ejemplo abreviado)

```jsonc
// src/music/profiles/albion-one.json
{
  "library": "Albion ONE",
  "defaults": { "articulation": { "method": "patch" }, "release": { "cc": 17 } },
  "patches": {
    "strings-high-octave-legato": {
      "match": ["Albion ONE - Strings High (Octave) - Legato"],
      "style": "sampled-legato", "family": "strings",
      "dynamics":   { "cc": 1, "layerMap": [0.78, 6], "status": "R17" },
      "expression": { "cc": 11, "phraseLift": 8, "ceiling": 112, "status": "M" },
      "vibrato":    { "cc": 21 },
      "velocity":   { "slur": "ignored", "attack": "minor", "status": "M" },
      "legato":     { "mode": "overlap-mono", "overlapMs": 70 },
      "latency":    { "attackMs": 25, "slurMs": 50, "jitterMs": 8,
                      "onBeat": { "attackMs": 150, "slurMs": 150 }, "status": "M" },
      "range":      { "practical": [55, 86], "full": [55, 93] },
      "calibration": { "cc1Db": [[10,-38],[25,-26],[40,-18],[55,-12],[70,-9],[85,-4],[100,0]],
                       "cc11Db": [[10,-22],[25,-14],[40,-8],[70,-4],[85,-3],[115,0]],
                       "source": "calibracion-librerias 2026-11-02", "status": "M" }
    }
  }
}
```

- Cada bloque lleva `status`: **M** medido, **D** documentado, **A** supuesto, **R17** validado de oído.
  `music profiles` lista lo que sigue en A, para saber qué calibrar.
- Lo que falte se toma de `_generic.json` (por estilo y familia) con un aviso en el informe.
- Spitfire (BBC SO y similares) añade `"articulation": { "method": "uacc", "cc": 32, "map": {...} }` y sus
  CC. Todo en A hasta calibrar. Un perfil nuevo sale de `_template.json`.
- Keyswitches: `{ "mode": "latch" | "per-note", "map": { "roll": 38, ... }, "leadQn": 0.06 }`. Cubre Ample
  (se enganchan), los timbales de Symphony Series (antes de cada golpe) y UACC.

## Declaración de una pieza

```js
// <carpeta de la pieza>/piece.mjs
import { createPiece } from "file:///A:/PROYECTOS/OPENCODE/Reaper Manager/src/music/index.js";

const piece = createPiece({
  title: "La Forja del Alba", seed: 20261102,
  tempo: [{ bar: 1, bpm: 54, num: 4, den: 4 }, { bar: 25, bpm: 76, num: 3, den: 4 } /* ... */],
  sections: [{ bar: 1, name: "I GÉNESIS", vib: 40, rel: 100 } /* ... */],
  tracks: {
    "FL SOLO":    { instrument: "flute",   profile: "swam/flute-3",  role: "solo" },
    "STR LEGATO": { instrument: "violins", profile: "albion-one/strings-high-octave-legato",
                    breathGroup: "melody", overrides: { vibrato: { scale: 1.0 } } },
    "TIMP":       { instrument: "timpani", profile: "symphony-series/timpani" }
  },
  feel: { albion: "laid-back" },     // "on-beat" = las latencias medidas en contexto (EXPR_ALB_T=2)
  balance: [["VLN SOLO", 53, 60, -5] /* ... */]
});
// las secciones escriben notas y curvas dinámicas con piece.line(), piece.mel(), piece.dyn()...
piece.render().writeBridge("./out");   // out/cmd/*.json (replace_midi) + out/build.json + informe
```

`style` sale del perfil y una pista puede cambiarlo. `role` (solo, melodía, contracanto, colchón) alimenta
el balance por rol (`tutti-balance-by-role`) cuando la pieza no da dB explícitos.

## Qué se porta de La Forja (estado final, incluido lo que otra sesión está terminando ahora)

Fuente: `generator/` en su versión más nueva al empezar la implementación, comparada con el último backup
(`backups/generator-pre-v4-1709` es de las 17:09 y `expr.mjs` cambió a las 17:10). No toco esa carpeta.

| Comportamiento | Va a | Por defecto |
|---|---|---|
| Interpretación B (SWAM y Albion) | `modeled.js`, `sampled-legato.js` + perfiles | **sí** (A se puede pedir como `performance: "A"` solo para A/B) |
| Timing base de Albion (25/50 ms ±8) | perfil `latency` | **sí**; las latencias de la ronda 2 quedan como `feel: "on-beat"` |
| Respiraciones: aguante, suspiros, llegadas, compartidas entre secciones que doblan la melodía | `breath.js`; aguante en `_players.json` | sí |
| Vibrato por frase sin reinicio en ligados (Albion CC21 y SWAM CC1), sin caída a 0 en los ligados SWAM | estilos | sí |
| Capa de soplo SWAM (borrador de swam-performance) | `modeled.js` como opción `breathNoise` | **solo si** la sesión de La Forja la deja integrada y aprobada; si no, apagada |
| Redoble de timbal por CC7 40–127 + CC1 curvado + reset de CC7 antes del siguiente golpe | `percussion.js` + perfil Symphony Series | sí |
| Swell de plato que deja sonar el trémolo (`ring`) | `percussion.js` | sí |
| Arreglo del pizz en el bajo (la 2ª nota sale de fundamental o 5ª del acorde, no "bajo + 7") | `writing/` (`pizzBass`, hoy dentro de `s2_despertar.mjs`) | sí |
| Arpegio de piano tipo arpa desde Do3 = 48 (es un suelo de **altura**, no de velocity) | `writing/harpArp` | sí, `lo: 48` |
| Balance por dB → MIDI | `balance.js` | sí; la tabla `BAL` se queda en la pieza |
| Lint (respiración, trompa aguda, contrabajos rápidos, timbales por pasaje, registro/dinámica) y choques | `validate.js` con reglas por instrumento, no por pista | sí |

De folk metal y K-pop: deriva de banda (paseo aleatorio), offsets por pieza de batería (caja +8 ms,
charles atrás), batería GM de EZD3, guitarra con keyswitches de Ample, EZbass una octava arriba, armonías
diatónicas a 3ª, recorte de solapes de misma altura y el swing de 8ª compartido (beat-making-preferences).
No los migro: el motor ofrece las piezas para la próxima canción.

## Paridad con La Forja

1. Copio `generator/` a un directorio temporal del scratchpad.
2. Ejecuto el original con `FORJA_OUT=<scratch>/ref`: es la referencia.
3. En la copia sustituyo `core.mjs`, `orch.mjs`, `expr.mjs` y `bal.mjs` por adaptadores de pocas líneas que
   llaman al motor. Las secciones `s1`–`s5` no se tocan.
4. Comparo `cmd/*.json` y `build.json` nota a nota y CC a CC.

Para que la comparación pueda ser exacta, el motor tiene un modo `rng: "shared"` (un solo flujo LCG con la
semilla de La Forja, consumido en el mismo orden). Las piezas nuevas usan un flujo por pista: así, cambiar
una pista no re-humaniza las demás. Cada diferencia que quede se explica en el informe de paridad.

## Calibración de una librería nueva

```
node scripts/calibrate-instrument.mjs --profile spitfire-bbcso/violins-1-legato --tests legato,long,short
```

1. Comprueba el bridge (`status`).
2. Abre o crea el proyecto de calibración aparte (`A:/CERBATANA/Ableton/calibracion-librerias/`). Nunca usa la
   pestaña de trabajo del usuario.
3. Carga el patch (`load_patch`) en una pista `CAL`, escribe las notas de prueba (`replace_midi`) y
   renderiza la pista (`render_audio` con `stems`).
4. Mide con `scripts/calibration/measure.py`: latencia del legato, ataque a −6 dB, CC → dB, velocity → dB y
   portamento.
5. Escribe los bloques medidos en el perfil con `status: "M"`, fecha y fuente, y enseña el diff antes de
   guardarlo.

`--dry-run` solo genera el MIDI de prueba, sin REAPER. **Ejecutarla de verdad requiere tu permiso cada vez.**

## Pieza nueva

`node scripts/new-piece.mjs --dir "A:/CERBATANA/Ableton/2026-11-xx Nombre" --template orquesta|banda|beat`
crea `piece.mjs`, `parts/` y `README.md` con las pistas de la plantilla ya mapeadas a perfiles.

## Pruebas

- Unidad: timeline (cambios de tempo y 7/8), pitch y acordes, curvas, RNG determinista, mezcla de perfiles
  con avisos, cada estilo sobre frases pequeñas (por ejemplo: el vibrato SWAM no baja en un ligado, el
  redoble pone CC7 a 127 antes del golpe siguiente, el arpegio del piano no baja de Do3), balance,
  validadores y la salida para el bridge.
- `npm test` falla hoy en Node 24 (`node --test test` toma `test` como archivo). Lo cambio a
  `node --test test/` con patrón explícito.
- Paridad con La Forja: script aparte, porque esa carpeta está fuera del repo.

## Fases

1. Núcleo + perfiles + estilos con la paridad de La Forja en verde (o con las diferencias explicadas).
2. Calibración (`--dry-run` primero; con REAPER solo con tu OK) y `new-piece.mjs`.
3. Punteros en AGENTS.md, `user-taste.md` y `_performance.md`; índice de la bóveda sin errores.

Commits en la rama `claude/beautiful-cori-2cb102`, sin push ni PR hasta que lo digas.

## Preguntas abiertas

1. **Base de la rama.** La rama salía de `main`, que no tiene la bóveda ni `build_beat`. La he movido a
   `feature/vocal-level-precomp` (345587d), que es donde está todo eso.
2. **Notas de la bóveda sin commit.** `performance/` (incluida la tabla de traducción) y los cambios de
   `user-taste.md` y `AGENTS.md` solo existen en el checkout principal y otras sesiones los están editando.
   Para los punteros propongo editar esos archivos en el checkout principal sin commit, como hacen las demás
   sesiones, y commitear en la rama solo lo nuevo (`docs/`, `src/music/`, `scripts/`, `test/`).
3. **Interpretación A.** ¿La conservo como opción para A/B o la elimino? Propongo conservarla mientras La
   Forja la use.
