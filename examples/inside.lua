local ui = require('likelihud')

local offsets = {
    a = {
        y      = 10,
        x      = 20,
        height = 24,
        width  = 160,
    },

    b = {
        y      = 56,
        x      = 20,
        height = 36,
        width  = 36,
    },

    c = {
        y      = 94,
        x      = 94,
        height = 26,
        width  = 84,
    },

    d = {
        y      = 150,
        x      = 40,
        height = 40,
        width  = 102,
    }
}

local UI = ui.Layout {
    rows    = 3,
    columns = 1,

    ui.Label {
        fill = { x = true, y = false },
        text = 'This is an Image with Labels put inside.'
    },

    ui.Label {
        fill = { x = true, y = false },
        text = 'Wherever you place this image, the labels will be correctly placed also',
    },

    ui.Image {
        path = 'images/offset.png',

        inside = {
            -- as a list
            ui.Label {
                text   = 'a',
                offset = offsets['a']
            },

            ui.Label {
                text   = 'b',
                offset = offsets['b']
            },

            -- or a map
            at = {
                ['third'] = ui.Label {
                    text   = 'c',
                    offset = offsets['c']
                },

                ['fourth'] = ui.Label {
                    text   = 'd',
                    offset = offsets['d']
                }
            }
        }
    }
}

return UI
