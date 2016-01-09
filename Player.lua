require("Object")

Player = Object:new()

Player.actor = false

function Player:setActor(actor)
    self.actor = actor
end

function Player:isActor(actor)
    return self.actor == actor
end

function love.keypressed(key, scancode, isrepeat)
    if isrepeat then return end
    if C.direction[scancode] then
        if Game.paused or Game.gameIsOver then return end
        Player.actor:hook_playerInput(scancode)
        return
    end
    if scancode == "space" then Game:togglePause() end
end