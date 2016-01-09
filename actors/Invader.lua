require("actors.Actor")
require("Pattern")
require("actors.InvaderBullet")

Invader = Actor:extend()

function Invader:construct()
    local invaderNum = love.math.random(1, #C.shapes.invaders)
    --invaderNum = 2
    self.patterns = {}
    for i=1, #C.shapes.invaders[invaderNum] do
        self.patterns[i] = Pattern:new(C.shapes.invaders[invaderNum][i])
    end

    self.frame = 1
    self.frameCounter = 0

    self.bulletCounter = love.math.random(1, C.invader.bulletTicks)

    self.x = -self.patterns[1]:width()
    self.y = 1
end

function Invader:getCurrentPattern()
    return self.patterns[self.frame]
end

function Invader:advanceFrame()
    self.frameCounter = self.frameCounter + 1
    if self.frameCounter >= C.invader.frameTicks then
        self.frameCounter = 0
        self.frame = ((self.frame) % #self.patterns) + 1
    end
end

function Invader:move()
    local currentCells = Game.board:getCellsByPattern(self.x, self.y, self:getCurrentPattern())

    for k, v in pairs(currentCells:items()) do
        v:setFilled(self, false)
        v:release(self)
    end

    self.x = self.x + 1
    self:advanceFrame()
    self.bulletCounter = self.bulletCounter - 1
    if self.bulletCounter <= 0 then
        Game.board:addActor(InvaderBullet:new(self.x + math.floor(self.patterns[1]:width() / 2), self.y + self.patterns[1]:height() + 1))
        self.bulletCounter = C.invader.bulletTicks
    end

    if self.x > C.board.width then
        Game.board:removeActor(self)
    end

    local nextCells = Game.board:getCellsByPattern(self.x, self.y, self:getCurrentPattern())

    for k, v in pairs(nextCells:items()) do
        v:destroy(self)
        v:claim(self)
        v:setFilled(self, true)
        v:setColour(self, C.colour.black)
    end
end

function Invader:hook_gameTick()
    self:move()
end