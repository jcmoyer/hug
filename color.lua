--
-- Copyright 2013 J.C. Moyer
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--   http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

--- Implements a basic color object compatible with LÖVE graphics functions.
-- @type color
-- @usage
-- local red = color.new(255, 0, 0)
-- love.graphics.setColor(red)

local color = {}
local mt = { __index = color }

local assert, error = assert, error
local getmetatable, setmetatable, type = getmetatable, setmetatable, type
-- 5.2+ compatibility
local unpack = unpack or table.unpack

local function clampcolor(a)
  if a < 0 then
    return 0
  elseif a > 255 then
    return 255
  else
    return a
  end
end

local function iscolor(a)
  return getmetatable(a) == mt
end

--- Implements binary operator `+` for colors.
-- This is equivalent to `a:clone():add(b)`.
-- @tparam color a
-- @tparam color b
-- @treturn color The result of adding colors `a` and `b`.
function mt.__add(a, b)
  return a:clone():add(b)
end

--- Implements binary operator `-` for colors.
-- This is equivalent to `a:clone():sub(b)`.
-- @tparam color a
-- @tparam color b
-- @treturn color The result of subtracting `b` from `a`.
function mt.__sub(a, b)
  return a:clone():sub(b)
end

--- Implements binary operator `*` for colors.
-- This is equivalent to `a:clone():mul(b)` or `b:clone():mul(a)` depending on
--   the order of the parameters.
-- @tparam color|number a
-- @tparam number|color b
-- @treturn color The result of multiplying `a` and `b`.
function mt.__mul(a, b)
  local result
  if iscolor(a) then
    result = a:clone()
    result:mul(b)
  elseif iscolor(b) then
    result = b:clone()
    result:mul(a)
  else
    error('no colors given')
  end
  return result
end

--- Implements binary operator `/` for colors.
-- This is equivalent to `a:clone():div(b)`.
-- @tparam color a
-- @number b
-- @treturn color The result of dividing `a` by `b`.
function mt.__div(a, b)
  return a:clone():div(b)
end

--- Implements unary operator `-` for colors.
-- This is equivalent to `a:clone():invert()`.
-- @tparam color a
-- @treturn color The result of inverting `a`.
function mt.__unm(a)
  return a:clone():invert()
end

--- Implements binary operator `==` for `color` objects.
-- @tparam color a Color A.
-- @tparam color b Color B.
-- @treturn boolean True if the colors are equal; otherwise false.
function mt.__eq(a, b)
  return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

--- Implements `tostring` for `color` objects.
-- Do not use this method for serialization as the format may change in the
-- future. This method only guarantees that `color` objects can be converted
-- to a human-readable representation.
-- @treturn string A `string` representation for this color.
function mt:__tostring()
  if #self == 3 then
    return string.format('rgb(%d,%d,%d)', self[1], self[2], self[3])
  elseif #self == 4 then
    return string.format('rgba(%d,%d,%d,%d)', self[1], self[2], self[3], self[4])
  else
    return '<invalid color>'
  end
end

--- Determines what kind of color the given table is.
-- @tab t Table to test.
-- @treturn string|nil If `t` is a color, `'rgb'` or `'rgba'`; otherwise,
--   `nil`.
function color.type(t)
  if iscolor(t) then
    if #t == 3 then
      return 'rgb'
    elseif #t == 4 then
      return 'rgba'
    end
  end
  return nil
end

--- Creates a new color object given RGBA values.
-- @tparam int r Red value. Accepted values fall in the range of [0..255].
-- @tparam int g Green value. Accepted values fall in the range of [0..255].
-- @tparam int b Blue value. Accepted values fall in the range of [0..255].
-- @tparam ?int a Alpha value. Accepted values fall in the range of
--   [0..255]. This component is not required.
-- @treturn color A new color object with the specified component values.
function color.fromrgba(r, g, b, a)
  assert(type(r) == 'number')
  assert(type(g) == 'number')
  assert(type(b) == 'number')
  assert(type(a) == 'number' or type(a) == 'nil')
  
  local instance = {
    clampcolor(r),
    clampcolor(g),
    clampcolor(b),
    a and clampcolor(a)
  }
  return setmetatable(instance, mt)
end

--- Creates a new color object from a table.
-- @tparam table t A sequence table containing RGBA components in slots 1 to 4.
-- @treturn color A new color object with the specified component values.
function color.fromtable(t)
  assert(type(t) == 'table', 'table required')
  assert(#t >= 3, 'a color requires at least three numerical components')
  
  return color.fromrgba(unpack(t))
end

--- Clones a color object.
-- @treturn color A new color object with the same values as the source color.
function color:clone()
  return setmetatable({self[1], self[2], self[3], self[4]}, mt)
end

--- Adds another color to this one.
-- @tparam color b Color to add.
-- @treturn color This color.
function color:add(b)
  assert(iscolor(b), 'cannot add a ' .. type(b) .. ' to a color')
  -- All colors will have at least three components
  self[1] = clampcolor(self[1] + b[1])
  self[2] = clampcolor(self[2] + b[2])
  self[3] = clampcolor(self[3] + b[3])
  if #self == 4 and #b == 4 then
    self[4] = clampcolor(self[4] + b[4])
  end
  return self
end

--- Subtracts another color from this one.
-- @tparam color b Color to subtract.
-- @treturn color This color.
function color:sub(b)
  assert(iscolor(b), 'cannot subtract a ' .. type(b) .. ' from a color')
  -- All colors will have at least three components
  self[1] = clampcolor(self[1] - b[1])
  self[2] = clampcolor(self[2] - b[2])
  self[3] = clampcolor(self[3] - b[3])
  if #self == 4 and #b == 4 then
    self[4] = clampcolor(self[4] - b[4])
  end
  return self
end

--- Multiplies this color by a number.
-- This operation works the same way as vector-scalar multiplication.
-- @number b Amount to scale the color by.
-- @treturn color This color.
function color:mul(b)
  assert(type(b) == 'number', 'cannot multiply a ' .. type(b) .. ' by a color')
  self[1] = clampcolor(self[1] * b)
  self[2] = clampcolor(self[2] * b)
  self[3] = clampcolor(self[3] * b)
  if #self == 4 then
    self[4] = clampcolor(self[4] * b)
  end
  return self
end

--- Divides this color by a number.
-- @number b Amount to scale the color by.
-- @treturn color This color.
function color:div(b)
  assert(type(b) == 'number', 'cannot divide a ' .. type(b) .. ' by a color')
  self[1] = clampcolor(self[1] / b)
  self[2] = clampcolor(self[2] / b)
  self[3] = clampcolor(self[3] / b)
  if #self == 4 then
    self[4] = clampcolor(self[4] / b)
  end
  return self
end

--- Inverts this color.
-- @treturn color This color.
function color:invert()
  self[1] = 255 - self[1]
  self[2] = 255 - self[2]
  self[3] = 255 - self[3]
  if #self == 4 then
    self[4] = 255 - self[4]
  end
  return self
end

return color
