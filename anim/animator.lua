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
local event = require('hug.event')

local animator = module.new(event.emitter)

-- Constructs and returns a new animator. An animator contains all the state
-- required to 
function animator.new(set)
  assert(set, 'animation set must be provided')
  assert(set:len() > 0, 'animation set must have at least one animation')
  local instance = {
    set = set,
    anim = set:first(),
    time = 0,
    frameidx = 1,
    -- 'playing' | 'paused' | 'stopped'
    state = 'stopped'
  }
  event.emitter.construct(instance)
  return setmetatable(instance, animator)
end

-- Switches the currently playing animation to `name`. If `name` is already
-- playing, this function does nothing.
function animator:play(name)
  self.state = 'playing'
  local anim = self.set:animation(name)
  if self.anim == anim then
    return
  end
  self.anim = anim
  self.time = 0
  self.frameidx = 1
end

-- Restarts the currently playing animation.
function animator:restart()
  self.time = 0
  self.frameidx = 1
  self.state = 'playing'
end

-- Pauses the currently playing animation.
function animator:pause()
  self.state = 'paused'
end

-- Stops the currently playing animation and immediately returns to the first
-- frame.
function animator:stop()
  self.time = 0
  self.frameidx = 1
  self.state = 'stopped'
end

-- Updates this animator, switching the currently active frame if enough time
-- has passed. `dt` is delta time.
--
-- Emits an `end` event if the animation has reached the final frame and needs
-- to loop around. The animator will be passed as a parameter.
--
-- NOTE: If a frame doesn't have a duration, the animator will stop changing
-- frames.
function animator:update(dt)
  if self.state ~= 'playing' then
    return
  end
  local frame = self:frame()
  if not frame then
    return
  end
  if not frame:duration() then
    return
  end
  self.time = self.time + dt
  while self.time >= frame:duration() do
    self.time = self.time - frame:duration()
    frame = self:advance()
  end
end

-- Advances the animation by one frame and returns the new frame.
-- Emits an `end` event if the animation has reached the final frame and needs
-- to loop around. The animator will be passed as a parameter.
function animator:advance()
  self.frameidx = self.frameidx + 1
  local frame = self:frame()
  -- we're past the last frame; go back to frame 1
  if not frame then
    self.frameidx = 1
    frame = self:frame()
    self:emit('end', self)
  end
  return frame
end

-- Returns the currently active frame for this animator. If there are no frames
-- in the animation, this function returns `nil`.
function animator:frame()
  -- TODO: remove this check because we enforce existence in ctor?
  if not self.anim then
    return nil
  end
  return self.anim:frame(self.frameidx)
end

-- Returns the attachment by `name` for the currently active frame. If there is
-- no attachment by `name` this function returns `nil`.
function animator:attachment(name)
  local f = self:frame()
  if not f then
    return nil
  end
  return f:attachment(name)
end

-- Returns the status of this animator; it is one of the following values:
--
-- * 'stopped' - the animator is stopped; playing it will start it from the
--   beginning
-- * 'playing' - the animator is currently playing
-- * 'paused' - the animator is currently paused; playing it will resume
--   animation from the point it was paused at
function animator:status()
  return self.state
end

return animator
