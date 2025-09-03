--- @module class
local Class = {}

--- API.
-- * a _class table_, or a _class_ - is a table that defines a class. This table can be called
--   to create instances of that class. Returned by the `Class:subclass` method.
-- * an _instance table_, or an _instance_, is a table that represents an instance of a class
-- * the `new` method of a class is the _constructor_ of the class. Called when an instance
--   is created
-- * _class.super_ or _instance.super_ refers to the superclass table (if any)
--
-- To create an instance of class `A` you _call_ `A` with a table as the only parameter.
-- This table
-- is accessible then inside the `A:new` method as `self`:
--
--    local A = Class:subclass('A')
--    function A:new()
--        print(('From A:new() : self.foo = %s'):format(self.foo))
--    end
--
--    local a = A { foo = 'bar' }
--    -- > From A:new() : self.foo = bar
--
-- When an instance is created _all_ constructors in the hierarchy are called
-- in the order from parent to child:
--
--    local A = Class:subclass('A')
--    function A:new()
--        print('A:new()')
--    end
--
--    local B = A:subclass('B')
--    function B:new()
--        print('B:new()')
--    end
--
--    local C = B:subclass('C')
--    function C:new()
--        print('C:new()')
--    end
--
--    local c = C { foo = 'bar' }
--    -- > A:new()
--    -- > B:new()
--    -- > C:new()
-- @section api

--- Creates a subclass of a class.
-- @param name Must be a string. This is the name of new class.
-- @return New class (a table).
--
-- @usage
--     local Class = require('class') -- this module
--
--     local Animal = Class:subclass('Animal') -- a class, or a class table
--     local Dog    = Animal:subclass('Dog') -- also a class
--     local bobik  = Dog { name = 'bob' } -- an instance of the Dog class
function Class:subclass (name)
    assert(type(name) == 'string',
           ('bad argument #1 to subclass (string expected, got %s)'):format(type(name)))
    local mt = {
        __call = function (class, instance)
            instance = instance or {}
            assert(type(instance) == 'table',
                   ('bad constructor argument (table expected, got %s)'):format(type(instance)))
            instance = setmetatable(instance or {}, class)

            local constructors = {}
            local current      = class
            local index        = 0

            -- Collect all constructors in the hierarchy
            while current do
                if current.new and not constructors[current.new] then
                    index                     = index + 1
                    constructors[current.new] = index
                    constructors[index]       = current.new
                end
                current = current.super
            end

            -- Call constructors in the reverse order (downwards in the hierarchy)
            for i = #constructors, 1, -1 do
                constructors[i](instance)
            end

            return instance
        end,
        __index = self, -- parent class
        __name = name,
    }

    local class   = {}
    class.__index = class

    class.super   = self

    return setmetatable(class, mt)
end

--- Constructor.
-- Called when an instance of a class is created. The instance created is accessible inside
-- this method as `self`. **Note**: there is no need to return anything from that method.
-- @param _ `self`, the instance itself
-- @usage
--     local Animal = Class:subclass('Animal')
--
--     function Animal:new()
--         print('Animal:new()')
--         self.hp    = self.hp or 100
--         self.alive = true
--     end
--
--     local Dog = Animal:subclass('Dog')
--
--     function Dog:new()
--         print('Dog:new()')
--         self.hasTail = true
--     end
--
--     local bobik = Dog { name = 'bob', hp = 200 }
--     -- > Animal:new()
--     -- > Dog:new()
--
--     assert(bobik.alive == true)
--     assert(bobik.hasTail == true)
--     assert(bobik.hp == 200)
--     assert(bobik.name == 'bob')
function Class.new(_)
end

--- Checks whether a given class is a subclass of another one.
-- **Note**: `self` here must be a class - not an instance. To check whether an instance is
-- a type of a class use `isA`.
-- @param class A class table
-- @return `true` if a class is a subclass of another class. `false` otherwise.
-- @usage
--     local Animal = Class:subclass('Animal')
--     local Dog    = Animal:subclass('Dog')
--     local Cat    = Animal:subclass('Cat')
--
--     Dog:isSubclassOf(Animal) --> true
--     Cat:isSubclassOf(Animal) --> true
--     Cat:isSubclassOf(Dog) --> false
function Class:isSubclassOf (class)
    if self == class then
        return true
    end

    local super = rawget(self, 'super')
    if super then
        return super:isSubclassOf(class)
    end

    return false
end

--- Checks whether a given object is an instance of a class.
-- **Note**: `self` here must be an instance - not a class. To check whether a class is a subclass
-- of another one use `isSubclassOf`.
-- @param class A class table
-- @return `true` if the object is an instance of a given class. `false` otherwise.
-- @usage
--     local Animal = Class:subclass('Animal')
--     local Dog    = Animal:subclass('Dog')
--
--     local bobik = Dog { name = 'bob' }
--
--     bobik:isA(Animal) --> true
--     bobik:isA(Dog) --> true
function Class:isA (class)
    local mt = getmetatable(self)
    return mt:isSubclassOf(class)
end

return Class
