# MIDI orquestal de referencia: fuentes y plan de análisis

Fecha: 2026-11-02. Investigación solo web: **no se ha descargado ningún MIDI ni proyecto**. Los tamaños se
han obtenido con peticiones `HEAD`, que no bajan el archivo. Una excepción menor: al leer el manual de SWAM
Solo Woodwinds v3.8.0, la herramienta de lectura web guardó el PDF en su caché temporal. Se usó solo para
extraer texto.

## Objetivo y criterio

Queremos MIDI **de interpretación**: curvas CC1/CC11/CC21 dibujadas para una librería concreta, ataques
adelantados, solapes de legato, velocidades con intención y timing humano. Así sabremos con qué valores
reales sustituir las constantes inventadas del generador.

- **PERF**: MIDI de interpretación. Es lo que interesa.
- **SCORE**: MIDI cuantizado exportado de notación (Sibelius, Dorico, archivos clásicos). Sirve como mucho
  para notas y orquestación, no para la expresión.

Etiquetas de confianza: **V** = visto en la página oficial o en el hilo. **I** = inferido de foros o
buscadores; hay que comprobarlo. En casi ninguna fuente hay licencia escrita sobre el MIDI (ver
[Licencias](#licencias-regla-práctica)).

## Fuentes priorizadas

### Prioridad A: gratis, oficiales, PERF y relevantes para nuestro setup

| # | Fuente | Qué contiene | Formato | ¿CC? | Librería | Precio / cuenta | Enlace | Conf. |
|---|---|---|---|---|---|---|---|---|
| A1 | **Sample Modeling: Challenge 2022 "REVEAL"** | Cuarteto de cuerda: un MIDI por parte (Vn I, Vn II, Va, Vc) más la grabación **real**, la versión MIDI y ambas juntas. También un PDF y un vídeo, "The 7 switches". | .mid + WAV + PDF | Sí. Los instrumentos modelados no suenan sin CC continuo. | SM Solo Strings (modelado, primo de SWAM) | Gratis, sin cuenta (Google Drive) | https://drive.google.com/drive/folders/1bUTQgt_i8Z5cCfWRIL2EP-TEnmO22Br5 | V (listado); CC: I |
| A2 | **Sample Modeling: MIDI de demos** | MIDI de The Trumpet v3, The Trombone v3 (más el proyecto Cubase del tráiler) y Solo/Chamber/Ensemble Strings. Horn y Tuba v3: "coming soon". | .mid, .cpr | Sí (I) | SM Trumpet, Trombone y Strings | Gratis, sin cuenta (Google Drive) | https://www.samplemodeling.com/downloads/ (Trumpet: https://drive.google.com/file/d/1algF8x000ALLR1WuZgoauja4B8iC7-FW/view · Trombone: https://drive.google.com/file/d/1MdTjBxNLV7bQk4FlMBexUc62ARQRQvCj/view · Strings: https://drive.google.com/file/d/1DRA4-iT7TxriJh8M1s1m60XiJ6yg0K7y/view) | V |
| A3 | **Cinematic Studio Series: MIDI de los walkthroughs** | Piezas de los vídeos de presentación y tutoriales de legato. | .mid / .zip | Sí: CC1, CC64 y velocidad de legato (I hasta abrirlo) | CSS, CSSS, CSW | Gratis, sin cuenta, enlace directo | Ver la [tabla de tamaños](#propuesta-de-primera-descarga-pendiente-de-permiso) | V |
| A4 | **Bernard Duc: proyectos de REAPER** | Adagietto de la 5.ª de Mahler y "Lighting of the Beacons" (LOTR), con MIDI y proyecto **.rpp**. | .mid + .rpp | Sí (I) | Sin confirmar | Gratis (Google Drive) | Enlazado desde el hilo índice de VI-Control (B1) | V (listado) |
| A5 | **MID-FiLD (dataset académico, AAAI 2024)** | 4 422 frases MIDI de compositores profesionales con **curvas CC1** y metadatos de 18 instrumentos (trompa, trompeta, fagot, chelo, flauta, cuerdas…). | .mid + metadatos | CC1 sí | No indicada | Gratis, sin cuenta (GitHub) | https://github.com/POZAlabs/MID-FiLD_code (datos en github.com/pozalabs/MID-FiLD) | V. El código es MIT; **la licencia de los datos hay que comprobarla** |

A1 es lo más valioso que hemos encontrado. Permite medir **qué curva de CC produce qué sonido real**, porque
el MIDI viene emparejado con la grabación del cuarteto que imita. Además, es la familia de instrumentos más
cercana a SWAM.

### Prioridad B: grandes colecciones PERF que piden más trabajo

| # | Fuente | Qué contiene | Formato | ¿CC? | Librería | Precio / cuenta | Enlace | Conf. |
|---|---|---|---|---|---|---|---|---|
| B1 | **VI-Control: "Consolidated list of MIDI mockups and project files for study"** (ene. 2026) | Índice maestro: Balfe, Duc, LOTR Prologue, Star Wars Main Title, Oppenheimer, The Village (Gleckman), packs de pago… | Varios | Varía | Varias | El índice es gratis; algunos enlaces son de pago o de Patreon | https://vi-control.net/community/threads/consolidated-list-of-midi-mockups-and-project-files-for-study.169383/ | V |
| B2 | **VSL "Movie Masterpieces" (Jay Bacal)** | Unos 30 temas de cine como proyectos de Cubase, entre ellos **John Powell, HTTYD 2 "Together We Map the World"**, además de Goldsmith, Horner, Zimmer e Hisaishi. | .cpr (Cubase) + vídeo/mp3 | Sí, pero las articulaciones van por *expression maps* y una exportación a MIDI las pierde | VSL Synchron (VE Pro) | Gratis; necesita Cubase para exportar (la prueba de 60 días sirve) | https://www.vsl.co.at/masterpieces · hilo: https://vi-control.net/community/threads/the-final-batch-10-new-vsl-movie-masterpieces-cubase-projects-available.136593/ | V (la página oficial dio 502 una vez) |
| B3 | **Ashton Gleckman: "Film Score Project Files – Download Hub"** | Unas 40 maquetas estilo Zimmer/Nolan (Interstellar, Dune, Dark Knight, Gladiator…). | Proyectos y MIDI; formato sin especificar | Sí (I) | Varias | Gratis | https://vi-control.net/community/threads/film-score-project-files-download-hub.73680/ | V |
| B4 | **Lorne Balfe: proyectos oficiales** | Cubase + MIDI de MI: Fallout, His Dark Materials, The Crown, AC3, Kung Fu Panda 3… "para estudio", a cambio de una donación benéfica (2020). | .cpr + .mid | Sí | Sobre todo Spitfire | Gratis | Enlaces de Hightail listados en B1; post original: https://x.com/Lornebalfe/status/1268550100697133065. **Probablemente caducados.** | I |
| B5 | **Sonuscore LUX** | 8 demos con .mid (Tilman Sillescu, Robin Hoffmann…), entre ellas una maqueta de Scheherazade. | .mid | Probable | LUX Orchestral | Gratis, parece que sin cuenta | https://www.sonuscore.com/demos-and-midifiles/ | V |
| B6 | **Thinkspace (Guy Michelmore) con Orchestral Tools** | Proyecto Cubase de Berlin Orchestra; Con Sordino Strings con proyecto Cubase, MIDI, stems y mezcla. | .cpr + .mid | Probable | OT Berlin | Gratis a cambio del email | https://thinkspace.ac.uk/signup/orchestral-tools · https://thinkspace.ac.uk/?p=100798 | V |
| B7 | **VSL Synchron Prime "BOOSTER" / Orchestration Recipes** | Canciones-tutorial con proyectos para varios DAW, un MIDI y presets. | .mid + proyectos | Sí (I) | Synchron Prime | Gratis vía Vienna Assistant (requiere cuenta VSL) | https://www.vsl.co.at/tutorials/guides/orchestration-recipes/start | Disponibilidad actual sin confirmar |
| B8 | **Daft Punk "Adagio for TRON"**, MIDI para estudio | Una maqueta. | .mid | Probable | Sin confirmar | Gratis | https://vi-control.net/community/threads/midi-download-of-daft-punk-adagio-for-tron-mockup-for-study.137585/ | V (listado) |

### Prioridad C: de pago o con poco retorno

- **Synthestration "Symphonic Explorations"** (29 $): MIDI completo con CC, proyecto Cubase/Logic, stems y
  partitura para EWSO/OPUS. "Educational purposes only".
  https://synthestration.com/product/symphonic-explorations/ (V). Otros packs suyos cubren Metropolis Ark,
  Abbey Road One y Musio.
- **Spitfire/ThinkSpace "Mastering Orchestral Composition with BBCSO"** (de pago): 10 MIDI y proyectos
  Logic/Cubase para BBC SO. https://www.spitfireaudio.com/bbcso-course (V).
- **Forte Composer Academy (Benjamin Botkin)**: packs de MIDI de maquetas de cine.
  https://store.fortecomposeracademy.com/ (V, listado en B1).
- **Master The Score, "The Virtual Orchestra"** (Rico Derks): MIDI de ejercicios.
  https://www.masterthescore.com/course/the-virtual-orchestra (V; precio no legible).
- **"Orchestral Mockup Fundamentals"**: módulo de CC y MIDI extra. https://payhip.com/b/Kpot5 (V, solo el
  extracto del buscador).
- **Spitfire, MIDI de la "Beginner's Guide to Composing"**: una sesión de iniciación de la compositora
  interna Homay. https://www.spitfireaudio.com/pages/beginners-guide-to-composing (V; 5,7 KB; no indica
  librería ni CC). Poco valor, pero es oficial de Spitfire.
- **Beat Kaufmann**: MIDI de Jurassic Park para Synchron Prime, y ofrece su MIDI VSL si se le pide.
  https://www.beat-kaufmann.com/vitutorials/synchron-prime-edition/index.php (V).
- **GigaMIDI** (Hugging Face, con login, CC BY-NC 4.0): marca las pistas "expresivas", pero casi todas son
  de piano o batería. Poco útil para orquesta.

### Lo que no existe o no sirve (comprobado)

- **Spitfire**: no hay MIDI oficial de las demos de BBC SO ni de Albion ONE, ni ningún "Composer Toolkit"
  con MIDI. Las plantillas Logic/Cubase de BBC SO (https://support.spitfireaudio.com/en/articles/11815563)
  y las de Berlin Free Orchestra de **Orchestral Tools** son plantillas vacías.
- **Audio Modeling (SWAM)**: no publica MIDI de demo; solo audio y vídeo (la página /media da 404). Un
  manual antiguo, el v2.8, mencionaba MIDI en swamengine.com; no pudimos confirmarlo. El sustituto
  razonable son A1 y A2 de Sample Modeling.
- **Hans Zimmer MasterClass**: solo un cuaderno PDF, sin sesiones. **Junkie XL "Studio Time"**: solo
  vídeos de YouTube. **John Powell**: nada oficial; la única maqueta profesional encontrada es la de Bacal
  (B2).
- **Performance Samples, Cinesamples/Musio, Audio Imperia, Embertone, Musical Sampling**: demos solo en
  audio. **8Dio**: el zip de Agitato Grandiose da 404.
- **SCORE, poco útil para la expresión**: Lakh MIDI, Kunstderfuge y classicalarchives (secuencias de
  aficionados con velocidad y algo de CC7/CC11, nada específico de ninguna librería), SymphonyNet,
  GiantMIDI y ASAP (piano). **NotePerformer**: su expresión se genera dentro del motor; la exportación MIDI
  solo lleva CC derivados de la notación.
- **Libros**: Pejrolo (*Acoustic and MIDI Orchestration*) y Gilreath (*Guide to MIDI Orchestration*)
  tienen webs de acompañamiento con audio, vídeo y PDF; no se encontró MIDI.

## Datos útiles ya, sin descargar nada

### Manual de SWAM Solo Woodwinds v3.8.0 (V)

Fuente: https://static.audiomodeling.com/manuals/woodwinds/SWAM%20Solo%20Woodwinds%20v3.8.0%20-%20User%20Manual.pdf

- **Sin Expression no hay sonido.** En estudio pide "una curva de Expression" (CC11 por defecto).
- **El deslizador de Expression se pone en rojo si se mantiene por encima del 75 % (≈ CC 95).** Según el
  manual, casi toda la interpretación real ocurre entre mp y mf. Recomienda monitorizar alto para no
  sobrepasar la dinámica.
  - ~~Hipótesis: tocamos SWAM casi siempre en la zona roja.~~ **Desmentida al medir** (ver
    [Resultados del lote 1](#resultados-del-lote-1-2026-11-02)). En la salida actual de La Forja, el CC11
    de los solistas SWAM queda en mediana 66–68 (p90 87–90), y ninguna nota supera 95. La fórmula solo
    llega a 105–125 con dinámicas extremas, que los ajustes de balance de las versiones v2–v5 recortaron.
- **Portamento por velocidad**: depende de la velocidad del note-on de la nota que solapa. Con Portamento
  Max Time por debajo de 0,15 no hay portamento. Esto coincide con nuestra regla de 110–120 para ligados
  limpios.
- **Attack Control**: Vel. Hard, Vel. Soft o *Expression*. En modo Expression, el ataque sigue la forma de
  la curva al entrar. **Attack-Expr. Bias** endurece el ataque según el valor de expresión en el note-on.
- Si Note Off Velocity está desactivado, el note-off vale 112. SWAM llama C3 al MIDI 60 (el número no
  cambia).

### Retardos de legato de CSS (como orden de magnitud)

- **Oficial**: el legato se retrasa "hasta en torno a 1/4 de segundo".
- **Manual de CSS/CSSS**, según citas en foros: rápido ≈ 100 ms (vel 101–127), medio ≈ 250 ms (vel
  65–100), lento ≈ 333 ms (vel 0–64).
- **Plugin comunitario "CSS Delay Helper"** (no oficial), en ms:

  | | Lento | Medio | Rápido | Cortas | Primera nota |
  |---|---|---|---|---|---|
  | Cuerdas | 330 | 250 | 100 | 60 | 100 |
  | Metales | 230 | 230 | 100 | 60 | 100 |
  | Maderas | 220 | 130 | 90 | 60 | 90 |

**Lección para nosotros**: estas cifras son de CSS y **no valen para Albion**. Lo que sí se aplica es el
principio. El adelanto depende de la **velocidad de transición** y de la familia, no es una constante. Hoy
`expr.mjs` adelanta 25 ms las notas atacadas y 50 ms las ligadas, sea cual sea la velocidad, aunque esa
misma velocidad ya codifica la rapidez de la transición (112 / 96 / 78 / 58). Hay que medir el retardo
real de cada patch de Albion. La forma de hacerlo está en el paso 4 del plan.

## Licencias: regla práctica

Ninguna fuente de A ni de B publica licencia sobre el MIDI. Las únicas con texto son Balfe ("para
estudio"), Synthestration ("educational purposes only", copyright de los autores) y MID-FiLD (el código es
MIT; los datos, por confirmar). Mientras no haya licencia explícita:

1. **Uso permitido**: escucharlos, abrirlos, medirlos y extraer **estadísticas y patrones**: rangos,
   formas normalizadas, retardos, distribuciones. Eso es análisis, no copia.
2. **Uso no permitido**: commitear los .mid en el repo, pegar sus notas o curvas literales en una pieza
   nuestra, o redistribuirlos. Van en una carpeta ignorada por git, como los PDF de `composition/`.
3. Las notas del vault guardan **números agregados y reglas con nuestras palabras**, citando la fuente.
   Nunca guardan fragmentos MIDI.

## Cómo aprovecharlos en este repo

### Lo que tenemos hoy

- `reaper/rm_beat_builder.lua` solo **escribe**:
  - `build_beat` / `replace_midi` / `add_midi` insertan `{beat, cc, value}` y aplican forma lineal entre
    puntos;
  - `humanize_midi` añade desplazamiento constante, aleatorio ± y deriva senoidal, más velocidad ±;
  - `swing_midi`, `lock_midi`, `set_cc_shape` y `adjust_velocity` completan la familia de comandos de
    "MIDI feel".
- **`dump_midi` no exporta CC**: solo devuelve notas. Ahora mismo no podemos leer cómo retoca el usuario
  las curvas a mano.
- La inteligencia expresiva vive en el generador de cada pieza. La versión más madura es
  `A:\CERBATANA\Ableton\2026-11-02 La Forja del Alba\generator\expr.mjs`, y todo en ella son constantes a
  ojo:
  - **Albion longs/legato**:
    - CC1 = curva de dinámica + `noteShape` (dip de 4–9 al ataque, pico de +4/+6/+8 al 55 % de la nota) +
      deriva senoidal de ±3,6;
    - CC11 de frase fijo 104 → 114 → 112 → 100;
    - CC21 retrasado (20 % → 30 % → 100 % al 75 % de la nota);
    - ataques adelantados 25/50 ms;
    - solape de legato de 70 ms;
    - velocidad de legato por duración (112/96/78) o 58 en saltos lentos.
  - **Shorts**: humanización de ±5–9 ms, velocidad = dinámica + 6 ± 4, un punto de CC11 por tiempo.
  - **SWAM**:
    - CC11 empieza en 22/26, sube en 180/140 ms, contorno por altura (0,9/semitono) y arco de ±9;
    - rearticulación con caída de 9–12;
    - cola de 320/380 ms hasta 14/20;
    - CC1 de vibrato con retardo de 0,12–0,6 s;
    - solape de 35 ms y hueco de 45 ms.
  - Respiraciones: `STAMINA` (segundos por frase y hueco en ms).

El análisis debe producir **los mismos parámetros**, para poder sustituir cada constante por un valor
medido, o al menos contrastarla con uno.

### Plan en 6 pasos

**1. Carpeta de referencias, fuera de git**

- `reference-midi/<fuente>/<archivo>.mid` más un `reference-midi/catalog.json` con origen, URL, fecha,
  librería, familia, licencia y si es PERF o SCORE.
- Añadir `reference-midi/` a `.gitignore`.
- Los proyectos Cubase/Logic (B2, B4) se exportan a .mid fuera de este repo. Las articulaciones de las
  *expression maps* se pierden, así que hay que apuntar el mapa de cada pista en el catálogo.

**2. `scripts/analyze-reference-midi.mjs`**

Node sin dependencias, porque no hay `mido` ni `pretty_midi` instalados y un lector SMF son unas 120
líneas. El script:

- Lee SMF tipo 0/1, el mapa de tempo y los cambios de compás, y pasa todo a **segundos y negras**.
- Clasifica cada pista por nombre, rango o keyswitch en `family` (strings, woods, brass, perc…) y `kind`
  (`legato`, `long`, `short`, `modeled`), igual que `PROFILE` en `expr.mjs`. Cuando no lo puede deducir,
  se lo indica el catálogo.
- Segmenta en **frases**: líneas monofónicas cortadas por silencios de 120 ms o más, y "eventos" que
  agrupan los ataques a menos de 40 ms (la misma regla que `events()`).
- Calcula las métricas de la tabla siguiente.

| Métrica | Qué mide | Constante nuestra que contrasta |
|---|---|---|
| Adelanto de ataque (ms) por `kind` y velocidad | Diferencia entre el note-on y la rejilla más probable. La subdivisión se elige por la mediana del error; se reporta la mediana y el p10/p90. | 25/50 ms de `albion()` y ±6 ms de `swam()` |
| Solape de legato (ms) y su relación con la velocidad y el intervalo | Note-off de n menos note-on de n+1 en líneas monofónicas | 70 ms (Albion) y 35 ms (SWAM); tabla de velocidad 112/96/78/58 |
| Hueco de rearticulación (ms) | Silencios cortos entre notas no ligadas | 45 ms (SWAM), 20–30 ms (Albion) |
| Forma de CC11 por frase | Valor al inicio, pico (valor y posición relativa 0–1), final, rango, tiempo de subida y tiempo desde la caída hasta el note-off final. Se reporta como **curva media normalizada** en 20 puntos. | Albion 104/114/112/100; SWAM 22 → objetivo en 180 ms, cola de 320 ms → 14 |
| Caídas de CC11 entre notas ligadas y no ligadas | Profundidad y duración del valle | Caída de rearticulación de 9–12; "nunca caer entre ligadas" |
| CC1 y dinámica | Distribución de CC1 por banda de velocidad y por posición en la frase; pendiente máxima (CC/s) | `noteShape` (dip y pico), deriva de ±3,6 |
| Densidad de CC | Eventos por segundo y por nota, y proporción de escalones mayores de 4 | Nuestras rampas lineales de 4 pt/negra y el adelgazamiento con `thin()` |
| Vibrato (CC21 o CC1 en modelados) | Retardo hasta el 50 % del máximo, en función de la duración de la nota | `vibDelay` y la rampa de CC21 |
| Velocidad en cortas | Desviación típica, acento por posición métrica (tiempo fuerte frente a débil), correlación con el contorno melódico y patrón en notas repetidas | `hum` y ±4 aleatorio |
| Proporción de duración | Duración de la nota dividida por el IOI, por `kind` | Duración de las cortas, `stacc` 120 ms |
| Longitud de frase y respiraciones | Segundos entre silencios de 200 ms o más, por instrumento y dinámica | `STAMINA` |

- **Salidas**:
  - un informe por archivo en Markdown y JSON, en `reference-midi/_reports/` (fuera de git);
  - un agregado por `family × kind × librería` en
    `knowledge/composition/data/reference-midi-stats.json`. Solo lleva números agregados, nunca notas, y
    se versiona.
- **Modo `--compare`**: el mismo análisis sobre **nuestra** salida. Puede leer directamente los
  `out/cmd/*.json` de `replace_midi` del generador, que ya llevan `cc`, o un .mid exportado. El informe
  es una tabla "referencia / nuestro / diferencia" por métrica. Es la herramienta principal: dice qué
  parte de nuestra programación se aleja más de lo profesional.

**3. Ampliar `dump_midi` con `cc: true`**

Cambio pequeño en el bridge: devolver `{bar, beat, cc, value, shape}` por pista. Así el analizador puede
leer el proyecto abierto, incluidas las **correcciones a mano del usuario**. Esas son la mejor referencia
posible, porque reflejan su oído con sus librerías. Después hay que actualizar la prueba estática del
bridge y correr `npm test`.

**4. Calibrar las librerías propias: el retardo del legato de Albion**

Ningún MIDI de terceros está hecho para Albion ONE, así que esto se mide con `render_audio`:

- renderizar pares de notas ligadas con velocidades 40, 70, 100 y 120 en cada patch de legato
  (`Strings High (Octave) - Legato`, `Woods High - Legato`, `Brass Mid - Legato`);
- medir con `scripts/analyze_render.py` dónde llega la energía de la segunda nota respecto al note-on;
- hacer lo mismo con el ataque de los longs a pp, mf y ff.

El resultado es una tabla de retardo por patch y velocidad, que sustituye los 25/50 ms fijos. Va en la
nota de patches (ver paso 5) y en `orchestral-patch-library`.

**5. Notas en el vault**

Siguen `_meta/synthesis-spec.md` y `conventions.md`: notas en inglés, como el resto del vault, y reglas
marcadas `(measured: <fuente>)`. Hay que añadir un dominio nuevo,
`knowledge/composition/performance/` (programación MIDI de maquetas, el hueco "patch and keyswitch maps"
que lista START-HERE). Contenido:

- `_performance.md` (mapa de contenidos);
- `cc-expression-phrase-shapes.md`: curvas CC11/CC1 normalizadas por familia, con rangos medidos;
- `legato-overlap-and-attack-offsets.md`: solapes, adelantos por velocidad y la tabla del paso 4;
- `velocity-and-timing-humanization.md`: distribuciones de velocidad y timing de cortas, y acento
  métrico;
- `modeled-instruments-swam.md`: los datos del manual de SWAM y lo medido en A1/A2 (Expression por debajo
  del 75 %, attack por expresión, portamento);
- `sources/reference-midi-<fuente>.md`: una ficha por fuente (origen, licencia, qué se midió, fecha).

Además:

- añadir una fila en el router de `START-HERE.md`: "suena a MIDI / más realista / curvas de expresión" →
  `performance/`;
- añadir a `workflows/validate-generated-midi.md` un paso 5b: "pasar `analyze-reference-midi --compare`
  y revisar las desviaciones de más de p10/p90";
- correr `node scripts/build-knowledge-index.mjs` (0 errores).

**Precedencia**: lo medido es un *default* con fuente, del nivel 4 en START-HERE. Solo pasa a
`workflows/user-taste.md` cuando el usuario lo valida de oído (paso 6). Las reglas actuales de user-taste
(R2: CC suaves, velocidad por voz) siguen mandando.

**6. Iterar por A/B de oído**

1. Elegir un pasaje de La Forja con solista SWAM, legato de cuerda Albion y cortas.
2. Generar dos versiones: las constantes actuales y las medidas.
3. Renderizar ambas con `render_audio` y dejar que el usuario elija.
4. Lo que el usuario apruebe se escribe en el `PROFILE`/`STAMINA` del generador (o en un futuro
   `expr` compartido en el repo) y en user-taste. Lo que rechace se anota como "medido pero no
   validado".

**Orden recomendado**: 1 → 2 con A1/A2/A3 → 3 → 4 → 5 → 6. Con A1–A3 bastan unas 300 KB de MIDI para tener
las primeras cifras de solapes, adelantos y forma de CC11.

## Propuesta de primera descarga (pendiente de permiso)

No se descarga nada sin un "sí" explícito del usuario. Lote 1, gratuito y sin cuenta. Los tamaños son
reales, obtenidos por `HEAD`:

| Archivo | Origen | Tamaño |
|---|---|---|
| `legatointro_midi.zip` (tutorial de legato de CSS) | https://www.cinematicstudioseries.com/MIDI/CSS/legatointro_midi.zip | 7,9 KB |
| `art_walkthrough_midi.zip` (articulaciones de CSS) | https://www.cinematicstudioseries.com/MIDI/CSS/art_walkthrough_midi.zip | 31,8 KB |
| `introvid.zip` (pieza de presentación de CSSS) | https://www.cinematicstudioseries.com/MIDI/CSSS/introvid.zip | 15,5 KB |
| `CSW_Intropiece.midi` (pieza de presentación de CSW) | https://cinematicstudioseries.s3.us-east-2.amazonaws.com/MIDI/CSW/CSW_Intropiece.midi | 14,3 KB |
| `CSW_Legato_Walkthrough.midi` | https://cinematicstudioseries.s3.us-east-2.amazonaws.com/MIDI/CSW/CSW_Legato_Walkthrough.midi | 68,9 KB |
| Los MIDI de Trumpet v3, Trombone v3 y Strings | Google Drive de Sample Modeling (A2) | Desconocido; Drive no lo expone sin abrirlo |
| Solo los 4 .mid del Challenge REVEAL, sin los WAV | Carpeta de Drive de A1 | Desconocido (pequeños; los WAV se omiten salvo que el usuario los quiera para comparar con la grabación) |

Notas sobre el lote:

- No incluye `consord_midi.zip` (6,7 MB, probablemente con audio) ni `csss_articulation_demo.zip` (1,9 MB).
- **MID-FiLD** se deja para un lote 2, después de confirmar la licencia de los datos y el tamaño del zip.
- B2 (VSL/Bacal) y B4 (Balfe) necesitan Cubase para exportar el MIDI. Eso lo decide el usuario.

## Resultados del lote 1 (2026-11-02)

Esto ya se ha hecho:

- Se descargó el lote 1, aprobado por el usuario: 12 archivos, unos 607 KB y **solo MIDI**. Los zip se
  abrieron en carpetas propias, sin ejecutar nada.
- Todo quedó en `reference-midi/` (git-ignored), con `catalog.json` (origen, URL, tamaño, mapa de CC por
  grupo).
- Los readme de CSS dicen que el MIDI se publica *for educational purposes* y prohíben renderizarlo,
  venderlo o darle cualquier uso comercial sin permiso. Sample Modeling no indica licencia.

**Archivos descargados:**

| Grupo | Archivos | Tamaño |
|---|---|---|
| `css-strings` | `legatointro_midi.zip`, `art_walkthrough_midi.zip`, `introvid.zip` (CSSS) | 7,9 + 31,8 + 15,5 KB |
| `csw-woods` | `CSW_Intropiece.midi`, `CSW_Legato_Walkthrough.midi` | 14,3 + 68,9 KB |
| `sm-brass` | `Trumpet_MIDI_Files.zip` (8 MIDI), `Trombone_MIDI_Files.zip` (2 MIDI); en el análisis también entra la trompa del archivo de Roemer, que viene en el zip de cuerdas | 155,4 + 28,4 KB |
| `sm-strings` | `Strings_MIDI_files.zip` (5 demos de usuarios: Vicentini ×2, Mulawa, Kamps, Roemer) | 138,0 KB |
| `sm-reveal` | Violin I, Violin II, Viola, Cello (REVEAL; sin los WAV) | 55,7 + 38,4 + 49,0 + 45,0 KB |

### Analizador: `scripts/analyze-reference-midi.mjs`

Es Node sin dependencias, con su propio lector SMF y el mapa de tempo. Mide:

- solapes y huecos;
- velocidad de las notas ligadas según la duración de la nota;
- desfase respecto a la rejilla;
- forma de la curva de expresión por frase: inicio, pico, final, posición del pico, subida, anticipo
  antes del note-on, caída final y valles en las transiciones;
- retardo del vibrato.

Lee los MIDI del catálogo y la salida del generador (`out/build.json` + `out/cmd/*.json`, CC con rampas
lineales). Con `--compare ref:nuestro` saca una tabla de diferencias. Los informes completos están en
`reference-midi/_reports/` (`batch1-vs-la-forja.md`, `batch1-summary.json`).

```bash
node scripts/analyze-reference-midi.mjs --catalog reference-midi/catalog.json --generator "A:/CERBATANA/Ableton/2026-11-02 La Forja del Alba/out" --gen-groups "forja-swam=^(FL|OB|EH|CL|BSN|HN) SOLO$=11,none,1;forja-swamStr=^(VLN|VC) SOLO$=11,none,1;forja-albLegato=LEGATO$=1,11,21" --compare sm-brass:forja-swam --compare sm-strings:forja-swamStr --compare css-strings:forja-albLegato
```

**Mapa de CC**:

- CSS y CSW: CC1 = dinámica (la expresión) y CC58 = articulación; no hay CC de vibrato.
- Sample Modeling: CC11 = expresión, CC1 = vibrato y CC19 = velocidad del vibrato, el mismo esquema que
  SWAM. La trompa de Roemer usa CC2 como expresión.
- REVEAL no documenta su mapa. Se asume CC2 = expresión, por ser la pista más densa.

### Cifras principales: referencia frente a La Forja

Formato: mediana (p10–p90).

**Solistas modelados**: SWAM de La Forja frente a Sample Modeling.

| Métrica | SM metales | SM cuerdas / REVEAL | Nuestro SWAM viento / cuerda | Constante actual en `expr.mjs` |
|---|---|---|---|---|
| Solape de legato (ms) | 34 (10–152) | 36 (17–129) / 28 (9–253) | 35 (30–39) / 34 (30–40) | `+35 ms` fijo |
| Vel. de nota ligada ≥ 500 ms | 47 (11–83) | 62 (12–90) / 28 | 111 / 112 | 112 ± 4 siempre |
| Vel. de nota ligada 250–500 ms | 74 (32–111) | 70 (40–84) / 65 | 113 / 114 | — |
| Desfase vs rejilla, atacadas (ms) | 1 (−28…31) | 0 (−23…23) / −1 (−25…23) | 0 (−4…5) / 0 (−4…4) | `rr(6)` |
| CC11 en las notas | 90 (61–119) | 48 (25–84) / 59 (33–84) | 66 (46–87) / 68 (35–90) | `map` + contorno + arco |
| Inicio → pico → final de frase (CC11) | 86 → 113 → 57 | 23 → 60 → 6 / 48 → 76 → 29 | 24 → 73 → 12 / 28 → 73 → 19 | 22/26 → … → 14/20 |
| Posición del pico (0–1) | 0,27 | 0,51 / 0,39 | 0,47 / 0,64 | arco senoidal centrado + pico de nota al 55 % |
| Subida inicial (ms) | 215 (87–1510) | 975 / 125 | 790 / 970 | 180/140 ms + arco |
| Anticipo de la curva antes del note-on (ms) | 110 (0–573) | 0 (0–298) / 198 | 15 / 20 | 20 ms (`p0 − 0.02`) |
| Caída final: duración (ms) · cuánto | 205 · 19 | 1591 · 24 / 65 · 5 | 896 · 46 / 921 · 42 | cola de 320/380 ms hasta 14/20, más el arco que ya baja |
| Retardo del vibrato (relativo a la nota) | 0,36 | 0,26 / 0,27 | 0,04 / 0,35 | 0,12–0,6 s |

**Secciones de legato**: CSS y CSW (CC1) frente a la sección de legato de Albion de La Forja (CC1).

| Métrica | CSS cuerdas | CSW maderas | Nuestro Albion legato |
|---|---|---|---|
| Solape de legato (ms) | 167 (23–904) | 53 (12–340) | 70 fijo |
| Vel. de nota ligada ≥ 500 ms | 32 (14–42) | 47 (22–74) | 78 (73–82) |
| Desfase de ligadas vs rejilla (ms) | 9 (−50…46) | 2 (−33…35) | −50 fijo |
| CC1 en las notas · % > 95 | 64 · 26 % | 61 · 11 % | 102 · 63 % |
| Posición del pico de CC1 | 0,48 | 0,42 | 0,78 |
| Frase (s) | 1,8 | 1,6 | 18,9 |

### Lectura

Las conclusiones son provisionales: hay pocas frases por grupo y las librerías son distintas. Ninguna
cifra pasa al generador sin una prueba A/B de oído.

1. **La velocidad de las ligadas es lo más mecánico.** Ponemos 109–115 en todas las notas ligadas de
   SWAM. Los programadores de Sample Modeling la varían según la nota, más baja en las largas (≈ 47–62 en
   notas de 0,5 s o más, ≈ 70–80 en las medias). En SM y SWAM esa velocidad gobierna la transición
   (portamento), así que nuestras ligadas son todas igual de "secas".
   - *Prueba*: velocidad de ligada ≈ 85 − 30·(duración ≥ 0,5 s) ± 12, y más baja en saltos lentos.
2. **La forma de la frase de SWAM está al revés en los extremos.**
   - *Arranque*: empezamos muy abajo (≈ 1/3 del pico) y subimos en 0,8–1 s. Los metales de SM arrancan
     ya al 75 % del pico, con la curva moviéndose unos 110 ms antes del note-on, y llegan al objetivo en
     unos 215 ms. REVEAL anticipa unos 200 ms y sube en 125 ms.
   - *Final*: caemos tarde y mucho (≈ 45 puntos en 0,9 s). Ellos caen poco (5–24 puntos) y más cerca del
     final, salvo las cuerdas lentas de SM.
   - *Pico*: el nuestro llega tarde (0,47–0,64 de la frase). En metales llega pronto (0,27).
   - *Prueba*: anticipar el CC11 100–200 ms, arrancar más alto en viento/metal, bajar la caída final
     a unos 20 puntos y adelantar el pico.
3. **El timing está demasiado limpio.** Nuestros ataques SWAM se desvían ±4–5 ms (p10–p90) y los de
   referencia ±23–31 ms, porque están tocados en vivo. En Albion aplicamos −25/−50 ms fijos. CSS y CSW no
   adelantan nada en el MIDI (mediana ≈ 0): Alex Wallbank compensa con retardo de pista, no nota a nota.
   Ese retardo depende de la librería, así que hay que medirlo para Albion (paso 4 del plan).
4. **Solape SWAM correcto en la mediana (≈ 35 ms), pero sin variación.** La referencia va de 10 a
   150 ms. En Albion, 70 ms queda entre CSW (53) y CSS (167).
5. **La sección de legato de Albion va casi siempre en forte.** Su CC1 queda en mediana 102, con el 63 %
   de las notas por encima de 95; CSS y CSW se quedan en 61–64. El pico llega al 78 % de la frase, frente
   al 42–48 %. Las frases duran unos 19 s frente a 1,6–1,8 s: casi no hay respiraciones ni cortes de
   fraseo en las secciones.
   - Matiz: el CC1 de Albion no responde igual que el de CSS. Esto se contrasta midiendo el render, no
     solo el MIDI.
6. **Fallo encontrado en nuestro generador.** En `expr.mjs` (función `swam`), el último punto de
   vibrato (CC1) de una nota ligada cae después del primer punto de la nota siguiente, porque el solape
   alarga la nota. REAPER ordena los puntos, así que el vibrato hace 40 → 0 → 28 → 15 en cada ligado:
   cae a cero y rebota. Eso explica el "retardo 0,04" medido en el viento SWAM. Ejemplo: OB SOLO, beats
   11,78–12,38 del primer ítem. Hay que recortar los puntos de cada nota al inicio de la siguiente, como ya
   hace `albion()` con `cut`.
7. **Lo que no se ha cumplido**: la hipótesis de la "zona roja" de SWAM (ver arriba). El nivel medio del
   CC11 de SWAM queda entre el de SM cuerdas (48–59) y el de SM metales (90).

### Fix del vibrato y A/B preparado (2026-11-02, aprobado por el usuario)

**Vibrato SWAM corregido** en `generator/expr.mjs` (función `swam`). Hay copia de seguridad de `expr.mjs`,
`main.mjs` y `out/` en `backups/generator-2026-11-02-vibfix/`.

- Los puntos de CC1 de cada nota se recortan al inicio de la siguiente.
- En un ligado, el vibrato del viento ya no vuelve a 0: arranca al 30 % de la profundidad.
- Resultado en OB SOLO, beats 11,78–12,38: antes 40 → 0 → 28 → 15; ahora 40 → 28 → 13 → 15.
- El retardo medido del vibrato del viento pasa de 35 ms a unos 590 ms. La referencia SM está en unos
  1040 ms y la nuestra de cuerda en 470 ms.

**Variante B**: `EXPR_B=1 node main.mjs`. Sin el flag, la salida es A, idéntica byte a byte entre
ejecuciones. `FORJA_OUT=<carpeta>` escribe en otra carpeta sin tocar `out/`. B cambia lo siguiente:

- **SWAM, velocidad de ligadas**: según la duración de la nota, 110 (< 0,25 s), 98 (0,25–0,5 s) y 88
  (≥ 0,5 s), ±6, con 4 menos en cuerda. La trompa nunca baja de 100, porque su portamento máximo es de
  2,4 s.
  - No se copian los 47–75 de Sample Modeling: en SWAM la velocidad baja alarga el portamento, y el
    usuario ya validó de oído 110–120 para ligados limpios.
- **SWAM, frase**:
  - CC11 empieza 150 ms (viento) o 120 ms (cuerda) antes del note-on, desde el 60 % del objetivo;
  - llega al objetivo en 90/110 ms;
  - el pico del arco se adelanta a ~0,37 de la frase;
  - la caída final es de unos 22 puntos en 240/300 ms, en vez de bajar hasta 14/20.
- **SWAM, timing**: humanización triangular de ±24 ms (antes ±6) y solape de ligado de 28–50 ms (antes
  35 fijo).
- **Albion longs y legato**:
  - capa dinámica CC1 = 0,78·v + 6, un ~16 % más abajo;
  - CC11 de frase +8, para devolver parte del volumen;
  - adelanto de ataque ±8 ms aleatorio;
  - frases de sección más cortas con respiraciones: STR LEGATO 7 s y 120 ms de hueco, WW/HN LEGATO 8 s y
    220 ms.
- **Efecto colateral**: B consume más números aleatorios, así que la humanización de las demás pistas
  (cortas, piano, percusión) también cambia ligeramente.

**Pasaje**: compases 52–64 de *II Despertar* (3/4, ♩76). VLN SOLO (SWAM) lleva la melodía sobre STR
LEGATO (Albion), con el resto de la orquesta. El render empieza en el 52 para que las notas que vienen de
antes suenen, y añade 3 s de cola.

**Cómo se renderizó**:

- en una copia, `La Forja del Alba - AB expresion.rpp`, hecha desde el `.rpp` principal en disco (estado
  v5, sin la prueba del techo de SWAM);
- con `replace_midi` de las 27 pistas para A y luego para B;
- la copia quedó guardada con B cargado;
- el `.rpp` original no se ha tocado.

**Nivel**: A integra −27,7 LUFS y B −28,1. La diferencia B−A por medio compás tiene mediana −0,2 dB
(p10 −1,0, p90 +1,0), así que el A/B es justo sin compensar ganancia.

**WAV para escuchar**:

- A (actual + fix): `A:\CERBATANA\Ableton\2026-11-02 La Forja del Alba\renders\ab-expresion\A_actual_c52-64.wav`
- B (medido): `A:\CERBATANA\Ableton\2026-11-02 La Forja del Alba\renders\ab-expresion\B_medido_c52-64.wav`

El MIDI de cada versión está junto a los WAV, en `out-A/` y `out-B/`.

**Decisión del usuario (2026-11-02): "B, la medida".** Cambios aplicados:

- en `expr.mjs`, B es ahora el comportamiento por defecto y `EXPR_A=1` recupera A. Se comprobó que la
  salida es idéntica a `out-B/` y a `out-A/` respectivamente;
- la preferencia está anotada en `knowledge/composition/workflows/user-taste.md` como R17;
- las notas del vault están en `knowledge/composition/performance/`;
- la ficha de fuente es `sources/reference-midi-batch1.md`.

El `.rpp` original de La Forja no se ha regenerado con B. Aplicarlo a la pieza es una decisión aparte.

### Siguiente paso propuesto

1. ~~Corregir el fallo del vibrato (punto 6).~~ Hecho.
2. ~~Preparar el A/B~~ Hecho: el usuario eligió B.
3. ~~Notas del vault en `performance/`~~ Hechas. Quedan pendientes el lote 2 (abajo) y la calibración de
   Albion con renders (ver [Plan de calibración](#plan-de-calibración-de-nuestras-librerías-con-renders-pendiente-de-permiso)).

## Lote 2: propuesta (pendiente de permiso, NADA descargado)

Fecha: 2026-11-02.

**Objetivo**: maquetas **completas**, para aprender el balance de tutti (qué nivel lleva cada familia
según su papel) y no solo frases sueltas.

**Origen**: casi todo sale del hilo índice de VI-Control (B1), leído en el navegador.

**Tamaños**: son reales, obtenidos con `HEAD`, que no descarga el archivo.

**Licencias**: ninguna maqueta comunitaria declara licencia. Se publican "para estudio" y se aplica la
misma regla que en el lote 1: solo análisis, nunca al repo y nunca copiar.

### Propuesta: descarga recomendada

| # | Archivo | Origen | Tamaño | Licencia | Qué aprenderíamos |
|---|---|---|---|---|---|
| L2-1 | `Duc_Bernard_Mahler_adagietto.MID` | Bernard Duc, Google Drive enlazado en el índice | 373 KB | No declarada; compartido para estudio | Cuerda y arpa lentas: forma de frase y respiración de una sección completa, balance entre las partes de cuerda |
| L2-2 | `DucBernard_LOTR_TheWhiteTree_v1.MID` | Bernard Duc, Google Drive (el índice lo llama "Lighting of the Beacons") | 370 KB | No declarada; para estudio | Tutti épico: metales, cuerda y percusión a la vez; nivel por familia en el clímax |
| L2-3 | `DucBernard_LOTR The White Tree_v2.RPP` | Bernard Duc, Google Drive | **4,6 MB** | No declarada | **Proyecto de REAPER**: nombres de librerías, volúmenes, panorama, envíos y FX por pista. Es el balance de tutti real, no solo el MIDI |
| L2-4 | `2024_star_wars_main_title.mid` | Ilya Zhuravlev, Google Drive | 204 KB | No declarada; para estudio | Tutti completo con **CSS, CSSS, CSB y CSW**, la misma familia que el lote 1, así que se puede comparar directamente. Incluye metales, que no tenemos de CSS |
| L2-5 | `MID-FiLD_dataset.zip` | POZAlabs, GitHub (`pozalabs/MID-FiLD`) | **5,4 MB** | **MIT** (fichero `LICENSE` del repo, que contiene el zip) | 4422 frases con **CC1 y papel** (`main_melody`, `sub_melody`, `pad`, `accompaniment`, `bass`, `riff`) de 18 instrumentos: dinámica según el papel, base estadística del balance |
| L2-6 | `The-Village.mid` | Ashton Gleckman, Dropbox | 182 KB | No declarada; "free MIDI file download" | Cuerda íntima de JNH con violín solista: solista sobre lecho |
| L2-7 | `time_midi.mid` | Tuomo Tanila, Dropbox | 299 KB | No declarada; para estudio | Zimmer "Time": crescendo de capas, cómo crece el tutti por entradas |

**Subtotal recomendado**: unos 11,8 MB, o 7,2 MB sin el `.RPP` de L2-3.

**Opcional, con aviso**:

- **L2-8** `Duc_Bernard_Adagietto_Mahler5th_v1.RPP`, **24 MB**: es texto, pero grande, porque lleva los
  estados de los plugins. Aporta lo mismo que L2-3 en otra textura.
- **Los `.RPP` no se abren en REAPER**: se leerían como texto con un script, para sacar pistas,
  volúmenes y nombres de plugins. Abrirlos cargaría plugins que no tenemos y podría colgar REAPER.

### Vistos y descartados por ahora

| Fuente | Por qué no |
|---|---|
| VSL Movie Masterpieces (Jay Bacal, unas 30 piezas, entre ellas *HTTYD 2*) | Son `.cpr` de **Cubase**, de 11–13 MB cada uno (Mulan 11,5 MB, Howl 13,4 MB, en Dropbox). Exportar el MIDI requiere Cubase (prueba de 60 días con cuenta Steinberg). Las *expression maps* se pierden, así que hay que anotar las articulaciones a mano. Merece la pena para el balance de tutti, pero lo decide el usuario: cuenta, instalación y tiempo |
| Carpeta de Drive con *Finding Nemo* Main Title (21 KB), *Concerning Hobbits* (106 KB) y *No Time to Die* Final Ascent / Matera (173 / 80 KB) | Aparece en el índice justo después de los packs **de pago** de Benjamin Botkin y sin autor. Podría ser contenido de pago compartido sin permiso. No se descarga hasta confirmar su origen |
| Ashton Gleckman, *Narnia – Free Pack* | 1,1 GB: lleva audio o stems. Si interesa, solo el MIDI suelto |
| Lorne Balfe (unos 25 proyectos en Hightail) | Proyectos de Cubase grandes; enlaces de 2020, probablemente caducados; habría que abrir Hightail uno a uno |
| *Oppenheimer – Can You Hear The Music* (Dropbox) | Dropbox no da el tamaño sin descargar; la autoría no se indica |
| ProjectSAM tutorials, Audio Imperia Nucleus | MIDI pensado para librerías que no tenemos |
| Patreon / Synthestration / Forte / ManyWorlds (este último tiene MIDI para SWAM a 4,80–6,99 £ cada uno) | De pago. ManyWorlds podría interesar por SWAM, pero lo decide el usuario |

**Próximo paso**: el usuario dice sí o no a L2-1…L2-7 (y L2-8). Nada se descarga hasta entonces.

## Separar intérprete y librería

Cada librería se toca distinto, así que las cifras de referencia no se copian tal cual. El analizador y
las notas de `performance/` separan dos capas:

- **Lo que hace el intérprete**, que se puede transferir entre librerías:
  - forma de frase **normalizada al pico** (inicio, final, caída y valles como % del pico);
  - posición del pico;
  - anticipo y subida en ms;
  - duración de las frases y de las respiraciones;
  - dispersión del timing;
  - retardo relativo del vibrato.
- **Cómo lo traduce cada librería**, que no se transfiere:
  - qué CC es expresión o dinámica;
  - nivel absoluto del CC;
  - qué significa la velocity (dinámica, velocidad de legato o tiempo de portamento);
  - solape mínimo y retardo de legato;
  - curva de respuesta del CC en dB.

La tabla de traducción de nuestras librerías está en
`knowledge/composition/performance/library-translation-table.md`. Marca qué está medido, qué es
documentación y qué es supuesto.

## Plan de calibración de nuestras librerías con renders (pendiente de permiso)

**Objetivo**: medir lo que la tabla de traducción marca como supuesto:

- el retardo real del legato y del ataque de Albion según la velocity;
- la respuesta de CC1 y CC11 en dB de Albion y SWAM.

**Restricciones**:

- **No se toca la pestaña `La Forja del Alba - AB expresion.rpp`**, que el usuario está usando.
- No se carga otra orquesta: con dos orquestas abiertas REAPER puede colgarse.

**Propuesta**:

1. Crear un proyecto de prueba nuevo y vacío en una pestaña aparte:
   `A:/CERBATANA/Ableton/calibracion-librerias/calibracion.rpp`. Lleva **una sola pista**, sin reverb, a
   ♩60 y en 4/4.
2. Cargar **un patch cada vez** con `load_patch` (`Strings High (Octave) - Legato`, `Woods High -
   Legato`, `Brass Mid - Legato`, `Strings - Long`, luego un SWAM, etc.), medirlo y vaciar la pista antes
   del siguiente. Nunca hay más de un Kontakt o un SWAM cargado.
3. Por cada patch, un MIDI de prueba generado por script:
   - **Retardo de legato**: pares ligados (C4 → D4, solape de 80 ms) con velocity 30, 60, 90 y 120, uno
     cada 4 s. Mide cuándo llega la energía de la segunda nota respecto a su note-on.
   - **Retardo de ataque**: notas sueltas de 1 s con CC1 = 40, 80 y 120 (velocity 40, 80 y 120 en
     cortas). Mide el tiempo hasta −6 dB del pico.
   - **Respuesta de CC**: una nota larga con CC1 en escalones de 10 (CC11 = 127) y luego CC11 en
     escalones de 10 (CC1 = 80), 2 s por escalón. Da la curva dB(CC) de cada controlador. En SWAM, igual
     con CC11.
4. Render de la pista con `render_audio` (`--timeout 400000`) y medida con un script de Python que
   detecte el ataque y el RMS por escalón.
5. Guardar los resultados en `library-translation-table.md` como "medido" y, si hace falta, en
   `expr.mjs` (adelanto por velocity).

**Comandos** (tras un "sí" del usuario y con `status` en verde):

```bash
node bin/reaper-manager.js status
node bin/reaper-manager.js send calib-new.json
node bin/reaper-manager.js send calib-patch.json
node bin/reaper-manager.js send calib-midi.json
node bin/reaper-manager.js send calib-render.json --timeout 400000
python -I scripts/calibrate_render.py <wav>
```

- `calib-new.json` es un `save_project` + `open_project` de un `.rpp` vacío nuevo.
- `calib-patch.json` es `load_patch` en la pista CAL, con `replace`.
- `calib-midi.json` es `replace_midi` con la prueba.
- `scripts/calibrate_render.py` está por escribir.

El tiempo estimado es de 2–3 minutos por patch, con unos 8 patches.

## Resultados del lote 2 y de la calibración (2026-11-02, aprobado por el usuario)

### Lote 2 descargado

Son siete archivos, todos con el tamaño anunciado: unos 11,4 MB, y no se descargó el `.RPP` de 24 MB.
Están en `reference-midi/_downloads/` y catalogados en `catalog.json` con los grupos `tutti` y `mid-fild`.

| Archivo | Tamaño |
|---|---|
| Duc, Adagietto `.MID` | 373 KB |
| Duc, LOTR White Tree `.MID` | 370 KB |
| Duc, LOTR White Tree `.RPP` (leído como texto) | 4,6 MB |
| Star Wars Main Title (Zhuravlev) | 204 KB |
| MID-FiLD (MIT; 4422 `.mid` + CSV) | 5,4 MB |
| The Village (Gleckman) | 182 KB |
| Time (Tanila) | 299 KB |

### Analizador

Tiene un modo nuevo, `--tracks <archivo>`, que da una tabla por pista: CC1, CC11, CC7 y CC2 en las
notas, velocity, registro, polifonía y fracción del tiempo activa. Las tablas están en
`reference-midi/_reports/batch2/`.

### Lo aprendido sobre el tutti

Detalle en `knowledge/composition/performance/tutti-balance-by-role.md`:

- **Faders a 0 dB.** En el `.RPP` de Duc todos los faders de instrumento están a 0 dB y solo se recortan
  los buses de familia (−2,1 a −6,6 dB). El balance está en el MIDI, como pide el usuario.
- **Papel de cada línea** (MID-FiLD, CC1 medio):
  - melodía principal 74 y la que más se mueve (36 puntos de rango por frase);
  - submelodía 68;
  - pad 67, el más plano (17 puntos);
  - bajo 58.
- **Ánimo → nivel de CC1**: calmado 25–43, triste 58, romántico 73, tenso 88.
- **Voces internas por debajo de las externas**: violas a 64 frente a violines 96 y chelos 101 (Duc
  LOTR).
- **Solista sobre lecho suave**: violín solista con CC1 110 sobre una sección a 20–56 con CC11 alto
  (Duc, Mahler).
- **Instrumentos fuertes con poco CC1**: la trompeta lleva la melodía con CC1 84 mientras las trompas
  van a 114–124 (Star Wars).
- **Dobles débiles empujados**: flautas a ~110 en el tutti (Star Wars).
- **CC11 como trim estático**: ~90 en casi todas las pistas en las maquetas de la familia CSS.
- **Percusión sin saturar**: en el clímax de Duc, caja y timbales van a velocity 66–68.

### Calibración con renders

**Montaje**:

- proyecto aparte `A:\CERBATANA\Ableton\calibracion-librerias\calibracion-librerias.rpp`, con una pista
  `CAL`, un patch cada vez y `ping` en verde tras cada carga;
- el SWAM se cargó solo y con la ventana cerrada;
- la pestaña del A/B no se tocó;
- resultados y scripts en `...\calibracion-librerias\resultados\`.

**Retardos de legato** (Albion ONE legato; la velocity de 30 a 120 da exactamente lo mismo):

| Patch | Inicio de la transición | Mitad | Hecha | 1.ª nota a −6 dB |
|---|---|---|---|---|
| Strings High (Octave) - Legato | 160 ms | **225 ms** | 595 ms | 185–225 ms |
| Woods High - Legato | 70 ms | **150 ms** | 460 ms | 90–150 ms |
| Brass Mid - Legato | 55 ms | **90 ms** | 340 ms | 105–190 ms |

**Respuesta de CC en nivel** (dB relativos al máximo):

| CC | 10 | 25 | 40 | 55 | 70 | 85 | 100 | 115 | 127 |
|---|---|---|---|---|---|---|---|---|---|
| Albion Strings Long, CC1 (CC11 = 127) | −38 | −26 | −18 | −12 | −9 | −4 | 0 | −2 | −1 |
| Albion Strings Long, CC11 (CC1 = 80) | −22 | −14 | −8 | −8 | −4 | −3 | −3 | 0 | −1 |

- La precisión es de ±1,5 dB, por el arco en las notas sostenidas.
- Strings Long llega a −6 dB unos 135–165 ms después del note-on.
- **SWAM Flute 3, CC11** (CC1 = 0): 20 → −18 dB, 35 → −10, 50 → −7, 65 → −4,4, 80 → −2,6, **95–127 ≈ 0**.
  El nivel deja de subir a partir de 95 y entre 50 y 95 sale a unos 7 puntos por dB.
- **SWAM Flute 3, portamento**: con los ajustes por defecto, la transición llega a la mitad en 50–65 ms
  con cualquier velocity de 60 a 120.
- **Albion Spiccato, velocity → pico**: 20 → −41 dB, 40 → −28, 60 → −20, 80 → −11, 120–127 → −2. El CC1
  apenas influye (≤ 3 dB).

**Lo que implica para el generador** (propuestas, sin aplicar y sin A/B):

1. Adelantar los ligados de Albion **~200 ms en cuerdas, ~130 en maderas y ~80 en trompas**, en vez de
   50 ms. Otra opción es un retardo negativo de pista por patch.
2. La tabla de velocity de ligados de Albion (112/96/78/58) **no hace nada**. Se puede quitar.
3. Los longs de Albion piden un adelanto de unos 80–120 ms, no 25.
4. En SWAM, el CC11 por encima de 95 no da nivel.
5. La velocity de ligados de R17 solo cambia el portamento si cada instancia tiene `Portamento Control =
   Velocity` con `Max Time` suficiente. Hay que comprobarlo con `fx_params` en La Forja.

**Pestañas de REAPER**: la de calibración (`calibracion-librerias.rpp`) queda guardada, sin plugins, y
**se puede cerrar**. No hay comando del bridge para cambiar de pestaña, así que la del A/B se activa al
cerrar la de calibración o haciendo clic en ella. La del A/B no se ha modificado ni guardado.

### Reo (SWAM tocado en directo): catalogado

La sesión swam-performance descargó los archivos con permiso del usuario; los detalles están en
`docs/swam-performance-research.md` §3.3. Aquí solo se catalogan:

- grupos `reo-swam-strings` y `reo-swam-flute` en `catalog.json`; el MIDI de piano queda excluido;
- informe de la comparación: `reference-midi/_reports/reo-vs-B.json`.

**Comparado con nuestra B**:

- El anticipo del CC11 (150–240 ms) confirma B.
- La subida hasta el nivel de la nota es mucho más rápida en Reo: 195–290 ms, frente a ~1 s en B.
- **El final de frase es lo contrario de las referencias de samples**: Reo lleva el CC11 casi a cero (4–17 %
  del pico), y B cae ~40 %. Es candidato para el próximo A/B de SWAM.
- Los solapes de Reo son más cortos: 17–26 ms.

**Nota**: `out/` de La Forja sigue conteniendo la versión **A**, la anterior a B, restaurada de la copia
de seguridad. La B está en `renders/ab-expresion/out-B/`. Al regenerar sin flag ahora sale B.

### A/B del timing de Albion (2026-11-02, tras el reinicio de REAPER)

**Flag**: `EXPR_ALB_T=1` en `expr.mjs`. El comportamiento por defecto sigue siendo B y `swam()` no se ha
tocado. Copia de seguridad en `backups/generator-2026-11-02-albtiming/`.

**Adelantos aplicados con el flag** (antes, 50 ms en ligadas y 25 en atacadas):

| Pista | Ligada | Atacada |
|---|---|---|
| Legato cuerda | 200 ms | 150 ms |
| Legato madera | 135 ms | 90 ms |
| Legato trompas | 80 ms | 110 ms |
| Longs | — | 100 ms (trémolo 80) |

- Criterio: ~0,9 × la mitad de la transición calibrada en las ligadas, y ~0,75 × el tiempo hasta −6 dB en
  los ataques.
- Una atacada ya no puede solaparse con la anterior. La tabla de velocity de ligados no cambia.

**Proyecto y WAV**:

- Proyecto: `La Forja del Alba - AB albion timing.rpp`, copia de `AB expresion`, guardada con la versión B
  cargada. La pestaña `AB expresion` no se ha tocado.
- WAV:
  - A: `A:\CERBATANA\Ableton\2026-11-02 La Forja del Alba\renders\ab-albion-timing\A_B-actual_c52-64.wav`
  - B: `A:\CERBATANA\Ableton\2026-11-02 La Forja del Alba\renders\ab-albion-timing\B_albion-timing_c52-64.wav`
- Hay stems en `stems/` y el MIDI de cada versión en `out-*/`.
- Sonoridad: −28,0 LUFS en las dos; B−A por medio compás, mediana +0,2 dB.

**Timing medido**: retraso de cada entrada respecto a su pulso (+ = tarde); tabla en
`knowledge/composition/performance/library-translation-table.md`.

| Pista | A: ligadas / atacadas | B: ligadas / atacadas |
|---|---|---|
| Legato cuerda | +105 / +141 ms | −55 / +1 ms |
| Legato madera | +117 / +246 ms | +26 / +26 ms |
| Legato trompas | +165 / +39 ms | +131 / −46 ms |

**Lectura**:

- La cuerda ligada pasa de llegar tarde a llegar algo antes del pulso: el adelanto de 200 ms se pasa.
  Con ~150 ms quedaría centrada.
- Las maderas quedan casi en el pulso.
- Las trompas siguen tarde en las ligadas y adelantadas en los ataques, aunque n es pequeño.
- Los acordes de los longs no se pueden medir con este método.

### Ronda 2 del timing de Albion: versión C (`EXPR_ALB_T=2`)

**Feedback del usuario sobre B**: "en B me da la sensación de estar un poco desfasadas". Coincide con la
medida: en B las ligadas de cuerda llegaban unos 55 ms antes del pulso.

**Adelantos en C** (ligada / atacada): cuerda 150 / 150 ms, madera 160 / 115 ms, trompas 210 / 65 ms. Los
longs siguen a 100 ms.

**Resultado**:

- WAV: `A:\CERBATANA\Ableton\2026-11-02 La Forja del Alba\renders\ab-albion-timing\C_albion-timing2_c52-64.wav`
- Sonoridad: −28,0 LUFS, igual que A; mediana B−A por medio compás de 0,0 dB.
- Timing medido (+ = tarde):

| Pista | A | B (ronda 1) | C |
|---|---|---|---|
| Ligadas de cuerda | +105 | −55 | **−8** |
| Atacadas de cuerda | +141 | +1 | **+11** |
| Ligadas / atacadas de madera | +117 / +246 | +26 / +26 | **+2 / +54** |
| Ligadas / atacadas de trompas | +165 / +39 | +131 / −46 | **+5 / −6** |

**Compás 64:1**:

- La percusión llega a: timbal +31 ms, platillo +42 ms, pizzicato +20 ms.
- El ligado de cuerda que entra en 64:1 llega:
  - en A, a +139 ms, unos 100 ms **después** del golpe;
  - en B, a −31 ms, unos 60–70 ms **antes**;
  - en C, a +29 ms, **junto** al golpe.
- Esto puede explicar parte de lo "raro" que el usuario oye en el compás 64 con A y con B.

**Proyecto de escucha**: `renders\ab-albion-timing\Escucha AB albion timing - ronda 2.rpp`. Tiene A, B y C
alineados en el compás 52 (120,79 s), con A sonando. Lo abre `open_project` en una pestaña nueva.

**Momentos de escucha** (segundos dentro del proyecto de escucha):

| Momento | Segundo | A | B | C |
|---|---|---|---|---|
| Entrada de cuerda en 59:1 | **137,4 s** | +141 ms | +1 | +11 |
| Ligado en 60:1, junto al pizzicato | **139,7 s** | +83 ms | −57 | −7 |
| Tutti en 64:1 y ligado en 64:2½ | **149,2 s y 150,4 s** | +139 / +100 ms | −31 / −70 | +29 / −15 |
