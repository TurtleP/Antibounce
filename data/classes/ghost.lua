local Entity = require("data.classes.entity")
local Ghost  = Entity:extend()

local CONST_PLAYER_RADIUS = 16

function Ghost:new(x, y, hasShield)
    Ghost.super.new(self, x, y, 32, 32)

    self.flags.shield = hasShield

    self.timer = 0
    self.maxTime = 0.25
end

function Ghost:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.maxTime then
        self.flags.remove = true
    end
end

function Ghost:draw()
    local color = utility.Hex2Color("#2e7d32FF")
    if self.flags.shield then
        color = utility.Hex2Color("#1e88e5FF")
    end

    color[4] = 1 - (self.timer / self.maxTime)
    love.graphics.setColor(color)

    love.graphics.circle("fill", self.x + CONST_PLAYER_RADIUS, self.y + CONST_PLAYER_RADIUS, CONST_PLAYER_RADIUS)

    love.graphics.setColor(1, 1, 1)
end

function Ghost:passive()
    return true
end

function Ghost:static()
    return true
end

function Ghost:__tostring()
    return "ghost"
end

return Ghost
