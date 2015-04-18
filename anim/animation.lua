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
local frame = require('hug.anim.frame')

local animation = module.new()

-- Returns the number of frames in this animation.
function animation:__len()
  return #self.frames
end

-- Creates a new animation and returns it.
function animation.new()
  local instance = {
    frames = {}
  }
  return setmetatable(instance, animation)
end

-- Adds a frame `f` to this animation and returns `f`.
function animation:add(f)
  table.insert(self.frames, f)
  return f
end

-- Returns frame `n` in this animation's sequence of frames. If there is no
-- frame `n`, this method returns nil.
function animation:frame(n)
  return self.frames[n]
end

return animation
