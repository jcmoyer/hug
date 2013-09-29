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
local extensions = {}

local concat = table.concat

function extensions.join(delim, xs)
  local whole = {}
  for i = 1, #xs do
    whole[#whole + 1] = xs[i]
    if i + 1 <= #xs then
      whole[#whole + 1] = delim
    end
  end
  return concat(whole)
end

function extensions.split(s, p, noempty)
  if s == '' then
    return {}
  end
  
  noempty = noempty or false
  
  local t    = {}
  local base = 1
  local a, b = s:find(p, 1)
  
  while a do
    local part = s:sub(base, a - 1)
    if #part > 0 or (#part == 0 and not noempty) then
      t[#t + 1] = part
    end
    base      = b + 1
    a, b      = s:find(p, base)
  end
  
  if base <= #s then
    t[#t + 1] = s:sub(base)
  elseif base > #s and not noempty then
    t[#t + 1] = ''
  end
  
  return t
end

return extensions