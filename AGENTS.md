# Reaper Manager Agent Instructions

## Fast Path For New Chats

If the user asks for a REAPER action, do not start with broad repo exploration. Do this:

1. Run `node .\bin\reaper-manager.js status`.
2. If `heartbeat.bridge` is `running` and the request is clear, execute the matching CLI command immediately.
3. If the bridge is stopped or missing, ask the user to press the `Reaper Manager` toolbar button in REAPER. Do not reinstall unless the user asks for install/repair or the installed bridge is clearly outdated.
4. For simple requests, use one primitive command. For compound requests, use several primitive commands so REAPER undo stays granular.
5. Only inspect source files when adding/changing capabilities, debugging a failure, or when no existing command can satisfy the request. Only inspect `.reaper-manager\queue` after a timeout or suspected stale command.
6. Work on the active REAPER project/tab reported by `status`; do not try to switch tabs unless the user explicitly asks.
7. Reply in Spanish, concise and operational. Summarize what changed and how many tracks/items/sends were affected.

Common direct mappings:

```powershell
node .\bin\reaper-manager.js color --contains orden --color "#d8b4fe"
node .\bin\reaper-manager.js volume --selected --db -3
node .\bin\reaper-manager.js pan --contains GTR --pan L50
node .\bin\reaper-manager.js send-volume --selected --dest Reverb --db 2
node .\bin\reaper-manager.js item-volume --selected --db -3
node .\bin\reaper-manager.js gain-stage --all-items
node .\bin\reaper-manager.js vocal-level --selected-items
node .\bin\reaper-manager.js gain-stage --contains FLAUTA --preview
node .\bin\reaper-manager.js track-state --contains VOX --mute on
node .\bin\reaper-manager.js select-tracks --contains flauta
node .\bin\reaper-manager.js add-fx --selected --fx RVerb
node .\bin\reaper-manager.js remove-fx --selected
node .\bin\reaper-manager.js delete-tracks --selected
```

## Project Purpose

This workspace is a local Codex-to-REAPER mix assistant. The user writes mix/setup requests in Spanish, and Codex translates them into safe structured commands sent to REAPER through the local Node CLI.

The user is a sound engineer. Respond in Spanish by default unless they ask otherwise.

## Key Paths

- Workspace: `A:\PROYECTOS\OPENCODE\Reaper Manager`
- CLI entrypoint: `A:\PROYECTOS\OPENCODE\Reaper Manager\bin\reaper-manager.js`
- Local bridge state: `A:\PROYECTOS\OPENCODE\Reaper Manager\.reaper-manager`
- Command queue: `A:\PROYECTOS\OPENCODE\Reaper Manager\.reaper-manager\queue`
- Responses and heartbeat: `A:\PROYECTOS\OPENCODE\Reaper Manager\.reaper-manager\state`
- REAPER resource path: `C:\Users\sagar\AppData\Roaming\REAPER`
- Installed REAPER bridge: `C:\Users\sagar\AppData\Roaming\REAPER\Scripts\Reaper Manager\Reaper Manager Bridge.lua`
- REAPER config backups from installer: `A:\PROYECTOS\OPENCODE\Reaper Manager\.reaper-manager\backups`

## Health Checks

Before sending any command that changes REAPER, run:

```powershell
node .\bin\reaper-manager.js status
```

If `heartbeat` is `null`, missing, stale, or says the bridge is stopped, do not queue mutating commands. Tell the user to restart REAPER if needed and press the `Reaper Manager` toolbar button.

Use this to check live bridge response once heartbeat exists:

```powershell
node .\bin\reaper-manager.js ping
```

Run tests after changing JavaScript or command behavior:

```powershell
npm test
```

## Safe Command Patterns

Use the CLI rather than writing queue JSON by hand.

Color tracks by name:

```powershell
node .\bin\reaper-manager.js color --contains CLICK --color red
```

Color all tracks:

```powershell
node .\bin\reaper-manager.js color --all --color azul
```

Create FX returns and sends from selected tracks:

```powershell
node .\bin\reaper-manager.js returns --count 2 --fx RVerb --from selected
```

Create FX returns without automatically creating sends:

```powershell
node .\bin\reaper-manager.js returns --count 2 --fx RVerb --from none
```

Add FX to selected tracks:

```powershell
node .\bin\reaper-manager.js add-fx --selected --fx RVerb
```

Remove FX from all tracks only when explicitly requested:

```powershell
node .\bin\reaper-manager.js remove-fx --all
```

Delete tracks only when explicitly requested:

```powershell
node .\bin\reaper-manager.js delete-tracks --selected
node .\bin\reaper-manager.js delete-tracks --all
```

Adjust track volume relatively in dB:

```powershell
node .\bin\reaper-manager.js volume --all --db -3
```

Pan tracks:

```powershell
node .\bin\reaper-manager.js pan --selected --pan L35
```

Adjust send levels from matching source tracks, optionally filtered by destination:

```powershell
node .\bin\reaper-manager.js send-volume --selected --dest Reverb --db 2
```

Adjust selected item volume:

```powershell
node .\bin\reaper-manager.js item-volume --selected --db -3
```

Run automatic item gain staging:

```powershell
node .\bin\reaper-manager.js gain-stage --all-items
node .\bin\reaper-manager.js gain-stage --selected-items
node .\bin\reaper-manager.js gain-stage --selected-tracks
node .\bin\reaper-manager.js gain-stage --contains FLAUTA --preview
```

Level selected vocal items by syllable-sized detected parts into take volume envelopes, using a simplified smooth curve by default:

```powershell
node .\bin\reaper-manager.js vocal-level --selected-items
node .\bin\reaper-manager.js vocal-level --selected-items --preview
```

Set track states:

```powershell
node .\bin\reaper-manager.js track-state --contains VOX --mute on
node .\bin\reaper-manager.js track-state --selected --solo toggle
```

Select tracks:

```powershell
node .\bin\reaper-manager.js select-tracks --contains FLAUTA
node .\bin\reaper-manager.js select-tracks --contains GTR --mode add
node .\bin\reaper-manager.js select-tracks --all --mode remove
```

Rename tracks:

```powershell
node .\bin\reaper-manager.js rename --contains CLICK --prefix REF_
```

Create tracks:

```powershell
node .\bin\reaper-manager.js create-tracks --count 2 --name FX
```

Create a folder from contiguous selected tracks:

```powershell
node .\bin\reaper-manager.js folder --selected --name DRUMS
```

Route tracks to a bus:

```powershell
node .\bin\reaper-manager.js route-to-bus --selected --bus DRUMS --disable-main
```

Bypass or enable FX:

```powershell
node .\bin\reaper-manager.js fx-bypass --selected --fx RVerb --state toggle
```

Create a standard rock session structure. This clears existing tracks by default, so use it only after an explicit destructive request:

```powershell
node .\bin\reaper-manager.js rock-template
```

Translate a simple Spanish request through the local parser:

```powershell
node .\bin\reaper-manager.js ask "Coloreame todas las pistas que contengan la palabra CLICK de rojo"
```

## REAPER Safety Rules

- Treat the currently open REAPER project as live work.
- Do not queue mutating commands unless the bridge heartbeat is active and the user requested that specific action.
- Do not execute ambiguous requests. If the source tracks, target tracks, plugin, or routing intent is unclear, ask one concise clarification question.
- Never delete tracks, FX, sends, files, or REAPER configuration unless the user explicitly asks for that destructive action.
- The bridge wraps each supported command in one REAPER undo block. For multi-step user requests, prefer multiple focused commands so the user can undo task-by-task instead of one giant undo.
- If a plugin cannot be resolved, report the error instead of guessing a different plugin.

## Plugin Defaults

- Prefer VST3 variants.
- Prefer stereo variants when available.
- `RVerb` means `VST3:RVerb Stereo (Waves)`.
- The plugin cache is stored at `.reaper-manager\plugin-cache.json`.

## Install And Repair

The installer copies the Lua bridge into REAPER, registers the action, and touches `reaper-kb.ini` and `reaper-menu.ini` with backups. Use it only when the user asks to install/repair:

```powershell
npm run install:reaper
```

If REAPER is open during install/repair, tell the user to restart REAPER once so the action list and toolbar reload.

## Current Operating Model

This project is intentionally local. Do not create global instructions in `~/.codex/AGENTS.md` for this workflow. Future Codex chats should be opened from this workspace root so these project instructions are loaded.

## Code Organization

- `src/commands.js` is a compatibility facade.
- Command builders live under `src/commands/` by domain: tracks, sends, FX, items, folders and project helpers.
- Shared parsing/validation lives under `src/core/`.
- The REAPER runtime is still `reaper/Reaper Manager Bridge.lua`; split it only when actively refactoring bridge internals.
