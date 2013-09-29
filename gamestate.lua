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
local gamestate = {}
local mt = { __index = gamestate }

local setmetatable = setmetatable

gamestate.isgamestate = true

function gamestate.new()
  local instance = {
    transparent = false
  }
  return setmetatable(instance, mt)
end

function gamestate:onEnter(oldstate)
end

function gamestate:onLeave(newstate)
end

function gamestate:keypressed(key, unicode)
end

function gamestate:keyreleased(key)
end

function gamestate:mousepressed(x, y, button)
end

function gamestate:mousereleased(x, y, button)
end

function gamestate:update(dt)
end

function gamestate:draw()
end

function gamestate:sm(who)
  if who ~= nil then
    self.statemachine = who
  end
  return self.statemachine
end

return gamestate