local _, script_path, section_id, command_id = reaper.get_action_context()
local script_dir = script_path:match("^(.*)[/\\][^/\\]+$")
package.path = script_dir .. "/?.lua;" .. script_dir .. "\\?.lua;" .. package.path

local json = require("rm_json")
local config = require("rm_config")

local root = config.workspace_root:gsub("\\", "/")
local chat_dir = root .. "/.reaper-manager/chat"
local request_dir = chat_dir .. "/requests"
local response_dir = chat_dir .. "/responses"
local history_path = chat_dir .. "/history.json"
local heartbeat_path = root .. "/.reaper-manager/state/heartbeat.json"
local input = ""
local pending_id = nil
local pending_since = nil
local messages = {}
local status_text = "Listo"
local last_poll = 0
local running = true

local function join(a, b)
  return a .. "/" .. b
end

local function ensure_dirs()
  reaper.RecursiveCreateDirectory(root .. "/.reaper-manager", 0)
  reaper.RecursiveCreateDirectory(chat_dir, 0)
  reaper.RecursiveCreateDirectory(request_dir, 0)
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

local function add_message(role, text)
  messages[#messages + 1] = {
    role = role,
    text = tostring(text or "")
  }
  while #messages > 80 do table.remove(messages, 1) end
end

local function load_history()
  local history = read_json(history_path)
  if type(history) ~= "table" then return end
  local start = math.max(1, #history - 24)
  for i = start, #history do
    local item = history[i]
    if type(item) == "table" and item.text then
      add_message(item.role or "assistant", item.text)
    end
  end
end

local function shell_quote(value)
  return '"' .. tostring(value):gsub('"', '""') .. '"'
end

local function launch_node(request_path)
  local node = config.node_path or "node"
  local bin = join(root, "bin/reaper-manager.js")
  local command
  if package.config:sub(1, 1) == "\\" then
    command = "cmd.exe /C cd /D " .. shell_quote(root) .. " && start \"\" /B " .. shell_quote(node) .. " " .. shell_quote(bin) .. " chat --request " .. shell_quote(request_path)
  else
    command = "cd " .. shell_quote(root) .. " && " .. shell_quote(node) .. " " .. shell_quote(bin) .. " chat --request " .. shell_quote(request_path) .. " >/dev/null 2>&1 &"
  end
  os.execute(command)
end

local function submit()
  local text = input:gsub("^%s+", ""):gsub("%s+$", "")
  if text == "" or pending_id then return end

  local id = "chat-" .. tostring(math.floor(reaper.time_precise() * 1000))
  local request_path = join(request_dir, id .. ".json")
  write_file(request_path, json.encode({
    id = id,
    text = text,
    source = "reaper-chat",
    time = os.date("!%Y-%m-%dT%H:%M:%SZ")
  }))

  input = ""
  pending_id = id
  pending_since = reaper.time_precise()
  status_text = "Pensando..."
  add_message("user", text)
  launch_node(request_path)
end

local function poll_response()
  if not pending_id then return end
  local response = read_json(join(response_dir, pending_id .. ".json"))
  if not response then
    if pending_since and reaper.time_precise() - pending_since > 90 then
      add_message("assistant", "La respuesta esta tardando demasiado. Revisa el puente o la clave de OpenAI.")
      status_text = "Timeout"
      pending_id = nil
    end
    return
  end

  add_message("assistant", response.message or response.error or "Sin respuesta.")
  status_text = response.ok and "Aplicado" or "Error"
  pending_id = nil
  pending_since = nil
end

local function bridge_label()
  local heartbeat = read_json(heartbeat_path)
  if type(heartbeat) == "table" and heartbeat.bridge == "running" then
    return "Puente activo"
  end
  return "Pulsa Reaper Manager"
end

local function draw_text(x, y, text, color)
  gfx.set(color[1], color[2], color[3], color[4] or 1)
  gfx.x = x
  gfx.y = y
  gfx.drawstr(text)
end

local function wrap_text(text, width)
  local lines = {}
  local line = ""
  for word in tostring(text or ""):gmatch("%S+") do
    local candidate = line == "" and word or (line .. " " .. word)
    local measured = gfx.measurestr(candidate)
    if measured > width and line ~= "" then
      lines[#lines + 1] = line
      line = word
    else
      line = candidate
    end
  end
  if line ~= "" then lines[#lines + 1] = line end
  if #lines == 0 then lines[#lines + 1] = "" end
  return lines
end

local function draw_messages()
  local margin = 14
  local top = 42
  local bottom = gfx.h - 58
  local y = bottom
  local line_height = 21
  gfx.setfont(1, "Arial", 17)

  for i = #messages, 1, -1 do
    local item = messages[i]
    local prefix = item.role == "user" and "Tu: " or "RM: "
    local color = item.role == "user" and { 0.78, 0.88, 1, 1 } or { 0.92, 0.92, 0.9, 1 }
    local lines = wrap_text(prefix .. item.text, gfx.w - margin * 2)
    y = y - (#lines * line_height) - 10
    if y < top then break end
    for _, line in ipairs(lines) do
      draw_text(margin, y, line, color)
      y = y + line_height
    end
    y = y - (#lines * line_height) - 8
  end
end

local function draw()
  gfx.set(0.08, 0.08, 0.09, 1)
  gfx.rect(0, 0, gfx.w, gfx.h, 1)

  gfx.set(0.13, 0.13, 0.15, 1)
  gfx.rect(0, 0, gfx.w, 34, 1)
  gfx.setfont(1, "Arial", 18)
  draw_text(12, 8, "Reaper Manager Chat", { 0.96, 0.96, 0.95, 1 })
  gfx.setfont(1, "Arial", 15)
  draw_text(gfx.w - 250, 10, bridge_label() .. " | " .. status_text, { 0.68, 0.72, 0.76, 1 })

  draw_messages()

  local input_y = gfx.h - 42
  gfx.set(0.16, 0.16, 0.18, 1)
  gfx.rect(10, input_y, gfx.w - 20, 30, 1)
  gfx.set(0.35, 0.35, 0.38, 1)
  gfx.rect(10, input_y, gfx.w - 20, 30, 0)
  gfx.setfont(1, "Arial", 17)
  local shown = pending_id and "Esperando respuesta..." or input
  if shown == "" then shown = "Escribe una orden y pulsa Enter" end
  draw_text(18, input_y + 8, shown, pending_id and { 0.55, 0.58, 0.62, 1 } or { 0.94, 0.94, 0.92, 1 })
end

local function handle_keyboard()
  local char = gfx.getchar()
  if char < 0 then
    running = false
    return
  end
  if pending_id then return end
  if char == 13 then
    submit()
  elseif char == 8 then
    input = input:sub(1, math.max(0, #input - 1))
  elseif char >= 32 and char <= 255 then
    input = input .. string.char(char)
  end
end

local function loop()
  if not running then return end
  handle_keyboard()
  local now = reaper.time_precise()
  if now - last_poll > 0.25 then
    last_poll = now
    poll_response()
  end
  draw()
  gfx.update()
  reaper.defer(loop)
end

local function cleanup()
  if command_id and command_id ~= 0 then
    reaper.SetToggleCommandState(section_id, command_id, 0)
    reaper.RefreshToolbar2(section_id, command_id)
  end
end

ensure_dirs()
load_history()
if #messages == 0 then add_message("assistant", "Listo. Escribe una orden de mezcla y pulsa Enter.") end
if reaper.set_action_options then reaper.set_action_options(1 | 4) end
if command_id and command_id ~= 0 then
  reaper.SetToggleCommandState(section_id, command_id, 1)
  reaper.RefreshToolbar2(section_id, command_id)
end
reaper.atexit(cleanup)
gfx.init("Reaper Manager Chat", 620, 460, 0)
if gfx.dock then gfx.dock(1) end
loop()
