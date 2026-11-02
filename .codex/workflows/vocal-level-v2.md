# Workflow: Vocal-Level V2

Este workflow coordina subagentes para cambios complejos de `vocal-level`.
El orquestador sigue siendo el chat principal.

## Entradas

Leer antes de empezar:

- `AGENTS.md`
- `docs/agent-loop.md`
- `docs/vocal-level-v2-brief.md`
- `docs/vocal-level-precomp.md`
- `.codex/agents/audiodesign.md`
- `.codex/agents/programer.md`
- `.codex/agents/tester.md`

## Reglas duras

- Responder en espanol.
- No tocar el comportamiento estable de `gain-stage` salvo peticion explicita.
- No instalar ni reparar el bridge salvo peticion explicita.
- No ejecutar comandos mutantes de REAPER hasta `node .\bin\reaper-manager.js status`.
- En REAPER, usar `vocal-level --selected-items --preview` antes de aplicar.
- `preview` debe ser estrictamente no mutante.
- No borrar envelopes existentes salvo `--replace-envelope`.
- No hacer force push.

## Secuencia recomendada

1. Orquestador: ejecutar `git status --short --branch`.
2. Orquestador: ejecutar `npm test` si el cambio toca codigo o comportamiento.
3. Cargar `.codex/agents/audiodesign.md` y lanzar AUDIODESIGN como `default`.
4. Cargar `.codex/agents/tester.md` y lanzar TESTER como `explorer`.
5. Implementar localmente o cargar `.codex/agents/programer.md` y lanzar PROGRAMER como `worker` con ownership claro.
6. Orquestador: integrar, revisar diff y ejecutar tests.
7. Lanzar TESTER como `explorer` sobre el diff final si el cambio es amplio.
8. Orquestador: solo entonces probar con REAPER, empezando por preview.

## Ownership tipico para PROGRAMER

Asignar solo los archivos necesarios. Para `vocal-level` suelen ser:

- `src/commands/items.js`
- `reaper/Reaper Manager Bridge.lua`
- `test/commands.test.js`
- `test/bridge-static.test.js`
- Docs si cambian defaults o flujo de uso.

## Direccion de producto actual

- `vocal-level` es clip gain automatico antes de compresion, no compresion.
- Debe funcionar con un comando.
- Si la toma no esta en rango, aplicar fase interna equivalente a gain staging.
- Dividir en macrozonas principales cuando ayude a corregir zonas bajas/altas.
- No subir partes que ya estan bien.
- No tratar igual macrozonas altas y bajas.
- Corregir silabas o palabras caidas cuando sea audible.
- Proteger respiraciones, ruido bajo y consonantes aisladas contra boost.
- Usar cruces por cero y rampas como proteccion contra artefactos, no como
  excusa para escribir puntos innecesarios.

## Telemetria esperada

El reporte de preview/aplicacion debe permitir revisar:

- Macrozonas.
- Partes protegidas.
- Partes corregidas.
- Puntos escritos.
- Rango de ganancia.
- Limites de boost/cut.
- Hits de `maxBoost` o `maxCut`.
- Items saltados y razon.

## Prompt base para lanzar agentes

AUDIODESIGN:

```text
Usa `.codex/agents/audiodesign.md`.
Tarea: valida la direccion de `vocal-level` V2 para este cambio concreto.
Devuelve objetivo sonoro, no-objetivos, defaults, riesgos, criterios de aceptacion
y dudas bloqueantes si existen.
```

TESTER:

```text
Usa `.codex/agents/tester.md`.
Tarea: revisa la spec/diff de `vocal-level` V2 y devuelve hallazgos ordenados
por severidad, con repros o tests sugeridos.
```

PROGRAMER:

```text
Usa `.codex/agents/programer.md`.
Tarea: implementa solo el cambio asignado.
Ownership: <lista de archivos o modulos>.
No estas solo en el codebase; no reviertas cambios ajenos.
Devuelve archivos cambiados, resumen tecnico, tests ejecutados y riesgos.
```
