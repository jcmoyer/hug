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
local color = {}
local mt = { __index = color }

local getmetatable, setmetatable, type, error = getmetatable, setmetatable, type, error

local function clampcolor(a)
  if a < 0 then
    return 0
  elseif a > 255 then
    return 255
  else
    return a
  end
end

local function checkcolor(a)
  return getmetatable(a) == mt
end

function mt.__add(a, b)
  local result = a:clone()
  result:add(b)
  return result
end

function mt.__sub(a, b)
  local result = a:clone()
  result:sub(b)
  return result
end

function mt.__mul(a, b)
  local result
  if checkcolor(a) then
    result = a:clone()
    result:mul(b)
  elseif checkcolor(b) then
    result = b:clone()
    result:mul(a)
  else
    error('no colors given')
  end
  return result
end

function mt.__div(a, b)
  local result = a:clone()
  result:div(b)
  return result
end

function mt.__unm(a)
  local result = a:clone()
  result:invert()
  return result
end

function color.new(r, g, b, a)
  -- support creation from table
  if type(r) == 'table' and #r >= 3 then
    a = r[4]
    b = r[3]
    g = r[2]
    r = r[1]
  end
  -- ensure all parameters are numbers
  if type(r) == 'number' and type(g) == 'number' and type(b) == 'number' and (type(a) == 'nil' or type(a) == 'number') then
    return setmetatable({r, g, b, a}, mt)
  else
    error('a color requires at least three numerical components')  
  end
end

function color:clone()
  return setmetatable({self[1], self[2], self[3], self[4]}, mt)
end

--
-- In-place operations
--
function color:add(b)
  if not checkcolor(b) then
    error('cannot add a ' .. type(b) .. ' to a color')
  end
  -- All colors will have at least three components
  self[1] = clampcolor(self[1] + b[1])
  self[2] = clampcolor(self[2] + b[2])
  self[3] = clampcolor(self[3] + b[3])
  if #self == 4 and #b == 4 then
    self[4] = clampcolor(self[4] + b[4])
  end
end

function color:sub(b)
  if not checkcolor(b) then
    error('cannot subtract a ' .. type(b) .. ' from a color')
  end
  -- All colors will have at least three components
  self[1] = clampcolor(self[1] - b[1])
  self[2] = clampcolor(self[2] - b[2])
  self[3] = clampcolor(self[3] - b[3])
  if #self == 4 and #b == 4 then
    self[4] = clampcolor(self[4] - b[4])
  end
end

function color:mul(b)
  if type(b) ~= 'number' then
    error('cannot multiply a color by a ' .. type(b))
  end
  self[1] = clampcolor(self[1] * b)
  self[2] = clampcolor(self[2] * b)
  self[3] = clampcolor(self[3] * b)
  if #self == 4 then
    self[4] = clampcolor(self[4] * b)
  end
end

function color:div(b)
  if type(b) ~= 'number' then
    error('cannot divide a color by a ' .. type(b))
  end
  self[1] = clampcolor(self[1] / b)
  self[2] = clampcolor(self[2] / b)
  self[3] = clampcolor(self[3] / b)
  if #self == 4 then
    self[4] = clampcolor(self[4] / b)
  end
end

function color:invert()
  self[1] = 255 - self[1]
  self[2] = 255 - self[2]
  self[3] = 255 - self[3]
  if #self == 4 then
    self[4] = 255 - self[4]
  end
end

return color