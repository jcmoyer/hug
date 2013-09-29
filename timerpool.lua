--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
local timerpool = {}
local timers = {}

local remove = table.remove

function timerpool.start(duration, callback)
  local remaining = duration
  local timer = {}
  function timer.getCallback()
    return callback
  end
  function timer.getRemaining()
    return remaining
  end
  function timer.getDuration()
    return duration
  end
  function timer.update(dt)
    remaining = remaining - dt
  end
  function timer.finished()
    return remaining <= 0
  end
  
  timers[#timers + 1] = timer
  
  return timer
end

function timerpool.update(dt)
  for i = #timers, 1, -1 do
    local t = timers[i]
    t.update(dt)
    if t.finished() then
      local f = t.getCallback()
      if f then f() end
      remove(timers, i)
    end
  end
end

return timerpool