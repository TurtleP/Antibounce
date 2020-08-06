local Game = {}

local HUD   = require("data.classes.hud")
local Score = require("data.classes.score")

local Coin = require("data.classes.coin")
local Shield = require("data.classes.shield")

local Particle = require("data.classes.particle")

Game.DEBUG =
{
    "OS: " .. love._os,
    "",
    "dpup: toggle this DEBUG info",
    "",
    "a: Toggle DEBUG Render",
    "b: Kill PLAYER",
    "y: Spawn COIN at PLAYER position",
    "x: Spawn ROCKET",
    "dpleft: Give PLAYER a SHIELD"
}

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

    self.debugString = table.concat(Game.DEBUG, "\n")
    self.showDebug = false

    self.difficultyModMin = 1
    self.difficultyMod = self.difficultyModMin

    self.paused = false

    self.shake = 0
    self.shakeIntensity = 0
end

function Game:update(dt)
    if self.paused then
        return
    end

    if self.shakeIntensity > 0 then
        self.shakeIntensity = self.shakeIntensity - 5 * dt
    end

    if self.difficultyMod > 0 then
        dt = dt * self.difficultyMod
    end

    tiled:update(dt)
    self.score:update(dt)

    if self.coin.timer < self.coin.maxTime then
        self.coin.timer = self.coin.timer + dt
    else
        local zones = physics:getEntity("coinzone", true)
        local currentZone = zones[love.math.random(#zones)]

        currentZone:spawnCoin()
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

    if not self.showDebug then
        return
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(self.debugString, 0, 128)
end

function Game:gamepadpressed(joy, button)
    if button == "b" then
        self.player:die()
    elseif button == "y" then
        local x, y = unpack(self.player:position())
        tiled:addEntity(Coin(x, y, love.math.random() <= 0.5))
    elseif button == "dpup" then
        self.showDebug = not self.showDebug
    elseif button == "dpleft" then
        local x, y = unpack(self.player:position())
        tiled:addEntity(Shield(x, y))
    end
end

function Game:gamepadaxis(joy, axis, value)
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

end

function Game:getName()
    return "State: Game"
end

return Game
