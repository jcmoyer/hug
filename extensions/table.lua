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

--- Provides extra table functions.
-- @alias extensions

local extensions = {}

local getmetatable, setmetatable, pairs = getmetatable, setmetatable, pairs

--- Shallowly clones a table.
-- @tparam table t Table to clone.
-- @treturn table A new table containing all of the data in `t`.
function extensions.clone(t)
  local r = {}
  for k,v in pairs(t) do
    r[k] = v
  end
  return setmetatable(r, getmetatable(t))
end

-- Deeply clones a table `t`.
function extensions.deepclone(t)
  local r = {}
  for k,v in pairs(t) do
    if type(v) == 'table' then
      r[k] = extensions.deepclone(v)
    else
      r[k] = v
    end
  end
  return setmetatable(r, getmetatable(t))
end

return extensions
