require("Object")

Cell = Object:extend()

function Cell:construct(x, y)
    self.x = x
    self.y = y
    self.filled = false
    self.owner = nil
    self.colour = C.colour.white
    self.edge = false
    self.doPreserve = false
    self.edgePreserve = false
end

function Cell:draw()
    local pixX = C.board.left + (self.x - 1) * C.cell.width
    local pixY = C.board.top + (self.y - 1) * C.cell.height
    love.graphics.setColor(self.doPreserve or self.colour)
    love.graphics.rectangle("fill", pixX, pixY, C.cell.width, C.cell.height)
    if self.edgePreserve or self.edge then
        love.graphics.setColor(self.edgePreserve or self.edge)
        love.graphics.rectangle("line", pixX+0.5, pixY+0.5, C.cell.width-1, C.cell.height-1)
    end
end

function Cell:claim(owner)
    -- If the cell is unclaimed, claims it and returns true.
    -- If the cell is claimed, requests a release from the owner and returns
    -- whether that succeeded.
    -- TODO: Request a release from owner
    if self.owner then owner:hook_cellClaimRequest() end
    if not self.owner then
        self.owner = owner
        return true
    end
    return false
end

function Cell:release(owner)
    -- Releases the cell, meaning other actors can claim it.
    -- Must own cell to release it.
    -- The cell will either go black or white, depending on whether it's filled
    -- or not.
    if self.owner ~= owner then return false end
    self:setColour(owner, self.filled and C.colour.black or C.colour.white)
    self:setEdge(owner, false)
    self.owner = nil
end

function Cell:destroy(actor)
    -- Destroys the cell. This clears whatever's in the cell, and removes the
    -- owner. The owner is notified that this has happened.
    self.filled = false
    self.colour = C.colour.white
    self.edge = false
    if self.owner then self.owner:hook_cellDestroyed(self, actor) end
    self.owner = nil
end

function Cell:teleport(direction)
    -- Checks if the cell has a teleporting actor as owner, and if that actor
    -- will teleport from this cell. A direction may be supplied, but is not
    -- required. Returns either this cell, or the one that is teleported to.
    if not self.owner then return self end
    return self.owner:hook_teleport(self, direction)
end

function Cell:setColour(owner, colour)
    if not self.owner then return end
    if self.owner ~= owner then return false end
    self.colour = colour
end

function Cell:setEdge(owner, edgeColour)
    if not self.owner then return end
    if self.owner ~= owner then return false end
    self.edge = edgeColour
end

function Cell:setFilled(owner, filled)
    if self.owner ~= owner then return false end
    self.filled = filled
    if not self.owner then
        self.edge = false
        self.colour = filled and C.colour.black or C.colour.white
    end
end

function Cell:preserve()
    self.doPreserve = self.colour
    self.edgePreserve = self.edge
end
