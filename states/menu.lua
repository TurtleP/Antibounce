local Menu = {}

local Score = require("data.classes.score")

local GAME_TITLE = "AntiBounce"
local Vector = require("libraries.vector")

function Menu:load(initFunc)
    physics:init(tiled:loadMap("menu"))

    self.player = physics:getEntity("player")
    self.beams = physics:getEntity("beam", true)

    self.arrow = love.graphics.newImage("graphics/arrow.png")

    if initFunc then
        initFunc()
    end

    self.highScoreDisplay = Score(19, 54, highScore)

    self.title = love.graphics.newImage("graphics/title.png")
    self.titlePos = Vector((love.graphics.getWidth() - self.title:getWidth()) / 2, love.graphics.getHeight() * 0.40)
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

    love.graphics.setColor(colors:get("DarkGreen"))
    love.graphics.draw(self.title, self.titlePos.x, self.titlePos.y + math.sin(love.timer.getTime() * 5) * 16)

    love.graphics.setColor(colors:get("DarkGreen"))
    love.graphics.draw(self.arrow, self.beams[1]:center().x - self.arrow:getWidth() / 2, self.beams[1].y - 48 + math.sin(love.timer.getTime() * 8) * 4)

    self.highScoreDisplay:draw()

    love.graphics.setColor(colors:get("LightGreen"))
    love.graphics.print("HI-SCORE", 11, 23)

    love.graphics.setColor(colors:get("DarkestGreen"))
    love.graphics.print("HI-SCORE", 12, 24)

    love.graphics.setColor(1, 1, 1, 1)
end

function Menu:gamepadaxis(joy, axis, value)
    value = tonumber(value)

    if axis == "leftx" then
        if value > 0.5 then
            self.player:moveRight(true)
        elseif value < -0.5 then
            self.player:moveLeft(true)
        else
            self.player:stop(true)
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
