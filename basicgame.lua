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

--- Provides a basic framework for a game.
-- **Dependencies:**
--
-- * `statemachine`
-- * `gamestate`

local statemachine = require('hug.statemachine')
local gamestate = require('hug.gamestate')

local basicgame = {}

--- Creates a state machine and hooks it into LÖVE callbacks.
-- When this function is called, a state machine will be created and
-- `initialstate` will be pushed onto the top of the stack.
-- This function will then set the LÖVE callbacks listed in
-- `gamestate.callbacks`, plus `love.load`.
--
-- These events will be forwarded to the state machine, which in turn will
-- dispatch them to the appropriate game state.
--
-- @tparam gamestate initialstate the state to start the basicgame with
-- @treturn statemachine the created state machine
-- @see statemachine
-- @see gamestate
-- @see gamestate.callbacks
function basicgame.start(initialstate)  
  local sm = statemachine.new()
  
  local callbacks = gamestate.callbacks()
  for i = 1, #callbacks do
    local name = callbacks[i]
    love[name] = function(...)
      sm[name](sm, ...)
    end
  end
  
  function love.load()
    sm:push(initialstate)
  end
  
  function love.update(dt, ...)
    sm:update(dt, ...)
  end

  return sm
end

return basicgame
