local Entity = require("data.classes.entity")
local Particle = Entity:extend()

local CONST_PARTICLE_BOUNCE = 0.75

function Particle:new(x, y, shape, color, speeds)
    Particle.super.new(self, x, y, 6, 6)

    self.speed.x = speeds[1]
    self.speed.y = speeds[2]

    self.color = color
    self.shape = shape or "square"

    self.bounces = 0
    self.maxBounces = 4
end

function Particle:update(dt)
    if self.bounces >= self.maxBounces then
        self.flags.remove = true
    end
end

function Particle:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    love.graphics.setColor(1, 1, 1, 1)
end

function Particle:gravity()
    return 720
end

function Particle:filter()
    return function(entity, other)
        if not other:is("tile") then
            return false
        end
        return "slide"
    end
end

function Particle:countBounce()
    self.bounces = self.bounces + 1
    -- audio:play("Bounce")
end

function Particle:ceilCollide(_, name, _)
    if name == "tile" then
        self.speed.y = -self.speed.y * CONST_PARTICLE_BOUNCE
        self:countBounce()
        return true
    end
end

function Particle:floorCollide(_, name, _)
    if name == "tile" then
        self.speed.y = -self.speed.y * CONST_PARTICLE_BOUNCE
        self:countBounce()
        return true
    end
end

function Particle:rightCollide(_, name, _)
    if name == "tile" then
        self.speed.x = -self.speed.x * CONST_PARTICLE_BOUNCE
        self:countBounce()
        return true
    end
end

function Particle:leftCollide(_, name, _)
    if name == "tile" then
        self.speed.x = -self.speed.x * CONST_PARTICLE_BOUNCE
        self:countBounce()
        return true
    end
end

function Particle:__tostring()
    return "particle"
end

return Particle
