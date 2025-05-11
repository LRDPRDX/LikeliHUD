local UI    = (...):gsub('Stack$', '')
local Block = require(UI .. 'Block')

local Stack = setmetatable({}, Block)
Stack.__index = Stack


function Stack:new(o)
    self = setmetatable(o, self)
    return self
end

function Stack:doPlace(x, y, w, h)
    for _, child in ipairs(self) do
        child:place(x, y, w, h)
    end
end

function Stack:doSize()
    local maxSX, maxSY = 0, 0

    for _, child in ipairs(self) do
        local sx, sy = child:size()
        maxSX = (sx > maxSX) and sx or maxSX
        maxSY = (sy > maxSY) and sy or maxSY
    end

    return { x = maxSX, y = maxSY }
end

function Stack:doDraw()
    for _, child in ipairs(self) do
        child:draw()
    end
end

return Stack
