local Object = require("libraries.classic")
local HUD = Object:extend()

HUD.graphic = love.graphics.newImage("graphics/heart.png")
HUD.quads = {}
for i = 1, 3 do
    HUD.quads[i] = love.graphics.newQuad((i - 1) * 31, 0, 31, 32, HUD.graphic)
end

function HUD:new(x, y)
    self.x = x
    self.y = y
end

function HUD:draw(player)
    for i = 1, player:heartCount() do
        if i <= player:health() then
            love.graphics.draw(HUD.graphic, HUD.quads[2], self.x + (i - 1) * 36, self.y)
        else
            love.graphics.draw(HUD.graphic, HUD.quads[3], self.x + (i - 1) * 36, self.y)
        end

        love.graphics.draw(HUD.graphic, HUD.quads[1], self.x + (i - 1) * 36, self.y)
    end
end

return HUD
