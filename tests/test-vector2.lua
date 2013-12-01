require('path')
local framework = require('framework')
local vector2   = require('vector2')

local function eq()
  local a = vector2.new(100, 200)
  local b = vector2.new(100, 200)
  framework.compare(true, a == b, 'vector2 equality')
end

local function add()
  framework.compare(
    vector2.new(6, 4),
    vector2.new(1, 3):add(vector2.new(5, 1))
  )
end

local function sub()
  local a = vector2.new(400, 300)
  local b = vector2.new(200, 100)
  local c = a - b
  framework.compare(
    vector2.new(6, 4),
    vector2.new(10, 8):sub(vector2.new(4, 4))
  )
end

local function mul()
  framework.compare(
    vector2.new(10, 8),
    vector2.new(5, 4):mul(2)
  )
end

local function div()
  framework.compare(
    vector2.new(5, 2),
    vector2.new(10, 4):div(2)
  )
end

local function opadd()
  framework.compare(
    vector2.new(6, 8),
    vector2.new(3, 3) + vector2.new(3, 5)
  )
end

local function opsub()
  framework.compare(
    vector2.new(2, 4),
    vector2.new(8, 5) - vector2.new(6, 1)
  )
end

local function opmul()
  framework.compare(
    vector2.new(8, 4),
    vector2.new(2, 1) * 4,
    'vector * scalar'
  )
  framework.compare(
    vector2.new(8, 4),
    4 * vector2.new(2, 1),
    'scalar * vector'
  )
end

local function opdiv()
  framework.compare(
    vector2.new(2, 1),
    vector2.new(8, 4) / 4,
    'vector / scalar'
  )
end

local function normalize()
  local a = 500
  local b = 250
  -- hypotenuse of the right triangle with sides 'a' and 'b'
  local c = math.sqrt(a*a + b*b)
  framework.compare(
    -- create a vector using the normalized values
    vector2.new(a / c, b / c),
    vector2.new(a, b):normalize()
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
  
  { 'normalization', normalize }
}
