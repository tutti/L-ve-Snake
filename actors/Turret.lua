require("actors.Actor")
require("actors.TurretBullet")

Turret = Actor:extend()

function Turret:construct()
    self.center = Game.board:getRandomCell(false, false)

    local shell = Game.board:getCellsInRange(self.center.x, self.center.y, 1, false)
    for k, v in pairs(shell:items()) do
        v:destroy(self)
        v:setFilled(nil, true)
    end
    self.center:claim(self)
    self.center:setFilled(self, true)
    self.center:setColour(self, C.colour.orange)

    -- Select a direction that has some room to fire
    self.direction = C.direction.random()

    while not Game.board:getCell(self.center.x + self.direction[1] * 3, self.center.y + self.direction[2] * 3) do
        self.direction = C.direction.random()
    end

    self.fireCounter = 0
end

function Turret:fire()
    Game.board:addActor(TurretBullet:new(self.center.x + self.direction[1], self.center.y + self.direction[2], self.direction))
end

function Turret:stop()
    self.center:setFilled(self, true)
    self.center:release(self)
    Game.board:removeActor(self)
end

function Turret:hook_gameTick()
    self.fireCounter = self.fireCounter + 1
    if self.fireCounter >= C.turret.fireTicks then
        self:fire()
        self.fireCounter = 0
    end
end

function Turret:hook_cellDestroyed()
    self:stop()
end

function Turret:hook_cleanup()
    self.center:release(self)
end