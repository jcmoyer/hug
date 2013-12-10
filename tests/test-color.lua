require('path')
local framework = require('framework')
local color     = require('color')

local function eq()
  local a = color.new(100, 200, 300)
  local b = color.new{100, 200, 300}
  framework.compare(true, a == b, 'rgb-rgb color equality')
  
  local c = color.new(100, 200, 300, 200)
  local d = color.new{100, 200, 300}
  framework.compare(false, c == d, 'rgba-rgb color equality')
  
  local e = color.new(100, 200, 300, 100)
  local f = color.new{100, 200, 300, 100}
  framework.compare(true, e == f, 'rgba-rgba color equality')
end

local function add()
  framework.compare(
    color.new(100, 200, 100),
    color.new(40, 100, 60):add(color.new(60, 100, 40))
  )
end

local function sub()
  framework.compare(
    color.new(100, 100, 100),
    color.new(200, 150, 100):sub(color.new(100, 50, 0))
  )
end

local function mul()
  framework.compare(
    color.new(100, 150, 200),
    color.new(10, 15, 20):mul(10)
  )
end

local function div()
  framework.compare(
    color.new(10, 15, 20),
    color.new(100, 150, 200):div(10)
  )
end

local function opadd()
  framework.compare(
    color.new(100, 200, 100),
    color.new(40, 100, 60) + color.new(60, 100, 40)
  )
end

local function opsub()
  framework.compare(
    color.new(100, 100, 100),
    color.new(200, 150, 100) - color.new(100, 50, 0)
  )
end

local function opmul()
  framework.compare(
    color.new(100, 150, 200),
    color.new(10, 15, 20) * 10,
    'color * scalar'
  )
  framework.compare(
    color.new(100, 150, 200),
    10 * color.new(10, 15, 20),
    'scalar * color'
  )
end

local function opdiv()
  framework.compare(
    color.new(100, 75, 50),
    color.new(200, 150, 100) / 2,
    'color / scalar'
  )
end

local function invert()
  framework.compare(
    color.new(100, 120, 140),
    color.new(255 - 100, 255 - 120, 255 - 140):invert()
  )
end

local function opinvert()
  framework.compare(
    color.new(100, 120, 140),
    -color.new(255 - 100, 255 - 120, 255 - 140)
  )
end

return framework.testall {
  { 'equality', eq },

  { 'in-place addition', add },
  { 'in-place subtraction', sub },
  { 'in-place multiplication', mul },
  { 'in-place division', div },

  { 'operator addition', opadd },
  { 'operator subtraction', opsub },
  { 'operator multiplication', opmul },
  { 'operator division', opdiv },
  
  { 'in-place inversion', invert },
  { 'operator inversion', opinvert }
}