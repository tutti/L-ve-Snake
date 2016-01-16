love.math.setRandomSeed(love.timer.getTime())

require("include")

local boardWidth = love.graphics.getWidth() - 2*C.board.margin - C.dpad.margin - Game.dpad:size()
local boardHeight = love.graphics.getHeight() - 2*C.board.margin

C.board.width = math.floor(boardWidth / C.cell.width)
C.board.height = math.floor(boardHeight / C.cell.height)

--Game:newGame()

function love.draw()
    Game:draw()
end