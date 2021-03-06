require("Object")
require("Button")

Game = Object:new()

Game.debug = ""
Game.paused = false
Game.gameIsOver = false

local width, height = love.graphics.getWidth(), love.graphics.getHeight()
local centerHeight = height / 2

local dpadImage = love.graphics.newImage("resources/images/dpad.png")
local dpadSize = dpadImage:getWidth()

Game.dpad = Button:new(dpadImage, width - dpadSize - C.dpad.margin, centerHeight - dpadSize / 2)
Game.dpad:setTolerance(10)
function Game.dpad:hook_press(x, y)
    if not Player.actor then return end
    if y > x then
        if y > -x then
            -- Down
            Player.actor:hook_playerInput("down")
        else
            -- Left
            Player.actor:hook_playerInput("left")
        end
    else
        if y > -x then
            -- Right
            Player.actor:hook_playerInput("right")
        else
            -- Up
            Player.actor:hook_playerInput("up")
        end
    end
end

Game.dpad.hook_move = Game.dpad.hook_press

local startImage = love.graphics.newImage("resources/images/start.png")
local startImageWidth = startImage:getWidth()

Game.startbutton = Button:new(startImage, width - startImageWidth - C.gamebutton.margin, C.gamebutton.margin)
Game.pausebutton = Button:new(love.graphics.newImage("resources/images/pause.png"), width - startImageWidth - C.gamebutton.margin, C.gamebutton.margin)
Game.resumebutton = Button:new(love.graphics.newImage("resources/images/resume.png"), width - startImageWidth - C.gamebutton.margin, C.gamebutton.margin)

Game.pausebutton:hide()
Game.resumebutton:hide()

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

    --[[
    self.upbutton:draw()
    self.downbutton:draw()
    self.leftbutton:draw()
    self.rightbutton:draw()
    ]]
    self.dpad:draw()

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
    if time >= C.tick then
        Game:tick()
        time = 0
    end
end