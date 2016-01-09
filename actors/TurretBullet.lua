require("actors.Actor")

TurretBullet = Actor:extend()

function TurretBullet:construct(x, y, direction)
    self.x = x
    self.y = y
    self.direction = direction
end

function TurretBullet:move()
    local cell = Game.board:getCell(self.x, self.y)
    cell:setFilled(self, false)
    cell:release(self)
    self.x = self.x + self.direction[1]
    self.y = self.y + self.direction[2]
    cell = Game.board:getCell(self.x, self.y)
    if cell then
        if cell.filled or not cell:claim(self) then
            self:stop()
            return
        end
        cell:setFilled(self, true)
        cell:setColour(self, C.colour.black)
    else
        self:stop()
    end
end

function TurretBullet:stop()
    Game.board:removeActor(self)
end

function TurretBullet:hook_gameTick()
    self:move()
end

function TurretBullet:hook_cleanup()
    local cell = Game.board:getCell(self.x, self.y)
    if cell then cell:release(self) end
end