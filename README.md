# love-9-slice
Simple library that make 9-slice images for LÖVE.

# Usage
```lua
require "love9slice"

function love.load()
    img1 = Image9Slice:new("test.png", 10, 10, 38, 38)
    img2 = Image9Slice:new("test.png", 10, 10, 38, 38)

    img1:resize(240, 120)
    img2:resizeScale(1.5, 3)
end

function love.draw()
    img1:draw(10, 10)
    img2:draw(10, 150)
end
```

![screenshot_love_9_slice](https://user-images.githubusercontent.com/22749928/32697177-62667916-c7ce-11e7-8f7f-c4d3b36f121b.png)

# License
MIT License
