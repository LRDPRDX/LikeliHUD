local UI    = (...):gsub('Stack$', '')
local Block = require(UI .. 'Block')

-- *******************
-- ****** STACK ******
-- *******************
local Stack = Block:subclass('Stack')

function Stack:doPlace(x, y, w, h)
    for _, child in ipairs(self) do
        child:place(x, y, w, h)
    end
end

function Stack:doSize()
    local maxSX, maxSY = 0, 0

    for _, child in ipairs(self) do
        local s = child:size()
        maxSX = (s.x > maxSX) and s.x or maxSX
        maxSY = (s.y > maxSY) and s.y or maxSY
    end

    return { x = maxSX, y = maxSY }
end

function Stack:doDraw()
    for _, child in ipairs(self) do
        child:draw()
    end
end

return Stack
