local UI = (...):gsub('Rectangle$', '')
local Block = require(UI .. 'Block')

local Rectangle = setmetatable({}, Block)
Rectangle.__index = Rectangle

function Rectangle:new(o)
    return setmetatable(o, self)
end

function Rectangle:doSize()
    return { x = self.w, y = self.h }
end

function Rectangle:doDraw()
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

return Rectangle
