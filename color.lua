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

local getmetatable, setmetatable, type, error = getmetatable, setmetatable, type, error

local function clampcolor(a)
  if a < 0 then
    return 0
  elseif a > 255 then
    return 255
  else
    return a
  end
end

local function checkcolor(a)
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
  if checkcolor(a) then
    result = a:clone()
    result:mul(b)
  elseif checkcolor(b) then
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

--- Creates a new color object.
-- @tparam int|table r Red value. Accepted values fall in the range of [0..255].
--   Alternatively, you can pass a table with 3 or more numerical components
--   and omit the rest of the parameters.
-- @tparam int|nil g Green value. Accepted values fall in the range of [0..255].
-- @tparam int|nil b Blue value. Accepted values fall in the range of [0..255].
-- @tparam ?int|nil a Alpha value. Accepted values fall in the range of
--   [0..255]. This component is not required.
-- @treturn color A new color object with the specified component values.
function color.new(r, g, b, a)
  -- support creation from table
  if type(r) == 'table' and #r >= 3 then
    a = r[4]
    b = r[3]
    g = r[2]
    r = r[1]
  end
  -- ensure all parameters are numbers
  if type(r) == 'number' and type(g) == 'number' and type(b) == 'number' and (type(a) == 'nil' or type(a) == 'number') then
    return setmetatable({ clampcolor(r), clampcolor(g), clampcolor(b), a and clampcolor(a) }, mt)
  else
    error('a color requires at least three numerical components')  
  end
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
  if not checkcolor(b) then
    error('cannot add a ' .. type(b) .. ' to a color')
  end
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
  if not checkcolor(b) then
    error('cannot subtract a ' .. type(b) .. ' from a color')
  end
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
  if type(b) ~= 'number' then
    error('cannot multiply a color by a ' .. type(b))
  end
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
  if type(b) ~= 'number' then
    error('cannot divide a color by a ' .. type(b))
  end
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