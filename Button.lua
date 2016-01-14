require("Object")

Button = Object:extend()

function Button:construct(image, x, y)
    self.image = image
    self.x = x
    self.y = y
end

function Button:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Button:size()
    return self.image:getWidth(), self.image:getHeight()
end

function Button:hook_click()
    -- Called when a user presses and releases the button without moving
    -- off it. This is called by the other hooks, and only works properly
    -- if they're not implemented. This hook is a simplified hook for when you
    -- don't need very specific behaviour for different ways to touch the
    -- button.
end

function Button:hook_press()
    -- Called when the button is clicked or touched directly
end

function Button:hook_release()
    -- Called when a user releases the button
end

function Button:hook_moveOn()
    -- Called when a click or touch moves onto the button
end

function Button:hook_moveOff()
    -- Called when a click or touch moves off the button
end

