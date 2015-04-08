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

--- Manages a collection of timers.
-- **Dependencies:**
--
-- * `timer`
--

local timer = require('hug.timer')

local timerpool = {}
local mt = { __index = timerpool }

local remove = table.remove

function timerpool.new()
  local instance = {
    timers = {}
  }
  return setmetatable(instance, mt)
end

--- Starts a new timer.
-- @number duration Amount of time, in seconds, this timer will expire in.
-- @func callback Function to run when the timer expires. The callback will
--   receive the expiring timer as a parameter. If you need to associate extra
--   information with the callback, consider providing a table with a `__call`
--   metamethod for this parameter.
-- @treturn timer The newly started timer.
function timerpool:start(duration, callback)
  local t = timer.new(duration, callback)
  self.timers[#self.timers + 1] = t
  return t
end

--- Clears the timerpool's internal collection of timers.
-- This function is useful if you need a fresh timerpool, but you don't want to
-- allocate a new one.
function timerpool:clear()
  for i = 1, #self.timers do
    self.timers[i] = nil
  end
end

--- Returns the number of timers in this timerpool.
function timerpool:size()
  return #self.timers
end

--- Updates the timerpool.
-- This updates all the timers that this timerpool is managing. Timers that
-- have expired will have their callbacks executed, and the timers themselves
-- will be removed from the timerpool.
-- @number dt Time elapsed in seconds.
function timerpool:update(dt)
  for i = #self.timers, 1, -1 do
    local t = self.timers[i]
    t:update(dt)
   
    local status = t:status()
    local removable = status ~= 'active'
    
    -- only invoke callbacks on finished timers
    if status == 'finished' then
      local f = t:state()
      if f then f(t) end
    end
    
    if removable then
      remove(self.timers, i)
    end
  end
end

return timerpool
