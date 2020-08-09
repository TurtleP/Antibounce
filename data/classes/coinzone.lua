local Entity = require("data.classes.entity")
local CoinZone = Entity:extend()

local Coin = require("data.classes.coin")
local Shield = require("data.classes.shield")
local Heart = require("data.classes.heart")
local Rocket = require("data.classes.rocket")

function CoinZone:new(x, y, width, height)
    CoinZone.super.new(self, x, y, width, height)
end

function CoinZone:draw()
end

function CoinZone:generateCoords()
    local x = love.math.random(0, self.width - 16)
    local y = love.math.random(0, self.height - 16)

    return x, y
end

function CoinZone:spawnCoin()
    local x, y = self:generateCoords()
    local isBadCoin = love.math.random() <= 0.20

    tiled:addEntity(Coin(self.x + x, self.y + y, isBadCoin))
end

function CoinZone:spawnShield()
    if #physics:getEntity("shield") == 0 then
        local x, y = self:generateCoords()

        tiled:addEntity(Shield(self.x + x, self.y + y))

        return true
    end

    return false
end

function CoinZone:spawnRocket()
    if #physics:getEntity("rocket") == 0 then
        local x, y = self:generateCoords()

        tiled:addEntity(Rocket(self.x + x, self.y + y))

        return true
    end

    return false
end

function CoinZone:spawnHeart()
    if #physics:getEntity("heart") == 0 then
        local x, y = self:generateCoords()

        tiled:addEntity(Heart(self.x + x, self.y + y))

        return true
    end

    return false
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
