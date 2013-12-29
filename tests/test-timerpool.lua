require('path')
local framework = require('framework')
local timerpool = require('hug.timerpool')

local function simple()
  local n = 0
  local function inc()
    n = n + 1
  end
  
  -- start timers with varying durations
  for i = 1, 5 do
    timerpool.start(i, inc)
  end
  
  for i = 1, 5 do
    timerpool.update(1)
    framework.compare(i, n)
  end
end

local function cancelled()
  local n = 0
  local function inc()
    n = n + 1
  end
  
  local t = timerpool.start(2, inc)
  timerpool.update(1)
  t:cancel()
  timerpool.update(1)
  
  framework.compare(0, n)
end

local function overstep()
  local n = 0
  local function inc()
    n = n + 1
  end
  
  timerpool.start(1, inc)
  timerpool.update(math.huge)
  
  framework.compare(1, n)
end

return framework.testall {
  { 'simple', simple },
  { 'cancelled', cancelled },
  { 'overstep', overstep }
}
