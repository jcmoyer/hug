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

local module = require('hug.module')

local quadstore = module.new()

-- Constructs a new quadstore from an animation set and image. The store will
-- compute quads for all frames in the animation set and provide a way to
-- lookup the quad associated with a specific frame.
function quadstore.new(aset, image)
  local quads = {}

  for i = 1,aset:len() do
    local a = aset:animation(i)
    for j = 1,a:len() do
      local f = a:frame(j)
      quads[f] = love.graphics.newQuad(
        f[1],
        f[2],
        f[3],
        f[4],
        image:getWidth(),
        image:getHeight()
      )
    end
  end

  local instance = {
    quads = quads
  }

  return setmetatable(instance, quadstore)
end

-- Returns the quad associated with `frame`.
function quadstore:quad(frame)
  return self.quads[frame]
end

return quadstore
