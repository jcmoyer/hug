require('path')
local framework = require('tt')
local cache     = require('hug.cache')

local function get()
  local function f(n)
    return n*n
  end
  
  local squarecache = cache.new(f)
  framework.compare(
    f(2),
    squarecache:get(2),
    'distinct key #1'
  )
  framework.compare(
    f(4),
    squarecache:get(4),
    'distinct key #2'
  )
  framework.compare(
    f(4),
    squarecache:get(4),
    'multiple calls with the same key'
  )
end

return framework.testall {
  { 'get', get }
}
