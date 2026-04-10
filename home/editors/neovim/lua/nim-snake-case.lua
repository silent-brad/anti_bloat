local function is_camel_case(s)
  if not (s:match("^[a-z]") or s:match("^_+[a-z]")) then
    return false
  end
  return s:match("[A-Z]") ~= nil
end

local function to_snake_case(s)
  local result = {}
  for i = 1, #s do
    local c = s:sub(i, i)
    if c:match("[A-Z]") and i > 1 then
      local prev = s:sub(i - 1, i - 1)
      local next_c = i < #s and s:sub(i + 1, i + 1) or ""
      if prev:match("[a-z0-9]") then
        table.insert(result, "_")
      elseif prev:match("[A-Z]") and next_c:match("[a-z]") then
        table.insert(result, "_")
      end
      table.insert(result, c:lower())
    else
      table.insert(result, c)
    end
  end
  return table.concat(result)
end

local function format_nim(input)
  local output = {}
  local i = 1
  local len = #input

  while i <= len do
    -- Doc block comment ##[ ... ]##
    if input:sub(i, i + 2) == "##[" then
      local depth = 1
      local start = i
      i = i + 3
      while i <= len and depth > 0 do
        if input:sub(i, i + 2) == "##[" then
          depth = depth + 1
          i = i + 3
        elseif input:sub(i, i + 2) == "]##" then
          depth = depth - 1
          i = i + 3
        else
          i = i + 1
        end
      end
      table.insert(output, input:sub(start, i - 1))

    -- Block comment #[ ... ]#
    elseif input:sub(i, i + 1) == "#[" then
      local depth = 1
      local start = i
      i = i + 2
      while i <= len and depth > 0 do
        if input:sub(i, i + 1) == "#[" then
          depth = depth + 1
          i = i + 2
        elseif input:sub(i, i + 1) == "]#" then
          depth = depth - 1
          i = i + 2
        else
          i = i + 1
        end
      end
      table.insert(output, input:sub(start, i - 1))

    -- Single-line comment
    elseif input:sub(i, i) == "#" then
      local start = i
      while i <= len and input:sub(i, i) ~= "\n" do
        i = i + 1
      end
      table.insert(output, input:sub(start, i - 1))

    -- Triple-quoted string
    elseif input:sub(i, i + 2) == '"""' then
      local start = i
      i = i + 3
      while i <= len do
        if input:sub(i, i + 2) == '"""' then
          i = i + 3
          break
        end
        i = i + 1
      end
      table.insert(output, input:sub(start, i - 1))

    -- Regular string
    elseif input:sub(i, i) == '"' then
      local start = i
      i = i + 1
      while i <= len and input:sub(i, i) ~= '"' do
        if input:sub(i, i) == "\\" then
          i = i + 1
        end
        i = i + 1
      end
      if i <= len then
        i = i + 1
      end
      table.insert(output, input:sub(start, i - 1))

    -- Character literal
    elseif input:sub(i, i) == "'" then
      local start = i
      i = i + 1
      while i <= len and input:sub(i, i) ~= "'" do
        if input:sub(i, i) == "\\" then
          i = i + 1
        end
        i = i + 1
      end
      if i <= len then
        i = i + 1
      end
      table.insert(output, input:sub(start, i - 1))

    -- Backtick identifier
    elseif input:sub(i, i) == "`" then
      local start = i
      i = i + 1
      while i <= len and input:sub(i, i) ~= "`" do
        i = i + 1
      end
      if i <= len then
        i = i + 1
      end
      table.insert(output, input:sub(start, i - 1))

    -- Identifier
    elseif input:sub(i, i):match("[a-zA-Z_]") then
      local start = i
      while i <= len and input:sub(i, i):match("[a-zA-Z0-9_]") do
        i = i + 1
      end
      local ident = input:sub(start, i - 1)
      if is_camel_case(ident) then
        table.insert(output, to_snake_case(ident))
      else
        table.insert(output, ident)
      end

    -- Everything else
    else
      table.insert(output, input:sub(i, i))
      i = i + 1
    end
  end

  return table.concat(output)
end

local filename = arg[1]
local f, input
if filename then
  f = io.open(filename, "r")
  if not f then
    io.stderr:write("Error: cannot open " .. filename .. "\n")
    os.exit(1)
  end
  input = f:read("*a")
  f:close()
else
  input = io.read("*a")
end
io.write(format_nim(input))
