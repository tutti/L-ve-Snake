require("Object")

Collection = Object:extend()

function Collection:construct()
    self.collection = {}
end

function Collection:size()
    return #self.collection
end

function Collection:items()
    return self.collection
end

function Collection:indexOf(element)
    for i=1, #self.collection do
        if self.collection[i] == element then return i end
    end
    return -1
end

function Collection:remove(element)
    -- Removes all instances of element from the collection
    for i=1, #self.collection do
        while self.collection[i] == element do
            table.remove(self.collection, i)
        end
    end
end

function Collection:get(position)
    -- Returns an item directly from the collections table.
    -- Positive numbers return the item in that position.
    -- Negative numbers return the item that far from the end.
    -- 0 gets the last item
    if position > 0 then
        return self.collection[position]
    else
        return self.collection[#self.collection+position]
    end
end

Stack = Collection:extend()
-- Note: For stacks, the first element added is the first element in the stack.
-- So, for Stack:get(), the most recently added items are at the end.

function Stack:push(element)
    -- Puts an element at the top of the stack
    self.collection[#self.collection+1] = element
end

function Stack:pop()
    -- Removes an element from the top of the stack and returns it
    local element = self.collection[#self.collection]
    self.collection[#self.collection] = nil
    return element
end

function Stack:peek()
    -- Returns the next element that will be popped
    return self.collection[#self.collection]
end

Queue = Collection:extend()

function Queue:push(element)
    -- Adds an element to the back of the queue
    self.collection[#self.collection+1] = element
end

function Queue:pop()
    -- Removes an element from the front of the queue and returns it
    return table.remove(self.collection, 1)
end

function Queue:peek()
    -- Returns the next element that will be popped
    return self.collection[1]
end

Set = Collection:extend()

function Set:add(element)
    if element == nil then return end
    if self:contains(element) then return end
    self.collection[#self.collection+1] = element
end

function Set:contains(element)
    for i=1, #self.collection do
        if self.collection[i] == element then return true end
    end
    return false
end

-- Function for cloning tables

local function _tableclone(tbl, refs)
    if type(tbl) ~= "table" then return tbl end
    if refs[tbl] then return refs[tbl] end
    local metatable = getmetatable(tbl)
    local r = {}
    refs[tbl] = r
    setmetatable(r, _tableclone(metatable, refs))
    for k, v in pairs(tbl) do
        if type(k) == "table" then k = _tableclone(k, refs) end
        if type(v) == "table" then v = _tableclone(v, refs) end
        r[k] = v
    end
    return r
end

function table.clone(tbl)
    local refs = {}
    return _tableclone(tbl, refs)
end