require("actors.Actor")

Wormhole = Actor:extend()

function Wormhole:construct()
    self.orangeCell = Game.board:getRandomCell(false, false)
    while self.orangeCell.x == 1 or self.orangeCell.x == C.board.width or self.orangeCell.y == 1 or self.orangeCell.y == C.board.height do
        self.orangeCell = Game.board:getRandomCell(false, false)
    end
    self.orangeCell:claim(self)
    self.orangeCell:setColour(self, C.colour.orange)
    self.blueCell = Game.board:getRandomCell(false, false)
    while self.blueCell.x == 1 or self.blueCell.x == C.board.width or self.blueCell.y == 1 or self.blueCell.y == C.board.height do
        self.blueCell = Game.board:getRandomCell(false, false)
    end
    self.blueCell:claim(self)
    self.blueCell:setColour(self, C.colour.lightblue)
end

function Wormhole:hook_teleport(cell, direction)
    if not direction then direction = C.direction.none end

    if cell == self.orangeCell then
        return Game.board:getCell(self.blueCell.x + direction[1], self.blueCell.y + direction[2])
    elseif cell == self.blueCell then
        return Game.board:getCell(self.orangeCell.x + direction[1], self.orangeCell.y + direction[2])
    end
end

function Wormhole:hook_cellDestroyed(cell)
    self.orangeCell:release(self)
    self.blueCell:release(self)
    local orangeExplosion = Game.board:getCellsInRange(self.orangeCell.x, self.orangeCell.y, 1)
    local blueExplosion = Game.board:getCellsInRange(self.blueCell.x, self.blueCell.y, 1)
    for k, v in pairs(orangeExplosion:items()) do
        v:destroy(self)
        v:setFilled(nil, true)
    end
    for k, v in pairs(blueExplosion:items()) do
        v:destroy(self)
        v:setFilled(nil, true)
    end
    Game.board:removeActor(self)
end