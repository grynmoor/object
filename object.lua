
local _METAMETHODS = { --- Lookup table used for filtering metamethods
    __index = true;
    __newindex = true;
    __call = true;
    __concat = true;
    __unm = true;
    __add = true;
    __sub = true;
    __mul = true;
    __div = true;
    __mod = true;
    __pow = true;
    __tostring = true;
    __metatable = true;
    __eq = true;
    __lt = true;
    __le = true;
    __mode = true;
    __gc = true;
    __len = true;}


---@class Object
local Object = {}               --- Base object class

Object.class = Object           --- Class reference
Object.classname = "Object"     --- Class string identifier
Object.super = false            --- Superclass reference
Object._metaclass = {};         --- Container for class metamethods


--- Allows classes to access variables from the class they inherit from
function Object._metaclass:__index(i)
    local s = self.super
    if s then return s[i] end
end


--- Creates a new instance when this class is called like a function
function Object._metaclass:__call(...)
    return self:wrap({}, ...)
end


--- Allows instances to access class variables.
--- getmetatable() should be used in __index functions to reference the correct class when the function is inherited
function Object:__index(i)
    return getmetatable(self)[i]
end


--- Returns the class string identifier when instances are cast to string
function Object:__tostring()
    return self.classname
end


--- Instance constructor. Behavior can be defined in extending classes
function Object:new(...)

end


--- Class method. Wraps the provided table into a class instance
function Object:wrap(t, ...)

    local c = self.class
    setmetatable(t, c)
    c.new(t, ...)

    return t
end


--- Class method. Returns true if the provided table inherits from the class or a superclass
function Object:is(t)
    local c = self.class
    local tc = getmetatable(t)

    while tc do
        if tc == c then return true end
        tc = tc.super
    end

    return false
end


--- Class method. Returns a new class that inherits from this class
function Object:extend(classname)
    local c = self.class

    local NewClass = {}

    NewClass.class = NewClass
    NewClass.classname = classname
    NewClass.super = c
    NewClass._metaclass = {}

    -- Copy over class and instance metamethods
    for i, _ in pairs(_METAMETHODS) do
        NewClass._metaclass[i] = rawget(c._metaclass, i)
        NewClass[i] = rawget(c, i)
    end

    return setmetatable(NewClass, NewClass._metaclass)
end


return setmetatable(Object, Object._metaclass)
