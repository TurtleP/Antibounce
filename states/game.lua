local Game = {}

local Spike = require("data.classes.spike")
local HUD   = require("data.classes.hud")

function Game:load()
    physics:init(tiled:loadMap("game"))
    self.player = physics:getEntity("player")

    self.testSpike = Spike(192, 704 - 8, "up")
    tiled:addEntity(self.testSpike)

    self.display = HUD(27, 32)
end

function Game:update(dt)
    tiled:update(dt)
end

function Game:draw()
    tiled:draw()

    self.display:draw(self.player)
end

function Game:gamepadaxis(joy, axis, value)
    value = tonumber(value)

    if axis == "leftx" then
        if value > 0.5 then
            self.player:moveRight(true)
        elseif value < -0.5 then
            self.player:moveLeft(true)
        else
            self.player:stop()
        end
    end
end

function Game:unload()

end

function Game:getName()
    return "State: Game"
end

return Game
