local function keyify(value)
  if type(value) == 'string' then
    return value
  else
    return string.format('[%s]', value)
  end
end

local function dump(value)
  if type(value) == 'table' then
    local t = {}
    t[1] = '{ '
    for k,v in pairs(value) do
      t[#t + 1] = string.format('%s = %s; ', keyify(k), dump(v))
    end
    t[#t + 1] = '}'
    return table.concat(t)
  elseif type(value) == 'string' then
    return string.format('"%s"', value)
  else
    return tostring(value)
  end
end

local function test(desc, f)
  local status, msg = pcall(f)
  if not status then
    print('[FAIL] ' .. desc .. ': ' .. msg)
    return false
  else
    print('[PASS] ' .. desc)
    return true
  end
end

local function testall(t)
  local total = #t
  local passed = 0
  
  for i = 1, total do
    local testinfo = t[i]
    local name = testinfo[1]
    local f = testinfo[2]
    if not name then
      name = 'unknown'
    end
    if not f then
      error('no test function given for ' .. name)
    end
    if test(name, f) then
      passed = passed + 1
    end
  end
  
  return passed, total
end

local function compare(expected, actual, desc)
  if expected ~= actual then
    if desc then
      error(string.format('%s: compare failed; expected %s but got %s', desc, dump(expected), dump(actual)), 2)
    else
      error(string.format('compare failed; expected %s but got %s', dump(expected), dump(actual)), 2)
    end
  end
end

local function ensureerror(f, desc)
  local status = pcall(f)
  if status then
    if desc then
      error(string.format('%s: expected an error to be raised', desc))
    else
      error('expected an error to be raised')
    end
  end
end

return {
  dump = dump,
  test = test,
  testall = testall,
  compare = compare,
  ensureerror = ensureerror
}