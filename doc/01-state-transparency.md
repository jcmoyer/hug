# Game State Transparency

Transparency is the method hug uses to deal with multiple visible gamestates in the gamestate stack. When the topmost gamestate is marked as transparent, any underlying states are rendered first. Rendering starts at the first opaque state encountered from the top of the stack or at the bottommost state if all states in the stack are transparent. Additionally, LÖVE callbacks are called on each transparent state from top to bottom. At any point in the transparency stack, a gamestate can intercept the callback so that it is not passed to underlying states.

`gamestate` objects can be flagged as transparent through the `transparent` field on a `gamestate` instance. By default, properly implemented gamestates are opaque - any code that looks for the `transparent` field by default should find the default value in `hug.gamestate` by climbing the `__index` chain. To intercept an event so that it is not propagated downwards, return `false` from your callback.

# Example

```
-- instructions:
-- press ESC to pause the timer

local gamestate = require('hug.gamestate')
local playstate = gamestate.extend()
playstate.__index = playstate

local pausestate = gamestate.extend()
pausestate.__index = pausestate

local font = love.graphics.setNewFont(48)

function playstate.new()
  return setmetatable({t = 0}, playstate)
end
function playstate:keypressed(key)
  if key == 'escape' then
    self:sm():push(pausestate.new())
  end
end
function playstate:update(dt)
  self.t = self.t + dt
end
function playstate:draw()
  -- draw a red screen with some dynamic text
  local w, h = love.graphics.getDimensions()
  love.graphics.setColor(120, 55, 55)
  love.graphics.rectangle('fill', 0, 0, w, h)

  local text = 'Seconds passed: ' .. math.floor(self.t)
  local tw, th = font:getWidth(text), font:getHeight()
  local tx, ty = w / 2 - tw / 2, h / 2 - th / 2 - 150

  love.graphics.setColor(255, 255, 255)
  love.graphics.print('Seconds passed: ' .. math.floor(self.t), tx, ty)
end

function pausestate.new()
  return setmetatable({transparent = true}, pausestate)
end
function pausestate:keypressed(key)
  if key == 'escape' then
    self:sm():pop()
  end
  -- this intercepts all input so that the underlying state doesn't process it
  return false
end
function pausestate:update()
  -- this prevents update ticks on the underlying state
  return false
end
function pausestate:draw()
  -- draw a 50% transparent, black overlay
  local w, h = love.graphics.getDimensions()
  love.graphics.setColor(0, 0, 0, 128)
  love.graphics.rectangle('fill', 0, 0, w, h)

  local text = 'PAUSED - Press ESC to unpause'
  local tw, th = font:getWidth(text), font:getHeight()
  local tx, ty = w / 2 - tw / 2, h / 2 - th / 2
  love.graphics.setColor(255, 255, 255)
  love.graphics.print('PAUSED - Press ESC to unpause', tx, ty)
end

local basicgame = require('hug.basicgame')
basicgame.start(playstate.new())
```

