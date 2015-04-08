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
local gameloop = {}

--- Contains functions that set up various kinds of game loops.

--- Sets up a game loop with a fixed timestep and interpolated rendering.
-- **Replaces** the default `love.run` callback with one that calls
-- `love.update` `updatehz` times per second. Additionally, `love.draw` will
-- receive an argument `alpha` that tells it how much it needs to interpolate
-- the scene by for this frame. That is, objects in a scene need to be drawn
-- at a position that is `alpha` percent between the previous and next _update_
-- frame. This game loop aims to eliminate a visual artifact known as temporal
-- aliasing when used properly.
--
-- `love.timer` is **required** for this game loop to function. If it is
-- disabled, `love.run` will throw an error.
--
-- @int updatehz How many times to update the game per second.
function gameloop.fixint(updatehz)
  function love.run()
    local now
    local last

    local acc  = 0
    
    local PHYS_HZ   = updatehz
    local PHYS_RATE = 1 / PHYS_HZ
    
    if love.math then
      love.math.setRandomSeed(os.time())
    end
    
    if love.event then
      love.event.pump()
    end
    
    if love.load then
      love.load(arg)
    end
    
    assert(love.timer, 'love.timer is required for this type of game loop')
    
    love.timer.step()
    now  = love.timer.getTime()
    last = now
    
    while true do
      now  = love.timer.getTime()
      acc  = acc + now - last
      last = now
      
      if love.event then
        love.event.pump()
        for e,a,b,c,d in love.event.poll() do
          if e == "quit" then
            if not love.quit or not love.quit() then
              if love.audio then
                love.audio.stop()
              end
              return
            end
          end
          love.handlers[e](a,b,c,d)
        end
      end
      
      love.timer.step()
      
      if love.update then
        while acc >= PHYS_RATE do
          love.update(PHYS_RATE)
          acc = acc - PHYS_RATE
        end
      end
      
      if love.window and love.graphics and love.window.isCreated() then
        love.graphics.clear()
        love.graphics.origin()
        if love.draw then
          love.draw(acc / PHYS_RATE)
        end
        love.graphics.present()
      end
    end
  end
end

return gameloop
