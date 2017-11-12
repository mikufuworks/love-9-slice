--[[
MIT License

Copyright (c) 2017 Yuuki Yamashita

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

Image9Slice = {}

function Image9Slice:new(filename, left, top, right, bottom)
    local o = {
        imgBase= love.graphics.newImage(filename),
        canvas = nil,
        left   = left,
        top    = top,
        right  = right,
        bottom = bottom,
        width  = nil,
        height = nil,
        sx     = 1,
        sy     = 1,
        quadTL = nil,
        quadTR = nil,
        quadBL = nil,
        quadBR = nil,
        quadL  = nil,
        quadT  = nil,
        quadR  = nil,
        quadB  = nil,
        quadC  = nil
    }

    setmetatable(o, self)
    self.__index = self

    self.init(o)

    return o
end

function Image9Slice:init()

    self.width  = self.imgBase:getWidth()
    self.height = self.imgBase:getHeight()

    local w, h, l, r, t, b = self.width, self.height, self.left, self.right, self.top, self.bottom

    self.quadTL = love.graphics.newQuad(0, 0, l,               t,               self.imgBase:getDimensions())
    self.quadTR = love.graphics.newQuad(r, 0, w - r,           t,               self.imgBase:getDimensions())
    self.quadBL = love.graphics.newQuad(0, b, l,               h - b,           self.imgBase:getDimensions())
    self.quadBR = love.graphics.newQuad(r, b, w - r,           h - b,           self.imgBase:getDimensions())
    self.quadL  = love.graphics.newQuad(0, t, l,               h - t - (h - b), self.imgBase:getDimensions())
    self.quadT  = love.graphics.newQuad(l, 0, w - l - (w - r), t,               self.imgBase:getDimensions())
    self.quadR  = love.graphics.newQuad(r, t, w - r,           h - t - (h - b), self.imgBase:getDimensions())
    self.quadB  = love.graphics.newQuad(l, b, w - l - (w - r), h - b,           self.imgBase:getDimensions())
    self.quadC  = love.graphics.newQuad(l, t, r - l,           b - t,           self.imgBase:getDimensions())

    self.right  = self.width - self.right
    self.bottom = self.height - self.bottom

    self:redrawCanvas()
end


function Image9Slice:redrawCanvas()
    local originalWidth, originalHeight = self.imgBase:getDimensions()
    local w, h, sx, sy

    if self.width ~= nil or self.height ~= nil then
        w  = self.width - self.left - self.right
        h  = self.height - self.top - self.bottom
        sx = w / (originalWidth - self.left - self.right)
        sy = h / (originalHeight - self.top - self.bottom)
    else
        sx = (originalWidth * self.sx - self.left - self.right) / (originalWidth - self.left - self.right)
        sy = (originalHeight * self.sy - self.top - self.bottom) / (originalHeight - self.top - self.bottom)
        w  = originalWidth * self.sx - self.left - self.right
        h  = originalHeight * self.sy - self.top - self.bottom
    end

    self.canvas = love.graphics.newCanvas()
    love.graphics.setCanvas(self.canvas)
        love.graphics.draw(self.imgBase, self.quadTL, 0,             0)
        love.graphics.draw(self.imgBase, self.quadT,  self.left,     0,            0 ,sx, 1)
        love.graphics.draw(self.imgBase, self.quadTR, self.left + w, 0)
        love.graphics.draw(self.imgBase, self.quadL,  0,             self.top,     0, 1,  sy)
        love.graphics.draw(self.imgBase, self.quadC,  self.left,     self.top,     0, sx, sy)
        love.graphics.draw(self.imgBase, self.quadR,  self.left + w, self.top,     0, 1,  sy)
        love.graphics.draw(self.imgBase, self.quadBL, 0,             self.top + h)
        love.graphics.draw(self.imgBase, self.quadB,  self.left,     self.top + h, 0 ,sx, 1)
        love.graphics.draw(self.imgBase, self.quadBR, self.left + w, self.top + h)
    love.graphics.setCanvas(canvas)
end

function Image9Slice:draw(x, y)
    love.graphics.draw(self.canvas, x, y)
end

function Image9Slice:resize(w, h)
    self.width = w
    self.height = h or w
    self.sx = nil
    self.sy = nil

    self:redrawCanvas()
end

function Image9Slice:resizeWidth(w)
    self.width = w
    self.sx = nil
    self.sy = nil

    self:redrawCanvas()
end

function Image9Slice:resizeHeight(h)
    self.height = h
    self.sx = nil
    self.sy = nil

    self:redrawCanvas()
end

function Image9Slice:resizeScale(sx, sy)
    self.sx = sx
    self.sy = sy or sx
    self.width = nil
    self.height = nil

    self:redrawCanvas()
end

function Image9Slice:resizeScaleX(sx)
    self.sx = sx
    self.width = nil
    self.height = nil

    self:redrawCanvas()
end

function Image9Slice:resizeScaleY(sy)
    self.sy = sy
    self.width = nil
    self.height = nil

    self:redrawCanvas()
end
