require("Object")

Game = Object:new()

Game.debug = ""
Game.paused = false
Game.gameIsOver = false

function Game:newGame()
    self.debug = ""

    self.board = Board:new()
    self.paused = false
    self.gameIsOver = false
end

function Game:gameOver()
    self.gameIsOver = true
end

function Game:pause()
    self.paused = true
end

function Game:resume()
    self.paused = false
end

function Game:togglePause()
    self.paused = not self.paused
end

function Game:draw()
    love.graphics.setColor(C.colour.white)
    love.graphics.print(self.debug, 0, 0)
    if self.board then self.board:draw() end
end

function Game:tick()
    if self.paused then return end
    if self.gameIsOver then return end
    if self.board then self.board:gameTick() end
end

local time = 0
function love.update(elapsed)
    time = time + elapsed
    while time >= C.tick do
        Game:tick()
        time = time - C.tick
    end
end