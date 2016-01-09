require("actors.Actor")

local getX, getY = 0, 0
local function cellSelectFunc(cell)
    return math.abs(getX - cell.x) <= 1 or math.abs(getY - cell.y) <= 1
end

AntimatterBomb = Actor:extend()

function AntimatterBomb:construct()
    self.countdown = C.antimatter.ticksPerStage * 4

    self.center = Game.board:getRandomCell(false, false)
    self.center:claim(self)
    self.center:setColour(self, C.colour.darkgreen)
    self.center:setFilled(self, true)
end

function AntimatterBomb:explode()
    getX = self.center.x
    getY = self.center.y
    self.center:setFilled(self, false)
    self.cellList = Game.board:getCellsByFunction(cellSelectFunc)
    for k, v in pairs(self.cellList:items()) do
        local filled = v.filled
        v:destroy(self)
        v:claim(self)
        v:setFilled(self, true)
        v:setColour(self, filled and C.colour.darkred or C.colour.red)
    end
end

function AntimatterBomb:hook_gameTick()
    self.countdown = self.countdown - 1

    if     self.countdown == C.antimatter.ticksPerStage * 3 then
        self.center:setColour(self, C.colour.orange)
    elseif self.countdown == C.antimatter.ticksPerStage * 2 then
        self.center:setColour(self, C.colour.red)
    elseif self.countdown == C.antimatter.ticksPerStage     then
        self:explode()
    elseif self.countdown == 0 then
        Game.board:removeActor(self)
    end
end

function AntimatterBomb:hook_cleanup()
    for k, v in pairs(self.cellList:items()) do
        if v.owner == self then
            v:setFilled(self, false)
            v:release(self)
        end
    end
end

function AntimatterBomb:hook_cellDestroyed(cell)
    if cell == self.center then
        self.countdown = C.antimatter.ticksPerStage + 1
    end
end