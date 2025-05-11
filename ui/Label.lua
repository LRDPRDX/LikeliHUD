local UI = (...):gsub('Label$', '')
local Block = require(UI .. 'Block')

local Label = setmetatable({}, Block)
Label.__index = Label

function Label:new(o)
    self = setmetatable(o, self)

    self.text    = self.text or ''
    self.maxText = self.maxText or self.text

    if #self.maxText < #self.text then
        self.maxText = self.text
    end

    return self
end

function Label:doSize()
    local font = love.graphics.getFont()
    return { x = font:getWidth(self.maxText),
             y = font:getHeight(self.maxText) }
end

function Label:doDraw()
    if self.color then
        love.graphics.setColor(self.color)
    end

    love.graphics.print(self.text, self.x, self.y)
end

return Label
