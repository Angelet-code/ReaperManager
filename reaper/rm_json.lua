local json = {}

local escape_map = {
  ['"'] = '\\"',
  ['\\'] = '\\\\',
  ['\b'] = '\\b',
  ['\f'] = '\\f',
  ['\n'] = '\\n',
  ['\r'] = '\\r',
  ['\t'] = '\\t'
}

local function skip_ws(str, pos)
  while true do
    local c = str:sub(pos, pos)
    if c == " " or c == "\n" or c == "\r" or c == "\t" then
      pos = pos + 1
    else
      return pos
    end
  end
end

local function parse_error(str, pos, message)
  error(message .. " at byte " .. tostring(pos))
end

local parse_value

local function parse_string(str, pos)
  pos = pos + 1
  local out = {}

  while pos <= #str do
    local c = str:sub(pos, pos)
    if c == '"' then
      return table.concat(out), pos + 1
    end

    if c == "\\" then
      local esc = str:sub(pos + 1, pos + 1)
      if esc == '"' or esc == "\\" or esc == "/" then
        out[#out + 1] = esc
        pos = pos + 2
      elseif esc == "b" then
        out[#out + 1] = "\b"
        pos = pos + 2
      elseif esc == "f" then
        out[#out + 1] = "\f"
        pos = pos + 2
      elseif esc == "n" then
        out[#out + 1] = "\n"
        pos = pos + 2
      elseif esc == "r" then
        out[#out + 1] = "\r"
        pos = pos + 2
      elseif esc == "t" then
        out[#out + 1] = "\t"
        pos = pos + 2
      elseif esc == "u" then
        out[#out + 1] = "?"
        pos = pos + 6
      else
        parse_error(str, pos, "invalid string escape")
      end
    else
      out[#out + 1] = c
      pos = pos + 1
    end
  end

  parse_error(str, pos, "unterminated string")
end

local function parse_number(str, pos)
  local start = pos
  local c = str:sub(pos, pos)
  if c == "-" then pos = pos + 1 end

  while str:sub(pos, pos):match("%d") do pos = pos + 1 end

  if str:sub(pos, pos) == "." then
    pos = pos + 1
    while str:sub(pos, pos):match("%d") do pos = pos + 1 end
  end

  c = str:sub(pos, pos)
  if c == "e" or c == "E" then
    pos = pos + 1
    c = str:sub(pos, pos)
    if c == "+" or c == "-" then pos = pos + 1 end
    while str:sub(pos, pos):match("%d") do pos = pos + 1 end
  end

  return tonumber(str:sub(start, pos - 1)), pos
end

local function parse_array(str, pos)
  local arr = {}
  pos = skip_ws(str, pos + 1)
  if str:sub(pos, pos) == "]" then return arr, pos + 1 end

  while true do
    local value
    value, pos = parse_value(str, pos)
    arr[#arr + 1] = value
    pos = skip_ws(str, pos)

    local c = str:sub(pos, pos)
    if c == "]" then return arr, pos + 1 end
    if c ~= "," then parse_error(str, pos, "expected array comma or close") end
    pos = skip_ws(str, pos + 1)
  end
end

local function parse_object(str, pos)
  local obj = {}
  pos = skip_ws(str, pos + 1)
  if str:sub(pos, pos) == "}" then return obj, pos + 1 end

  while true do
    if str:sub(pos, pos) ~= '"' then parse_error(str, pos, "expected object key") end
    local key
    key, pos = parse_string(str, pos)
    pos = skip_ws(str, pos)
    if str:sub(pos, pos) ~= ":" then parse_error(str, pos, "expected object colon") end
    pos = skip_ws(str, pos + 1)
    obj[key], pos = parse_value(str, pos)
    pos = skip_ws(str, pos)

    local c = str:sub(pos, pos)
    if c == "}" then return obj, pos + 1 end
    if c ~= "," then parse_error(str, pos, "expected object comma or close") end
    pos = skip_ws(str, pos + 1)
  end
end

parse_value = function(str, pos)
  pos = skip_ws(str, pos)
  local c = str:sub(pos, pos)

  if c == '"' then return parse_string(str, pos) end
  if c == "{" then return parse_object(str, pos) end
  if c == "[" then return parse_array(str, pos) end
  if c == "-" or c:match("%d") then return parse_number(str, pos) end
  if str:sub(pos, pos + 3) == "true" then return true, pos + 4 end
  if str:sub(pos, pos + 4) == "false" then return false, pos + 5 end
  if str:sub(pos, pos + 3) == "null" then return nil, pos + 4 end

  parse_error(str, pos, "unexpected JSON value")
end

function json.decode(str)
  local value, pos = parse_value(str, 1)
  pos = skip_ws(str, pos)
  if pos <= #str then parse_error(str, pos, "trailing JSON data") end
  return value
end

local function is_array(tbl)
  local count = 0
  for key, _ in pairs(tbl) do
    if type(key) ~= "number" then return false end
    count = count + 1
  end
  for i = 1, count do
    if tbl[i] == nil then return false end
  end
  return true
end

local function encode_string(str)
  return '"' .. tostring(str):gsub('[%z\1-\31\\"]', function(c)
    return escape_map[c] or string.format("\\u%04x", c:byte())
  end) .. '"'
end

local encode_value

encode_value = function(value)
  local t = type(value)
  if t == "nil" then return "null" end
  if t == "boolean" then return value and "true" or "false" end
  if t == "number" then return tostring(value) end
  if t == "string" then return encode_string(value) end
  if t ~= "table" then return encode_string(tostring(value)) end

  local out = {}
  if is_array(value) then
    for i = 1, #value do out[#out + 1] = encode_value(value[i]) end
    return "[" .. table.concat(out, ",") .. "]"
  end

  for key, item in pairs(value) do
    out[#out + 1] = encode_string(key) .. ":" .. encode_value(item)
  end
  return "{" .. table.concat(out, ",") .. "}"
end

function json.encode(value)
  return encode_value(value)
end

return json
