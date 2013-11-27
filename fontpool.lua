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

--- Facilitates the reuse of fonts instead of creating new ones.
-- **DEPRECATED**: Prefer an abstraction based on `cache` instead. The current
-- functionality in this module may be duplicated with the following line of
-- code:
--
-- `fontpool = require('hug.cache').new(love.graphics.newFont)`
--
-- This module will be removed in the future.

local fontpool = {}
local fonts = {}

local newFont = love.graphics.newFont

-- https://www.love2d.org/wiki/love.graphics.newFont
--
-- TODO: Support other overloads:
--   filename, size
--   file, size
--   data, size
--
-- Since none of these overloads have been used yet, this isn't a high priority.

--- Returns a font for the given size, creating a new one only if necessary.
-- @int size Font size.
-- @treturn Font
function fontpool.get(size)
  size = size or 12
  
  local f = fonts[size]
  if f == nil then
    f = newFont(size)
    fonts[size] = f
  end
  return f
end

return fontpool