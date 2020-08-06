local Entity = require("data.classes.entity")
local CoinZone = Entity:extend()

local Coin = require("data.classes.coin")

function CoinZone:new(x, y, width, height)
    CoinZone.super.new(self, x, y, width, height)
end

function CoinZone:draw()
end

function CoinZone:spawnCoin()
    local x = love.math.random(self.x, self.x + self.width - 16)
    local y = love.math.random(self.y, self.y + self.height - 16)

    tiled:addEntity(Coin(x, y, love.math.random() <= 0.5))
end

function CoinZone:static()
    return true
end

function CoinZone:passive()
    return true
end

function CoinZone:__tostring()
    return "coinzone"
end

return CoinZone
