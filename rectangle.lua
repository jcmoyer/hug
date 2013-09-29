--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
local rectangle = {}
local mt = {__index = rectangle}

function rectangle.new(x, y, w, h)
  local instance = {
    x = x,
    y = y,
    w = w,
    h = h
  }
  return setmetatable(instance, mt)
end

function rectangle:right()
  return self.x + self.w
end

function rectangle:bottom()
  return self.y + self.h
end

function rectangle:intersects(r)
  return not (self:bottom() < r.y or
              self.y > r:bottom() or
              self.x > r:right()  or
              self:right() < r.x)
end

function rectangle:contains(x, y)
  return x >= self.x       and
         x <= self:right() and
         y >= self.y       and
         y <= self:bottom()
end

function rectangle:center()
  return self.x + self.w / 2, self.y + self.h / 2
end

function rectangle:unpack()
  return self.x, self.y, self.w, self.h
end

return rectangle