# Cómo se tocan de verdad los SWAM y cómo emularlo en el MIDI generado

Investigación y propuesta, 2 de noviembre de 2026. No se ha tocado el generador, el vault ni REAPER, y no se
ha descargado MIDI salvo los tres archivos de Reo que el usuario aprobó (sección 3.3). Una excepción menor: al leer PDF, la herramienta web los guardó en su caché temporal
(`~/.claude/projects/…/tool-results/webfetch-*.pdf`). Son los manuales SWAM v2.9.2, Strings v2.1 y
String Sections v1.1, la guía del BBC2 y un artículo sobre vibrato. Solo se usaron para leerlos y se pueden
borrar.

**Leyenda.** **(V)** es un dato verificado: leído en la fuente enlazada o medido por nosotros en MIDI.
**(I)** es una inferencia o una propuesta nuestra. **(S)** sale solo del fragmento de un buscador, porque la
página estaba bloqueada.

## 0. Resumen

- **SWAM está pensado para un flujo continuo de soplo o de arco.** Se toca con controladores de viento, de
  soplo, pedal o MPE, y sin una Expression en movimiento el instrumento no suena. El manual lo resume así:
  "Constant variation of the Expression is the key of expressive playing" (V,
  [String Sections v1.1.0][ss110]).
- **El propio motor ya modela la física entre la presión y la afinación.** Audio Modeling desaconseja
  mezclar el vibrato o el pitch bend en el canal del soplo (V, [Woodwinds v3.8.0][ww380]). El plugin tiene
  además parámetros internos de aleatoriedad (*Random Dynamic*, *Dynamic Pitch*, *Random Bow*,
  *Random Finger*, *Vibrato Random*). Conclusión (I): **no hay que escribir deriva de afinación ni vibrato
  dentro de CC11**. Lo que falta en nuestro MIDI es **información en la propia curva de soplo**.
- **Diferencias medidas entre el MIDI tocado y nuestra versión B.** En el MIDI tocado de referencia (cuarteto
  REVEAL, demos de Sample Modeling):
  - la curva de expresión lleva **15–110 eventos/s** de pasos de 1 punto; la nuestra lleva **2 eventos/s**;
  - hay un **"ruido" de soplo o arco de 1–4,5 puntos RMS**; el nuestro es de 0,3–0,5;
  - **cada nota larga tiene forma propia**: el pico llega pronto (mediana al 15–47 % de la nota) y luego cae
    11–70 puntos. En B, todas las notas largas tienen la misma joroba, con el pico al 55 % y ±6 puntos;
  - **la profundidad del vibrato (CC1) se cabalga sin parar** (70–85 eventos/s, con un vaivén de 34–60
    puntos dentro de la nota).
- **El ataque de frase de B ya coincide con lo medido** (anticipo, arranque al 75 % del pico, subida
  rápida), igual que las velocities de ligado.
- **Propuesta.** Un "soplo sintético" que **se suma a B sin cambiar lo validado**. Añade tres capas:
  1. forma propia por nota larga;
  2. ruido de soplo o arco filtrado;
  3. CC1 cabalgado.

  Los valores cambian por familia. Se valida con un A/B ciego en tres pasos (sección 6).
- **Reo** es el canal de YouTube [@ReoMusicCH](https://www.youtube.com/@ReoMusicCH) (identidad comprobada).
  - Toca SWAM con un **Expressive E Osmose**: la presión controla la dinámica y el movimiento lateral, el
    vibrato por pitch bend. Luego retoca a mano.
  - **No hemos encontrado que use boquilla ni controlador de soplo.**
  - Comparte su MIDI en Drive con permiso de uso libre.
  - Se han descargado y medido tres archivos con aprobación del usuario (sección 3.3). Su cuerda en Osmose
    hace el vibrato por **pitch bend a 4,7–6,7 Hz** en casi todas las notas largas. Su flauta hace
    ***messa di voce***, con el pico tarde (0,76) y el vibrato CC1 siguiendo la misma forma.

## 1. Cómo están pensados para tocarse

### 1.1 Lo que dice Audio Modeling

Manuales leídos:
- [Solo Woodwinds v3.8.0][ww380] y [v2.9.2][ww292];
- [Solo Strings v2.1.0][str21];
- [String Sections v1.1.0][ss110], que ya usa la interfaz v3;
- [notas de versión de Solo Brass][brassrn] y la [base de conocimiento][kbnoctrl].

**Entrada de Expression**
- (V) Por defecto es **CC11**, pensada para un pedal de expresión. Un controlador de soplo suele mandar
  **CC2**.
- (V) Los presets de controlador de viento cambian la Expression a CC2 ([WW292][ww292]).
- (V) Para teclados sin pedal recomiendan Expression en CC1 y Vibrato Depth en aftertouch ([WW380][ww380],
  [KB][kbvel]).

**Mapa de CC por defecto**
- (V, v2.9.2 maderas) ([WW292][ww292]):
  - vibrato depth CC1 y vibrato rate CC19;
  - Dyn. Pitch CC8, SubHarm CC20, Growl CC21, Flutter CC23;
  - Breath Noise CC25, Key Noise CC9;
  - Overblow CC64;
  - portamento CC5 en modo controlador de viento.
- (S) En v3, Expression CC11, vibrato CC1 y CC19, CC7 volumen y CC64 sustain, según un foro
  ([KVR][kvrmap]). El manual v3.8.0 no publica una tabla numérica: el mapeo se hace con *Learn*. **Hay que
  comprobar el mapa real con `fx_params` o en la página MIDI del plugin** antes de escribir CC de growl o de
  ruido.

**Tipos de mensaje y curvas**
- (V) Mensajes: CC, **CC-HIRES** (14 bits, MSB en CC0–31 y LSB en CC32–63), aftertouch y NRPN.
- (V) Cada mapeo tiene una curva: Input Min/Max, Output Min/Max, Shape, Symmetry y Bipolar
  ([WW380][ww380], [SS110][ss110]).

**Modo de soplo**
- (V) *Breath Ctrl Mode = ON* permite **rearticular con la envolvente de soplo sin soltar la nota**.
- (V) *Breath Ctrl Attack Sens* y *Hi-Res Threshold* ajustan ese ataque.
- (V) *Wind Controller Release Mode* acorta el release, porque los controladores de viento mandan el
  note-off cuando la Expression llega al mínimo ([WW380][ww380]).

**Ataque**
- (V) *Attack Control* = Vel. Hard, Vel. Soft o **Expression** (el ataque lo da la forma de la curva).
- (V) *Attack-Expr. Bias* cambia la pendiente del ataque según la Expression en el note-on ([WW380][ww380]).

**Legato y portamento**
- (V) Las notas solapadas con velocity alta dan legato, y con velocity baja dan portamento.
- (V) *Portamento Max Time* < 0,15 desactiva el portamento.
- (V) *Transition Vel. Sens* relaciona la velocity con la duración del portamento.
- (V) *Auto Expression* o *Dynamic Transit.* da forma a la expresión dentro de la transición ligada
  ([WW380][ww380], [Str21][str21]).
- (V) El algoritmo de articulación tiene en cuenta la velocity, el intervalo, el hueco desde el último
  note-off y la "energía residual" ([WW292][ww292]).
- (V) *Staccato Interval Time* es el hueco mínimo para que la siguiente nota cuente como staccato (unos 18 ms
  para staccato rápido) ([SS110][ss110]).

**Afinación y dinámica**
- (V) "SWAM engine applies the right behavioral models to the relationships between pitch and dynamics
  based on the physics of the instrument" ([WW380][ww380], p. 13).
- (V) Por eso desaconsejan las opciones "Pb" y "bo" del EWI, que mezclan el bite en el soplo.
- (V) Parámetros internos relacionados:
  - *Random Dynamic*: modulación aleatoria de dinámica y afinación;
  - *Dynamic Pitch*: afinación que se mueve con la dinámica;
  - *Vibr. Rand. Rate*;
  - *Panpot Dyn1/Dyn2*: pequeños movimientos del intérprete.

**Cuerdas**
- *Gesture Mode* (V):
  - **Expression**: la Expression es la velocidad del arco respecto a la presión. El cambio de arco
    automático solo ocurre si la Expression se queda en 0 "un rato" y el mínimo de la curva es 0.
  - **Bipolar**: 63 = arco quieto.
  - **Bowing**: la Expression es el desplazamiento del arco.
- (V) El cambio de arco manual se hace con el keyswitch C# o con sustain ([SS110][ss110], [Str21][str21]).
- (V) Suelo de la Expression en String Sections: 0–1 para el arco, 2 suena rasposo y **3 o más da un
  pianissimo limpio** ([SS110][ss110]).
- (V) Hay aleatoriedad interna: *Random Bow* (presión, velocidad y posición), *Random Finger* (afinación),
  *Vibrato Random*, y *Interactive BowPress*, que corrige la presión para mantener una buena vibración
  ([Str21][str21]).
- (V) Recetas del manual:
  - **crescendo más ancho**: mapear Bow Pressure al mismo CC11 con Min 55 / Max 80;
  - **acercarse al ponticello con la dinámica**: Bow Position en CC11 con Min 80 / Max 40;
  - **flautando**: presión muy baja;
  - **martelé**: velocity y expresión altas, y luego dejar caer la expresión ([Str21][str21],
    [SS110][ss110]).

**Uso sin controlador**
- (V) La KB solo dice que hay que dibujar al menos una curva de Expression ([KB][kbnoctrl]).
- (V) No hay cifras oficiales de densidad ni de suavizado, ni un parámetro de *smoothing* de CC para el
  usuario.

**Presets de controlador**
- (V) Vienen dentro del plugin (MIDI > PRESETS): Roland Aerophone, Travel Sax, Robkoo, EMEO, LinnStrument
  MPE, Yamaha YDS, etc. ([brassrn]).
- (V) **No encontramos presets oficiales de Audio Modeling para Osmose** ni un paquete de Expressive E para
  SWAM ([expressivee.com/osmose](https://www.expressivee.com/osmose)).
- (V) Roger Linn dice que SWAM no es MPE de verdad. Su preset "LinnStrument MPE Default" pliega el MPE en una
  voz monofónica ([Linn][linn]).

### 1.2 Qué flujos MIDI producen los controladores

| Controlador | Mensajes | Resolución y densidad | Velocity |
|---|---|---|---|
| **Akai EWI** USB / 4000s / 5000 | Soplo en CC configurable (CC2 típico) o aftertouch. Bite → pitch bend o CC. Placas de pitch bend (V, [ewi-usb-config][ewiusb], [EWI5000 p.31][ewi5000]) | El EWI5000 puede mandar **14 bits** (2 CC) (V). No se publica la tasa. Midiendo la misma frase, el EWI4000s dio **347 puntos de soplo** frente a 199 del WX5 en un crescendo de 16 tiempos, y 472 frente a 136 eventos en un compás de vibrato (V, [Degazio][degazio1]) | Dinámica a partir del soplo, o fija (V) |
| **Roland Aerophone** AE-10 / AE-20 / AE-30 | Breath Out 1 = **CC2** por defecto (o CC, BEND o AFT). Bite Out 1 = **BEND** por defecto (V, [AE-10][ae10]) | 7 bits (no ofrece CC33–63 como LSB) (I). Tasa no publicada | Del soplo (I) |
| **TEControl BBC2** | Soplo (CC2 por defecto), bite (CC1), nod y tilt (acelerómetro). Cada sensor puede ir a CC, pitch bend o aftertouch (V, [BBC2][bbc2]) | 7 bits. **Solo transmite cuando el valor cambia** (V, [FAQ][bbc2faq]) | El keyboard da la velocity (I) |
| **Hornberg hb1** | Hasta 4 flujos de CC desde el soplo (V, [hb1][hb1]) | Resolución interna de 1 ms y "real-time data reduction" (V) | — |
| **Travel Sax 2** | Soplo en CC2, CC7 o CC11 (S) | SWAM trae el preset "Travel Sax 2 Default" (S) | — |
| **Expressive E Osmose** (MPE) | Recorrido de la tecla → velocity y **channel pressure**. Presión por debajo del fondo → **CC74**. Vibrato lateral → **pitch bend por nota**. Canal 1 global y canales 2–16 por voz (V, [Osmose config][osmose]) | No se publica la resolución. Rango de bend 48 según un foro (S) | Del recorrido de la tecla (V) |
| **ROLI Seaboard** (MPE) | Strike = velocity, Press = channel pressure, Glide = pitch bend ±48, Slide = CC74, Lift = release velocity (S, [ROLI][roli]) | — | Strike |
| **LinnStrument** (MPE) | Z = channel pressure (o poly AT en modo un canal), Y = CC74, X = pitch bend ±48 (V, [Linn][linn]) | **La presión sale cada 10 ms (100/s)** por diseño (V, [Roger Linn en KVR][linnrate]). Opción de loudness en 14 bits (V) | Strike |

Rasgos comunes que importan para emularlos:
- (V) Se manda **solo cuando hay cambio**, con pasos de un valor (Degazio: el EWI recorre "cada valor
  consecutivo" en pendientes suaves).
- (I) El techo práctico es de unos 100 mensajes/s.
- (V) El soplo empieza antes de la nota y acaba después ([Degazio][degazio2]).
- (V) Degazio propone usar como velocity **la media del soplo durante la nota**, no el valor en el ataque.
- (S) El vibrato de una flauta real va a unos 5–8 Hz, y 10–15 cents ya es un vibrato intenso.
- (V) Con el bite del EWI, Degazio llama "vibrato lento" a lo que queda por debajo de unos 2 Hz
  ([Degazio][degazio3]).

## 2. Intérpretes de referencia

### 2.1 Reo (レオ)

**Identidad: confianza alta.**
- Canal de YouTube **"Reo"**, [@ReoMusicCH](https://www.youtube.com/@ReoMusicCH): composición y DTM, música
  de fondo gratuita, unos 311 000 suscriptores.
- Enlaza a X ([@Reo5419233](https://x.com/Reo5419233)) y TikTok
  ([@reo5419233](https://www.tiktok.com/@reo5419233)). No abrimos esos perfiles.
- Lo hemos comprobado leyendo la descripción y el oEmbed del vídeo
  [壮大な冒険が始まりそうなバイオリン](https://youtu.be/_TDk__THzzc), cuyo autor es "Reo" (V).
- Equipboard enlaza uno de sus vídeos en la [ficha de SWAM Violin](https://equipboard.com/items/swam-violin)
  (V).

**Equipo.** Según la descripción del canal (V): Logic Pro, **Expressive E Osmose 49**, Roland A-49 y
A-88MKII, Nektar Impact GX Mini, Keystation Mini 32 y **Expressive E Touché SE**.
- **No encontramos ninguna boquilla ni controlador de soplo** en su equipo ni en sus descripciones.
- Puede que el usuario confunda el Touché o la palanca del Nektar con una boquilla, o que se refiera a otra
  persona (I). Si tiene un enlace concreto, conviene revisarlo.

**Cómo toca SWAM** (V, descripciones de los vídeos):
- **Osmose:** "押し込むと音が強くなり、左右に揺らすと音が動いてビブラートする" (al hundir la tecla sube la
  dinámica; al moverla de lado hace vibrato) ([vídeo](https://youtu.be/_TDk__THzzc)).
- Corrige el detalle después a mano: "細かい部分の表現は後から打ち込みで微調整"
  ([vídeo](https://youtu.be/gV2Av0y0WLI)).
- Con el Nektar usa la palanca izquierda para volumen y vibrato ([vídeo](https://youtu.be/lpYTMEQVaVI)).
- Qué lleva su MIDI:
  - en [優雅な海辺の町](https://youtu.be/UvSVJkRsrC4): Expression para el volumen, pitch bend para la
    afinación y Modulation para el vibrato;
  - en [爽やかな朝の日差し](https://youtu.be/ePYq39E22f8): **el vibrato va por pitch bend**.

  Es el mismo patrón que medimos en REVEAL (vibrato hecho con pitch bend en algunas notas).
- Dice que SWAM tocado "plano" suena a lectura monótona (棒読み).
- Sus instrumentos Audio Modeling se los cede Media Integration, el distribuidor japonés.

**Vídeos con curvas.** Los cortos
[バイオリン音源をリアルに打ち込むコツ](https://youtu.be/clF_CsGVdB4) y la serie "1分でわかる…打ち込むコツ"
probablemente enseñan las curvas en Logic (I: no los hemos visto).

**Presets o ajustes.** No publica presets. Avisa de que su MIDI de violín necesita "una configuración algo
especial de SWAM Violin" para sonar bien (V), pero no dice cuál.

### 2.2 Otros intérpretes de SWAM

- **Omri Abramov** (EWI y Aodyo Sylphyo): artista oficial de Audio Modeling
  ([perfil](https://audiomodeling.com/omri-abramov),
  [Jamming with SWAM + EWI](https://www.youtube.com/watch?v=kmhJAd8huNs)) (V).
- **Dino Soldo** (EWI): testimonio en [audiomodeling.com/artists](https://audiomodeling.com/artists) (V).
- **TEControl BBC2 con SWAM Viola:** [vídeo](https://www.youtube.com/watch?v=NQpSDph_c4k) (V). Synthtopia lo
  atribuye a Dan Radlauer (I).
- **Frans Absil, SWAM Solo Strings v3 con EWI:** [vídeo](https://www.youtube.com/watch?v=2oIMUgeg1OQ) (V).
- **ACjazzEWI, "Swam + EWI parameter settings":** [vídeo](https://www.youtube.com/watch?v=mYW4gLuPJR8) (V
  el título). Es el mejor candidato para ver los ajustes en pantalla (I).
- **Intérpretes japoneses de EWI con SWAM Sax:** [ゆずスタ!TV](https://www.youtube.com/watch?v=4tOJeYO1C2I)
  y [Sanson](https://www.youtube.com/watch?v=N-oDwbKm6xM) (V).
- **Stefano Lucato con Doctor Mix**, controlador de soplo en SWAM Sax
  ([blog](https://audiomodeling.com/blog/swam-saxophones-in-action-with-stefano-lucato-and-doctor-mix)) (S).
- **Andrew Keeping**, *Ave Maria* con controlador de soplo y la asignación de CC
  ([Synthtopia](https://www.synthtopia.com/?p=97037)) (S).
- **Hilo de VI-Control "LinnStrument + TEC + SWAM"**
  ([enlace](https://vi-control.net/community/threads/linnstrument-tec-control-swam-instruments.160178/)):
  bloqueado (403), no leído.

## 3. MIDI tocado de verdad

### 3.1 Lo que ya tenemos: el cuarteto REVEAL y las demos de Sample Modeling

Analizado con un script propio de solo lectura (`played.mjs` y `vibac.mjs` en el scratchpad de la sesión; no
está en el repo). No modifica `scripts/analyze-reference-midi.mjs`, que es de la otra sesión.

- **REVEAL: la expresión va por CC2 y es tocada (V, medido).**
  - Carriles CC2 de 35–59 eventos/s mientras suena, con un intervalo mediano de 14–16 ms y el 45–68 % de
    los pasos de 1 valor. Es la firma de un controlador continuo, no de puntos dibujados.
  - Las otras demos de Sample Modeling Strings llevan la expresión en CC11 (V, `catalog.json`). CC2 es el
    CC típico de un controlador de soplo, y los presets de viento de SWAM cambian a él (V, manuales SWAM).
    Que REVEAL se tocara **con soplo** es plausible pero no está documentado (I).
  - Un pedal o un fader motorizado darían la misma firma (I).
- **REVEAL: el pitch bend es denso** (6 100–8 200 eventos por pista) y **se toca a mano**.
  - En 2–3 de cada 6–13 notas largas hay **vibrato hecho con pitch bend a 5,3–6,3 Hz** (autocorrelación >
    0,3) (V).
  - El resto son derivas lentas y portamentos de entrada. El desvío en el note-on va del P10 al P90 entre
    −900 y +840 unidades (de 8 192), y se asienta en 50–425 ms (V).
  - El CC1 casi no se usa (mediana 0).
  - Sin el rango de bend del proyecto no se puede pasar a cents. Encaja con un MPE o con un pitch bend
    tocado (I).
- **REVEAL: CC21 y CC38.**
  - En viola y chelo, **CC21** es denso (28–47 eventos/s) y se correlaciona algo con CC2 (r = 0,36–0,43).
  - **CC38** es casi constante (mediana 64–65).
  - El mapa de CC de REVEAL no está documentado. Que CC21 sea presión o posición de arco es una conjetura
    (I).
- **SM Strings: CC1 y CC19 también se cabalgan (V).**
  - Vicentini (Tchaikovsky) escribe CC1 a 73 eventos/s y CC19 (velocidad del vibrato) con 2 513 eventos.
    Mulawa (Reger) escribe CC1 a 84 eventos/s.
  - Dentro de las notas largas, la profundidad del vibrato se mueve 34–60 puntos.
  - Correlación entre CC11 y CC19: +0,48 en Reger, −0,08 en Tchaikovsky. No hay una regla única.

### 3.2 MIDI descargable propuesto (no descargado)

**Pendiente de tu aprobación. No se ha bajado nada.** Los tamaños no aparecen en las páginas de Drive.
Serán pequeños (I), salvo los .zip, que podrían traer audio.

| # | Archivo | Origen | Qué es | Licencia o condiciones |
|---|---|---|---|---|
| R1 | `110BPM_DesertCanyon_SwamVn.mid` | [Drive de Reo](https://drive.google.com/file/d/1W6zk8i4DERx1Fe87tZFnApPdUwRs_iOs/view) ([vídeo](https://youtu.be/_TDk__THzzc)) | SWAM Violin tocado en **Osmose** y retocado a mano | "Libre para arreglar o usar como material en tus temas" (V). Es más permisivo que CSS |
| R2 | `110BPM_A_Str_v20241013a.zip` | [Drive](https://drive.google.com/file/d/1BAIteBDk2ZdBHSDylSWzlsKTQCmFHp90/view) | SWAM Violin y Cello en **Osmose** | Igual (V) |
| R3 | `116BPM_Beach_Town_Vn+Fl.zip` | [Drive](https://drive.google.com/file/d/1p04bIpbRWvMYuILFtJI5KQnEFShla9Fv/view) | SWAM Violin y Flute | Igual (V) |
| R4 | `80BPM_WJ_SWAM_Flutes_v20251117a.mid` | [Drive](https://drive.google.com/file/d/1oP-ynKPEfo8bne5hJ4sNai05uXJCh1ON/view) | SWAM Flutes tocadas **con la palanca del Nektar** | Igual (V) |
| R5 | `120BPM_LivelyBeachTown_MIDI_v20260807a.zip` | [Drive](https://drive.google.com/file/d/1ZiCZ-40lQpJVtLy1mrdD74V1YKjbRp25/view) | Flautas, violín, trompetas, saxos y trombones SWAM, pero **convertido a GM**. Puede haber perdido los datos SWAM | Igual (V). Prioridad baja |
| S1 | `Trombone_Video_Trailer.cpr` | [Sample Modeling downloads](https://www.samplemodeling.com/downloads/) → [Drive](https://drive.google.com/file/d/1nn5_M1hWYyDpt2Q_1FlPU3TLuFCHQPBF/view) | Proyecto de **Cubase**, no un MIDI. Es el mismo trailer que ya tenemos en `.mid` | No declarada. **No recomendado** |

Recomendación (I): **R1, R2 y R4**.
- Son la única fuente con instrumentos SWAM de verdad tocados con controlador.
- R1 y R2 vienen de un controlador de presión (Osmose: presión → Expression, lateral → pitch bend). R4 viene
  de una palanca.
- Ninguno es de soplo, así que medirían "gesto MPE más edición a mano", no un soplo.
- Se catalogarían en `reference-midi/catalog.json` con la misma regla de solo cifras agregadas. Ese
  catálogo es de la otra sesión: habría que coordinarlo con ella.

**No encontrado**:
- MIDI de demo oficial de Audio Modeling;
- conjuntos de datos públicos de EWI, soplo o MPE (GitHub, Zenodo);
- MIDI de saxo, clarinete, trompa o tuba en Sample Modeling.

El repositorio [swam-toolkit](https://github.com/Beennnn/swam-toolkit) (MIT) solo trae el mapa de CC por
defecto y los IDs de parámetros VST3, no MIDI tocado (V, vía [KVR][kvrmap]).

### 3.3 MIDI de Reo: descargado y medido (aprobado por el usuario el 2 de noviembre)

**Archivos.**
- Se han descargado **R1, R2 y R4**, unos 166 KB en total, en `reference-midi/_downloads/reo/`.
- En `reference-midi/extracted/reo/` hay cinco `.mid`. El zip R2 traía tres MIDI (violín, chelo y piano), y
  el piano no se usa.
- **No se ha añadido nada a `catalog.json`**, porque es de la otra sesión.
- La licencia la da Reo: libre para arreglar o usar como material. Aun así seguimos la misma regla de usar
  solo cifras agregadas.

**Qué contienen (V, medido).** Todo va en formato 0 y un canal. No hay MPE multicanal: SWAM o Logic lo
pliegan. Llevan **CC11 (Expression), pitch bend y, en la flauta, CC1**. No hay CC2 ni aftertouch.

| Pista | Controlador | CC11, eventos/s | Residuo RMS | Vaivén | Pico de la nota larga (fracción) | Subida / caída desde el pico | Velocity p10/50/90 |
|---|---|---|---|---|---|---|---|
| R1 *Desert Canyon*, violín | Osmose | 56 | 5,4 | 52 | 0,38 | 6 / 31 | **70 / 70 / 70 (fija)** |
| R2, violín | Osmose | 37 | 2,0 | 32 | 0,69 | 12 / 10 | 43 / 66 / 74 |
| R2, chelo | Osmose | 40 | 2,6 | 31 | 0,79 (7 de 16 en crescendo) | 8 / 3 | 28 / 58 / 73 |
| R4, flautas | Palanca del Nektar | 36 | 2,6 | 66 | **0,76** (17 de 23 son *messa di voce*) | 40 / 53 | 35 / 63 / 78 |

Lo que aporta frente a REVEAL y Sample Modeling (V, medido):

1. **El vibrato de la cuerda en Osmose va casi entero por pitch bend.**
   - Es periódico en **20 de 23, 4 de 4 y 16 de 16 notas largas**, a **4,7–6,7 Hz** (mediana 6,3–6,7 por
     autocorrelación).
   - Pico a pico de unas 7 400–8 300 unidades. CC1 está a 0.
   - Para que eso sea un vibrato y no un glissando de ±1 semitono, el rango de bend de SWAM tiene que estar
     muy reducido. Probablemente es la "configuración especial" que menciona Reo (I).
   - La velocidad del vibrato varía de nota a nota (P25–P75 de 4,5–5,9 Hz).
2. **En R1 la presión se acopla al vibrato.**
   - CC11 lleva un residuo alto (5,4 RMS), con oscilación a unos 6 Hz.
   - Al balancear la tecla del Osmose cambia también la presión (I). Es un artefacto del controlador, no algo
     que convenga imitar.
3. **R1 tiene la velocity fija a 70**, así que el ataque lo da la curva.
   - En R1 no hay ninguna anticipación (10 ms) y la subida al 90 % tarda 30 ms. La curva sube en el mismo
     instante del note-on.
   - Las demás pistas van de 28 a 78 y no tienen una velocity alta en las ligadas, a diferencia de nuestra B
     (88–110).
   - No sabemos cómo tenía Reo *Portamento Control* y *Max Time*. Con velocity baja y portamento por
     velocity, habría glissandos lentos. **No hay que trasladar estas velocities a B** (I).
4. **Entradas lentas en la cuerda de R2:** el anticipo es de 455–480 ms y la subida al 90 % de 460–475 ms.
   Es un arco que entra "de la nada", muy distinto del ataque rápido de B (90 ms).
5. **La flauta hace *messa di voce*.** El pico de cada nota larga llega tarde (0,76), con una subida de 40 y
   una caída de 53.
   - El vibrato CC1 **sigue esa misma forma**: su pico está a 0,71 y se mueve 102 puntos dentro de la nota.
   - El pitch bend es lento (0,5 Hz). Hay entradas por debajo de la nota, con una mediana de −716 unidades,
     que se asientan en unos 840 ms.
   - Encaja con *lip bends* (I).
6. **Empuje en las ligaduras:** la curva queda 3–6,5 puntos por encima alrededor del cambio de nota. Lo
   confirma igual que REVEAL.

## 4. Una curva tocada frente a la nuestra

Medido en notas sonando. El "residuo" es la diferencia frente a una media móvil de 300 ms (ruido de soplo
o arco). El "vaivén" es el máximo menos el mínimo dentro de una nota de 0,8 s o más, sin su ataque. Nuestra
salida es la variante B de La Forja (`renders/ab-expresion/out-B`), leída con interpolación lineal, como la
reproduce REAPER.

| Pista (CC de expresión) | Eventos/s | Intervalo mediano | Pasos de 1 | Residuo RMS | Vaivén en nota larga | Pico de la nota larga (fracción) | Caída desde el pico |
|---|---|---|---|---|---|---|---|
| REVEAL Violín I (CC2) | 59 | 15 ms | 45 % | 4,4 | 77 | 0,47 | 44 |
| REVEAL Violín II (CC2) | 35 | 16 ms | 61 % | 2,8 | 27 | 0,34 | 35 |
| REVEAL Viola (CC2) | 39 | 14 ms | 68 % | 1,0 | 20 | 0,16 | 39 |
| REVEAL Chelo (CC2) | 35 | 15 ms | 54 % | 1,8 | 23 | 0,32 | 70 |
| Roemer, trompa (CC2) | 64 | 9 ms | 88 % | 1,4 | 36 | 0,86 (crescendos) | 1 |
| Vicentini, violín (CC11) | 68 | 8 ms | 79 % | 2,1 | 33 | 0,58 | 16 |
| Mulawa, viola (CC11) | 108 | 4 ms | 99 % | 1,1 | 27 | 0,29 | 27 |
| Kamps, violines 1 (CC11) | 17 | 35 ms | 71 % | 0,7 | 21 | 0,07 | 18 |
| SM trombón, *Trailer* (CC11) | 114 | 4 ms | 93 % | 2,4 | 35 | 0,15 | 27 |
| SM trompeta I, *Oktoberfest* (CC11) | 34 | 10 ms | 96 % | 1,5 | 23 | 0,24 | 11 |
| Reo R1, violín Osmose (CC11) | 56 | 17 ms | 34 % | 5,4 | 52 | 0,38 | 31 |
| Reo R2, chelo Osmose (CC11) | 40 | 25 ms | 50 % | 2,6 | 31 | 0,79 | 3 |
| Reo R4, flauta con palanca (CC11) | 36 | 23 ms | 22 % | 2,6 | 66 | 0,76 | 53 |
| **B, VLN SOLO** | **2,2** | **344 ms** | 11 % | **0,37** | **6** | **0,55** | **6** |
| **B, VC SOLO** | 2,0 | 379 ms | 9 % | 0,34 | 6 | 0,55 | 7 |
| **B, OB SOLO** | 2,5 | 285 ms | 11 % | 0,55 | 5 | 0,55 | 5 |
| **B, CL SOLO** | 1,8 | 368 ms | 11 % | 0,47 | 5 | 0,55 | 6 |

Lo que sale de la tabla y de las demás medidas:

1. **Densidad (V).**
   - Lo tocado lleva 17–114 eventos/s y lo nuestro 2.
   - Ojo (I): REAPER interpola nuestras rampas lineales al reproducir, así que el problema no es la tasa de
     mensajes. Es que **nuestros puntos no llevan información entre ancla y ancla**.
   - Emularlo no exige más de unos 30 puntos/s. Los controladores reales mandan solo cuando hay cambio, y la
     LinnStrument limita la presión a 100/s.
2. **Microvariación (V).**
   - El residuo tocado es de 1–4,5 puntos RMS (P90 de 2–12), y nuestro residuo es de 0,3–0,5.
   - Es aperiódico. Solo una minoría de notas tiene una oscilación de 5–9 Hz en la expresión: 2 de 6 en
     REVEAL Violín I y 2 de 29 en la trompa de Roemer, con 12–15 puntos pico a pico.
   - **El vibrato no va por la expresión**: va por CC1, o por pitch bend en REVEAL.
3. **Forma de cada nota larga (V).**
   - En la **cuerda y el metal** de REVEAL y Sample Modeling, lo tocado es sobre todo "florece y cae": el
     pico llega pronto (mediana 0,15–0,47) y la caída es mayor que la subida (11–70 puntos frente a 2–22).
   - En la **flauta de Reo** domina la *messa di voce*: el pico va a 0,76, con una subida de 40 y una caída
     de 53.
   - Los violines y chelos de Reo en Osmose mezclan las dos formas (pico a 0,38–0,79).
   - La trompa de Roemer es la excepción: crece hacia el final (pico a 0,86 y 14 de 27 notas en crescendo).
   - **B pone el pico de toda nota larga en el 55 %, con +5/+9 y simétrico** (código: `e.pos + e.len * 0.55`).
     Ese patrón idéntico en todas las notas es una firma mecánica.
4. **Ataque de frase (V).**
   - Anticipo: 0–193 ms en lo tocado (mediana de pista) y 70–140 ms en B.
   - Valor en el note-on: 0,49–0,95 del pico en lo tocado (típico 0,7) y 0,76–0,80 en B.
   - Subida al 90 %: 72–420 ms en lo tocado (cuerdas REVEAL 75–240, trompa de Roemer 420) y 60–90 ms en B.
   - **B está bien encajado en anticipo y nivel de arranque, y es algo rápido subiendo** en notas largas y
     líricas.
5. **Cierre (V).**
   - En lo tocado, la cuerda REVEAL mantiene el arco casi hasta el note-off: en ese momento está a 0,93–1,0
     del valor a mitad de nota. Después del note-off quedan 14–24 puntos, porque el arco se suelta.
   - Las trompetas cierran a 0,7.
   - La "caída" de final de frase de lo tocado está **dentro de la forma de la última nota** (florece y cae),
     no es una rampa aparte.
   - B cae 22 puntos en los últimos 240–300 ms y llega al note-off a 0,5–0,62. Es compatible, pero más
     "dibujado".
6. **Ligaduras (V).**
   - En lo tocado, la curva alrededor de una ligadura queda **1–6 puntos por encima** del menor de los dos
     lados: un pequeño empuje de aire o arco al cambiar de nota.
   - En B es plana (±0,4).
7. **Vibrato (V).**
   - En lo tocado, CC1 se cabalga de forma continua (70–85 eventos/s) con una forma propia por nota, y CC19
     también se mueve.
   - En B hay 4 puntos fijos por nota (0 → 35 % → 100 % → 70 %), a 3–6 eventos/s, y no hay CC19.
8. **Afinación y presión (V/I).**
   - En lo tocado, el pitch bend lleva vibrato en algunas notas y derivas o portamentos de entrada lentos.
   - En SWAM, la relación entre afinación y dinámica la pone el motor (*Dynamic Pitch*, *Random Dynamic*,
     *Random Finger*). En nuestro caso **no conviene escribirla en MIDI** (I).

Resultado secundario: `out/` contiene la versión A (arranque al 0,48 del pico y caída de 765 ms), no la B.
La B está en `renders/ab-expresion/out-B`. Hay que tenerlo en cuenta al medir.

## 5. Propuesta: "soplo sintético" por familia

### 5.1 Principio

**B se queda como esqueleto validado.** Sus anclas siguen siendo las mismas (anticipo, arranque al 60 %,
subida, arco de frase con pico a 0,37, caída final de unos 22 puntos, velocities de ligado y timing). Encima
se suman tres capas (I), y cada una se puede apagar con su propia variable de entorno (I):

```
E(t) = B(t) + formaNota(t) + soplo(t) + gesto(t)        → clamp [suelo, 95], entero
CC1(t) = vibratoB(t) · cabalgado(t)                      (CC19 opcional)
```

**Escritura.** Un punto cada **30 ms** (unos 33/s), **solo si el valor entero cambia**, como el BBC2 o la
LinnStrument. Las anclas de B se escriben exactas. Así una frase de 10 s pasa de unos 25 puntos a 150–300,
asumible para `replace_midi` (I: medir el tamaño del JSON del bridge y el tiempo de carga).

**Semilla fija** por pista y por nota (`rr` determinista), para que el A/B sea reproducible.

### 5.2 Capas

1. **Forma de nota** (notas de 0,6 s o más, sin contar la primera nota de frase, cuyo ataque ya hace B).
   Sustituye la joroba fija de B (`0,55 → +5/+9`, `0,88 → +2`) por una forma aleatoria acotada:
   - La forma por defecto depende de la familia (ver 5.3): *messa di voce* en la madera, "florece y cae"
     en la cuerda.
   - **"Florece y cae":**
     - pico en `xp ∈ [0,15, 0,45]`;
     - subida hasta el pico de `2–8` puntos;
     - caída hasta el final de la nota de `d = 8–20` puntos, más en notas largas y en piano (relativa), menos
       en forte.
   - **"Crece"** en el 20–30 % de las notas largas: en frases ascendentes, hacia el clímax del arco de frase
     o cuando la partitura marca `<`. Pico en `[0,7, 0,9]` y `+6–12`.
   - **Plana** (±2) en notas repetidas o en pedales largos.
   - Entre notas ligadas la forma se encadena sin escalón: la nota siguiente arranca donde acabó la
     anterior más el empuje de ligado.
2. **Soplo o arco (ruido).** Ruido de banda baja de media cero:
   - la suma de **3 senos de 0,3–3 Hz** con fase y frecuencia aleatorias;
   - más **ruido blanco filtrado a unos 4 Hz**.

   Objetivo de residuo:

   | Familia | RMS (puntos) | Pico a pico (puntos) |
   |---|---|---|
   | Madera | 1,5 | 4–8 |
   | Metal | 1,5–2 | 5–10 |
   | Cuerda | 1,0–1,5 | 3–7 |

   Encima, una **deriva lenta** de 0,1–0,2 Hz y ±2 puntos, que imita el apoyo del aire o del brazo.
   - **Nunca periódico a 4–8 Hz.** El vibrato es cosa de CC1 y del motor SWAM.
   - Se atenúa a 0 en los 60 ms alrededor de cada note-on, para no ensuciar el ataque ni la ligadura.
3. **Gesto de articulación.**
   - **Ligadura ascendente:** un empuje de +2–4 puntos centrado en el cambio, en ±60 ms.
   - **Ligadura descendente:** 0–2 puntos.
   - **Rearticulación de viento** (lengua sin respirar): se mantiene el valle de B (−9), con 30–50 ms de
     bajada y 40–60 ms de vuelta.
   - **Cambio de arco:** se mantiene el valle de B (−12), sin bajar nunca de **3 + margen (8)**, porque con
     0–1 el arco se para (V). Mientras el mínimo de la curva no sea 0, no habrá cambio de arco automático (V).
4. **CC1 cabalgado** (vibrato):
   - se mantiene el retraso y la profundidad de B;
   - la profundidad de cada nota se multiplica por `U(0,8, 1,2)`;
   - **sigue la forma de la nota**: crece con el "florecer" y baja un 15–25 % en la caída final;
   - variación lenta de ±4–6 puntos a 0,5–1 Hz;
   - un punto cada 50 ms.
   - *Opcional:* CC19 (velocidad) un 5–10 % más rápido en las notas del clímax y un 5 % más lento en las
     caídas. **Antes, confirmar con `fx_params` que CC19 es Vibrato Rate en nuestros SWAM v3.**

### 5.3 Por familia

| | Madera (FL, OB, EH, CL, BSN) | Metal (HN SOLO) | Cuerda frotada (VLN, VC) |
|---|---|---|---|
| Forma de nota por defecto | ***Messa di voce*** **(pico 0,45–0,75)**, como en la flauta de Reo. "Florece y cae" (pico 0,2–0,4) en el 30–40 % de las notas y en la última antes de respirar | **Crece más a menudo** (≈50 % de las notas largas; pico 0,6–0,9, como en Roemer) | Florece y cae (pico 0,15–0,45). En el arco abajo, cae más |
| Caída `d` | 8–16. En la *messa di voce*, subida y caída de 8–20 (Reo llega a 40 / 53: empezar moderado) | 4–12 | 12–25 (REVEAL cae 35–70: empezar moderado) |
| Entrada de frase | La de B | La de B | La de B. **Variante para entradas líricas en p** (nota de 1 s o más): anticipo de 250–450 ms y subida de 250–450 ms, como en las cuerdas de Reo |
| Ruido RMS | 1,5 | 1,5–2 | 1,0–1,5 |
| Vibrato | CC1 cabalgado. El clarinete casi sin vibrato (B: 6) | Poco o nada (B: 18). Sin cabalgado fuerte | CC1 cabalgado, más denso y variable |
| Afinación | El motor (*Dynamic Pitch*). Nada en MIDI | Mantener el *scoop* de B (0,3 st, 120 ms) solo en la primera nota de frase | Nada en MIDI. Los portamentos expresivos, con la velocity de ligado de B |
| Respiración o arco | Igual que B: `STAMINA` y hueco 220–280 ms. La última nota antes de respirar usa la forma "florece y cae" con `d` alto | Igual que B | Arco de 5–5,5 s (`STAMINA`). La capa de gesto marca el cambio de arco |
| Extra opcional | — | — | **Bow Pressure mapeado a CC11 con Min 55 / Max 80** (receta del manual, sin cambiar el MIDI) como variante de timbre |

**Vibrato por pitch bend (como Reo).** Queda fuera de esta propuesta y como posible prueba aparte (I). Habría
que reducir el rango de bend de SWAM y escribir 5–6,5 Hz con velocidad y profundidad variables por nota. Se
salta el modelo de vibrato del motor, que el manual recomienda (CC1), así que solo merece la pena si el C2
con CC1 cabalgado sigue sonando "de máquina".

### 5.4 Lo que no proponemos

- **Escribir un vibrato de 5–6 Hz dentro de CC11, o pitch bend ligado al soplo.** El manual lo desaconseja
  porque el motor ya lo modela (V).
- **Subir la densidad sin añadir información** (puntos interpolados de B a 100/s). No cambia el sonido (I).
- **Copiar curvas de referencia.** La licencia de estudio solo permite cifras agregadas (ver
  `reference-midi/catalog.json`).
- **Usar ya las velocities de ligado medidas (47–75).** Siguen valiendo las de B (R17).

### 5.5 Comprobaciones antes de generar

1. **`fx_params` en un SWAM de cada familia.** Anotar el valor por defecto de *Random Dynamic*,
   *Dynamic Pitch*, *Vibr. Rand. Rate*, *Random Bow*, *Random Finger*, *Auto Expression* o
   *Dynamic Transit.* y *Attack Control*.
   - Si el motor ya mete bastante aleatoriedad, el ruido en MIDI se baja a la mitad (I).
   - Si *Attack Control* = Expression, la forma de ataque de B manda sobre la velocity.
2. **Mapa de CC real** (Expression = CC11, vibrato = CC1 y CC19).
3. **Medir la salida nueva con el mismo script** y comprobar que cae en los rangos tocados:
   - 25–60 eventos/s;
   - residuo de 1–2,5 RMS;
   - vaivén de 15–40;
   - pico de la nota larga a 0,2–0,45 (madera y cuerda);
   - CC11 ≤ 95.

### 5.6 Datos nuevos de la sesión reference-midi (medidos en REAPER)

Fuente: `docs/reference-midi-sources.md` (calibración de librerías) y
`knowledge/composition/performance/modeled-instruments-swam.md`.

- **SWAM Flute 3, nivel por CC11** (V, medido por reference-midi):
  - 20 → −18 dB, 35 → −10, 50 → −7, 65 → −4,4, 80 → −2,6, **95–127 ≈ 0**;
  - entre 50 y 95 salen unos **7 puntos por dB**, y por encima de 95 el nivel no sube.

  Consecuencias para el diseño:
  - el techo de 95 de la capa coincide con la física del plugin;
  - un ruido de 1,5 puntos RMS son unos **0,2 dB** en mf, pero hasta ~0,5 dB en pp, donde cada punto pesa
    más. Por eso el borrador lo reduce al 60 % por debajo de CC 35.
- **SWAM Flute 3, portamento con los ajustes de fábrica** (V, medido): la transición llega a la mitad en
  50–65 ms con **cualquier velocity de 60 a 120**.
  - Si las instancias de La Forja están así, la velocity de ligado de R17 **no hace nada** en esa flauta
    (I).
  - Hay que comprobarlo instancia por instancia (5.8).
- **Final de frase de Reo** (V, medido por reference-midi): la última nota se apaga hasta el **4–17 % del
  pico** (cae el 78–93 %). B se queda en torno al 60 % (cae unos 22 puntos).
  - Queda como **variante candidata `end: "reo"`**, no como regla. Contradice las referencias con samples,
    y quizá sea un rasgo de SWAM: el note-off corta más que el release de un sample (I).
- **Subida y solapes de Reo:**
  - la subida al nivel de la nota tarda 195–290 ms;
  - los solapes son de 17–26 ms, frente a 36–39 ms en B.

  No entran en esta capa, que deja intactos el timing y las notas de B. Si gana C2, se pueden probar como un
  A/B propio.

### 5.7 Borrador en código (fuera del generador)

Está en el scratchpad de esta sesión y hay una copia en la carpeta de notas compartidas
(`side-session-notes/…/soplo-draft/`). **No se ha tocado `expr.mjs`.**

- `soplo.mjs`: la capa.
  - Recibe lo que `swam()` ya calculó: notas, puntos CC11 y CC1 de B, y frases. Devuelve los CC11 y CC1
    nuevos.
  - Parámetros por familia en `FAM` (madera, metal, cuerda).
  - RNG determinista por pista (mulberry32 sobre el nombre), para que el A/B se pueda repetir.
  - Opciones: `end: "B" | "reo"`, capas `shape`, `noise` y `ride` apagables por separado, y `amount`, que
    escala la forma de nota.
- `apply-soplo.mjs`: banco de pruebas. Aplica la capa a una salida ya generada (`out-B/cmd/*.json`) y
  escribe otra carpeta. Así se ha medido sin REAPER.

**Integración prevista en `expr.mjs`** (cuando lo autorice la sesión principal):
1. Dentro de `swam()`, con `SOPLO=1`, no escribir los dos puntos de joroba de B. Son las líneas
   `e.pos + e.len * 0.55` y `0.88` del bloque `if (dur >= 0.7)`. La capa pone su propia forma.
2. Al final de `swam()`, separar los CC11 y CC1 de esa pista, llamar a
   `soplo(name, prof, notes, cc11, cc1, phrases, { secs, ms2qn })` y volver a meter el resultado en `d.cc`.
   - `secs` y `ms2qn` son los de `core.mjs`.
   - Las frases salen de `phrasesOf(evs)`, mapeando cada evento a `e.notes[0]`.
   - Los pitch bend del *scoop* de la trompa no se tocan.
3. Variables de entorno:
   - `SOPLO=1` activa la capa;
   - `SOPLO_END=reo`;
   - `SOPLO_CAPAS=shape,noise,ride`;
   - `SOPLO_AMOUNT=1`.

   Sin `SOPLO`, la salida es B, bit a bit.

**Medido sobre la salida B** (`renders/ab-expresion/out-B`), con el mismo script de la sección 4:

| Variante | Eventos/s CC11 | Residuo RMS | Vaivén | Pico de la nota larga | Final de frase (fracción) | CC11 máx. |
|---|---|---|---|---|---|---|
| B (control) | 1,8–2,5 | 0,34–0,55 | 5–7 | 0,55 (fijo) | 0,50–0,62 | ≤ 95 |
| **C1** (solo forma) | 11–13 | 0,4–0,8 | 8–12 | cuerda 0,26–0,27 · madera 0,31–0,51 | 0,44–0,48 | ≤ 95 |
| **C2** (forma, soplo, gesto y CC1) | 22–28 | **1,2–1,7** | 12–17 | cuerda 0,28–0,30 · madera 0,35–0,68 | 0,41–0,56 | **95** |
| C2 ×1,5 (`amount`) | 22–28 | 1,3–1,8 | 14–21 | igual | igual | 95 |
| **C2-reo** (final de Reo) | 21–28 | 1,3–2,0 | 12–15 | igual | **0,09–0,18** | 95 |
| Referencia tocada | 17–114 | 1–4,5 | 20–77 | 0,15–0,47 (cuerda) · 0,76 (flauta de Reo) | 0,04–0,17 (Reo) · 0,7–1,0 (samples) | — |

Comprobaciones superadas en C2 y C2-reo:
- el CC11 nunca pasa de 95;
- no hay rebote de CC1 a 0 en las ligaduras (regla R2);
- el CC11 no baja de 8 dentro de una ligadura (en C2-reo, solo en la cola de la última nota, como se
  pretende);
- el CC1 de C2 se mueve 29–32 puntos dentro de la nota a 15–17 eventos/s, con el pico a 0,63–0,73.

Pendiente o débil:
- **El empuje de ligadura apenas se ve en la medida** (de −3 a 0 puntos, frente a −2/−6,5 en lo tocado).
  Queda tapado por el ataque de la nota siguiente que ya escribe B.
- El vaivén queda en la mitad baja de lo tocado, a propósito. `amount` 1,5 lo sube.
- Tamaño: el comando de VLN SOLO pasa de **22 KB a ~150 KB**, y el de OB SOLO a ~100 KB. Hay que vigilar
  el tiempo de `replace_midi` en el bridge (I).

### 5.8 Comprobación previa con `fx_params` (planeada, sin ejecutar)

`{"type":"fx_params","track":"<pista>","fx":0}` **sin `params` es de solo lectura** y devuelve
`describe_params` (`reaper/rm_beat_builder.lua`, `command_fx_params`). Se ejecutaría una vez por pista
SWAM de La Forja:
- FL SOLO, OB SOLO, EH SOLO, CL SOLO, BSN SOLO, HN SOLO, VLN SOLO y VC SOLO;
- en la pestaña del A/B, **cuando la sesión principal libere REAPER**.

Se anotan en una tabla:
1. **Portamento:** *Portamento Control* (Velocity/CC), *Portamento Max Time* (< 0,15 = desactivado),
   *Transition Vel. Sens*, *Legato Mode* (Expr/Gliss) y *Note Off Velocity*. Responde si la velocity de
   R17 actúa en cada instancia.
2. **Ataque:** *Attack Control* (Vel. Hard / Vel. Soft / Expression) y *Attack-Expr. Bias*.
3. **Aleatoriedad interna:**
   - madera y metal: *Random Dynamic*, *Dynamic Pitch* y *Vibr. Rand. Rate*;
   - cuerda: *Random Bow*, *Random Finger* y *Vibrato Random*.

   Si ya están altos, el `rms` de la capa se baja a la mitad antes del A/B.
4. **Transiciones:** *Auto Expression* o *Dynamic Transit.* (profundidad de la forma de expresión en el
   ligado).
5. **Mapa:** que Expression sea CC11, Vibrato Depth CC1 y Vibrato Rate CC19. Además, el *Transpose* y el
   *Pitch Bend Up/Down*, como ya pide R13.

No se cambia ningún parámetro en esta pasada. Si conviene cambiar alguno (por ejemplo, *Portamento Control
= Velocity* en la flauta), se propone aparte, porque altera el sonido validado de B.

### 5.9 Encaje con las respiraciones compartidas y el vibrato continuo (2 de noviembre, tarde)

La sesión de revisión del c.64 está cambiando `expr.mjs` (`revision-c64.md`, puntos 2 y 6):
- **respiraciones alineadas:** las líneas que doblan cortan juntas, con un id de frase común;
- **vibrato continuo:** en las notas ligadas el vibrato no se reinicia, solo tras una respiración o un ataque.

La capa se monta **encima** de esa versión, y estas son las reglas del diseño final:

1. **La capa no decide dónde se respira.** Solo lee las marcas que deja `plan()`: `breath`, `afterBreath` y
   `slur`. Por eso `soplo()` tiene que recibir las notas de `swam()` con esas marcas, después de `plan()` y
   de los ajustes de duración.
2. **La respiración y el cambio de arco cortan el tramo.**
   - La nota con `breath` se apaga ("bloom", salvo en el metal), igual que la última de la frase.
   - No lleva empuje de ligadura, porque ya no está ligada.
   - El CC1 se cabalga por tramos, de una respiración a la siguiente.
   - En la cuerda, el cambio de arco sin hueco (*gap* 0) es un corte de tramo pero **no un final de frase**,
     así que el final "reo" solo se aplica a un final de frase real (hueco ≥ 0,12 negras).
3. **Las líneas dobladas frasean igual.**
   - Si la nota trae un id de grupo (`n.group`, que saldría del `o.id` de `line()` que propone la revisión),
     el tipo de forma y la posición del pico se sortean con una semilla de grupo y de posición. Así dos SWAM
     que doblan hacen el mismo gesto en la misma nota.
   - La amplitud, el soplo y el CC1 siguen siendo de cada intérprete, con una semilla por pista. Dos
     instrumentistas reales no respiran el mismo ruido.
   - Sin `group`, todo se comporta como antes.
4. **El vibrato sale continuo.**
   - El CC1 ya no se rehace por nota. Se multiplica la curva de base de `swam()`, y por eso los reinicios
     solo están donde los pone la base.
   - El vaivén es lento: 0,15–0,3 Hz y ±20 % por la familia.
   - El acoplamiento a la forma de nota se suaviza (τ 80 ms), para que no salte en el cambio de nota.
   - El factor total está acotado a ±20 %, y el ±5 lento se escala con el nivel de la base, así que vale 0
     donde la base vale 0.

**Medido** con `cc1cont.mjs`. Para cada nota ligada mide la caída de CC1 entre justo antes del note-on y el
mínimo de las 0,25 negras siguientes, sobre la salida vigente `out-armonia-c64-v3`.

| Base | Capa | Caídas > 15 en ligados: VLN / VC / OB / EH | Caída media: VLN / VC |
|---|---|---|---|
| v3 actual (reinicia por nota) | no | 42 / 43 / 44 / 18 | 43 / 44 |
| v3 actual | sí | 42 / 38 / 38 / 12 | 27 / 26 |
| Continua (simulada con `CONT=1`: ≥ 70 % en el ligado) | no | 0 / 0 / 0 / 0 | 3,4 / 3,3 |
| Continua (simulada) | **sí** | **2 / 1 / 0 / 0** | 5,3 / 4,7 |

- Con la base continua, la capa **no crea reinicios**. Las 3 caídas que pasan de 15 son el vaivén de ±20 %
  sobre un CC1 de ~80, es decir, 16–18 puntos repartidos en más de 1 s.
- El CC11 mide como en 5.7. Por ejemplo, VLN SOLO sobre v3:
  - eventos: 22 por segundo;
  - residuo: 1,25;
  - vaivén: 14;
  - pico de la nota larga: 0,32;
  - caída en la ligadura: 0.
- **La simulación `CONT=1` es solo del banco.** La base real será la que deje la revisión. Cuando esté, se
  repite la medida sin `CONT`.

### 5.10 Integrado en el generador (v4 → `out-v5-swam`, 2 de noviembre, sin render)

- **Copia de seguridad del generador:** `backups/generator-pre-soplo-1718/`.
- **Código:**
  - `generator/soplo.mjs`: la capa;
  - `expr.mjs`: se importa la capa, se leen `SOPLO`, `SOPLO_END`, `SOPLO_CAPAS` y `SOPLO_AMOUNT`, y la
    capa se llama al final de `swam()`.
- **Comando:** `SOPLO=1 FORJA_OUT=../out-v5-swam node main.mjs`. Da 0 errores y los mismos 2 avisos que v4.
- **Aislamiento comprobado:**
  - sin `SOPLO`, la salida es **idéntica fichero a fichero** a `out-v4`;
  - con `SOPLO=1` solo cambian los 8 `*_SOLO.json` y `midi.json`;
  - en ellos, notas, velocidades, timing, pitch bend y el resto de CC son idénticos: solo cambian CC11 y CC1;
  - la capa usa su propio RNG y no consume `rr()`.
- **El techo de la capa es 127 en el generador**, para no cambiar el nivel respecto a v4, que ya pasa de 95 en
  OB, VLN y VC. Se hereda de B y no lo arregla esta capa.
- **Se iguala el nivel.** La forma propia sustituye a la joroba fija de B y bajaba el CC11 medio 0,7–4,9
  puntos. Ahora se compensa con un offset por pista, y queda a ±0,5 puntos del de v4 mientras suenan las notas.
- **Vibrato:** 0 caídas de CC1 de más de 15 en ligados, salvo 2 en VC (el vaivén de ±20 %).
- **Curva CC11:**
  - eventos: 25–27 por segundo, frente a ~2;
  - residuo: 1,2–2,0;
  - vaivén: 13–16;
  - pico de la nota larga: cuerda 0,28 y madera ~0,5.
- **Tamaño:** VLN y VC pasan de 16–17 KB a 153–158 KB, y OB de 15 KB a 107 KB.

## 6. Validación A/B propuesta (sin ejecutar)

- **Pasajes.**
  - El mismo de R17 (c. 52–64, VLN SOLO sobre STR LEGATO).
  - Un pasaje de madera expuesta (OB SOLO o FL SOLO).
  - Si hay, uno de HN SOLO.
- **Antes:** la comprobación con `fx_params` de 5.8.
- **Variantes**, todas sobre B y generadas con `SOPLO` (o con `apply-soplo.mjs` sobre `out-B`):
  - **B**: control.
  - **C1**: B + forma de nota.
  - **C2**: C1 + soplo + gesto + CC1 cabalgado.
  - **C2-reo**: C2 con el final de frase de Reo (4–17 % del pico). Se prueba **después** de decidir B frente
    a C2, como un cambio aislado.
  - **C3** (solo cuerda, opcional): C2 + Bow Pressure mapeado a CC11.
- **Procedimiento.**
  - Render con `render_audio` (stems del solista y mezcla).
  - **Igualar la sonoridad** a ±0,2 LU; B y C deberían quedar a menos de 0,5 dB, pero se iguala igual.
  - Nombres aleatorios (X, Y) para escuchar a ciegas. Primero **B frente a C2**, la diferencia grande. Si
    gana C2, **C1 frente a C2**, para saber qué capa aporta. Por último, **el ganador frente a su versión
    `-reo`**.
- **Qué escuchar.**
  - ¿"Respira" o suena a curva dibujada?
  - ¿Hay mareo o temblor (ruido excesivo)?
  - ¿Las notas largas "florecen" o se caen demasiado?
  - ¿Hay zipper o escalones audibles?
  - ¿Cambia la ligadura?
- **Medida** (sin oído):
  - el script de la sección 4 sobre C2, para ver si cae en los rangos tocados;
  - el nivel por medio compás, para no confundir "más expresivo" con "más alto".
- **Registro.** Solo lo que el usuario elija de oído pasa a `user-taste.md` (como R18) y a la memoria, igual
  que R17.

## 7. Colocación en el espacio: Ambiente de SWAM o pan de REAPER (para la mezcla, sin aplicar)

Pregunta del usuario: *"SWAM también permite ubicación espacial de los instrumentos, pero no sé si es mejor
eso o el panorama normal de reaper."*

### 7.1 Qué parámetros hay

Desde la v3.8.0, los SWAM solistas usan **Ambiente**: no es una reverb, sino un simulador de sala que coloca
cada fuente en un espacio 3D y calcula las reflexiones por geometría ([ww380], p. 17 y cap. "Room &
Position"; [ss110], "Room & Position").

- **Todas las instancias comparten la sala.** Se comunican por red local, y desde cualquiera se cambia la sala
  y la posición de todas ([ww380]; [kbroom]; [kbamb]).
- Hay hasta 4 salas: 3 configurables y una de **"Close Mic"**, pensada para usar un espacializador o una reverb
  externos.

Nombres reales de los parámetros, sacados de las respuestas `fx_params` guardadas en
`.reaper-manager/state/responses` (lectura de las 03:03 y las 11:45 del 2 de noviembre):

| Parámetro | Ámbito | Qué hace | Valor hoy en La Forja |
|---|---|---|---|
| **Source Distance** | por instancia | Distancia de la fuente en metros. Es lineal: `m = 1,2 + 13,8·v` (I: ajustado con 8 lecturas; 0,13 → 3 m, 1 → 15 m) | VLN 7 · VC 7,5 · FL y OB 10 · EH y CL 10,5 · BSN 11 · HN 13 |
| **Source Angle** | por instancia | Ángulo de la fuente: 0,5 = 90° = centro. Probablemente va de 0 a 180° (I). **No está comprobado qué extremo es la izquierda** | **90 (centro) en las 8** |
| **Room Sizes** | sala (global) | MEDIUM 1–3 y LARGE 1–3 | LARGE 3 |
| **Absorption Materials** | sala (global) | Set 1 HIGH, Set 2 MEDIUM, Set 3 LOW. Con el tamaño da el tipo de sala, "de estudio absorbente a iglesia reflectante" ([ss110]) | Set 2: MEDIUM |
| **Listener Position** | sala (global) | Es la *Mic Position* del manual: "distancia del par estéreo virtual a la posición del director" ([ss110]) | 0,25 |
| **Mics Spread** | sala (global) | Separación del par estéreo. Es el único "montaje de micros" que se expone: no hay patrón polar ni árbol | 17 cm |
| **Source Delay Mode** | sala | Tiempo de vuelo: No Delay, Real Delay o Nearest | No Delay |
| **Reverb Modulation** | sala | Cola más "sedosa", con más CPU | ON |
| Early Reflection Gain, Reverb Mix, Reverb Time | **solo Legacy** | El manual los lista en "Effects: visible only when Legacy Reverb is ON" ([ww380]) | 0,5 · 28,8 % (HN 32 %) · 0,64 |
| Pan Pot | **solo Legacy** | "Available only if Legacy Reverb mode…" ([ww380]) | C |
| Legacy Reverb | por instancia | Si está en OFF, Ambiente está activo | OFF |

Lo que **no existe** en los solistas:
- **anchura** (*width*) por instrumento: solo hay posición y distancia, y la anchura sale de la sala y de
  *Mics Spread*;
- control de **primeras reflexiones** con Ambiente activo.

La "mezcla de ~29 %" que se cree activa es *Reverb Mix*, un parámetro de Legacy. Con Ambiente en marcha
**probablemente no hace nada** (I). Se comprueba con un render de 2 compases a 0 % y a 29 % y una resta de
nulo.

### 7.2 Dónde suena hoy cada cosa (medido en los stems ya renderizados)

`band.py` mide la diferencia de nivel R−L por bandas y la correlación L/R, solo en las ventanas activas. Se
ha pasado sobre `renders/ab-albion-timing/stems` (Albion) y `renders/v7/st_*` (SWAM). La medida incluye el
pan de REAPER, y con la ley constante de −3 dB un pan de ±0,25 da unos ±3,5 dB.

| Stem | Pan REAPER | R−L medido | R−L que da solo el pan | Lo que pone la librería | Correlación |
|---|---|---|---|---|---|
| STR LEGATO (Albion) | −0,25 | −3,4 | ≈ −3,5 | ≈ 0 | 0,39 |
| STR LONG | −0,05 | −0,2 | ≈ −0,7 | ≈ +0,5 | 0,17 |
| LO STR LONG | +0,25 | +3,2 | ≈ +3,5 | ≈ −0,3 | 0,36–0,58 |
| WW LEGATO | −0,1 | −0,6 | ≈ −1,4 | ≈ +0,8 | 0,24 |
| HN LEGATO | −0,3 | −2,9 | ≈ −4,3 | ≈ +1 | 0,58 |
| STR PIZZ | +0,1 | +2,5 | ≈ +1,4 | ≈ +1 | 0,14–0,54 |
| TIMP | −0,1 | −1,7 | ≈ −1,4 | ≈ 0 | 0,64–0,73 |
| VLN SOLO (SWAM, ángulo 90) | −0,2 | −2,8 | ≈ −2,8 | 0 | **0,84** |
| VC SOLO | +0,15 | +2,2 | ≈ +2,1 | 0 | **0,86** |
| OB SOLO / EH SOLO | −0,05 / +0,05 | −0,5 / +0,4 | ≈ ∓0,7 | 0 | 0,70 |

- **Los patches de Albion ONE salen casi centrados y anchos.** Correlación de 0,17 a 0,58; la posición que
  ponen por sí mismos no pasa de ±1 dB (I: la cuenta del pan es aproximada).
  - Albion ONE es de secciones mezcladas, grabado en Lyndhurst Hall (AIR) con micros close, tree,
    outriggers y ambient ([sosalb]; [kvralb]).
  - No he encontrado documentado su plano de asientos. El que publica Spitfire es del Spitfire Symphony
    Orchestra, otra grabación ([sfsso]).
  - **En esta mezcla, la colocación la dan los pan de REAPER de las pistas Albion**: violines a la
    izquierda, graves y trompetas a la derecha, trompas a la izquierda.
- **Los SWAM están todos en el centro de Ambiente.** El lado lo pone solo el pan de REAPER, y son fuentes
  estrechas (correlación de 0,70 a 0,86).
- El retardo L/R (GCC-PHAT) da 0 en todos, así que con esta medida no se ve el tiempo horneado.

### 7.3 Recomendación

**Colocar los SWAM con Ambiente (*Source Angle* + *Source Distance*) y dejar el pan de REAPER centrado en esas
8 pistas.** Motivos:
- El pan de REAPER en estéreo solo cambia niveles. Ambiente mueve la fuente: llegada, nivel y, sobre todo,
  reflexiones del lado correcto. Es lo que hace creíble una fuente lateral en sala, y Audio Modeling
  recomienda el modo interno precisamente por eso ([ss110], *Spatializer*: "applying ONLY a reverb is not
  enough").
- Hacer las dos cosas a la vez (ángulo + pan) suma dos paneos y estrecha o descoloca la imagen.

**Matices:**
- En las pistas **Albion** el pan de REAPER se queda como está. Es la única herramienta allí y ya define los
  asientos.
- **Source Delay Mode se queda en No Delay.** Con Real Delay la trompa a 13 m llegaría unos 38 ms tarde
  frente a Albion, cuyo timing está validado.
- **Plan B** si la sala de SWAM no casa con el hall de Albion: mover los 8 a la sala *Close Mic* y usar pan
  de REAPER más un envío a `REV PANORAMIC`.
- La sala se queda en LARGE 3 / Set 2. No se toca *Mics Spread* hasta oír el resultado, porque es global y
  cambia los 8 a la vez.

**Valores propuestos.** Asientos de orquesta "americana", coherentes con los pan actuales de Albion. Ángulo
negativo = izquierda, contado desde el centro (90°).

| Pista | Asiento | Distancia: hoy → propuesta | Ángulo desde el centro | R−L objetivo (el del pan actual de su sección) | Pan REAPER |
|---|---|---|---|---|---|
| VLN SOLO | concertino, 1.er atril de violines I | 7 → **6,5 m** | **−25°** | ≈ −3 dB, como STR LEGATO | −0,20 → **0** |
| VC SOLO | solista de chelos, delante a la derecha | 7,5 → **7 m** | **+20°** | ≈ +2,5 dB, como LO STR | +0,15 → **0** |
| FL SOLO | 1.ª fila de maderas, izquierda del centro | 10 m | **−8°** | ≈ −1 dB | −0,15 → **0** |
| OB SOLO | 1.ª fila, derecha del centro | 10 m | **+6°** | ≈ +0,5 dB | −0,05 → **0** |
| EH SOLO | 1.ª fila, junto a los oboes, más a la derecha | 10,5 m | **+14°** | ≈ +1 dB | +0,05 → **0** |
| CL SOLO | 2.ª fila, detrás de las flautas (izquierda) | 10,5 → **11 m** | **−7°** | ≈ −0,5 dB | +0,12 → **0** |
| BSN SOLO | 2.ª fila, detrás de los oboes (derecha) | 11 m | **+8°** | ≈ +1 dB | +0,18 → **0** |
| HN SOLO | trompas, detrás a la izquierda, con HN LEGATO | 13 → **12,5 m** | **−25°** | ≈ −3 dB, como HN LEGATO | −0,30 → **0** |

- **El clarinete cambia de lado.** Hoy está a +0,12 (derecha), pero en el asiento clásico va detrás de las
  flautas, a la izquierda. Si el usuario prefiere la imagen actual, ángulo +7°.
- **Las distancias apenas cambian.** El fondo ya está ordenado (solistas de cuerda delante, maderas,
  trompa), y acercar un poco los dos solistas de cuerda les da presencia sin subir el fader.
- **Los ángulos son de partida.** No se sabe cuántos dB de R−L da cada grado con un par de 17 cm a 6–13 m.

**Cómo aplicarlo, en la fase de mezcla y con permiso:**
1. **Calibrar.** Mover VLN SOLO a 60°, 75°, 105° y 120° (uno por render de 2 compases), medir con
   `band.py` y apuntar el R−L de cada uno. Así se sabe **qué extremo es la izquierda** y cuántos dB da cada
   grado, y se ajustan los ángulos de la tabla para clavar el R−L objetivo.
2. Escribir *Source Angle* y *Source Distance* en las 8 pistas y poner su pan de REAPER a 0. Ambiente
   comparte sala, pero la posición es de cada instancia.
3. Comprobar *Reverb Mix* con la resta de nulo de 7.1.
4. A/B a ciegas, igualado en sonoridad: **pan de REAPER (hoy)** frente a **Ambiente**, en el pasaje de
   c.52–64 y en uno de maderas. Medir correlación y R−L por stem para confirmar que la imagen quedó donde se
   quería.
5. Si el usuario elige Ambiente, se anota en `user-taste` y en la memoria.

## 8. Fuentes

[kbroom]: https://kb.audiomodeling.com/support/solutions/articles/206000050970-how-to-position-instruments-in-ambiente-using-the-room-view
[kbamb]: https://kb.audiomodeling.com/support/solutions/articles/206000041743-getting-started-with-ambiente-an-overview
[kbtech]: https://kb.audiomodeling.com/en/ambiente/advanced-positioning-with-the-tech-view
[sosalb]: https://www.soundonsound.com/reviews/spitfire-audio-albion
[kvralb]: https://www.kvraudio.com/product/albion-one-by-spitfire-audio
[sfsso]: https://support.spitfireaudio.com/en/articles/11815972-recording-spitfire-symphony-orchestra-a-placement-diagram

[ww380]: https://static.audiomodeling.com/manuals/woodwinds/SWAM%20Solo%20Woodwinds%20v3.8.0%20-%20User%20Manual.pdf
[ww292]: https://static.audiomodeling.com/manuals/woodwinds/SWAM%20Solo%20Woodwinds%20v2.9.2%20-%20User%20Manual.pdf
[str21]: https://images.equipboard.com/uploads/item/manual/109721/audio-modeling-swam-solo-strings-bundle-manual.pdf
[ss110]: https://static.audiomodeling.com/manuals/stringsections/SWAM%20String%20Sections%20v1.1.0%20-%20User%20Manual.pdf
[brassrn]: https://kb.audiomodeling.com/support/solutions/articles/206000050991-swam-solo-brass-release-notes
[kbnoctrl]: https://kb.audiomodeling.com/support/solutions/articles/206000050919-can-i-use-swam-instruments-without-a-physical-midi-controller-
[kbvel]: https://kb.audiomodeling.com/support/solutions/articles/206000050973-is-it-possible-to-control-swam-instruments-using-only-note-on-velocity-
[kvrmap]: https://www.kvraudio.com/forum/viewtopic.php?p=9266283
[linn]: https://rogerlinndesign.com/support/support-linnstrument-recommended-sounds
[linnrate]: https://www.kvraudio.com/forum/viewtopic.php?p=9263253
[ewiusb]: https://pypi.org/project/ewi-usb-config-cli/
[ewi5000]: https://www.manualslib.com/manual/1958832/Akai-Ewi5000.html?page=31
[ae10]: https://mcgrp.ru/files/viewer/1007986/10
[bbc2]: https://tecontrol.se/products/usb-midi-breath-bite-controller-2
[bbc2faq]: https://tecontrol.se/products/usb-midi-breath-bite-controller-2/faq
[hb1]: https://www.ilio.com/products/hornberg-research/hb1
[osmose]: https://expressivee.happyfox.com/kb/article/254-config-menu
[roli]: https://support.roli.com/support/solutions/articles/36000019142
[degazio1]: https://www-acad.sheridanc.on.ca/~degazio/AboutMeFolder/MusicPages/EWI-WX5.html
[degazio2]: https://econtact.ca/10_3/degazio_windperformance.html
[degazio3]: https://www-acad.sheridanc.on.ca/~degazio/AboutMeFolder/MusicPages/EWI%20Vibrato.html

**Manuales SWAM**
- Solo Woodwinds v3.8.0: [PDF][ww380]. Leído en local desde la caché de la herramienta web de la sesión
  anterior.
- Solo Woodwinds v2.9.2: [PDF][ww292].
- Solo Strings v2.1.0: [PDF][str21].
- String Sections v1.1.0: [PDF][ss110].
- Base de conocimiento: [notas de Solo Brass][brassrn], [uso sin controlador][kbnoctrl], [solo
  velocity][kbvel].

**Controladores**
- EWI: [ewi-usb-config][ewiusb], [EWI5000][ewi5000].
- Aerophone: [AE-10][ae10].
- TEControl: [BBC2][bbc2], [FAQ][bbc2faq].
- Hornberg: [hb1][hb1].
- Osmose: [Config][osmose].
- ROLI: [Seaboard][roli].
- LinnStrument: [recomendaciones][linn], [tasa de 10 ms][linnrate].
- Degazio: [EWI frente a WX5][degazio1], [interpretación con viento][degazio2], [vibrato][degazio3].

**MIDI medido:** `reference-midi/catalog.json`, grupos `sm-reveal`, `sm-brass` y `sm-strings` (solo cifras
agregadas).

**Ambiente y Albion (sección 7)**
- Ambiente: [Room View][kbroom], [visión general][kbamb], [Tech View][kbtech].
  - El ángulo y la distancia no están definidos en la base de conocimiento. Los nombres y valores salen de
    `fx_params`.
- Albion ONE:
  - [reseña de Albion en Sound On Sound][sosalb], sobre los micros ambient en la galería (es la del Albion
    original de 2011);
  - [ficha en KVR][kvralb], con los cuatro micros (close, tree, outriggers y ambient).
- [Plano de colocación del Spitfire Symphony Orchestra][sfsso]: otra grabación, no es el de Albion ONE.
- Stems medidos: `La Forja del Alba/renders/ab-albion-timing/stems` y `renders/v7/st_*`. Pan de REAPER
  leído de `La Forja del Alba.rpp` (PANMODE 5, PANLAW 1,414).
