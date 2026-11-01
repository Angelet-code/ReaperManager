# knowledge/ — cerebro de composición para agentes

Vault de Obsidian (abre esta carpeta `knowledge/` como vault) con el conocimiento destilado de los
libros y apuntes de `composition/` (que no se versiona). Está escrito **para agentes de IA** que
componen y orquestan en REAPER mediante el CLI de este repo; los humanos pueden navegarlo con el
grafo y los backlinks de Obsidian.

## Cómo lo usa un agente
1. Lee `composition/START-HERE.md` (router: tarea → notas, prioridad de fuentes, presupuesto de lectura).
2. Carga solo las 3–6 notas que el router indica para su tarea. Cada nota tiene `summary` y `use_when`
   en el frontmatter, así que puede descartar notas leyendo solo la cabecera.
3. Búsqueda libre: `composition/index.json` (catálogo con id, alias en español, tags, use_when,
   summary) o `grep` sobre `aliases:`. El glosario ES/EN/DE está en `composition/glossary.md`.

## Estructura
- `composition/harmony/` — armonía tonal (Hindemith I y II).
- `composition/form/` — formas musicales (Zamacois, esquema de sonata).
- `composition/orchestration/` — instrumentos, texturas, balance, doblajes (curso UNIR, apuntes).
- `composition/film-scoring/` — música para imagen (taller 4-Day Challenge, análisis de HTTYD).
- `composition/workflows/` — procedimientos paso a paso (componer un cue, armonizar, orquestar…).
- `composition/data/` — datos máquina (rangos de instrumentos en MIDI).
- `composition/sources/` — fichas de cada fuente y `digests/` (extracción fiel por páginas, solo
  para consulta profunda).
- `composition/_meta/` — convenciones y specs con que se generó el vault.

## Mantenimiento
- Regenerar índice y validar enlaces: `node scripts/build-knowledge-index.mjs`
- Añadir un libro: generar digests con `_meta/digest-spec.md`, sintetizar notas con
  `_meta/synthesis-spec.md`, actualizar `_index.md` del dominio, `START-HERE.md` y el índice.
