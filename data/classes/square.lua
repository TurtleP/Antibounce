local Object = require("libraries.classic")
local Square = Object:extend()

Square.COLORS =
{
    "#2e7d32AA",
    "#60ad5eAA",
    "#005005AA"
}

function Square:new(x, y)
    self.x = x
    self.y = y

    self.width = love.math.random(28, 34)
    self.height = self.width

    self.color = Square.COLORS[love.math.random(#Square.COLORS)]
    self.speed = love.math.random(120, 240)
end

function Square:update(dt)
    self.x = self.x - self.speed * dt

    if self.x + self.width < -self.width then
        self.x = love.graphics.getWidth() + self.width
    end
end

function Square:draw()
    love.graphics.setColor(utility.Hex2Color(self.color))
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    love.graphics.setColor(1, 1, 1, 1)
end

return Square
