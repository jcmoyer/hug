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

--- Provides extra math functions.
-- @alias extensions

local extensions = {}

--- Linearly interpolates between two values.
-- @tparam number v0 First value.
-- @tparam number v1 Second value.
-- @tparam number t Percent to interpolate by.
-- @treturn number The interpolated value.
function extensions.lerp(v0, v1, t)
  return v0 + (v1 - v0) * t
end

--- Clamps a number between two values.
-- @tparam number x Value to clamp.
-- @tparam number min Minimum value.
-- @tparam number max Maximum value.
-- @treturn number The clamped value.
function extensions.clamp(x, min, max)
  if x < min then return min end
  if x > max then return max end
  return x
end

return extensions
