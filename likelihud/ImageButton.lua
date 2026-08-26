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
-- * `onPress` : a function. Called whenever the button is pressed. The button object itself
-- is passed to that function on call.
--
-- * `onClick` : a function. Called whenever the button is clicked. The button object itself
-- is passed to that function on call.
--
-- * `onEnter` : a function. Called whenever the cursor is enters the button. The button object itself
-- is passed to that function on call.
--
-- * `onExit` : a function. Called whenever the cursor is exits the button. The button object itself
-- is passed to that function on call.
--
-- * `mouse` : ⚠️ Don't override this property. If you want a button with
-- a custom mouse
-- better to create it from scratch as a user-defined block.
--
-- * `tooltip` : A table. A tooltip object. It works in the following way:
--    * on the button's creation it adds the `block` field to the tooltip object
--      (so `tooltip.block` refers to the button itself)
--    * every time the cursor enters the button two things happen:
--        * the tooltips `status` field is set to `true` and
--        * the following event is emitted: `{ id = 'likelihud.tooltip', tooltip = tooltip }`
--
--    * every time the cursor leaves the button
--        * the tooltips `status` field is set to `false` and
--        * the following event is emitted: `{ id = 'likelihud.tooltip', tooltip = tooltip }`
--
--    so it emits the signal with the tooltip object itself as the data. Then you can catch those
--    signals and draw the tooltip. _NOTE_ : you might have thought why not drawing tooltips
--    automatically. The reason is that drawing is sequential: the button is drawn once per frame,
--    this means that if we had drawn the button's tooltip after the button itself everything which
--    is drawn _after_ the button would have drawn _over_ the tooltip. In other words, this library
--    doesn't support delayed drawing out of the box.
--
-- _NOTE_ : this is not a text button - use the `inside` (see `Block:new`)
-- property to place a `Label` inside a button.
--
-- See the `buttons.lua` file for an example.
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
--     tooltip = {
--       text = 'This is a tooltip'
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

    if self.tooltip then
        self.tooltip.block = self
    end

    self.mouse = {
        onExit  = function (this)
            this.quad.current = 1

            if self.tooltip then
                self.tooltip.status = false
                self:emit { id = 'likelihud.tooltip', tooltip = self.tooltip }
            end

            if this.onExit then
                this:onExit()
            end
        end,

        onEnter = function (this)
            this.quad.current = 2
            if self.tooltip then
                self.tooltip.status = true
                self:emit { id = 'likelihud.tooltip', tooltip = self.tooltip }
            end

            if this.onEnter then
                this:onEnter()
            end
        end,

        onPress = function (this)
            this.quad.current = 3
            if this.onPress then
                this:onPress()
            end
        end,

        onClick = function (this)
            this.quad.current = 2
            if this.onClick then
                this:onClick()
            end
        end,
    }
end

return ImageButton
