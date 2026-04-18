local font = love.graphics.newFont('fonts/moder-dos-437.ttf', 20)
love.graphics.setFont(font)

local screen = {
    w       = 800,
    h       = 600,
    margin  = 10,
}

-- Statistics: FPS, memory
local statUI = require('statUI')

local ui = require('likelihud')

local layoutUI     = require('examples.layout')
local simpleUI     = require('examples.simple')
local oeUI         = require('examples.o')
local squaresUI    = require('examples.squares')
local fillUI       = require('examples.fill')
local startUI      = require('examples.start')
local buttonsUI    = require('examples.buttons')
local eventsUI     = require('examples.events')
local focusUI      = require('examples.focus')
local HUD          = nil

local queue = {}

local function updateHUD(newHUD)
    local w, h = love.window.getMode()
    if HUD then
        HUD:registerQ()
    end
    HUD = newHUD
    HUD:place(screen.margin, screen.margin, w - 2 * screen.margin, h - 2 * screen.margin)
    HUD:registerQ(queue)
end

local oeSound = love.audio.newSource( 'sounds/oe.mp3', 'stream' )
local n = 1


local keys = {
    pressed = {
        text = {
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
            ['8'] = function() updateHUD(focusUI) end,

            ['q'] = function() love.event.quit() end,
        },

        ['space'] = function()
            if oeSound:isPlaying() then
                oeSound:stop()
            end
            oeSound:play()
            HUD:push({ id = 'button.pressed' })
        end,

        ['escape'] = function () HUD:unsetFocus() end,
        ['backspace'] = function ()
            HUD:push {
                id     = 'backspace',
                filter = function (this) return this.focus end
            }
        end,
        ['left'] = function ()
            HUD:push {
                id     = 'left',
                filter = function (this) return this.focus end
            }
        end,
        ['right'] = function ()
            HUD:push {
                id     = 'right',
                filter = function (this) return this.focus end
            }
        end,
    },
    released = {
        ['space'] = function() HUD:push({ id = 'button.released' }) end,
    }
}

function love.load()
    love.window.setMode(screen.w, screen.h, { resizable = true })
    updateHUD(startUI)
end

function love.update(_)
    for _, event in ipairs(queue) do
        if event.id == 'last.clicked' then
            HUD:push { id = 'last.clicked', message = event.data }
        end
    end
    ui.utils.clearArray(queue)

    local fps = love.timer.getFPS()
    local mem = math.floor(collectgarbage('count'))

    statUI:push { id = 'stat', fps = fps, mem = mem }
end

function love.resize(w, h)
    HUD:place(screen.margin, screen.margin, w - 2 * screen.margin, h - 2 * screen.margin)
    statUI:place(screen.margin, screen.margin, w - 2 * screen.margin, h - 2 * screen.margin)
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

function love.textinput (text)
    local event = { id     = 'textinput',
                    text   = text,
                    filter = function (this) return this.focus end }
    HUD:push(event)
    if not event.swallowed then
        if keys.pressed.text[text] then keys.pressed.text[text]() end
    end
end

function love.draw()
    HUD:draw()
    statUI:draw()
end
