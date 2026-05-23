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
- La aplicacion real respeta techo de pico, limites de boost/cut y queda deshecha con un undo.

## Modos Expertos

`relative`, `reference-percentile`, `preserve-loudness`, `steps`, `zero-crossing` y controles de deteccion siguen disponibles para pruebas y comparativas, pero no son el camino normal de V1.
