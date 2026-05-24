local _, script_path = reaper.get_action_context()
local script_dir = script_path:match("^(.*)[/\\][^/\\]+$")
package.path = script_dir .. "/?.lua;" .. script_dir .. "\\?.lua;" .. package.path

local ok_json, json = pcall(require, "rm_json")
local ok_config, config = pcall(require, "rm_config")

if not ok_json or not ok_config or type(config) ~= "table" or not config.workspace_root then
  reaper.MB("Reaper Manager no esta instalado. Ejecuta npm run install:reaper.", "Reaper Manager Gain Stage", 0)
  return
end

local root = config.workspace_root:gsub("\\", "/")
local queue_dir = root .. "/.reaper-manager/queue"
local state_dir = root .. "/.reaper-manager/state"
local response_dir = state_dir .. "/responses"
local heartbeat_path = state_dir .. "/heartbeat.json"
local timeout_seconds = tonumber(config.quick_action_timeout_seconds) or 90

local function join(a, b)
  return a .. "/" .. b
end

local function ensure_dirs()
  reaper.RecursiveCreateDirectory(root .. "/.reaper-manager", 0)
  reaper.RecursiveCreateDirectory(queue_dir, 0)
  reaper.RecursiveCreateDirectory(state_dir, 0)
  reaper.RecursiveCreateDirectory(response_dir, 0)
end

local function read_file(path)
  local file = io.open(path, "rb")
  if not file then return nil end
  local content = file:read("*a")
  file:close()
  return content
end

local function write_file(path, content)
  local tmp = path .. "." .. tostring(math.floor(reaper.time_precise() * 1000)) .. ".tmp"
  local file = assert(io.open(tmp, "wb"))
  file:write(content)
  file:close()
  os.remove(path)
  assert(os.rename(tmp, path))
end

local function read_json(path)
  local content = read_file(path)
  if not content then return nil end
  local ok, decoded = pcall(json.decode, content)
  if ok then return decoded end
  return nil
end

local function notify(text)
  if reaper.TrackCtl_SetToolTip and reaper.GetMousePosition then
    local x, y = reaper.GetMousePosition()
    reaper.TrackCtl_SetToolTip(tostring(text), x + 16, y + 16, true)
  else
    reaper.ShowConsoleMsg(tostring(text) .. "\n")
  end
end

local function bridge_command_id()
  local action_id = config.bridge_action_id or "_RS5f8ec7eefb29a342a97ac7f8aae8dfc9012cf12d"
  if not reaper.NamedCommandLookup then return 0 end
  return reaper.NamedCommandLookup(action_id)
end

local function bridge_toggle_state(command_id)
  if command_id == 0 then return -1 end
  if reaper.GetToggleCommandStateEx then
    return reaper.GetToggleCommandStateEx(0, command_id)
  end
  if reaper.GetToggleCommandState then
    return reaper.GetToggleCommandState(command_id)
  end
  return -1
end

local function ensure_bridge_running()
  local command_id = bridge_command_id()
  if command_id == 0 then
    return false, "Reinicia REAPER una vez para cargar la accion Reaper Manager."
  end

  if bridge_toggle_state(command_id) == 1 then return true end

  if reaper.Main_OnCommand then
    reaper.Main_OnCommand(command_id, 0)
  end

  return true
end

local function enqueue_gain_stage()
  local id = "quick-gain-stage-" .. tostring(math.floor(reaper.time_precise() * 1000))
  local payload = {
    id = id,
    createdAt = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    source = "reaper-toolbar",
    command = {
      type = "gain_stage_items",
      itemFilter = { type = "selected" },
      preview = false,
      calibrationDb = -18,
      targetVu = 0,
      peakCeilingDb = -0.3,
      maxBoostDb = 24,
      windowMs = 300,
      silenceDb = -60,
      topWindowPercent = 5
    }
  }

  write_file(join(queue_dir, id .. ".json"), json.encode(payload))
  return id
end

local function summarize_success(response)
  local data = response.data or {}
  local applied = tonumber(data.applied or data.processed or 0) or 0
  local matched = tonumber(data.matched or applied) or applied
  local skipped = tonumber(data.skipped or 0) or 0
  local gain = data.gain_db or {}

  if matched == 0 then
    reaper.MB(
      "No hay items seleccionados para gain staging.\n\nSelecciona uno o varios items, o pulsa primero el boton Select Items para seleccionar todo el proyecto.",
      "Reaper Manager Gain Stage",
      0
    )
    return
  end

  notify("Gain staging seleccionados: " .. tostring(applied) .. " items procesados, " .. tostring(skipped) .. " saltados.")

  reaper.ShowConsoleMsg(
    "Reaper Manager Gain Stage seleccionados\n" ..
    "Encontrados: " .. tostring(matched) .. "\n" ..
    "Procesados: " .. tostring(applied) .. "\n" ..
    "Saltados: " .. tostring(skipped) .. "\n" ..
    "Ganancia min: " .. tostring(gain.min or "-") .. " dB\n" ..
    "Ganancia max: " .. tostring(gain.max or "-") .. " dB\n" ..
    "Ganancia media: " .. tostring(gain.average or "-") .. " dB\n\n"
  )
end

local function wait_for_response(id, started_at)
  local response = read_json(join(response_dir, id .. ".json"))
  if response then
    if response.ok then
      summarize_success(response)
    else
      reaper.MB("Gain staging fallo:\n" .. tostring(response.error or "Error desconocido."), "Reaper Manager Gain Stage", 0)
    end
    return
  end

  if reaper.time_precise() - started_at > timeout_seconds then
    local heartbeat = read_json(heartbeat_path)
    local bridge = type(heartbeat) == "table" and heartbeat.bridge or "sin heartbeat"
    reaper.MB(
      "El gain staging esta tardando demasiado.\nEstado del bridge: " .. tostring(bridge) .. ".",
      "Reaper Manager Gain Stage",
      0
    )
    return
  end

  reaper.defer(function()
    wait_for_response(id, started_at)
  end)
end

ensure_dirs()
local ok_bridge, err = ensure_bridge_running()
if not ok_bridge then
  reaper.MB(err, "Reaper Manager Gain Stage", 0)
  return
end

local command_id = enqueue_gain_stage()
notify("Gain staging enviado a Reaper Manager.")
wait_for_response(command_id, reaper.time_precise())
