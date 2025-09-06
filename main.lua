local Signal = require('libraries.hump.signal')

local font = love.graphics.newFont('fonts/moder-dos-437.ttf', 20)
love.graphics.setFont(font)

local screen = {
    w       = 1200,
    h       = 800,
    margin  = 10,
}

local ui = require('ui')

local layoutUI  = require('examples.layout')
local simpleUI  = require('examples.simple')
local oeUI      = require('examples.o')
local HUD       = nil

local function updateHUD(newHUD)
    w, h = love.window.getMode()
    HUD = newHUD
    HUD:place(screen.margin, screen.margin, w - 2 * screen.margin, h - 2 * screen.margin)
end

local oeSound = love.audio.newSource( 'sounds/oe.mp3', 'stream' )
Signal.register('button.pressed', function(...) if oeSound:isPlaying() then oeSound:stop() end oeSound:play() end)

local keys = {
    pressed = {
        ['space'] = function() Signal.emit('button.pressed') end,
        ['1'] = function() updateHUD(layoutUI) end,
        ['2'] = function() updateHUD(simpleUI) end,
        ['3'] = function() updateHUD(oeUI) end,
        ['q'] = function() love.event.quit() end,
    },
    released = {
        ['space'] = function() Signal.emit('button.released') end,
    }
}

function love.load()
    love.window.setMode(screen.w, screen.h, { resizable = true })
    updateHUD(layoutUI)
end

function love.resize(w, h)
    HUD:place(screen.margin, screen.margin, w - 2 * screen.margin, h - 2 * screen.margin)
end

function love.keypressed(key)
    if keys.pressed[key] then keys.pressed[key]() end
end

function love.keyreleased(key)
    if keys.released[key] then keys.released[key]() end
end

function love.draw()
    HUD:draw()
end
