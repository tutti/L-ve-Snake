require("actors.Actor")

local dims = {"width", "height"}
local getX, getY, tolX, tolY = 0, 0, 0, 0
local function getCellFunc(cell)
    return math.abs(getX-cell.x) <= tolX and math.abs(getY-cell.y) <= tolY
end

GigaSnake = Actor:extend()

function GigaSnake:construct()
    self.direction = C.direction.random()
    self.position = {}
    for i=1, 2 do
        if self.direction[i] == 0 then
            self.position[i] = love.math.random(3, C.board[dims[i]]-2)
        elseif self.direction[i] == 1 then
            self.position[i] = 0
        else
            self.position[i] = C.board[dims[i]] + 1
        end
    end
end

function GigaSnake:move()
    for i=1, 2 do self.position[i] = self.position[i] + self.direction[i] end
    getX = self.position[1]
    getY = self.position[2]
    tolX = math.abs(self.direction[2] * C.gigasnake.size)
    tolY = math.abs(self.direction[1] * C.gigasnake.size)
    local headCells = Game.board:getCellsByFunction(getCellFunc)
    getX = self.position[1] - C.gigasnake.length * self.direction[1]
    getY = self.position[2] - C.gigasnake.length * self.direction[2]
    local tailCells = Game.board:getCellsByFunction(getCellFunc)
    for k, v in pairs(headCells:items()) do
        v:destroy(self)
        v:claim(self)
        v:setFilled(self, true)
        v:setColour(self, C.colour.black)
    end
    for k, v in pairs(tailCells:items()) do
        local dropVal = love.math.random()
        if dropVal > C.gigasnake.dropChance then
            v:setFilled(self, false)
        end
        v:release(self)
    end

    if (getX < 0 and self.position[1] < 0)
    or (getX > C.board.width and self.position[1] > C.board.width)
    or (getY < 0 and self.position[2] < 0)
    or (getY > C.board.height and self.position[2] > C.board.height)
    then
        Game.board:removeActor(self)
    end

end

function GigaSnake:hook_gameTick()
    self:move()
end

function GigaSnake:hook_cleanup()
    Game.board:releaseAllCells(self)
end