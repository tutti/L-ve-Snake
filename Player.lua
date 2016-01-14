require("Object")

Player = Object:new()

Player.actor = false

function Player:setActor(actor)
    self.actor = actor
end

function Player:isActor(actor)
    return self.actor == actor
end