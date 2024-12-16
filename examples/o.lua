local ui = require('ui')

local buttons = ui.Layout {
    rows    = 2,
    columns = 1,

    ui.Image {
        path = 'images/love-button.png',
        quad = {
            layout = {
                rows    = 1,
                columns = 2,
            }
        },

        signals = { ['button.pressed'] = function (self) self.quad.current = 2 end,
                    ['button.released'] = function (self) self.quad.current = 1 end },
    },

    ui.Label {
        text = 'Press Space'
    }
}

return buttons
