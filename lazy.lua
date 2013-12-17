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

--- Implements lazily initialized values.
-- Lazy values are not produced until they are first requested. This allows you
-- to delay a potentially expensive computation until the moment it is needed.
-- @type lazy
-- @usage
-- local filenames = lazy.new(function()
--   return love.filesystem.getDirectoryItems('images/')
-- end)
-- ...
-- for file in ipairs(filenames:get()) do
--   local im = love.graphics.newImage(file)
--   ...
-- end

local lazy = {}
local mt = { __index = lazy }

local setmetatable = setmetatable

--- Creates a new lazily initialized value.
-- @func factory Function that produces a value.
-- @treturn lazy
function lazy.new(factory)
  local instance = {
    factory = factory,
    wasinit = false
  }
  return setmetatable(instance, mt)
end

--- Returns the value associated with this `lazy` instance.
-- @treturn any
function lazy:get()
  if self.wasinit == false then
    self.value = self.factory()
    self.wasinit = true
  end
  return self.value
end

return lazy