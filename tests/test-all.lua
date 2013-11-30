local function makeheader(text)
  local header = '== ' .. text .. ' '
  return header .. string.rep('=', 79 - #header)
end

-- runs 'test-name.lua'
local function runtest(name)
  print(makeheader('Running tests for ' .. name))
  
  local chunk = assert(loadfile('test-' .. name .. '.lua'))
  chunk()
end

-- calls runtest for each entry in a table
local function runtests(t)
  for i = 1, #t do
    runtest(t[i])
  end
end

runtests {
  'vector2'
}