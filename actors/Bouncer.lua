require("actors.Actor")

Bouncer = Actor:extend()

function Bouncer:construct(x, y)
    self.name = "Bouncer"
    self.x = x
    self.y = y
    self.life = C.bouncer.life
    self.cell = Game.board:getCell(x, y)
    self.cell:destroy(self)
    self.cell:claim(self)
    self.cell:setColour(C.colour.lightgreen)

    self.moveX = love.math.random(1, 2) * 2 - 3
    self.moveY = love.math.random(1, 2) * 2 - 3
end

function Bouncer:move()
    self.life = self.life - 1
    if self.life <= 0 then
        return self:explode()
    end

    local cell1 = Game.board:getCell(self.x + self.moveX, self.y)
    local cell2 = Game.board:getCell(self.x, self.y + self.moveY)
    local cell3 = Game.board:getCell(self.x + self.moveX, self.y + self.moveY)

    local bounceX, bounceY = false, false

    if not cell1 then
        bounceX = true
    elseif cell1.filled then
        cell1:destroy(self)
        bounceX = true
    end
    if not cell2 then
        bounceY = true
    elseif cell2.filled then
        cell2:destroy(self)
        bounceY = true
    end
    if cell3 and cell3.filled and not (bounceX or bounceY) then
        cell3:destroy(self)
        bounceX, bounceY = true, true
    end

    if bounceX then self.moveX = -self.moveX end
    if bounceY then self.moveY = -self.moveY end

    local nextX = self.x + self.moveX
    local nextY = self.y + self.moveY
    local nextCell = Game.board:getCell(nextX, nextY)
    if not nextCell then self:explode() return end
    if nextCell.filled then self:explode() return end

    self.x = nextX
    self.y = nextY
    self.cell:release(self)
    self.cell = nextCell
    nextCell:destroy(self)
    nextCell:claim(self)
    nextCell:setColour(self, C.colour.lightgreen)
end

function Bouncer:explode()
    local cells = Game.board:getCellsInRange(self.x, self.y, -self.life-1, false)
    for k, v in pairs(cells:items()) do
        v:destroy(self)
    end
    if self.life < -C.bouncer.explosionSize then
        Game.board:removeActor(self)
        return
    end
    local cells = Game.board:getCellsInRange(self.x, self.y, -self.life, false)
    for k, v in pairs(cells:items()) do
        v:destroy(self)
        v:claim(self)
        v:setColour(self, C.colour.lightgreen)
    end
end

function Bouncer:hook_gameTick()
    self:move()
end