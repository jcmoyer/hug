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

--- Implements a finite state machine for handling game states.
-- @type statemachine
-- @see gamestate

local statemachine = {}
local mt = { __index = statemachine }

local setmetatable, error = setmetatable, error
local max = math.max
local insert, remove = table.insert, table.remove

local callbacks = require('hug.gamestate').callbacks()

local function reviter(f, t)
  for i = #t, 1, -1 do
    f(t[i])
  end
end

--- Constructs a new statemachine object.
-- @treturn statemachine
function statemachine.new()
  local instance = {
    states = {},
    base = 0
  }
  return setmetatable(instance, mt)
end

function statemachine:findBaseState()
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

--- Determines if this state machine is managing any states.
function statemachine:any()
  return #self.states > 0
end

--- Returns the topmost state.
-- @treturn gamestate
function statemachine:top()
  return self.states[#self.states]
end

--- Pushes a new `gamestate` on top of the statemachine stack.
function statemachine:push(newstate)
  if not newstate.isgamestate then
    error('newstate is not a gamestate')
  end
  
  local oldstate = self:top()
  
  newstate:sm(self)
  insert(self.states, newstate)
  
  if oldstate then
    oldstate:onLeave(newstate)
  end
  newstate:onEnter(oldstate)
  
  self:findBaseState()
end

--- Pops the topmost `gamestate` from the statemachine stack.
-- The state being popped will receive a call to `onLeave` with the underlying
-- state as a parameter. Likewise, the state being transitioned to will receive
-- a call to `onEnter` with the popped state as a parameter.
-- @treturn gamestate The gamestate popped from the stack.
function statemachine:pop()
  local old = remove(self.states, #self.states)
  local new = self:top()
  
  old:onLeave(new)
  if new then
    new:onEnter(old)
  end
  
  self:findBaseState()
  
  return old
end

return statemachine