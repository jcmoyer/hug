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

local function intersect()
  local a = rectangle.new(200, 200, 200, 200)
  local b = rectangle.new(150, 250, 200, 50)
  
  framework.compare(
    rectangle.new(200, 250, 150, 50),
    a:intersect(b)
  )
  framework.compare(
    rectangle.new(200, 250, 150, 50),
    b:intersect(a)
  )
  
  local c = rectangle.new(0, 0, 100, 100)
  framework.compare(
    nil,
    a:intersect(c)
  )
  framework.compare(
    nil,
    c:intersect(a)
  )
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

local function union()
  local a = rectangle.new(0, 0, 100, 100)
  local b = rectangle.new(200, 100, 100, 100)
  framework.compare(
    rectangle.new(0, 0, 300, 200),
    a:union(b)
  )
end

local function contains()
  local r = rectangle.new(100, 100, 100, 100)
  framework.compare(false, r:contains(0, 0))
  framework.compare(false, r:contains(250, 150))
  framework.compare(true, r:contains(100, 100))
  framework.compare(true, r:contains(200, 200))
  
  framework.compare(
    true,
    r:contains(rectangle.new(120, 120, 50, 50))
  )
  framework.compare(
    false,
    r:contains(rectangle.new(120, 120, 50, 200))
  )
  framework.compare(
    false,
    r:contains(rectangle.new(500, 100, 100, 100))
  )
end

local function center()
  local r = rectangle.new(100, 100, 200, 100)
  local x, y = r:center()
  framework.compare(200, x, 'x')
  framework.compare(150, y, 'y')
end

local function eq()
  local a = rectangle.new(10, 20, 30, 40)
  local b = rectangle.new(20, 30, 40, 50)
  local c = rectangle.new(10, 20, 30, 40)
  framework.compare(true, a ~= b)
  framework.compare(true, a == c)
end

local function inflate()
  local a = rectangle.new(50, 50, 100, 100)
  local cx1, cy1 = a:center()
  
  a:inflate(20, 10)
  framework.compare(30, a:x())
  framework.compare(140, a:width())
  
  framework.compare(40, a:y())
  framework.compare(120, a:height())
  
  local cx2, cy2 = a:center()
  framework.compare(cx1, cx2)
  framework.compare(cy1, cy2)
end

local function offset()
  local a = rectangle.new(10, 20, 30, 40)
  a:offset(10, 20)
  framework.compare(20, a:x())
  framework.compare(40, a:y())
end

return framework.testall {
  { 'components', components },
  { 'intersect', intersect },
  { 'intersects', intersects },
  { 'union', union },
  { 'contains', contains },
  { 'center', center },
  
  { 'equality', eq },
  
  { 'inflation', inflate },
  { 'offset', offset }
}
