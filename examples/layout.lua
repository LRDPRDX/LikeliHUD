local ui = require('ui')

local layout = ui.Layout {
    rows = 3,
    columns = 1,

    ui.Layout {
        rows    = 2,
        columns = 3,
        border  = true,

        ui.Label {
            text   = 'Hello',
            border = true,
        },

        ui.Label {
            text   = 'Lua',
            border = true,
        },

        ui.Label {
            text   = 'Chat',
            border = true,
        },

        ui.Layout {
            rows    = 2,
            columns = 2,

            border  = true,

            ui.Label {
                text       = 'Layout',
                border     = true,
            },

            ui.Label {
                text       = 'inside',
                border     = true,
            },

            ui.Label {
                text       = 'another',
                border     = true,
            },

            ui.Layout {
                rows    = 2,
                columns = 2,

                border  = true,

                ui.Image {
                    path   = 'images/lua-logo-64.png',
                    border = true,
                },

                ui.Label {
                    text       = 'Layout',
                    border     = true,
                },

                ui.Label {
                    text       = 'inside',
                    border     = true,
                },

                ui.Label {
                    text       = 'another',
                    border     = true,
                },
            }
        },

        ui.Stack {
            ui.Image {
                path   = 'images/lua-logo-128.png',
                border = true,
            },

            ui.Layout {
                rows    = 3,
                columns = 3,
                border  = true,

                ui.Label {
                    text   = 'l + t',
                    align  = 'left+top',
                    border = true,
                    pad    = 5,
                },

                ui.Label {
                    text   = 't',
                    align  = 'top',
                    border = true,
                    pad    = 5,
                },

                ui.Label {
                    text   = 't + r',
                    align  = 'top+right',
                    border = true,
                    pad    = 5,
                },

                ui.Label {
                    text   = 'l',
                    align  = 'left',
                    border = true,
                    pad    = 5,
                },

                ui.Label {
                    text   = 'c',
                    align  = 'center',
                    border = true,
                    color  = { 1, 0, 0 },
                    pad    = 5,
                },

                ui.Label {
                    text   = 'r',
                    align  = 'right',
                    border = true,
                    pad    = 5,
                },

                ui.Label {
                    text   = 'l + b',
                    align  = 'left+bottom',
                    border = true,
                    pad    = 5,
                },

                ui.Label {
                    text   = 'b',
                    align  = 'bottom',
                    border = true,
                    pad    = 5,
                },

                ui.Label {
                    text   = 'r + b',
                    align  = 'right+bottom',
                    border = true,
                    pad    = 5,
                },
            }
        },

        ui.Stack {
            ui.Image {
                path   = 'images/love2d.png',
                border = true,
            },

            ui.Layout {
                rows    = 2,
                columns = 2,

                border  = true,

                ui.Label {
                    text   = 'Stack:',
                    border = true,
                },

                ui.Label {
                    text   = 'Image',
                    border = true,
                },

                ui.Label {
                    text   = 'and',
                    border = true,
                },

                ui.Label {
                    text   = 'Layout',
                    border = true,
                }
            }
        },
    },

    ui.Layout {
        rows       = 1,
        columns    = 4,
        border     = true,

        ui.Image {
            path      = 'images/lua-logo-64.png',
            border    = true,
            fillWidth = false,
            pad       = 5,
        },

        ui.Image {
            path   = 'images/lua-logo-64.png',
            border = true,
        },

        ui.Image {
            path   = 'images/lua-logo-64.png',
            border = true,
        },

        ui.Image {
            path      = 'images/lua-logo-64.png',
            border    = true,
            fillWidth = false,
            pad       = 5,
        },
    },

    ui.Layout {
        fillHeight = false,
        rows       = 1,
        columns    = 4,
        border     = true,

        ui.Image {
            path       = 'images/lua-logo-64.png',
            border     = true,
            fillWidth  = false,
            fillHeight = false,
            pad        = 5,
        },

        ui.Image {
            path       = 'images/lua-logo-64.png',
            border     = true,
            fillWidth  = false,
            fillHeight = false,
            pad        = 5,
        },

        ui.Image {
            path       = 'images/lua-logo-64.png',
            border     = true,
            fillWidth  = false,
            fillHeight = false,
            pad        = 5,
        },

        ui.Image {
            path       = 'images/lua-logo-64.png',
            border     = true,
            fillWidth  = false,
            fillHeight = false,
            pad        = 5,
        },
    }
}

return layout
