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
local statemachine = require('hug.statemachine')
local timerpool = require('hug.timerpool')
local extension = require('hug.extensions.extension')

local basicgame = {}

function basicgame.start(initialstate, withexts)  
  local sm = statemachine.new()
  
  if withexts == true then
    extension.install(require('hug.extensions.math'), math)
    extension.install(require('hug.extensions.table'), table)
  end
  
  sm:push(initialstate)

  function love.load(args)
    sm:push(initialstate)
  end

  function love.draw(a)
    sm:draw(a)
  end

  function love.update(dt)
    timerpool.update(dt)
    sm:update(dt)
  end

  function love.keypressed(key, unicode)
    sm:keypressed(key, unicode)
  end

  function love.keyreleased(key, unicode)
    sm:keyreleased(key)
  end

  function love.mousepressed(x, y, button)
    sm:mousepressed(x, y, button)
  end

  function love.mousereleased(x, y, button)
    sm:mousereleased(x, y, button)
  end
end

return basicgame