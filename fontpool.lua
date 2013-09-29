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
-- facilitates the reuse of fonts instead of creating new ones
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