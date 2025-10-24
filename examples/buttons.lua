local ui = require('likelihud')
local Signal = require('hump.signal')

local buttons = ui.Layout {
    rows = 3,
    columns = 1,

    ui.Block { },

    ui.Layout {
        rows = 4,
        columns = 1,
        fill = { x = true, y = false },
        spacing = 1,

        ui.ImageButton {
            path = 'images/button.png',

            quad = {
                layout = {
                    rows = 3,
                    columns = 1,
                }
            },

            onClick = function ()
                Signal.emit('last.clicked', 'Start')
            end,

            on = {
                ui.Label {
                    text = 'Start'
                }
            }
        },

        ui.ImageButton {
            path = 'images/button.png',

            quad = {
                layout = {
                    rows = 3,
                    columns = 1,
                }
            },

            onClick = function ()
                Signal.emit('last.clicked', 'Load')
            end,

            on = {
                ui.Label {
                    text = 'Load'
                }
            }
        },

        ui.ImageButton {
            path = 'images/button.png',

            quad = {
                layout = {
                    rows = 3,
                    columns = 1,
                }
            },

            onClick = function ()
                Signal.emit('last.clicked', 'Quit')
            end,

            on = {
                ui.Label {
                    text = 'Quit'
                }
            }
        },

        ui.Layout {
            columns = 2,

            ui.Label {
                align = 'right',
                text = 'Last clicked: ',
            },

            ui.Label {
                align = 'left',
                text = 'Nothing',
                signals = {
                    ['last.clicked'] = function (self, message)
                        self.text = message
                    end
                },
            }
        }
    },

    ui.Block { },
}

return buttons
