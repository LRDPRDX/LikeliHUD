--- Used to enter text.
-- @classmod TextField
local UI = (...):gsub('TextField$', '')
local Block = require(UI .. 'Block')

--- Represents a text field.
-- @type TextField
local TextField = Block:subclass('TextField')

local function update (self)
    local cursor = self.cursor
    local text   = self.text

    cursor.position = math.min(math.max(cursor.position, 0), text:len())
    cursor.x = self.font:getWidth(text:sub(1, cursor.position))

    if cursor.x + self.shift >= self.width then
        self.shift = self.width - cursor.x
    elseif cursor.x + self.shift <= 0 then
        self.shift = - cursor.x
    end
end

local function textinput (self, t)
    if self.text:len() >= self.maxLength then
        return
    end

    local cursor = self.cursor
    self.text = self.text:sub(1, cursor.position) .. t .. self.text:sub(cursor.position + 1)
    cursor.position = cursor.position + 1
end


local function backspace (self)
    local cursor = self.cursor
    if cursor.position <= 0 then
        return
    end

    cursor.position = cursor.position - 1
    self.text = self.text:sub(1, cursor.position) .. self.text:sub(cursor.position + 2)
end

local function left (self)
    local cursor = self.cursor
    cursor.position = cursor.position - 1
end

local function right (self)
    local cursor = self.cursor
    cursor.position = cursor.position + 1
end

--- Constructor.
--
-- * `text` : a string. The initial text to fill the text field with.
-- * `maxLength` : an integer (default 100).
-- The maximum length allowed for the text inside this text field.
-- * `margin` : an integer (default 10).
-- The number of pixels to display the content of the textfield
-- behind the left and right edges: useful to see whether there is text further
-- on the left (right) when the cursor at the left (right) edge (see Fig.1 below).
-- * `width` : an integer (default 100). The width of the text field. _NOTE:_ `margin` is not
-- included: it means that the full width would be `width + 2 * margin` (see Fig.1 below).
--
-- This block has 4 callbacks (see the `on` property in `Block:new`):
--
-- * `backspace` : to erase one character under the cursor
-- * `left`      : to move the cursor one character left
-- * `right`     : to move the cursor one character right
-- * `textinput` : to insert text (expects the `text` field in the passed event)
--
-- See `focus.lua` for the example.
--
-- @usage
-- local UI = ui.Layout {
--   ui.TextField {
--     width = 200,
--   },
--
--   ui.TextField {
--     width = 100,
--   },
-- }
--
-- function love.textinput(text)
--   UI:push {
--     id       = 'textinput',
--     text     = text,
--     filter   = function (this) return this.focus end
--   }
-- end
-- -- without filter above both text fields will be receiving text
function TextField:new ()
    self.maxLength  = self.maxLength or 100
    self.text       = self.text and self.text:sub(1, self.maxLength) or ''
    self.margin     = self.margin or 10
    self.width      = self.width or 100

    self.shift = 0
    self.cursor = {
        position = 0,
        x        = 0,
        y        = 0,
    }

    self.mouse = {
        onClick = function (this)
            this:setFocus()
        end
    }

    self.on = {
        ['backspace'] = function (this)
            backspace(this)
            return true
        end,

        ['left'] = function (this)
            left(this)
            return true
        end,

        ['right'] = function (this)
            right(this)
            return true
        end,

        ['textinput'] = function (this, event)
            textinput(this, event.text)
            return true
        end,
    }
end

function TextField:doSize ()
    return { x = self.width + 2 * self.margin, y = self.font:getHeight() }
end

--- Draws the cursor.
-- Override this function if you want to draw the cursor in a custom way. This function will
-- be called with 4 useful arguments (see below).
-- Default cursor is just a one pixel wide vertical line.
--
--    Fig. 1
--                                      sx
--                        │◀────────────────────────────▶│
--                        │                              │
--                       margin       cursorX       margin  ┌──── not visible
--                        │◀─▶│         │            │◀─▶│  │
--       not visible ─┐   │   │         │            │   │  │
--                    ▼   ┌───┬─────────▼────────────┬───┐  ▼  ─▲─   ◀──── cursorY
--                 TEXT HE│RE │TEXT HERE TEXT HERE TE│XT │HERE  │  sy
--                 │      └───┼─────────▲────────────┼───┘     ─▼─
--                 │          │                      │
--                 │◀────────▶│◀────────────────────▶│
--                    shift            width
-- @param cursorX An integer. The x coordinate of the cursor position.
-- @param cursorY An integer. The y coordinate of the cursor position.
-- @param sx An integer. The width of the text bar.
-- @param sy An integer. The height of the text bar.
--
function TextField:drawCursor (cursorX, cursorY, sx, sy)
    love.graphics.rectangle('line', cursorX, cursorY, 1, sy)
end

function TextField:doDraw ()
    local s = self:size()

    update(self)

    love.graphics.setScissor(self.x, self.y, s.x, s.y)

--     love.graphics.rectangle('line', self.x, self.y, s.x, s.y)
    love.graphics.print(self.text, self.x + self.shift + self.margin, self.y)

    if not self.focus then
        return
    end

    self:drawCursor(self.x + self.margin + self.cursor.x + self.shift,
                    self.y + self.cursor.y,
                    s.x, s.y)
end

return TextField
