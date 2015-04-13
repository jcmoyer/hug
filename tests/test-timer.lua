require('path')
local framework = require('tt')
local timer = require('hug.timer')

local function overstep()
  local t = timer.new(1)
  framework.compare('active', t:status())
  t:update(math.huge)
  framework.compare('finished', t:status())
  framework.compare(0, t:remaining())
end

local function evaluate()
  local function id(x)
    return x
  end
  
  local t = timer.new(1)
  framework.compare(0.0, t:evaluate(id))
  t:update(0.5)
  framework.compare(0.5, t:evaluate(id))
  t:update(0.5)
  framework.compare(1.0, t:evaluate(id))
end

local function restart()
  local t = timer.new(1)
  framework.compare('active', t:status())
  t:update(1)
  framework.compare('finished', t:status())
  t:restart()
  framework.compare('active', t:status())
end

return framework.testall {
  { 'overstep', overstep },
  { 'evaluate', evaluate },
  { 'restart', restart }
}
