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

local rectangle = require('hug.rectangle')
local vector2 = require('hug.vector2')
local tablex = require('hug.extensions.table')
local module = require('hug.module')

local frame = module.new(rectangle, true)

-- Constructs a frame and returns it.
--
-- `x`, `y`, `w`, and `h` are integers that define the rectangle the frame
-- should use as a source from an image.
--
-- `duration` is a string that tells how long this frame should last when
-- played as part of an animation. Example values are `'500ms'` (500
-- milliseconds), `'1s'` (1 second), `'0.76s'` (0.76 seconds or 760
-- milliseconds). If `duration` is `nil`, the frame will be interpreted as
-- lasting indefinitely.
--
-- `userdata` is a table containing arbitrary data.
function frame.new(x, y, w, h, duration, userdata)
  -- at some point this should be put into a different module
  if type(duration) == 'string' then
    local n, unit = duration:match('^([%d%.]+)(%a+)$')
    if unit == 's' then
      duration = tonumber(n)
    elseif unit == 'ms' then
      duration = tonumber(n) / 1000
    else
      error('unrecognized time unit')
    end
  end

  local instance = {
    x, y, w, h,
    duration = duration,
    _userdata = userdata or {}
  }

  return setmetatable(instance, frame)
end

-- Returns the attachment named `name`, or `nil` if it doesn't exist. The value
-- returned is a `vector2`. This is syntactic sugar to access the userdata
-- named 'attachments'.
function frame:attachment(name)
  local attachments = self:userdata('attachments')
  if attachments then
    return attachments[name]
  else
    return nil
  end
end

-- Returns the userdata named `name`, or `nil` if it doesn't exist.
function frame:userdata(name)
  return self._userdata[name]
end

-- Creates a copy of this frame and returns it.
function frame:clone()
  return frame.new(
    self[1], -- x
    self[2], -- y
    self[3], -- w
    self[4], -- h
    self.duration,
    tablex.deepclone(self.userdata))
end

return frame
