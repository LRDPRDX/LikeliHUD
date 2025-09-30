--- Used to place text.
-- @classmod Label
local UI = (...):gsub('Label$', '')
local Block = require(UI .. 'Block')

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
function Label:new()
    self.text    = self.text    or ''
    self.maxText = self.maxText or self.text

    if #self.maxText < #self.text then
        self.maxText = self.text
    end
end

function Label:doSize()
    local font = love.graphics.getFont()
    return {
        x = font:getWidth(self.maxText),
        y = font:getHeight(self.maxText),
    }
end

function Label:doDraw()
    love.graphics.print(self.text, self.x, self.y)
end

return Label
