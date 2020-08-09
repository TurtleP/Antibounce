local Entity = require("data.classes.entity")
local Rocket = Entity:extend()

local Explosion = require("data.classes.explosion")

Rocket.graphic = love.graphics.newImage("graphics/rocket.png")

function Rocket:new(x, y)
    Rocket.super.new(self, x, y, 5, 6)

    self.angle = 0
    self.spinFactor = math.pi / 45

    self.timer = 0
    self.lifeTime = love.math.random(3, 6)

    self.moveSpeed = 320

    self.particleColors =
    {
        {1, 0, 0},
        {1, 1, 1},
        {0, 0, 0}
    }
end

function Rocket:update(dt)
    local target = physics:getEntity("player")
    local spinFactor = math.pi / 8

    local speedAngle = math.atan2(self.speed.y, self.speed.x)
    local targetAngle = math.atan2((target.y + (target.height / 2)) - self.y, target.x - self.x)

    if speedAngle < targetAngle and targetAngle - speedAngle > math.pi then
        spinFactor = spinFactor * -1
    elseif speedAngle > targetAngle and speedAngle - targetAngle <= math.pi then
        spinFactor = spinFactor * -1
    end

    speedAngle = speedAngle + spinFactor
    if speedAngle < 0 then
        speedAngle = speedAngle + math.pi * 2
    elseif speedAngle >= math.pi * 2 then
        speedAngle = speedAngle - math.pi * 2
    end

    self.speed.x = self.moveSpeed * math.cos(speedAngle)
    self.speed.y = self.moveSpeed * math.sin(speedAngle)

    self.timer = self.timer + dt
    if self.timer > self.lifeTime then
        self.flags.remove = true
    end

    -- rocket's angle isn't at 0
    self.angle = targetAngle + math.pi / 2
end

function Rocket:draw()
    love.graphics.draw(Rocket.graphic, self.x, self.y, self.angle, 1, 1, self.width, self.height)
end

function Rocket:collect()
    audio:play("Rocket")
    state:call("spawnParticles", self, self.particleColors[love.math.random(#self.particleColors)])

    tiled:addEntity(Explosion(self.x, self.y))

    self.flags.remove = true
end

function Rocket:filter()
    return function(entity, other)
        return false
    end
end

function Rocket:gravity()
    return 0
end

function Rocket:passive()
    return true
end

function Rocket:__tostring()
    return "rocket"
end

return Rocket
