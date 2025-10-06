--- A rectangle.
--
-- Used primarily for testing purpose.
--
-- @classmod Rectangle
local UI = (...):gsub('Rectangle$', '')
local Block = require(UI .. 'Block')

--- Represents a rectangle.
-- @type Rectangle
local Rectangle = Block:subclass('Rectangle')

--- Constructor.
-- These are properties (in addition to the list in `Block:new`) relevant for this type of block:
--
-- * `w` : a non-negative integer. The width of the rectangle. Default is 10.
-- * `h` : a non-negative integer. The height of the rectangle. Default is 10.
-- * `color` : a color like in [love2d](https://www.love2d.org/wiki/love.graphics.setColor)
-- (the table variant). The rectangle is filled with this color.
-- @usage
-- local r = ui.Rectangle {
--   w = 100,
--   h = 50,
--   color = { 0, 0, 1, 1 },
-- }
function Rectangle:new()
    self.w = self.w or 10
    self.h = self.h or 10
end

function Rectangle:doSize()
    return { x = self.w, y = self.h }
end

function Rectangle:doDraw()
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

return Rectangle
