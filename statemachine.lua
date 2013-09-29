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
local statemachine = {}
local mt = { __index = statemachine }

local setmetatable, error = setmetatable, error
local max = math.max
local insert, remove = table.insert, table.remove

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
    -- find the top-most concrete state
    repeat
      i = i - 1
      s = self.states[i]
    until not s.transparent or i < 1
    self.base = max(i, 1)
  end
end

function statemachine:update(dt)
  for i = #self.states, self.base, -1 do
    if not self.states[i]:update(dt) then return end
  end
end

function statemachine:draw(a)
  local g = love.graphics
  for i = self.base, #self.states do
    g.push()
    self.states[i]:draw(a)
    g.pop()
  end
end

function statemachine:keypressed(key, unicode)
  for i = #self.states, self.base, -1 do
    if not self.states[i]:keypressed(key, unicode) then return end
  end
end

function statemachine:keyreleased(key)
  for i = #self.states, self.base, -1 do
    if not self.states[i]:keyreleased(key) then return end
  end
end

function statemachine:mousepressed(x, y, button)
  for i = #self.states, self.base, -1 do
    if not self.states[i]:mousepressed(x, y, button) then return end
  end
end

function statemachine:mousereleased(x, y, button)
  for i = #self.states, self.base, -1 do
    if not self.states[i]:mousereleased(x, y, button) then return end
  end
end

function statemachine:any()
  return #self.states > 0
end

function statemachine:top()
  return self.states[#self.states]
end

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

function statemachine:pop()
  local popped = remove(self.states, newstate)
  
  if popped then
    popped:onLeave(newstate)
  end
  self:top():onEnter(popped)
  
  self:findBaseState()
  
  return popped
end

return statemachine