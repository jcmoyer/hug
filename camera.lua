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

--- Implements a basic 2D camera.
-- **Dependencies:**
--
-- * `extensions.math`
--
-- @type camera

local camera = {}
local mt = { __index = camera }

local setmetatable = setmetatable
local random = math.random
local mathex = require('hug.extensions.math')
local lerp = mathex.lerp

--- Creates a new camera.
-- @number width Width of the camera's viewport.
-- @number height Height of the camera's viewport.
-- @treturn camera
function camera.new(width, height)
  local instance = {
    x = 0,
    y = 0,
    sx = 0,
    sy = 0,
    sd = 0,
    st = 0,
    sm = 0,
    w = width,
    h = height
  }
  return setmetatable(instance, mt)
end

--- Centers the camera on a point instantly.
-- @number x X-coordinate of the point to center on.
-- @number y Y-coordinate of the point to center on.
function camera:center(x, y)
  self.x = x - self.w / 2
  self.y = y - self.h / 2
end

--- Pans the camera towards a point.
-- @number x X-coordinate of the point to pan towards.
-- @number y Y-coordinate of the point to pan towards.
-- @number a Percent to pan by.
function camera:pan(x, y, a)
  local cx = self.x
  local cy = self.y
  self:center(x, y)
  self.x = lerp(cx, self.x, a)
  self.y = lerp(cy, self.y, a)
end

--- Updates the state of the camera.
-- @number dt Delta time to run simulations for, in seconds.
function camera:update(dt)
  self.st = self.st - dt
  if self.st < 0 then
    self.st = 0
    self.sx = 0
    self.sy = 0
  else
    self.sx = random() * self.sm * (self.st / self.sd)
    self.sy = random() * self.sm * (self.st / self.sd)
  end
end

--- Shakes the camera.
-- @number duration Time to shake the camera for, in seconds.
-- @number[opt=20] magnitude How violently the camera should shake.
function camera:shake(duration, magnitude)
  self.st = duration
  self.sd = duration
  self.sm = magnitude or 20
end

--- Computes the X and Y coordinates of the camera.
-- This function takes shaking into account.
-- @treturn[1] number The X coordinate.
-- @treturn[2] number The Y coordinate.
function camera:position()
  return self.x + self.sx, self.y + self.sy
end

return camera
