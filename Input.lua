require("Object")

Input = Object:new()

Input.buttons = Set:new()
Input.touches = {}

function Input:registerButton(button)
    self.buttons:add(button)
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

function love.touchpressed(id, x, y, pressure)
    Input.touches[id] = {x, y}
    for k, v in pairs(Input.buttons:items()) do
        if v:isHit(x, y) then
            v:hook_press(x - v.x - v.width / 2, y - v.y - v.height / 2)
        end
    end
end

function love.touchreleased(id, x, y, pressure)
    Input.touches[id] = nil
    for k, v in pairs(Input.buttons:items()) do
        if v:isHit(x, y) then
            v:hook_release(x - v.x - v.width / 2, y - v.y - v.height / 2)
        end
    end
end

function love.touchmoved(id, x, y, pressure)
    if not Input.touches[id] then return end
    local oldX, oldY = Input.touches[id][1], Input.touches[id][2]
    for k, v in pairs(Input.buttons:items()) do
        local hitThen = v:isHit(oldX, oldY)
        local hitNow = v:isHit(x, y)
        if hitThen and not hitNow then
            v:hook_moveOff()
        elseif hitNow and not hitThen then
            v:hook_moveOn()
        end
        if hitNow then
            v:hook_move(x - v.x - v.width / 2, y - v.y - v.height / 2)
        end
    end
end