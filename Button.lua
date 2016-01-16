require("Object")
require("Input")

Button = Object:extend()

function Button:construct(image, x, y)
    self.image = image
    self.x = x
    self.y = y
    self.width, self.height = self.image:getWidth(), self.image:getHeight()
    self.tolerance = 0
    self.shown = true
    self.isStillOnButton = false

    Input:registerButton(self)
end

function Button:setTolerance(tolerance)
    -- A button's tolerance is how far outside of the button's area it will
    -- accept clicks.
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

-- Hook functions
-- Note: For all of these, the x and y values are relative to the center of the
-- button. A touch at the very center of the button will give x=y=0.

function Button:hook_click(x, y)
    -- Called when a user presses and releases the button without moving
    -- off it. This is called by the other hooks, and only works properly
    -- if they're not implemented. This hook is a simplified hook for when you
    -- don't need very specific behaviour for different ways to touch the
    -- button.
end

function Button:hook_press(x, y)
    -- Called when the button is clicked or touched directly.
    self.isStillOnButton = true
end

function Button:hook_release(x, y)
    -- Called when a user releases the button.
    if self.hook_move ~= Button.hook_move
        or self.hook_moveOn ~= Button.hook_moveOn
        or self.hook_moveOff ~= Button.hook_moveOff
        or self.hook_press ~= Button.hook_press
    then
        -- The simplified click hook should only work if none of the other
        -- hooks have been implemented.
        return
    end
    if self.isStillOnButton then
        self:hook_click(x, y)
    end
    self.isStillOnButton = false
end

function Button:hook_move(x, y)
    -- Called when a click or touch moves around or onto the button.
end

function Button:hook_moveOn()
    -- Called when a click or touch moves onto the button.
    self.isStillOnButton = false
end

function Button:hook_moveOff()
    -- Called when a click or touch moves off the button.
    self.isStillOnButton = false
end

