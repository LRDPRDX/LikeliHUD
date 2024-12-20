local Signal = require('libraries.hump.signal')

local font = love.graphics.newFont('fonts/moder-dos-437.ttf', 30)
love.graphics.setFont(font)

local ui = require('ui')

local HUD = require('examples.layout')
-- local HUD = require('examples.simple')
-- local HUD = require('examples.o')

local o = love.audio.newSource( 'sounds/oe.mp3', 'stream' )
Signal.register('button.pressed', function(...) if o:isPlaying() then o:stop() end o:play() end)

function love.load()
    local w, h = 1200, 800
    love.window.setMode(w, h, { resizable = true })

    HUD:place(10, 10, w - 20, h - 20)
end

function love.resize(w, h)
    local margin = 10
    HUD:place(margin, margin, w - 2 * margin, h - 2 * margin)
end

function love.keypressed(key)
    if key == 'space' then
        Signal.emit('button.pressed')
    end
end

function love.keyreleased(key)
    if key == 'space' then
        Signal.emit('button.released')
    end
end

function love.draw()
    HUD:draw()
end
