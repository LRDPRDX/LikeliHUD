local ui = require('ui')

local fill = ui.Layout {
    rows    = 2,
    columns = 2,

    ui.Label {
        text = 'fill.x = true, fill.y = true',
    },

    ui.Layout {
        rows = 3,

        ui.Block { },

        ui.Layout {
            rows = 3,

            fill = { x = true, y = false },

            ui.Label {
                text = 'one',
            },

            ui.Label {
                text = 'one',
            },

            ui.Label {
                text = 'three',
            },
        },

        ui.Block { },
    },

    ui.Label {
        text = 'fill.x = true, fill.y = false',
        fill = { x = true, y = false },
    },

    ui.Layout {
        rows    = 2,
        columns = 2,

        fill = { x = false, y = false },

        ui.Label {
            text = 'fill.x = false, fill.y = true',
            fill = { x = false, y = false },
        },

        ui.Label {
            text = 'fill.x = true, fill.y = true',
        },

        ui.Label {
            text = 'fill.x = false, fill.y = true',
            fill = { x = false, y = false },
        },

        ui.Label {
            text = 'fill.x = true, fill.y = true',
        },
    }
}

for block in fill:traverse() do
    block.border = true
end

return fill
