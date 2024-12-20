local ui = require('ui')

local layout = ui.Layout {
    rows = 3,
    columns = 1,

    ui.Layout {
        rows    = 2,
        columns = 3,

        ui.Label {
            text   = 'Hello',
        },

        ui.Label {
            text   = 'Lua',
        },

        ui.Label {
            text   = 'Chat',
        },

        ui.Layout {
            rows    = 2,
            columns = 2,

            ui.Label {
                text       = 'Layout',
            },

            ui.Label {
                text       = 'inside',
            },

            ui.Label {
                text       = 'another',
            },

            ui.Layout {
                rows    = 2,
                columns = 2,

                ui.Image {
                    path   = 'images/lua-logo-64.png',
                },

                ui.Label {
                    text       = 'Layout',
                },

                ui.Label {
                    text       = 'inside',
                },

                ui.Label {
                    text       = 'another',
                },
            }
        },

        ui.Stack {
            ui.Image {
                path   = 'images/lua-logo-128.png',
            },

            ui.Layout {
                rows    = 3,
                columns = 3,

                ui.Label {
                    text   = 'l + t',
                    align  = 'left+top',
                    pad    = 5,
                },

                ui.Label {
                    text   = 't',
                    align  = 'top',
                    pad    = 5,
                },

                ui.Label {
                    text   = 't + r',
                    align  = 'top+right',
                    pad    = 5,
                },

                ui.Label {
                    text   = 'l',
                    align  = 'left',
                    pad    = 5,
                },

                ui.Label {
                    text   = 'c',
                    align  = 'center',
                    color  = { 1, 0, 0 },
                    pad    = 5,
                },

                ui.Label {
                    text   = 'r',
                    align  = 'right',
                    pad    = 5,
                },

                ui.Label {
                    text   = 'l + b',
                    align  = 'left+bottom',
                    pad    = 5,
                },

                ui.Label {
                    text   = 'b',
                    align  = 'bottom',
                    pad    = 5,
                },

                ui.Label {
                    text   = 'r + b',
                    align  = 'right+bottom',
                    pad    = 5,
                },
            }
        },

        ui.Stack {
            ui.Image {
                path   = 'images/love2d.png',
            },

            ui.Layout {
                rows    = 2,
                columns = 2,


                ui.Label {
                    text   = 'Stack:',
                },

                ui.Label {
                    text   = 'Image',
                },

                ui.Label {
                    text   = 'and',
                },

                ui.Label {
                    text   = 'Layout',
                }
            }
        },
    },

    ui.Layout {
        rows       = 1,
        columns    = 4,

        ui.Image {
            path      = 'images/lua-logo-64.png',
            fill      = { y = true },
            pad       = 5,
        },

        ui.Image {
            path   = 'images/lua-logo-64.png',
        },

        ui.Image {
            path   = 'images/lua-logo-64.png',
        },

        ui.Image {
            path      = 'images/lua-logo-64.png',
            fill      = { y = true },
            pad       = 5,
        },
    },

    ui.Layout {
        fill       = { x = true },
        rows       = 1,
        columns    = 4,

        ui.Image {
            path       = 'images/lua-logo-64.png',
            fill       = { },
            pad        = 5,
        },

        ui.Image {
            path       = 'images/lua-logo-64.png',
            fill       = { },
            pad        = 5,
        },

        ui.Image {
            path       = 'images/lua-logo-64.png',
            fill       = { },
            pad        = 5,
        },

        ui.Image {
            path       = 'images/lua-logo-64.png',
            fill       = { },
            pad        = 5,
        },
    }
}

for block in layout:traverse() do
    block.border = true
end

return layout
