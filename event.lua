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

-- Constructs a new event and returns it. An event table directly contains
-- callbacks in the sequence part of the table, so standard table operations
-- can be used.
function event.new()
  local instance = {}
  return setmetatable(instance, event)
end

-- Adds `f` to the list of listeners for this event. When this event is raised,
-- `f` will be called with the same parameters passed to `raise`.
function event:add(f)
  table.insert(self, f)
end

-- Removes `f` from this event.
function event:remove(f)
  for i = 1, #self do
    if self[i] == f then
      return table.remove(self, i)
    end
  end
end

-- Removes all listeners from this event.
function event:clear()
  for i = #self, 1, -1 do
    table.remove(self, i)
  end
end

-- Raises this event. All listeners connected to this event will be called with
-- the same parameters passed to `event:raise()`.
function event:raise(...)
  for i = 1, #self do
    self[i](...)
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
  return setmetatable(emitter.construct(), emitter)
end

-- Inserts an emitter object into the table `t` named `_emitter`. If `t` is
-- `nil`, an empty table will be used. When instantiating an object, use this
-- function to compose emitter functionality. Returns `t` for convenience. If
-- `t` is `nil`, this function returns the constructed table.
function emitter.compose(t)
  if t == nil then
    t = {}
  end
  t._emitter = emitter.new()
  return t
end

-- Inserts an event table into the table `t` named `_events`. If `t` is `nil`,
-- an empty table will be used. When instantiating an object, use this function
-- to inherit emitter functionality. This is suitable for use with
-- `module.new(event.emitter)`. Returns `t` for convenience. If `t` is `nil`,
-- this function returns the constructed table.
function emitter.construct(t)
  if t == nil then
    t = {}
  end
  t._events = setmetatable({}, eventproxy)
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
--
-- This function returns `t` for convenience.
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
  return t
end

-- Emits a `name` event. All listeners for `name` will be called with any
-- additional parameters.
function emitter:emit(name, ...)
  self._events[name]:raise(...)
end

-- Adds `f` as a listener for `name` events.
function emitter:on(name, f)
  self._events[name]:add(f)
end

-- Removes `f` from the list of listeners `name` events.
function emitter:removelistener(name, f)
  self._events[name]:remove(f)
end

-- Clears all listeners for `name` events.
function emitter:clearlisteners(name)
  self._events[name]:clear()
end

-- expose `emitter` through the `event` module
event.emitter = emitter

return event
