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

-- Connects `f` to this event. When this event is raised, `f` will be called
-- with the same parameters passed to `raise`.
function event:connect(f)
  table.insert(self.callbacks, f)
end

-- Disconnects `f` from this event.
function event:disconnect(f)
  for i = 1, #self.callbacks do
    if self.callbacks[i] == f then
      return table.remove(self.callbacks, i)
    end
  end
end

-- Disconnects all functions from this event.
function event:clear()
  for i = #self.callbacks, 1, -1 do
    table.remove(self.callbacks, i)
  end
end

-- Returns the number of functions connected to this event.
function event:len()
  return #self.callbacks
end

-- Raises this event. This calls all functions that have been connected to this
-- event.
function event:raise(...)
  for i = 1, #self.callbacks do
    self.callbacks[i](...)
  end
end

return event
