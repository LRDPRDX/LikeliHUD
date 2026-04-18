local ui = require('likelihud')

-- Use "factory" functions to create similar elements
local function MyTextField (_)
    return
        ui.ImageButton {
            path = 'images/textfield.png',
            align = 'left',

            quad = {
                layout = {
                    rows    = 3,
                    columns = 1
                }
            },

            inside = {
                ui.TextField {
                    width = 270
                }
            },

            onClick = function (this)
                this.inside[1]:setFocus()
            end
        }
end

local layout = ui.Layout {
    rows    = 3,
    columns = 1,

    ui.Block {},

    ui.Layout {
        rows    = 4,
        columns = 2,
        fill    = { x = true, y = false },

        ui.Label {
            text = 'Name :',
            align = 'right',
        },

        MyTextField { },

        ui.Label {
            text = 'Age :',
            align = 'right',
        },

        MyTextField { },

        ui.Label {
            text = 'Clan :',
            align = 'right',
        },

        MyTextField { },

        ui.Label {
            text = 'Class :',
            align = 'right',
        },

        MyTextField { },
    },

    ui.Label {
        text = 'Mouse click to focus then type, <Esc> to remove focus'
    }
}

return layout
