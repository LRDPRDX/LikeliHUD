local ui = require('likelihud')

local UI = ui.Layout {
    rows    = 2,
    columns = 1,

    ui.Layout {
        rows    = 1,
        columns = 2,
        fill = { x = true, y = false },

        ui.Layout {
            rows    = 2,
            columns = 2,
            fill = { x = false, y = true },

            ui.Label {
                text = 'FPS: ',
                align = 'right',
            },

            ui.Label {
                text  = '?',
                align = 'left',
                color = { 1, 0, 0},

                on = {
                    ['stat'] = function (this, event)
                        this.text = tostring(event.fps)
                    end
                }
            },

            ui.Label {
                text = 'MEM: ',
                align = 'right',
            },

            ui.Label {
                text  = '?',
                align = 'left',
                color = { 1, 0, 0},

                on = {
                    ['stat'] = function (this, event)
                        this.text = tostring(event.mem)
                    end
                }
            },
        },

        ui.Block { }
    },

    ui.Block { }
}

return UI
