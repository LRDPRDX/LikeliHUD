local ui = require('likelihud')

local events = ui.Layout {
    columns = 1,
    rows    = 2,

    ui.Layout {
        columns = 3,
        rows    = 1,

        ui.Rectangle {
            w     = 200,
            h     = 200,
            color = { 0.5, 0.5, 0.5 },

            filter = function (self, event)
                if event.id ~= 'number.changed' then
                    return false
                end

                if event.number % 2 == 0 then
                    return false
                end

                return true
            end,

            inside = {
                ui.Label {
                    text    = '1',
                    maxText = '100',
                    color   = { 1, 1, 1 },

                    on = {
                        ['number.changed'] = function (self, event)
                            self.text = tostring(event.number)
                        end
                    }
                }
            }
        },

        ui.Rectangle {
            w     = 200,
            h     = 200,
            color = { 0.5, 0.5, 0.5 },

            filter = function (self, event)
                if event.id ~= 'number.changed' then
                    return false
                end

                if event.number % 3 == 0 then
                    return false
                end

                return true
            end,

            inside = {
                ui.Label {
                    text    = '2',
                    maxText = '100',
                    color   = { 1, 1, 1 },

                    on = {
                        ['number.changed'] = function (self, event)
                            self.text = tostring(event.number)
                        end
                    }
                }
            }
        },

        ui.Rectangle {
            w     = 200,
            h     = 200,
            color = { 0.5, 0.5, 0.5 },

            inside = {
                ui.Label {
                    text    = '3',
                    maxText = '100',
                    color   = { 1, 1, 1 },

                    on = {
                        ['number.changed'] = function (self, event)
                            self.text = tostring(event.number)
                        end
                    }
                }
            }
        },
    },

    ui.Label {
        text = [[Press 'n' and see how the numbers in the squares are
changing: every press increments the number; the first square accepts only
odd numbers, second - only those not divisible by 3, and the third accepts
all.]]
    }
}

return events
