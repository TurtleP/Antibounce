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

    self.title = love.graphics.newImage("graphics/title.png")
    self.titlePos = Vector((love.graphics.getWidth() - self.title:getWidth()) / 2, love.graphics.getHeight() * 0.40)

    self.clearTimer = 0
    self.clearingFlag = false
    self.maxClear = 3

    self.shakeIntensity = 0
end

function Menu:clearHighscore()
    highScore = nil
    audio:play("Gravity")
    love.filesystem.remove("highscore")
    self.clearTimer = 0
    self.shakeIntensity = 0
end

function Menu:update(dt)
    if self.shakeIntensity > 0 and self.clearTimer == 0 then
        self.shakeIntensity = self.shakeIntensity - 5 * dt
    end

    tiled:update(dt)

    for _, beam in pairs(self.beams) do
        if physics:checkCollision(self.player, beam) then
            beam:activate()
        end
        beam:update(dt)
    end

    if self.clearingFlag then
        self.clearTimer = self.clearTimer + dt

        if self.clearTimer > self.maxClear then
            self:clearHighscore()
        else
            if math.floor(self.clearTimer % 3) == 0 then
                self.shakeIntensity = love.math.random(2, 4)
            end
        end
    end
end

function Menu:draw()
    if self.shakeIntensity > 0 and self.clearingFlag then
        local x, y = (love.math.random() * 2 - 1) * self.shakeIntensity,  (love.math.random() * 2 - 1) * self.shakeIntensity
        love.graphics.translate(x, y)
    end

    tiled:draw()

    love.graphics.setColor(colors:get("DarkGreen"))
    love.graphics.draw(self.title, self.titlePos.x, self.titlePos.y + math.sin(love.timer.getTime() * 5) * 16)

    love.graphics.draw(self.arrow, self.beams[1]:center().x - self.arrow:getWidth() / 2, self.beams[1].y - 48 + math.sin(love.timer.getTime() * 8) * 4)

    love.graphics.setFont(mainFont)
    love.graphics.setColor(colors:get("DarkGreen"))

    if highScore then
        love.graphics.print("HI-SCORE", (love.graphics.getWidth() - mainFont:getWidth("HI-SCORE")) / 2, 28)
        love.graphics.print(highScore, (love.graphics.getWidth() - mainFont:getWidth(highScore)) / 2, 64)
    end

    if self.clearingFlag then
        love.graphics.setColor(0, 0, 0, math.min(self.clearTimer / self.maxClear, 1))
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end

    love.graphics.setColor(1, 1, 1, 1)
end

function Menu:gamepadpressed(joy, button)
    if button == "start" and highScore then
        self.clearingFlag = true
    end
end

function Menu:gamepadreleased(joy, button)
    if button == "start" then
        self.clearingFlag = false
        self.clearTimer = 0
    end
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
