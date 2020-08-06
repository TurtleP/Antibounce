local Menu = {}

local GAME_TITLE = "AntiBounce"

function Menu:load()
    physics:init(tiled:loadMap("menu"))

    self.player = physics:getEntity("player")
    self.beams = physics:getEntity("beam", true)
end

function Menu:update(dt)
    tiled:update(dt)

    for _, beam in pairs(self.beams) do
        if physics:checkCollision(self.player, beam) then
            beam:activate()
        end
        beam:update(dt)
    end
end

function Menu:draw()
    tiled:draw()

    love.graphics.setFont(titleFont)


    local TITLE_POS_X = (love.graphics.getWidth() - titleFont:getWidth(GAME_TITLE)) / 2
    local TITLE_POS_Y = (love.graphics.getHeight() * 0.40) + math.sin(love.timer.getTime() * 5) * 16

    love.graphics.setColor(utility.Hex2Color("#fafafa"))
    love.graphics.print(GAME_TITLE, TITLE_POS_X - 1, TITLE_POS_Y - 1)

    love.graphics.setColor(utility.Hex2Color("#00701a"))
    love.graphics.print(GAME_TITLE, TITLE_POS_X, TITLE_POS_Y)
end

function Menu:gamepadaxis(joy, axis, value)
    value = tonumber(value)

    if axis == "leftx" then
        if value > 0.5 then
            self.player:moveRight(true)
        elseif value < -0.5 then
            self.player:moveLeft(true)
        else
            self.player:stop()
        end
    end
end

function Menu:unload()
    self.player = nil
    self.beams = nil
end

function Menu:getName()
    return "State: Menu"
end

return Menu
