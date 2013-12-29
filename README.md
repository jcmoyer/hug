# hug

Minimalistic utility library for LÖVE. Documentation can be [read online](http://jcmoyer.github.io/hug/doc/) or compiled manually using [LDoc](https://github.com/stevedonovan/LDoc).

# Getting started
The fastest way to get started with hug is by cloning it into your LÖVE game directory. Here, hug is cloned into `hug/` (relative to the directory where `main.lua` and `conf.lua` are kept):

    $ git clone https://github.com/jcmoyer/hug.git

Now you can load hug modules using `require`:

    local color = require('hug.color')
    local red = color.new(255, 0, 0)

    function love.draw()
      love.graphics.setColor(red)
      love.graphics.rectangle('fill', 0, 0, 128, 128)
    end

To learn more about hug, check out the documentation [here](http://jcmoyer.github.io/hug/doc/).

# License

    Copyright 2013 J.C. Moyer
   
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
   
      http://www.apache.org/licenses/LICENSE-2.0
   
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
