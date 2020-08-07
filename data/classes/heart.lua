local Entity = require("data.classes.entity")
local Heart = Entity:extend()

Heart.graphic = love.graphics.newImage("graphics/health.png")

function Heart:new(x, y)
    Heart.super.new(self, x, y, 16, 16)

    self.flags.float = true
    self.timer = 0
end

function Heart:update(dt)
    self.timer = self.timer + 4 * dt
    if self.timer > 24 then
        self.flags.remove = true
    end
end

function Heart:draw()
    if self.timer > 8 and math.floor(self.timer % 2) == 0 then
        return
    end

    local addx, addy = math.cos(love.timer.getTime() * 2) * 6, math.abs(math.sin(love.timer.getTime() * 2) * 4)
    if not self.flags.float then
        addx, addy = 0, 0
    end

    love.graphics.draw(Heart.graphic, self.x + addx, self.y + addy)
end

function Heart:collect()
    audio:play("Heart")
    self.flags.remove = true
end

function Heart:gravity()
    return 10
end

function Heart:floorCollide(entity, name)
    if name == "tile" then
        self.flags.float = false
    end
end

function Heart:passive()
    return true
end

function Heart:__tostring()
    return "heart"
end

return Heart
