--- Used to place one block over another.
--
-- Places child blocks one "over" another. You already know how to place one
-- block over another
-- using the `on` property. This block just puts every child element inside
-- its enclosing cell
-- one by one, one over another. For example, provided you have this image:
--
--    Fig. 1
--
--    ┌────────┐
--    │  ▞▚▞▚  │
--    │  ▚  ▞  │
--    │   ▚▞   │
--    └────────┘
--
-- doing this
--
--    local stack = ui.Stack {
--      ui.Image {
--        path = 'foo.png',
--      },
--
--      ui.Label {
--        text = 'This is a stack'
--      },
--    }
--
--    stack:place(0, 0, 100, 100)
--    stack:draw()
--
-- will result in
--    Fig. 2
--
--      ┌────────┐
--      │  ▞▚▞▚  │
--    This is a stack
--      │   ▚▞   │
--      └────────┘
-- @classmod Stack
local UI    = (...):gsub('Stack$', '')
local Block = require(UI .. 'Block')

--- Represents a stack of elements.
-- @type Stack
local Stack = Block:subclass('Stack')

--- Constructor.
-- There are no special properties for this type of a block. However,
--
-- * `align` : ignored.
-- * `mouse` : mouse events are passed to the **top most** element only.
function Stack:new()
    self.mouse = self.mouse or true
end

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

function Stack:doMousemoved (x, y, button, istouch, presses)
    if #self == 0 then
        return
    end

    local top = self[#self]
    top:mousemoved(x, y, button, istouch, presses)
end

function Stack:doMousepressed (x, y, button, istouch, presses)
    if #self == 0 then
        return
    end

    local top = self[#self]
    top:mousepressed(x, y, button, istouch, presses)
end

function Stack:doMousereleased (x, y, button, istouch, presses)
    if #self == 0 then
        return
    end

    local top = self[#self]
    top:mousereleased(x, y, button, istouch, presses)
end

return Stack
