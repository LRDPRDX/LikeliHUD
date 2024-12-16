local Signal = require('libraries.hump.signal')

local function round (x)
    return math.floor(x + 0.5)
end

local Block = {
    visible    = true,
    fillWidth  = true,
    fillHeight = true,
    pad        = 0,
    align      = 'center',
    offset     = { x = 0, y = 0 }
}
Block.__index = Block

function Block.__call(cls, args)
    local signals = args['signals']
    args['signals'] = nil
    local instance = cls:new(args)
    if(signals) then
        for k, f in pairs(signals) do
            Signal.register(k, function(...) f(instance, ...) end)
        end
    end

    return instance
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

    -- Take the offset into account
    w = self.offset.w or (w - self.offset.x)
    h = self.offset.h or (h - self.offset.y)
    x = x + self.offset.x
    y = y + self.offset.y

    self:doPlace(x, y, w, h)

    if not self.inside then
        return
    end

    for _, item in ipairs(self.inside) do
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

    for direction in self.align:gmatch('([^+]+)') do
        if move[direction] then move[direction]() end
    end
end

function Block:drawBorder()
    love.graphics.rectangle('line', self._cell.x, self._cell.y, self._cell.w, self._cell.h)
end

function Block:draw()
    if not self.visible then
        return
    end

    love.graphics.push('all')
        if self.border then
            self:drawBorder()
        end

        self:doDraw()

        if self.inside then
            for _, item in ipairs(self.inside) do
                item:draw()
            end
        end
    love.graphics.pop()
end

return Block
