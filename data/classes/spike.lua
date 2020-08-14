local tween = require("libraries.tween")

local Vector = require("libraries.vector")

local Entity = require("data.classes.entity")
local Spike = Entity:extend()

Spike.graphic = love.graphics.newImage("graphics/spike.png")

Spike.quads = {}
local directions = {"up", "down", "left", "right"}

for y = 1, 2 do
    Spike.quads[y] = {}
    for i = 1, 4 do
        Spike.quads[y][directions[i]] = love.graphics.newQuad((i - 1) * 16, (y - 1) * 16, 16, 16, Spike.graphic)
    end
end

local CONST_SPAWN_LERP = 0.25
local CONST_LERP_TYPE = "inOutQuad"

function Spike:new(x, y, direction)
    Spike.super.new(self, x, y, 16, 16)

    self.lerps =
    {
        up    = tween.new(CONST_SPAWN_LERP, self, {y = y - self.height}, CONST_LERP_TYPE),
        down  = tween.new(CONST_SPAWN_LERP, self, {y = y + self.height}, CONST_LERP_TYPE),
        left  = tween.new(CONST_SPAWN_LERP, self, {x = x - self.width}, CONST_LERP_TYPE),
        right = tween.new(CONST_SPAWN_LERP, self, {x = x + self.width}, CONST_LERP_TYPE)
    }


    local addx = 0
    if direction == "left" then
        addx = -self.width
    elseif direction == "right" then
        addx = self.width
    end

    local addy = 0
    if direction == "up" then
        addy = -self.height
    elseif direction == "down" then
        addy = self.height
    end

    self.scissorOffset = Vector(self.x + addx, self.y + addy)

    self.direction = direction

    self.lifeTime = love.math.random(4, 8)
    self.lifeTimer = 0

    self.init = false
end

function Spike:update(dt)
    local finished = false
    if not self.init then
        finished = self.lerps[self.direction]:update(dt)
    end

    if finished and not self.init then
        self.init = true
    end

    if self.init then
        self.lifeTimer = self.lifeTimer + dt

        if self.lifeTimer > self.lifeTime then
            self.lerps[self.direction]:reverse(dt)

            if self.lerps[self.direction]:getClock() == 0 then
                self:setRemove(true)
            end
        end
    end
end

function Spike:draw()
    love.graphics.setScissor(self.scissorOffset.x, self.scissorOffset.y, self.width, self.height)

    love.graphics.setColor(colors:get("DarkGreen"))
    love.graphics.draw(Spike.graphic, Spike.quads[1][self.direction], self.x, self.y)

    love.graphics.setColor(colors:get("LightGreen"))
    love.graphics.draw(Spike.graphic, Spike.quads[2][self.direction], self.x, self.y)

    love.graphics.setScissor()
end

function Spike:depth()
    return 0
end

function Spike:gravity()
    return 0
end

function Spike:facing(dir)
    return self.direction == dir
end

function Spike:filter()
    return function(entity, other)
        if other:passive() or other:is("tile") then
            return false
        end

        return "slide"
    end
end

function Spike:__tostring()
    return "spike"
end

function Spike:static()
    return false
end

return Spike
