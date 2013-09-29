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
local camera = {}
local mt = { __index = camera }

local setmetatable = setmetatable
local random = math.random
local mathex = require('hug.extensions.math')
local lerp = mathex.lerp

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

function camera:center(x, y)
  self.x = x - self.w / 2
  self.y = y - self.h / 2
end

function camera:panCenter(x, y, dt)
  local cx = self.x
  local cy = self.y
  self:center(x, y)
  self.x = lerp(cx, self.x, dt * 3)
  self.y = lerp(cy, self.y, dt * 3)
end

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

function camera:shake(duration, magnitude)
  self.st = duration
  self.sd = duration
  self.sm = magnitude or random() * 20
end

function camera:calculatedX()
  return self.x + self.sx
end

function camera:calculatedY()
  return self.y + self.sy
end

return camera
