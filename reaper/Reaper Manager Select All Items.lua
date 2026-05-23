local _, script_path = reaper.get_action_context()
local script_dir = script_path:match("^(.*)[/\\][^/\\]+$")
package.path = script_dir .. "/?.lua;" .. script_dir .. "\\?.lua;" .. package.path

local ok_config, config = pcall(require, "rm_config")

if not ok_config or type(config) ~= "table" then
  reaper.MB("Reaper Manager no esta instalado. Ejecuta npm run install:reaper.", "Reaper Manager Select All Items", 0)
  return
end

local count = reaper.CountMediaItems(0)

reaper.Undo_BeginBlock2(0)
reaper.SelectAllMediaItems(0, false)
for i = 0, count - 1 do
  local item = reaper.GetMediaItem(0, i)
  if item then reaper.SetMediaItemSelected(item, true) end
end
reaper.Undo_EndBlock2(0, "Reaper Manager: select all items", -1)

reaper.UpdateArrange()

if reaper.TrackCtl_SetToolTip and reaper.GetMousePosition then
  local x, y = reaper.GetMousePosition()
  reaper.TrackCtl_SetToolTip("Seleccionados " .. tostring(count) .. " items.", x + 16, y + 16, true)
else
  reaper.ShowConsoleMsg("Seleccionados " .. tostring(count) .. " items.\n")
end
