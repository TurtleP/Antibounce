local Tile = require("data.classes.tile")
local SpikeWall = Tile:extend()

function SpikeWall:new(x, y, width, height, directions)
    SpikeWall.super.new(self, x, y, width, height)

    self.spikes = {}

    self.timer = 0
    self.maxTime = love.math.random(3, 12)

    self.directions = directions
end

function SpikeWall:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.maxTime then
        self:newSpike()
        self.timer = 0
    end
end

function SpikeWall:draw()
end

function SpikeWall:newSpike()
    local properties = self.directions:split(";")
    local direction = properties[love.math.random(#properties)]

    local x, y = self.x, self.y
    if direction == "left" or direction == "right" then
        y = love.math.random(self.y, self.y + (self.height - 16))
        if direction == "right" then
            x = x + self.width / 2
        end
    elseif direction == "up" or direction == "down" then
        x = love.math.random(self.x, self.x + (self.width - 16))
        if direction == "down" then
            y = y + self.height - 16
        end
    end

    tiled:spawnEntity("spike", {x = x, y = y, dir = direction})
end

return SpikeWall
