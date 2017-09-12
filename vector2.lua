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

-- Implements a 2D vector type.
-- `vector2` is implemented as a table with X and Y components residing at
-- indices `1` and `2`, respectively. This design choice has the following
-- implications:
--
-- 1. `unpack` can be used to retrieve the components of a vector as needed.
-- 2. Numerical indices give certain performance benefits due to the way tables
--    are implemented in Lua.
--
-- @type vector2
-- @usage
-- local a = vector2.new(3, 4)
-- local b = vector2.new(5, 2)
-- -- allocates a new vector:
-- local c = a + b
-- -- modifies vector b in-place:
-- b:sub(a)
--
-- -- unpack allows you to pass vector components into functions:
-- love.graphics.translate(unpack(c))

local module = require('hug.module')

local vector2 = module.new()

local function isvector2(v)
  return getmetatable(v) == vector2
end

-- Implements binary operator `+` for `vector2` objects.
-- @tparam vector2 a The first vector.
-- @tparam vector2 b The second vector.
-- @treturn vector2 The result of adding `a` and `b`.
function vector2.__add(a, b)
  return a:clone():add(b)
end

-- Implements binary operator `-` for `vector2` objects.
-- @tparam vector2 a The first vector.
-- @tparam vector2 b The second vector.
-- @treturn vector2 The result of subtracting `b` from `a`.
function vector2.__sub(a, b)
  return a:clone():sub(b)
end

-- Implements binary operator `*` for `vector2` objects.
-- @tparam vector2|number a The first vector or scalar.
-- @tparam number|vector2 b The second vector or scalar.
-- @treturn vector2 The result of multiplying `a` by `b`.
function vector2.__mul(a, b)
  local result
  if isvector2(a) then
    result = a:clone()
    result:mul(b)
  else
    result = b:clone()
    result:mul(a)
  end
  return result
end

-- Implements binary operator `/` for `vector2` objects.
-- @tparam vector2 a The vector.
-- @number b The scalar.
-- @treturn vector2 A new `vector2` containing the results of the division.
function vector2.__div(a, b)
  return a:clone():div(b)
end

-- Implements binary operator `==` for `vector2` objects.
-- @tparam vector2 a Vector A.
-- @tparam vector2 b Vector B.
-- @treturn boolean True if the vectors are equal; otherwise false.
function vector2.__eq(a, b)
  return a[1] == b[1] and a[2] == b[2]
end

-- Implements `tostring` for `vector2` objects.
-- Do not use this method for serialization as the format may change in the
-- future. This method only guarantees that `vector2` objects can be converted
-- to a human-readable representation.
-- @treturn string A `string` representation for this vector.
function vector2:__tostring()
  return string.format('<%f,%f>', self[1], self[2])
end

-- Creates a new vector2 object.
-- @number[opt=0] x The X component for this vector. Defaults to 0 if none is
--   provided.
-- @number[opt=0] y The Y component for this vector. Defaults to 0 if none is
--   provided.
-- @treturn vector2 A new vector 2 object with the specified magnitude.
function vector2.new(x, y)
  local instance = {
    x or 0,
    y or 0
  }
  return setmetatable(instance, vector2)
end

-- Creates a new vector2 object from polar coordinates.
-- @number r The radial coordinate.
-- @number phi The polar angle.
-- @treturn vector2 A new vector 2 object with the specified radial coordinate and angle.
function vector2.frompolar(r, phi)
  local x = r * math.cos(phi)
  local y = r * math.sin(phi)
  return vector2.new(x, y)
end

-- Clones this vector2 and returns it.
-- @treturn vector2
function vector2:clone()
  return vector2.new(unpack(self))
end

-- Returns the X component of this vector.
-- This is equivalent to vector[1].
-- @treturn number The X component of this vector.
function vector2:x()
  return self[1]
end

-- Returns the Y component of this vector.
-- This is equivalent to vector[2].
-- @treturn number The Y component of this vector.
function vector2:y()
  return self[2]
end

-- Computes the length of this vector.
-- @treturn number The length of this vector.
function vector2:len()
  local x = self[1]
  local y = self[2]
  return math.sqrt(x * x + y * y)
end

-- Computes the dot product between this vector and another.
-- @tparam vector2 vec The second vector.
-- @treturn number The dot product between the given vectors.
function vector2:dot(vec)
  return self[1] * vec[1] + self[2] * vec[2]
end

-- Adds another vector to this one.
-- @tparam vector2|number a If a `vector2` is provided, each of its components
--   will be added to the components of this vector. If a number is provided
--   instead, it will be added to the X component of this vector.
-- @number b Amount to add to the Y component of this vector. Only required if
--   `a` is not a `vector2`.
-- @treturn vector2 This vector.
function vector2:add(a, b)
  if isvector2(a) then
    self[1] = self[1] + a[1]
    self[2] = self[2] + a[2]
  else
    self[1] = self[1] + a
    self[2] = self[2] + b
  end
  return self
end

-- Subtracts another vector from this one.
-- @tparam vector2|number a If a `vector2` is provided, its components will be
--   subtracted from the components of this vector. If a number is provided
--   instead, it will be subtracted from the X component of this vector.
-- @number b Amount to subtract from the Y component of this vector. Only
--   required if `a` is not a `vector2`.
-- @treturn vector2 This vector.
function vector2:sub(a, b)
  if isvector2(a) then
    self[1] = self[1] - a[1]
    self[2] = self[2] - a[2]
  else
    self[1] = self[1] - a
    self[2] = self[2] - b
  end
  return self
end

-- Multiplies this vector by a scalar amount.
-- @number a Amount to multiply this vector by.
-- @treturn vector2 This vector.
function vector2:mul(a)
  self[1] = self[1] * a
  self[2] = self[2] * a
  return self
end

-- Divides this vector by a scalar amount.
-- @number a Amount to divide this vector by.
-- @treturn vector2 This vector.
function vector2:div(a)
  self[1] = self[1] / a
  self[2] = self[2] / a
  return self
end

-- Normalizes this vector.
-- This vector will become a unit vector codirectional with the original
-- vector.
-- @treturn vector2 This vector.
function vector2:normalize()
  local x = self[1]
  local y = self[2]
  local l = math.sqrt(x * x + y * y)
  self[1] = x / l
  self[2] = y / l
  return self
end

-- Sets the individual components of this vector.
-- @number x New value for the X component of this vector.
-- @number y New value for the Y component of this vector.
-- @treturn vector2 This vector.
function vector2:set(x, y)
  self[1] = x
  self[2] = y
  return self
end

return vector2
