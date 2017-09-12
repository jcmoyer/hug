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

-- Provides functions that help manage extensions.

local extension = {}

local assert, type, error, pairs = assert, type, error, pairs

-- Installs the members of one table into another.
-- An error will be raised if there is a name conflict.
-- @tab ext Source table.
-- @tab t Destination table.
function extension.install(ext, t)
  assert(type(ext) == 'table', 'ext must be a table')
  assert(type(t) == 'table', 't must be a table')
  
  for k,v in pairs(ext) do
    if t[k] then
      error('(extension) duplicate key: "' .. k .. '"')
    else
      t[k] = v
    end
  end
end

return extension
