local ui = require('ui')

local simple = ui.Layout {
    rows    = 2,
    columns = 2,

    ui.Label { text = 'Hello', },

    ui.Label { text = 'I', },

    ui.Label { text = 'am', },

    ui.Layout {
        rows    = 2,
        columns = 2,

        ui.Label { text = 'Li', },

        ui.Label { text = 'ke', },

        ui.Label { text = 'li', },

        ui.Label { text = 'HUD', },
    }
}

for block in simple:traverse() do
    block.border = true
end

return simple
