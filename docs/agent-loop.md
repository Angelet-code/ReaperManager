# Bucle Multiagente

Este proyecto usa un unico repositorio Git y tres roles de trabajo. El objetivo es iterar sin chats inconexos ni variantes perdidas.

## Roles

- Arquitecto/spec: mantiene el contrato musical y tecnico. Decide defaults, no-objetivos y criterios de aceptacion.
- Implementador Codex: modifica codigo, tests y documentacion dentro de una rama de trabajo.
- Revisor critico: revisa el diff y busca fallos sonoros, defaults peligrosos, mutaciones en preview, problemas de envelope y huecos de test.
- Orquestador: integra resultados, ejecuta pruebas, hace commits/push y decide si hace falta otra vuelta.

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
- No se procesan items fuera de `--selected-items`.
- Items MIDI, silenciosos o sin take se saltan con razon clara.
- El resumen informa partes, puntos, rango de ganancia, limitaciones por pico/boost/cut y ejemplos.
- El resultado auditivo prepara el compresor; no intenta mezclar la interpretacion.
