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

local function textAtWidth (text, l, r, width, font)
    -- Preconditions.
    -- If they are true at the top of this function, they are also true
    -- once the function returns. I.e. this function doesn't break them.
    --
    -- a) l <= r
    -- b) l >= 1
    -- c) text:sub(1, l) <= width
    -- d) r <= text:len()
    -- e) width >= 0
    local prefix = text:sub(1, r)

    -- At each call of this function text:sub(1, r) is at least
    -- as wide as width (see (2) below). So if it is less or equal it
    -- must be exactly equal
    -- (unless it is strictly less on the very first call).
    if font:getWidth(prefix) <= width then -- (1)
        return prefix
    end

    local diff = math.floor((r - l) / 2)

    -- diff is equal to zero iff either `r == l` or `r == l + 1`
    -- but the former case (`r == l`) would violate the c) precondition
    -- (see (1))
    -- so the only option is `r == l + 1` which in turn means l is the
    -- maximum possible number of chars we can fit.
    if diff == 0 then
        return text:sub(1, l)
    end

    -- otherwise diff is at least 1.
    local midPoint        = l + diff
    local widthAtMidPoint = font:getWidth(text:sub(1, midPoint))

    if widthAtMidPoint >= width then -- (2)
        r = midPoint
    else
        l = midPoint
    end

    return textAtWidth(text, l, r, width, font)
end

--- Returns the maximum substring (prefix) of a string which width
--- is less than or equal to a given width.
-- _NOTE_: this function will work only for fonts with monotonically
-- increasing width once the length of the string increases. In other words,
-- for any non-empty strings `S1`, `S2`: `width(S1 + S2) > width(S1)`.
-- @param text A string. The original text to elide.
-- @param width A non-negative number. The width to fit the text.
-- @param font A font. The target font.
-- @return A string. The maximum prefix of `text` which width
-- (according to the font `font`) is less or equal to `width`.
-- If `text` is an empty string returns an empty string.
-- If `width` is 0 returns an empty string.
function utils.textAtWidth (text, width, font)
    assert(width >= 0, 'width must be non-negative')

    if (width == 0) or
       (text:len() == 0) or
       (font:getWidth(text:sub(1, 1)) > width) then
        return ''
    end

    return textAtWidth (text, 1, text:len(), width, font)
end

--- Places the block in a given enclosing cell with some default algorithm.
-- It is unlikely you need this function ever -- it is used internally, but
-- exposed for the sake of reusability.
-- @param block
-- @param x x coordinate of the enclosing cell
-- @param y y coordinate of the enclosing cell
-- @param w width of the enclosing cell
-- @param h height of the enclosing cell
-- @param s size of the block which must be used during placement. If `nil` then
-- `Block:size` is used.
--
-- @see Block:place
function utils.placeAt (block, x, y, w, h, s)
    s = s or block:size()

    -- Initial position at the center of the enclosing cell
    block.x = utils.round(x + (w - s.x) / 2)
    block.y = utils.round(y + (h - s.y) / 2)

    local move = {
        ['left']   = function()
            block.x = x
        end,

        ['right']  = function()
            block.x = x + (w - s.x)
        end,

        ['bottom'] = function()
            block.y = y + (h - s.y)
        end,

        ['top']    = function()
            block.y = y
        end
    }

    for direction in block.align:gsub('%s+', ''):gmatch('([^+]+)') do
        if move[direction] then move[direction]() end
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
