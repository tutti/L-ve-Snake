require("Object")
require("Cell")
require("actors.Snake")
require("actors.Pellet")

Board = Object:extend()

function Board:construct()
    self.cells = {}
    for x=1, C.board.width do
        self.cells[x] = {}
        for y=1, C.board.height do
            self.cells[x][y] = Cell:new(x, y)
        end
    end

    self.actors = Set:new()
    local snake = Snake:new(love.math.random(C.board.width), love.math.random(C.board.height))
    self.actors:add(snake)
    Player:setActor(snake)

    self.pellet = Pellet:new()
    self.actors:add(self.pellet)

    self.score = 0
end

function Board:draw()
    for x=1, C.board.width do
        for y=1, C.board.height do
            self.cells[x][y]:draw()
        end
    end
end

function Board:gameTick()
    for k, v in pairs(self.actors:items()) do
        v:hook_gameTick()
    end

    -- if not self.test then
    --     for i=1, 10 do
    --         self.pellet:triggerPowerPellet(self:getRandomCell(false, false), snake)
    --     end
    --     self.test = true
    -- end
end

function Board:getCell(x, y)
    if (x < 1 or x > C.board.width or y < 1 or y > C.board.height) then return nil end
    return self.cells[x][y]
end

function Board:getCellsInRange(x, y, range, fill)
    -- Returns a set of all cells within a certain distance of the center cell
    local cells = Set:new()
    local start = range
    if fill or fill == nil then
        start = 0
    end
    for r=start, range do
        for i=0, r do
            cells:add(self:getCell(x+i, y+r-i))
            cells:add(self:getCell(x+i, y+i-r))
            cells:add(self:getCell(x-i, y+r-i))
            cells:add(self:getCell(x-i, y+i-r))
        end
    end
    return cells
end

function Board:getCellsByPattern(x, y, pattern)
    -- Expects a Pattern object
    local cells = Set:new()
    for px=1, pattern:width() do
        for py=1, pattern:height() do
            local val = pattern:valueAt(px, py)
            --val = true
            if val then
                local cell = self:getCell(px + x - 1, py + y - 1)
                cells:add(cell)
            end
        end
    end
    return cells
end

function Board:getCellsByFunction(func)
    -- The function gets each cell as an argument and must return either true or false
    -- Returns a set
    local cells = Set:new()
    for x=1, C.board.width do
        for y=1, C.board.height do
            if func(self.cells[x][y]) then
                cells:add(self.cells[x][y])
            end
        end
    end
    return cells
end

function Board:getRandomCell(allowFilled, allowOwned)
    -- Looks for a random cell on the board.
    -- By default will only find an unfilled, unowned cell.
    -- This can be overridden.
    local cell = nil
    while not cell do
        local x, y = love.math.random(C.board.width), love.math.random(C.board.height)
        local foundCell = self.cells[x][y]
        cell = foundCell
        if foundCell.filled and not allowFilled then cell = nil end
        if foundCell.owner and not allowOwner then cell = nil end
    end
    return cell
end

function Board:isCellFilled(x, y)
    -- Returns:
    -- 1. Whether the cell is filled
    -- 2. Whether the cell is on the board
    if (x < 1 or x > C.board.width or y < 1 or y > C.board.height) then return false, false end
    return self.cells[x][y].filled, true
end

function Board:releaseAllCells(actor)
    -- Releases all cells that belong to a given actor.
    -- This is somewhat thorough, so if your actor keeps track of its cells,
    -- do this yourself instead.
    for x=1, C.board.width do
        for y=1, C.board.height do
            self.cells[x][y]:release(actor)
        end
    end
end

function Board:addActor(actor)
    self.actors:add(actor)
end

function Board:removeActor(actor)
    if Player:isActor(actor) then
        for x=1, C.board.width do
            for y=1, C.board.height do
                self.cells[x][y]:preserve()
            end
        end
        Game:gameOver()
    end
    actor:hook_cleanup()
    self.actors:remove(actor)
end

function Board:addPoint()
    self.score = self.score + 1
end