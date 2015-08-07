require('path')
local framework = require('tt')
local event = require('hug.event')

local function connect()
  local e = event.new()
  local n = false
  e:connect(function()
    n = true
  end)
  e:raise()
  framework.compare(true, n)
end

local function disconnect()
  local e = event.new()
  local n = false
  local function f()
    n = true
  end
  e:connect(f)
  e:disconnect(f)
  e:raise()
  framework.compare(false, n)
end

local function raise()
  local e = event.new()
  local n = 0
  local function f(x)
    n = n + x
  end
  e:connect(f)
  e:raise(1)
  framework.compare(1, n)
  e(1)
  framework.compare(2, n)
end

local function len()
  local e = event.new()
  e:connect(function() end)
  framework.compare(1, e:len())
  e:connect(function() end)
  framework.compare(2, e:len())
  -- __len not supported on tables in 5.1 and, by extension, luajit with
  -- default compilation options
  if _VERSION ~= 'Lua 5.1' then
    framework.compare(2, #e)
  end
end

return framework.testall {
  { 'connect', connect },
  { 'disconnect', disconnect },
  { 'raise', raise },
  { 'len', len }
}
