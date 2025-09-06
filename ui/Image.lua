local UI    = (...):gsub('Image$', '')
local Block = require(UI .. 'Block')

-- *******************
-- ****** IMAGE ******
-- *******************
local Image = Block:subclass('Image')

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
