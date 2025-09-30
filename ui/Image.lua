--- Used to place an image.
--
-- @classmod Image
local UI    = (...):gsub('Image$', '')
local Block = require(UI .. 'Block')

--- Represents an image.
-- @type Image
local Image = Block:subclass('Image')

--- Constructor.
--
-- * `path` : a string.
-- Path to the image (`filename` in [love2d](https://www.love2d.org/wiki/love.graphics.newImage)).
-- * `quad` : a table. It contains information about quads in the image. It has two fields: 
--     * `layout` : a table of the form `{ rows = n, columns = m }`, where `n` and `m` are positive
--     integers.
--     * `current` : a positive integer. The current quad index. The quad index goes from left to
--     right, top to bottom.
--
-- Default `quad` is
--
--    self.quad = {
--      layout = {
--        rows    = 1,
--        columns = 1,
--      },
--      current = 1,
--    }
-- i.e. if not specified it is assumed there is only one quad in the image - the image itself.
-- _NOTE:_ the quads must
--
-- * be of the same size.
-- * not have spacing in between.
-- * be placed in a grid `quad.layout.rows` by `quad.layout.columns` inside the image.
--
-- Provided you have an image at `path/to/my/awesome/image.png` that looks like this:
--
--    ┌────────┬────────┐
--    │  ▚▞    │    ▞▚  │
--    │        │        │
--    │        │        │
--    ├────────┼────────┤
--    │ ▞      │   ▞    │
--    │ ▚      │     ▞  │
--    │        │        │
--    └────────┴────────┘
-- the code
--
--    local image = ui.Image {
--      path = 'path/to/my/awesome/image.png',
--      quad = {
--        layout = {
--          rows    = 2,
--          columns = 2,
--        },
--        current = 3,
--      }
--    }
--
--    image:place(0, 0, 100, 100)
--    image:draw()
-- will draw:
--    ┌────────┐
--    │ ▞      │
--    │ ▚      │
--    │        │
--    └────────┘
function Image:new()
    self.image        = love.graphics.newImage(self.path)

    self.quad         = self.quad           or {}
    self.quad.layout  = self.quad.layout    or { rows = 1, columns = 1 }
    self.quad.current = self.quad.current   or 1
    self.quad.quads   = {}

    local quadW = math.floor(self.image:getWidth()  / self.quad.layout.columns)
    local quadH = math.floor(self.image:getHeight() / self.quad.layout.rows)
    local yQuad = 0
    for r = 1, self.quad.layout.rows do
        local xQuad = 0
        for c = 1, self.quad.layout.columns do
            table.insert(self.quad.quads,
                         love.graphics.newQuad(xQuad, yQuad, quadW, quadH, self.image))
            xQuad = xQuad + quadW
        end
        yQuad = yQuad + quadH
    end
end

function Image:doSize()
    -- Quads must be of the same size
    local _, _, w, h = self.quad.quads[1]:getViewport()
    return { x = w, y = h }
end

function Image:doDraw()
    love.graphics.draw(self.image, self.quad.quads[self.quad.current], self.x, self.y)
end

return Image
