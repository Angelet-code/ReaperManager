local M = {}

local json = require("rm_json")
local config = require("rm_config")
local fs = require("rm_fs")
local registry_module = require("rm_registry")

local function build_paths()
  local root = config.workspace_root:gsub("\\", "/")
  local state_dir = root .. "/.reaper-manager/state"
  return {
    root = root,
    queue_dir = root .. "/.reaper-manager/queue",
    state_dir = state_dir,
    response_dir = state_dir .. "/responses",
    processing_dir = state_dir .. "/processing"
  }
end

function M.start(options)
  options = options or {}
  local section_id = options.section_id
  local command_id = options.command_id
  local paths = build_paths()
  local registry = registry_module.create()
  local running = true
  local last_poll = 0

  local function ensure_dirs()
    fs.ensure_dir(paths.root .. "/.reaper-manager")
    fs.ensure_dir(paths.queue_dir)
    fs.ensure_dir(paths.state_dir)
    fs.ensure_dir(paths.response_dir)
    fs.ensure_dir(paths.processing_dir)
  end

  local function respond(id, ok, data)
    local payload = {
      id = id,
      ok = ok,
      time = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    if ok then
      payload.data = data
    else
      payload.error = tostring(data)
    end
    local encoded = json.encode(payload)
    fs.write_file(fs.join(paths.response_dir, id .. ".json"), encoded)
    fs.write_file(fs.join(paths.state_dir, "last-response.json"), encoded)
  end

  local function heartbeat(status, error_message)
    local _, project_path = reaper.EnumProjects(-1, "")
    local payload = {
      ok = error_message == nil,
      bridge = status or "running",
      bridge_version = registry_module.version(),
      features = registry_module.features(),
      time = os.date("!%Y-%m-%dT%H:%M:%SZ"),
      project_path = project_path,
      track_count = reaper.CountTracks(0),
      selected_item_count = reaper.CountSelectedMediaItems(0)
    }
    if error_message then payload.error = tostring(error_message) end
    fs.write_file(fs.join(paths.state_dir, "heartbeat.json"), json.encode(payload))
  end

  local function run_command(command)
    if command.type == "shutdown" then
      running = false
      return { bridge = "stopping" }
    end

    local handler = registry_module.handler(registry, command)
    if not handler then error("unsupported command type: " .. tostring(command.type)) end

    if registry_module.bypasses_undo(registry, command) then
      local ok, result = pcall(handler, command)
      if not ok then error(result) end
      return result
    end

    if registry_module.is_read_only(registry, command) then
      local ok, result = pcall(handler, command)
      if not ok then error(result) end
      return result
    end

    reaper.Undo_BeginBlock2(0)
    local ok, result = pcall(handler, command)
    local undo_name = "Reaper Manager: " .. tostring(command.type)
    reaper.Undo_EndBlock2(0, undo_name, -1)
    if not ok then error(result) end
    return result
  end

  local function claim_file(filename)
    local queue_path = fs.join(paths.queue_dir, filename)
    local processing_path = fs.join(paths.processing_dir, filename)
    os.remove(processing_path)
    local ok = os.rename(queue_path, processing_path)
    if ok then return processing_path end
    return nil
  end

  local function process_file(filename)
    local path = claim_file(filename)
    if not path then return end

    local content = fs.read_file(path)
    if not content then return end

    local ok, payload = pcall(json.decode, content)
    local id = filename:gsub("%.json$", "")

    if not ok then
      respond(id, false, payload)
      os.remove(path)
      return
    end

    id = payload.id or id
    local command = payload.command or payload
    local ok_command, result = pcall(run_command, command)
    respond(id, ok_command, result)
    os.remove(path)
  end

  local function poll()
    ensure_dirs()
    local i = 0
    while true do
      local filename = reaper.EnumerateFiles(paths.queue_dir, i)
      if not filename then break end
      if filename:match("%.json$") then
        process_file(filename)
      end
      i = i + 1
    end
    heartbeat()
  end

  local function loop()
    if not running then return end
    local now = reaper.time_precise()
    if now - last_poll >= (config.poll_interval or 0.25) then
      last_poll = now
      local ok, err = pcall(poll)
      if not ok then
        pcall(heartbeat, "error", err)
        pcall(respond, "bridge-error", false, err)
      end
    end
    reaper.defer(loop)
  end

  local function cleanup()
    if command_id and command_id ~= 0 then
      reaper.SetToggleCommandState(section_id, command_id, 0)
      reaper.RefreshToolbar2(section_id, command_id)
    end
    local payload = {
      ok = true,
      bridge = "stopped",
      bridge_version = registry_module.version(),
      time = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    fs.write_file(fs.join(paths.state_dir, "heartbeat.json"), json.encode(payload))
  end

  ensure_dirs()
  if reaper.set_action_options then reaper.set_action_options(1 | 4) end
  if command_id and command_id ~= 0 then
    reaper.SetToggleCommandState(section_id, command_id, 1)
    reaper.RefreshToolbar2(section_id, command_id)
  end
  reaper.atexit(cleanup)
  heartbeat()
  loop()
end

return M
