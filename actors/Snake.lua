require("actors.Actor")

Snake = Actor:extend()

function Snake:construct(x, y)
    self.x = x
    self.y = y
    self.length = C.snake.length
    self.direction = C.direction.random()
    self.cells = Queue:new()

    self.invincible = 0
end

function Snake:changeDirection(direction)
    -- Don't allow turning 180 degrees, the snake would crash with its own neck
    local neck = self.cells:get(-1)
    if self.x + direction[1] == neck.x and self.y + direction[2] == neck.y then return end
    self.direction = direction
end

function Snake:enableInvincibility()
    self.invincible = C.invincibility.ticks
end

function Snake:move()
    -- Ensure the snake's minimum length
    if self.length < 3 then self.length = 3 end

    -- Find out what the next cell is and acquire it
    local newX, newY = self.x + self.direction[1], self.y + self.direction[2]
    local cell = Game.board:getCell(newX, newY)
    -- If no cell was returned, we fell off the board - go to a random location.
    if not cell then cell = Game.board:getRandomCell(false, false) end
    cell = cell:teleport(self.direction)
    
    -- Check if the next cell is filled - if so, game over.
    -- TODO: Skip this check if the player's invincible.
    if cell.filled and self.invincible <= 0 then
        Game.board:removeActor(self)
        return
    end

    if self.invincible >= 0 then self.invincible = self.invincible - 1 end

    -- Turn the current head black
    if self.cells:size() > 0 then
        local head = self.cells:get(0)
        head:setEdge(self, false)
        head:setColour(self, C.colour.black)
    end

    -- The cell's fine; turn it into the snake's head
    -- Destroy the cell first to ensure that anything that's using it stops.
    cell:destroy(self)
    cell:claim(self)
    self.cells:push(cell)
    cell:setEdge(self, C.colour.black)
    cell:setColour(self, self.invincible > 0 and C.colour.yellow or C.colour.blue)
    cell:setFilled(self, true)
    self.x = cell.x
    self.y = cell.y

    -- If the snake's too long, pop a cell, then clear and release it.
    while self.cells:size() > self.length do
        local tail = self.cells:pop()
        tail:setFilled(self, false)
        tail:release(self)
    end
end

function Snake:hook_gameTick()
    -- Triggers the snake to move
    self:move()
end

function Snake:hook_playerInput(key)
    if key == "up" then self:changeDirection(C.direction.up) end
    if key == "down" then self:changeDirection(C.direction.down) end
    if key == "left" then self:changeDirection(C.direction.left) end
    if key == "right" then self:changeDirection(C.direction.right) end
end

function Snake:hook_cellDestroyed(cell)
    -- Used to remove the cell from the snake's tail
    -- The snake's length isn't affected; the destruction leaves a hole until
    -- the snake moves over it. The cell just needs to be removed so the snake
    -- doesn't try to do things with it it's not allowed to.
    self.cells:remove(cell)
end

function Snake:hook_pellet()
    self.length = self.length + C.snake.growth
end

function Snake:hook_powerup(power)
    if power == "invincibility" then
        self:enableInvincibility()
    end
end

function Snake:hook_cleanup()
    for k, v in pairs(self.cells:items()) do
        v:release(self)
    end
end