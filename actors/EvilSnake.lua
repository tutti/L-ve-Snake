require("actors.Actor")

EvilSnake = Actor:extend()

function EvilSnake:construct()
    self.cells = Queue:new()

    local firstCell = Game.board:getRandomCell(false, false)
    self.x = firstCell.x
    self.y = firstCell.y
    firstCell:claim(self)
    firstCell:setFilled(self, true)
    firstCell:setColour(self, self.empowered and C.colour.darkred or C.colour.grey)
    self.cells:push(firstCell)

    self.life = C.evilsnake.life

    self.direction = C.direction.random()
    self.directionCounter = love.math.random(C.evilsnake.changeDirectionMin, C.evilsnake.changeDirectionMax)

    self.empowered = false
end

function EvilSnake:move()

    self.life = self.life - 1

    if self.life > 0 then
        local nextX = ((self.x + self.direction[1] - 1) % C.board.width) + 1
        local nextY = ((self.y + self.direction[2] - 1) % C.board.height) + 1
        local nextCell = Game.board:getCell(nextX, nextY)
        nextCell = nextCell:teleport(self.direction)
        nextCell:destroy(self)
        nextCell:claim(self)
        nextCell:setColour(self, self.empowered and C.colour.darkred or C.colour.grey)
        nextCell:setFilled(self, true)
        self.cells:push(nextCell)
        self.x = nextCell.x
        self.y = nextCell.y
    end

    if self.cells:size() > C.evilsnake.length or self.life <= 0 then
        local cell = self.cells:pop()
        cell:setFilled(self, false)
        cell:release(self)

        if self.empowered then
            local rnd = love.math.random(1, 10)
            if rnd == 1 then
                self:dropBomb()
            end
        end
    end

    self.directionCounter = self.directionCounter - 1

    if self.directionCounter <= 0 then
        local rnd = love.math.random(1, 2)
        if self.direction[1] == 0 then
            self.direction = (rnd == 1 and C.direction.left or C.direction.right)
        else
            self.direction = (rnd == 1 and C.direction.up or C.direction.down)
        end
        self.directionCounter = love.math.random(C.evilsnake.changeDirectionMin, C.evilsnake.changeDirectionMax)
    end

    if self.life <= 0 and self.cells:size() <= 0 then
        Game.board:removeActor(self)
    end
end

function EvilSnake:dropBomb()
    local tailCell = self.cells:get(1)
    local cells = Game.board:getCellsInRange(tailCell.x, tailCell.y, 1)
    for k, v in pairs(cells:items()) do
        v:destroy(self)
        v:setFilled(nil, true)
    end
end

function EvilSnake:hook_gameTick()
    self:move()
end

function EvilSnake:hook_cleanup()
    for k, v in pairs(self.cells:items()) do
        v:release(self)
    end
end

function EvilSnake:hook_pellet()
    self.empowered = true
end