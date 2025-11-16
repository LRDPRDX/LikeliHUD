--- An image button.
--
-- Internally it is an `Image` with a predefined `mouse` field.
--
-- @classmod ImageButton
local UI    = (...):gsub('ImageButton$', '')
local Image = require(UI .. 'Image')

--- Represents an image button.
-- @type ImageButton
local ImageButton = Image:subclass('ImageButton')

--- Constructor.
--
-- It is `Image` under the hood so it has same fields as described in
-- `Image:new`.
--
-- * `quad` : ⚠️ The number of quads _must_ be equal to 3.
-- These quads are supposed to display different states of the button: the
-- current quad is set according to the state of the button as follows
-- (see also the `mouse` property in `Block:new`): 
--
--                     | onExit | onEnter | onPress | onClick |
--                     |--------|---------|---------|---------|
--        quad.current | 1      | 2       | 3       | 2       |
--
--
-- * `onClick` : a function. Called whenever the button is clicked.
--
-- * `mouse` : ⚠️ Don't override this property. If you want a button with
-- a custom mouse
-- better to create it from scratch as a user-defined block.
--
-- _NOTE_ : this is not a text button - use the `inside` (see `Block:new`)
-- property to place a `Label` inside a button.
--
-- @usage
--
-- local UI = ui.ImageButton {
--     path = '/path/to/button.png',
--
--     quad = {
--         layout = {
--             rows    = 3,
--             columns = 1,
--         },
--     },
--
--     -- Make the button display text
--     inside = {
--         ui.Label {
--             text = 'Ok'
--         }
--     }
-- }
function ImageButton:new()
    if #self.quad.quads ~= 3 then
        error(('Wrong number of quads: 3 expected, but got %d')
        :format(#self.quad.quads), 2)
    end

    self.mouse = {
        onExit  = function (self) self.quad.current = 1 end,
        onEnter = function (self) self.quad.current = 2 end,
        onPress = function (self) self.quad.current = 3 end,
        onClick = function (self)
            if self.onClick then
                self:onClick()
            end
            self.quad.current = 2
        end,
    }
end

return ImageButton
