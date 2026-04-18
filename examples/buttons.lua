local ui = require('likelihud')

-- See the main.lua to see how the events emitted below are handled.

-- Use "factory" functions to create similar elements
local function MyButton (t)
    return
        ui.ImageButton {
            path = 'images/button.png',

            quad = {
                layout = {
                    rows    = 3,
                    columns = 1,
                }
            },

            onClick = function (self)
                self:emit { id = 'last.clicked', data = t.text }
            end,

            inside = {
                ui.Label {
                    text = t.text
                }
            }
        }
end

local buttons = ui.Layout {
    rows    = 3,
    columns = 1,

    ui.Block { },

    ui.Layout {
        rows    = 4,
        columns = 1,
        fill    = { x = true, y = false },
        spacing = 1,


        MyButton {
            text = 'Start'
        },

        MyButton {
            text = 'Settings'
        },

        MyButton {
            text = 'Quit'
        },

        ui.Layout {
            columns = 2,

            ui.Label {
                align = 'right',
                text  = 'Last clicked: ',
            },

            ui.Label {
                align = 'left',
                text  = 'Nothing',

                on = {
                    ['last.clicked'] = function (self, event)
                        self.text = event.message
                    end
                },
            }
        }
    },

    ui.Block { },
}

return buttons
