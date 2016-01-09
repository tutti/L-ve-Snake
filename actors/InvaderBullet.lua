require("actors.Actor")

InvaderBullet = Actor:extend()

function InvaderBullet:construct(x, y)
    self.x = x
    self.y = y
    self.exploded = false
    self.remaining = C.invader.bulletLength
end

function InvaderBullet:move()
    local cell = Game.board:getCell(self.x, self.y - C.invader.bulletLength - 1)
    if cell then
        cell:setFilled(self, false)
        cell:release(self)
    end

    if self.remaining > 0 then self.remaining = self.remaining - 1 end

    for y=1, C.invader.bulletLength - self.remaining do
        cell = Game.board:getCell(self.x, self.y - y)
        if cell then
            if cell.filled and not (cell.owner and cell.owner:is(InvaderBullet)) then
                self:explode()
                return
            end
            cell:destroy(self)
            cell:claim(self)
            cell:setColour(self, C.colour.grey)
            cell:setFilled(self, true)
        end
    end
    if self.y - C.invader.bulletLength > C.board.height then
        Game.board:removeActor(self)
    end

    self.y = self.y + 1
end

function InvaderBullet:explodeTick()
    local oldCells = Game.board:getCellsInRange(self.x, self.y, self.exploded, false)
    for k, v in pairs(oldCells:items()) do
        v:setFilled(self, false)
        v:release(self)
    end
    self.exploded = self.exploded + 1
    if self.exploded > C.invader.bulletExplosionSize then
        Game.board:removeActor(self)
        return
    end
    local newCells = Game.board:getCellsInRange(self.x, self.y, self.exploded, false)
    for k, v in pairs(newCells:items()) do
        v:destroy(self)
        v:claim(self)
        v:setFilled(self, true)
        v:setColour(self, C.colour.grey)
    end
end

function InvaderBullet:explode()
    if self.exploded then return end
    self.exploded = -1
end

function InvaderBullet:hook_gameTick()
    if self.exploded then
        self:explodeTick()
    else
        self:move()
    end
end

function InvaderBullet:hook_cellDestroyed(cell, destroyer)
    if destroyer == self then return end
    self:explode()
end