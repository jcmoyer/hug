require('path')
local framework = require('tt')
local module = require('hug.module')

local function simple()
  local m = module.new()

  function m.new()
    return setmetatable({}, m)
  end

  function m:foo()
  end

  m.new():foo()
end

local function inherit()
  local super = module.new()

  function super:foo()
  end

  local m = module.new(super)

  function m.new()
    return setmetatable({}, m)
  end

  m.new():foo()
end

return framework.testall {
  { 'simple', simple },
  { 'inherit', inherit }
}
