--- **START HERE**. Parent of every element in the system.
--
-- **Introduction**
--
-- (words/letters in **bold** in this section refer to the ones in the Fig. 1 below)
--
-- * A _block_ is used to denote an element of a graphical user interface in this library
-- (**BLOCK**), another famous name for this is _widget_ but I will be using _element_ / _block_
-- interchangeable here.
-- * The coordinate system as it is in
-- [love2d](https://www.love2d.org/wiki/love.graphics).
-- * A _rectangle_ we define by the coordinate of its upper-left corner and its width
-- and height. I.e. it is a tuple (x, y, w, h).
-- In Lua a rectangle would be a table with 4 keys `x, y, w, h`:
--    local rectangle = {
--      x = 10,
--      y = 20,
--      w = 100,
--      h = 50,
--    }
-- * The _enclosing cell_ of a block is a rectangle which the block is placed in, **(X, Y, W, H)**
-- . In order to place the block use its `place` method. _NOTE:_ you are
-- not supposed to use this method on every block in your GUI, you usually call it once on the root
-- block. See `Layout`. So placing an element on the screen requires not only the
-- coordinate but the whole rectangle. _NOTE:_ `place` itself doesn't draw anything. Use the
-- block's `draw` method to actually draw it.
--
-- `likeliHUD` was created with the following objectives:
--
-- * Declarative construction (similar to QML)
-- * Everything is a rectangle
-- * Automatic layout (but see the `offset` parameter below)
--
-- A typical user workflow consists of at least 3 steps when using this library
--
-- * Create
-- * Place
-- * Draw
--
-- **Create**
--
-- _Declarative construction_ means you create a _block tree_ which represents your UI.
-- Blocks can have properties and embedded (children) blocks.
-- _Properties_ go in the hash part of the block (in the end every block is a Lua table)
-- i.e. key-value pairs; _children_ elements is the array part of the block. However, see the
-- `on` property in the description of the `new` method. A simple example of
-- an object tree which has the following diagram (properties and their values are written in the
-- parentheses)
--
--    A1 (a: 1)
--    ├───B1 (b: 2)
--    │   ├───B2 (b: 3)
--    │   ├───B3 (b: 4)
--    │   ├───B4 (b: 5)
--    │
--    ├───C1 (c: 1)
--        ├───C2 (c: 2)
--
-- can be created with the following code:
--
--    local root = A1 {
--      a = 1,
--
--      B1 {
--        b = 2,
--
--        B2 {
--          b = 3,
--        },
--
--        B3 {
--          b = 4,
--        },
--
--        B4 {
--          b = 5,
--        },
--      },
--
--      C1 {
--        c = 1,
--
--        C2 {
--          c = 2,
--        }
--      }
--    }
--
-- **Place**
--
-- This library treats every block (**BLOCK**) as a rectangle of some width **a** and
-- height **b**
-- placed inside its enclosing cell **(X, Y, W, H)**. It may also have some pads **pad** and/or
-- offset **(Xo, Yo, Wo, Ho)**.
-- Below you can see a figure which we'll be referring to in this documentation a lot:
--
--    Fig.1
--                         Enclosing cell
--                               ┆
--                               ┆       offset
--                               ┆          ┆
--    (X, Y)                     ▼          ┆
--      ■───────────────────────────────────┆────────────────────╮
--      │          ▲                        ┆                    │
--      │          Yo                       ┆                    │
--      │          ▼                        ▼                    │
--      │       ■──────────────────────────────────┬──────╮      │
--      │       │              ▲                   │      │      │
--      │◀︎ Xo  ▶︎│             Pad                  │      │      │
--      │       │   (Xs, Ys)   ▼                   │      │      │
--      │       │       ■──────────────────╮       │      │      │
--      │       │       │                  │       │      │      │
--      │       │◀︎ Pad ▶︎│      BLOCK       b       B      │      │
--      │       │       │                  │       │      Ho     H
--      │       │       ╰────────a─────────╯       │      │      │
--      │       │                                  │      │      │
--      │       │                                  │      │      │
--      │       │                                  │      │      │
--      │       ├─────────────────A────────────────╯      │      │
--      │       │                                         │      │
--      │       ╰───────────────────Wo────────────────────╯      │
--      │                                                        │
--      │                                                        │
--      │                                                        │
--      ╰───────────────────────────W────────────────────────────╯
--
-- This is the code that corresponds to the figure:
--
--    local BLOCK = ui.Rectangle {
--      w = a,
--      h = b,
--
--      offset = {
--        x = Xo,
--        y = Yo,
--        w = Wo,
--        h = Ho,
--      },
--
--      pad = Pad,
--    }
--
--    BLOCK:place(X, Y, W, H)
--
-- One more time: to place an element you call its `place` method with the enclosing cell as an
-- argument (actually it is 4 arguments, but you get the idea). Don't be afraid - you are not
-- going to call this method on each element in your UI - usually only the root element is placed
-- explicitly.
--
-- **Draw**
--
-- In order to draw an element call its `draw` method. Similarly to `place` you usually call it
-- once (per frame) for the root element.
--
-- See below for details.
-- @classmod Block

local Signal = require('libraries.hump.signal')
local Class  = require('libraries.class.class')

local function round (x)
    return math.floor(x + 0.5)
end

local function drawBorder (block)
    love.graphics.rectangle('line',
                            block._cell.x, block._cell.y, block._cell.w, block._cell.h)
end

--- Represents a _block_.
-- @type Block
local Block = Class:subclass('Block')

--- Constructor.
-- The user is not supposed to explicitly call this method. It's called automatically when an
-- instance of Block is created. See [here](https://lrdprdx.github.io/lua-class/) for details.
-- When created a block can be given properties. The list of the properties below is common for
-- all blocks in this library. _NOTE:_ though can be given some properties might be ignored by
-- a block either because of the type of the block and/or different circumstances. F.e. the
-- `fill` property only makes sense when the block is placed inside a `Layout`.
--
-- * `visible` : boolean.
-- `true` (default) means the element is visible (drawn). Otherwise it is not visible
-- * `color`: a color like in [love2d](https://www.love2d.org/wiki/love.graphics.setColor)
-- (the table variant). For different type of a block it has different meaning. See concrete
-- type. Default is nil.
-- * `pad` : a non-negative number. The minimum gap between the block's border and the
-- enclosing cell (see Fig. 1). It can be greater than the pad because of the
-- `offset` parameter. _NOTE:_ the pad along the x-axis is eqaul to the pad
-- along the y-axis.
-- * `align` : Alignment of the block inside its enclosing cell.
-- A string containing one or two words
-- `'center'` (default), `'top', 'bottom', 'left', 'right'` delimited by the `+` sign. For example,
-- `'top+right'` (equivalent to `'right+top'`).
-- _NOTE:_ this string must be consistent: it doesn't make sense to have something
-- like `'top+bottom'` (`'top'` will be set), or `'left+right'` (`'right'` will be set). In other
-- words there are only 9 options of alignment (* means default):
--
--        Fig.2
--
--        ╭────────────────┬────────────┬────────────────╮
--        │ top + left     │    top     │    top + right │
--        │                │            │                │
--        │                │            │                │
--        ├────────────────┼────────────┼────────────────┤
--        │                │            │                │
--        │ left           │   center*  │          right │
--        │                │            │                │
--        ├────────────────┼────────────┼────────────────┤
--        │                │            │                │
--        │                │            │                │
--        │ bottom + left  │   bottom   │ bottom + right │
--        ╰────────────────┴────────────┴────────────────╯
--
-- * `fill` : a table of the form `{ x = boolean, y = boolean }`. Tells whether the block should
-- occupy free space (along the corresponding axis) if placed inside a Layout. See `Layout:new`.
-- * `offset` : a rectangle **(Xo, Yo, Wo, Ho)**. Modifies the enclosing cell (X, Y, W, H) of
-- the element (which was given by calling the `place` method) by adding (Xo, Yo) to (X, Y) and
-- overriding (W, H) by (Wo, Ho).
-- In other words, placing the element with the `offset` field (Xo, Yo, Wo, Ho) inside
-- the cell (X, Y, W, H) is the same as placing this element inside the
-- cell (X + Xo, Y + Yo, Wo, Ho). See Fig. 1.
-- Usually used together with the `on` element (see below).
--
--        -- Rectangle is a Block
--        local element = ui.Rectangle {
--          w = 100,
--          h = 100,
--
--          offset = {
--            x = 10,
--            y = 20,
--            w = 200,
--            h = 200,
--          }
--        }
--
--        element:place(10, 10, 300, 300) -- actually placed in (20, 30, 200, 200)
--
-- * `on` : a block. Special property which value must be a block. Let us explain the meaning of
-- the `on` property looking at the following example:
--
--        local UI = ui.Rectangle {
--          id = 'A'
--
--          w = 100,
--          h = 50,
--
--          on = {
--            ui.Rectangle { -- the enclosing cell of this element is A itself
--              id = 'B',
--
--              w = 60,
--              h = 30,
--            }
--          }
--        }
--
--        UI:place(20, 20, 200, 200)
-- which produces the following diagram:
--
--        Fig.3
--
--                              Enclosing cell of A
--                                     ┆
--                                     ┆
--                                     ┆  Enclosing cell of B
--        (0, 0)                       ┆       ┆
--          ■──────────────────────────┆───────┆─────────────────╮
--          │          ▲               ┆       ┆                 │
--          │          20              ┆       ┆                 │
--          │          ▼               ▼       ┆                 │
--          │       ■──────────────────────────┆──────────╮      │
--          │       │                          ┆          │      │
--          │◀︎ 20  ▶︎│                          ┆          │      │
--          │       │                          ▼          │      │
--          │       │       ╭────────────────────╮        │      │
--          │       │       │A                   │        │      │
--          │       │       │   ╭────────────╮   │        │      │
--          │       │       │   │B           │  50        │      │
--          │       │       │   │           30   │       200     H (screen)
--          │       │       │   ╰─────60─────╯   │        │      │
--          │       │       │                    │        │      │
--          │       │       ╰────────100─────────╯        │      │
--          │       │                                     │      │
--          │       │                                     │      │
--          │       │                                     │      │
--          │       ╰───────────────────200───────────────╯      │
--          │                                                    │
--          │                                                    │
--          │                                                    │
--          ╰───────────────────────────W (screen)───────────────╯
-- as you can see now the enclosing cell of **B** is **A** itself, namely, (A.x, A.y, A.w, A.h).
-- In other words **B** is automatically placed _inside_ **A**. This property together with the
-- `offset` one makes it possible to integrate elements (usually `Label`) into images. F.e.,
-- suppose you drew a health bar image:
--
--        ╭─────────────────╮
--        │■───────────────■│◀︎- cool health bar image
--        ││ area for text ││
--        │■───────────────■│
--        ╰─────────────────╯
-- and you want the text showing the health is always centered inside this image wherever
-- the bar is placed. All you need is to place a `Label` inside this image with the right offset:
--
--        local hp = ui.Image {
--          path = 'path/to/image.png',
--
--          on = {
--            ui.Label {
--              text = '100',
--              offset = {
--                -- area for text
--              }
--            }
--          }
--        }
-- Now wherever `hp` is placed the text inside it is placed correctly automatically.
function Block:new()
    self.visible = self.visible or true
    self.pad     = self.pad     or 0
    self.align   = self.align   or 'center'
    self.fill    = self.fill    or { x = true, y = true }

    if self.signals then
        for k, f in pairs(self.signals) do
            Signal.register(k, function(...) f(self, ...) end)
        end
    end
end

--- Returns the size of the block.
-- The size of the block is the minimum rectangle which the block can be placed in,
-- in the form of a table `{ x = width, y = height }`.
-- @param includePad If `true` then the pads of the block are included
-- (**AxB** in Fig. 1).
-- If `nil` (default) or `false` the pads are not included (**axb** in the figure above)
-- @return A table of the form `{ x = width, y = height }`
function Block:size(includePad)
    if not self._size then
        self._size = self:doSize()
    end

    if includePad == true then
        return {
            x = self._size.x + 2 * self.pad,
            y = self._size.y + 2 * self.pad,
        }
    end

    return {
        x = self._size.x,
        y = self._size.y,
    }
end

function Block:doSize()
    return { x = 0, y = 0 }
end

--- Enclosing cell.
-- Returns the enclosing cell of the block.
-- @return The enclosing cell rectangle i.e. a table of the form
-- `{ x = cell.x, y = cell.y, w = cell.w, h = cell.h }`, or `nil`.
-- _NOTE:_ the enclosing cell is initialized
-- only after the block was placed by calling its `place` method. Otherwise it stays `nil`.
-- @usage
-- local r = ui.Rectangle {
--   w = 100,
--   h = 200,
-- }
--
-- local c = r:cell() --> c == nil
--
-- r:place(10, 10, 300, 300)
--
-- local c = r:cell() --> c = { x = 10, y = 10, w = 300, h = 300 }
function Block:cell()
    if not self._cell then
        return nil
    end

    return {
        x = self._cell.x,
        y = self._cell.y,
        w = self._cell.w,
        h = self._cell.h,
    }
end

--- Places the block within specified enclosing cell.
-- @param x x coordinate of the cell (**X** in the Fig. 1)
-- @param y y coordinate of the cell (**Y** in the Fig. 1)
-- @param w width of the cell (**W** in the Fig. 1)
-- @param h height of the cell (**H** in the Fig. 1)
function Block:place(x, y, w, h)
    -- Enclosing cell of the block
    self._cell = { x = x, y = y, w = w, h = h }

    local s = self:size()

    if self.offset then
        x = x + self.offset.x
        y = y + self.offset.y
        w = self.offset.width
        h = self.offset.height
    end

    x = x + self.pad
    y = y + self.pad
    w = w - 2 * self.pad
    h = h - 2 * self.pad

    if w < s.x or h < s.y then
        print("Warning: the size of the element exceeds its cell bounds")
    end

    self:doPlace(x, y, w, h)

    if not self.on then
        return
    end

    -- Place blocks that use this block as a coordinate reference
    for _, item in ipairs(self.on) do
        item:place(self.x, self.y, s.x, s.y)
    end
end

--- Draws the block.
-- Used to draw the block. Usually you don't want to call it on every block in your GUI - only
-- once for each root element.
function Block:draw()
    if not self.visible then
        return
    end

    love.graphics.push('all')
        if self.color then
            love.graphics.setColor(self.color)
        end

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

--- Block iterator.
-- Used to iterate over blocks in the hierarchy.
-- @usage
-- local UI = ui.Layout {
--   rows = 1,
--   columns = 2,
--
--   ui.Label {
--     text = 'foo'
--   },
--
--   ui.Label {
--     text = 'bar'
--   }
-- }
--
-- for i, b in UI:traverse() do
--   b.border = true
-- end
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

--- User defined blocks.
-- ⚠️ This section is not complete and to be done. ⚠️
-- @section override.

--- A block must override this function to be drawn. Does nothing by default.
function Block:doDraw()
    return
end

--- Placement.
-- A block should override this function to be placed.
-- Used to place the block within specified enclosing cell.
-- @param x x coordinate of the window
-- @param y y coordinate of the window
-- @param w width of the window
-- @param h height of the window
function Block:doPlace(x, y, w, h)
    local s = self:size()

    -- Initial position at the center of the enclosing cell
    self.x = round(x + (w - s.x) / 2)
    self.y = round(y + (h - s.y) / 2)

    local move = {
        ['left']   = function()
            self.x = x
        end,

        ['right']  = function()
            self.x = x + (w - s.x)
        end,

        ['bottom'] = function()
            self.y = y + (h - s.y)
        end,

        ['top']    = function()
            self.y = y
        end
    }

    for direction in self.align:gsub('%s+', ''):gmatch('([^+]+)') do
        if move[direction] then move[direction]() end
    end
end



return Block
