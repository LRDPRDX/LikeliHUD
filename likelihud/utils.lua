--- Different utility functions 
--
-- @module Utils
local utils = {}

--- Round function.
-- @param x A number.
-- @return `math.floor(x + 0.5)`
function utils.round (x)
    return math.floor(x + 0.5)
end

--- Tells whether or not a given point lies inside an axis-aligned rectangle.
-- @param x0 The point's x-coordinate. 
-- @param y0 The point's y-coordinate.
-- @param x x-coordinate of the top-left corner of the rectangle.
-- @param y y-coordinate of the top-left corner of the rectangle.
-- @param w Width of the rectangle.
-- @param h Height of the rectangle.
-- @return Whether the point `(x0, y0)`
-- lies inside the rectangle `(x, y, w, h)`.
function utils.inside (x0, y0, x, y, w, h)
    return x0 >= x and x0 <= (x + w) and
           y0 >= y and y0 <= (y + h)
end

--- Clears the array part of the table.
-- @param t A table.
function utils.clearArray (t)
    local length = #t
    for i = 1, length do
        t[i] = nil
    end
end

--- Clears the table.
-- @param t A table.
function utils.clear (t)
    for k, _ in pairs(t) do
        t[k] = nil
    end
end

--- Creates a finite state machine.
-- @param t A table containing events, states and transitions.
--
-- * `events` : an array of event IDs. Technically can be of any type that
-- is allowed for a table key, but it is more convenient to use strings.
-- * `states` : an array of state IDs. Technically can be of any type that
-- is allowed for a table key, but it is more convenient to use strings.
-- * `transitions` : a table of the following form.
--
--        transitions = {
--            eventID = {
--                stateID_from = { state = stateID_to, action = f },
--                stateID_from = { state = stateID_to, action = f },
--                ...
--            },
--            eventID = {
--                stateID_from = { state = stateID_to, action = f },
--            },
--            ...
--
--            initial = stateID,
--        }
-- where `eventID` denotes the event that causes the transition,
-- `stateID_from` and `stateID_to` is the current and the next state
-- respectively, and `action` is a function that is called each time this
-- transition is active. Also it **must** contain the initial state under the
-- `initial` key.
-- Events are processed via the `process` method: `fsm:process(event)`.
-- Below you can see an FSM which is used for managing
-- mouse events in this library (which diagram can be seen in the `Block:new`
-- section):
-- @usage
-- local m = self.mouse
--
-- utils.FSM {
--     events = {
--         'press',
--         'inside',
--         'outside',
--         'release',
--     },
-- 
--     states = {
--         'idle',
--         'hovered',
--         'pressed'
--     },
-- 
--     transitions = {
--         ['press']   = {
--             ['hovered'] = { state = 'pressed', action = f(m.onPress) }
--         },
--         ['inside']  = {
--             ['idle']    = { state = 'hovered', action = f(m.onEnter) }
--         },
--         ['outside'] = {
--             ['pressed'] = { state = 'idle', action = f(m.onExit) },
--             ['hovered'] = { state = 'idle', action = f(m.onExit) },
--         },
--         ['release'] = {
--             ['pressed'] = { state = 'hovered', action = f(m.onClick) }
--         },
--     },
-- 
--     initial = 'idle'
-- }
function utils.FSM (t)
    local fsm = {}
    fsm.events = {}
    for i, e in ipairs(t.events) do
        if fsm.events[e] then
            error(('Duplicated event : %s'):format(e), 2)
        end

        fsm.events[e] = i
    end

    fsm.states = {}
    for i, s in ipairs(t.states) do
        if fsm.states[s] then
            error(('Duplicated state : %s'):format(s), 2)
        end

        fsm.states[s] = i
    end

    fsm.state = t.initial
    if not fsm.states[fsm.state] then
        error(('Invalid initial state : %s'):format(tostring(fsm.state)), 2)
    end

    fsm.transitions = t.transitions

    local process = function (self, event)
        local transitions = self.transitions
        local state       = self.state

        local to = transitions[event] and transitions[event][state]
                   or nil

        if not to then
            return
        end

        if to.action then
            to.action()
        end

        self.state = to.state
    end

    fsm.process = process

    return fsm
end

return utils
