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

local timer = require('hug.timer')

local timerpool = {}
local timers = {}

local remove = table.remove

--- Starts a new timer.
-- @number duration Amount of time, in seconds, this timer will expire in.
-- @func callback Function to run when the timer expires.
-- @treturn timer The newly started timer.
function timerpool.start(duration, callback)
  local t = timer.new(duration, callback)
  timers[#timers + 1] = t
  return t
end

--- Updates the timerpool.
-- This updates all the timers that this timerpool is managing. Timers that
-- have expired will have their callbacks executed, and the timers themselves
-- will be removed from the timerpool.
-- @number dt Time elapsed in seconds.
function timerpool.update(dt)
  for i = #timers, 1, -1 do
    local t = timers[i]
    t:update(dt)
   
    local status = t:status()
    
    -- true if the timer is removable
    local r = status ~= 'active'
    
    -- only invoke callbacks on finished timers
    if status == 'finished' then
      local f = t:state()
      if f then f() end
    end
    
    -- remove the dead timer
    if r then
      remove(timers, i)
    end
  end
end

return timerpool