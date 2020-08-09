local Entity = require("data.classes.entity")
local Explosion = Entity:extend()

Explosion.graphic = love.graphics.newImage("graphics/explosion.png")
Explosion.quads   = {}
for i = 1, 6 do
    Explosion.quads[i] = love.graphics.newQuad((i - 1) * 32, 0, 32, 32, Explosion.graphic)
end

function Explosion:new(x, y)
    Explosion.super.new(self, x, y, 32, 32)

    self.timer = 0
    self.quadi = 1
end

function Explosion:update(dt)
    self.timer = self.timer + 8 * dt

    self.quadi = math.floor(self.timer % #Explosion.quads) + 1
    if self.quadi == #Explosion.quads then
        self.flags.remove = true
    end
end

function Explosion:draw()
    love.graphics.draw(Explosion.graphic, Explosion.quads[self.quadi], self.x, self.y)
end

function Explosion:passive()
    return true
end

function Explosion:static()
    return true
end

return Explosion
