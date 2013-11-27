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
-- local im1 = imagecache.get('foo.png')
-- local im2 = imagecache.get('foo.png')
-- assert(im1 == im2)

local cache = {}

--- Creates a cache from a function.
-- @func factory function that produces values for some input. The given
--   function should be referentially transparent.
-- @return A table with a single method, get(name). The function specified
--   will receive name as a parameter, and it is expected to return a
--   non-nil result corresponding to that name. Subsequent calls to get
--   will return the same, cached value for the same name.
function cache.new(factory)
  local t = {}
  
  function t.get(name)
    local existing = t[name]
    if existing ~= nil then
      return existing
    else
      existing = factory(name)
      t[name] = existing
      return existing
    end
  end

  return t
end

return cache