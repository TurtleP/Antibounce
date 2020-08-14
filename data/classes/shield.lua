local Entity = require("data.classes.entity")
local Shield = Entity:extend()

Shield.graphic = love.graphics.newImage("graphics/shield.png")

function Shield:new(x, y)
    Shield.super.new(self, x, y, 8, 8)

    self.timer = 0
end

function Shield:update(dt)
    self.timer = self.timer + 4 * dt
    if self.timer > 32 then
        self.flags.remove = true
    end
end

function Shield:draw()
    love.graphics.setColor(colors:get("LightGreen"))
    love.graphics.draw(Shield.graphic, self.x, self.y)
end

function Shield:floorCollide(entity, name)
    if name == "tile" then
        self.speed.y = -self.speed.y * 0.55
        return true
    end
end

function Shield:collect()
    self.flags.remove = true
    audio:play("Shield")
end

function Shield:gravity()
    return 640
end

function Shield:__tostring()
    return "shield"
end

return Shield
