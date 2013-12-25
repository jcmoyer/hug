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

--- Implements a rectangle object.
-- `rectangle` is implemented as a table with X, Y, width, and height
-- components residing at the indices `1` to `4` respectively. This design
-- choice has the following implications:
--
-- 1. `unpack` can be used to retreive the components of a rectangle as needed.
-- 2. Numerical indices give certain performance benefits due to the way tables
--    are implemented in Lua.
--
-- @type rectangle
-- @usage
-- local a = rectangle.new(0, 0, 32, 32)
-- love.graphics.rectangle('fill', unpack(a))

local rectangle = {}
local mt = {__index = rectangle}

--- Implements binary operator `==` for `rectangle` objects.
-- @tparam rectangle a Rectangle A.
-- @tparam rectangle b Rectangle B.
-- @treturn boolean True if the rectangles are equal; otherwise false.
function mt.__eq(a, b)
  return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

--- Constructs a new `rectangle`.
-- @number x X-coordinate of the rectangle's top-left point.
-- @number y Y-coordinate of the rectangle's top-left point.
-- @number w Width of the rectangle.
-- @number h Height of the rectangle.
function rectangle.new(x, y, w, h)
  local instance = { x, y, w, h }
  return setmetatable(instance, mt)
end

--- Returns the X-coordinate of the left side of the rectangle.
-- @treturn number
function rectangle:x()
  return self[1]
end

--- Returns the Y-coordinate of the top side of the rectangle.
-- @treturn number
function rectangle:y()
  return self[2]
end

--- Returns the width of the rectangle.
-- @treturn number
function rectangle:width()
  return self[3]
end

--- Returns the height of the rectangle.
-- @treturn number
function rectangle:height()
  return self[4]
end

--- Returns the X-coordinate of the right side of the rectangle.
-- @treturn number
function rectangle:right()
  return self[1] + self[3]
end

--- Returns the Y-coordinate of the bottom side of the rectangle.
-- @treturn number
function rectangle:bottom()
  return self[2] + self[4]
end

--- Performs an intersection test with another rectangle.
-- @tparam rectangle r Rectangle to test with.
-- @treturn bool True if the rectangles intersect; otherwise, false.
function rectangle:intersects(r)
  return not (self:bottom() < r[2] or
              self[2] > r:bottom() or
              self[1] > r:right()  or
              self:right() < r[1])
end

--- Test whether or not a point falls within the bounds of this rectangle.
-- @number x X-coordinate of the point.
-- @number y Y-coordinate of the point.
-- @treturn bool True if the point is contained by this rectangle; otherwise,
--   false.
function rectangle:contains(x, y)
  return x >= self[1]      and
         x <= self:right() and
         y >= self[2]      and
         y <= self:bottom()
end

--- Computes the point that lies in the center of this rectangle.
-- @treturn[1] number X-coordinate of the point.
-- @treturn[2] number Y-coordinate of the point.
function rectangle:center()
  return self[1] + self[3] / 2, self[2] + self[4] / 2
end

--- **DEPRECATED**. Unpacks the components that describe this rectangle.
-- @treturn[1] number X-coordinate of this rectangle's top-left point.
-- @treturn[2] number Y-coordinate of this rectangle's top-left point.
-- @treturn[3] number Width of this rectangle.
-- @treturn[4] number Height of this rectangle.
function rectangle:unpack()
  return self[1], self[2], self[3], self[4]
end

return rectangle