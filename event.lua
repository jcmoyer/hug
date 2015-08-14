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

local event = module.new()

-- Syntactic sugar for `event:raise(...)`.
function event:__call(...)
  return self:raise(...)
end

-- Syntactic sugar for `event:len()`. NOTE: This metamethod is not available in
-- love2d. Use `event:len()` instead.
function event:__len()
  return self:len()
end

-- Constructs a new event.
function event.new()
  local instance = {
    callbacks = {}
  }
  return setmetatable(instance, event)
end

-- Adds `f` to the list of listeners for this event. When this event is raised,
-- `f` will be called with the same parameters passed to `raise`.
function event:add(f)
  table.insert(self.callbacks, f)
end

-- Removes `f` from this event.
function event:remove(f)
  for i = 1, #self.callbacks do
    if self.callbacks[i] == f then
      return table.remove(self.callbacks, i)
    end
  end
end

-- Removes all listeners from this event.
function event:clear()
  for i = #self.callbacks, 1, -1 do
    table.remove(self.callbacks, i)
  end
end

-- Returns the number of listeners associated with this event.
function event:len()
  return #self.callbacks
end

-- Raises this event. All listeners connected to this event will be called with
-- the same parameters passed to `event:raise()`.
function event:raise(...)
  for i = 1, #self.callbacks do
    self.callbacks[i](...)
  end
end

--
-- Emitter implementation
--
local emitter = module.new()

local eventproxy = {
  -- add nonexistent events to the table
  __index = function(t, k)
    local e = event.new()
    rawset(t, k, e)
    return e
  end
}

local emitterfns = {'emit', 'on', 'removelistener', 'clearlisteners'}

function emitter.new()
  local instance = {
    events = setmetatable({}, eventproxy)
  }
  return setmetatable(instance, emitter)
end

-- Inserts an emitter object into the table `t` named `_emitter`. When
-- instantiating an object, use this function to compose emitter functionality.
-- Returns `t` for convenience.
function emitter.compose(t)
  t._emitter = emitter.new()
  return t
end

-- Declares `t` to have methods similar to `emitter`. The following fields will
-- be assigned:
--
-- * `t.emit`
-- * `t.on`
-- * `t.remove`
-- * `t.clear`
--
-- Use this in combination with `emitter.compose` to add emitter functionality
-- to your own types:
--
-- ```
-- local timer = module.new()
--
-- event.emitter.declare(timer)
-- -- at this point, timer.emit, timer.on, timer.remove, and timer.clear are
-- -- callable functions
--
-- function timer.new()
--   return event.emitter.compose(setmetatable({tickcount = 0}, timer))
-- end
--
-- function timer:tick()
--   self.tickcount = self.tickcount + 1
--   self:emit('tick', self)
-- end
--
-- local t = timer.new()
-- t:on('tick', function(timer)
--   print('timer has ticked ' .. timer.tickcount .. ' time(s)')
-- end)
-- t:tick() -- 'timer has ticked 1 time(s)'
-- t:tick() -- 'timer has ticked 2 time(s)'
-- ```
function emitter.declare(t)
  -- declare wrapper functions on `t`
  for i = 1,#emitterfns do
    local name = emitterfns[i]
    -- since we can't use colon syntax here, we need to declare self
    t[name] = function(self, ...)
      -- here, `self` is an instance of `t`; similar to above, we need to take
      -- its `_emitter` field and call a method on it, passing `emitter` as the
      -- first parameter so that `self` is correct when control is passed to
      -- one of the emitter functions
      local emitter = self._emitter
      return emitter[name](emitter, ...)
    end
  end
end

-- Emits a `name` event. All listeners for `name` will be called with any
-- additional parameters.
function emitter:emit(name, ...)
  self.events[name]:raise(...)
end

-- Adds `f` as a listener for `name` events.
function emitter:on(name, f)
  self.events[name]:add(f)
end

-- Removes `f` from the list of listeners `name` events.
function emitter:removelistener(name, f)
  self.events[name]:remove(f)
end

-- Clears all listeners for `name` events.
function emitter:clearlisteners(name)
  self.events[name]:clear()
end

-- expose `emitter` through the `event` module
event.emitter = emitter

return event
