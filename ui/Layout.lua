local UI    = (...):gsub('Layout$', '')
local Block = require(UI .. 'Block')

local function mod (a, b)
    return math.floor(a / b), math.fmod(a, b)
end

local function len (array)
    local n = 0
    for _ in pairs(array) do
        n = n + 1
    end
    return n
end

local function preplace (self)
    local grid = self.gridView(self)

    for _, child in ipairs(self) do
        child._cell = {}
    end

    local rowsToFill = {}
    -- Find maximum height in each row.
    -- Those values will be initial cell heights.
    for r = 1, self.rows do
        local maxSY = nil
        for c = 1, self.columns do
            if grid[r][c] then
                local _, y = grid[r][c]:size()
                maxSY = maxSY and math.max(maxSY, y) or y
            end
        end

        maxSY = maxSY or 0

        for c = 1, self.columns do
            if grid[r][c].fillHeight then rowsToFill[r] = true end
            grid[r][c]._cell.h = maxSY
        end
    end

    local columnsToFill = {}
    -- Find maximum width in each column.
    -- Those values will be initial cell width.
    for c = 1, self.columns do
        local maxSX = nil
        for r = 1, self.rows do
            if grid[r][c] then
                local x, _ = grid[r][c]:size()
                maxSX = maxSX and math.max(maxSX, x) or x
            end
        end

        maxSX = maxSX or 0

        for r = 1, self.rows do
            if grid[r][c].fillWidth then columnsToFill[c] = true end
            grid[r][c]._cell.w = maxSX
        end
    end

    return rowsToFill, columnsToFill
end

local Layout = setmetatable({
    __call = function(cls, args)
        return cls:new(args)
    end, }, Block)
Layout.__index = Layout

function Layout:new(o)
    self = setmetatable(o, self)

    self.rows       = self.rows     or 1
    self.columns    = self.columns  or 1
    self.spacing    = self.spacing  or 10

    return self
end

function Layout:gridView()
    local grid = {}

    for r = 1, self.rows do
        grid[r] = {}
        for c = 1, self.columns do
            local i = (r - 1) * self.columns + c
            grid[r][c] = self[i]
        end
    end

    return grid
end

function Layout:doPlace(x, y, w, h)
    if #self == 0 then return end

    local grid = self:gridView()

    local usedX, usedY = self:size()

    local rowsToFill, columnsToFill = preplace(self)
    local nRowsToFill, nColumnsToFill = len(rowsToFill), len(columnsToFill)

    local qW, rW = mod(w - usedX, nColumnsToFill)
    local qH, rH = mod(h - usedY, nRowsToFill)

    -- Add extra space to the cells
    local curY = y + self.spacing
    for r = 1, self.rows do
        local curX = x + self.spacing
        local curH = grid[r][1]._cell.h
        if rowsToFill[r] then
            curH = curH + qH + ((rH > 0) and 1 or 0)
            rH = rH - 1
        end
        for c = 1, self.columns do
            local curW = grid[r][c]._cell.w
            if columnsToFill[c] then
                curW = curW + qW + ((rW > 0) and 1 or 0)
                rW = rW - 1
            end
            grid[r][c]:place(curX, curY, curW, curH)
            curX = curX + curW + self.spacing
        end
        curY = curY + curH + self.spacing
    end
end

function Layout:doSize()
    if #self == 0 then return { x = 0, y = 0 } end

    local grid = self:gridView()

    local sy = 0
    for r = 1, self.rows do
        local maxSY = nil
        for c = 1, self.columns do
            if grid[r][c] then
                local _, y = grid[r][c]:size()
                maxSY = maxSY and math.max(maxSY, y) or y
            end
        end

        maxSY = maxSY or 0
        sy = sy + maxSY
    end

    local sx = 0
    for c = 1, self.columns do
        local maxSX = nil
        for r = 1, self.rows do
            if grid[r][c] then
                local x, _ = grid[r][c]:size()
                maxSX = maxSX and math.max(maxSX, x) or x
            end
        end

        maxSX = maxSX or 0
        sx = sx + maxSX
    end

    return {
        x = sx + (self.columns + 1) * self.spacing,
        y = sy + (self.rows + 1) * self.spacing
    }
end

function Layout:doDraw()
    for _, child in ipairs(self) do
        child:draw()
    end
end

return Layout
