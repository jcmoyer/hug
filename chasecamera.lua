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
-- Adapted from http://gamedev.stackexchange.com/a/18980
local vector2 = require('hug.vector2')

local chasecamera = {}
local mt = {__index = chasecamera}

function chasecamera.new(width, height, stiffness, damping, mass)
  local instance = {
    position     = vector2.new(),
    velocity     = vector2.new(),
    
    width  = width  or love.graphics.getWidth(),
    height = height or love.graphics.getHeight(),
    
    stiffness = stiffness,
    damping   = damping,
    mass      = mass,
    
    shaketime = 0,
    shakedur  = 0,
    shakemag  = 0,
    shakevec  = vector2.new()
  }
  return setmetatable(instance, mt)
end

function chasecamera:left()
  return self.position:x() - self.width / 2
end

function chasecamera:right()
  return self.position:x() + self.width / 2
end

function chasecamera:top()
  return self.position:y() - self.height / 2
end

function chasecamera:bottom()
  return self.position:y() + self.height / 2
end

function chasecamera:center(x, y)
  self.position[1] = x
  self.position[2] = y
end

function chasecamera:shake(duration, magnitude)
  self.shaketime = duration
  self.shakedur  = duration
  self.shakemag  = magnitude or math.random() * 20
end

function chasecamera:clamp(x, y, r, b)
  local halfw = self.width / 2
  local halfh = self.height / 2
  
  local origx = self.position[1]
  local origy = self.position[2]
  
  self.position[1] = math.max(self.position[1] - halfw, x) + halfw
  self.position[2] = math.max(self.position[2] - halfh, y) + halfh
  self.position[1] = math.min(self.position[1] + halfw, r) - halfw
  self.position[2] = math.min(self.position[2] + halfh, b) - halfh
  
  -- TODO: Revisit epsilon comparison
  -- It may be possible to simply floor each number before comparison
  if math.abs(self.position[1] - origx) > 0.0001 then
    self.velocity[1] = 0
  end
  if math.abs(self.position[2] - origy) > 0.0001 then
    self.velocity[2] = 0
  end
end

-- TODO: Attempt to optimize excess allocations
function chasecamera:update(dt, target)
  local stretch = self.position - target
  local force   = -self.stiffness * stretch - self.damping * self.velocity
  
  local acceleration = force / self.mass
  
  acceleration:mul(dt)
  self.velocity:add(acceleration)
  self.velocity:mul(dt)
  self.position:add(self.velocity)
  
  -- process screen shake
  self.shaketime = self.shaketime - dt
  if self.shaketime < 0 then
    self.shaketime = 0
    self.shakevec:zero()
  else
    self.shakevec:zero()
    self.shakevec:set(
      math.random() * self.shakemag * (self.shaketime / self.shakedur),
      math.random() * self.shakemag * (self.shaketime / self.shakedur))
  end
end

function chasecamera:predict(dt, target, a)
  local stretch = self.position - target
  local force   = -self.stiffness * stretch - self.damping * self.velocity
  
  local acceleration = force / self.mass
  
  acceleration:mul(dt)
  
  local velocity = self.velocity:clone()
  
  velocity:add(acceleration)
  velocity:mul(dt)
  
  local position = self.position:clone()
  
  position:add(self.velocity * a)
  
  return position:x() + self.shakevec:x(), position:y() + self.shakevec:y()
end

return chasecamera