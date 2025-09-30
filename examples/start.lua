local ui = require('ui')

local start = ui.Layout {
    rows = 3,

    ui.Block { },

    ui.Layout {
        rows = 2,

        fill = { x = true, y = false },

        ui.Label {
            text  = 'Press 1, 2, 3, ... to switch between examples'
        },

        ui.Label {
            text  = 'Press q to quit'
        }
    },

    ui.Block { },
}

return start
