require("actors.Actor")
require("Pattern")

Tetromino = Actor:extend()

function Tetromino:construct(xMin, xMax)
    xMin = xMin or 3
    xMax = xMax or C.board.width - 3
    self.x = love.math.random(xMin, xMax)
    self.y = love.math.random(-15, -5)

    local shapenum = love.math.random(1, #C.shapes.tetrominoes)
    --shapenum = 3
    self.pattern = Pattern:new(C.shapes.tetrominoes[shapenum])

    for i=1, love.math.random(0, 3) do
        self.pattern:rotateRight()
    end

    self.ticks = C.tetromino.ticksPerMove
end

function Tetromino:move()

    local currentCells = Game.board:getCellsByPattern(self.x, self.y, self.pattern)
    if self:checkForStop(currentCells) then return end

    for k, v in pairs(currentCells:items()) do
        v:setFilled(self, false)
        v:release(self)
    end

    self.y = self.y + 1

    local nextCells = Game.board:getCellsByPattern(self.x, self.y, self.pattern)

    for k, v in pairs(nextCells:items()) do
        v:destroy(self)
        v:claim(self)
        v:setFilled(self, true)
        v:setColour(self, C.colour.black)
    end

    if self:checkForStop(nextCells) then return end
end

function Tetromino:checkForStop(currentCells)
    for k, v in pairs(currentCells:items()) do
        local cell = Game.board:getCell(v.x, v.y+1)
        if not cell or (cell.owner ~= self and cell.filled) then
            self:stop()
            return true
        end
    end
    return false
end

function Tetromino:stop()
    Game.board:removeActor(self)
end

function Tetromino:hook_gameTick()
    self.ticks = self.ticks - 1

    if self.ticks <= 0 then
        self:move()
        self.ticks = C.tetromino.ticksPerMove
    end
end

function Tetromino:hook_cellDestroyed(cell, destroyer)
    if cell.x >= self.x and cell.x < self.x + self.pattern:width() and cell.y >= self.y and cell.y < self.y + self.pattern:height() then
        self.pattern:removeCell(cell.x - self.x + 1, cell.y - self.y + 1)
    end
end

function Tetromino:hook_cleanup()
    Game.board:releaseAllCells(self)
end