# Reaper Manager Subagents

Estos perfiles son contratos repo-locales para lanzar subagentes de Codex sin
reinventar instrucciones en cada chat. La fuente comun sigue siendo
`AGENTS.md`; estos archivos solo especializan el rol.

Uso recomendado desde el chat orquestador:

1. Lee `AGENTS.md` y el workflow de `.codex/workflows/` que aplique.
2. Lanza el subagente con el `agent_type` indicado en el frontmatter.
3. Pasa como prompt inicial el archivo del rol y una tarea concreta.
4. Mantiene en el orquestador los pasos bloqueantes: integracion, `npm test`,
   comandos mutantes de REAPER, commits y push.

Perfiles:

- `audiodesign.md`: criterio de audio, producto y defaults.
- `programer.md`: implementacion con ownership claro de archivos.
- `tester.md`: revision critica, criterios de rechazo y repros.

Regla importante: no usar subagentes para compensar una tarea ambigua. Si el
objetivo de mezcla o producto no esta cerrado, el orquestador debe preguntar al
usuario o pedir primero una decision concreta a AUDIODESIGN.
