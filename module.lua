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

local module = {}

-- Constructs a table with an __index field that refers to itself.
-- If `super` is present, absent fields will be looked for there.
-- If `inheritmt` is true, the table will have all metamethods from `super`
-- copied into it.
function module.new(super, inheritmt)
  local t = {}
  if super then
    if inheritmt then
      for k,v in pairs(super) do
        if (type(k) == 'string' and k:match('^__')) then
          t[k] = v
        end
      end
    end
    setmetatable(t, {__index = super})
  end
  t.__index = t
  return t
end

return module
