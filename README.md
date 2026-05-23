# Reaper Manager

Local bridge between Codex and REAPER for mix assistant commands.

## What it does

- Installs a persistent Lua ReaScript bridge into the REAPER resource path.
- Adds a toolbar button that starts/stops the bridge.
- Adds a `Gain Stage` toolbar button that applies deterministic gain staging to selected items.
- Adds a `Select Items` toolbar button that selects every item in the project.
- Adds `vocal-level` for pre-compressor vocal leveling on selected item take volume envelopes, targeting the `-18 dBFS = 0 VU` working point with conservative smooth automation.
- Lets Codex send structured commands through `.reaper-manager/queue`.
- Writes command responses and bridge heartbeat into `.reaper-manager/state`.

## Quick commands

```powershell
npm run install:reaper
node .\bin\reaper-manager.js status
node .\bin\reaper-manager.js ping
node .\bin\reaper-manager.js color --contains CLICK --color red
node .\bin\reaper-manager.js color --all --color azul
node .\bin\reaper-manager.js returns --count 2 --fx RVerb --from selected
node .\bin\reaper-manager.js add-fx --selected --fx RVerb
node .\bin\reaper-manager.js remove-fx --all
node .\bin\reaper-manager.js delete-tracks --selected
node .\bin\reaper-manager.js select-tracks --contains FLAUTA
node .\bin\reaper-manager.js select-tracks --all --mode remove
node .\bin\reaper-manager.js volume --all --db -3
node .\bin\reaper-manager.js pan --selected --pan L35
node .\bin\reaper-manager.js send-volume --selected --dest Reverb --db 2
node .\bin\reaper-manager.js item-volume --selected --db -3
node .\bin\reaper-manager.js gain-stage --all-items
node .\bin\reaper-manager.js vocal-level --selected-items --preview
node .\bin\reaper-manager.js vocal-level --selected-items
node .\bin\reaper-manager.js vocal-level --selected-items --replace-envelope
node .\bin\reaper-manager.js gain-stage --selected-items --preview
node .\bin\reaper-manager.js track-state --contains VOX --mute on
node .\bin\reaper-manager.js rename --contains CLICK --prefix REF_
node .\bin\reaper-manager.js create-tracks --count 2 --name FX
node .\bin\reaper-manager.js folder --selected --name DRUMS
node .\bin\reaper-manager.js route-to-bus --selected --bus DRUMS --disable-main
node .\bin\reaper-manager.js fx-bypass --selected --fx RVerb --state toggle
node .\bin\reaper-manager.js rock-template
node .\bin\reaper-manager.js chat "baja guitarras 1 dB"
```

If REAPER is open while installing, restart REAPER once so it reloads the action list
and toolbar configuration.

## New Codex chat quickstart

Open new Codex chats from this workspace:

```text
A:\PROYECTOS\OPENCODE\Reaper Manager
```

Codex will read `AGENTS.md` for project-specific instructions. Before asking it to
change REAPER, make sure REAPER is open and the `Reaper Manager` toolbar button has
been pressed. If `node .\bin\reaper-manager.js status` shows no heartbeat, the bridge
is not running yet.

## REAPER chat

Run `npm run install:reaper` after updates to register the bridge action:

- `Reaper Manager`: starts/stops the bridge.
- `Gain Stage`: queues `gain_stage_items` for selected items using the standard defaults.
- `Select Items`: selects every item in the project.

The chat handles simple local commands first through the same parser and command
builders as the CLI. If the local parser does not understand the request and
`OPENAI_API_KEY` is available, it uses `gpt-5.5` with low reasoning effort as a
fallback planner. If no clear safe command comes out, it answers
`No entiendo lo que quieres.` Clear commands are applied immediately and each
command stays in its own REAPER undo block.

## Safety

The bridge only implements additive/reversible setup commands in v1. Each command is
wrapped in one REAPER undo block.
