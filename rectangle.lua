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
-- 1. `unpack` can be used to retrieve the components of a rectangle as needed.
-- 2. Numerical indices give certain performance benefits due to the way tables
--    are implemented in Lua.
--
-- @type rectangle
-- @usage
-- local a = rectangle.new(0, 0, 32, 32)
-- love.graphics.rectangle('fill', unpack(a))

local module = require('hug.module')

local rectangle = module.new()

local function isrectangle(t)
  return getmetatable(t) == rectangle
end

--- Implements binary operator `==` for `rectangle` objects.
-- @tparam rectangle a Rectangle A.
-- @tparam rectangle b Rectangle B.
-- @treturn boolean True if the rectangles are equal; otherwise false.
function rectangle.__eq(a, b)
  return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

--- Implements `tostring` for `rectangle` objects.
-- Do not use this method for serialization as the format may change in the
-- future. This method only guarantees that `rectangle` objects can be
-- converted to a human-readable representation.
-- @treturn string A `string` representation for this vector.
function rectangle:__tostring()
  return self[1] .. ',' .. self[2] .. ',' .. self[3] .. ',' .. self[4]
end

--- Constructs a new `rectangle`.
-- @number[opt=0] x X-coordinate of the rectangle's top-left point.
-- @number[opt=0] y Y-coordinate of the rectangle's top-left point.
-- @number[opt=0] w Width of the rectangle.
-- @number[opt=0] h Height of the rectangle.
function rectangle.new(x, y, w, h)
  local instance = { x or 0, y or 0, w or 0, h or 0 }
  return setmetatable(instance, rectangle)
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

--- Computes the rectangle formed from the area of two overlapping rectangles.
-- @tparam rectangle r Rectangle to intersect with.
-- @treturn rectangle|nil If the rectangles intersect, this function returns
--   the rectangle formed from the overlapping area between them. If the
--   given rectangles do not intersect, this function returns `nil`.
function rectangle:intersect(r)
  local xmin = math.max(self[1], r[1])
  local ymin = math.max(self[2], r[2])
  local xmax = math.min(self:right(), r:right())
  local ymax = math.min(self:bottom(), r:bottom())
  if (xmax < xmin or ymax < ymin) then
    return nil
  end
  return rectangle.new(xmin, ymin, xmax - xmin, ymax - ymin)
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

--- Computes the rectangle that contains two given rectangles.
-- @tparam rectangle r Rectangle to compute the union rectangle with.
-- @treturn rectangle The rectangle that contains the given rectangles.
function rectangle:union(r)
  local xmin = math.min(self[1], r[1])
  local ymin = math.min(self[2], r[2])
  local xmax = math.max(self:right(), r:right())
  local ymax = math.max(self:bottom(), r:bottom())
  return rectangle.new(xmin, ymin, xmax - xmin, ymax - ymin)
end

--- Determines whether or not this rectangle contains a point or rectangle.
-- @tparam number|rectangle x If `x` is a number, it is treated as the
--   X-coordinate of a point. If `x` is a `rectangle`, this function determines
--   whether or not `x` is completely bounded by this rectangle.
-- @tparam number|nil y Y-coordinate of the point. This parameter is ignored if
--   `x` is a `rectangle`.
-- @treturn bool True if the point or rectangle is contained by this rectangle;
--   otherwise, false.
function rectangle:contains(x, y)
  if isrectangle(x) then
    return x[1] >= self[1] and x[2] >= self[2] and
           x:right() <= self:right() and x:bottom() <= self:bottom()
  else
    return x >= self[1] and x <= self:right() and
           y >= self[2] and y <= self:bottom()
  end
end

--- Computes the point that lies in the center of this rectangle.
-- @treturn[1] number X-coordinate of the point.
-- @treturn[2] number Y-coordinate of the point.
function rectangle:center()
  return self[1] + self[3] / 2, self[2] + self[4] / 2
end

--- Inflates this rectangle by the specified amount.
-- The rectangle is enlarged in both directions on each axis by the exact
-- amount specified. This means that inflating a 20 by 50 rectangle by 10 and
-- 20 will result in a 40 by 90 rectangle concentric with the original.
-- @number x Amount to inflate this rectangle on the X-axis.
-- @number y Amount to inflate this rectangle on the Y-axis.
function rectangle:inflate(x, y)
  self[1] = self[1] - x
  self[3] = self[3] + x * 2
  self[2] = self[2] - y
  self[4] = self[4] + y * 2
end

--- Moves this rectangle by the given vector.
-- @number x Amount to move this rectangle by on the X-axis.
-- @number y Amount to move this rectangle by on the Y-axis.
function rectangle:offset(x, y)
  self[1] = self[1] + x
  self[2] = self[2] + y
end

-- Clones this rectangle and returns the clone.
function rectangle:clone()
  return rectangle.new(unpack(self))
end

return rectangle
