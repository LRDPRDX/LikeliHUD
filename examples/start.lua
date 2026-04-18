local ui = require('likelihud')

local start = ui.Layout {
    rows = 3,

    ui.Block { },

    ui.Layout {
        rows = 2,

        fill = { x = true, y = false },

        ui.Label {
            text  = 'Press 1, 2, 3, 4, 5, 6, 7, 8 to switch between the examples'
        },

        ui.Label {
            text  = 'Press q to quit'
        }
    },

    ui.Block { },
}

return start
