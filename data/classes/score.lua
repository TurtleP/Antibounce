local Object = require("libraries.classic")
local Score = Object:extend()

function Score:new(x, y, width)
    self.x = x
    self.y = y

    self.width = 108

    self.value = 0
    self.combo = 0

    self.comboTimeout = 6
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

    love.graphics.setColor(utility.Hex2Color("#00330066"))
    love.graphics.rectangle("fill", self.x - 2, self.y - 2, self.width + 4, scoreFont:getHeight() + 4)

    local y = (self.y - 2) + ((scoreFont:getHeight() + 4) - scoreFont:getHeight()) / 2 + 2

    love.graphics.setColor(utility.Hex2Color("#003300"))
    love.graphics.print(self.value, self.x + (self.width - scoreFont:getWidth(self.value)) / 2 - 1, y - 1)

    love.graphics.setColor(utility.Hex2Color("#2e7d32"))
    love.graphics.print(self.value, self.x + (self.width - scoreFont:getWidth(self.value)) / 2, y)

    love.graphics.setColor(utility.Hex2Color("#003300"))
    love.graphics.rectangle("fill", self.x, self.y + scoreFont:getHeight() + 12, (self.comboTimeoutTimer / self.comboTimeout) * self.width, 2)
end

function Score:add(amount)
    self.combo = math.min(self.combo + 1, 4)
    local add = amount

    if self.combo > 1 then
        add = self.combo * amount
    end

    self.value = self.value + add
end

function Score:getCombo()
    return self.combo
end

return Score
