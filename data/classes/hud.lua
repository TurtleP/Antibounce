local Object = require("libraries.classic")
local HUD = Object:extend()

HUD.graphic = love.graphics.newImage("graphics/heart.png")
HUD.quads = {}
for i = 1, 4 do
    HUD.quads[i] = love.graphics.newQuad((i - 1) * 32, 0, 32, 30, HUD.graphic)
end

function HUD:new(x, y)
    self.x = x
    self.y = y

    self.colors =
    {
        colors:get("DarkGreen"),
        colors:get("LightGreen"),
        colors:get("LightestGreen")
    }
end

function HUD:draw(player)
    love.graphics.setColor(1, 1, 1)

    for i = 1, player:heartCount() do
        local shouldFill = false

        if i <= player:health() then
            shouldFill = true
        end

        self:drawHeart(shouldFill, self.x + (i - 1) * 36, self.y)
    end
end

function HUD:drawHeart(fill, x, y)
    if not fill then
        love.graphics.setColor(self.colors[1])
        love.graphics.draw(HUD.graphic, HUD.quads[4], x, y)
        return
    end

    love.graphics.setColor(self.colors[1])
    love.graphics.draw(HUD.graphic, HUD.quads[1], x, y)

    love.graphics.setColor(self.colors[2])
    love.graphics.draw(HUD.graphic, HUD.quads[2], x, y)

    love.graphics.setColor(self.colors[3])
    love.graphics.draw(HUD.graphic, HUD.quads[3], x, y)
end

return HUD
