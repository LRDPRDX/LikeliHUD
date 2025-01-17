local Signal = require('libraries.hump.signal')

local function round (x)
    return math.floor(x + 0.5)
end

local Block = {
    visible    = true,
    pad        = 0,
    align      = 'center',
    drawOn     = { x = 0, y = 0 },
    fill       = { x = true, y = true },
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

    -- Take the drawOn into account
    w = self.drawOn.width or (w - self.drawOn.x)
    h = self.drawOn.height or (h - self.drawOn.y)
    x = x + self.drawOn.x
    y = y + self.drawOn.y

    self:doPlace(x, y, w, h)

    if not self.on then
        return
    end

    for _, item in ipairs(self.on) do
        if self.drawMap then
            item.drawOn = self.drawMap[item.drawOn] or item.drawOn
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
