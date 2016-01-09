require("events.Event")

Bombs = Event:extend()

function Bombs:trigger(actor)
    for i=1, C.bombs.bombCount do
        local center = Game.board:getRandomCell(false, false)
        local cells = Game.board:getCellsInRange(center.x, center.y, C.bombs.bombSize, true)
        for k, v in pairs(cells:items()) do
            v:destroy(actor)
            v:setFilled(nil, true)
        end
    end
end