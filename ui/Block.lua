local Signal = require('libraries.hump.signal')
local Class  = require('libraries.class.class')

local function round (x)
    return math.floor(x + 0.5)
end

local function zoom (t, zoom)
    if not zoom or zoom == 1 then
        return t
    end

    for k, v in pairs(t) do
        t[k] = v * zoom
    end

    return t
end

local function drawBorder (block)
    love.graphics.rectangle('line',
                            block._cell.x, block._cell.y, block._cell.w, block._cell.h)
end

local Block = Class:subclass('Block')

function Block:new()
    self.visible = self.visible or true
    self.pad     = self.pad     or 0
    self.align   = self.align   or 'center'
    self.drawOn  = self.drawOn  or { x = 0, y = 0 }
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

    return self._size.x + self.pad, self._size.y + self.pad
end

function Block:place(x, y, w, h)
    self._cell = { x = x, y = y, w = w, h = h }

    local sx, sy = self:size()

    -- Take the drawOn into account
    w = self.drawOn.width  or (w - self.drawOn.x)
    h = self.drawOn.height or (h - self.drawOn.y)
    x = x + self.drawOn.x
    y = y + self.drawOn.y

    self:doPlace(x, y, w, h)

    if not self.on then
        return
    end

    for _, item in ipairs(self.on) do
        if self.drawMap then
            local drawArea = self.drawMap[item.drawOn]
            if drawArea then
                item.drawOn = zoom(drawArea, self.drawMap.zoom)
            end
        end
        item:place(self.x, self.y, sx, sy)
    end
end

function Block:doPlace(x, y, w, h)
    local sx, sy = self:size()

    -- Initial position at the center of the enclosing cell
    self.x = round(x + (w - sx) / 2)
    self.y = round(y + (h - sy) / 2)

    if w < sx or h < sy then
       print("Warning: the size of the element exceeds its cell bounds")
    end

    local move = {
        ['left']   = function()
            self.x = x + self.pad
        end,

        ['right']  = function()
            self.x = x + (w - sx) - self.pad
        end,

        ['bottom'] = function()
            self.y = y + (h - sy) - self.pad
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
            for _, childOn in ipairs(block.on) do
                table.insert(stack, childOn)
            end
        end
        return block
    end, { self }
end

return Block
