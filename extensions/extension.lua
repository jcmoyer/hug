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
local extension = {}

local type, error, pairs = type, error, pairs

-- installs the members of table 'ext' into table 't'
function extension.install(ext, t)
  if type(ext) ~= 'table' then
    error('ext must be a table')
  end
  if type(t) ~= 'table' then
    error('t must be a table')
  end
  for k,v in pairs(ext) do
    if t[k] then
      error('(extension) duplicate key: "' .. k .. '"')
    else
      t[k] = v
    end
  end
end

return extension