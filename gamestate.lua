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
local tablex = require('hug.extensions.table')

local gamestate = {}
local mt = { __index = gamestate }

--- Provides a simple abstraction for individual states in a game.
-- **Dependencies:**
--
-- * `extensions.table`
--
-- @type gamestate
-- Typical game state implementation:
-- @usage
-- -- Extend gamestate
-- local mystate = gamestate.extend()
-- -- Use mystate as a metatable so mystate methods can be called on mystate
-- -- instances
-- mystate.__index = mystate
-- -- Constructs a new mystate instance
-- function mystate.new()
--   return setmetatable({ color = {255, 0, 0} }, mystate)
-- end
-- -- The colon syntax turns draw into a method:
-- function mystate:draw()
--   love.graphics.setColor(self.color)
--   love.graphics.rectangle('fill', 0, 0, 200, 200)
-- end

local setmetatable, getmetatable = setmetatable, getmetatable

--- List of supported gamestate callbacks.
-- Each of these callbacks can be implemented on your derived gamestates. This
-- list is a one-to-one mapping of the LÖVE callbacks found
-- [here](http://love2d.org/wiki/love#Callbacks). Note that `errhand`, `load`,
-- `run`, and `threaderror` are omitted.
--
-- This table cannot be directly accessed. Use `gamestate.callbacks()` to
-- retreive a clone of this table.
local callbacks = {
  'draw',
  'focus',
  'keypressed',
  'keyreleased',
  'mousefocus',
  'mousepressed',
  'mousereleased',
  'quit',
  'resize',
  'textinput',
  'update',
  'visible',

  'gamepadaxis',
  'gamepadpressed',
  'gamepadreleased',
  'joystickadded',
  'joystickaxis',
  'joystickhat',
  'joystickpressed',
  'joystickreleased',
  'joystickremoved'
}

-- Climb the __index chain and see if it contains gamestate.
local function isgamestate(t)
  local tmt = getmetatable(t)
  if tmt.__index == mt.__index then
    return true
  elseif tmt.__index then
    return isgamestate(tmt.__index)
  end
  return false
end

--- Default transparency value.
-- If a `gamestate` is transparent, events will be passed to underlying states
-- as long as the active state does not explicitly intercept them. This field
-- is used for all derived gamestates that do not specify their own
-- `transparent` field.
gamestate.transparent = false

--- Checks whether `t` is a valid gamestate.
-- @treturn string|nil The string `'gamestate'` if `t` is a gamestate;
--   otherwise, `nil`.
function gamestate.type(t)
  if isgamestate(t) then
    return 'gamestate'
  else
    return nil
  end
end

--- Creates and returns a new gamestate table.
-- @treturn gamestate A new gamestate.
function gamestate.new()
  local instance = {}
  return setmetatable(instance, mt)
end

--- Returns an empty table that indexes gamestate.
-- This is equivalent to `setmetatable({}, { __index = gamestate})`.
-- @treturn table A table that indexes gamestate.
function gamestate.extend()
  return setmetatable({}, { __index = gamestate})
end

--- Callback invoked when this gamestate becomes the active state in a state machine.
-- @tab oldstate A reference to the previous state.
function gamestate:enter(oldstate)
end

--- Callback invoked when this gamestate is replaced as the active state in a state machine.
-- @tab newstate A reference to the state being transitioned to.
function gamestate:leave(newstate)
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

--- Returns a copy of the callbacks table.
-- @treturn table A copy of the callbacks table.
function gamestate.callbacks()
  return tablex.clone(callbacks)
end

-- set up empty functions for all the supported callbacks
for i = 1, #callbacks do
  local name = callbacks[i]
  gamestate[name] = function(...)
  end
end

return gamestate