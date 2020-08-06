local Entity = require("data.classes.entity")
local Shield = Entity:extend()

function Shield:new(x, y)
    Shield.super.new(self, x, y, 8, 8)

    self.blue = utility.Hex2Color("#1976d2")
    self.lightBlue = utility.Hex2Color("#1e88e5")

    self.colorTimer = 0

    self.currentColor = self.blue
    self.toColor = self.lightBlue
end

function Shield:update(dt)
    self.colorTimer = self.colorTimer + 4 * dt

    if self.colorTimer > 3 then
        local tmp = self.currentColor
        self.currentColor = self.toColor
        self.toColor = tmp

        self.colorTimer = 0
    end
end

function Shield:draw()
    local r, g, b = unpack(utility.ColorFade(self.colorTimer, 3, self.currentColor, self.toColor))
    love.graphics.setColor(r, g, b)

    love.graphics.circle("fill", self.x, self.y, self.width)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", self.x + 3, self.y - 2, 1)
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
