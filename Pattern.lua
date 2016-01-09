require("Object")

Pattern = Object:extend()

function Pattern:construct(shape)
    self.shape = table.clone(shape)
end

function Pattern:addCell(x, y)
    self.shape[y][x] = true
end

function Pattern:removeCell(x, y)
    self.shape[y][x] = false
end

function Pattern:width()
    return #self.shape[1]
end

function Pattern:height()
    return #self.shape
end

function Pattern:valueAt(x, y)
    return self.shape[y][x]
end

function Pattern:rotateRight()
    self:flipDiagonally()
    self:flipHorizontally()
end

function Pattern:rotateLeft()
    self:flipHorizontally()
    self:flipDiagonally()
end

function Pattern:flipHorizontally()
    for y=1, self:height() do
        for x=1, self:width() / 2 do
            local temp = self.shape[y][x]
            self.shape[y][x] = self.shape[y][self:width() - x + 1]
            self.shape[y][self:width() - x + 1] = temp
        end
    end
end

function Pattern:flipVertically()
    for x=1, self:width() do
        for y=1, self:height() / 2 do
            local temp = self.shape[y][x]
            self.shape[y][x] = self.shape[self:height() - y + 1][x]
            self.shape[self:height() - y + 1][x] = temp
        end
    end
end

function Pattern:flipDiagonally(reverse)
    -- By default, flips around the diagonal from the top left to the bottom right.
    -- Pass true to flip around the other diagonal.

    -- Currently, flipping by the reverse diagonal is done by reversing the
    -- pattern horizontally first. Is there a better way?
    if reverse then
        self:flipHorizontally()
    end

    local origWidth, origHeight = self:width(), self:height()
    local origMax = math.max(origWidth, origHeight)
    while self:width() > self:height() do
        self.shape[self:height() + 1] = {}
    end

    for y=1, origMax do
        for x=y+1, origMax do
            local temp = self.shape[x][y]
            self.shape[x][y] = self.shape[y][x]
            self.shape[y][x] = temp
        end
    end

    while self:height() > origWidth do
        self.shape[self:height()] = nil
    end

    if reverse then
        self:flipHorizontally()
    end
end