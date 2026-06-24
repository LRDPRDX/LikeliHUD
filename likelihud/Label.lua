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
-- cell. `false` by default. _NOTE_: it only takes effect (for now at least) _on placement_: i.e.
-- when its `Block:place` is called. If you change `text` afterwards the new text will be put as
-- is, without elision. Useful for static `Label`s.
--        ■────────────╮
--        │ A veeeery long label  -- elide = false
--        ╰────────────╯
--
--        ■────────────╮
--        │ A veeeer...│          -- elide = true
--        ╰────────────╯
function Label:new()
    self.text    = self.text    or ''
    self.maxText = self.maxText or self.text
    self.elide   = self.elide   or false

    if #self.maxText < #self.text then
        self.maxText = self.text
    end
end

function Label:doSize()
    local font = love.graphics.getFont()
    return {
        x = font:getWidth(self.maxText),
        y = font:getHeight(),
    }
end

function Label:doPlace (x, y, w, h)
    local s = self:size()

    local font = love.graphics.getFont()
    if self.elide and (font:getWidth(self.text)) > w then
        local ellipsis = '...'
        self.text = utils.textAtWidth(self.text,
                                      math.max(w - font:getWidth(ellipsis), 0),
                                      font) .. ellipsis
    end
    s.x = font:getWidth(self.text)

    utils.placeAt(self, x, y, w, h, s)
end

function Label:doDraw()
    love.graphics.print(self.text, self.x, self.y)
end

return Label
