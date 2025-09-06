local UI = (...):gsub('Label$', '')
local Block = require(UI .. 'Block')

-- *******************
-- ****** LABEL ******
-- *******************
local Label = Block:subclass('Label')

function Label:new()
    self.text    = self.text    or ''
    self.maxText = self.maxText or self.text

    if #self.maxText < #self.text then
        self.maxText = self.text
    end
end

function Label:doSize()
    local font = love.graphics.getFont()
    return {
        x = font:getWidth(self.maxText),
        y = font:getHeight(self.maxText),
    }
end

function Label:doDraw()
    if self.color then
        love.graphics.setColor(self.color)
    end

    love.graphics.print(self.text, self.x, self.y)
end

return Label
