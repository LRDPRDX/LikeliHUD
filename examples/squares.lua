local ui = require('ui')

local squares = ui.Rectangle {
    w = 300,
    h = 300,

    color = { 1, 0, 0 },

    on = {
        ui.Rectangle {
            w = 50,
            h = 50,

            color = { 0, 1, 0 },

            offset = {
                x = 10,
                y = 10,
                width = 100,
                height = 100,
            }
        },

        ui.Rectangle {
            w = 100,
            h = 100,

            color = { 0, 0, 1 },

            offset = {
                x = 30,
                y = 30,
                width = 200,
                height = 200,
            },

            on = {
                ui.Rectangle {
                    w = 130,
                    h = 130,

                    color = { 0, 1, 1 },

                    offset = {
                        x = 20,
                        y = 20,
                        width = 150,
                        height = 150,
                    },

                    on = {
                        ui.Rectangle {
                            w = 50,
                            h = 50,

                            color = { 1, 1, 0 },
                        }
                    }
                }
            }
        },
    }
}

return squares
