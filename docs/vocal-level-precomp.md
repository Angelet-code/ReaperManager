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
- Si un item necesita mas corte que `maxCutDb` para respetar el techo de pico, se salta en lugar de escribir una automatizacion extrema.

## Modos Expertos

`relative`, `reference-percentile`, `preserve-loudness`, `steps`, `zero-crossing` y controles de deteccion siguen disponibles para pruebas y comparativas, pero no son el camino normal de V1.

## Direccion V2 Pendiente

AUDIODESIGN recomienda que la siguiente version audible deje de perseguir silabas y trabaje por frases vocales:

- Unidad principal: frase vocal dentro de item, no palabra ni item completo.
- Frase minima util: unos `350 ms`; pausas naturales de separacion: `180-350 ms`.
- Medicion robusta por zonas activas de frase, usando percentiles como `P70`, no promedio total con silencio.
- Correccion parcial hacia target: `applied = clamp((target - measured) * strength, -8, +6)`, con `strength` alrededor de `0.55`.
- No levantar respiraciones, ruido de sala, consonantes aisladas ni micro-eventos.
- Curva de clip gain humana: una base por frase, rampas suaves, preservar crescendos y finales.

Esta direccion no debe activarse sin pruebas auditivas controladas. Mientras el usuario no este presente, el loop puede anadir tests, protecciones y documentacion, pero no cambiar mas el sonido por defecto.
