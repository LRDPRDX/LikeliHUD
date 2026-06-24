local ui = require('likelihud')

local ElideLabel = function (t)
    return ui.Label {
        text   = t.text,
        elide  = true,
        border = true,
    }
end

local elide = ui.Layout {
    rows    = 2,
    columns = 1,

    ui.Label {
        text = 'Resize the window to see how elided labels work',
        fill = { x = true, y = false },
    },

    ui.Layout {
        rows    = 3,
        columns = 3,

        ElideLabel {
            text  = 'In a hole in the ground',
        },

        ElideLabel {
            text = 'there lived a hobbit.',
        },

        ElideLabel {
            text = 'Not a nasty, dirty, wet hole,',
        },

        ElideLabel {
            text = 'filled with the end of worms',
        },

        ElideLabel {
            text = 'and an oozy smell, nor yet a dry,',
        },

        ElideLabel {
            text = 'bare, sandy hole',
        },

        ElideLabel {
            text = 'with nothing to sit down on or eat:',
        },

        ElideLabel {
            text = 'it was a hobbit-hole',
        },

        ElideLabel {
            text = 'and that meant comfort.',
        },
    }
}

return elide
