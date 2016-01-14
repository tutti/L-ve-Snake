love.math.setRandomSeed(love.timer.getTime())

require("include")



Game:newGame()

function love.draw()
    Game:draw()
end