--- Used to place text.
-- @classmod Label
local UI = (...):gsub('Label$', '')
local Block = require(UI .. 'Block')

local utils = require(UI .. 'utils')

--- Represents a label.
-- @type Label
local Label = Block:subclass('Label')

--- Constructor.
--
-- * `text` : a string. The text to be displayed.
-- * `maxText` : a string. The text of maximum possible length displayed by this label.
-- Let us explain: as you know the size of a block is calculated once per a call to `Block:place`,
-- however, it is highly likely you want to change the text "on-the-fly", f.e., when displaying
-- HP or XP of a character, current FPS, or the number of items left in a slot. You don't want to
-- re-place the HUD every time you need to change the text. More over, you don't want the HUD to
-- vary in size if text is changed.
-- That is where the `maxText` parameter comes to play: it reserves the necessary area on the
-- screen to fit any text there.
-- So suppose you have a label in your HUD that displays XP. You know that the maximum possible
-- XP is limited to `10000`, but at the moment you want to display `0`, so you do:
--
--        local label = ui.Label {
--          text    = '0',
--          maxText = '10000'
--        }
-- _NOTE_: I encourage you to use a monospace font, otherwise `maxText` might not guarantee it
-- occupies the maximum area. For example, for some fonts the string `11111` may be shorter
-- than `9999`.
-- * `color` : a color like in [love2d](https://www.love2d.org/wiki/love.graphics.setColor)
-- (the table variant). The color of the text.
-- * `elide` : a boolean meaning whether the text is cut when the label doesn't fit its enclosing
-- cell. `false` by default. _NOTE_: if you want to change `text` dinamically don't just assign
-- `text` to a new value: it won't elide. Instead use the `Label:setText` member-function.
--
--        ■────────────╮
--        │ A veeeery long label  -- elide = false
--        ╰────────────╯
--
--        ■────────────╮
--        │ A veeeer...│          -- elide = true
--        ╰────────────╯
-- See `elide.lua` for the example.
function Label:new()
    self.text         = self.text    or ''
    self._totalText   = self.text
    self.maxText      = self.maxText or self.text
    self.elide        = self.elide   or false

    if #self.maxText < #self.text then -- TODO: use width instead of length
        self.maxText = self.text
    end
end

function Label:doSize()
    return {
        x = self.font:getWidth(self.maxText),
        y = self.font:getHeight(),
    }
end

--- Changes the label's text.
-- _NOTE_: it doesn't just assign a new value to the `text` property. It re-places the block
-- in its enclosing cell also. This function is supposed to be used together with the `elide`
-- property. So use only if `elide` is `true` and you want to modify the label's text while still
-- be elided. If it's not the case just change `text`: `self.text = 'new_text_here'`.
--
-- See `elide.lua` for the example.
-- @param text a string. New label's text.
function Label:setText(text)
    self._totalText = text

    local c = self:cell()
    self:place(c.x, c.y, c.w, c.h)
end

function Label:doPlace (x, y, w, h)
    local s = self:size()

    if self.elide then
        self.text = utils.elide(self._totalText, w, self.font)
    end
    s.x = self.font:getWidth(self.text)

    utils.placeAt(self, x, y, w, h, s)
end

function Label:doDraw()
    love.graphics.print(self.text, self.x, self.y)
end

return Label
