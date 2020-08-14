local Game = {}

local HUD   = require("data.classes.hud")
local Score = require("data.classes.score")

local Particle = require("data.classes.particle")

Game.PausedText = "GAME PAUSED"
Game.OverText = "GAME OVER"

function Game:load()
    physics:init(tiled:loadMap("game"))
    self.player = physics:getEntity("player")

    self.display = HUD(12, 16)
    self.score   = Score(10, 64)

    self.coin =
    {
        timer = 0,
        maxTime = love.math.random(3, 4)
    }

    self.difficultyModMin = 1
    self.difficultyMod = self.difficultyModMin

    self.paused = false

    self.shake = 0
    self.shakeIntensity = 0

    self.gameover = false
    self.gameoverTimer = 0


    self.gravityTimer = 0
    self.gravityMaxTime = love.math.random(10, 16)
end

function Game:update(dt)
    if self.paused then
        return
    end

    self.gravityTimer = self.gravityTimer + dt
    if self.gravityTimer > self.gravityMaxTime then
        physics:flipGravity()
        self.gravityTimer = 0
    end

    if self.shakeIntensity > 0 then
        self.shakeIntensity = self.shakeIntensity - 5 * dt
    end

    if self.difficultyMod > 0 then
        dt = dt * self.difficultyMod
    end

    tiled:update(dt)

    if self.gameover then
        self.gameoverTimer = self.gameoverTimer + dt

        if self.gameoverTimer > 3 then
            state:switch("menu", function()
                self:saveHiScore()
            end)
        end
        return
    end

    self.score:update(dt)

    if self.coin.timer < self.coin.maxTime then
        self.coin.timer = self.coin.timer + dt
    else
        local zones = physics:getEntity("coinzone", true)
        local currentZone = zones[love.math.random(#zones)]

        local actions =
        {
            function()
                local random = love.math.random()

                if random < 0.15 then
                    if self.player:health() < self.player:heartCount() then
                        return currentZone:spawnHeart()
                    end
                end

                return false
            end,

            function()
                local random = love.math.random()

                if random < 0.05 then
                    return currentZone:spawnShield()
                end

                return false
            end,

            function()
                local random = love.math.random()

                if random < 0.10 then
                    return currentZone:spawnRocket()
                end

                return false
            end
        }

        local index = love.math.random(#actions)
        local zoneAction = actions[index]

        if not zoneAction() then
            currentZone:spawnCoin()
        end

        self.coin.timer = 0
        self.coin.maxTime = love.math.random(3, 4)
    end
end

function Game:draw()
    if self.shakeIntensity > 0 then
        local x, y = (love.math.random() * 2 - 1) * self.shakeIntensity,  (love.math.random() * 2 - 1) * self.shakeIntensity
        love.graphics.translate(x, y)
    end

    tiled:draw()

    self.display:draw(self.player)
    self.score:draw()

    if self.showDebug then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(self.debugString, 0, 128)
    end

    if self.paused or self.gameover then
        love.graphics.setColor(utility.Hex2Color("#212121AA"))
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setFont(titleFont)
        love.graphics.setColor(utility.Hex2Color("#00701a"))

        local text = Game.PausedText
        if self.gameover then
            text = Game.OverText
        end
        love.graphics.print(text, (love.graphics.getWidth() - titleFont:getWidth(text)) / 2, (love.graphics.getHeight() * 0.4) + math.sin(love.timer.getTime() * 4) * 6)
    end
end

function Game:gamepadpressed(joy, button)
    if button == "start" then
        self.paused = not self.paused

        if self.paused then
            audio:play("Pause")
        end

        return
    elseif button == "leftshoulder" or button == "rightshoulder" then
        self.player:setDashing(true)
    end
end

function Game:gamepadaxis(joy, axis, value)
    if self.paused then
        return
    end

    value = tonumber(value)

    if self.player:dashing() then
        return
    end

    if axis == "leftx" then
        if value > 0.5 then
            self.player:moveRight(true)
        elseif value < -0.5 then
            self.player:moveLeft(true)
        else
            self.player:stop(true)
        end
    elseif axis == "lefty" then
        if value > 0.5 then
            self.player:moveDown(true)
        elseif value < -0.5 then
            self.player:moveUp(true)
        else
            self.player:stop()
        end
    end
end

function Game:gravity()
    if physics:flipped() then
        return -1
    end
    return 1
end

function Game:saveHiScore()
    if highscore and self.score:getValue() > highScore then
        highScore = self.score:getValue()
    end

    love.filesystem.write("highscore", msgpack.pack(highScore))
end

function Game:setGameover()
    self.gameover = true
    self.difficultyMod = 1
end

function Game:updateDifficulty()
    if self.score:getCombo() > 1 then
        self.difficultyMod =  math.min(self.difficultyModMin + self.score:getCombo() * 0.075 , 2)
        return
    end
    self.difficultyMod = self.difficultyModMin
end

function Game:spawnParticles(entity, color)
    tiled:addEntity(Particle(entity.x, entity.y, nil, color, {-100, -100}))
    tiled:addEntity(Particle(entity.x + entity.width, entity.y, nil, color, {100, -100}))
    tiled:addEntity(Particle(entity.x + entity.width, entity.y + entity.height, nil, color, {100, -50}))
    tiled:addEntity(Particle(entity.x, entity.y + entity.height, nil, color, {-100, -50}))
end

function Game:shakeScreen(amount)
    self.shakeIntensity = math.abs(amount)
end

function Game:addScore(amount)
    self.score:add(amount)
    self:updateDifficulty()
end

function Game:unload()
    self.hud = nil
    self.score = nil
    self.player = nil
end

function Game:getName()
    return "State: Game"
end

return Game
