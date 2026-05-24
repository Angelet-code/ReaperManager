local M = {}

function M.join(a, b)
  return a .. "/" .. b
end

function M.ensure_dir(path)
  reaper.RecursiveCreateDirectory(path, 0)
end

function M.read_file(path)
  local file = io.open(path, "rb")
  if not file then return nil end
  local content = file:read("*a")
  file:close()
  return content
end

function M.write_file(path, content)
  local clock = reaper and reaper.time_precise and reaper.time_precise() or os.time()
  local tmp = path .. "." .. tostring(math.floor(clock * 1000)) .. ".tmp"
  local file = assert(io.open(tmp, "wb"))
  file:write(content)
  file:close()
  os.remove(path)
  assert(os.rename(tmp, path))
end

return M
