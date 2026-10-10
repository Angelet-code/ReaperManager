# New Chat Start Prompt

Use this prompt to start a clean Codex chat from `A:\PROYECTOS\OPENCODE\Reaper Manager`.

```text
Trabaja en `A:\PROYECTOS\OPENCODE\Reaper Manager`.

Objetivo: continuar la implementacion limpia de `vocal-level` V2 para ReaperManager. Lee primero:

- `AGENTS.md`
- `docs/agent-loop.md`
- `docs/vocal-level-v2-brief.md`
- `docs/vocal-level-precomp.md`

Reglas duras:

- Responde en espanol.
- No toques el comportamiento estable de `gain-stage`; el usuario dijo que estaba perfecto.
- No instales ni repares el bridge salvo peticion explicita.
- No ejecutes comandos mutantes de REAPER hasta tener una razon clara y despues de `node .\bin\reaper-manager.js status`.
- Para pruebas con REAPER, usar primero `--preview`; aplicar solo sobre items seleccionados/de prueba, y usar undo si hace falta.
- `preview` debe ser estrictamente no mutante.
- No borrar envelopes existentes salvo `--replace-envelope`.
- No hagas force push.

Modelo de agentes:

- Orquestador: este chat principal. Coordina, integra, ejecuta tests, commitea y sube.
- AUDIODESIGN: subagente `default`. Define criterio de audio y decisiones de producto.
- PROGRAMER: subagente `worker`. Implementa codigo con ownership claro.
- TESTER: subagente `explorer` para revision critica sin editar; `worker` solo si debe anadir tests.

Antes de crear agentes nuevos, revisa si hay hilos viejos abiertos y cierralos si estorban. No uses todos como `explorer`: PROGRAMER debe ser `worker` cuando vaya a editar codigo.

Estado de producto confirmado por el usuario:

- `vocal-level` es clip gain automatico antes de compresion, no compresion.
- Debe funcionar con un comando; no sirve un flujo de warnings donde el usuario tenga que decidir.
- Los clips llegan con gain staging ya hecho. Si no, `vocal-level` debe aplicar una fase interna equivalente a gain staging antes de nivelar.
- Si la toma se divide en 5 o 6 macrozonas principales y alguna queda baja/alta, aplicar gain staging por macrozona antes de nivelar detalle.
- Fallos de la version anterior: voz demasiado alta, no nivela silabas, sube partes que ya estan bien, trata igual macrozonas altas y bajas.
- Respiraciones protegidas contra boost por defecto, aunque es prioridad secundaria frente a corregir macro/micro.

Primer paso:

1. Ejecuta `git status --short --branch`.
2. Ejecuta `npm test` para verificar baseline.
3. Lanza AUDIODESIGN (`default`) para validar la spec V2 y cerrar dudas bloqueantes.
4. Lanza TESTER (`explorer`) para convertir la spec en criterios de rechazo medibles.
5. Haz localmente el mapa de implementacion o lanza PROGRAMER (`worker`) con ownership claro:
   - `src/commands/items.js`
   - `reaper/Reaper Manager Bridge.lua`
   - `test/commands.test.js`
   - `test/bridge-static.test.js`
   - docs si cambian defaults

Direccion tecnica:

- Mantener `absolute` y `relative` como modos legacy/experto.
- Crear `macro_micro` como camino normal V2.
- En `vocal-level`, reutilizar medicion/deteccion actual como input, pero dejar de usar `target_take_db = -18 - sustain_db` como decision final por cada trozo.
- Anadir una fase interna de macro gain-stage por item/macrozonas.
- Despues aplicar nivelacion local relativa para frases, palabras o silabas caidas.
- Proteger partes ya correctas: movimiento maximo aproximado `1 dB`.
- Corregir silabas/palabras caidas por defecto, con limites bajos.
- Escribir take-volume envelope pre-FX, con rampas/cruces por cero y sin puntos innecesarios.
- El reporte debe incluir telemetry para TESTER: macrozonas, partes protegidas, partes corregidas, puntos, limites de boost/cut, maxBoost hits, preview/applied.

No termines en plan. Implementa, prueba con `npm test`, commit y push en `feature/vocal-level-precomp`. Si una decision auditiva bloquea de verdad, pregunta de forma concreta.
```
