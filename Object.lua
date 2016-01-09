Object = {}

function Object:construct(...)
    -- Empty constructor
end

function Object:new(...)
    local r = {}
    setmetatable(r, self)
    self.__index = self
    r:construct(...)
    return r
end

function Object:extend()
    local r = {}
    setmetatable(r, self)
    self.__index = self
    return r
end

function Object:is(class)
    if self == class then return true end
    local parent = getmetatable(self)
    if not parent then return false end
    return parent:is(class)
end