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

--- Implements a timer object.
-- @type timer

local module = require('hug.module')
local event = require('hug.event')

local timer = module.new(event.emitter)

--- Constructs a new timer object.
-- @number duration The duration of this timer.
-- @tparam any state User-defined data to attach to this timer.
function timer.new(duration, state)
  local instance = {
    _duration = duration,
    _remaining = duration,
    _state = state,
    cancelled = false
  }
  event.emitter.construct(instance)
  return setmetatable(instance, timer)
end

--- Returns the state associated with this timer.
-- @treturn any
function timer:state()
  return self._state
end

--- Returns how much time remains before this timer is finished.
-- @treturn number
function timer:remaining()
  return self._remaining
end

--- Returns the original duration of this timer.
-- @treturn number
function timer:duration()
  return self._duration
end

--- Evaluates the given function using this timer's percentage to completion.
-- This is equivalent to `f(1 - timer:remaining() / timer:duration())`.
-- @func f The function to evaluate.
-- @treturn any The result of evaluating `f`.
function timer:evaluate(f)
  return f(1 - self._remaining / self._duration)
end

--- Updates this timer.
-- @number dt Amount of time elapsed since the last update.
function timer:update(dt)
  local ostat = self:status()
  self._remaining = math.max(self._remaining - dt, 0)
  local nstat = self:status()
  if nstat ~= ostat and nstat == 'finished' then
    self:emit('expire', self)
  end
end

--- Determines whether or not this timer has finished running.
-- @treturn str The string 'active' if this timer should still be running. If
--   the timer has been cancelled, then this function returns 'cancelled'. If
--   the timer's duration has passed without this timer being cancelled, this
--   function returns 'finished'.
function timer:status()
  if self.cancelled then
    return 'cancelled'
  elseif self._remaining > 0 then
    return 'active'
  elseif self._remaining <= 0 then
    return 'finished'
  end
end

--- Restarts the timer.
-- Clears the cancellation status and resets the remaining time to `duration`
-- if it is present, or the duration the timer was created with.
-- @tparam number duration Duration of the timer.
function timer:restart(duration)
  self.cancelled = false
  self._duration = duration or self._duration
  self._remaining = self._duration
end

--- Flags this timer as cancelled.
-- Cancelled timers will always have the status of 'cancelled'.
function timer:cancel()
  self.cancelled = true
end

return timer
