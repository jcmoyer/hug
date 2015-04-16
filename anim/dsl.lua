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

local set = require('hug.anim.set')
local animation = require('hug.anim.animation')
local frame = require('hug.anim.frame')
local rectangle = require('hug.rectangle')

local dsl = {}

local runenv
if _VERSION == 'Lua 5.1' then
  runenv = function(f, env)
    setfenv(f, env)
    return f()
  end
else
  -- pass environment as _ENV parameter
  runenv = function(f, env)
    return f(env)
  end
end

local function dslframef(t)
  local attachments = {}
  for k,v in pairs(t) do
    if (type(v) == 'table' and v._attachment) then
      table.insert(attachments, v)
    end
  end
  return {
    source = t.source,
    duration = t.duration,
    attachments = attachments,
    _frame = true
  }
end

local function dslrectanglef(x, y, w, h)
  return rectangle.new(x, y, w, h)
end

local function dslattachmentf(name, x, y)
  return {x, y, name = name, _attachment = true}
end

-- Runs a function `f` in the context of an animation builder. An animation set
-- will be constructed and returned using the data provided.
--
-- `f` will have access to the following functions:
--
-- * animation(s) - Takes `s`, a string that provides an animation name;
--   returns a function(t) that takes a sequence table containing all of the
--   frames in the animation.
-- * frame(t) - Takes `t`, a table containing information about a frame.
-- * attachment(name, x, y) - Denotes an attachment in the context of a frame.
--   `name` is the name of the attachment, and `x` and `y` represent the point
--   in 2D Euclidean space.
-- * rectangle(x, y, w, h) - Constructs a `hug.rectangle` and returns it. This
--   is used to define sources for frames.
--
-- Example:
--
-- ```
-- -- _ENV can be omitted in Lua 5.1 interpreters, but it should be included
-- -- to be fully portable.
-- local as = dsl.run(function(_ENV)
--   animation 'idle' {
--     frame {
--       source = rectangle(0, 0, 32, 32),
--       attachment('head', 16, 2)
--     }
--   }
--   animation 'walk' {
--     frame {
--       source = rectangle(0, 32, 32, 32),
--       duration = '500ms',
--       attachment('head', 14, 2)
--     },
--     frame {
--       source = rectangle(32, 32, 32, 32),
--       duration = '500ms',
--       attachment('head', 16, 2)
--     }
--   }
-- end)
-- ```
function dsl.run(f)
  local as = set.new()

  -- this needs to close over `as` so it can be modified
  local function dslanimationf(name)
    local a = animation.new()
    as:add(name, a)
    return function(t)
      for i = 1, #t do
        -- get frame
        local fr = t[i]
        -- add to current anim
        a:add(frame.new(
          fr.source[1],
          fr.source[2],
          fr.source[3],
          fr.source[4],
          fr.duration,
          fr.attachments))
      end
    end
  end

  local env = {
    animation = dslanimationf,
    frame = dslframef,
    attachment = dslattachmentf,
    rectangle = dslrectanglef
  }

  runenv(f, env)

  return as
end

return dsl
