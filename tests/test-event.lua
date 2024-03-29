require('path')
local framework = require('tt')
local event = require('hug.event')
local module = require('hug.module')

local function add()
  local e = event.new()
  local n = false
  e:add(function()
    n = true
  end)
  e:raise()
  framework.compare(true, n)
end

local function remove()
  local e = event.new()
  local n = false
  local function f()
    n = true
  end
  e:add(f)
  e:remove(f)
  e:raise()
  framework.compare(false, n)
end

local function raise()
  local e = event.new()
  local n = 0
  local function f(x)
    n = n + x
  end
  e:add(f)
  e:raise(1)
  framework.compare(1, n)
  e(1)
  framework.compare(2, n)
end

local function len()
  local e = event.new()
  e:add(function() end)
  framework.compare(1, #e)
  e:add(function() end)
  framework.compare(2, #e)
end

local function emitter()
  local e = event.emitter.new()
  local n = 0
  local function increment()
    n = n + 1
  end
  local function decrement()
    n = n - 1
  end
  e:on('increment', increment)
  e:on('decrement', decrement)
  e:emit('increment')
  framework.compare(1, n)
  e:emit('decrement')
  framework.compare(0, n)
  e:removelistener('increment', increment)
  e:emit('increment')
  framework.compare(0, n)
  e:clearlisteners('decrement')
  e:emit('decrement')
  framework.compare(0, n)
end

local function emitter_composition()
  local obj = event.emitter.declare(module.new())
  function obj.new()
    local instance = setmetatable({}, obj)
    event.emitter.compose(instance)
    return instance
  end
  function obj:tick()
    self:emit('tick')
  end

  local a = obj.new()
  local n = 0
  local function tickcb()
    n = n + 1
  end

  a:on('tick', tickcb)
  a:tick()
  framework.compare(1, n)

  a:clearlisteners('tick')
  a:tick()
  framework.compare(1, n)

  a:on('tick', tickcb)
  a:removelistener('tick', tickcb)
  a:tick()
  framework.compare(1, n)
end

local function emitter_inheritance()
  local obj = module.new(event.emitter)
  function obj.new()
    local instance = setmetatable({}, obj)
    event.emitter.construct(instance)
    return instance
  end
  function obj:tick()
    self:emit('tick')
  end

  local a = obj.new()
  local n = 0
  local function tickcb()
    n = n + 1
  end

  a:on('tick', tickcb)
  a:tick()
  framework.compare(1, n)

  a:clearlisteners('tick')
  a:tick()
  framework.compare(1, n)

  a:on('tick', tickcb)
  a:removelistener('tick', tickcb)
  a:tick()
  framework.compare(1, n)
end

return framework.testall {
  { 'add', add },
  { 'remove', remove },
  { 'raise', raise },
  { 'len', len },
  { 'emitter', emitter },
  { 'emitter composition', emitter_composition },
  { 'emitter inheritance', emitter_inheritance }
}
