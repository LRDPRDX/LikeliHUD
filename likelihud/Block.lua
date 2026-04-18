--- **START HERE**. The base class of every element in the system.
--
-- **Introduction**
--
-- (words/letters in **bold** in this section refer to the ones in the Fig. 1
-- below)
--
-- * A _block_ is used to denote an element of a graphical user interface in
-- this library
-- (**BLOCK**), another famous name for this is _widget_ but I will be using
-- _element_ / _block_
-- interchangeable here.
-- * The coordinate system as it is in
-- [love2d](https://www.love2d.org/wiki/love.graphics).
-- * A _rectangle_ we define by the coordinate of its upper-left corner and
-- its width
-- and height. I.e. it is a tuple (x, y, w, h).
-- In Lua a rectangle would be a table with 4 keys `x, y, w, h`:
--    local rectangle = {
--      x = 10,
--      y = 20,
--      w = 100,
--      h = 50,
--    }
-- * The _enclosing cell_ of a block is a rectangle which the block is placed
-- in, **(X, Y, W, H)**
-- . In order to place the block use its `place` method. _NOTE:_ you are
-- not supposed to use this method on every block in your GUI, you usually
-- call it once on the root
-- block. See `Layout`. So placing an element on the screen requires not only
-- the
-- coordinate but the whole rectangle. _NOTE:_ `place` itself doesn't draw
-- anything. Use the
-- block's `draw` method to actually draw it.
--
-- `likeliHUD` was created with the following objectives:
--
-- * Declarative construction (similar to QML)
-- * Everything is a rectangle
-- * Automatic layout (but see the `offset` parameter below)
--
-- A typical user workflow consists of at least 3 steps when using this
-- library
--
-- * Create
-- * Place
-- * Draw
--
-- **Create**
--
-- _Declarative construction_ means you create a _block tree_ which represents
-- your UI.
-- Blocks can have properties and embedded (children) blocks.
-- _Properties_ go in the hash part of the block (in the end every block is a
-- Lua table)
-- i.e. key-value pairs; _children_ elements is the array part of the block.
-- However, see the
-- `inside` property in the description of the `new` method. A simple example of
-- an object tree which has the following diagram (properties and their values
-- are written in the
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
-- This library treats every block (**BLOCK**) as a rectangle of some width
-- **a** and
-- height **b**
-- placed inside its enclosing cell **(X, Y, W, H)**. It may also have some
-- pads **pad** and/or
-- offset **(Xo, Yo, Wo, Ho)**.
-- Below you can see a figure which we'll be referring to in this
-- documentation a lot:
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
-- One more time: to place an element you call its `place` method with the
-- enclosing cell as an
-- argument (actually it is 4 arguments, but you get the idea). Don't be
-- afraid - you are not
-- going to call this method on each element in your UI - usually only the
-- root element is placed
-- explicitly.
--
-- **Draw**
--
-- In order to draw an element call its `draw` method. Similarly to `place`
-- you usually call it
-- once (per frame) for the root element.
--
-- See below for details.
-- @classmod Block

local Class  = require('subclass')

local UI    = (...):gsub('Block$', '')
local utils = require(UI .. 'utils')

local function initMouseFSM(self)
    local f = function (g)
        return g and function ()
            g(self)
        end
    end

    local m = self.mouse

    return utils.FSM {
        events = {
            'press',
            'inside',
            'outside',
            'release',
        },

        states = {
            'idle',
            'hovered',
            'pressed'
        },

        transitions = {
            [ 'press' ]   = {
                ['hovered'] = { state = 'pressed', action = f(m.onPress) }
            },
            [ 'inside' ]  = {
                ['idle']    = { state = 'hovered', action = f(m.onEnter) }
            },
            [ 'outside' ] = {
                ['pressed'] = { state = 'idle', action = f(m.onExit) },
                ['hovered'] = { state = 'idle', action = f(m.onExit) },
            },
            [ 'release' ] = {
                ['pressed'] = { state = 'hovered', action = f(m.onClick) }
            },
        },

        initial = 'idle'
    }
end

local function drawBorder (block)
    love.graphics.rectangle('line',
                            block._cell.x, block._cell.y, block._cell.w, block._cell.h)
end

--- Represents a _block_.
-- @type Block
local Block = Class:subclass('Block')

--- Constructor.
-- The user is not supposed to explicitly call this method. It's called
-- automatically when an
-- instance of Block is created. See
-- [here](https://lrdprdx.github.io/lua-class/) for details.
-- When created a block can be given properties. The list of the properties
-- below is common for
-- all blocks in this library. _NOTE:_ though can be given some properties
-- might be ignored by
-- a block either because of the type of the block and/or different
-- circumstances. F.e. the
-- `fill` property only makes sense when the block is placed inside a
-- `Layout`.
--
-- * `visible` : boolean.
-- `true` (default) means the element is visible (drawn). Otherwise it is not
-- visible
--
-- * `font` : a font (default is `love.graphics.getFont()`). Used internally by some blocks
-- like `TextField`.
-- * `color`: a color like in
-- [love2d](https://www.love2d.org/wiki/love.graphics.setColor)
-- (the table variant). For different block types this property might have a different
-- meaning. See concrete
-- type. Default is nil.
-- * `pad` : a non-negative number. The minimum gap between the block's border
-- and the
-- enclosing cell (see Fig. 1). It can be greater than the pad because of the
-- `offset` parameter. _NOTE:_ the pad along the x-axis is eqaul to the pad
-- along the y-axis.
-- * `align` : Alignment of the block inside its enclosing cell.
-- A string containing one or two words
-- `'center'` (default), `'top', 'bottom', 'left', 'right'` delimited by the
-- `+` sign. For example,
-- `'top+right'` (equivalent to `'right+top'`).
-- _NOTE:_ this string must be consistent: it doesn't make sense to have
-- something
-- like `'top+bottom'` (`'top'` will be set), or `'left+right'` (`'right'`
-- will be set). In other
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
-- * `fill` : a table of the form `{ x = boolean, y = boolean }`. Tells
-- whether the block should
-- occupy free space (along the corresponding axis) if placed inside a Layout.
-- See `Layout:new`.
-- * `offset` : a rectangle **(Xo, Yo, Wo, Ho)**. Modifies the enclosing cell
-- (X, Y, W, H) of
-- the element (which was given by calling the `place` method) by adding (Xo,
-- Yo) to (X, Y) and
-- overriding (W, H) by (Wo, Ho).
-- In other words, placing the element with the `offset` field (Xo, Yo, Wo,
-- Ho) inside
-- the cell (X, Y, W, H) is the same as placing this element inside the
-- cell (X + Xo, Y + Yo, Wo, Ho). See Fig. 1.
-- Usually used together with the `inside` element (see below).
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
--        element:place(10, 10, 300, 300) -- actually placed in (20, 30, 200,
--        200)
--
-- * `inside` : a block. Special property which value must be a block. Let us
-- explain the meaning of
-- the `inside` property looking at the following example:
--
--        local UI = ui.Rectangle {
--          id = 'A'
--
--          w = 100,
--          h = 50,
--
--          inside = {
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
-- as you can see now the enclosing cell of **B** is **A** itself, namely,
-- (A.x, A.y, A.w, A.h).
-- In other words **B** is automatically placed _inside_ **A**. This property
-- together with the
-- `offset` one makes it possible to integrate elements (usually `Label`) into
-- images. F.e.,
-- suppose you drew a health bar image:
--
--        ╭─────────────────╮
--        │■───────────────■│◀︎- cool health bar image
--        ││ area for text ││
--        │■───────────────■│
--        ╰─────────────────╯
-- and you want the text showing the health is always centered inside this
-- image wherever
-- the bar is placed. All you need is to place a `Label` inside this image
-- with the right offset:
--
--        local hp = ui.Image {
--          path = 'path/to/image.png',
--
--          inside = {
--            ui.Label {
--              text = '100',
--              offset = {
--                -- area for text
--              }
--            }
--          }
--        }
-- Now wherever `hp` is placed the text inside it is placed correctly
-- automatically.
--
-- * `filter` : a function. It is supposed to filter the events if pushed
-- to the element. See the <a href="#Events">Events</a> section for details.
--
-- * `mouse` : a table or boolean. Used to make a block react to mouse events
-- (can be used to
-- make buttons).
-- A boolean used by some basic blocks in this library.
-- In most cases this is a table containing mouse callbacks. There are 4 mouse
-- callbacks available:
--    * `onExit` : called each time the mouse (cursor) leaves the block
--    * `onEnter` : called each time the mouse enters the block
--    * `onPress` : called each time the mouse is pressed inside the block
--    * `onClicked` : called each time the mouse is pressed __and__ released
--    inside the block
--
-- The mouse actually is an FSM
-- ([wiki](https://en.wikipedia.org/wiki/Finite-state_machine))
-- which diagram you can see below:
--
--    Fig.4 Mouse FSM
--
--                   outside/onExit
--    *     ┌───────────────────────────────┐                      ┌─────┐
--    │     │                               │                 ┌────▶State├───┐
--    │     │                               │                 │    └─────┘   │
--    │ ┌───▼─────┐    inside/onEnter    ┌──┴──────┐          │              │
--    │ │  Idle   │──────────────────────▶  Hover  │          │ event/action │
--    └─▶(initial)│                      │         │          └──────────────┘
--      └─▲───────┘                      └───┬───▲─┘
--        │              press/onPressed     │   │
--        │                    ┌─────────────┘   │
--        │                    │                 │
--        │                    │                 │
--        │                  ┌─▼─────────┐       │release/onClick
--        │  outside/onExit  │  Pressed  │       │
--        └──────────────────│           ├───────┘
--                           └───────────┘
--
-- So there are 4 events managing the mouse FSM:
--
-- * `press`
-- * `inside`
-- * `outside`
-- * `release`
--
-- Each mouse callback accepts up to 1 (one) argument: if passed it is
-- supposed to be the block itself (`self`).
-- This is how it can be used:
--    ui.Rectangle {
--        w = 200,
--        h = 200,
--        color = { 1, 0, 0 },
--        mouse = {
--            onExit  = function () print('Bye, cursor !') end,
--            onEnter = function () print('Hello, cursor !') end,
--            onPress = function (self) self.color = { 0, 0, 1 } end,
--            onClick = function (self) self.color = { 0, 1, 0 } end,
--        }
--    }
-- Note how in the example above the `onExit` and `onEnter` callbacks
-- don't have parameters. But each
-- time the mouse is pressed or clicked inside the rectangle `onPress` and
-- `onClick`
-- are used to change the `color` property of the rectangle.
function Block:new()
    self.focus   = false
    self.visible = self.visible or true
    self.pad     = self.pad     or 0
    self.align   = self.align   or 'center'
    self.fill    = self.fill    or { x = true, y = true }
    self.font    = self.font    or love.graphics.getFont()

    for _, child in ipairs(self) do
        child.parent = self
    end

    if self.inside then
        for _, child in ipairs(self.inside) do
            child.parent = self
        end
    end
end

--- Returns the size of the block.
-- The size of the block is the minimum rectangle which the block can be
-- placed in,
-- in the form of a table `{ x = width, y = height }`.
-- @param includePad If `true` then the pads of the block are included
-- (**AxB** in Fig. 1).
-- If `nil` (default) or `false` the pads are not included (**axb** in the
-- figure above)
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
-- only after the block was placed by calling its `place` method. Otherwise it
-- stays `nil`.
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

    if not self.inside then
        return
    end

    -- Place blocks that use this block as a coordinate reference
    for _, item in ipairs(self.inside) do
        item:place(self.x, self.y, s.x, s.y)
    end
end

--- Draws the block.
-- Used to draw the block. Usually you don't want to call it on every block in
-- your GUI - only
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

        if self.inside then
            for _, item in ipairs(self.inside) do
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
-- for b in UI:traverse() do
--   b.border = true
-- end
--
-- TODO: filtered traversal
function Block:traverse()
    return function (stack)
        if #stack == 0 then return nil end
        local block = table.remove(stack)

        for _, child in ipairs(block) do
            table.insert(stack, child)
        end

        if block.inside then
            for _, child in ipairs(block.inside) do
                table.insert(stack, child)
            end
        end
        return block
    end, { self }
end

--- Mouse movement handler.
-- . Parameters are the same as in
-- [love.mousemoved](https://www.love2d.org/wiki/love.mousemoved)
function Block:mousemoved(x, y, dx, dy, istouch)
    if not self.mouse then
        return
    end

    self:doMousemoved(x, y, dx, dy, istouch)
end

--- Mouse press handler.
-- Mouse press handler. Parameters are the same as in
-- [love.mousepressed](https://www.love2d.org/wiki/love.mousepressed)
function Block:mousepressed(x, y, button, istouch, presses)
    if not self.mouse then
        return
    end

    self:doMousepressed(x, y, button, istouch, presses)
end

--- Mouse release handler.
-- Mouse release handler. Parameters are the same as in
-- [love.mousereleased](https://www.love2d.org/wiki/love.mousereleased)
function Block:mousereleased(x, y, button, istouch, presses)
    if not self.mouse then
        return
    end

    self:doMousereleased(x, y, button, istouch, presses)
end

--- Events.
-- Communication with the external world is defined through the use of `Event`'s.
-- Events can go in two directions: from the external world to a block, and vice versa.
-- The mechanisms are different in each case.
--
-- See the diagram on Fig. 5.
--
--
--    Fig. 5
--
--    External world
--
--    ┌────────────┐                  ┌───────────────────────────┐
--    │ Event      ├──────push───────────┐      BLOCK             │
--    └────────────┘                  │  │                        │
--                                    │  │   on = {               │
--                                    │  └───▶ event = function ()│
--                                    │      }                    │
--    ┌────────────┐                  │                           │
--    │ Queue      │                  │           ┌───────┐       │
--    │            │                  │      emit │Event  │       │
--    │  - event   │                  │           └───┬───┘       │
--    │  - event   │<─────emit────────────────────────┘           │
--    └─┬──────────┘                  └───────────────────────────┘
--      │
--      │
--      │                ┌───────────┐
--      │                │ process   │
--      └────────────────▶           │
--                       │ events    │
--                       └───────────┘
--
--
-- To deliver an event _to_ a block tree you use the
-- `Block:push` method (see below).
--
-- An `Event` in this case is any table with the mandatory `id` key and optional
-- data and/or filter. For example, this table can be an `Event`:
--
--    local event = {
--      id = 'button.pressed',
--      key = 'space',
--    }
--
-- or this
--
--    local event = {
--      id = 'backspace',
--      filter = function (self) return self.focus end -- only those which are focused
--    }
--
-- or this
--
--    local event = {
--      id = 'change.color',
--      color = { 0.5, 0.5, 0.5 },
--      filter = function (self) return self.border end, -- but only those with the border
--    }
--
-- Note how the 'filter' field is a function and the target block passed as an argument.
--
-- The block which is supposed to react on events must have the
-- corresponding `on` property of the following structure:
--
--    local l = ui.Label {
--      text = 'hello',
--      on = {
--        ['text.changed'] = function (self, event)
--          self.text = event.message
--        end
--      }
--    }
--
-- i.e. it is a table where keys are events' IDs and values are
-- callbacks to those events.
-- A callback accepts two arguments: the block itself (`self`), and the event.
-- _NOTE:_ a callback can return a value. If it returns `true` it means that the event was
-- accepted. Once the event is accepted a special field `swallowed` is set to `true` on the
-- event. This is useful when you want to push an event to the UI tree and if it was not
-- accepted (by the tree) you use it somehow further. As an example consider you use
-- the `q` button in order to exit your game but what if you have a text field focused at that
-- moment. You don't want to exit this time, instead the `q` symbol should be printed in the
-- field.
--
-- To send an event to a block you call the `push` method on the block with
-- the event as the only argument:
--
--    l:push { id = 'text.changed', message = 'world' }
--
--  This call will propagate the event to
--  the label and call the corresponding function with 2 arguments:
--  `self` is the label object, and the `event` itself.
--
--  In order to see if the event was accepted you have to store the event into a variable and
--  then check for the `swallowed` field:
--
--    local event = { id = 'text.changed', message = 'world' }
--    l:push(event)
--    if event.swallowed then
--      ...
--    end
--
-- See the `events.lua` file for an example.
--
-- If you want to emit an event _from_ a block on the other hand you use the `Block:emit` method.
-- Before doing that you must register the event queue for the block tree you want emit signals
-- from, and then later handle the events in that queue. It means that in order to, for example,
-- affect one element (from a block tree) from another you need to do it in 2 steps:
-- you emit an event from one element, and then when you handle that event you push another
-- event back to the block tree. See an example below.
--
-- See also the `buttons.lua` for an example. (The queue is registered and processed in main.lua)
--
-- @section signals

--- Pushes an event to the block and to all of its children down the tree.
-- @param event A table. _NOTE_: it MUST have the `id` key which is often just
-- a string.
-- @see
-- Block:filter
function Block:push (event)
    if event.filter and not event.filter(self) then
        return
    end

    local callback = self.on and self.on[event.id]
    if callback then
        if callback (self, event) then
            event.swallowed = true
        end
    end

    local isAllowed = self:filter(event)
    if not isAllowed then -- break propagation
        return
    end

    for _, child in ipairs(self) do
        child:push (event)
    end

    if self.inside then
        for _, child in ipairs(self.inside) do
            child:push (event)
        end
    end
end

--- It says whether the event should propagate further down the tree or not.
-- And also can be used to modify the event: so the children blocks will get
-- a modified event.
-- @param event Event to be passed. _NOTE_: DON'T modify this event
-- inside this function (if overriden). If you want to modify the event
-- create a new one inside this function and return it
-- (see the 2nd return value).
-- @return A boolean.
-- `true` means that `event` propagates down the tree (i.e. to the children).
-- `false` means the event is filtered out and the propagation breaks.
-- _NOTE_: you can either pass this function as a property in the constructor
-- or override the method. See `events.lua` for an example.
-- @see
-- Block:push
function Block:filter (event)
    return true
end

--- Registers the event queue.
-- Registers the event queue for this block and all of its children. Every time an element
-- emits an event it will be inserted into this queue. You can later iterate over the queue and
-- handle the events.
-- _NOTE:_ you can unregister the queue by calling this method with no arguments.
-- _NOTE:_ Once you've done processing the queue
-- you MUST clear the queue. **Don't** reassign the queue to an empty table - it will break
-- the reference.
-- _NOTE:_ If you have modified the block tree by adding new elements **after** registering the
-- queue for the tree, be sure you re-register the queue after adding new elements --
-- otherwise those
-- elements will have no queue at all (adding elements doesn't automatically register
-- the queue for those elements).
-- You can use the `Utils.clearArray` function to clear your queue.
--
-- @param queue [optional] A table.
-- @usage
--
-- local UI = ui.Layout {
--   ui.ImageButton {
--     onClick = function (self)
--       self:emit('button.pressed')
--     end
--   },
--
--   ui.Label {
--     text = 'Foo'
--   }
-- }
--
-- local queue = {} -- this is your queue
-- UI:registerQ(queue)
--
-- -- Process events
-- for i, event in ipairs(queue) do
--   print(event) -- prints 'button.pressed'
-- end
--
-- -- Clear the queue
-- utils.clearArray(queue)
-- -- Don't do the following to clear the queue
-- -- queue = {} -- this will break the reference
--
-- @see Block:emit
-- @see Utils.clearArray
function Block:registerQ (queue)
    self.queue = queue

    for child in self:traverse() do
        child.queue = queue
    end
end

--- Focuses this block and every its parent upwards the tree.
-- _NOTE:_ this function also removes focus from the subtree that has focus at the time
-- of calling this function if any. I.E. only one chain may be focused at a time.
-- Intended to be used internally. Doesn't do anything if the block is already focused.
-- @see Block:unsetFocus
-- @see focus.lua
function Block:setFocus ()
    if self.focus then
        return
    end

    -- Go up until we find a focused parent
    local parent = self.parent
    while parent do
        if parent.focus == true then
            -- when found unfocus the subtree starting from that parent with
            -- the parent itself excluded
            parent:unsetFocus(true)
            break
        end
        parent = parent.parent
    end

    -- Go up again but this time focus every parent up to
    -- the one we stopped in the procedure above
    self.focus = true
    parent = self.parent
    while parent do
        if parent.focus == true then
            return
        end

        parent.focus = true
        parent = parent.parent
    end
end

--- Removes focus from this block and all focused children downwards the tree.
-- @param skipSelf A boolean (default `false`). If `true` removes focus of all children but
-- not this block itself.
-- Intended to be used internally.
-- @see Block:setFocus
function Block:unsetFocus (skipSelf)
    local block = self

    if skipSelf then
        goto skip_self
    end

    ::iteration::
    block.focus = false
    ::skip_self::

    for _, child in ipairs(block) do
        if child.focus == true then
            block = child
            goto iteration
        end
    end

    if not block.inside then
        return
    end

    for _, child in ipairs(block.inside) do
        if child.focus == true then
            block = child
            goto iteration
        end
    end
end

--- Emits an event by putting it inside the queue of this element which was registered
-- with the `Block:registerQ` method. Doesn't do anything if the queue is not registered. 
-- @param event Anything that can be inserted in the queue and handled later. I recommend to put
-- an Event as described in the beginning of this section, namely, a table like this:
-- `{ id = 'next.page', data = 2 }`. But you can emit anything you can later identify and handle.
--
-- @see Block:registerQ
function Block:emit (event)
    if not self.queue then
        return
    end

    table.insert(self.queue, event)
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
    self.x = utils.round(x + (w - s.x) / 2)
    self.y = utils.round(y + (h - s.y) / 2)

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

function Block:mouseFSM ()
    if not self.mouse.fsm then
        self.mouse.fsm = initMouseFSM(self)
    end

    return self.mouse.fsm
end

--- Mouse moved.
-- A block can override this function.
--
-- ⚠️ Care must be taken when overriding this function. As stated in
-- `Block:new` this function manages the internal mouse FSM - if
-- overridden incorrectly it can cause inconsistent behaviour. If you need
-- to override this function you probably want to `doMousepressed` and
-- `doMousereleased` also.
--
-- See `Block:mousemoved` for parameter description.
function Block:doMousemoved (x, y, _, _, _)
    local s   = self:size()
    local fsm = self:mouseFSM()

    if utils.inside(x, y, self.x, self.y, s.x, s.y) then
        fsm:process('inside')
    else
        fsm:process('outside')
    end
end

--- Mouse pressed.
-- A block can override this function.
--
-- ⚠️ Care must be taken when overriding this function. As stated in
-- `Block:new` this function manages the internal mouse FSM - if
-- overridden incorrectly it can cause inconsistent behaviour. If you need
-- to override this function you probably want to `doMousemoved` and
-- `doMousereleased` also.
--
-- See `Block:mousepressed` for parameter description.
function Block:doMousepressed (_, _, _, _, _)
    local fsm = self:mouseFSM()
    fsm:process('press')
end

--- Mouse released.
-- A block can override this function.
--
-- ⚠️ Care must be taken when overriding this function. As stated in
-- `Block:new` this function manages the internal mouse FSM - if
-- overridden incorrectly it can cause inconsistent behaviour. If you need
-- to override this function you probably want to `doMousemoved` and
-- `doMousepressed` also.
--
-- See `Block:mousereleased` for parameter description.
function Block:doMousereleased (_, _, _, _, _)
    local fsm = self:mouseFSM()
    fsm:process('release')
end

return Block
