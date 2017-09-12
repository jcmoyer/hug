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

-- Implements a finite state machine for handling game states.
-- **Dependencies:**
--
-- * `gamestate`
--
-- The `statemachine` module generates _methods_ with the same names as those
-- defined in `gamestate.callbacks` at runtime. Consult the LÖVE documentation
-- to see what parameters these functions take. When one of these methods is
-- called, the parameters you give it are forwarded to the corresponding method
-- in the currently active `gamestate`. If the gamestate's method returns a
-- truthy value (e.g. anything that is not `false` or `nil`), and the gamestate
-- is flagged as transparent, the same parameters will be forwarded to the
-- underlying gamestate in the statemachine's stack. This process will continue
-- down the stack until the bottommost state is reached or one of the methods
-- returns a falsy value or one of the states is not flagged as transparent.

-- @type statemachine
-- @see gamestate

local module = require('hug.module')

local statemachine = module.new()

local assert = assert
local setmetatable = setmetatable
local max = math.max
local insert, remove = table.insert, table.remove

local gamestate = require('hug.gamestate')
local callbacks = gamestate.callbacks()

-- Constructs a new statemachine object.
-- @treturn statemachine
function statemachine.new()
  local instance = {
    states = {},
    base = 0
  }
  return setmetatable(instance, statemachine)
end

function statemachine:findbase()
  local i = #self.states + 1
  local s
  if i > 0 then
    -- find the topmost concrete state
    repeat
      i = i - 1
      s = self.states[i]
    until not s.transparent or i < 1
    self.base = max(i, 1)
  end
end

-- start of callback implementations
for i = 1, #callbacks do
  local name = callbacks[i]
  statemachine[name] = function(self, ...)
    for i = #self.states, self.base, -1 do
      if not self.states[i][name](self.states[i], ...) then return end
    end
  end
end

function statemachine:draw(...)
  local g = love.graphics
  for i = self.base, #self.states do
    g.push()
    self.states[i]:draw(...)
    g.pop()
  end
end
-- end of callback implementations

-- Determines if this state machine is managing any states.
function statemachine:any()
  return #self.states > 0
end

-- Returns the topmost state.
-- @treturn gamestate
function statemachine:top()
  return self.states[#self.states]
end

-- Pushes a new `gamestate` on top of the statemachine stack.
function statemachine:push(newstate)
  assert(gamestate.type(newstate), 'newstate is not a gamestate')
  
  local oldstate = self:top()
  
  newstate:sm(self)
  insert(self.states, newstate)
  
  if oldstate then
    oldstate:leave(newstate)
  end
  newstate:enter(oldstate)
  
  self:findbase()
end

-- Pops the topmost `gamestate` from the statemachine stack.
-- The state being popped will receive a call to `leave` with the underlying
-- state as a parameter. Likewise, the state being transitioned to will receive
-- a call to `enter` with the popped state as a parameter.
-- @treturn gamestate The gamestate popped from the stack.
function statemachine:pop()
  local old = remove(self.states, #self.states)
  local new = self:top()
  
  old:leave(new)
  if new then
    new:enter(old)
  end
  
  self:findbase()
  
  return old
end

return statemachine
