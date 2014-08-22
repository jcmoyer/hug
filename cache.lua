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

--- Implements a generalized data cache.
-- @type cache
-- @usage
-- local imagecache = require('hug.cache').new(love.graphics.newImage)
-- local im1 = imagecache:get('foo.png')
-- local im2 = imagecache:get('foo.png')
-- assert(im1 == im2)

local cache = {}
local mt = { __index = cache }

--- Creates a cache from a factory function.
-- @func factory An unary function that produces a different value for each
--   unique input.
-- @return A new cache.
function cache.new(factory)
  local instance = {
    factory = factory,
    entries = {}
  }
  return setmetatable(instance, mt)
end

--- Returns the value associated with a given key.
-- In the event that there is no value associated with `key`, the factory
-- function will be called to generate a value.
-- @tparam any key The key to lookup a value for.
-- @treturn any The value associated with `key`.
function cache:get(key)
  local existing = self.entries[key]
  if existing ~= nil then
    return existing
  else
    existing = self.factory(key)
    self.entries[key] = existing
    return existing
  end
end

return cache