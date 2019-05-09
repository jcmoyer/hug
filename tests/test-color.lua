require('path')
local framework = require('tt')
local color     = require('hug.color')

local function eq()
  local a = color.fromrgba(1, 0.5, 0.2)
  local b = color.fromtable{1, 0.5, 0.2}
  framework.compare(true, a == b, 'rgb-rgb color equality')
  
  local c = color.fromrgba(1, 0.5, 0.2, 0.4)
  local d = color.fromtable{1, 0.5, 0.2}
  framework.compare(false, c == d, 'rgba-rgb color equality')
  
  local e = color.fromrgba(1, 0.5, 0.2, 0.4)
  local f = color.fromtable{1, 0.5, 0.2, 0.4}
  framework.compare(true, e == f, 'rgba-rgba color equality')
end

local function add()
  framework.compare(
    color.fromrgba(0.3, 0.4, 0.5),
    color.fromrgba(0.1, 0.2, 0.3):add(color.fromrgba(0.2, 0.2, 0.2))
  )
end

local function sub()
  framework.compare(
    color.fromrgba(0.9, 0.6, 0.3),
    color.fromrgba(1, 0.8, 0.6):sub(color.fromrgba(0.1, 0.2, 0.3))
  )
end

local function mul()
  framework.compare(
    color.fromrgba(0.1, 0.2, 0.3),
    color.fromrgba(0.01, 0.02, 0.03):mul(10)
  )
end

local function div()
  framework.compare(
    color.fromrgba(0.1, 0.08, 0.06),
    color.fromrgba(1, 0.8, 0.6):div(10)
  )
end

local function opadd()
  framework.compare(
    color.fromrgba(0.6, 0.6, 0.6),
    color.fromrgba(0.2, 0.3, 0.4) + color.fromrgba(0.4, 0.3, 0.2)
  )
  
  framework.ensureerror(function()
    return color.fromrgba(1, 1, 1) + 5
  end, 'invalid operation: color + number')

  framework.ensureerror(function()
    return 5 + color.fromrgba(1, 1, 1)
  end, 'invalid operation: number + color')
end

local function opsub()
  framework.compare(
    color.fromrgba(0.9, 0.6, 0.3),
    color.fromrgba(1, 0.8, 0.6) - color.fromrgba(0.1, 0.2, 0.3)
  )
  
  framework.ensureerror(function()
    return color.fromrgba(1, 1, 1) - 5
  end, 'invalid operation: color - number')

  framework.ensureerror(function()
    return 5 - color.fromrgba(1, 1, 1)
  end, 'invalid operation: number - color')
end

local function opmul()
  framework.compare(
    color.fromrgba(0.2, 0.4, 0.6),
    color.fromrgba(0.1, 0.2, 0.3) * 2,
    'color * scalar'
  )
  framework.compare(
    color.fromrgba(0.2, 0.4, 0.6),
    2 * color.fromrgba(0.1, 0.2, 0.3),
    'scalar * color'
  )
  
  framework.ensureerror(function()
    return color.fromrgba(1, 1, 1) * color.fromrgba(1, 1, 1)
  end, 'invalid operation: color * color')
end

local function opdiv()
  framework.compare(
    color.fromrgba(0.5, 0.4, 0.3),
    color.fromrgba(1, 0.8, 0.6) / 2,
    'color / scalar'
  )
  
  framework.ensureerror(function()
    return color.fromrgba(1, 1, 1) / color.fromrgba(1, 1, 1)
  end, 'invalid operation: color / color')
end

local function invert()
  framework.compare(
    color.fromrgba(0.2, 0.4, 0.6),
    color.fromrgba(0.8, 0.6, 0.4):invert()
  )
end

local function opinvert()
  framework.compare(
    color.fromrgba(0.2, 0.4, 0.6),
    -color.fromrgba(0.8, 0.6, 0.4)
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
