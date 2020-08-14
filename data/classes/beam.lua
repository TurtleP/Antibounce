local Entity = require("data.classes.entity")
local Beam = Entity:extend()

function Beam:new(x, y, func, text)
    Beam.super.new(self, x, y, 32 * 4, 32 * 4)

    self.maxWidth = self.width
    self.timer = 3

    self.dx = x

    self.active = false
    self.func = func

    self.text = text
end

function Beam:static()
    return true
end

function Beam:passive()
    return true
end

function Beam:update(dt)
    if not self.active then
        return
    end

    self.timer = math.max(self.timer - dt / 0.3, 0)

    self.dx = (self.x + self.width / 2) - (32 * self.timer) / 2
    self.maxWidth = 32 * self.timer

    if math.floor(self.maxWidth) == 0 then
        self.func()
    end
end

function Beam:draw()
    love.graphics.setFont(mainFont)
    love.graphics.setColor(colors:get("DarkGreen"))
    love.graphics.print(self.text:upper(), self.x + (self.width - mainFont:getWidth(self.text:upper())) / 2, self.y - 96)

    if not self.active then
        return
    end

    love.graphics.setColor(colors:get("LightGreen"))
    love.graphics.rectangle("fill", self.dx, 0, self.maxWidth, self.y)

    love.graphics.setColor(1, 1, 1, 1)
end

function Beam:activate()
    self.active = true
    audio:play("Selection")
end

function Beam:__tostring()
    return "beam"
end

return Beam
