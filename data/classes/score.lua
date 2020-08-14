local Object = require("libraries.classic")
local Score = Object:extend()

function Score:new(x, y, default)
    self.x = x
    self.y = y

    self.width = 108

    local value = default or 0

    self.value = value

    self.combo = 0

    self.comboTimeout = 8
    self.comboTimeoutTimer = 0
end

function Score:update(dt)
    if self.combo == 0 then
        return
    end

    self.comboTimeoutTimer = self.comboTimeoutTimer + dt

    if self.comboTimeoutTimer > self.comboTimeout then
        self.comboTimeoutTimer = 0
        self.combo = 0
        state:call("updateDifficulty")
    end
end

function Score:draw()
    love.graphics.setFont(scoreFont)

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.x - 2, self.y - 2, self.width + 4, scoreFont:getHeight() + 4)

    local y = (self.y - 3) + ((scoreFont:getHeight() + 4) - scoreFont:getHeight()) / 2 + 2

    love.graphics.setColor(colors:get("DarkGreen"))
    love.graphics.print(self.value, self.x + (self.width - scoreFont:getWidth(self.value)) / 2 - 1, y - 1)

    love.graphics.setColor(colors:get("LightGreen"))
    love.graphics.print(self.value, self.x + (self.width - scoreFont:getWidth(self.value)) / 2, y)

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.x - 1, self.y + scoreFont:getHeight() + 11, (self.comboTimeoutTimer / self.comboTimeout) * self.width, 4)

    love.graphics.setColor(colors:get("LightGreen"))
    love.graphics.rectangle("fill", self.x, self.y + scoreFont:getHeight() + 12, (self.comboTimeoutTimer / self.comboTimeout) * self.width, 4)
end

function Score:add(amount)
    self.combo = self.combo + 1
    local add = amount

    if self.combo > 1 then
        add = self.combo * amount
    end

    self.comboTimeoutTimer = 0
    self.value = math.min(self.value + add, 9999)
end

function Score:getValue()
    return self.value
end

function Score:getCombo()
    return self.combo
end

return Score
