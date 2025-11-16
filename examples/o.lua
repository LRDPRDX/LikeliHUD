local ui = require('likelihud')

local buttons = ui.Layout {
    rows    = 2,
    columns = 1,

    ui.ImageButton {
        path = 'images/love-button.png',
        quad = {
            layout = {
                rows    = 1,
                columns = 3,
            }
        },

        onClick = function () print('Clicked...') end,

        on = {
            ['button.pressed'] = function (self)
                self.quad.current = 3
            end,
            ['button.released'] = function (self)
                self.quad.current = 1
            end
        },
    },

    ui.Label {
        text = 'Press Space or click the button with the mouse'
    }
}

return buttons
