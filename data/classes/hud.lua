local Object = require("libraries.classic")
local HUD = Object:extend()

HUD.graphic = love.graphics.newImage("graphics/heart.png")
HUD.quads = {}
for i = 1, 4 do
    HUD.quads[i] = love.graphics.newQuad((i - 1) * 31, 0, 31, 32, HUD.graphic)
end

function HUD:new(x, y)
    self.x = x
    self.y = y
end

function HUD:draw(player)
    love.graphics.setColor(1, 1, 1)

    for i = 1, player:heartCount() do
        local index = nil

        if i <= player:health() then
            if not player:hasShield() then
                index = 2
            else
                index = 4
            end
        else
            index = 3
        end

        love.graphics.draw(HUD.graphic, HUD.quads[index], self.x + (i - 1) * 36, self.y)
        love.graphics.draw(HUD.graphic, HUD.quads[1], self.x + (i - 1) * 36, self.y)
    end
end

return HUD
