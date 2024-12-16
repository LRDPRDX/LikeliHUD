local UI    = (...):gsub('Inside$', '')
local Block = require(UI .. 'Block')

local Inside = setmetatable({
    __call = function(cls, args)
                return cls:new(args)
             end }, Block)
Inside.__index = Inside

function Inside:new(o)
end
