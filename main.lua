local Signal = require('hump.signal')


local font = love.graphics.newFont('fonts/moder-dos-437.ttf', 20)
love.graphics.setFont(font)

local screen = {
    w       = 1200,
    h       = 800,
    margin  = 10,
}

local ui = require('likelihud')

local layoutUI  = require('examples.layout')
local simpleUI  = require('examples.simple')
local oeUI      = require('examples.o')
local squaresUI = require('examples.squares')
local fillUI    = require('examples.fill')
local startUI   = require('examples.start')
local buttonsUI = require('examples.buttons')
local eventsUI  = require('examples.events')
local HUD       = nil

local function updateHUD(newHUD)
    local w, h = love.window.getMode()
    HUD = newHUD
    HUD:place(screen.margin, screen.margin, w - 2 * screen.margin, h - 2 * screen.margin)
end

local oeSound = love.audio.newSource( 'sounds/oe.mp3', 'stream' )
local n = 1

Signal.register('button.pressed',
    function(...) if oeSound:isPlaying() then
        oeSound:stop() end oeSound:play()
        HUD:push({ id = 'button.pressed' })
    end
)

Signal.register('last.clicked',
    function (text)
        HUD:push({ id = 'last.clicked', message = text })
    end
)


local keys = {
    pressed = {
        ['space'] = function() Signal.emit('button.pressed') end,

        ['n'] = function()
            n = n + 1
            HUD:push { id = 'number.changed', number = n }
        end,

        ['1'] = function() updateHUD(layoutUI) end,
        ['2'] = function() updateHUD(simpleUI) end,
        ['3'] = function() updateHUD(oeUI) end,
        ['4'] = function() updateHUD(squaresUI) end,
        ['5'] = function() updateHUD(fillUI) end,
        ['6'] = function() updateHUD(buttonsUI) end,
        ['7'] = function() updateHUD(eventsUI) end,

        ['q'] = function() love.event.quit() end,
    },
    released = {
        ['space'] = function() HUD:push({ id = 'button.released' }) end,
    }
}

function love.load()
    love.window.setMode(screen.w, screen.h, { resizable = true })
    updateHUD(startUI)
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

function love.mousemoved(x, y, dx, dy, istouch)
    HUD:mousemoved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch, presses)
    HUD:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    HUD:mousereleased(x, y, button, istouch, presses)
end

function love.draw()
    HUD:draw()
end
