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
