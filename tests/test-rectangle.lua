require('path')
local framework = require('framework')
local rectangle = require('rectangle')

local function components()
  local r = rectangle.new(12, 34, 56, 78)
  framework.compare(true, r:x() == 12, 'X component')
  framework.compare(true, r:y() == 34, 'Y component')
  framework.compare(true, r:width() == 56, 'width component')
  framework.compare(true, r:height() == 78, 'height component')
  
  framework.compare(true, r:right() == 12 + 56, 'right side')
  framework.compare(true, r:bottom() == 34 + 78, 'bottom side')
end

local function intersects()
  local a = rectangle.new(100, 200, 300, 400)
  local b = rectangle.new(400, 800, 100, 100)
  
  -- should not intersect
  framework.compare(false, a:intersects(b), 'a-b intersection')
  framework.compare(false, b:intersects(a), 'b-a intersection')
  
  -- intersects a from the left side
  local intaleft = rectangle.new(a:x() - 100, a:y() + 100, 150, 150)
  framework.compare(true, a:intersects(intaleft), 'a-left intersection')
  framework.compare(true, intaleft:intersects(a), 'left-a intersection')
  
  -- intersects a from the right side
  local intaright = rectangle.new(a:right() - 100, a:y() + 100, 150, 150)
  framework.compare(true, a:intersects(intaright), 'a-right intersection')
  framework.compare(true, intaright:intersects(a), 'right-a intersection')
  
  -- intersects a from the top side
  local intatop = rectangle.new(a:x() + 100, a:y() - 100, 150, 150)
  framework.compare(true, a:intersects(intatop), 'a-top intersection')
  framework.compare(true, intatop:intersects(a), 'top-a intersection')
  
  -- intersects a from the bottom side
  local intabottom = rectangle.new(a:x() + 100, a:bottom() - 100, 150, 150)
  framework.compare(true, a:intersects(intabottom), 'a-bottom intersection')
  framework.compare(true, intabottom:intersects(a), 'bottom-a intersection')
end

local function contains()
  local r = rectangle.new(100, 100, 100, 100)
  framework.compare(false, r:contains(0, 0))
  framework.compare(false, r:contains(250, 150))
  framework.compare(true, r:contains(100, 100))
  framework.compare(true, r:contains(200, 200))
end

local function center()
  local r = rectangle.new(100, 100, 200, 100)
  local x, y = r:center()
  framework.compare(200, x, 'x')
  framework.compare(150, y, 'y')
end

return framework.testall {
  { 'components', components },
  { 'intersects', intersects },
  { 'contains', contains },
  { 'center', center }
}
