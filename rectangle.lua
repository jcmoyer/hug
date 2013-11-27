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
-- @type rectangle

local rectangle = {}
local mt = {__index = rectangle}

--- Constructs a new `rectangle`.
-- @number x X-coordinate of the rectangle's top-left point.
-- @number y Y-coordinate of the rectangle's top-left point.
-- @number w Width of the rectangle.
-- @number h Height of the rectangle.
function rectangle.new(x, y, w, h)
  local instance = {
    x = x,
    y = y,
    w = w,
    h = h
  }
  return setmetatable(instance, mt)
end

--- Returns the X-coordinate of the right side of the rectangle.
-- @treturn number
function rectangle:right()
  return self.x + self.w
end

--- Returns the Y-coordinate of the bottom side of the rectangle.
-- @treturn number
function rectangle:bottom()
  return self.y + self.h
end

--- Performs an intersection test with another rectangle.
-- @tparam rectangle r Rectangle to test with.
-- @treturn bool True if the rectangles intersect; otherwise, false.
function rectangle:intersects(r)
  return not (self:bottom() < r.y or
              self.y > r:bottom() or
              self.x > r:right()  or
              self:right() < r.x)
end

--- Test whether or not a point falls within the bounds of this rectangle.
-- @number x X-coordinate of the point.
-- @number y Y-coordinate of the point.
-- @treturn bool True if the point is contained by this rectangle; otherwise,
--   false.
function rectangle:contains(x, y)
  return x >= self.x       and
         x <= self:right() and
         y >= self.y       and
         y <= self:bottom()
end

--- Computes the point that lies in the center of this rectangle.
-- @treturn[1] number X-coordinate of the point.
-- @treturn[2] number Y-coordinate of the point.
function rectangle:center()
  return self.x + self.w / 2, self.y + self.h / 2
end

--- Unpacks the components that describe this rectangle.
-- @treturn[1] number X-coordinate of this rectangle's top-left point.
-- @treturn[2] number Y-coordinate of this rectangle's top-left point.
-- @treturn[3] number Width of this rectangle.
-- @treturn[4] number Height of this rectangle.
function rectangle:unpack()
  return self.x, self.y, self.w, self.h
end

return rectangle