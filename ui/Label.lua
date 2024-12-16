local UI = (...):gsub('Label$', '')
local Block = require(UI .. 'Block')

local Label = setmetatable({
    __call = function(cls, args)
        return cls:new(args)
    end }, Block)
Label.__index = Label

function Label:new(o)
    return setmetatable(o, self)
end

function Label:doSize()
    local font = love.graphics.getFont()
    return { x = font:getWidth(self.text),
             y = font:getHeight(self.text) }
end

function Label:doDraw()
    if self.color then
        love.graphics.setColor(self.color)
    end

    love.graphics.print(self.text, self.x, self.y)
end

return Label
