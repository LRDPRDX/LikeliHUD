local Signal = require('libraries.hump.signal')
local Class  = require('libraries.class.class')

local function round (x)
    return math.floor(x + 0.5)
end

local function drawBorder (block)
    love.graphics.rectangle('line',
                            block._cell.x, block._cell.y, block._cell.w, block._cell.h)
end

-- *******************
-- ****** BLOCK ******
-- *******************
local Block = Class:subclass('Block')

function Block:new()
    self.visible = self.visible or true
    self.pad     = self.pad     or 0
    self.align   = self.align   or 'center'
    self.offset  = self.offset  or { x = 0, y = 0 }
    self.fill    = self.fill    or { x = true, y = true }

    if self.signals then
        for k, f in pairs(self.signals) do
            Signal.register(k, function(...) f(self, ...) end)
        end
    end
end

function Block:size()
    if not self._size then
        self._size = self:doSize()
    end

    return {
        x = self._size.x,
        y = self._size.y,
    }
end

function Block:place(x, y, w, h)
    -- Enclosing cell of the block
    self._cell = { x = x, y = y, w = w, h = h }

    local s = self:size()

    -- Take offset into account
    x = x + self.offset.x
    y = y + self.offset.y
    w = self.offset.width  or (w - self.offset.x)
    h = self.offset.height or (h - self.offset.y)

    self:doPlace(x, y, w, h)

    if not self.on then
        return
    end

    -- Place blocks that use this block as a coordinate reference
    for _, item in ipairs(self.on) do
        item:place(self.x, self.y, s.x, s.y)
    end
end

function Block:doPlace(x, y, w, h)
    local s = self:size()

    -- Initial position at the center of the enclosing cell
    self.x = round(x + (w - s.x) / 2)
    self.y = round(y + (h - s.y) / 2)

    if w < s.x or h < s.y then
       print("Warning: the size of the element exceeds its cell bounds")
    end

    local move = {
        ['left']   = function()
            self.x = x + self.pad
        end,

        ['right']  = function()
            self.x = x + (w - s.x) - self.pad
        end,

        ['bottom'] = function()
            self.y = y + (h - s.y) - self.pad
        end,

        ['top']    = function()
            self.y = y + self.pad
        end
    }

    for direction in self.align:gsub('%s+', ''):gmatch('([^+]+)') do
        if move[direction] then move[direction]() end
    end
end

function Block:draw()
    if not self.visible then
        return
    end

    love.graphics.push('all')
        if self.border then
            drawBorder(self)
        end

        self:doDraw()

        if self.on then
            for _, item in ipairs(self.on) do
                item:draw()
            end
        end
    love.graphics.pop()
end

function Block:traverse()
    return function (stack)
        if #stack == 0 then return nil end
        local block = table.remove(stack)

        for _, child in ipairs(block) do
            table.insert(stack, child)
        end

        if block.on then
            for _, child in ipairs(block.on) do
                table.insert(stack, child)
            end
        end
        return block
    end, { self }
end

return Block
