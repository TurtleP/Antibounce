local Entity = require("data.classes.entity")
local Coin   = Entity:extend()

Coin.graphic = love.graphics.newImage("graphics/coin.png")

Coin.quads = {}
for i = 1, 2 do
    Coin.quads[i] = love.graphics.newQuad((i - 1) * 16, 0, 16, 16, Coin.graphic)
end

function Coin:new(x, y, isBad)
    Coin.super.new(self, x, y, 16, 16)

    self.flags.bad = isBad

    local colors =
    {
        utility.Hex2Color("#fdd835"),
        utility.Hex2Color("#fbc02d")
    }

    if isBad then
        colors =
        {
            utility.Hex2Color("#f4511e"),
            utility.Hex2Color("#e64a19")
        }
    end

    self.colors = colors

    self.timer = 0
    self.maxTime = 10
end

function Coin:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.maxTime then
        self.flags.remove = true
    end
end

function Coin:draw()
    self.colors[1][4] = 1 - math.min(self.timer / self.maxTime, 1)
    self.colors[2][4] = 1 - math.min(self.timer / self.maxTime, 1)

    love.graphics.setColor(self.colors[1])
    love.graphics.draw(Coin.graphic, Coin.quads[1], self.x, self.y)

    love.graphics.setColor(self.colors[2])
    love.graphics.draw(Coin.graphic, Coin.quads[2], self.x, self.y)

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
