--- Used to place blocks in a grid.
--
-- Places child blocks in a grid `rows` by `columns`. _NOTE:_ strictly speaking it places the
-- enclosing cells of its child elements in a grid - the blocks themselves may stay "unaligned"
-- because of different size and/or values of the `align` property (see Fig. 1).
--    Fig. 1
--
--      ■───▶︎ columns: 1, 2, 3, ...
--      │
--      ▼
--    rows: 1, 2, 3, ...
--
--                      Enclosing cell of a block
--                                ┆
--                                ┆
--                                ┆
--                                ┆
--    ■───────────────────────────┆───────────────────╮
--    │          ▲                ┆                   │
--    │          S                ┆                   │
--    │          ▼                ▼                   │
--    │       ■───────────╮       ■───────────╮       │
--    │       │           │       │           │       │
--    │◀︎  S  ▶︎│  ╭─────╮  │◀︎  S  ▶︎│           │◀︎  S  ▶︎│
--    │       │  │A    b  │       │    ╭─────╮│       │
--    │       │  ╰──a──╯  │       │    │B    ││       │
--    │       │           │       │    ╰─────╯│       │
--    │       ╰───────────╯       ╰───────────╯       │
--    │          ▲                                    │
--    │          S                                    │
--    │          ▼                                    │
--    │       ■───────────╮       ■───────────╮       │
--    │       │           │       │╭─────╮    │       │
--    │       │           │       ││C    │    │       │
--    │       │╭─────╮    │       │╰─────╯    │       │
--    │       ││D    │    │       │           │       │
--    │       │╰─────╯    │       │           │       │
--    │       ╰───────────╯       ╰───────────╯       │
--    │          ▲                                    │
--    │          S                                    │
--    │          ▼                                    │
--    ╰───────────────────────────────────────────────╯
--
-- The code which produces the UI shown in Fig. 1 is the following:
--
--    local layout = ui.Layout {
--      rows    = 2,
--      columns = 2,
--      spacing = S,
--
--      ui.Rectangle {
--        id = 'A',
--
--        w = a,
--        h = b,
--
--        align = 'center',
--      },
--
--      ui.Rectangle {
--        id = 'B',
--
--        w = a,
--        h = b,
--
--        align = 'bottom + right',
--      },
--
--      ui.Rectangle {
--        id = 'C',
--
--        w = a,
--        h = b,
--
--        align = 'bottom + left',
--      },
--
--      ui.Rectangle {
--        id = 'D',
--
--        w = a,
--        h = b,
--
--        align = 'top + left',
--      },
--    }
-- @classmod Layout
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

local function gridView (self)
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

local function preplace (self)
    local grid = gridView(self)

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
                local s = grid[r][c]:size(true)
                maxSY = maxSY and math.max(maxSY, s.y) or s.y
            end
        end

        maxSY = maxSY or 0

        for c = 1, self.columns do
            if grid[r][c].fill.y then rowsToFill[r] = true end
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
                local s = grid[r][c]:size(true)
                maxSX = maxSX and math.max(maxSX, s.x) or s.x
            end
        end

        maxSX = maxSX or 0

        for r = 1, self.rows do
            if grid[r][c].fill.x then columnsToFill[c] = true end
            grid[r][c]._cell.w = maxSX
        end
    end

    return rowsToFill, columnsToFill
end

--- Represents a layout.
-- @type Layout
local Layout = Block:subclass('Layout')

--- Constructor.
-- These are properties (in addition to the list in `Block:new`) relevant for this type of block:
--
-- * `rows` : a positive integer. The number of rows in the layout. Default is 1.
-- * `columns` : a positive integer. The number of columns in the layout. Default is 1.
-- * `spacing` :  a non-negative integer. The minimum distance between columns/rows _and_ between
-- the children's enclosing cells and the layout's one. Default is 10.
-- * `align` : ignored.
-- * `fill` : for a child element it means the element's enclosing cell fills empty space of the
-- layout's enclosing cell if any:
--        local layout = {
--          columns = 1,
--
--          ui.Rectangle {
--            id = 'A',
--
--            w = a,
--            h = b,
--
--            fill = { x = false, y = true },
--          },
--
--          ui.Rectangle {
--            id = 'B',
--
--            w = a,
--            h = b,
--
--            fill = { x = true, y = false },
--          }
--        }
--
--        layout:place(X, Y, W, H)
-- which results in the following diagram
--        Fig. 2
--
--        (X, Y)
--          ■────────────────────────────────────╮
--          │■───────────╮■─────────────────────╮│
--          ││           ││                     ││
--          ││  ╭─────╮  ││       ╭─────╮       ││
--          ││  │A    b  ││       │B    b       │H
--          ││  ╰──a──╯  ││       ╰──a──╯       ││
--          ││           ││                     ││
--          │╰───────────╯╰─────────────────────╯│
--          ╰─────────────────W──────────────────╯
-- _NOTE:_ as `Layout` places the enclosing cells of its child elements in a grid, if there is at
-- least one element in a row (column) that has `fill.y` (`fill.x`) equal to `true` then virtually
-- all elements in that row (column) fills the `y` (`x`) axis also. For example, in Fig. 2 you
-- can see that the **B**'s enclosing cell fills the y-axis despite the fact it
-- has `fill.y == false`. This is because **A** has `fill.y == true`.
--
-- See the `fill.lua` example to give it a taste.
function Layout:new()
    self.rows       = self.rows     or 1
    self.columns    = self.columns  or 1
    self.spacing    = self.spacing  or 10
end

function Layout:doPlace(x, y, w, h)
    if #self == 0 then
        return
    end

    local grid = gridView(self)

    local usedS = self:size(true)

    local rowsToFill, columnsToFill = preplace(self)
    local nRowsToFill, nColumnsToFill = len(rowsToFill), len(columnsToFill)

    local qW, rW = mod(w - usedS.x, nColumnsToFill)
    local qH, rH = mod(h - usedS.y, nRowsToFill)

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

    local grid = gridView(self)

    -- Height is the sum of maximum heights in each row
    local sy = 0
    for r = 1, self.rows do
        local maxSY = nil
        for c = 1, self.columns do
            if grid[r][c] then
                local s = grid[r][c]:size(true)
                maxSY = maxSY and math.max(maxSY, s.y) or s.y
            end
        end

        maxSY = maxSY or 0
        sy = sy + maxSY
    end

    -- Width is the sum of maximum widths in each column
    local sx = 0
    for c = 1, self.columns do
        local maxSX = nil
        for r = 1, self.rows do
            if grid[r][c] then
                local s = grid[r][c]:size(true)
                maxSX = maxSX and math.max(maxSX, s.x) or s.x
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
