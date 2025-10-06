local ui = require('likelihud')

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
                    text   = '|left + top|',
                    align  = 'left+top',
                    pad    = 10,
                },

                ui.Label {
                    text   = '|top|',
                    align  = 'top',
                    pad    = 10,
                },

                ui.Label {
                    text   = '|top + right|',
                    align  = 'top+right',
                    pad    = 10,
                },

                ui.Label {
                    text   = '|left|',
                    align  = 'left',
                    pad    = 10,
                },

                ui.Label {
                    text   = '|center|',
                    align  = 'center',
                    color  = { 1, 0, 0 },
                    pad    = 10,
                },

                ui.Label {
                    text   = '|right|',
                    align  = 'right',
                    pad    = 10,
                },

                ui.Label {
                    text   = '|left + bottom|',
                    align  = 'left+bottom',
                    pad    = 10,
                },

                ui.Label {
                    text   = '|bottom|',
                    align  = 'bottom',
                    pad    = 10,
                },

                ui.Label {
                    text   = '|right + bottom|',
                    align  = 'right+bottom',
                    pad    = 10,
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
            path   = 'images/offset.png',

            on = {
                ui.Label {
                    text = '1',
                    offset = {
                        y      = 10,
                        height = 24,
                        width  = 160,
                        x      = 20,
                    },
                },

                ui.Label {
                    text = '2',
                    offset = {
                        y      = 56,
                        height = 36,
                        width  = 36,
                        x      = 20,
                    },
                },

                ui.Label {
                    text = '3',
                    offset = {
                        y      = 94,
                        height = 26,
                        width  = 84,
                        x      = 94,
                    },
                },

                ui.Label {
                    text = '4',
                    offset = {
                        y      = 150,
                        height = 40,
                        width  = 102,
                        x      = 40,
                    }
                }
            }
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
