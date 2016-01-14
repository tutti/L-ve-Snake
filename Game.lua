require("Object")
require("Button")

Game = Object:new()

Game.debug = ""
Game.paused = false
Game.gameIsOver = false

local width, height = love.graphics.getWidth(), love.graphics.getHeight()
local centerHeight = height / 2

local upImage = love.graphics.newImage("resources/images/up.png")
local arrowImageSize = upImage:getWidth()

Game.upbutton = Button:new(upImage, width - 2*arrowImageSize - C.dpad.margin, centerHeight - (arrowImageSize * 1.5))
Game.downbutton = Button:new(love.graphics.newImage("resources/images/down.png"), width - 2*arrowImageSize - C.dpad.margin, centerHeight + (arrowImageSize / 2))
Game.rightbutton = Button:new(love.graphics.newImage("resources/images/right.png"), width - arrowImageSize - C.dpad.margin, centerHeight - (arrowImageSize / 2))
Game.leftbutton = Button:new(love.graphics.newImage("resources/images/left.png"), width - 3*arrowImageSize - C.dpad.margin, centerHeight - (arrowImageSize / 2))

Game.upbutton:setTolerance(25)
Game.downbutton:setTolerance(25)
Game.rightbutton:setTolerance(25)
Game.leftbutton:setTolerance(25)

Input:registerButton(Game.upbutton)
Input:registerButton(Game.downbutton)
Input:registerButton(Game.rightbutton)
Input:registerButton(Game.leftbutton)

function Game.upbutton:hook_press()
    if not Player.actor then return end
    Player.actor:hook_playerInput("up")
end

function Game.downbutton:hook_press()
    if not Player.actor then return end
    Player.actor:hook_playerInput("down")
end

function Game.rightbutton:hook_press()
    if not Player.actor then return end
    Player.actor:hook_playerInput("right")
end

function Game.leftbutton:hook_press()
    if not Player.actor then return end
    Player.actor:hook_playerInput("left")
end

Game.upbutton.hook_moveOn = Game.upbutton.hook_press
Game.downbutton.hook_moveOn = Game.downbutton.hook_press
Game.rightbutton.hook_moveOn = Game.rightbutton.hook_press
Game.leftbutton.hook_moveOn = Game.leftbutton.hook_press

local startImage = love.graphics.newImage("resources/images/start.png")
local startImageWidth = startImage:getWidth()

Game.startbutton = Button:new(startImage, width - startImageWidth - C.gamebutton.margin, C.gamebutton.margin)
Game.pausebutton = Button:new(love.graphics.newImage("resources/images/pause.png"), width - startImageWidth - C.gamebutton.margin, C.gamebutton.margin)
Game.resumebutton = Button:new(love.graphics.newImage("resources/images/resume.png"), width - startImageWidth - C.gamebutton.margin, C.gamebutton.margin)

Game.pausebutton:hide()
Game.resumebutton:hide()

Input:registerButton(Game.startbutton)
Input:registerButton(Game.pausebutton)
Input:registerButton(Game.resumebutton)

function Game.startbutton:hook_click()
    Game.startbutton:hide()
    Game.pausebutton:show()
    Game:newGame()
end

function Game.pausebutton:hook_click()
    Game.pausebutton:hide()
    Game.resumebutton:show()
    Game:pause()
end

function Game.resumebutton:hook_click()
    Game.resumebutton:hide()
    Game.pausebutton:show()
    Game:resume()
end

function Game:newGame()
    self.debug = ""

    self.board = Board:new()
    self.paused = false
    self.gameIsOver = false
end

function Game:gameOver()
    self.pausebutton:hide()
    self.resumebutton:hide()
    self.startbutton:show()
    self.paused = false
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
    if self.board then
        love.graphics.print("Score: " .. self.board.score, width-450, height-200, 0, 5)
        self.board:draw()
    end

    self.upbutton:draw()
    self.downbutton:draw()
    self.leftbutton:draw()
    self.rightbutton:draw()

    self.startbutton:draw()
    self.pausebutton:draw()
    self.resumebutton:draw()
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