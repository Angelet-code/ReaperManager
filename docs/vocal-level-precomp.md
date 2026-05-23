# Vocal Level Precomp V1

## Objetivo

`vocal-level` prepara clips de voz antes del compresor escribiendo automatizacion en la envolvente de volumen de take. El objetivo es que el compresor reciba una senal vocal mas estable alrededor de `-18 dBFS = 0 VU`, sin hacer rides interpretativos ni decidir el plano final de la voz en la mezcla.

## Camino Normal

Uso recomendado:

```powershell
node .\bin\reaper-manager.js status
node .\bin\reaper-manager.js vocal-level --selected-items --preview
node .\bin\reaper-manager.js vocal-level --selected-items
```

Defaults de V1:

- `calibrationDb = -18`
- `targetVu = 0`
- `measurementMode = sustain_robust`
- `levelMode = absolute`
- `automationMode = smooth_curve`
- `peakCeilingDb = -0.3`
- `maxBoostDb = 12`
- `maxCutDb = 12`
- `minPartMs = 300`
- `partMergeGapMs = 350`
- `syllableSplitDb = 20`
- `syllableSplitHoldMs = 140`
- `gainDeadbandDb = 3`
- `minGainChangeDb = 5`
- `curveSmoothMs = 320`
- `curveToleranceDb = 2`
- `curveMinPointGapMs = 240`
- `curveDetail = 0.5`
- `curveEdgeRampMs = 80`
- `zeroCrossing = true`

El criterio por defecto es frase/energia sostenida, no silaba. El splitter se conserva como detector de energia y solo separa cambios grandes; los bordes detectados se ajustan a cruces por cero cuando la opcion esta activa.

## No Objetivos

- No sustituye compresion, de-essing, limpieza de respiraciones o edicion manual fina.
- No automatiza interpretacion, secciones, emociones o plano vocal final.
- No toca faders de pista, inserts, sends ni configuracion de plugins.
- No procesa pistas o items no seleccionados.
- No reemplaza envolventes existentes salvo con `--replace-envelope`.

## Criterios De Exito

- El compresor lee de forma mas regular sin que la voz suene aplastada o robotica.
- Las respiraciones, ruido de sala y consonantes no disparan boosts artificiales.
- Los silencios vuelven a `0 dB` de envelope y no quedan levantados.
- `--preview` no escribe envelopes, no renombra pistas y no cambia seleccion ni ganancias.
- `--preview` informa `estimated_points`, pero mantiene `points = 0` y `envelope_points_written = 0`.
- La aplicacion real respeta techo de pico, limites de boost/cut y queda deshecha con un undo.
- Si un item necesita mas corte que `maxCutDb` para respetar el techo de pico, se salta en lugar de escribir una automatizacion extrema.

## Modos Expertos

`relative`, `reference-percentile`, `preserve-loudness`, `steps`, `zero-crossing` y controles de deteccion siguen disponibles para pruebas y comparativas, pero no son el camino normal de V1.

## Criterio De Frase En V1

AUDIODESIGN adopta ya en V1 una direccion de frase para evitar artefactos y exceso de puntos:

- Unidad principal: frase vocal dentro de item, no palabra ni item completo.
- Frase minima util: unos `300 ms`; pausas naturales de separacion: hasta `350 ms`.
- Medicion robusta por zonas activas de frase, usando percentiles como `P70`, no promedio total con silencio.
- No levantar respiraciones, ruido de sala, consonantes aisladas ni micro-eventos.
- Curva de clip gain humana: una base por frase, rampas suaves, preservar crescendos y finales, y no llenar el take de puntos si una correccion amplia ya resuelve la entrada al compresor.

En el banco de prueba del 2026-05-23, el lead largo bajo de unas 293 partes/597 puntos con defaults micro a unas 51 partes/168 puntos con defaults por frase. Backings, guturales y graves quedaron entre 2 y 7 partes en preview. Estos numeros no sustituyen escucha, pero si bloquean la direccion de "micro-edicion nerviosa" como default.

## V2 Section-Aware Phrase Leveling

La idea macro -> meso -> micro queda aceptada como direccion de diseno, con una condicion importante: la macro-dinamica debe ordenar la entrada al compresor sin borrar la intencion musical. Si un estribillo esta cantado mas fuerte que un verso, esa diferencia se debe preservar parcialmente; no se igualan secciones por regla fija.

- Macro: regiones, marcadores, bloques contiguos o grupos de items separados por pausas largas. Correccion muy parcial: `strength 0.30-0.40`, `maxBoost +2 dB`, `maxCut -3 dB`, `deadband 1.5 dB`.
- Meso: frases vocales dentro de cada zona. Es la escala principal de trabajo: pausa natural `180-350 ms`, frase minima `350 ms`, medicion robusta `P70`, `strength 0.55`.
- Micro: reparacion opcional y apagada por defecto. Solo para palabras/silabas caidas claramente despues de macro y meso; no respiraciones, consonantes, ruido o expresividad natural.
- Stop temprano: si una escala ya deja la entrada al compresor estable, no se baja a una escala mas micro.
- Preview debe reportar confianza por escala: frases utiles, duracion activa, correccion media/maxima, skips y motivos.

No implementar aun sin pruebas auditivas: clasificar verso/estribillo automaticamente, activar micro-leveling por defecto, procesar items no seleccionados para entender la cancion, o aplicar reglas fijas tipo "estribillo siempre +X dB".
