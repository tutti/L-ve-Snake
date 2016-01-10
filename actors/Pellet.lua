require("actors.Actor")

Pellet = Actor:extend()

function Pellet:construct()
    self.cells = {}
    self.cellcount = 0
    self.powerCooldown = love.math.random(C.pellet.powerCooldownMin, C.pellet.powerCooldownMax)
    --self.powerCooldown = 0
end

function Pellet:placeRandom(type)
    local cell = Game.board:getRandomCell(false, false)
    cell:claim(self)
    if not type then
        type = "normal"
        self.powerCooldown = self.powerCooldown - 1
        if self.powerCooldown <= 0 then
            type = "power"
            self.powerCooldown = love.math.random(C.pellet.powerCooldownMin, C.pellet.powerCooldownMax)
        end
    end

    if type == "power" then
        cell:setColour(self, C.colour.lightgreen)
    else
        cell:setColour(self, C.colour.magenta)
    end
    self.cells[cell] = type
    self.cellcount = self.cellcount + 1
end

function Pellet:hook_gameTick()
    if self.cellcount < C.pellet.minimum then
        self:placeRandom()
    end
end

function Pellet:hook_cellDestroyed(cell, destroyer)
    if not self.cells[cell] then return end
    destroyer:hook_pellet()
    if Player:isActor(destroyer) then Game.board:addPoint() end
    if self.cells[cell] == "power" then self:triggerPowerPellet(cell, destroyer) end
    self.cells[cell] = nil
    self.cellcount = self.cellcount - 1
end

function Pellet:triggerPowerPellet(cell, actor)
    cell:release(self)
    local effectNumber = love.math.random(1, 10)
    --effectNumber = 3 -- FOR TESTING
    --while effectNumber ~= 9 and effectNumber ~= 2 do effectNumber = love.math.random(1, 9) end
    if effectNumber == 1 then
        -- Release a bouncer where the power pellet was
        Game.board:addActor(Bouncer:new(cell.x, cell.y))
    end
    if effectNumber == 2 then
        -- Release a number of bombs
        Bombs:trigger(self)
    end
    if effectNumber == 3 then
        -- Release an antimatter bomb
        Game.board:addActor(AntimatterBomb:new())
    end
    if effectNumber == 4 then
        -- Turn the actor invincible
        actor:hook_powerup("invincibility")
    end
    if effectNumber == 5 then
        -- Spawn a giga snake
        Game.board:addActor(GigaSnake:new())
    end
    if effectNumber == 6 then
        -- Add tetrominoes
        local distance = math.floor(C.board.width / 5)
        for i=1, C.tetromino.count do
            local xMin = (i-1) * distance + 3
            local xMax = i * distance - 3
            Game.board:addActor(Tetromino:new(xMin, xMax))
        end
    end
    if effectNumber == 7 then
        -- Evil snake
        Game.board:addActor(EvilSnake:new())
    end
    if effectNumber == 8 then
        -- Wormhole
        Game.board:addActor(Wormhole:new())
    end
    if effectNumber == 9 then
        -- Invaders
        Game.board:addActor(Invader:new())
    end
    if effectNumber == 10 then
        -- Turret
        Game.board:addActor(Turret:new())
    end
end