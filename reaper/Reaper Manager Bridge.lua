local _, script_path, section_id, command_id = reaper.get_action_context()
local script_dir = script_path:match("^(.*)[/\\][^/\\]+$")

package.path = table.concat({
  script_dir .. "/?.lua",
  script_dir .. "\\?.lua",
  script_dir .. "/?/init.lua",
  script_dir .. "\\?\\init.lua",
  package.path
}, ";")

local runtime_modules = {
  "rm_bridge",
  "rm_registry",
  "rm_fs",
  "rm_core",
  "rm_commands_basic",
  "rm_gain_stage",
  "rm_vocal_level",
  "rm_project_mix"
}

for _, module_name in ipairs(runtime_modules) do
  package.loaded[module_name] = nil
end

local ok, bridge_or_error = pcall(require, "rm_bridge")
if not ok then
  local message = "Could not load Reaper Manager bridge modules:\n" .. tostring(bridge_or_error)
  if reaper.ShowMessageBox then
    reaper.ShowMessageBox(message, "Reaper Manager", 0)
  elseif reaper.ShowConsoleMsg then
    reaper.ShowConsoleMsg(message .. "\n")
  end
  error(bridge_or_error)
end

bridge_or_error.start({
  script_dir = script_dir,
  section_id = section_id,
  command_id = command_id
})
