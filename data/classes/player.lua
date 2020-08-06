local Entity = require("data.classes.entity")
local Player = Entity:extend()

local CONST_PLAYER_RADIUS = 16
local CONST_PLAYER_BOUNCE = 640
local CONST_PLAYER_MAX_SPEED = 320

function Player:new(x, y)
    Player.super.new(self, x, y, 32, 32)

    self.maxHearts = 3
    self.hearts = self.maxHearts

    self.flags.invincible = false
    self.invincibleTimer = 0
end

function Player:update(dt)
    if self.rightHeld then
        self.speed.x = math.min(self.speed.x + CONST_PLAYER_MAX_SPEED * dt, CONST_PLAYER_MAX_SPEED)
    elseif self.leftHeld then
        self.speed.x = math.max(self.speed.x - CONST_PLAYER_MAX_SPEED * dt, -CONST_PLAYER_MAX_SPEED)
    else
        if self.speed.x > 0 then
            self.speed.x = math.max(self.speed.x - CONST_PLAYER_MAX_SPEED * dt, 0)
        else
            self.speed.x = math.min(self.speed.x + CONST_PLAYER_MAX_SPEED * dt, 0)
        end
    end

    if self.flags.invincible then
        self.invincibleTimer = self.invincibleTimer + 24 * dt

        if self.invincibleTimer > 72 then
            self.flags.invincible = false
            self.invincibleTimer = 0
        end
    end
end

function Player:draw()
    if self.flags.invincible and math.floor(self.invincibleTimer % 4) == 0 then
        return
    end

    love.graphics.setColor(utility.Hex2Color("#2e7d32"))
    love.graphics.circle("fill", self.x + CONST_PLAYER_RADIUS, self.y + CONST_PLAYER_RADIUS, CONST_PLAYER_RADIUS)
    love.graphics.setColor(1, 1, 1)
end

function Player:gravity()
    return 1080
end

function Player:heartCount()
    return self.maxHearts
end

function Player:health()
    return self.hearts
end

function Player:addHealth(amount)
    if self.flags.invincible then
        return
    end

    self.hearts = math.min(self.hearts + amount, self.maxHearts)

    if amount < 0 then
        audio:play("Dead")

        if self.hearts > 0 then
            self.flags.invincible = true
        end
    end

    if self.hearts <= 0 then
        self.flags.remove = true
    end
end

function Player:filter()
    return function(entity, other)
        if other:passive() then
            return false
        end
        return "slide"
    end
end

function Player:floorCollide(entity, name, type)
    if name == "tile" or name == "spike" then
        self.speed.y = -CONST_PLAYER_BOUNCE
        audio:play("Jump")

        if name == "spike" and entity:facing("up") then
            self:addHealth(-1)
        end

        return true
    end
end

function Player:leftCollide(entity, name, type)
    if name == "tile" or name == "spike" then
        self.speed.x = -self.speed.x
        audio:play("Jump")

        if name == "spike" and entity:facing("right") then
            self:addHealth(-1)
        end

        return true
    end
end

function Player:rightCollide(entity, name)
    if name == "tile" or name == "spike" then
        self.speed.x = -self.speed.x
        audio:play("Jump")

        if name == "spike" and entity:facing("left") then
            self:addHealth(-1)
        end

        return true
    end
end

function Player:ceilCollide(entity, name)
    if name == "tile" or name == "spike" then
        self.speed.y = CONST_PLAYER_BOUNCE
        audio:play("Jump")

        if name == "spike" and entity:facing("down") then
            self:addHealth(-1)
        end

        return true
    end
end

function Player:moveRight(held)
    self.leftHeld = false
    self.rightHeld = held
end

function Player:moveLeft(held)
    self.rightHeld = false
    self.leftHeld = held
end

function Player:stop()
    self.leftHeld = false
    self.rightHeld = false
end

function Player:__tostring()
    return "player"
end

return Player