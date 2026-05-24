# Bucle Multiagente

Este proyecto usa un unico repositorio Git y cuatro areas de trabajo. El objetivo es iterar sin chats inconexos ni variantes perdidas, separando el proyecto estable del laboratorio de funcionalidades.

## Areas

- REAPERMANAGER: el proyecto estable ya implementado, incluyendo bridge y comandos operativos como ordenar, colorear, seleccionar, rutear, gain staging y utilidades de mezcla. Se protege como producto en uso.
- AUDIODESIGN: disena funcionalidades nuevas desde criterios de ingenieria de audio. Define objetivo sonoro, no-objetivos, defaults, riesgos y criterios de aceptacion.
- PROGRAMER: implementa lo que pide AUDIODESIGN en codigo, tests y documentacion. Pregunta o devuelve dudas a AUDIODESIGN cuando el comportamiento tecnico no esta cerrado.
- TESTER: prueba el resultado, busca fallos auditivos y tecnicos, y si algo no funciona pide a AUDIODESIGN una modificacion concreta para la siguiente iteracion.
- Orquestador: coordina las cuatro areas, integra resultados, ejecuta pruebas, hace commits/push y decide si hace falta otra vuelta.

## Tipos De Subagente

No todos los subagentes deben ser `explorer`.

- AUDIODESIGN: usar `default`. Su trabajo es criterio de audio, producto, no-objetivos, decisiones de comportamiento y preguntas al usuario si hay una duda de mezcla real.
- PROGRAMER: usar `worker` cuando haya que editar codigo. Debe tener ownership claro de archivos y no revertir cambios ajenos.
- TESTER: usar `explorer` para revision critica sin tocar archivos ni REAPER. Usar `worker` solo si debe anadir tests o fixtures.
- Orquestador: el chat principal. No delega el paso bloqueante inmediato, integra resultados, ejecuta `npm test`, commitea y sube hitos.

Si el limite de hilos esta lleno, cerrar agentes viejos antes de empezar. No reutilizar un `explorer` como implementador salvo que la tarea sea solo inspeccion.

## Reglas De Rama

- `main` conserva el baseline estable publicado.
- El trabajo activo vive en `feature/vocal-level-precomp`.
- Cada hito se commitea y se sube: spec, implementacion, fixes de revision.
- No se hace force push salvo decision explicita.
- Para abrir un chat limpio, usar `docs/new-chat-start-prompt.md`.

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

## Contrato Actual Para Vocal-Level

El ensayo del 2026-05-24 sobre `43_LeadVoxOD_UncompedTake01` invalida la direccion de "objetivo absoluto por trozos" como default musical: 48 partes, 175 puntos, promedio `+9.5 dB`, maximo `+12 dB` y 21 partes limitadas por `maxBoost` resultaron auditivamente mal. No se debe seguir refinando esa ruta como si fuera un simple problema de parametros.

AUDIODESIGN debe partir de estos objetivos:

- Es clip gain automatico precomp, no compresion ni riding interpretativo.
- Debe funcionar con un comando. No depender de avisos o decisiones manuales para el camino normal.
- Los clips llegan con gain staging hecho. Si una toma completa no esta en rango, `vocal-level` debe aplicar una fase interna equivalente a gain staging antes de nivelar.
- Si el item se divide en macrozonas principales y alguna queda baja/alta, se aplica gain staging por macrozona antes de entrar al detalle.
- No subir partes que ya estan bien. Esta fue una causa directa del fallo auditivo.
- No tratar igual macrozonas altas y bajas. Cada decision micro usa el contexto de su macrozona.
- La herramienta debe nivelar silabas/palabras caidas cuando sea audible, despues del ajuste macro.
- Respiraciones, ruido bajo y consonantes aisladas se protegen contra boost por defecto.
- Los cruces por cero y rampas son protecciones contra artefactos, no una licencia para escribir mas puntos.

Regla de dudas: si AUDIODESIGN, PROGRAMER o TESTER necesitan decidir entre dos comportamientos auditivos razonables, deben devolver preguntas explicitas al usuario antes de implementar una nueva direccion.
