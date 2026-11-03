-- "Herramientas" toolbar button: drop-down menu with the Reaper Manager tools.
-- Analysis tools run through the Node CLI in the background (declip needs Python),
-- so REAPER and the bridge keep running while they work; the CLI writes a short
-- report file that this script shows when the run finishes.
local _, script_path = reaper.get_action_context()
local script_dir = script_path:match("^(.*)[/\\][^/\\]+$")
package.path = script_dir .. "/?.lua;" .. script_dir .. "\\?.lua;" .. package.path

local TITLE = "Reaper Manager"
local ok_json, json = pcall(require, "rm_json")
local ok_config, config = pcall(require, "rm_config")

if not ok_json or not ok_config or type(config) ~= "table" or not config.workspace_root then
  reaper.MB("Reaper Manager no esta instalado. Ejecuta npm run install:reaper.", TITLE, 0)
  return
end

local root = config.workspace_root:gsub("\\", "/")
local report_dir = root .. "/.reaper-manager/state/tools"
local timeout_seconds = 20 * 60

local MENU = {
  { label = "Declip: selección de tiempo", tool = "declip" },
  { label = "Declip: item completo", tool = "declip-item" },
  { label = "Nivelar voz (item seleccionado)", tool = "vocal-level" },
  { separator = true },
  { label = "Gain Stage", action = config.gain_stage_action_id },
  { label = "Select Items", action = config.select_items_action_id },
  { label = "Detect Parts", action = config.detect_arrangement_action_id },
  { label = "Tablatura en tiempo real", action = config.tab_viewer_action_id }
}

local function notify(text)
  local x, y = reaper.GetMousePosition()
  reaper.TrackCtl_SetToolTip(tostring(text), x + 16, y + 16, true)
end

local function read_json(path)
  local file = io.open(path, "rb")
  if not file then return nil end
  local content = file:read("*a")
  file:close()
  local ok, decoded = pcall(json.decode, content)
  if ok then return decoded end
  return nil
end

local function show_menu()
  local labels, entries = {}, {}
  for _, entry in ipairs(MENU) do
    if entry.separator then
      labels[#labels + 1] = ""
    else
      labels[#labels + 1] = entry.label
      entries[#entries + 1] = entry
    end
  end
  local x, y = reaper.GetMousePosition()
  gfx.init(TITLE, 0, 0, 0, x, y)
  gfx.x, gfx.y = 0, 0
  local choice = gfx.showmenu(table.concat(labels, "|"))
  gfx.quit()
  return entries[choice]
end

local function ensure_bridge_running()
  local command_id = reaper.NamedCommandLookup(config.bridge_action_id or "")
  if command_id == 0 then return false end
  if reaper.GetToggleCommandStateEx(0, command_id) ~= 1 then reaper.Main_OnCommand(command_id, 0) end
  return true
end

local function show_report(report)
  local lines = type(report.lines) == "table" and report.lines or {}
  local title = TITLE .. " - " .. tostring(report.title or "")
  if report.ok then
    reaper.MB(table.concat(lines, "\n"), title, 0)
  else
    reaper.MB("Ha fallado:\n" .. table.concat(lines, "\n"), title, 0)
  end
end

local function wait_report(path, started)
  local report = read_json(path)
  if report then
    os.remove(path)
    show_report(report)
    return
  end
  if reaper.time_precise() - started > timeout_seconds then
    reaper.MB("La herramienta esta tardando demasiado. Revisa el estado con: node bin\\reaper-manager.js status", TITLE, 0)
    return
  end
  reaper.defer(function() wait_report(path, started) end)
end

local function run_tool(entry)
  if not config.node_path or not config.cli_path then
    reaper.MB("Falta node_path/cli_path en rm_config.lua. Ejecuta npm run install:reaper.", TITLE, 0)
    return
  end
  if not ensure_bridge_running() then
    reaper.MB("Reinicia REAPER una vez para cargar la accion Reaper Manager.", TITLE, 0)
    return
  end
  reaper.RecursiveCreateDirectory(report_dir, 0)
  local report = report_dir .. "/" .. entry.tool .. "-" .. tostring(math.floor(reaper.time_precise() * 1000)) .. ".json"
  local cmd = string.format('"%s" "%s" tool %s --report "%s"', config.node_path, config.cli_path, entry.tool, report)
  reaper.ExecProcess(cmd, -1)
  notify(entry.label .. ": procesando...")
  wait_report(report, reaper.time_precise())
end

local entry = show_menu()
if not entry then return end
if entry.tool then
  run_tool(entry)
elseif entry.action then
  local command_id = reaper.NamedCommandLookup(entry.action)
  if command_id ~= 0 then reaper.Main_OnCommand(command_id, 0) end
end
