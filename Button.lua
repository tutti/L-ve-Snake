require("Object")

Button = Object:extend()

function Button:construct(image, x, y)
    self.image = image
    self.x = x
    self.y = y
    self.width, self.height = self.image:getWidth(), self.image:getHeight()
    self.tolerance = 0
    self.shown = true

    self.isStillOnButton = false
end

function Button:setTolerance(tolerance)
    self.tolerance = tolerance
end

function Button:draw()
    if not self.shown then return end
    love.graphics.setColor(C.colour.white)
    love.graphics.draw(self.image, self.x, self.y)
end

function Button:size()
    return self.width, self.height
end

function Button:show()
    self.shown = true
end

function Button:hide()
    self.shown = false
end

function Button:isHit(x, y)
    return
        self.shown
        and x >= self.x - self.tolerance
        and x < self.x + self.width + self.tolerance
        and y >= self.y - self.tolerance
        and y < self.y + self.height + self.tolerance
end

function Button:hook_click(x, y)
    -- Called when a user presses and releases the button without moving
    -- off it. This is called by the other hooks, and only works properly
    -- if they're not implemented. This hook is a simplified hook for when you
    -- don't need very specific behaviour for different ways to touch the
    -- button.
end

function Button:hook_press(x, y)
    self.isStillOnButton = true
    -- Called when the button is clicked or touched directly
end

function Button:hook_release(x, y)
    if self.isStillOnButton then
        self:hook_click(x, y)
    end
    self.isStillOnButton = false
    -- Called when a user releases the button
end

function Button:hook_moveOn(x, y)
    self.isStillOnButton = false
    -- Called when a click or touch moves onto the button
end

function Button:hook_moveOff(x, y)
    self.isStillOnButton = false
    -- Called when a click or touch moves off the button
end

