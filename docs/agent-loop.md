# Bucle Multiagente

Este proyecto usa un unico repositorio Git y cuatro areas de trabajo. El objetivo es iterar sin chats inconexos ni variantes perdidas, separando el proyecto estable del laboratorio de funcionalidades.

## Areas

- REAPERMANAGER: el proyecto estable ya implementado, incluyendo bridge y comandos operativos como ordenar, colorear, seleccionar, rutear, gain staging y utilidades de mezcla. Se protege como producto en uso.
- AUDIODESIGN: disena funcionalidades nuevas desde criterios de ingenieria de audio. Define objetivo sonoro, no-objetivos, defaults, riesgos y criterios de aceptacion.
- PROGRAMER: implementa lo que pide AUDIODESIGN en codigo, tests y documentacion. Pregunta o devuelve dudas a AUDIODESIGN cuando el comportamiento tecnico no esta cerrado.
- TESTER: prueba el resultado, busca fallos auditivos y tecnicos, y si algo no funciona pide a AUDIODESIGN una modificacion concreta para la siguiente iteracion.
- Orquestador: coordina las cuatro areas, integra resultados, ejecuta pruebas, hace commits/push y decide si hace falta otra vuelta.

## Reglas De Rama

- `main` conserva el baseline estable publicado.
- El trabajo activo vive en `feature/vocal-level-precomp`.
- Cada hito se commitea y se sube: spec, implementacion, fixes de revision.
- No se hace force push salvo decision explicita.

## Reglas De Seguridad

- Antes de tocar REAPER se ejecuta `node .\bin\reaper-manager.js status`.
- No se ejecutan acciones destructivas en el proyecto activo salvo peticion explicita.
- Para `vocal-level`, el camino normal es `--preview` primero y aplicacion despues sobre items seleccionados.
- Los reintentos sobre envelopes existentes requieren `--replace-envelope`.

## Checklist De Revision

- `npm test` pasa.
- `preview` es realmente no mutante.
- REAPERMANAGER no pierde comportamiento estable mientras se experimenta con funcionalidades nuevas.
- No se procesan items fuera de `--selected-items`.
- Items MIDI, silenciosos o sin take se saltan con razon clara.
- El resumen informa partes, puntos, rango de ganancia, limitaciones por pico/boost/cut y ejemplos.
- El resultado auditivo prepara el compresor; no intenta mezclar la interpretacion.
- Para nivelacion vocal, TESTER debe tratar como fallo cualquier default que multiplique puntos sin necesidad, levante respiraciones o ignore cruces por cero cuando estos estan activos.
