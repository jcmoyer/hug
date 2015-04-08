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

-- Adapted from http://gamedev.stackexchange.com/a/18980

--- Implements a 2D camera that chases a target.
-- **Dependencies:**
--
-- * `vector2`
--
-- @type chasecamera

local vector2 = require('hug.vector2')

local chasecamera = {}
local mt = {__index = chasecamera}

--- Creates a new chasecamera.
-- @number width Width of the camera's viewport.
-- @number height Height of the camera viewport.
-- @number stiffness How stiff the camera feels.
-- @number damping How fast the camera should lose velocity. The value should be
--   in the range of [0..1]. A value of 1 means the camera will not lose
--   velocity, and a value of 0 means that velocity will not affect the camera.
-- @number mass How weighty the camera feels.
-- @treturn chasecamera
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

--- Computes the left side of the camera's viewport.
-- @treturn number The X-coordinate of the line segment that runs along the
--   left side of the camera's viewport.
function chasecamera:left()
  return self.position:x() - self.width / 2
end

--- Computes the right side of the camera's viewport.
-- @treturn number The X-coordinate of the line segment that runs along the
--   right side of the camera's viewport.
function chasecamera:right()
  return self.position:x() + self.width / 2
end

--- Computes the top side of the camera's viewport.
-- @treturn number The Y-coordinate of the line segment that runs along the
--   top side of the camera's viewport.
function chasecamera:top()
  return self.position:y() - self.height / 2
end

--- Computes the bottom side of the camera's viewport.
-- @treturn number The Y-coordinate of the line segment that runs along the
--   bottom side of the camera's viewport.
function chasecamera:bottom()
  return self.position:y() + self.height / 2
end

--- Centers the camera on a point instantly.
-- @number x X-coordinate of the point to center on.
-- @number y Y-coordinate of the point to center on.
function chasecamera:center(x, y)
  self.position[1] = x
  self.position[2] = y
end

--- Shakes the camera.
-- @number duration Time to shake the camera for, in seconds.
-- @number[opt=20] magnitude How violently the camera should shake.
function chasecamera:shake(duration, magnitude)
  self.shaketime = duration
  self.shakedur  = duration
  self.shakemag  = magnitude or 20
end

--- Clamps the camera's viewport within a rectangle.
-- The camera's viewport will not be allowed outside of this rectangle.
-- @number x X-coordinate of the rectangle.
-- @number y Y-coordinate of the rectangle.
-- @number r X-coordinate of the right side of the rectangle.
-- @number b Y-coordinate of the bottom side of the rectangle.
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

--- Updates the state of the camera.
-- @number dt Time elapsed, in seconds.
-- @tparam vector2 target Point to chase.
-- @see vector2
function chasecamera:update(dt, target)
  -- TODO: Attempt to optimize excess allocations
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
    self.shakevec:set(0, 0)
  else
    self.shakevec:set(
      math.random() * self.shakemag * (self.shaketime / self.shakedur),
      math.random() * self.shakemag * (self.shaketime / self.shakedur))
  end
end

--- Predicts where the camera will be at a point in the future.
-- @number dt Time elapsed, in seconds.
-- @tparam vector2 target Point to chase.
-- @number a Percent to interpolate by.
-- @treturn[1] number The predicted X coordinate.
-- @treturn[2] number The predicted Y coordinate.
-- @see vector2
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
