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

local module = require('hug.module')
local animation = require('hug.anim.animation')

local set = module.new()

-- Returns the number of animations in this animation set. NOTE: This
-- metamethod is not available in love2d due to the way luajit is compiled. Use
-- set:len() instead.
function set:__len()
  return self:len()
end

-- Creates a new animation set and returns it.
function set.new()
  local instance = {
    animations = {}
  }
  return setmetatable(instance, set)
end

-- Adds an animation `a` to this set as `name` and returns `a`.
function set:add(name, a)
  table.insert(self.animations, a)
  self.animations[name] = a
  return a
end

-- Returns the animation in this set named `name`, or `nil` if it doesn't
-- exist.
function set:animation(name)
  return self.animations[name]
end

-- Returns the first animation in the set.
function set:first()
  return self.animations[1]
end

-- Returns the number of animations in this animation set.
function set:len()
  return #self.animations
end

return set
