require('path')
local framework = require('framework')
local timerpool = require('hug.timerpool')

local function simple()
  local n = 0
  local function inc()
    n = n + 1
  end
  
  local pool = timerpool.new()
  
  -- start timers with varying durations
  for i = 1, 5 do
    pool:start(i, inc)
  end
  
  for i = 1, 5 do
    pool:update(1)
    framework.compare(i, n)
  end
end

local function cancelled()
  local n = 0
  local function inc()
    n = n + 1
  end
  
  local pool = timerpool.new()
  local t = pool:start(2, inc)
  pool:update(1)
  t:cancel()
  pool:update(1)
  
  framework.compare(0, n)
end

local function overstep()
  local n = 0
  local function inc()
    n = n + 1
  end
  
  local pool = timerpool.new()
  pool:start(1, inc)
  pool:update(math.huge)
  
  framework.compare(1, n)
end

return framework.testall {
  { 'simple', simple },
  { 'cancelled', cancelled },
  { 'overstep', overstep }
}
