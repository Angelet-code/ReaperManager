local M = {}

local BRIDGE_VERSION = "vocal-level-measured-macro-micro-2026-05-24"

local module_names = {
  "rm_commands_basic",
  "rm_gain_stage",
  "rm_vocal_level",
  "rm_project_mix"
}

function M.version()
  return BRIDGE_VERSION
end

function M.features()
  return {
    undo_command = true,
    vocal_level_estimated_points = true,
    vocal_level_zero_crossing_curve = true,
    vocal_level_phrase_safe_defaults = true,
    vocal_level_macro_micro = true,
    vocal_level_post_level_measurement = true
  }
end

local function command_ping()
  local _, project_path = reaper.EnumProjects(-1, "")
  return {
    bridge_version = M.version(),
    features = M.features(),
    project_path = project_path,
    track_count = reaper.CountTracks(0),
    selected_track_count = reaper.CountSelectedTracks(0),
    selected_item_count = reaper.CountSelectedMediaItems(0)
  }
end

local function command_undo(command)
  local count = math.floor(tonumber(command.count) or 1)
  if count < 1 then count = 1 end

  for _ = 1, count do
    if reaper.Undo_DoUndo2 then
      reaper.Undo_DoUndo2(0)
    else
      reaper.Main_OnCommand(40029, 0)
    end
  end

  reaper.UpdateArrange()
  return {
    undone = count
  }
end

function M.create()
  local registry = {
    handlers = {},
    read_only = {},
    bypass_undo = {},
    destructive = {}
  }

  function registry.command(name, handler, options)
    options = options or {}
    registry.handlers[name] = handler
    registry.read_only[name] = options.read_only == nil and false or options.read_only
    registry.bypass_undo[name] = options.bypass_undo == true
    registry.destructive[name] = options.destructive == true
  end

  registry.command("ping", command_ping, { read_only = true })
  registry.command("undo", command_undo, { bypass_undo = true })

  for _, module_name in ipairs(module_names) do
    local module = require(module_name)
    if type(module) ~= "table" or type(module.register) ~= "function" then
      error("runtime module missing register: " .. tostring(module_name))
    end
    module.register(registry)
  end

  return registry
end

function M.handler(registry, command)
  return registry.handlers[command.type]
end

function M.is_read_only(registry, command)
  local rule = registry.read_only[command.type]
  if type(rule) == "function" then return rule(command) == true end
  return rule == true
end

function M.bypasses_undo(registry, command)
  return registry.bypass_undo[command.type] == true
end

function M.is_destructive(registry, command)
  return registry.destructive[command.type] == true
end

return M
