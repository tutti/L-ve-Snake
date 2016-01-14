require("Object")
require("Button")

Game = Object:new()

Game.debug = ""
Game.paused = false
Game.gameIsOver = false

local width, height = love.graphics.getWidth(), love.graphics.getHeight()
local centerHeight = height / 2

local upImage = love.graphics.newImage("resources/images/up.png")
local imageSize = upImage:getWidth()

Game.upbutton = Button:new(upImage, width - 2*imageSize - C.dpad.right, centerHeight - (imageSize * 1.5))
Game.downbutton = Button:new(love.graphics.newImage("resources/images/down.png"), width - 2*imageSize - C.dpad.right, centerHeight + (imageSize / 2))
Game.rightbutton = Button:new(love.graphics.newImage("resources/images/right.png"), width - imageSize - C.dpad.right, centerHeight - (imageSize / 2))
Game.leftbutton = Button:new(love.graphics.newImage("resources/images/left.png"), width - 3*imageSize - C.dpad.right, centerHeight - (imageSize / 2))

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

    self.upbutton:draw()
    self.downbutton:draw()
    self.leftbutton:draw()
    self.rightbutton:draw()
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