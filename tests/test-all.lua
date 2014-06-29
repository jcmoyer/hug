local testfmt = '%d test(s) passed out of %d. (%.2f%%)'

local function makeheader(text)
  local header = '== ' .. text .. ' '
  return header .. string.rep('=', 79 - #header)
end

-- runs 'test-name.lua'
local function runtest(name)
  print(makeheader('Running tests for ' .. name))
  
  local chunk = assert(loadfile('test-' .. name .. '.lua'))
  local passed, total = chunk()
  print(string.format(testfmt, passed, total, 100 * passed / total))
  
  return passed, total
end

-- calls runtest for each entry in a table
local function runtests(t)
  local totalpassed, totaloverall = 0, 0
  for i = 1, #t do
    local passed, total = runtest(t[i])
    totalpassed = totalpassed + passed
    totaloverall = totaloverall + total
  end
  return totalpassed, totaloverall
end

local passed, total = runtests {
  'vector2',
  'color',
  'rectangle',
  'timer',
  'timerpool'
}

local overall = string.format(testfmt, passed, total, 100 * passed / total)
print(makeheader('Overall Results'))
print(overall)

os.exit(passed == total)
