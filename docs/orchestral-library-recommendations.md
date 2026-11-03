# Librerías orquestales: qué comprar y qué sobra

Informe del 2 de noviembre de 2026. Es solo investigación: no se ha comprado, descargado ni borrado nada, y no se ha tocado REAPER.

Los precios son aproximados, en USD de lista, y salen de las páginas oficiales o de tiendas consultadas en la web. Cambian con las ofertas, así que comprueba en la tienda antes de comprar. Cinematic Studio anuncia un **25 % de descuento del 24 de noviembre al 3 de diciembre**: es buen momento para comprar.

## Resumen

Ya tienes muchas herramientas. Los **solistas modelados** (la colección SWAM casi completa) y la **percusión** (Symphony Series, Darwin y HZ) están cubiertos de sobra. Para los **pianos** tienes The Giant, Noire y Ultimate Stage Pianos, y para las **salas**, Altiverb 7 y SWAM Ambiente.

Lo que limita el sonido son tres huecos:

1. **Cuerda de sección con legato por sección.** Albion ONE es un conjunto con octavas dobladas, sin violines I y II, violas, chelos y contrabajos por separado. Sus ataques son lentos y el CC11 llega pronto al techo.
2. **Metales de sección** con legato real y cortos limpios. Albion solo tiene conjuntos (Brass Low, Mid y High, Trumpets XL).
3. **Coro real y arpa.** No hay ninguno instalado: Mysteria, Rise and Hit y Kwaya son texturas y efectos.

### Top 5 por impacto y precio

| # | Qué | Por qué | Precio aprox. | Formato |
|---|---|---|---|---|
| 0 | **Gratis primero:** Spitfire Symphony Orchestra Discover, y probar las secciones SWAM sobre Albion | Arpa gratis, 3 legatos, y comprobar si las secciones SWAM (que ya tienes) tapan parte del hueco de cuerda | 0 | Plugin de Spitfire |
| 1 | **Cinematic Studio Strings (CSS)** | Legato por sección, divisi real, cortos ajustados. Es el mayor salto de realismo por dólar | ~$299 (−25 % en Black Friday) | Kontakt Player |
| 2 | **Cinematic Studio Brass (CSB)** | Trompas, trompetas y trombones con legato, cortos, rips y flatterzunge. Completa a SWAM, que hace los solos | ~$279 como añadido tras CSS | Kontakt Player |
| 3 | **Un coro de verdad:** Strezov Wotan + Freyja (épico) o Spitfire Eric Whitacre Choir (lírico) | No hay coro instalado | Wotan o Freyja ~$327 de lista, ~$196 en oferta. Whitacre ~$150 | Kontakt / plugin de Spitfire |
| 4 | **Arpa:** CineHarps, solo si el arpa de SSO Discover se queda corta | No hay arpa instalada | ~$279 de lista, ~$167 en oferta | Kontakt Player |

Opcional, después: **Cinematic Studio Woodwinds** (~$279 como añadido), solo para maderas a2 y en tutti. Las maderas expuestas ya las hace mejor SWAM.

---

## 1. Inventario

Fuentes: `reaper-vstplugins64.ini`, el registro de Native Instruments (rutas de contenido), las carpetas de `A:\SONIDO\SAMPLES KONTAKT` y `D:\MÚSICA\SAMPLES KONTAKT`, los patches de `FXChains\Reaper Manager` y la memoria del proyecto.

| Familia | Lo que hay | Notas |
|---|---|---|
| Orquesta "todo en uno" | **Spitfire Albion ONE** (Kontakt): Strings, Brass Low/Mid/High, Woods High/Low, Darwin, XXL Perc, Hyper Toms, Easter Island, Brunel Loops y patches "(Legacy)" | Registrado en `A:\…\Spitfire Albion ONE library` (59 GB). **Hay una segunda copia en `D:\…\Spitfire Audio - Albion ONE` (50 GB)** |
| Cuerda solista | **SWAM Violin 3, Viola 3, Cello 3, Double Bass 3**; Stradivari Violin (Kontakt); Spitfire LLP Solo Strings (Kontakt, antigua) | SWAM ya está calibrado en el flujo |
| Cuerda de sección | Albion ONE Strings (conjunto con octavas); **SWAM Violin, Viola, Cello y Double Bass Section** (modeladas) | Las secciones SWAM no se han usado aún en los temas |
| Maderas | Albion Woods High/Low (conjuntos); **SWAM Flute, Alto Flute, Bass Flute, Piccolo, Oboe, English Horn, Clarinet, Bass Clarinet, Bassoon, Contrabassoon y 4 saxos** | Las maderas solistas están completas |
| Metales | Albion Brass Low/Mid/High y Trumpets XL (conjuntos); **SWAM French Horn F y Bb, Trumpet, Trumpet C, Piccolo Trumpet, Flugelhorn (2), trombones alto, tenor, tenor-bajo, bajo y contrabajo, Euphonium, Bass Tuba, Tuba Eb** | Los metales solistas están completos |
| Percusión | **Symphony Series Percussion** (timbales, platos, tam-tam, cajas, bombos y láminas: celesta, glockenspiel, xilófono, marimba, vibráfono, crótalos, campanas tubulares), Darwin, HZ01, HZ02, Session Percussionist | Muy bien cubierta |
| Coro | Mysteria (texturas aleatóricas), Rise and Hit (voces de efecto), Kwaya (voces africanas), Arturia Augmented VOICES | **No hay coro de sustains ni de sílabas** |
| Arpa | — | **No hay ninguna** (solo el clave de Rinascimento) |
| Pianos y teclas | The Giant, Noire, Ultimate Stage Pianos, Arturia Piano V3 y Augmented Grand, Waves Grand Rhapsody | Cubierto |
| Color y mundo | Fluffy Rinascimento, Koto 17, East Asia, Kithara, Arkhis, Straylight, Lumina, Erosia, Nightshade | Sirve para color, no para el núcleo orquestal |
| Salas y reverb | **Altiverb 7**, SWAM Ambiente, Waves H-Reverb, RVerb, Abbey Road Chambers y Plates, Eventide Blackhole, UADx Pure Plate | No hace falta comprar reverb |
| Sampler | Kontakt 8 (completo) | Admite librerías de Kontakt Player y de Kontakt completo |

Patches capturados: 16 de Albion ONE y 2 de Symphony Series (lista en `AGENTS.md`).

## 2. Diagnóstico: dónde nos quedamos cortos

**Cuerda de sección (es el hueco principal).**
- Albion ONE graba "Strings" como un conjunto, y los patches *High (Octave)* y *Low XL 8ves* doblan a la octava. No se puede escribir una línea interior de violas o de violines II con su propio legato, ni hacer divisi.
- Los ataques de las notas largas son lentos. Ya compensamos adelantando 0,04–0,05 de tiempo, y de 0,06 a 0,1 en el legato.
- El CC11 está cerca del techo a 110–112, así que subirlo da como mucho 1 dB. El balance acaba dependiendo del CC1, que cambia también el timbre.
- Resultado: los tutti suenan "Albion" (épico, grande, de sala), pero los pasajes líricos o íntimos suenan genéricos.

**Metales de sección.** Albion tiene trompas en legato (Brass Mid), pero las trompetas y los graves son conjuntos sin solos sampleados ni técnicas como rips, flatterzunge o sordina. SWAM cubre los solistas, pero nos dio dos problemas: un solo de trompa encima de las trompas de Albion quedaba 16 dB por encima, y los SWAM salen entre 10 y 15 dB más fuertes y secos. Falta una sección de metales homogénea, desde a2 hasta a4, con legato real.

**Maderas.** Expuestas, SWAM es lo mejor del mercado para MIDI generado: la expresión continua es justo lo que escribimos. El hueco es pequeño: maderas a2 y en tutti, y cortos de conjunto más definidos que los de Albion Woods.

**Cortos.** Los cortos de cuerda de Albion (Spiccato, Staccato Combo) son de conjunto y con octavas. Para ostinatos rápidos y de registro preciso hace falta una librería por sección.

**Coro y arpa.** No hay. Son los dos colores que más se echan en falta en el estilo de aventura o épico de "La Forja del Alba" y el cue en Re.

**Percusión, láminas, pianos y salas:** no hace falta comprar nada.

## 3. Compatibilidad con el flujo sin interfaz (`capture_patch` / `load_patch`)

He comprobado el código: `capture_patch` (`reaper/rm_beat_builder.lua`) copia el bloque de estado del plugin desde el chunk de la pista. **Funciona con cualquier VST3**, sea Kontakt, el plugin de Spitfire, SINE o Synchron Player. Lo que cambia de un formato a otro:

- **Kontakt Player (CSS, CSB, CSW, CineHarps, Strezov):** funciona igual que hoy con Albion. Es lo más seguro.
- **Plugin de Spitfire (SSO, BBC SO, Whitacre, Abbey Road One):** un preset por instancia y estado pequeño. Carga las muestras en segundo plano, así que conviene un `ping` y una espera antes de reproducir.
- **SINE (Orchestral Tools) y Synchron Player (VSL):** también funcionan, pero el estado es grande y la carga asíncrona más larga. Además, SINE descarga las articulaciones por separado.

Lo que importa para programar por MIDI es que **el retardo del legato sea predecible**, más que que sea bajo. Como generamos el MIDI, podemos adelantar cada nota exactamente lo que haga falta, siempre que la librería se comporte igual cada vez.

## 4. Recomendaciones en detalle

### 0. Gratis antes de gastar
- **Spitfire Symphony Orchestra Discover** (gratis desde noviembre de 2025): 44 instrumentos, 3 legatos, solistas, **arpa** y piano. Usa el plugin de Spitfire con la misma convención que Albion: CC1 dinámica, CC11 expresión, CC21 vibrato y UACC por CC32. Sirve para tener un arpa ya y para comprobar si el plugin de Spitfire se comporta bien con `capture_patch`.
- **Secciones SWAM (ya instaladas):** probar Violin Section y Cello Section como capa *por debajo* de Albion Strings en una frase lírica. Así se ve si dan la línea interior independiente que falta. Antes, renderizar y medir como de costumbre.

### 1. Cinematic Studio Strings (Kontakt Player, ~$299)
- **Qué aporta frente a Albion:** cinco secciones separadas (violines I y II, violas, chelos y contrabajos) con legato real arriba y abajo, portamento y re-arco en la misma nota, y divisi. Los cortos son de sección y ajustados. En comparaciones de usuarios suele aparecer como de los mejores legatos del mercado.
- **MIDI:** CC1 dinámica y CC11 expresión, con keyswitches reasignables. Según el fabricante, cada nota nueva del legato se retrasa **hasta ~250 ms**. La velocity elige la velocidad de la transición, así que el retardo depende de la velocity y se puede compensar con exactitud. Convendría añadir una tabla de adelantos por velocity al generador, como ya hacemos con Albion. Antes de escribir partes, comprobar en el manual los CC de vibrato y de cambio de articulación.
- **Precio:** ~$299. Con cualquier librería de la serie, el resto sale un 30 % más barato. La última versión es la 1.7, de 2022: es estable y no se espera que cambie.
- **Encaje:** Kontakt Player, así que `capture_patch` funciona igual que con Albion.

### 2. Cinematic Studio Brass (Kontakt Player, ~$279 como añadido)
- **Qué aporta:** secciones de trompas, trompetas, trombones y tuba con legato de pp a fff. Cortos (repeticiones, staccatissimo, staccato, sforzando), sordina larga y corta, flatterzunge, trinos, doble picado, marcato y rips.
- **Por qué segundo:** cubre el hueco de sección que SWAM no debe cubrir, porque SWAM queda mejor como solista. Evita poner un solo de trompa encima de una sección de otra librería.
- **MIDI:** el mismo motor que CSS. El retardo del legato es de hasta ~¼ s y se compensa igual.

### 3. Coro (elegir uno según el estilo)
- **Strezov Wotan (masculino) + Freyja (femenino)**, Kontakt: el coro épico con sílabas y legato. Freyja tiene "agile legato". Cada uno cuesta ~$327 de lista y ~$196 en oferta. Para épica o aventura y folk metal sinfónico.
- **Spitfire Eric Whitacre Choir** (~$150, plugin de Spitfire): vocales sostenidas muy realistas, poco útil si se necesita texto. Para lo lírico o sacro y para pads de coro.
- La opción más barata y épica es **Audio Imperia Chorus** (~$50). Es menos detallado, pero vale para probar.

### 4. Arpa: solo si SSO Discover no basta
- **CineHarps** (Cinesamples, Kontakt Player, grabado en MGM): ~$279 de lista, ~$167 en oferta.
- Alternativas: Soundiron Elysium Harp (~$149) y ProjectSAM Concert Harp (~€125).

### Opcional: Cinematic Studio Woodwinds (~$279 como añadido)
Solo si las maderas a2 y en tutti de Albion se quedan cortas. Para cualquier madera expuesta, SWAM sigue siendo la referencia.

### Alternativas que he valorado y no recomiendo ahora

| Librería | Por qué no, por ahora |
|---|---|
| **VSL Synchron Prime** (~€399–579, Synchron Player) | Es la alternativa seria a CS*: una orquesta completa con legato por sección, muy consistente y sala seca del Synchron Stage. Pero cuesta lo mismo que CSS+CSB y su player es más pesado. Elegirla solo si se quiere una sola compra de orquesta completa |
| **BBC SO Core** (~$449) / **Pro** (~£899, ~630 GB) | Muy buenas y con la misma convención que Albion, pero otra orquesta completa de Spitfire solapa con Albion en carácter. El legato es más lento y menos predecible que el de CS*. Pro ocupa mucho disco. El usuario no tiene acceso a ella |

**Revisión del 2 de noviembre: Spitfire Symphony Orchestra (SSO, ~£499 / $629, ~345 GB) es una opción válida** si se quiere una sola compra. Reúne Symphonic Strings, Brass y Woodwinds, más percusión, arpa (Skaila Kanga), piano y Masse. El script de legato se rehízo en 2024. Trae las secciones separadas que le faltan a Albion y está grabada en la misma sala que Albion (AIR Lyndhurst), así que empastan bien. En contra: su legato es más lento que el de CS*, y su carácter de sala grande sirve peor para lo íntimo. Con el plugin de Spitfire y la misma convención de CC que Albion, su perfil se calibra casi igual.
| **Abbey Road One Foundations** (~$449) | Otro conjunto orquestal "en bloque", como Albion: redundante |
| **Spitfire Symphonic Motions** (~$249) | Cuerda de re-arco y "motion grid": es de nicho y poco determinista para MIDI generado |
| **Orchestral Tools Berlin Strings** (SINE, ~€840) / **Metropolis Ark** | Caro. En la comparación de legatos de vi-control, Berlin Strings desplaza el timing según la velocidad de interpretación. Metropolis Ark son conjuntos épicos que solapan con Albion |
| **Cinesamples CineBrass PRO** (~$429), **CineWinds** | Buena opción, pero más cara que CSB y con un hueco parecido |
| **Musical Sampling** Adventure o Trailer Strings y Brass (~$249 cada una) | Muy de estilo aventura, pero requieren Kontakt completo (lo tienes) y escriben en conjunto. Encajan peor con nuestra escritura por partes |
| **Performance Samples** (Con Moto, Caspian, Fluid Shorts) | Retiradas o en liquidación. Mejor no basar el flujo en ellas |
| **Sample Modeling**, **Infinite Brass/Woodwinds**, más **Audio Modeling** | **Redundante con SWAM**: es la misma idea de modelado, y SWAM ya está instalado y calibrado |
| **Audio Imperia**, **8Dio** (épico o híbrido) | Solapan con Albion, Rise and Hit y HZ. No cubren ningún hueco |
| Más percusión o láminas | Symphony Series + Darwin + HZ ya lo cubren |
| Reverb nueva | Altiverb 7 (con IR de estudios de grabación de bandas sonoras, si están instalados) y SWAM Ambiente bastan. RVerb es lo más flojo de lo que hay para orquesta |

## 5. Qué sobra o aporta poco

1. **La copia de Albion ONE en `D:\MÚSICA\SAMPLES KONTAKT\Spitfire Audio - Albion ONE` (50 GB).** Native Access y Kontakt tienen registrada la de `A:\SONIDO\…` (59 GB), que es la que usan los patches. Antes de borrarla a mano, comprueba que ningún proyecto apunta a D:. Yo no la he tocado.
2. **Los patches "(Legacy)" de Albion ONE.** Son la versión 1 de los mismos instrumentos. Usar siempre los de la v2.
3. **Los SWAM duplicados por papel.** No ocupan disco, pero complican las plantillas. Para orquesta basta con:
   - French Horn F (no Bb);
   - Trumpet C (no Trumpet en Sib ni los dos Flugelhorn);
   - Tenor Trombone y Bass Trombone (el Tenor-Bass, el Alto y el Double Bass Trombone son casos especiales);
   - Bass Tuba (la Tuba Eb es más de banda de metales);
   - los saxos, que no son orquestales.
4. **Arturia Augmented STRINGS/VOICES:** son híbridos de sintetizador. No aportan realismo orquestal.
5. **Mysteria, Rise and Hit, Arkhis y Straylight:** no sobran para tráiler o híbrido, pero no son núcleo orquestal. No cuentan como "coro".

HZ01 y Spitfire LLP Solo Strings se quedan en uso: el usuario quiere poder utilizarlos.

## 6. Plan sugerido

1. **Ahora (gratis):** instalar Spitfire Symphony Orchestra Discover y capturar su arpa con `capture_patch`. Probar las secciones SWAM bajo Albion en una frase de "La Forja del Alba" y medir.
2. **Black Friday (24 de noviembre – 3 de diciembre):** comprar CSS y luego CSB, con el 25 % más el 30 % del añadido.
3. Capturar los patches de CSS y CSB, uno por articulación o grupo de keyswitch. Medir el retardo del legato por tramo de velocity con un render, y añadirlo como tabla de adelantos en el generador.
4. **Después:** un coro según el próximo proyecto (Strezov si es épico, Whitacre si es lírico) y CineHarps solo si el arpa gratuita se queda corta.

## Fuentes

- Cinematic Studio Series: [Strings](https://cinematicstudioseries.com/strings/), [Brass](https://cinematicstudioseries.com/brass/), [Woodwinds](https://cinematicstudioseries.com/woodwinds/), [Solo Strings](https://cinematicstudioseries.com/solo-strings/), [descuentos de fidelidad](https://cinematicseries.zendesk.com/hc/en-us/articles/360011454754-Do-you-have-upgrade-cross-grade-or-loyalty-discounts)
- [Comparación de legatos de cuerda, 15 librerías (vi-control)](https://vi-control.net/community/threads/strings-legato-comparison-15-libraries-put-to-the-test.168003/)
- [Spitfire Symphony Orchestra Discover](https://www.spitfireaudio.com/products/spitfire-symphony-orchestra-discover) · [anuncio en Rekkerd](https://rekkerd.org/spitfire-audio-releases-sso-discover-free-orchestral-instrument-library/)
- [Albion ONE v2.0 (KVR)](https://www.kvraudio.com/news/spitfire-releases-albion-one-v2-0---new-content-and-fixes-61429) · [Spitfire Originals, julio de 2026](https://sonicstate.com/news/2026/07/10/four-new-spitfire-audio-originals-libraries/)
- [BBC SO Core, precio](https://www.long-mcquade.com/429659/Software/Virtual-Instruments-Downloads/Spitfire-Audio/BBC-Symphony-Orchestra-Core-Download.htm) · [Symphonic Motions](https://www.spitfireaudio.com/products/spitfire-symphonic-motions) · [Abbey Road One](https://rekkerd.org/?p=164385)
- [VSL Synchron Prime (Rekkerd)](https://rekkerd.org/vienna-symphonic-library-launches-synchron-prime-sections)
- [Orchestral Tools Berlin en SINE](https://www.orchestraltools.com/berlin-orchestra-guide)
- [CineBrass PRO (NI)](https://www.native-instruments.com/en/pricing/cinebrass-pro/) · [CineHarps (NI)](https://www.native-instruments.com/products/cineharps)
- [Musical Sampling en Pluginfox](https://pluginfox.com/products/musical-sampling-trailer-bundle) · [Performance Samples, venta de liquidación](https://vi-control.net/community/threads/performance-samples-discontinuation-sale-con-moto-caspian-fluid-shorts.108606/)
- [Sample Modeling vs Infinite Brass (vi-control)](https://vi-control.net/community/threads/sample-modeling-brass-vs-infinite-brass.133649/)
- [Strezov Freyja, precio (NI)](https://www.native-instruments.com/de/pricing/freyja-female-choir/) · [Reseña de Wotan, Freyja y Arva (Sound On Sound)](https://www.soundonsound.com/reviews/strezov-sampling-wotan-freyja-arva-choirs) · [Coros 2026 (MuseHub)](https://www-cf.musehub.com/learn/best-choir-vst)
