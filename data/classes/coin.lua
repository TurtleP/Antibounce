local Entity = require("data.classes.entity")
local Coin   = Entity:extend()

Coin.graphic = love.graphics.newImage("graphics/coin.png")

Coin.quads = {}
for y = 1, 2 do
    Coin.quads[y] = {}
    for i = 1, 2 do
        Coin.quads[y][i] = love.graphics.newQuad((i - 1) * 16, (y - 1) * 16, 16, 16, Coin.graphic)
    end
end

function Coin:new(x, y, isBad)
    Coin.super.new(self, x, y, 16, 16)

    self.quadi = 1
    if isBad then
        self.quadi = 2
    end

    self.flags.bad = isBad

    self.colors = colors
    self.particleColor = colors[1]

    self.timer = 0
    self.maxTime = 10

    self.colors = {colors:get("LightGreen"), colors:get("DarkGreen")}
    if isBad then
        self.colors = {colors:get("DarkGreen"), colors:get("LightGreen")}
    end
end

function Coin:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.maxTime then
        self.flags.remove = true
    end
end

function Coin:draw()
    love.graphics.setColor(self.colors[1])
    love.graphics.draw(Coin.graphic, Coin.quads[self.quadi][1], self.x, self.y)

    love.graphics.setColor(self.colors[2])
    love.graphics.draw(Coin.graphic, Coin.quads[self.quadi][2], self.x, self.y)

    love.graphics.setColor(1, 1, 1, 1)
end

function Coin:collect()
    local amount = 1
    local sound = "Coin"

    if self.flags.bad then
        amount = -1
        sound = "CoinBad"
    end

    audio:play(sound)
    state:call("spawnParticles", self, self.colors[1])

    state:call("addScore", amount)
    self.flags.remove = true
end

function Coin:bad()
    return self.flags.bad
end

function Coin:static()
    return true
end

function Coin:passive()
    return true
end

function Coin:__tostring()
    return "coin"
end

return Coin
