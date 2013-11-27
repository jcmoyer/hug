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
local gamestate = {}
local mt = { __index = gamestate }

--- Provides a simple abstraction for individual states in a game.
-- @type gamestate
-- Typical game state implementation:
-- @usage
-- local mystate = setmetatable({}, {__index = gamestate})
-- mystate.__index = mystate
-- function mystate.new()
--   return setmetatable({}, mystate)
-- end
-- function mystate:draw()
--   love.graphics.rectangle('fill', 0, 0, 200, 200)
-- end

local setmetatable = setmetatable

gamestate.isgamestate = true

--- Creates and returns a new gamestate table.
-- @treturn gamestate A new gamestate.
function gamestate.new()
  local instance = {
    transparent = false
  }
  return setmetatable(instance, mt)
end

--- Callback invoked when this gamestate becomes the active state in a state machine.
-- @tab oldstate A reference to the previous state.
function gamestate:onEnter(oldstate)
end

--- Callback invoked when this gamestate is replaced as the active state in a state machine.
-- @tab newstate A reference to the state being transitioned to.
function gamestate:onLeave(newstate)
end

--- Callback invoked when a key is pressed.
-- @string key Character of the key pressed.
-- @number unicode The unicode number of the key pressed.
function gamestate:keypressed(key, unicode)
end

--- Callback invoked when a key is released.
-- @string key Character of the key released.
function gamestate:keyreleased(key)
end

--- Callback invoked when a mouse button is pressed.
-- @number x Mouse X position.
-- @number y Mouse Y position.
-- @string button Mouse button pressed.
function gamestate:mousepressed(x, y, button)
end

--- Callback invoked when a mouse button is released.
-- @number x Mouse X position.
-- @number y Mouse Y position.
-- @string button Mouse button released.
function gamestate:mousereleased(x, y, button)
end

--- Callback invoked when this gamestate needs to update its state.
-- @number dt Time elapsed in seconds.
function gamestate:update(dt)
end

--- Callback invoked when this gamestate needs to draw itself.
function gamestate:draw()
end

--- Gets or sets the `statemachine` associated with this game state.
-- @tparam ?statemachine who If provided, `who` will be stored with this game
--   state.
-- @treturn ?statemachine The `statemachine` associated with this game state.
function gamestate:sm(who)
  if who ~= nil then
    self.statemachine = who
  end
  return self.statemachine
end

return gamestate