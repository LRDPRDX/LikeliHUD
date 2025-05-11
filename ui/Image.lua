local UI    = (...):gsub('Image$', '')
local Block = require(UI .. 'Block')

local function loadDrawMap (path)
    local path, n = path:gsub('.png$', '.lua')
    if n ~= 1 then
        return nil
    end

    local f, e = love.filesystem.load(path)
    if e then
--         print(e)
        return nil
    end

    local map = f()
    if type(map) ~= 'table' then
        return nil
    end

    return map
end

local Image = setmetatable({}, Block)
Image.__index = Image

function Image:new(o)
    self = setmetatable(o, self)

    self.image        = love.graphics.newImage(self.path)
    self.drawMap      = loadDrawMap(self.path)

    self.quad         = self.quad or {}
    self.quad.layout  = self.quad.layout or { rows = 1, columns = 1 }
    self.quad.current = self.quad.current or 1
    self.quad.quads   = {}

    local quadW = math.floor(self.image:getWidth() / self.quad.layout.columns)
    local quadH = math.floor(self.image:getHeight() / self.quad.layout.rows)
    local yQuad = 0
    for r = 1, self.quad.layout.rows do
        local xQuad = 0
        for c = 1, self.quad.layout.columns do
            table.insert(self.quad.quads, love.graphics.newQuad(xQuad, yQuad, quadW, quadH, self.image))
            xQuad = xQuad + quadW
        end
        yQuad = yQuad + quadH
    end

    return self
end

function Image:doSize()
    local _, _, w, h = self.quad.quads[1]:getViewport()
    return { x = w, y = h }
end

function Image:doDraw()
    love.graphics.draw(self.image, self.quad.quads[self.quad.current], self.x, self.y)
end

return Image
